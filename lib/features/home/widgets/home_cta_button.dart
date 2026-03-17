import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

class HomeCtaButton extends StatefulWidget {
  final VoidCallback onPressed;

  const HomeCtaButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<HomeCtaButton> createState() => _HomeCtaButtonState();
}

class _HomeCtaButtonState extends State<HomeCtaButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _hovering ? 1.05 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _hovering
                ? const Color(0xFF42897B)
                : AppColors.primary,
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            boxShadow: _hovering
                ? const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 25,
                      offset: Offset(0, 12),
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              onTap: widget.onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.buttonHorizontalPadding,
                  vertical: AppSizes.buttonVerticalPadding,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.ctaButton,
                      style: AppTextStyles.ctaText,
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.arrow_downward,
                      size: 28,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}