import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/core/constants/app_responsive.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';
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
              Text(
                'Customers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$totalCustomers customers • ${CurrencyFormatter.formatCompact(totalCredit)} credit',
                style: TextStyle(fontSize: 13, color: textSecondary),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Customer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
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
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search customers...',
                hintStyle: TextStyle(color: textSecondary),
                prefixIcon: Icon(Icons.search, color: textSecondary, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => setState(() => _showInactive = !_showInactive),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _showInactive ? primaryLight : surfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _showInactive ? primaryColor : borderColor,
              ),
            ),
            child: Text(
              'Inactive',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _showInactive ? primaryColor : textPrimary,
              ),
            ),
          ),
        ),
      ],
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
    if (customers.isEmpty) {
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
            Text(
              'No customers found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add your first customer to get started',
              style: TextStyle(fontSize: 13, color: textSecondary),
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
        itemCount: customers.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: AppResponsive.getSectionGap(context) - 4),
        itemBuilder: (context, index) {
          final customer = customers[index];
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
