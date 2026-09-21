// packages/features/feature_dashboard/lib/src/presentation/screens/saas_dashboard_screen.dart

import "package:core_ui_kit/core_ui_kit.dart";
import "package:flutter/material.dart";
import "../../domain/entities/saas_metric_entity.dart";

class SaasDashboardScreen extends StatelessWidget {
  final List<SaasMetricEntity> metrics;

  const SaasDashboardScreen({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enterprise SaaS Dashboard")),
      body: ResponsiveLayout(
        mobile: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final item = metrics[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                title: Text(item.metricName),
                subtitle: Text("Growth: ${item.changePercentage}%"),
                trailing: Text("\\$${item.value.toStringAsFixed(2)}"),
              ),
            );
          },
        ),
        desktop: Row(
          children: [
            NavigationRail(
              selectedIndex: 0,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard),
                  label: Text("Dashboard"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.analytics),
                  label: Text("Analytics"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text("Settings"),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(24.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 2.0,
                ),
                itemCount: metrics.length,
                itemBuilder: (context, index) {
                  final item = metrics[index];
                  return Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.metricName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            "\\$${item.value.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            "+${item.changePercentage}% from last month",
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
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

