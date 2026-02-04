import 'package:flutter/material.dart';

class NavRailDestination {
  final String label;
  final IconData icon;
  final String shortcut;

  const NavRailDestination({
    required this.label,
    required this.icon,
    required this.shortcut,
  });
}

/// Modern flat navigation rail with smooth animations
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
      curve: Curves.easeInOut,
      width: isExpanded ? 240 : 72,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            child: Row(
              children: [
                if (isExpanded)
                  Expanded(
                    child: Text(
                      'PASAL PRO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.chevron_left : Icons.chevron_right,
                    size: 20,
                  ),
                  onPressed: onToggleExpanded,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: destinations.length,
              itemBuilder: (context, index) => _NavItem(
                destination: destinations[index],
                isSelected: selectedIndex == index,
                isExpanded: isExpanded,
                onTap: () => onDestinationSelected(index),
              ),
            ),
          ),

          // Footer items
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            child: Column(
              children: [
                _NavItem(
                  destination: const NavRailDestination(
                    label: 'SETTINGS',
                    icon: Icons.settings_outlined,
                    shortcut: 'S',
                  ),
                  isSelected: false,
                  isExpanded: isExpanded,
                  onTap: () {},
                ),
                _NavItem(
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

class _NavItem extends StatefulWidget {
  final NavRailDestination destination;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const _NavItem({
    required this.destination,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = widget.isSelected;
    final showHover = _isHovering && !isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary.withOpacity(0.1)
                : showHover
                    ? theme.colorScheme.surfaceContainerHighest
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(
                  widget.destination.icon,
                  size: 20,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                if (widget.isExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.destination.label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                            color: isActive
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          widget.destination.shortcut,
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.onSurfaceVariant,
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
      ),
    );
  }
}
