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

    return customersAsync.when(
      loading: () => _buildLoadingState(context),
      error: (error, stack) => _buildErrorState(context, error),
      data: (customers) {
        return Container(
          color: PasalColorToken.surfaceAlt.token.resolve(context),
          padding: AppResponsive.getPagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, customers),
              SizedBox(height: AppResponsive.getSectionGap(context)),
              _buildSearchAndFilters(context),
              SizedBox(height: AppResponsive.getSectionGap(context) - 8),
              Expanded(child: _buildCustomersList(context, customers)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: PasalColorToken.primary.token.resolve(context),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: PasalColorToken.error.token.resolve(context),
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading customers',
            style: TextStyle(
              fontSize: 16,
              color: PasalColorToken.error.token.resolve(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List customers) {
    final totalCustomers = customers.length;
    final totalCredit = customers.fold<double>(0, (sum, c) => sum + c.balance);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: PasalColorToken.primary.token
                .resolve(context)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.people_outline,
            color: PasalColorToken.primary.token.resolve(context),
            size: 24,
          ),
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
                  color: PasalColorToken.textPrimary.token.resolve(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$totalCustomers customers • ${CurrencyFormatter.formatCompact(totalCredit)} credit',
                style: TextStyle(
                  fontSize: 13,
                  color: PasalColorToken.textSecondary.token.resolve(context),
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Customer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: PasalColorToken.primary.token.resolve(context),
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

  Widget _buildSearchAndFilters(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: PasalColorToken.surface.token.resolve(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: PasalColorToken.border.token.resolve(context),
              ),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search customers...',
                hintStyle: TextStyle(
                  color: PasalColorToken.textSecondary.token.resolve(context),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: PasalColorToken.textSecondary.token.resolve(context),
                  size: 20,
                ),
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
              color: _showInactive
                  ? PasalColorToken.primary.token
                        .resolve(context)
                        .withValues(alpha: 0.1)
                  : PasalColorToken.surface.token.resolve(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _showInactive
                    ? PasalColorToken.primary.token.resolve(context)
                    : PasalColorToken.border.token.resolve(context),
              ),
            ),
            child: Text(
              'Inactive',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _showInactive
                    ? PasalColorToken.primary.token.resolve(context)
                    : PasalColorToken.textPrimary.token.resolve(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomersList(BuildContext context, List customers) {
    if (customers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: PasalColorToken.primary.token
                    .resolve(context)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.people_outline,
                size: 48,
                color: PasalColorToken.primary.token.resolve(context),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No customers found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: PasalColorToken.textPrimary.token.resolve(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add your first customer to get started',
              style: TextStyle(
                fontSize: 13,
                color: PasalColorToken.textSecondary.token.resolve(context),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: PasalColorToken.surface.token.resolve(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: PasalColorToken.border.token.resolve(context),
        ),
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
