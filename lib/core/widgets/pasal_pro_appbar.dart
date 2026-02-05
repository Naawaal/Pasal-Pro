import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';

/// Modern flat AppBar for Pasal Pro
/// Clean design with smooth interactions
class PasalProAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onSearch;
  final VoidCallback? onSync;
  final String? syncStatus;
  final VoidCallback? onUserMenu;
  final bool showSearch;
  final ValueChanged<String>? onThemeSelected;

  const PasalProAppBar({
    super.key,
    this.title,
    this.onSearch,
    this.onSync,
    this.syncStatus,
    this.onUserMenu,
    this.showSearch = false,
    this.onThemeSelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final appBarStyle = BoxStyler()
        .height(56)
        .color(surfaceColor)
        .borderBottom(color: borderColor)
        .paddingX(16);

    return Box(
      style: appBarStyle,
      child: Row(
        children: [
          // Title
          StyledText(
            title ?? 'Pasal Pro',
            style: TextStyler()
                .style(PasalTextStyleToken.title.token.mix())
                .color(PasalColorToken.textPrimary.token()),
          ),
          const Spacer(),

          // Search button
          _ActionButton(
            icon: Icons.search,
            tooltip: 'Search (Ctrl+F)',
            onPressed: onSearch,
          ),
          const SizedBox(width: 8),

          // Sync status
          if (syncStatus != null) ...[
            _SyncIndicator(status: syncStatus!, onTap: onSync),
            const SizedBox(width: 8),
          ],

          // Theme selector
          _ThemeButton(onThemeSelected: onThemeSelected),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceAlt = PasalColorToken.surfaceAlt.token.resolve(context);
    final surfaceHover = PasalColorToken.surfaceHover.token.resolve(context);
    final iconColor = PasalColorToken.textSecondary.token.resolve(context);

    return MouseRegion(
      child: Tooltip(
        message: tooltip,
        child: PressableBox(
          onPress: onPressed,
          style: BoxStyler()
              .paddingAll(8)
              .borderRounded(8)
              .color(surfaceAlt)
              .onHovered(BoxStyler().color(surfaceHover)),
          child: StyledIcon(
            icon: icon,
            style: IconStyler().size(20).color(iconColor),
          ),
        ),
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final ValueChanged<String>? onThemeSelected;

  const _ThemeButton({this.onThemeSelected});

  @override
  Widget build(BuildContext context) {
    return _ActionButton(
      icon: Icons.palette_outlined,
      tooltip: 'Change theme',
      onPressed: () => _showThemeMenu(context, onThemeSelected),
    );
  }
}

class _SyncIndicator extends StatelessWidget {
  final String status;
  final VoidCallback? onTap;

  const _SyncIndicator({required this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(context);
    final icon = _getStatusIcon();
    return GestureDetector(
      onTap: onTap,
      child: Box(
        style: BoxStyler()
            .paddingX(10)
            .paddingY(6)
            .borderRounded(12)
            .color(color.withValues(alpha: 0.1)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status == 'syncing')
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            else
              Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            StyledText(
              _getStatusText(),
              style: TextStyler()
                  .style(PasalTextStyleToken.caption.token.mix())
                  .fontWeight(FontWeight.w600)
                  .color(color),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    switch (status) {
      case 'syncing':
        return PasalColorToken.primary.token.resolve(context);
      case 'synced':
        return const Color(0xFF10B981);
      case 'error':
        return PasalColorToken.error.token.resolve(context);
      default:
        return PasalColorToken.textSecondary.token.resolve(context);
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case 'synced':
        return Icons.check_circle;
      case 'error':
        return Icons.error;
      default:
        return Icons.sync;
    }
  }

  String _getStatusText() {
    switch (status) {
      case 'syncing':
        return 'Syncing...';
      case 'synced':
        return 'Synced';
      case 'error':
        return 'Error';
      default:
        return '';
    }
  }
}

Future<void> _showThemeMenu(
  BuildContext context,
  ValueChanged<String>? onThemeSelected,
) async {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );

  final selection = await showMenu<String>(
    context: context,
    position: position,
    items: const [
      PopupMenuItem(
        value: 'system',
        child: _ThemeMenuItem(label: 'System', icon: Icons.brightness_auto),
      ),
      PopupMenuItem(
        value: 'light',
        child: _ThemeMenuItem(label: 'Light', icon: Icons.light_mode),
      ),
      PopupMenuItem(
        value: 'dark',
        child: _ThemeMenuItem(label: 'Dark', icon: Icons.dark_mode),
      ),
    ],
  );

  if (selection != null) {
    onThemeSelected?.call(selection);
  }
}

class _ThemeMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const _ThemeMenuItem({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(label)],
    );
  }
}
