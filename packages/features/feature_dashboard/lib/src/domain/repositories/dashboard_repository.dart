// packages/features/feature_dashboard/lib/src/domain/repositories/dashboard_repository.dart

import "../entities/saas_metric_entity.dart";

abstract class DashboardRepository {
  Stream<List<SaasMetricEntity>> watchLiveMetrics();
}

