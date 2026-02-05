import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/widgets/pasal_button.dart';
import 'package:pasal_pro/core/widgets/pasal_dialog.dart';
import 'package:pasal_pro/features/cheques/domain/entities/cheque.dart';
import 'package:pasal_pro/features/cheques/presentation/providers/cheque_providers.dart';

/// Widget to display a single cheque in the list using Mix
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

    PasalConfirmDialog.show(
      context,
      title: 'Mark as Cleared',
      message: 'Mark cheque ${cheque.chequeNumber} as cleared?',
      confirmLabel: 'Confirm',
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          await ref.read(updateStatusProvider((cheque.id!, 'cleared')).future);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cheque marked as cleared')),
            );
          }
          onStatusChanged?.call();
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
          }
        }
      }
    });
  }

  /// Handle delete
  void _delete(BuildContext context, WidgetRef ref) {
    PasalConfirmDialog.show(
      context,
      title: 'Delete Cheque',
      message: 'Delete cheque ${cheque.chequeNumber}? This cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          await ref.read(deleteChequeProvider(cheque.id!).future);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Cheque deleted')));
          }
          onStatusChanged?.call();
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final (statusIcon, statusColor, _) = _getStatusIndicator(context);

    return Box(
      style: BoxStyler()
          .paddingAll(16.0)
          .borderRounded(12.0)
          .color(surfaceColor)
          .borderAll(color: borderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Party name and status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status icon
              Box(
                style: BoxStyler()
                    .paddingAll(8.0)
                    .borderRounded(8.0)
                    .color(statusColor.withValues(alpha: 0.1)),
                child: StyledIcon(
                  icon: statusIcon,
                  style: IconStyler().size(20).color(statusColor),
                ),
              ),
              AppSpacing.hMedium,

              // Party name and cheque number
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StyledText(
                      cheque.partyName,
                      style: TextStyler()
                          .style(PasalTextStyleToken.headline.token.mix())
                          .fontWeight(FontWeight.bold)
                          .color(textPrimary),
                    ),
                    StyledText(
                      'CHQ: ${cheque.chequeNumber}',
                      style: TextStyler().fontSize(12).color(textSecondary),
                    ),
                  ],
                ),
              ),

              // Status badge
              Box(
                style: BoxStyler()
                    .paddingX(8.0)
                    .paddingY(4.0)
                    .borderRounded(4.0)
                    .color(statusColor.withValues(alpha: 0.2)),
                child: StyledText(
                  cheque.getDisplayStatus(),
                  style: TextStyler()
                      .fontSize(11)
                      .fontWeight(FontWeight.w600)
                      .color(statusColor),
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
                  StyledText(
                    'Amount',
                    style: TextStyler().fontSize(11).color(textSecondary),
                  ),
                  StyledText(
                    _formatAmount(cheque.amount),
                    style: TextStyler()
                        .fontSize(14)
                        .fontWeight(FontWeight.bold)
                        .color(primaryColor),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StyledText(
                    'Due Date',
                    style: TextStyler().fontSize(11).color(textSecondary),
                  ),
                  StyledText(
                    _formatDate(cheque.dueDate),
                    style: TextStyler()
                        .fontSize(14)
                        .fontWeight(FontWeight.bold)
                        .color(textPrimary),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.medium,

          // Days remaining/overdue info
          if (!cheque.isCleared)
            Box(
              style: BoxStyler()
                  .paddingX(12.0)
                  .paddingY(6.0)
                  .borderRounded(4.0)
                  .color(statusColor.withValues(alpha: 0.05)),
              child: StyledText(
                _getDaysInfo(),
                style: TextStyler().fontSize(11).color(statusColor),
              ),
            ),
          AppSpacing.medium,

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!cheque.isCleared)
                PasalButton(
                  label: 'Mark Clear',
                  icon: Icons.check,
                  onPressed: () => _markAsCleared(context, ref),
                  variant: PasalButtonVariant.primary,
                  size: PasalButtonSize.small,
                ),
              if (!cheque.isCleared) AppSpacing.hSmall,
              PasalButton(
                label: 'Delete',
                icon: Icons.delete,
                onPressed: () => _delete(context, ref),
                variant: PasalButtonVariant.destructive,
                size: PasalButtonSize.small,
              ),
            ],
          ),
        ],
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
