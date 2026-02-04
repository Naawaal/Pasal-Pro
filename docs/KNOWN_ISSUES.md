# Known Issues & Solutions

## Build Errors

### ❌ Windows Build Error: `atlstr.h` not found

**Error:**

```
Cannot open include file: 'atlstr.h': No such file or directory
[flutter_secure_storage_windows_plugin.vcxproj]
```

**Cause:**

- `flutter_secure_storage_windows` requires ATL (Active Template Library) headers
- These are only included with Visual Studio's "Desktop development with C++" workload
- Not all Windows development setups have this installed

**Solution (Temporary):**

- Removed `flutter_secure_storage`, `googleapis`, and `googleapis_auth` from dependencies
- These packages are commented out in `pubspec.yaml`
- Will be re-added in Phase 6 when actually needed for Google Drive backup

**Solution (Permanent - for Phase 6):**

Option 1: Install Visual Studio Components

```bash
# Install Visual Studio Build Tools with C++ support
# Download from: https://visualstudio.microsoft.com/downloads/
# Select: "Desktop development with C++"
```

Option 2: Use Alternative Package

```yaml
# Consider using:
hive: ^2.2.3 # Local encrypted storage
shared_preferences_windows: ^2.4.1 # Simple key-value storage
```

Option 3: Platform-Specific Implementation

```dart
// Use flutter_secure_storage only on mobile
// Use Windows Credential Manager directly via FFI on Windows
```

---

## Dependency Conflicts

### ⚠️ Bluetooth Printer Package Conflict

**Issue:**

- `blue_thermal_printer` has version conflicts with other packages
- Not available on pub.dev in compatible version

**Solution:**

- Removed from dependencies
- Will use `printing` package for PDF receipts in MVP
- Can evaluate alternatives in Phase 5:
  - `esc_pos_bluetooth`
  - `flutter_pos_printer`
  - Direct platform channel implementation

---

## Version Warnings

### ⚠️ Analyzer Version Warning

**Warning:**

```
Your current `analyzer` version may not fully support your current SDK version.
Analyzer: 3.1.0, SDK: 3.10.0
```

**Impact:** Low - doesn't affect functionality

**Solution:**

- Analyzer version is locked by Flutter SDK
- Will be resolved when Flutter SDK updates
- Can ignore for now

---

## Phase-Specific Notes

### Phase 0 (Current)

✅ All core functionality working
✅ Tests passing
✅ Windows build successful (without secure_storage)

### Phase 6 (Future)

⚠️ Need to address:

- Google Drive backup authentication
- Secure token storage on Windows
- Consider alternative authentication flows

---

**Last Updated:** February 4, 2026
✅ Windows build successful (without secure_storage)

### Phase 6 (Future)

⚠️ Need to address:

- Google Drive backup authentication
- Secure token storage on Windows
- Consider alternative authentication flows

---

**Last Updated:** February 4, 2026
