# Phase 2: Collect Evidence

## Evidence Collection

This phase guides collection and organization of evidence to support the bug report.

### Variables from Previous Phases

Required from previous phases:
- `FEATURE_NAME` - The feature name
- `TICKET_ID` - The ticket identifier
- `TICKET_PATH` - Path to ticket folder
- `BUG_ID` - Assigned bug ID
- `BUG_PATH` - Full path to bug file
- `MODE` - interactive or direct
- `BUG_DETAILS` - Details collected in Phase 1
- `PRESET_SEVERITY` - Severity if provided in direct mode (may be null)

---

## Evidence Collection Checklist

Present evidence types to collect:

```
Evidence Collection

Which types of evidence do you have for this bug?
Select all that apply (comma-separated, e.g., 1,2,5):

  [1] Screenshots / Recordings (file path)
  [2] Console / Browser logs (file path or paste)
  [3] API request / response (file path or paste)
  [4] Network traces (file path or HAR reference)
  [5] Error messages (paste text)
  [6] Other evidence

  [0] No additional evidence (skip)

Select types:
> [User input, e.g., "1,2,5"]
```

---

## Evidence Collection by Type

### Type 1: Screenshots / Recordings

If user selected [1]:

```
Screenshots / Recordings:

Enter file path(s), one per line. Type "DONE" when finished.
  Example: ./screenshots/checkout-error.png

> [User input - file path]
> [User input - file path]
> DONE
```

**Path Validation:**
- Check if file exists at specified path
- If file not found, warn but continue:
  ```
  Warning: File not found at [path]. Path will be recorded but verify it exists.
  ```

**Store as:**
```
EVIDENCE.screenshots = [
  { path: "[path1]", description: "[optional description]" },
  { path: "[path2]", description: "[optional description]" }
]
```

### Type 2: Console / Browser Logs

If user selected [2]:

```
Console / Browser Logs:

Option A: Provide file path
Option B: Paste log content directly

Choose [A/B]:
> [User input]
```

**If Option A (file path):**
```
Enter log file path:
> [User input]
```

**If Option B (paste content):**
```
Paste log content (type "END" on new line when done):
> [User input - multiline until "END"]
```

**AI Log Analysis (inline evidence-summarizer logic):**

Once logs are provided, analyze and extract key information:

```
Analyzing logs...

Key findings:
- [ERROR] [timestamp] [error message]
- [FATAL] [timestamp] [fatal error]
- Stack trace: [relevant trace lines]

Noise filtered: [X] INFO/DEBUG lines ignored
Errors found: [Y] ERROR/FATAL entries
```

**Store as:**
```
EVIDENCE.console_logs = {
  source: "[file path or 'pasted']",
  raw_content: "[full content]",
  analyzed: {
    errors: ["[error 1]", "[error 2]"],
    stack_traces: ["[trace 1]"],
    summary: "[AI-generated summary of key log findings]"
  }
}
```

### Type 3: API Request / Response

If user selected [3]:

```
API Request / Response:

Option A: Provide file path (JSON, HAR, or text)
Option B: Paste request/response directly

Choose [A/B]:
> [User input]
```

**If Option A:**
```
Enter API capture file path:
> [User input]
```

**If Option B:**
```
Paste API details in this format (or paste raw cURL/response):

Request:
  Method: [GET/POST/PUT/DELETE]
  URL: [endpoint]
  Headers: [relevant headers]
  Body: [request body if any]

Response:
  Status: [status code]
  Body: [response body]

Paste now (type "END" when done):
> [User input - multiline until "END"]
```

**Store as:**
```
EVIDENCE.api_data = {
  source: "[file path or 'pasted']",
  request: {
    method: "[method]",
    url: "[url]",
    headers: "[headers]",
    body: "[body]"
  },
  response: {
    status: "[status code]",
    body: "[body]"
  }
}
```

### Type 4: Network Traces

If user selected [4]:

```
Network Traces:

Enter file path to HAR file, request IDs, or correlation IDs:
> [User input]

Additional trace notes (or "None"):
> [User input]
```

**Store as:**
```
EVIDENCE.network_traces = {
  file_path: "[path or N/A]",
  request_ids: "[IDs if provided]",
  correlation_ids: "[IDs if provided]",
  notes: "[additional notes]"
}
```

### Type 5: Error Messages

If user selected [5]:

```
Error Messages:

Paste the exact error message(s) displayed to the user or in logs.
Type "END" on new line when done:

> [User input - multiline until "END"]
```

**Store as:**
```
EVIDENCE.error_messages = [
  "[Error message 1]",
  "[Error message 2]"
]
```

### Type 6: Other Evidence

If user selected [6]:

```
Other Evidence:

Describe the additional evidence:
> [User input - description]

File path (if applicable, or "None"):
> [User input]

Content (if pasting, type "END" when done, or "None"):
> [User input]
```

**Store as:**
```
EVIDENCE.other = {
  description: "[description]",
  file_path: "[path or None]",
  content: "[content or None]"
}
```

---

## Evidence Analysis (Inline Evidence-Summarizer Logic)

After collecting all evidence, perform analysis:

### Log Analysis Rules

**Filter noise:**
- Ignore DEBUG, TRACE, INFO level entries unless relevant
- Focus on ERROR, FATAL, WARN entries
- Extract exception stack traces

**Key patterns to identify:**
- Error codes and messages
- Stack traces with line numbers
- Timeout or connection errors
- Authentication/authorization failures
- Null pointer or undefined errors
- Database errors (SQL exceptions, connection failures)

### Root Cause Hypothesis Generation

Based on evidence analysis, generate initial hypothesis:

```
Evidence Analysis Complete

Evidence Summary:
- Screenshots: [count] files
- Logs: [count] error entries found
- API: [status code] response captured
- Network: [traces captured or N/A]
- Error messages: [count] messages

Root Cause Hypothesis:
[AI-generated hypothesis based on evidence patterns]

Example hypotheses:
- "API endpoint /checkout returns 500 due to unhandled null parameter"
- "Frontend validation passes but backend rejects invalid date format"
- "Session timeout occurs before request completion under slow network"
```

---

## Store Evidence Details

Compile all evidence into EVIDENCE_DETAILS variable:

```
EVIDENCE_DETAILS={
  screenshots: [...],
  console_logs: {...},
  api_data: {...},
  network_traces: {...},
  error_messages: [...],
  other: {...},
  analysis: {
    error_summary: "[key errors found]",
    root_cause_hypothesis: "[AI-generated hypothesis]"
  }
}
```

### Summary Display

```
Evidence collected:
- Screenshots: [count] files
- Logs: [analyzed/not provided]
- API data: [captured/not provided]
- Network traces: [captured/not provided]
- Error messages: [count] messages

Root cause hypothesis generated: [Yes/No]

Proceeding to Phase 3: Classify Severity
```

### Set Variables for Next Phase

Pass to Phase 3:
```
FEATURE_NAME=[feature-name]
TICKET_ID=[ticket-id]
TICKET_PATH=[path]
BUG_ID=[bug-id]
BUG_PATH=[path]
BUG_DETAILS=[details object]
EVIDENCE_DETAILS=[evidence object]
PRESET_SEVERITY=[severity if provided, else null]
```

### Next Phase

Continue to Phase 3: Classify Severity
