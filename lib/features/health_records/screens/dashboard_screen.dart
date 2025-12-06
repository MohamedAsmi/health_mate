import 'package:flutter/material.dart';
import 'package:healthmate/features/health_records/common/custom_app_bar.dart';
import 'package:healthmate/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/health_provider.dart';
import 'health_records_screen.dart';
import 'add_edit_record_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("HealtMate", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.onPrimaryColor)),
        backgroundColor: AppTheme.primaryColorB,
        foregroundColor: AppTheme.onPrimaryColor,
        elevation: 2.0,
      ),
      body: Consumer<HealthProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final todaySummary = provider.todaySummary;
          final weeklySummary = provider.getWeeklySummary();
          final averages = provider.getAverageDaily();

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadRecords();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Today\'s Activities', Icons.today),
                  const SizedBox(height: 12),
                  _buildTodaySummaryCards(todaySummary),
                  const SizedBox(height: 24),

                  _buildSectionTitle('This Week', Icons.calendar_month),
                  const SizedBox(height: 12),
                  _buildWeeklySummaryCard(weeklySummary),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Daily Averages', Icons.bar_chart),
                  const SizedBox(height: 12),
                  _buildAveragesCard(averages),
                  const SizedBox(height: 24),

                  _buildQuickActions(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditRecordScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d, y');

    return Card(
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dateFormat.format(now),
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTodaySummaryCards(Map<String, int> summary) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Steps',
            summary['steps']!.toString(),
            Icons.directions_walk,
            Colors.green,
            '10,000 goal',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            'Calories',
            summary['calories']!.toString(),
            Icons.local_fire_department,
            Colors.orange,
            'kcal burned',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            'Water',
            '${(summary['water']! / 1000).toStringAsFixed(1)}L',
            Icons.water_drop,
            Colors.blue,
            '2.5L goal',
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummaryCard(Map<String, int> summary) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow(
              'Total Steps',
              summary['steps']!.toString(),
              Icons.directions_walk,
              Colors.green,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              'Total Calories',
              '${summary['calories']} kcal',
              Icons.local_fire_department,
              Colors.orange,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              'Total Water',
              '${(summary['water']! / 1000).toStringAsFixed(1)} L',
              Icons.water_drop,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAveragesCard(Map<String, double> averages) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow(
              'Avg Steps',
              averages['steps']!.toStringAsFixed(0),
              Icons.directions_walk,
              Colors.green,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              'Avg Calories',
              '${averages['calories']!.toStringAsFixed(0)} kcal',
              Icons.local_fire_department,
              Colors.orange,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              'Avg Water',
              '${(averages['water']! / 1000).toStringAsFixed(1)} L',
              Icons.water_drop,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Quick Actions', Icons.flash_on),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'View All Records',
                Icons.list,
                Colors.purple,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealthRecordsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                'Add New Entry',
                Icons.add_circle,
                Colors.green,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddEditRecordScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
