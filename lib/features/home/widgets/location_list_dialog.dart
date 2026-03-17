import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/services/air_quality_service.dart';

class LocationListDialog extends StatelessWidget {
  const LocationListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final locations = AirQualityService.locationNames;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.dialogRadius),
      ),
      child: Container(
        width: 820,
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              AppStrings.locationListTitle,
              style: AppTextStyles.dialogTitle,
            ),
            const SizedBox(height: 8),
            const Text(
              AppStrings.locationListDescription,
              textAlign: TextAlign.center,
              style: AppTextStyles.dialogBody,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                itemCount: locations.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 72,
                ),
                itemBuilder: (context, index) {
                  final location = locations[index];

                  return OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, location);
                    },
                    icon: const Icon(Icons.location_on_outlined),
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        location,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.foreground,
                      side: const BorderSide(color: Color(0xFFD7D7D7)),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}