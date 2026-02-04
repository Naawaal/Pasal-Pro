import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_responsive.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
import 'package:pasal_pro/features/customers/domain/entities/customer.dart';
import 'package:pasal_pro/features/customers/presentation/providers/customer_transactions_providers.dart';
import 'package:pasal_pro/features/sales/data/models/sale_model.dart';

/// Customer transactions ledger showing payment history and balance tracking
class CustomerTransactionsPage extends ConsumerStatefulWidget {
  final Customer customer;

  const CustomerTransactionsPage({super.key, required this.customer});

  @override
  ConsumerState<CustomerTransactionsPage> createState() =>
      _CustomerTransactionsPageState();
}

class _CustomerTransactionsPageState
    extends ConsumerState<CustomerTransactionsPage> {
  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;

  @override
  void initState() {
    super.initState();
    _selectedEndDate = DateTime.now();
    _selectedStartDate = DateTime.now().subtract(const Duration(days: 30));
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return DateFormat('dd MMM, yyyy').format(date);
  }

  /// Format time for display
  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  /// Open date range picker
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _selectedStartDate,
        end: _selectedEndDate,
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked.start;
        _selectedEndDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerId = widget.customer.id;
    final transactionsAsync = ref.watch(
      customerTransactionsProvider(customerId),
    );
    final balanceAsync = ref.watch(customerCreditBalanceProvider(customerId));
    final totalPurchasesAsync = ref.watch(
      customerTotalPurchasesProvider(customerId),
    );
    final averageTransactionAsync = ref.watch(
      customerAverageTransactionProvider(customerId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.customer.name} - Transaction History'),
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Summary cards
          Padding(
            padding: AppResponsive.getPagePadding(context),
            child: _buildSummaryCards(
              context,
              balanceAsync,
              totalPurchasesAsync,
              averageTransactionAsync,
            ),
          ),

          // Date range filter
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.getPagePadding(context).left,
            ),
            child: ResponsiveRowColumn(
              layout: AppResponsive.shouldStack(context)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              children: [
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: OutlinedButton.icon(
                    onPressed: _selectDateRange,
                    icon: Icon(AppIcons.calendar),
                    label: Text(
                      '${_formatDate(_selectedStartDate)} - ${_formatDate(_selectedEndDate)}',
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.medium,

          // Transactions list
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                // Filter by date range
                final filtered = transactions.where((sale) {
                  return sale.createdAt.isAfter(
                        _selectedStartDate.subtract(const Duration(days: 1)),
                      ) &&
                      sale.createdAt.isBefore(
                        _selectedEndDate.add(const Duration(days: 1)),
                      );
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          AppIcons.inbox,
                          size: 48,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        AppSpacing.medium,
                        Text(
                          'No transactions in this period',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                // Calculate running balance
                double runningBalance = 0;
                final transactionsWithBalance = filtered.map((sale) {
                  if (sale.paymentMethod == SalePaymentMethod.credit) {
                    runningBalance += sale.subtotal;
                  }
                  return (sale, runningBalance);
                }).toList();

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: transactionsWithBalance.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Theme.of(context).colorScheme.outline,
                    height: 16,
                  ),
                  itemBuilder: (context, index) {
                    final (sale, balance) = transactionsWithBalance[index];
                    return _buildTransactionItem(
                      context,
                      sale,
                      balance,
                      index + 1,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      AppIcons.error,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    AppSpacing.medium,
                    Text(
                      'Failed to load transactions',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build summary statistics cards
  Widget _buildSummaryCards(
    BuildContext context,
    AsyncValue<double> balanceAsync,
    AsyncValue<double> totalPurchasesAsync,
    AsyncValue<double> averageTransactionAsync,
  ) {
    return GridView.count(
      crossAxisCount: AppResponsive.getValue<int>(
        context,
        small: 1,
        medium: 2,
        large: 3,
        xLarge: 3,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppResponsive.getSectionGap(context),
      crossAxisSpacing: AppResponsive.getSectionGap(context),
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          context,
          'Outstanding',
          balanceAsync,
          AppIcons.creditCard,
          false,
        ),
        _buildStatCard(
          context,
          'Total Purchases',
          totalPurchasesAsync,
          AppIcons.rupee,
          true,
        ),
        _buildStatCard(
          context,
          'Avg Transaction',
          averageTransactionAsync,
          AppIcons.barChart3,
          true,
        ),
      ],
    );
  }

  /// Build individual stat card
  Widget _buildStatCard(
    BuildContext context,
    String label,
    AsyncValue<double> value,
    IconData icon,
    bool isPositive,
  ) {
    return Container(
      padding: EdgeInsets.all(AppResponsive.getSectionGap(context) - 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              Icon(
                icon,
                size: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          value.when(
            data: (amount) => Text(
              CurrencyFormatter.format(amount),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: isPositive ? Colors.green : Colors.orange,
              ),
            ),
            loading: () =>
                Text('—', style: Theme.of(context).textTheme.bodySmall),
            error: (error, stackTrace) =>
                Text('—', style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  /// Build individual transaction item
  Widget _buildTransactionItem(
    BuildContext context,
    SaleModel sale,
    double balance,
    int index,
  ) {
    final isCash = sale.paymentMethod == SalePaymentMethod.cash;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Date, time, and payment method
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction #${sale.id}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(4),
                    Text(
                      '${_formatDate(sale.createdAt)} • ${_formatTime(sale.createdAt)}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCash
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isCash ? 'Cash' : 'Credit',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isCash ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.small,

          // Items summary
          Text(
            '${sale.items.length} item${sale.items.length != 1 ? 's' : ''}',
            style: Theme.of(context).textTheme.labelSmall,
          ),

          AppSpacing.small,

          // Amount and balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount', style: Theme.of(context).textTheme.labelSmall),
                  Text(
                    CurrencyFormatter.format(sale.subtotal),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (!isCash)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Balance',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        CurrencyFormatter.format(balance),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
