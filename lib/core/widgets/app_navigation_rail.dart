import 'package:flutter/material.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';

/// Navigation destination definition for the rail
class NavRailDestination {
  final String label;
  final IconData icon;
  final String shortcut; // e.g., "F1", "F2"

  const NavRailDestination({
    required this.label,
    required this.icon,
    required this.shortcut,
  });
}

/// Desktop Navigation Rail Component
/// Supports collapsed (72px) and expanded (280px) states
/// Usage: Place on the left side of Scaffold
class AppNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isExpanded;
  final VoidCallback? onToggleExpanded;
  final List<NavRailDestination> destinations;

  const AppNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.isExpanded = true,
    this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isExpanded ? 280 : 72,
      color: AppColors.bgWhite,
      child: Column(
        children: [
          // Header with collapse button
          Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isExpanded) ...[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'PASAL PRO',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GestureDetector(
                    onTap: onToggleExpanded,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_left
                            : Icons.keyboard_arrow_right,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Primary destinations
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  destinations.length,
                  (index) => _NavRailItem(
                    destination: destinations[index],
                    isSelected: selectedIndex == index,
                    isExpanded: isExpanded,
                    onTap: () => onDestinationSelected(index),
                  ),
                ),
              ),
            ),
          ),

          // Secondary destinations (Settings, Help)
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.borderColor)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavRailItem(
                  destination: const NavRailDestination(
                    label: 'SETTINGS',
                    icon: Icons.settings,
                    shortcut: 'S',
                  ),
                  isSelected: false,
                  isExpanded: isExpanded,
                  onTap: () {},
                ),
                _NavRailItem(
                  destination: const NavRailDestination(
                    label: 'HELP',
                    icon: Icons.help_outline,
                    shortcut: 'H',
                  ),
                  isSelected: false,
                  isExpanded: isExpanded,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual navigation rail item
class _NavRailItem extends StatefulWidget {
  final NavRailDestination destination;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const _NavRailItem({
    required this.destination,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<_NavRailItem> createState() => _NavRailItemState();
}

class _NavRailItemState extends State<_NavRailItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 56,
          color: _isHovering && !widget.isSelected
              ? AppColors.bgLight
              : widget.isSelected
              ? Colors.transparent
              : Colors.transparent,
          child: Row(
            children: [
              // Left indicator (3px blue border)
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 3,
                color: widget.isSelected
                    ? AppColors.primaryBlue
                    : Colors.transparent,
              ),
              Expanded(
                child: Padding(
                  padding: widget.isExpanded
                      ? AppSpacing.paddingHorizontalMedium
                      : const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: widget.isExpanded
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      // Icon
                      Icon(
                        widget.destination.icon,
                        color: widget.isSelected
                            ? AppColors.primaryBlue
                            : AppColors.iconInactive,
                        size: 20,
                      ),

                      // Label with shortcut (visible only when expanded)
                      if (widget.isExpanded) ...[
                        const SizedBox(height: 3),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.destination.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: widget.isSelected
                                          ? AppColors.primaryBlue
                                          : AppColors.textSecondary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                      height: 1.0,
                                    ),
                              ),
                              Text(
                                widget.destination.shortcut,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.textTertiary,
                                      fontSize: 8,
                                      height: 1.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
