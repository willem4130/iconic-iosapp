# /commit - Build, Commit, and Push

Run build check, then commit with AI-generated message and push.

## Steps

1. **Build Check**
   ```bash
   xcodebuild -project IconicFestival.xcodeproj -scheme IconicFestival build CODE_SIGNING_ALLOWED=NO 2>&1 | grep -E "error:" | head -10
   ```
   If errors exist, fix them first. Do not commit broken code.

2. **Check for Changes**
   ```bash
   git status
   git diff --stat
   ```

3. **Stage and Commit**
   - Stage relevant files (not build artifacts)
   - Generate a concise commit message based on the changes
   - Format: `type: description` (e.g., `feat: add timetable view`, `fix: resolve navigation bug`)

4. **Push**
   ```bash
   git push
   ```

5. **Report** what was committed and pushed.
