import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class LocationSelectorCard extends StatelessWidget {
  final String? selectedLocation;
  final List<String> locations;
  final ValueChanged<String?>? onChanged;

  const LocationSelectorCard({
    super.key,
    this.selectedLocation,
    this.locations = const [],
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = locations.isNotEmpty
        ? locations
        : const ['Kuala Lumpur City Centre'];

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 40,
                color: AppColors.primary,
              ),
              SizedBox(width: 12),
              Text(
                'Change Location',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFD1D5DB),
                width: 3,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: items.contains(selectedLocation) ? selectedLocation : items.first,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 24,
                  color: Color(0xFF4B5563),
                ),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
                items: items
                    .map(
                      (location) => DropdownMenuItem<String>(
                        value: location,
                        child: Text(location),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}