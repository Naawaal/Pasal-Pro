import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/features/cheques/domain/entities/cheque.dart';
import 'package:pasal_pro/features/cheques/presentation/providers/cheque_providers.dart';

/// Widget to display a single cheque in the list
class ChequeListItem extends ConsumerWidget {
  final Cheque cheque;
  final VoidCallback? onStatusChanged;

  const ChequeListItem({super.key, required this.cheque, this.onStatusChanged});

  /// Get status icon and color based on cheque status
  (IconData, Color, String) _getStatusIndicator(BuildContext context) {
    final theme = Theme.of(context);

    if (cheque.isCleared) {
      return (Icons.check_circle, Colors.grey, '✓');
    } else if (cheque.isOverdue) {
      return (Icons.error, Colors.red, '⚠️');
    } else if (cheque.isDueSoon) {
      return (Icons.schedule, Colors.orange, '⏰');
    } else {
      return (Icons.schedule, theme.colorScheme.outline, '⏳');
    }
  }

  /// Format amount as currency
  String _formatAmount(double amount) {
    return 'Rs. ${amount.toStringAsFixed(2)}';
  }

  /// Format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Handle mark as cleared
  void _markAsCleared(BuildContext context, WidgetRef ref) {
    if (cheque.isCleared) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mark as Cleared'),
        content: Text('Mark cheque ${cheque.chequeNumber} as cleared?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(
                  updateStatusProvider((cheque.id!, 'cleared')).future,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cheque marked as cleared')),
                  );
                }
                onStatusChanged?.call();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  /// Handle delete
  void _delete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Cheque'),
        content: Text(
          'Delete cheque ${cheque.chequeNumber}? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(deleteChequeProvider(cheque.id!).future);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cheque deleted')),
                  );
                }
                onStatusChanged?.call();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final (statusIcon, statusColor, _) = _getStatusIndicator(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Party name and status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 20),
                ),
                AppSpacing.hMedium,

                // Party name and cheque number
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cheque.partyName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'CHQ: ${cheque.chequeNumber}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    cheque.getDisplayStatus(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.medium,

            // Details row: Amount and Due Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      _formatAmount(cheque.amount),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Due Date',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      _formatDate(cheque.dueDate),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            AppSpacing.medium,

            // Days remaining/overdue info
            if (!cheque.isCleared)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getDaysInfo(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                  ),
                ),
              ),
            AppSpacing.medium,

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!cheque.isCleared)
                  ElevatedButton.icon(
                    onPressed: () => _markAsCleared(context, ref),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Mark Clear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                if (!cheque.isCleared) AppSpacing.hSmall,
                OutlinedButton.icon(
                  onPressed: () => _delete(context, ref),
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Get formatted days remaining/overdue info
  String _getDaysInfo() {
    if (cheque.isOverdue) {
      final daysOverdue = DateTime.now().difference(cheque.dueDate).inDays;
      return '$daysOverdue day${daysOverdue == 1 ? '' : 's'} overdue';
    } else {
      final daysLeft = cheque.daysUntilDue;
      return '$daysLeft day${daysLeft == 1 ? '' : 's'} remaining';
    }
  }
}
