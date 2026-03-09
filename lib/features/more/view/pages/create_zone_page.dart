import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_scaffold.dart';
import '../../../dashboard/view/widgets/chat_support_button.dart';
import '../../viewmodel/zone_viewmodel.dart';

/// Mock Zone Model
class ZoneModel {
  final String name;
  final List<String> restaurants;
  final bool isActive;
  final DateTime createdDate;

  ZoneModel({
    required this.name,
    required this.restaurants,
    this.isActive = true,
    required this.createdDate,
  });
}

/// Restaurant Zone List Page
class CreateZonePage extends ConsumerStatefulWidget {
  const CreateZonePage({super.key});

  @override
  ConsumerState<CreateZonePage> createState() => _CreateZonePageState();
}

class _CreateZonePageState extends ConsumerState<CreateZonePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<ZoneModel> _zones = [];
  final Set<int> _selectedZoneIndexes = {};

  @override
  void initState() {
    super.initState();
    // Load stores from repository
    Future.microtask(() {
      ref.read(zoneViewModelProvider.notifier).loadStores();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleActionSelection(String action) {
    if (_selectedZoneIndexes.isEmpty) {
      _showNoRecordSelectedDialog();
      return;
    }

    // Handle the action with selected zones
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$action applied to ${_selectedZoneIndexes.length} zone(s)',
        ),
      ),
    );
  }

  void _showNoRecordSelectedDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        content: Text(
          'You have not selected any record. So please select at least one record to perform this action.',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addZone(ZoneModel zone) {
    setState(() {
      _zones.add(zone);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(zoneViewModelProvider);
    final viewModel = ref.read(zoneViewModelProvider.notifier);

    // Build outlets list from stores
    final availableOutlets = [
      'All Outlets',
      ...state.stores.map((s) => s.name),
    ];

    return CommonScaffold(
      activeItemId: 'create_zone',
      selectedOutlet: state.selectedOutlet,
      availableOutlets: availableOutlets,
      onOutletSelected: (outlet) {
        viewModel.setSelectedOutlet(outlet);
      },
      onLightBulbTap: () {},
      backgroundColor: colorScheme.surface,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
      floatingActionButton: ChatSupportButton(
        onTap: () {
          // Handle chat support tap
        },
      ),
    );
  }

  Widget _buildBody() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and back button
        _buildHeader(colorScheme, textTheme),
        // Main content
        Expanded(
          child: Container(
            color: colorScheme.surfaceContainerLowest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter section
                _buildFilterSection(colorScheme, textTheme),
                // Zone list or empty state
                Expanded(
                  child: _zones.isEmpty
                      ? _buildEmptyState(colorScheme, textTheme)
                      : _buildZoneList(colorScheme, textTheme),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back,
                color: colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
          // Title
          Text(
            'Restaurant Zone List',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildFilterSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Create Zone and Action buttons
          Row(
            children: [
              // Create Zone button
              OutlinedButton(
                onPressed: () async {
                  final result = await Navigator.push<ZoneModel>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddZonePage(),
                    ),
                  );
                  if (result != null) {
                    _addZone(result);
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.outline),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  'Create Zone',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Action button with popup menu
              PopupMenuButton<String>(
                onSelected: _handleActionSelection,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'Active',
                    child: Text(
                      'Active',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Inactive',
                    child: Text(
                      'Inactive',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Delete',
                    child: Text(
                      'Delete',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                ],
                offset: const Offset(0, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Action',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_drop_down,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Zone Name label
          Text(
            'Zone Name',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '',
              hintStyle: TextStyle(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              filled: true,
              fillColor: colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Search and Show All buttons
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle search
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.outline),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  'Show All',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Search icon with circle background
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.errorContainer.withValues(alpha: 0.3),
            ),
            child: Icon(Icons.search, size: 40, color: colorScheme.error),
          ),
          const SizedBox(height: 24),
          // No Record Found text
          Text(
            'No Record Found',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          Text(
            'We could not find what you searched for Try searching\nagain',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneList(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              // Table header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  border: Border(
                    bottom: BorderSide(color: colorScheme.outline),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Checkbox(
                        value: _selectedZoneIndexes.length == _zones.length,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedZoneIndexes.addAll(
                                List.generate(_zones.length, (i) => i),
                              );
                            } else {
                              _selectedZoneIndexes.clear();
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Zone Name',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Restaurant(s)',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Status',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Created Date',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Action',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Table rows
              ..._zones.asMap().entries.map(
                (entry) => _buildZoneRow(
                  entry.key,
                  entry.value,
                  colorScheme,
                  textTheme,
                ),
              ),
              // Footer
              Container(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Showing 1 to ${_zones.length} of ${_zones.length} records',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZoneRow(
    int index,
    ZoneModel zone,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isSelected = _selectedZoneIndexes.contains(index);
    final dateStr =
        '${zone.createdDate.day.toString().padLeft(2, '0')}-${zone.createdDate.month.toString().padLeft(2, '0')}-${zone.createdDate.year}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorScheme.outline)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedZoneIndexes.add(index);
                  } else {
                    _selectedZoneIndexes.remove(index);
                  }
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              zone.name,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              zone.restaurants.join(', '),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              zone.isActive ? 'Active' : 'Inactive',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dateStr,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(
              Icons.edit_outlined,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Add Restaurant Zone Page
class AddZonePage extends ConsumerStatefulWidget {
  const AddZonePage({super.key});

  @override
  ConsumerState<AddZonePage> createState() => _AddZonePageState();
}

class _AddZonePageState extends ConsumerState<AddZonePage> {
  final TextEditingController _zoneNameController = TextEditingController();
  bool _isActive = true;
  final Set<int> _selectedRestaurants = {};

  @override
  void initState() {
    super.initState();
    // Load stores from repository
    Future.microtask(() {
      ref.read(zoneViewModelProvider.notifier).loadStores();
    });
  }

  @override
  void dispose() {
    _zoneNameController.dispose();
    super.dispose();
  }

  void _saveZone() {
    final state = ref.read(zoneViewModelProvider);

    if (_zoneNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a zone name')));
      return;
    }

    if (_selectedRestaurants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one restaurant')),
      );
      return;
    }

    final selectedRestaurantNames = _selectedRestaurants
        .map((index) => state.restaurants[index]['name'] as String)
        .toList();

    final zone = ZoneModel(
      name: _zoneNameController.text.trim(),
      restaurants: selectedRestaurantNames,
      isActive: _isActive,
      createdDate: DateTime.now(),
    );

    Navigator.pop(context, zone);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(zoneViewModelProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header with title and back button
                _buildHeader(colorScheme, textTheme),
                // Main content
                Expanded(
                  child: Container(
                    color: colorScheme.surfaceContainerLowest,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildZoneDetails(colorScheme, textTheme),
                          _buildRestaurantList(
                            colorScheme,
                            textTheme,
                            state.restaurants,
                          ),
                          const SizedBox(
                            height: 80,
                          ), // Space for bottom buttons
                        ],
                      ),
                    ),
                  ),
                ),
                // Bottom action buttons
                _buildBottomButtons(colorScheme),
              ],
            ),
      floatingActionButton: ChatSupportButton(
        onTap: () {
          // Handle chat support tap
        },
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back,
                color: colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
          // Title
          Text(
            'Add Restaurant Zone',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildZoneDetails(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zone Details heading
          Text(
            'Zone Details',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          // Zone Name field
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Zone Name',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '*',
                          style: TextStyle(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _zoneNameController,
                      decoration: InputDecoration(
                        hintText: '',
                        filled: true,
                        fillColor: colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Status toggle
              Column(
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isActive = !_isActive;
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _isActive
                                ? colorScheme.primary
                                : colorScheme.surface,
                            border: Border.all(
                              color: _isActive
                                  ? colorScheme.primary
                                  : colorScheme.outline,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: _isActive
                              ? Icon(
                                  Icons.check,
                                  size: 16,
                                  color: colorScheme.onPrimary,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Status',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantList(
    ColorScheme colorScheme,
    TextTheme textTheme,
    List<Map<String, dynamic>> restaurants,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Select Restaurant heading
          Row(
            children: [
              Text(
                'Select Restaurant',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                // Table header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    border: Border(
                      bottom: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Checkbox(
                          value:
                              _selectedRestaurants.length == restaurants.length,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedRestaurants.addAll(
                                  List.generate(restaurants.length, (i) => i),
                                );
                              } else {
                                _selectedRestaurants.clear();
                              }
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Sub Order Type',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Restaurant Name',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Present In Zone',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'State',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'City',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Table rows
                ...restaurants.asMap().entries.map(
                  (entry) => _buildRestaurantRow(
                    entry.key,
                    entry.value,
                    colorScheme,
                    textTheme,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantRow(
    int index,
    Map<String, dynamic> restaurant,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isSelected = _selectedRestaurants.contains(index);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorScheme.outline)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedRestaurants.add(index);
                  } else {
                    _selectedRestaurants.remove(index);
                  }
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              restaurant['subOrderType'] ?? '',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              restaurant['name'] ?? '',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              restaurant['presentInZone'] == true ? 'Yes' : '',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              restaurant['state'] ?? '',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              restaurant['city'] ?? '',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: colorScheme.outline),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _saveZone,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
