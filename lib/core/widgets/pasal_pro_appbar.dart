import 'package:flutter/material.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_spacing.dart';

/// Custom AppBar for Pasal Pro Desktop
/// Compact design (48px), modern flat styling
/// Features: Search bar, global actions, sync status, user menu
class PasalProAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onSearch;
  final VoidCallback? onSync;
  final String? syncStatus; // null, "syncing", "synced", "error"
  final VoidCallback? onUserMenu;
  final bool showSearch;

  const PasalProAppBar({
    super.key,
    this.title,
    this.onSearch,
    this.onSync,
    this.syncStatus,
    this.onUserMenu,
    this.showSearch = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.bgWhite,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 48,
      automaticallyImplyLeading: false,
      title: showSearch
          ? _SearchBar(onTap: onSearch)
          : Text(
              title ?? 'Pasal Pro',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
      actions: [
        // Global search shortcut
        if (!showSearch)
          Tooltip(
            message: 'Search (Ctrl+F)',
            child: IconButton(
              icon: const Icon(Icons.search, size: 24),
              onPressed: onSearch,
              splashRadius: 24,
            ),
          ),

        AppSpacing.hSmall,

        // Sync status indicator
        _SyncStatusButton(status: syncStatus, onTap: onSync),

        AppSpacing.hSmall,

        // User menu
        Tooltip(
          message: 'User Menu',
          child: IconButton(
            icon: const Icon(Icons.account_circle, size: 24),
            onPressed: onUserMenu,
            splashRadius: 24,
          ),
        ),

        AppSpacing.hMedium,
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.borderColor),
      ),
    );
  }
}

/// Search bar widget for AppBar
class _SearchBar extends StatefulWidget {
  final VoidCallback? onTap;

  const _SearchBar({this.onTap});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        focusNode: _focusNode,
        onTap: widget.onTap,
        decoration: InputDecoration(
          hintText: 'Search products, customers... (Ctrl+F)',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textTertiary,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textTertiary,
            size: 18,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          isDense: true,
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}

/// Sync status indicator button
class _SyncStatusButton extends StatelessWidget {
  final String? status;
  final VoidCallback? onTap;

  const _SyncStatusButton({this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isVisible = status != null && status!.isNotEmpty;

    if (!isVisible) return const SizedBox.shrink();

    return Tooltip(
      message: _getSyncMessage(),
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Padding(
            padding: AppSpacing.paddingHorizontalSmall,
            child: Center(
              child: Row(
                children: [
                  // Status indicator icon
                  _buildStatusIcon(),
                  AppSpacing.hSmall,

                  // Status text (compact)
                  Text(
                    _getStatusText(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 11,
                      color: _getStatusColor(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (status) {
      case 'syncing':
        return SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
          ),
        );
      case 'synced':
        return Icon(Icons.check_circle, size: 16, color: _getStatusColor());
      case 'error':
        return Icon(Icons.error, size: 16, color: _getStatusColor());
      default:
        return const SizedBox.shrink();
    }
  }

  Color _getStatusColor() {
    switch (status) {
      case 'syncing':
        return AppColors.warningOrange;
      case 'synced':
        return AppColors.successGreen;
      case 'error':
        return AppColors.dangerRed;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText() {
    switch (status) {
      case 'syncing':
        return 'Syncing...';
      case 'synced':
        return 'Synced';
      case 'error':
        return 'Sync Error';
      default:
        return '';
    }
  }

  String _getSyncMessage() {
    switch (status) {
      case 'syncing':
        return 'Uploading changes to cloud';
      case 'synced':
        return 'All changes synced';
      case 'error':
        return 'Sync failed - tap to retry';
      default:
        return '';
    }
  }
}
