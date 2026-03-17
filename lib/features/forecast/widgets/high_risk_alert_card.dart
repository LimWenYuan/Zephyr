import 'package:flutter/material.dart';

class HighRiskAlertCard extends StatelessWidget {
  final String text;

  const HighRiskAlertCard({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFDBA74),
          width: 2,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.warning_amber_outlined,
              size: 28,
              color: Color(0xFFEA580C),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'High-risk forecast alert will appear here when AQI exceeds your threshold.',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFC2410C),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}