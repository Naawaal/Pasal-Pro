import 'package:flutter/material.dart';
import 'package:pasal_pro/features/sales/constants/sales_spacing.dart';
import 'package:shimmer/shimmer.dart';

/// Loading skeleton for daily sales log entries
///
/// Displays 10 shimmer placeholder rows (52px each)
/// Provides visual feedback while data is loading
class SalesLogSkeleton extends StatelessWidget {
  final int rowCount;

  const SalesLogSkeleton({super.key, this.rowCount = 10});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        itemCount: rowCount,
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey[200], height: 1),
        itemBuilder: (context, index) {
          return Container(
            height: SalesSpacing.logRowHeight,
            padding: SalesSpacing.getLogCellPadding(),
            child: Row(
              children: [
                // Product name skeleton (flex: 3)
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                // Quantity skeleton (flex: 1)
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      height: 12,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                // Price skeleton (flex: 1)
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 12,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                // Profit skeleton (flex: 1)
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 12,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                // Remove button skeleton (32px)
                SizedBox(
                  width: SalesSpacing.removeButtonSize,
                  child: Center(
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
