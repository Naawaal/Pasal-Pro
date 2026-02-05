import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';

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
  final VoidCallback? onSettingsSelected;
  final VoidCallback? onHelpSelected;
  final VoidCallback? onAccountSelected;
  final String? activeFooterLabel;
  final List<NavRailDestination> destinations;

  const AppNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.isExpanded = true,
    this.onToggleExpanded,
    this.onSettingsSelected,
    this.onHelpSelected,
    this.onAccountSelected,
    this.activeFooterLabel,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: isExpanded ? 240 : 72,
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                if (isExpanded)
                  Expanded(
                    child: StyledText(
                      'PASAL PRO',
                      style: TextStyler()
                          .style(PasalTextStyleToken.caption.token.mix())
                          .fontWeight(FontWeight.w700)
                          .letterSpacing(0.5)
                          .color(textPrimary),
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
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Column(
              children: [
                _NavItem(
                  destination: const NavRailDestination(
                    label: 'SETTINGS',
                    icon: Icons.settings_outlined,
                    shortcut: 'S',
                  ),
                  isSelected: activeFooterLabel == 'SETTINGS',
                  isExpanded: isExpanded,
                  onTap: () {
                    onSettingsSelected?.call();
                  },
                ),
                _NavItem(
                  destination: const NavRailDestination(
                    label: 'HELP',
                    icon: Icons.help_outline,
                    shortcut: 'H',
                  ),
                  isSelected: activeFooterLabel == 'HELP',
                  isExpanded: isExpanded,
                  onTap: () {
                    onHelpSelected?.call();
                  },
                ),
                _NavItem(
                  destination: const NavRailDestination(
                    label: 'ACCOUNT',
                    icon: Icons.person_outline,
                    shortcut: 'A',
                  ),
                  isSelected: activeFooterLabel == 'ACCOUNT',
                  isExpanded: isExpanded,
                  onTap: () {
                    onAccountSelected?.call();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final surfaceAlt = PasalColorToken.surfaceAlt.token.resolve(context);
    final surfaceHover = PasalColorToken.surfaceHover.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final isActive = isSelected;
    final baseStyle = BoxStyler()
        .paddingX(12)
        .paddingY(12)
        .borderRounded(8)
        .marginX(8)
        .marginY(2)
        .color(surfaceAlt)
        .onHovered(BoxStyler().color(surfaceHover));
    final activeStyle = baseStyle.color(primaryColor.withValues(alpha: 0.1));

    return PressableBox(
      onPress: onTap,
      style: isActive ? activeStyle : baseStyle,
      child: Row(
        children: [
          StyledIcon(
            icon: destination.icon,
            style: IconStyler()
                .size(19)
                .color(isActive ? primaryColor : textSecondary),
          ),
          if (isExpanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StyledText(
                    destination.label,
                    style: TextStyler()
                        .style(PasalTextStyleToken.body.token.mix())
                        .fontWeight(
                          isActive ? FontWeight.w600 : FontWeight.w500,
                        )
                        .color(isActive ? primaryColor : textPrimary),
                  ),
                  StyledText(
                    destination.shortcut,
                    style: TextStyler()
                        .style(PasalTextStyleToken.caption.token.mix())
                        .color(textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
