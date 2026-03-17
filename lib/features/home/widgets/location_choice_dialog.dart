import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/services/air_quality_service.dart';
import 'location_list_dialog.dart';

class LocationChoiceDialog extends StatefulWidget {
  const LocationChoiceDialog({super.key});

  @override
  State<LocationChoiceDialog> createState() => _LocationChoiceDialogState();
}

class _LocationChoiceDialogState extends State<LocationChoiceDialog> {
  bool _isLoadingLiveLocation = false;

  String get _defaultLocation => AirQualityService.locationNames.first;

  void _goToDashboard(BuildContext context, String location) {
    Navigator.of(context).pop();
    Navigator.pushNamed(
      context,
      '/dashboard',
      arguments: location,
    );
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(',', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _buildPlacemarkText(Placemark placemark) {
    final parts = <String>[
      if ((placemark.locality ?? '').trim().isNotEmpty) placemark.locality!.trim(),
      if ((placemark.administrativeArea ?? '').trim().isNotEmpty)
        placemark.administrativeArea!.trim(),
      if ((placemark.country ?? '').trim().isNotEmpty) placemark.country!.trim(),
    ];

    return parts.join(', ');
  }

  String _matchToAvailableLocation(Placemark placemark) {
    final availableLocations = AirQualityService.locationNames;

    final candidates = <String>{
      _buildPlacemarkText(placemark),
      if ((placemark.locality ?? '').trim().isNotEmpty) placemark.locality!.trim(),
      if ((placemark.subAdministrativeArea ?? '').trim().isNotEmpty)
        placemark.subAdministrativeArea!.trim(),
      if ((placemark.administrativeArea ?? '').trim().isNotEmpty)
        placemark.administrativeArea!.trim(),
      if ((placemark.country ?? '').trim().isNotEmpty) placemark.country!.trim(),
    }.where((e) => e.isNotEmpty).toList();

    for (final candidate in candidates) {
      final normalizedCandidate = _normalize(candidate);

      // Exact match
      for (final location in availableLocations) {
        if (_normalize(location) == normalizedCandidate) {
          return location;
        }
      }

      // Partial match
      for (final location in availableLocations) {
        final normalizedLocation = _normalize(location);
        if (normalizedLocation.contains(normalizedCandidate) ||
            normalizedCandidate.contains(normalizedLocation)) {
          return location;
        }
      }
    }

    return _defaultLocation;
  }

  Future<String> _resolveLiveLocation() async {
    final fallback = _defaultLocation;

    try {
      if (!kIsWeb) {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return fallback;
        }

        LocationPermission permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return fallback;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return fallback;
      }

      final placemark = placemarks.first;
      return _matchToAvailableLocation(placemark);
    } catch (_) {
      return fallback;
    }
  }

  Future<void> _handleLiveLocation() async {
    if (_isLoadingLiveLocation) return;

    setState(() => _isLoadingLiveLocation = true);

    final selectedLocation = await _resolveLiveLocation();

    if (!mounted) return;

    setState(() => _isLoadingLiveLocation = false);
    _goToDashboard(context, selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.dialogRadius),
      ),
      child: Container(
        width: 700,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              AppStrings.chooseLocationTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.dialogTitle,
            ),
            const SizedBox(height: 12),
            const Text(
              AppStrings.chooseLocationDescription,
              textAlign: TextAlign.center,
              style: AppTextStyles.dialogBody,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoadingLiveLocation
                        ? null
                        : () async {
                      final selectedLocation = await showDialog<String>(
                        context: context,
                        builder: (_) => const LocationListDialog(),
                      );

                      if (selectedLocation != null && context.mounted) {
                        _goToDashboard(context, selectedLocation);
                      }
                    },
                    icon: const Icon(Icons.location_on_outlined, size: 30),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        AppStrings.manualLocation,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoadingLiveLocation ? null : _handleLiveLocation,
                    icon: _isLoadingLiveLocation
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.white,
                      ),
                    )
                        : const Icon(Icons.navigation_outlined, size: 30),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        _isLoadingLiveLocation
                            ? 'Detecting location...'
                            : AppStrings.liveLocation,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}