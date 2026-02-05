import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/constants/app_responsive.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
import 'package:pasal_pro/core/widgets/pasal_button.dart';
import 'package:pasal_pro/core/widgets/pasal_text_field.dart';
import 'package:pasal_pro/features/customers/presentation/pages/customer_form_page.dart';
import 'package:pasal_pro/features/customers/presentation/providers/customer_providers.dart';
import 'package:pasal_pro/features/customers/presentation/widgets/customer_list_item.dart';

/// Modern customers management page
class CustomersPage extends ConsumerStatefulWidget {
  const CustomersPage({super.key});

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showInactive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customersProvider);
    final bgColor = PasalColorToken.surfaceAlt.token.resolve(context);
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final primaryLight = primaryColor.withValues(alpha: 0.1);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final errorColor = PasalColorToken.error.token.resolve(context);

    return customersAsync.when(
      loading: () => _buildLoadingState(context, primaryColor: primaryColor),
      error: (error, stack) =>
          _buildErrorState(context, error, errorColor: errorColor),
      data: (customers) {
        return Container(
          color: bgColor,
          padding: AppResponsive.getPagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(
                context,
                customers,
                primaryColor: primaryColor,
                primaryLight: primaryLight,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              SizedBox(height: AppResponsive.getSectionGap(context)),
              _buildSearchAndFilters(
                context,
                primaryColor: primaryColor,
                primaryLight: primaryLight,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
              SizedBox(height: AppResponsive.getSectionGap(context) - 8),
              Expanded(
                child: _buildCustomersList(
                  context,
                  customers,
                  primaryColor: primaryColor,
                  primaryLight: primaryLight,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(
    BuildContext context, {
    required Color primaryColor,
  }) {
    return Center(child: CircularProgressIndicator(color: primaryColor));
  }

  Widget _buildErrorState(
    BuildContext context,
    Object error, {
    required Color errorColor,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: errorColor),
          const SizedBox(height: 16),
          Text(
            'Error loading customers',
            style: TextStyle(fontSize: 16, color: errorColor),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    List customers, {
    required Color primaryColor,
    required Color primaryLight,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final totalCustomers = customers.length;
    final totalCredit = customers.fold<double>(0, (sum, c) => sum + c.balance);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.people_outline, color: primaryColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledText(
                'Customers',
                style: TextStyler()
                    .style(PasalTextStyleToken.title.token.mix())
                    .color(textPrimary),
              ),
              const SizedBox(height: 2),
              StyledText(
                '$totalCustomers customers • ${CurrencyFormatter.formatCompact(totalCredit)} credit',
                style: TextStyler()
                    .style(PasalTextStyleToken.caption.token.mix())
                    .color(textSecondary),
              ),
            ],
          ),
        ),
        PasalButton(
          label: 'Add Customer',
          icon: Icons.add,
          onPressed: () {},
          variant: PasalButtonVariant.primary,
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(
    BuildContext context, {
    required Color primaryColor,
    required Color primaryLight,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Row(
      children: [
        Expanded(
          child: PasalTextField(
            controller: _searchController,
            hint: 'Search customers...',
            prefixIcon: Icons.search,
            onChanged: (_) => setState(() {}),
            fillColor: surfaceColor,
          ),
        ),
        const SizedBox(width: 12),
        _buildFilterChip(
          label: 'Inactive',
          selected: _showInactive,
          primaryColor: primaryColor,
          primaryLight: primaryLight,
          surfaceColor: surfaceColor,
          borderColor: borderColor,
          textPrimary: textPrimary,
          onSelected: (value) => setState(() => _showInactive = value),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required Color primaryColor,
    required Color primaryLight,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required ValueChanged<bool> onSelected,
  }) {
    return GestureDetector(
      onTap: () => onSelected(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primaryLight : surfaceColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? primaryColor : borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? primaryColor : textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomersList(
    BuildContext context,
    List customers, {
    required Color primaryColor,
    required Color primaryLight,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = customers.where((customer) {
      if (!_showInactive && customer.isActive == false) {
        return false;
      }
      if (query.isEmpty) return true;
      final nameMatch = customer.name.toLowerCase().contains(query);
      final phoneMatch = (customer.phone ?? '').contains(query);
      return nameMatch || phoneMatch;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.people_outline, size: 48, color: primaryColor),
            ),
            const SizedBox(height: 16),
            StyledText(
              'No customers found',
              style: TextStyler()
                  .style(PasalTextStyleToken.title.token.mix())
                  .color(textPrimary),
            ),
            const SizedBox(height: 4),
            StyledText(
              'Add your first customer to get started',
              style: TextStyler()
                  .style(PasalTextStyleToken.caption.token.mix())
                  .color(textSecondary),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ListView.separated(
        padding: EdgeInsets.all(AppResponsive.getSectionGap(context) - 4),
        itemCount: filtered.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: AppResponsive.getSectionGap(context) - 4),
        itemBuilder: (context, index) {
          final customer = filtered[index];
          return CustomerListItem(
            customer: customer,
            onTap: () {
              // Navigate to customer detail/edit page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerFormPage(customer: customer),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
