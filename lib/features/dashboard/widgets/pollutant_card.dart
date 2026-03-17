import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/pollutant_item.dart';

class PollutantCard extends StatelessWidget {
  final PollutantItem item;

  const PollutantCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = item.valueText != null && item.valueText!.trim().isNotEmpty;
    final safe = item.isSafe ?? true;

    final borderColor = !hasData
        ? const Color(0xFFE5E7EB)
        : safe
        ? const Color(0xFFBBF7D0)
        : const Color(0xFFFED7AA);

    final iconBackground = !hasData
        ? const Color(0xFFF3F4F6)
        : safe
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFFFEDD5);

    final accentColor = !hasData
        ? const Color(0xFF9CA3AF)
        : safe
        ? const Color(0xFF16A34A)
        : const Color(0xFFEA580C);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 2,
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
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 28,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground,
                      ),
                    ),
                    Text(
                      item.unit,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            hasData ? item.valueText! : '--',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: accentColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Text(
              item.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.mutedForeground,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}