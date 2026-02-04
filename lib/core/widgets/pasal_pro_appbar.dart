import 'package:flutter/material.dart';

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
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Title
          Text(
            title ?? 'Pasal Pro',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
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

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isHovering
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
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
            Text(
              _getStatusText(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    switch (status) {
      case 'syncing':
        return Theme.of(context).colorScheme.primary;
      case 'synced':
        return const Color(0xFF10B981);
      case 'error':
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
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
