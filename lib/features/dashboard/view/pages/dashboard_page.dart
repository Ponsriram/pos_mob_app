import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/core/models/dashboard_models.dart';
import 'package:pos_app/features/ai_agent/view/pages/ai_chat_page.dart';
import '../../../../core/common/bottom_nav_bar.dart';
import '../../../../core/common/common_scaffold.dart';
import '../widgets/outlet_statistics_section.dart';
import '../widgets/stats_grid.dart';
import '../widgets/total_sales_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedOutlet = 'All Outlets';
  final List<String> _availableOutlets = const ['All Outlets'];
  int _currentNavIndex = 0;
  int _activeStatsTab = 0;
  DateTime _selectedDate = DateTime.now();
  static const _stats = DashboardStats.empty;
  static const List<OutletStats> _outletStats = [];
  static const List<StoreModel> _stores = [];
  static const List<String> _statsTabLabels = ['Sales', 'Orders', 'Net Sales'];
  static const List<String> _tabHeaders = ['Amount', 'Orders', 'Net Sales'];

  String get _formattedDate => DateFormat('dd MMM yyyy').format(_selectedDate);
  String get _activeTabColumnHeader => _tabHeaders[_activeStatsTab];

  String _getOutletValue(OutletStats outlet) {
    switch (_activeStatsTab) {
      case 1:
        return outlet.totalOrders.toString();
      case 2:
        return outlet.netSales.toStringAsFixed(2);
      default:
        return outlet.totalSales.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      activeItemId: 'dashboard',
      selectedOutlet: _selectedOutlet,
      availableOutlets: _availableOutlets,
      onOutletSelected: (outlet) => setState(() => _selectedOutlet = outlet),
      onLightBulbTap: () {},
      body: _currentNavIndex == 1
          ? const AiChatPage()
          : _buildBody(context),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            TotalSalesCard(
              totalSales: _stats.totalSales.toStringAsFixed(2),
              totalOutlets: _stores.length,
              totalOrders: _stats.totalOrders,
              onChartTap: () {},
              onMoreTap: () {},
            ),
            const SizedBox(height: 16),
            StatsGridNew(stats: _stats),
            const SizedBox(height: 24),
            OutletStatisticsSectionNew(
              tabLabels: _statsTabLabels,
              activeTabIndex: _activeStatsTab,
              outlets: _outletStats,
              columnHeader: _activeTabColumnHeader,
              valueGetter: _getOutletValue,
              onTabChanged: (index) => setState(() => _activeStatsTab = index),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dashboard',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          GestureDetector(
            onTap: () => _showDatePicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formattedDate,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, color: colorScheme.onSurfaceVariant, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colorScheme.primary,
              onPrimary: colorScheme.onPrimary,
              surface: colorScheme.surface,
              onSurface: colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }
}
