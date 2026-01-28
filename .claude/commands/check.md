# /check - Run Code Quality Checks

Run build and lint checks for the iOS project.

## Steps

1. **SwiftLint** (if available)
   ```bash
   swiftlint lint IconicFestival/ 2>/dev/null || echo "SwiftLint not installed"
   ```

2. **Build Check**
   ```bash
   xcodebuild -project IconicFestival.xcodeproj -scheme IconicFestival build CODE_SIGNING_ALLOWED=NO 2>&1 | grep -E "error:|warning:" | head -20
   ```

3. **Report** any errors or warnings found.

If errors exist, list them clearly so they can be fixed.
