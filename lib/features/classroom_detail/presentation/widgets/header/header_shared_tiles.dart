import 'package:flutter/material.dart';
import 'package:web_dashboard/common/widgets/custom_card.dart';

/// 헤더 패널 로딩 시 사용되는 플레이스홀더 타일.
class HeaderLoadingTile extends StatelessWidget {
  const HeaderLoadingTile({super.key, this.height = 100, this.width});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

/// 헤더 패널이 로딩에 실패했을 때 노출할 오류 타일.
class HeaderErrorTile extends StatelessWidget {
  const HeaderErrorTile({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Theme.of(context).colorScheme.errorContainer,
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}

/// 요약 카드에서 사용하는 간단한 라벨 칩.
class SummaryChip extends StatelessWidget {
  const SummaryChip({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

/// 환경 지표 출력에 재사용되는 타일.
class EnvironmentMetricTile extends StatelessWidget {
  const EnvironmentMetricTile({
    required this.label,
    required this.value,
    required this.unit,
    super.key,
  });

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.sensors, size: 18),
              const SizedBox(width: 8),
              Text(label, style: textTheme.labelLarge),
            ],
          ),
          Text(
            '$value$unit',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
