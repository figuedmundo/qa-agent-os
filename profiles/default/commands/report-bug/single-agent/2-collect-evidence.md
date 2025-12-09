# Phase 2: Supporting Materials Organization

## Purpose

Guide the user through providing evidence (screenshots, logs, videos, artifacts) and organize them into appropriate subfolders.

---

## Overview

Supporting materials provide crucial evidence for bug investigation. This phase helps organize materials into semantic subfolders:

- **screenshots/** - Visual evidence (PNG, JPG, GIF)
- **logs/** - Text diagnostic output (TXT, LOG)
- **videos/** - Screen recordings (MP4, MOV, WebM, AVI)
- **artifacts/** - Complex files (HAR, JSON, SQL, XML, CSV)

---

## Step 1: Supporting Materials Menu

Explain the evidence collection process:

```
Supporting Materials Collection
================================

You can add evidence to help investigate this bug:

Evidence Types:
  [1] Screenshot - Visual evidence (PNG, JPG, GIF)
  [2] Log - Console or server logs (LOG, TXT)
  [3] Video - Screen recording (MP4, MOV, WebM)
  [4] Artifact - Network traces, configs, SQL (HAR, JSON, SQL)
  [5] Done - Finish collecting evidence

You can add multiple items of each type.

Which evidence would you like to add? [1-5]:
```

---

## Step 2: For Each Evidence Item

Based on user selection, collect evidence:

### Option 1: Screenshot

```
Screenshot Evidence
===================

File types: PNG, JPG, GIF

Enter file path:
  (absolute path or relative from current directory)
  Example: /Users/name/screenshots/login-error.png
           or: ./screenshots/checkout-form.png

File path:
```

**Validation:**
```bash
# Validate file exists
if [[ ! -f "$file_path" ]]; then
  echo "ERROR: File not found: $file_path"
  echo "Please provide a valid file path."
  # Loop back for retry
fi

# Validate file type
if [[ ! "$file_path" =~ \.(png|jpg|jpeg|gif)$ ]]; then
  echo "WARNING: File may not be an image"
  echo "Supported: PNG, JPG, JPEG, GIF"
  echo "Continue anyway? [y/n]:"
fi
```

**If valid:**
```
Collect description:

What does this screenshot show?
  Example: "Login form validation error displayed to user"

Description:
```

**Store for attachment:**
```
MATERIAL_TO_ADD=[
  source_path=/absolute/path/to/login-error.png
  target_subfolder=screenshots
  target_filename=login-error.png
  description="Login form validation error displayed to user"
]
```

### Option 2: Log File

```
Log File Evidence
=================

File types: LOG, TXT

Enter file path:
  Example: /var/log/app.log
           or: ./logs/error.txt

File path:
```

**Validation:**
```bash
# Validate file exists and is readable
if [[ ! -r "$file_path" ]]; then
  echo "ERROR: File not found or not readable: $file_path"
  echo "Please provide a valid file path."
  # Loop back for retry
fi

# Validate file type (optional warning)
if [[ ! "$file_path" =~ \.(log|txt|out)$ ]]; then
  echo "WARNING: File may not be a log file"
  echo "Supported: LOG, TXT, OUT"
  echo "Continue anyway? [y/n]:"
fi
```

**Collect timestamp info:**
```
Log File Information:

When was this log generated?
  Example: "2025-12-08 14:30:00" or "This morning"

Timestamp/Context:
```

**Store for attachment:**
```
MATERIAL_TO_ADD=[
  source_path=/var/log/app.log
  target_subfolder=logs
  target_filename=error-2025-12-08-14-30.log
  description="Browser console errors during login attempt (2025-12-08 14:30)"
]
```

### Option 3: Video Recording

```
Video Recording Evidence
========================

File types: MP4, MOV, WebM, AVI

Enter file path:
  Example: /Users/name/videos/login-repro.mp4
           or: ./videos/checkout-flow.mov

File path:
```

**Validation:**
```bash
# Validate file exists
if [[ ! -f "$file_path" ]]; then
  echo "ERROR: File not found: $file_path"
  # Loop back
fi

# Validate file type
if [[ ! "$file_path" =~ \.(mp4|mov|webm|avi)$ ]]; then
  echo "WARNING: File type may not be a video"
  echo "Supported: MP4, MOV, WebM, AVI"
  echo "Continue anyway? [y/n]:"
fi
```

**Collect description:**
```
What does this video demonstrate?
  Example: "Complete repro steps: login → email error → submit → no feedback"

Description:
```

**Store for attachment:**
```
MATERIAL_TO_ADD=[
  source_path=/Users/name/videos/login-repro.mp4
  target_subfolder=videos
  target_filename=login-repro.mp4
  description="Screen recording: login form validation error reproduction"
]
```

### Option 4: Artifact (HAR, JSON, SQL, configs)

```
Artifact Evidence
=================

File types: HAR, JSON, SQL, XML, CSV, Config dumps

Enter file path:
  Example: /Users/name/traces/network-error.har
           or: ./artifacts/request-payload.json

File path:
```

**Collect artifact type:**
```
What type of artifact?
  [1] Network Trace (HAR file)
  [2] API Payload (JSON)
  [3] Database Query (SQL)
  [4] Configuration (Config, XML)
  [5] Other (CSV, dump, etc.)

Select [1-5]:
```

**Store for attachment:**
```
MATERIAL_TO_ADD=[
  source_path=/Users/name/traces/network-error.har
  target_subfolder=artifacts
  target_filename=network-trace-login-failure.har
  description="Network trace showing failed login API request with 401 response"
]
```

---

## Step 3: Copy File to Bug Folder

After validating file:

```bash
# Create target path
target_path="$BUG_FOLDER_PATH/$target_subfolder/$target_filename"

# Copy file (preserving original)
cp "$source_path" "$target_path"

if [[ $? -eq 0 ]]; then
  echo "✓ File copied to: $target_subfolder/$target_filename"
else
  echo "ERROR: Failed to copy file"
  echo "Proceeding without this file."
fi
```

**Organize files:**
```
Bug folder structure will be:
  BUG-003-payment-timeout/
  ├── bug-report.md
  ├── screenshots/
  │   ├── loading-spinner.png
  │   └── timeout-message.png
  ├── logs/
  │   ├── browser-console-2025-12-08.log
  │   └── network-request.txt
  ├── videos/
  │   └── repro-steps.mp4
  └── artifacts/
      ├── network-trace-failed.har
      └── request-payload.json
```

---

## Step 4: Add More Materials or Continue

After each material is added:

```
Evidence item added: screenshots/login-error.png

Would you like to add more evidence?
  [1] Add another screenshot
  [2] Add a log file
  [3] Add a video
  [4] Add an artifact
  [5] I'm done collecting evidence

Select [1-5]:
```

**Track all materials for Attachments section:**

```
Materials collected:
  - screenshots/login-error.png - "Validation error"
  - logs/browser-console-2025-12-08.log - "Error stack trace"
  - videos/repro-steps.mp4 - "Reproduction steps"
```

---

## Step 5: No Materials Added

If user selects "Done" without adding materials:

```
No evidence materials added.

This is acceptable for bugs with clear text descriptions.
However, supporting evidence helps with investigation.

Would you like to:
  [1] Add evidence now
  [2] Continue without evidence (can add later with /revise-bug)

Select [1-2]:
```

---

## Set Variables for Next Phase

Collect all materials:

```
Export variables:
  MATERIALS=[
    array of objects:
    {
      subfolder: "screenshots"
      filename: "login-error.png"
      description: "Validation error message"
    },
    {
      subfolder: "logs"
      filename: "browser-console-2025-12-08.log"
      description: "JavaScript errors during submission"
    },
    ...
  ]
```

---

## Success Message

```
✓ Supporting materials collected:
  - Screenshots: 2 files
  - Logs: 1 file
  - Videos: 1 file
  - Artifacts: 2 files
  Total: 6 evidence items

✓ Files organized in subfolders:
  - screenshots/
  - logs/
  - videos/
  - artifacts/

Proceeding to Phase 3: Severity Classification
```

---

## If No Materials

```
✓ No supporting materials added

You can add evidence later using:
  /revise-bug BUG-003 --add-evidence

Proceeding to Phase 3: Severity Classification
```

---

*Organized supporting materials enable faster bug investigation and resolution.*
