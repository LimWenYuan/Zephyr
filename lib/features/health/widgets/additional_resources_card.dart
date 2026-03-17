import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';

class AdditionalResourcesCard extends StatelessWidget {
  const AdditionalResourcesCard({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
    );

    if (!launched) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 48),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0x33A8D5E2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Resources',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            children: [
              const Text(
                'Malaysian Department of Environment: ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.foreground,
                ),
              ),
              InkWell(
                onTap: () => _openUrl('https://www.doe.gov.my'),
                child: const Text(
                  'www.doe.gov.my',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            children: [
              const Text(
                'Ministry of Health Malaysia: ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.foreground,
                ),
              ),
              InkWell(
                onTap: () => _openUrl('https://www.moh.gov.my'),
                child: const Text(
                  'www.moh.gov.my',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Remember: This information is for general guidance only. Always consult with your healthcare provider for personalized medical advice.',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.mutedForeground,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}