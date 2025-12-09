# Continue Template Elimination Implementation

**Quick Start:** When you're ready to continue, start here.

---

## What's Been Done ✅

1. ✅ Created 3 unified standards (bug-reporting, test-plan, test-cases)
2. ✅ Created feature standards folder
3. ✅ Completed bug reporting workflow
4. ✅ **Saved ~1,630 lines of duplication** (40-50% reduction)

---

## What's Next ⏳

**6 tasks remaining** (~90 minutes):

1. Update `requirement-analysis.md` workflow (10 min)
2. Update `testcase-generation.md` workflow (10 min)
3. Update 3 command phase files (30 min)
4. Delete `templates/` folder - **BACKUP FIRST** (10 min)
5. Delete old duplicate standards (10 min)
6. Update CHANGELOG.md (15 min)

---

## Start Here

### Option A: Read Full Guide
📖 **File:** `implementation/IMPLEMENTATION_GUIDE.md`
- Complete step-by-step instructions
- Exact file paths and line numbers
- Code snippets for all changes
- **Recommended if first time continuing**

### Option B: Quick Status
📊 **File:** `implementation/STATUS.md`
- Progress summary
- What's done vs remaining
- Time estimates
- **Good for quick check-in**

### Option C: Resume with Claude

Just say: **"Continue template elimination from Task 6"**

Claude will:
1. Read the implementation guide
2. Start with Task 6 (update requirement-analysis workflow)
3. Work through tasks 6-11 sequentially
4. Test after each command update

---

## Commands to Continue

```bash
# Option 1: Ask Claude to continue
"Continue template elimination implementation from Task 6"

# Option 2: Manual - Start with Task 6
"Update requirement-analysis.md workflow to reference test-plan.md standard"

# Option 3: Do remaining tasks yourself
# Follow IMPLEMENTATION_GUIDE.md step-by-step
```

---

## Important Reminders

⚠️ **Before deleting templates folder:**
```bash
cp -r profiles/default/templates/ profiles/default/templates.backup/
```

⚠️ **Test after each command update:**
- `/plan-ticket` → After Task 8b
- `/generate-testcases` → After Task 8c
- `/report-bug` → After Task 8a

✅ **Commit progress frequently:**
```bash
git add .
git commit -m "Template elimination: [describe what you just completed]"
```

---

## Quick File Reference

**Standards Created (✅ Done):**
- `standards/bugs/bug-reporting.md`
- `standards/testcases/test-plan.md`
- `standards/testcases/test-cases.md`
- `standards/features/feature-knowledge.md`
- `standards/features/feature-test-strategy.md`

**Workflows to Update (⏳ Todo):**
- `workflows/testing/requirement-analysis.md` (Task 6)
- `workflows/testing/testcase-generation.md` (Task 7)

**Command Files to Update (⏳ Todo):**
- `commands/report-bug/single-agent/4-generate-report.md` (Task 8a)
- `commands/plan-ticket/single-agent/3-analyze-requirements.md` (Task 8b)
- `commands/generate-testcases/single-agent/3-generate-cases.md` (Task 8c)

**To Delete (⏳ Todo):**
- `templates/` folder (Task 9) - BACKUP FIRST
- Old bug standards (Task 10a)
- Old testcase standards (Task 10b)

---

**Ready to continue?**

Pick one of the options above and let's finish this! 🚀
