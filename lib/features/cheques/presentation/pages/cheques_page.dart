import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/features/cheques/presentation/widgets/add_cheque_dialog.dart';
import 'package:pasal_pro/features/cheques/presentation/widgets/cheque_list_item.dart';
import 'package:pasal_pro/features/cheques/presentation/providers/cheque_providers.dart';

/// Main page for cheque tracking
class ChequesPage extends ConsumerStatefulWidget {
  const ChequesPage({super.key});

  @override
  ConsumerState<ChequesPage> createState() => _ChequesPageState();
}

class _ChequesPageState extends ConsumerState<ChequesPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Refresh data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshKey.currentState?.show();
    });
  }

  /// Handle filter selection
  void _setFilter(String status) {
    ref.read(selectedChequeFilterProvider.notifier).state = status;
  }

  /// Refresh cheques list
  Future<void> _refreshCheques() async {
    ref.invalidate(allChequesProvider);
    ref.invalidate(displayChequesProvider);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedFilter = ref.watch(selectedChequeFilterProvider);
    final displayCheques = ref.watch(displayChequesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CHEQUE TRACKER'),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          // Add button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const AddChequeDialog(),
                ).then((_) {
                  _refreshCheques();
                });
              },
              tooltip: 'Add Cheque',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  value: 'all',
                  isSelected: selectedFilter == 'all',
                  onTap: () => _setFilter('all'),
                ),
                AppSpacing.hMedium,
                _FilterChip(
                  label: 'Due Soon ⏰',
                  value: 'due_soon',
                  isSelected: selectedFilter == 'due_soon',
                  onTap: () => _setFilter('due_soon'),
                ),
                AppSpacing.hMedium,
                _FilterChip(
                  label: 'Overdue ⚠️',
                  value: 'overdue',
                  isSelected: selectedFilter == 'overdue',
                  onTap: () => _setFilter('overdue'),
                ),
                AppSpacing.hMedium,
                _FilterChip(
                  label: 'Cleared ✓',
                  value: 'cleared',
                  isSelected: selectedFilter == 'cleared',
                  onTap: () => _setFilter('cleared'),
                ),
              ],
            ),
          ),

          // Cheques list
          Expanded(
            child: displayCheques.when(
              data: (cheques) {
                if (cheques.isEmpty) {
                  return _EmptyState(filter: selectedFilter);
                }

                return RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: _refreshCheques,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: cheques.length,
                    itemBuilder: (context, index) {
                      final cheque = cheques[index];
                      return ChequeListItem(
                        cheque: cheque,
                        onStatusChanged: _refreshCheques,
                      );
                    },
                  ),
                );
              },
              loading: () {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      AppSpacing.medium,
                      Text(
                        'Error loading cheques',
                        style: theme.textTheme.titleMedium,
                      ),
                      AppSpacing.small,
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state widget
class _EmptyState extends StatelessWidget {
  final String filter;

  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String message = 'No cheques found';
    if (filter == 'due_soon') {
      message = 'No cheques due soon';
    } else if (filter == 'overdue') {
      message = 'No overdue cheques';
    } else if (filter == 'cleared') {
      message = 'No cleared cheques';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          AppSpacing.large,
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.small,
          Text(
            'Tap the + button to add a cheque',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

/// Filter chip widget
class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: isSelected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.outline,
        width: isSelected ? 2 : 1,
      ),
    );
  }
}
