// packages/features/feature_dashboard/lib/src/domain/entities/saas_metric_entity.dart

class SaasMetricEntity {
  final String metricName;
  final double value;
  final double changePercentage;

  const SaasMetricEntity({
    required this.metricName,
    required this.value,
    required this.changePercentage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaasMetricEntity &&
          runtimeType == other.runtimeType &&
          metricName == other.metricName &&
          value == other.value &&
          changePercentage == other.changePercentage;

  @override
  int get hashCode =>
      metricName.hashCode ^ value.hashCode ^ changePercentage.hashCode;

  @override
  String toString() =>
      "SaasMetricEntity(name: $metricName, value: $value, change: $changePercentage%)";
}

