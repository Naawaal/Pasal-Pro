# Deployment Guide

**Status:** Phase 7 - Documentation  
**Last Updated:** February 5, 2026  
**Target Platforms:** Windows (Primary), Linux, macOS

---

## 📦 Build Overview

### Release Optimization

Pasal Pro is optimized for **desktop deployment** with offline-first, local database storage (Isar). No backend API calls required for core functionality.

```
Build Strategy:
├─ Debug:   Development testing
├─ Profile: Performance profiling
└─ Release: Production deployment (optimized)
```

### Binary Sizes (Approximate)

| Platform    | Debug  | Profile | Release |
| ----------- | ------ | ------- | ------- |
| **Windows** | ~150MB | ~120MB  | ~75MB   |
| **Linux**   | ~140MB | ~110MB  | ~70MB   |
| **macOS**   | ~160MB | ~130MB  | ~80MB   |

---

## 🖥️ Windows Deployment (Primary)

### Build Release Binary

```bash
# 1. Ensure no uncommitted changes
git status

# 2. Clean previous builds
flutter clean

# 3. Build optimized binary
flutter build windows --release

# Output location
bin/windows/Release/pasal_pro.exe
```

### Build Results

```
Build output:
├─ pasal_pro.exe          [Main executable]
├─ other DLLs             [Runtime dependencies]
└─ resources/             [Assets, fonts, translations]

Size: ~75MB
Build time: 3-5 minutes
```

### Testing Before Release

```bash
# 1. Run release binary standalone
./build/windows/x64/Release/pasal_pro.exe

# 2. Verify all features work offline
# - Add products
# - Create sales
# - View dashboard
# - Test search and filtering

# 3. Check performance
# - Product search < 500ms
# - Sale entry < 2 seconds
# - Dashboard load < 1 second

# 4. Check file sizes
dir build/windows/x64/Release
```

### Distribution

**Option 1: Standalone EXE (Recommended)**

```
Deliver: build/windows/x64/Release/pasal_pro.exe
Users: Double-click to run, no installation needed
Pros: Simple, portable, no admin rights
Cons: No Start menu shortcut, no uninstall
```

**Option 2: MSIX Installer**

```bash
# Create Store package
flutter build windows --release --dart2js-optimization O4

# Manual steps:
# 1. Open Visual Studio or MSIX Packaging Tool
# 2. Create new package from build output
# 3. Sign with self-signed certificate
# 4. Distribute .msix file

# Users: Double-click .msix to install via Microsoft Store
```

**Option 3: InnoSetup Installer (Advanced)**

```bash
# 1. Install InnoSetup (free)
# 2. Create .iss configuration
# 3. Compile to create installer.exe
# 4. Users run installer.exe

# Benefits:
# - Start menu shortcuts
# - Uninstall support
# - File associations
```

### Portable Folder Distribution

```bash
# 1. Copy Release folder
xcopy /E /I build\windows\x64\Release Output\pasal_pro\

# 2. Create batch launcher
echo @echo off > Output\run_pasal_pro.bat
echo cd pasal_pro >> Output\run_pasal_pro.bat
echo pasal_pro.exe >> Output\run_pasal_pro.bat

# 3. Zip entire Output folder
# Users extract and run: pasal_pro\pasal_pro.exe
```

---

## 🐧 Linux Deployment

### Build Release Binary

```bash
# Binary builds for both x64 and ARM
flutter build linux --release

# Output location
build/linux/x64/release/pasal_pro
```

### Distribution

**AppImage (Recommended for Linux)**

```bash
# Install appimagetool
sudo apt-get install appimagetool

# Create AppImage
./build_appimage.sh build/linux/x64/release/pasal_pro

# Result: pasal_pro.AppImage
# Users: chmod +x pasal_pro.AppImage && ./pasal_pro.AppImage
```

**Snap Package**

```bash
# snapcraft.yaml configuration required
snapcraft
# Creates: pasal-pro.snap
```

---

## 🍎 macOS Deployment

### Build Release Binary

```bash
# x86_64 (Intel)
flutter build macos --release

# ARM64 (Apple Silicon)
flutter build macos --release --target-arch=arm64

# Universal (both architectures)
flutter build macos --release --universal
```

### Distribution

**Standalone .app Bundle**

```
Location: build/macos/Build/Products/Release/pasal_pro.app
Size: ~80MB
Distribution: ZIP and upload to website
Users: Double-click to run (may see "unidentified developer" warning)
```

**Code Signing (Optional but Recommended)**

```bash
# 1. Get Apple Developer certificate
# 2. Export to .p8 file

# 3. Sign the app
codesign --deep --force --verify --verbose \
  --sign "Developer ID Application" \
  build/macos/Build/Products/Release/pasal_pro.app

# 4. Notarize (if distributing outside App Store)
xcrun altool --notarize-app --primary-bundle-id <bundle-id> \
  --username <apple-id> --password <password>
```

---

## 🎯 Pre-Release Checklist

### Code Quality

- [ ] `flutter analyze` returns 0 issues
- [ ] `flutter test` passes 100%
- [ ] No unused dependencies in pubspec.yaml
- [ ] Version number updated in pubspec.yaml
- [ ] Changelog updated
- [ ] All comments are professional

### Functionality Testing

- [ ] App launches successfully
- [ ] All features work offline
- [ ] Sample data loads correctly
- [ ] Database saves/loads properly
- [ ] Navigation works smoothly
- [ ] No crashes or exceptions
- [ ] Performance meets targets
  - [ ] Search < 500ms
  - [ ] Sale entry < 2 seconds
  - [ ] Dashboard < 1 second

### Accessibility

- [ ] All text readable (contrast, size)
- [ ] Input fields properly labeled
- [ ] Keyboard navigation works
- [ ] Error messages clear

### Documentation

- [ ] README.md updated
- [ ] CHANGELOG.md updated
- [ ] Help text in app is clear
- [ ] Version number matches everywhere

---

## 📝 Version Management

### Updating Version

```yaml
# pubspec.yaml
version: 1.0.0+1
#       ^ Semantic versioning (Major.Minor.Patch)
#                 ^ Build number (increments with each release)
```

### Version Scheme (Semantic Versioning)

```
1.2.3
│ │ └─ Patch: Bug fixes, minor changes
│ └─── Minor: New features, backward compatible
└───── Major: Breaking changes, major revamp

Examples:
1.0.0  - Initial release
1.0.1  - Bug fix
1.1.0  - New feature (Dashboard)
2.0.0  - Complete redesign or breaking changes
```

### Changelog Format

```markdown
## [1.1.0] - 2026-02-05

### Added

- Dashboard with real-time metrics
- Product search functionality
- Customer credit ledger

### Fixed

- Stock calculation errors
- Price formatting in reports

### Changed

- Improved UI responsiveness
- Updated database schema

## [1.0.0] - 2026-01-01

### Added

- Initial release
- Product management
- Fast sales entry
```

---

## 🚀 Release Process

### Step 1: Prepare Release Branch

```bash
# 1. Update version in pubspec.yaml
#    version: 1.1.0+5

# 2. Update CHANGELOG.md
#    Add new section with changes

# 3. Commit changes
git add pubspec.yaml CHANGELOG.md
git commit -m "chore: release v1.1.0"

# 4. Tag release
git tag -a v1.1.0 -m "Release version 1.1.0"
git push origin main --tags
```

### Step 2: Build All Platforms

```bash
# Windows
flutter build windows --release

# Linux
flutter build linux --release

# macOS
flutter build macos --release --universal
```

### Step 3: Test Release Binaries

```bash
# Windows: Run final binary
./build/windows/x64/Release/pasal_pro.exe

# Linux: Test binary
./build/linux/x64/release/pasal_pro

# macOS: Test bundle
open build/macos/Build/Products/Release/pasal_pro.app
```

### Step 4: Create Distribution Packages

```bash
# Windows
# Option A: Standalone
xcopy /E /I build\windows\x64\Release dist\pasal_pro_windows_v1.1.0\

# Option B: Create installer with InnoSetup
# (Use IDE for this)

# Linux
mkdir dist/pasal_pro_linux_v1.1.0
cp build/linux/x64/release/pasal_pro dist/pasal_pro_linux_v1.1.0/

# macOS
ditto build/macos/Build/Products/Release/pasal_pro.app \
  dist/pasal_pro_macos_v1.1.0.app
```

### Step 5: Create Release Notes

```markdown
# Pasal Pro v1.1.0 Release Notes

**Release Date:** February 5, 2026

## New Features

- Dashboard with real-time sales metrics
- Improved product search (100ms response)
- Customer credit history tracking

## Bug Fixes

- Fixed stock calculation decimal precision
- Fixed timezone issue in transaction dates
- Fixed crash when adding product with special characters

## Performance

- 30% faster dashboard load time
- Optimized database queries for search
- Reduced memory usage by 15MB

## System Requirements

- **Windows:** 7 SP1 or later, 4GB RAM
- **Linux:** Ubuntu 18.04 or later
- **macOS:** 10.12 or later

## Installation

1. Download `pasal_pro_windows_v1.1.0` for your platform
2. Extract to folder
3. Run `pasal_pro.exe` (Windows) or `./pasal_pro` (Linux)

## Support

For issues, visit: [GitHub Issues](https://github.com/YourOrg/pasal-pro/issues)
```

### Step 6: Upload & Announce

```bash
# Create GitHub Release
# 1. Go to: https://github.com/YourOrg/pasal-pro/releases
# 2. Click "Create a new release"
# 3. Select tag: v1.1.0
# 4. Add release notes
# 5. Upload binaries:
#    - pasal_pro_windows_v1.1.0.zip
#    - pasal_pro_linux_v1.1.0.zip
#    - pasal_pro_macos_v1.1.0.dmg
# 6. Publish release
```

---

## 📊 Performance Optimization

### Build Size Reduction

```bash
# Check what's taking space
flutter build windows --analyze-size --release

# Output shows:
# Libraries: 26.5 MB
# Dart code: 15.2 MB
# Assets: 8.3 MB
# Other: 5.0 MB
```

### Unused Code Removal

```bash
# Before release, check for dead code
flutter build windows --release --obfuscate

# Results in smaller binary but harder to debug
# Only use for production releases
```

### Asset Optimization

- [ ] Images compressed with TinyPNG
- [ ] Fonts subsetted for required characters
- [ ] Unused translations removed
- [ ] Duplicate assets consolidated

---

## 🔍 Monitoring After Release

### User Feedback Channels

1. **GitHub Issues:** Bug reports and feature requests
2. **Email:** Support contact
3. **In-app Feedback:** (Future Phase 8+)

### Tracking Metrics

```
Track over the first month:
- Download count
- Crash rate
- User feedback volume
- Performance issues
- Feature requests
```

### Hotfix Process

If critical bug found post-release:

```bash
# 1. Create hotfix branch from tag
git checkout -b hotfix/critical-fix v1.1.0

# 2. Fix bug
# (Make minimal changes)

# 3. Bump patch version
#    version: 1.1.1+6

# 4. Test thoroughly
flutter test --coverage

# 5. Release as v1.1.1
git tag -a v1.1.1 -m "Hotfix for critical bug"
git push --tags
```

---

## 🔐 Security Considerations

### Before Release

- [ ] No hardcoded API keys or credentials
- [ ] No debug logging of sensitive data
- [ ] Database encryption enabled (if needed)
- [ ] User data properly validated
- [ ] No unnecessary permissions requested

### User Data Protection

```dart
// Database is local - no cloud storage
// User data stored exclusively in Isar database
// Periodic backups available through app

// Backup location: User's Documents folder
// Export format: JSON + Database snapshot
```

---

## 📞 Common Issues & Solutions

### Issue: "Build is too slow"

**Solution:**

- Use Profile build for testing (`flutter build windows --profile`)
- Don't rebuild everything: Use hot reload during development
- Check available disk space

### Issue: "Binary won't run on user's machine"

**Solution:**

- Ensure Windows 7 SP1 or later
- Check for missing Visual C++ Runtime
- Provide vcredist_x64.exe alongside binary
- Test on older machine before release

### Issue: "macOS shows 'unidentified developer'"

**Solution:**

- Right-click app → Open (bypass warning)
- User can then open normally in future
- Or: Sign with Apple Developer certificate (requires paid account)

### Issue: "App crashes on startup"

**Solution:**

- Check log files in user's Documents/.pasal_pro/
- Enable verbose logging: Set `AppLogger.level = LogLevel.debug`
- Test exact same Windows version as user

---

## 📚 Related Documentation

- [README.md](../README.md) - Project overview
- [DEVELOPMENT.md](DEVELOPMENT.md) - Development setup
- [TESTING.md](TESTING.md) - Testing before release
- [ARCHITECTURE.md](ARCHITECTURE.md) - System design

---

## Summary

✅ **Quick Release (Windows):**

```bash
flutter clean
flutter build windows --release
# Executable: build/windows/x64/Release/pasal_pro.exe
```

✅ **All Platforms Multi-Release:**

- Windows: 75MB executable
- Linux: 70MB executable
- macOS: 80MB universal binary

✅ **Version Bumping:** Major.Minor.Patch in pubspec.yaml

✅ **Pre-Release Checklist:** 15+ items to verify before shipping

**Next:** See [DEVELOPMENT.md](DEVELOPMENT.md) for development workflow or [TESTING.md](TESTING.md) for pre-release testing.
flutter clean
flutter build windows --release

# Executable: build/windows/x64/Release/pasal_pro.exe

```

✅ **All Platforms Multi-Release:**

- Windows: 75MB executable
- Linux: 70MB executable
- macOS: 80MB universal binary

✅ **Version Bumping:** Major.Minor.Patch in pubspec.yaml

✅ **Pre-Release Checklist:** 15+ items to verify before shipping

**Next:** See [DEVELOPMENT.md](DEVELOPMENT.md) for development workflow or [TESTING.md](TESTING.md) for pre-release testing.
```
