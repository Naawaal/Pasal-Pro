import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/features/settings/presentation/providers/settings_providers.dart';

/// Modern flat AppBar for Pasal Pro
/// Clean design with smooth interactions
class PasalProAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onSearch;
  final VoidCallback? onSync;
  final String? syncStatus;
  final VoidCallback? onUserMenu;
  final bool showSearch;

  const PasalProAppBar({
    super.key,
    this.title,
    this.onSearch,
    this.onSync,
    this.syncStatus,
    this.onUserMenu,
    this.showSearch = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
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

          // Theme toggle button
          _ThemeToggleButton(notifierRef: ref),
          const SizedBox(width: 8),

          // Sync status
          if (syncStatus != null) ...[
            _SyncIndicator(status: syncStatus!, onTap: onSync),
            const SizedBox(width: 8),
          ],

          // User menu
          _ActionButton(
            icon: Icons.account_circle_outlined,
            tooltip: 'Account',
            onPressed: onUserMenu,
          ),
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

class _SyncIndicator extends StatelessWidget {
  final String status;
  final VoidCallback? onTap;

  const _SyncIndicator({
    required this.status,
    this.onTap,
  });

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
/// Theme toggle button with dropdown
class _ThemeToggleButton extends ConsumerStatefulWidget {
  final WidgetRef notifierRef;

  const _ThemeToggleButton({required this.notifierRef});

  @override
  ConsumerState<_ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends ConsumerState<_ThemeToggleButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return settingsAsync.maybeWhen(
      data: (settings) => MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Tooltip(
          message: 'Theme (${_getThemeLabel(settings.themeMode)})',
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showThemeMenu(context),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  _getThemeIcon(settings.themeMode),
                  size: 20,
                  color: _isHovering
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }

  /// Get icon for current theme
  IconData _getThemeIcon(String mode) {
    return switch (mode) {
      'light' => Icons.light_mode,
      'dark' => Icons.dark_mode,
      _ => Icons.brightness_auto,
    };
  }

  /// Get label for theme
  String _getThemeLabel(String mode) {
    return switch (mode) {
      'light' => 'Light',
      'dark' => 'Dark',
      _ => 'System',
    };
  }

  /// Show theme selection menu
  void _showThemeMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 56, 0, 0),
      items: [
        PopupMenuItem(
          onTap: () {
            ref
                .read(settingsNotifierProvider.notifier)
                .setThemeMode('system');
          },
          child: const Row(
            children: [
              Icon(Icons.brightness_auto, size: 18),
              SizedBox(width: 12),
              Text('System'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            ref
                .read(settingsNotifierProvider.notifier)
                .setThemeMode('light');
          },
          child: const Row(
            children: [
              Icon(Icons.light_mode, size: 18),
              SizedBox(width: 12),
              Text('Light'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            ref
                .read(settingsNotifierProvider.notifier)
                .setThemeMode('dark');
          },
          child: const Row(
            children: [
              Icon(Icons.dark_mode, size: 18),
              SizedBox(width: 12),
              Text('Dark'),
            ],
          ),
        ),
      ],
    );
  }
}