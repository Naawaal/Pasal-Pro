import 'package:flutter/material.dart';
import 'package:pasal_pro/core/utils/currency_formatter.dart';

/// Recent activity feed showing latest transactions
class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._buildActivityItems(context),
        ],
      ),
    );
  }

  List<Widget> _buildActivityItems(BuildContext context) {
    final activities = [
      _ActivityData(
        icon: Icons.shopping_cart,
        title: 'New sale completed',
        subtitle: '5 items • Cash payment',
        amount: 2450.00,
        time: '2 min ago',
        isPositive: true,
      ),
      _ActivityData(
        icon: Icons.inventory_2,
        title: 'Stock adjusted',
        subtitle: 'Coca Cola 500ml',
        amount: null,
        time: '15 min ago',
        isPositive: null,
      ),
      _ActivityData(
        icon: Icons.shopping_cart,
        title: 'New sale completed',
        subtitle: '3 items • Credit payment',
        amount: 1850.00,
        time: '32 min ago',
        isPositive: true,
      ),
      _ActivityData(
        icon: Icons.person_add,
        title: 'New customer added',
        subtitle: 'Ram Sharma',
        amount: null,
        time: '1 hour ago',
        isPositive: null,
      ),
      _ActivityData(
        icon: Icons.shopping_cart,
        title: 'New sale completed',
        subtitle: '8 items • Cash payment',
        amount: 4250.00,
        time: '2 hours ago',
        isPositive: true,
      ),
    ];

    return activities
        .map((activity) => _buildActivityItem(context, activity))
        .toList();
  }

  Widget _buildActivityItem(BuildContext context, _ActivityData activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              activity.icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (activity.amount != null)
                Text(
                  CurrencyFormatter.format(activity.amount!),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: activity.isPositive == true
                        ? Colors.green
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              const SizedBox(height: 2),
              Text(
                activity.time,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityData {
  final IconData icon;
  final String title;
  final String subtitle;
  final double? amount;
  final String time;
  final bool? isPositive;

  _ActivityData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.isPositive,
  });
}
