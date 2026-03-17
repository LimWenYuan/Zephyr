import 'package:flutter/material.dart';

class WarningSignsCard extends StatelessWidget {
  final List<String> symptoms;

  const WarningSignsCard({
    super.key,
    required this.symptoms,
  });

  @override
  Widget build(BuildContext context) {
    final leftItems = <String>[];
    final rightItems = <String>[];

    for (int i = 0; i < symptoms.length; i++) {
      if (i.isEven) {
        leftItems.add(symptoms[i]);
      } else {
        rightItems.add(symptoms[i]);
      }
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 48),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Color(0xFFFDBA74),
          width: 4,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 20),
            blurRadius: 25,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFEA580C),
              ),
              SizedBox(width: 24),
              Expanded(
                child: Text(
                  'Warning Signs to Watch For',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9A3412),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(left: 72),
            child: Text(
              'Seek medical attention immediately if you experience any of these symptoms:',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFFC2410C),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 72),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _SymptomsColumn(items: leftItems)),
                const SizedBox(width: 16),
                Expanded(child: _SymptomsColumn(items: rightItems)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SymptomsColumn extends StatelessWidget {
  final List<String> items;

  const _SymptomsColumn({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '•',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEA580C),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF9A3412),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}