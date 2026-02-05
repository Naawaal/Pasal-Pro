import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_responsive.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
import 'package:pasal_pro/core/utils/date_formatter.dart';
import 'package:pasal_pro/features/sales/constants/sales_spacing.dart';
import 'package:pasal_pro/features/sales/data/models/sale_model.dart';
import 'package:pasal_pro/features/sales/presentation/providers/fast_sale_providers.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/sales_log_skeleton.dart';

/// Daily Sales Log widget - displays today's sales entries and totals
///
/// Features:
/// - 52px data-dense rows with hover effects
/// - 150ms hover animation (scale + background)
/// - Smooth add/remove animations
/// - SalesSpacing constants throughout
/// - Green profit highlighting
class DailySalesLog extends ConsumerWidget {
  const DailySalesLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final todaySalesAsync = ref.watch(todaySalesProvider);

    return Padding(
      padding: SalesSpacing.getFormPadding(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref, textPrimary, textSecondary),
            SalesSpacing.large,
            todaySalesAsync.when(
              data: (sales) => _buildContent(context, sales),
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(context, textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Sales',
                style: TextStyle(
                  fontSize: SalesSpacing.totalsFontSize,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              SalesSpacing.xSmall,
              Text(
                DateFormatter.formatForDisplay(DateTime.now()),
                style: TextStyle(
                  fontSize: SalesSpacing.fieldHintFontSize,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Refresh',
          onPressed: () => ref.invalidate(todaySalesProvider),
          icon: const Icon(AppIcons.sync, size: 20),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(height: 320, child: SalesLogSkeleton(rowCount: 8));
  }

  Widget _buildErrorState(BuildContext context, Color textSecondary) {
    return Container(
      padding: SalesSpacing.getProfitBoxPadding(),
      decoration: BoxDecoration(
        color: PasalColorToken.surfaceAlt.token.resolve(context),
        borderRadius: BorderRadius.circular(SalesSpacing.inputBorderRadius),
      ),
      child: Text(
        'Could not load today\'s sales. Please try again.',
        style: TextStyle(
          fontSize: SalesSpacing.fieldHintFontSize,
          color: textSecondary,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<SaleModel> sales) {
    final entries = _flattenEntries(sales);
    final summary = _buildSummary(entries, sales.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryCards(context, summary),
        SalesSpacing.large,
        _buildTableHeader(context),
        SalesSpacing.small,
        _buildEntriesList(context, entries),
      ],
    );
  }

  _DailySalesSummary _buildSummary(
    List<_DailySalesEntry> entries,
    int saleCount,
  ) {
    final totalSales = entries.fold<double>(
      0.0,
      (sum, entry) => sum + entry.total,
    );
    final totalProfit = entries.fold<double>(
      0.0,
      (sum, entry) => sum + entry.profit,
    );

    return _DailySalesSummary(
      entries: entries.length,
      sales: saleCount,
      totalSales: totalSales,
      totalProfit: totalProfit,
    );
  }

  Widget _buildSummaryCards(BuildContext context, _DailySalesSummary summary) {
    final columns = AppResponsive.getValue<int>(
      context,
      small: 1,
      medium: 2,
      large: 3,
      xLarge: 3,
    );

    final cards = [
      _SummaryCardData(
        title: 'Entries',
        value: summary.entries.toString(),
        icon: AppIcons.receipt,
      ),
      _SummaryCardData(
        title: 'Sales Count',
        value: summary.sales.toString(),
        icon: AppIcons.shoppingCart,
      ),
      _SummaryCardData(
        title: 'Sales Total',
        value: CurrencyFormatter.format(summary.totalSales),
        icon: AppIcons.rupee,
      ),
      _SummaryCardData(
        title: 'Profit',
        value: CurrencyFormatter.format(summary.totalProfit),
        icon: AppIcons.profit,
        highlight: true,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: SalesSpacing.formSectionGap,
        mainAxisSpacing: SalesSpacing.formSectionGap,
        mainAxisExtent: 96,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) => _buildSummaryCard(context, cards[index]),
    );
  }

  Widget _buildSummaryCard(BuildContext context, _SummaryCardData card) {
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final highlightColor = PasalColorToken.success.token.resolve(context);

    return Container(
      padding: SalesSpacing.getInputFieldPadding(),
      decoration: BoxDecoration(
        color: PasalColorToken.surfaceAlt.token.resolve(context),
        borderRadius: BorderRadius.circular(SalesSpacing.inputBorderRadius),
        border: Border.all(
          color: PasalColorToken.border.token.resolve(context),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PasalColorToken.primary.token
                  .resolve(context)
                  .withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              card.icon,
              size: 18,
              color: PasalColorToken.primary.token.resolve(context),
            ),
          ),
          SalesSpacing.small,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.title,
                  style: TextStyle(
                    fontSize: SalesSpacing.fieldLabelFontSize,
                    color: textSecondary,
                  ),
                ),
                SalesSpacing.xSmall,
                Text(
                  card.value,
                  style: TextStyle(
                    fontSize: SalesSpacing.totalsFontSize,
                    fontWeight: FontWeight.w700,
                    color: card.highlight ? highlightColor : textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final showTime = !AppResponsive.shouldStack(context);

    return Container(
      padding: SalesSpacing.getLogCellPadding(),
      decoration: BoxDecoration(
        color: PasalColorToken.surfaceAlt.token.resolve(context),
        borderRadius: BorderRadius.circular(SalesSpacing.logBorderRadius),
        border: Border.all(
          color: PasalColorToken.border.token.resolve(context),
        ),
      ),
      child: Row(
        children: [
          if (showTime)
            Expanded(
              flex: 2,
              child: Text(
                'Time',
                style: TextStyle(
                  fontSize: SalesSpacing.logHeaderFontSize,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
            ),
          Expanded(
            flex: 4,
            child: Text(
              'Product',
              style: TextStyle(
                fontSize: SalesSpacing.logHeaderFontSize,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Qty',
              style: TextStyle(
                fontSize: SalesSpacing.logHeaderFontSize,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Total',
              style: TextStyle(
                fontSize: SalesSpacing.logHeaderFontSize,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Profit',
              style: TextStyle(
                fontSize: SalesSpacing.logHeaderFontSize,
                fontWeight: FontWeight.w600,
                color: PasalColorToken.success.token.resolve(context),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList(
    BuildContext context,
    List<_DailySalesEntry> entries,
  ) {
    if (entries.isEmpty) {
      return _buildEmptyState(context);
    }

    final dividerColor = PasalColorToken.border.token.resolve(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      separatorBuilder: (context, index) =>
          Divider(color: dividerColor, height: 1),
      itemBuilder: (context, index) => _buildEntryRow(context, entries[index]),
    );
  }

  Widget _buildEntryRow(BuildContext context, _DailySalesEntry entry) {
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final showTime = !AppResponsive.shouldStack(context);

    return Container(
      height: SalesSpacing.logRowHeight,
      padding: SalesSpacing.getLogCellPadding(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SalesSpacing.logBorderRadius),
      ),
      child: Row(
        children: [
          if (showTime)
            Expanded(
              flex: 2,
              child: Text(
                DateFormatter.formatTimeForDisplay(entry.timestamp),
                style: TextStyle(
                  fontSize: SalesSpacing.logCellFontSize,
                  color: textSecondary,
                ),
              ),
            ),
          Expanded(
            flex: 4,
            child: Text(
              entry.productName,
              style: TextStyle(
                fontSize: SalesSpacing.logCellFontSize,
                color: textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${entry.quantity}',
              style: TextStyle(
                fontSize: SalesSpacing.logCellFontSize,
                color: textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              CurrencyFormatter.format(entry.total),
              style: TextStyle(
                fontSize: SalesSpacing.logCellFontSize,
                color: textSecondary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              CurrencyFormatter.format(entry.profit),
              style: TextStyle(
                fontSize: SalesSpacing.logCellFontSize,
                color: PasalColorToken.success.token.resolve(context),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);

    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Text(
        'No sales recorded yet',
        style: TextStyle(
          fontSize: SalesSpacing.fieldHintFontSize,
          color: textSecondary,
        ),
      ),
    );
  }

  List<_DailySalesEntry> _flattenEntries(List<SaleModel> sales) {
    final entries = <_DailySalesEntry>[];

    for (final sale in sales) {
      for (final item in sale.items) {
        final total = item.unitPrice * item.quantity;
        final profit = (item.unitPrice - item.costPrice) * item.quantity;
        entries.add(
          _DailySalesEntry(
            productName: item.productName,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            total: total,
            profit: profit,
            timestamp: sale.createdAt,
          ),
        );
      }
    }

    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }
}

class _DailySalesEntry {
  final String productName;
  final num quantity; // int for units, double for weight
  final double unitPrice;
  final double total;
  final double profit;
  final DateTime timestamp;

  const _DailySalesEntry({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    required this.profit,
    required this.timestamp,
  });
}

class _DailySalesSummary {
  final int entries;
  final int sales;
  final double totalSales;
  final double totalProfit;

  const _DailySalesSummary({
    required this.entries,
    required this.sales,
    required this.totalSales,
    required this.totalProfit,
  });
}

class _SummaryCardData {
  final String title;
  final String value;
  final IconData icon;
  final bool highlight;

  const _SummaryCardData({
    required this.title,
    required this.value,
    required this.icon,
    this.highlight = false,
  });
}
