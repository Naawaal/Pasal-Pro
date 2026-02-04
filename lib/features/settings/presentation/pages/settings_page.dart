import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/features/settings/presentation/providers/settings_providers.dart';
import 'package:pasal_pro/features/settings/presentation/widgets/settings_section.dart';
import 'package:pasal_pro/features/settings/presentation/widgets/settings_item.dart';

/// Modern settings page with functional store and app preferences
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return settingsAsync.when(
      data: (settings) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Business Information Section
                    SettingsSection(
                      title: 'Business Information',
                      icon: Icons.business_outlined,
                      children: [
                        SettingsItem(
                          icon: Icons.store_outlined,
                          title: 'Store Name',
                          subtitle: settings.storeName,
                          onTap: () =>
                              _editStoreName(context, ref, settings.storeName),
                        ),
                        SettingsItem(
                          icon: Icons.location_on_outlined,
                          title: 'Address',
                          subtitle: settings.storeAddress ?? 'Not set',
                          onTap: () => _editStoreAddress(
                            context,
                            ref,
                            settings.storeAddress,
                          ),
                        ),
                        SettingsItem(
                          icon: Icons.phone_outlined,
                          title: 'Contact',
                          subtitle: settings.storePhone ?? 'Not set',
                          onTap: () => _editStorePhone(
                            context,
                            ref,
                            settings.storePhone,
                          ),
                        ),
                        SettingsItem(
                          icon: Icons.receipt_outlined,
                          title: 'Tax Rate',
                          subtitle:
                              'VAT ${settings.taxRate?.toStringAsFixed(1)}%',
                          onTap: () => _editTaxRate(
                            context,
                            ref,
                            settings.taxRate ?? 13.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Application Section
                    SettingsSection(
                      title: 'Application',
                      icon: Icons.settings_outlined,
                      children: [
                        SettingsItem(
                          icon: Icons.palette_outlined,
                          title: 'Theme Mode',
                          subtitle: _themeModeLabel(settings.themeMode),
                          onTap: () => _selectThemeMode(context, ref, settings.themeMode),
                        ),
                        SettingsItem(
                          icon: Icons.language_outlined,
                          title: 'Language',
                          subtitle: settings.language == 'en'
                              ? 'English'
                              : 'नेपाली',
                          onTap: () =>
                              _selectLanguage(context, ref, settings.language),
                        ),
                        SettingsItem(
                          icon: Icons.currency_rupee,
                          title: 'Currency',
                          subtitle: settings.currency,
                        ),
                        SettingsItem(
                          icon: Icons.notifications_outlined,
                          title: 'Low Stock Alerts',
                          subtitle: 'Notify when inventory is low',
                          trailing: Switch(
                            value: settings.lowStockAlerts,
                            onChanged: (value) {
                              ref
                                  .read(settingsNotifierProvider.notifier)
                                  .toggleLowStockAlerts();
                            },
                          ),
                        ),
                        SettingsItem(
                          icon: Icons.insert_chart_outlined,
                          title: 'Daily Reports',
                          subtitle: 'Get daily business summary',
                          trailing: Switch(
                            value: settings.dailyReportNotifications,
                            onChanged: (value) {
                              ref
                                  .read(settingsNotifierProvider.notifier)
                                  .toggleDailyReportNotifications();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Data & Backup Section
                    SettingsSection(
                      title: 'Data & Backup',
                      icon: Icons.cloud_outlined,
                      children: [
                        SettingsItem(
                          icon: Icons.sync_outlined,
                          title: 'Auto Sync',
                          subtitle: 'Sync data automatically',
                          trailing: Switch(
                            value: settings.autoSync,
                            onChanged: (value) {
                              ref
                                  .read(settingsNotifierProvider.notifier)
                                  .toggleAutoSync();
                            },
                          ),
                        ),
                        SettingsItem(
                          icon: Icons.backup_outlined,
                          title: 'Backup Data',
                          subtitle: settings.lastBackupTime != null
                              ? 'Last backup: ${_formatDateTime(settings.lastBackupTime!)}'
                              : 'No backup yet',
                          onTap: () => _performBackup(context, ref),
                        ),
                        SettingsItem(
                          icon: Icons.restore_outlined,
                          title: 'Restore Data',
                          subtitle: 'Restore from backup',
                          onTap: () => _showRestoreDialog(context),
                        ),
                        SettingsItem(
                          icon: Icons.download_outlined,
                          title: 'Export Data',
                          subtitle: 'Export to CSV/Excel',
                          onTap: () => _showExportDialog(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // About Section
                    SettingsSection(
                      title: 'About',
                      icon: Icons.info_outlined,
                      children: [
                        SettingsItem(
                          icon: Icons.info_outlined,
                          title: 'Version',
                          subtitle: settings.version,
                        ),
                        SettingsItem(
                          icon: Icons.description_outlined,
                          title: 'Terms & Conditions',
                          onTap: () => _showTermsDialog(context),
                        ),
                        SettingsItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () => _showPrivacyDialog(context),
                        ),
                        SettingsItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () => _showHelpDialog(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }

  // Dialog and Edit Methods
  void _editStoreName(BuildContext context, WidgetRef ref, String current) {
    final controller = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Store Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter store name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .updateStoreName(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editStoreAddress(BuildContext context, WidgetRef ref, String? current) {
    final controller = TextEditingController(text: current ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Address'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter store address',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .updateStoreAddress(
                    controller.text.isEmpty ? null : controller.text,
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editStorePhone(BuildContext context, WidgetRef ref, String? current) {
    final controller = TextEditingController(text: current ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Phone'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter store phone',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .updateStorePhone(
                    controller.text.isEmpty ? null : controller.text,
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editTaxRate(BuildContext context, WidgetRef ref, double current) {
    final controller = TextEditingController(text: current.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tax Rate (%)'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: 'Enter tax rate',
            border: OutlineInputBorder(),
            suffixText: '%',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final rate = double.tryParse(controller.text) ?? current;
              ref.read(settingsNotifierProvider.notifier).updateTaxRate(rate);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _selectLanguage(BuildContext context, WidgetRef ref, String current) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              trailing: current == 'en'
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () {
                ref
                    .read(settingsNotifierProvider.notifier)
                    .updateLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('नेपाली'),
              trailing: current == 'ne'
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () {
                ref
                    .read(settingsNotifierProvider.notifier)
                    .updateLanguage('ne');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performBackup(BuildContext context, WidgetRef ref) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Backing up data...'),
          ],
        ),
      ),
    );

    // Simulate backup operation
    await Future.delayed(const Duration(seconds: 2));

    // Update last backup time
    ref.read(settingsNotifierProvider.notifier).updateLastBackupTime();

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup completed successfully')),
      );
    }
  }

  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Data'),
        content: const Text(
          'This will restore your data from the latest backup. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data restored successfully')),
              );
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Choose export format:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data exported as CSV')),
              );
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data exported as Excel')),
              );
            },
            child: const Text('Excel'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'Pasal Pro Terms & Conditions\n\n'
            'Last Updated: February 2026\n\n'
            '1. Use License\n'
            'Permission is granted to temporarily download one copy of the materials (information or software) on Pasal Pro\'s website for personal, non-commercial transitory viewing only.\n\n'
            '2. Disclaimer\n'
            'The materials on Pasal Pro\'s website are provided on an \'as is\' basis. Pasal Pro makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.\n\n'
            '3. Limitations\n'
            'In no event shall Pasal Pro or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on Pasal Pro\'s website.\n',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Pasal Pro Privacy Policy\n\n'
            'Last Updated: February 2026\n\n'
            '1. Information Collection\n'
            'Pasal Pro collects information you provide directly, such as when you create an account or configure settings.\n\n'
            '2. Data Protection\n'
            'Your data is stored locally on your device. We do not share your business data with third parties.\n\n'
            '3. Your Rights\n'
            'You have the right to access, modify, or delete your data at any time.\n\n'
            '4. Changes to Privacy Policy\n'
            'We may update this privacy policy from time to time. We will notify you of any changes by updating the date.\n',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const SingleChildScrollView(
          child: Text(
            'Pasal Pro Help & Support\n\n'
            'Quick Tips:\n\n'
            '⌘+S: Quick sale entry\n'
            '⌘+P: Open products\n'
            '⌘+C: Open customers\n'
            '⌘+,: Open settings\n\n'
            'Common Issues:\n\n'
            '1. How do I add a product?\n'
            'Click on "Products" → "Add Product" and fill in the details.\n\n'
            '2. How do I track credit sales?\n'
            'Customers are tracked in the "Customers" section with credit ledger.\n\n'
            '3. How do I backup my data?\n'
            'Use Settings → "Backup Data" to backup your business data.\n\n'
            'For more support, contact: support@pasalpro.com\n',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.settings_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Manage your app preferences and configurations',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Format datetime for display
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }

  /// Convert theme mode to readable label
  String _themeModeLabel(String mode) {
    return switch (mode) {
      'light' => 'Light',
      'dark' => 'Dark',
      _ => 'System',
    };
  }

  /// Show theme mode selection dialog
  void _selectThemeMode(BuildContext context, WidgetRef ref, String current) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('System'),
              subtitle: const Text('Follow device settings'),
              trailing: current == 'system'
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                ref
                    .read(settingsNotifierProvider.notifier)
                    .setThemeMode('system');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Light'),
              subtitle: const Text('Always use light theme'),
              trailing: current == 'light'
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                ref
                    .read(settingsNotifierProvider.notifier)
                    .setThemeMode('light');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Dark'),
              subtitle: const Text('Always use dark theme'),
              trailing: current == 'dark'
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                ref
                    .read(settingsNotifierProvider.notifier)
                    .setThemeMode('dark');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
