# Test Case Standard

This standard defines the required structure and generation guidelines for all test cases to ensure consistency, reproducibility, observability, and importability into tools like Testmo.

## 1. Test Case Structure

All test cases must contain the following fields:

| Field | Description | Example |
| :--- | :--- | :--- |
| **ID** | Unique identifier | `TC-LOGIN-001` |
| **Title** | `[Module] - [Action] - [Expected Outcome]` | `Login - Enter Invalid Password - Show Error Message` |
| **Requirement / Risk IDs** | Links to user stories, BRD items, risk tags | `REQ-45`, `RISK-A11Y` |
| **Purpose** | Short statement of intent | `Validate lockout on invalid attempts` |
| **Type** | Functional, Regression, Smoke, API, Security, Performance, Accessibility |
| **Priority** | Critical, High, Medium, Low |
| **Automation Status** | `Manual`, `Automated`, `Planned` + repo path if automated |
| **Preconditions** | State before testing | `User is on Login Page` |
| **Test Data / Config** | Specific accounts, payloads, flags | `user=test1`, `flag new_login=ON` |
| **Steps** | Numbered list of actions | `1. Enter username...` |
| **Expected Result** | Measurable outcome | `Error message 'Invalid credentials' appears.` |
| **Postconditions** | State after testing | `User remains on Login Page` |
| **Observability Notes** | Logs, metrics, traces to monitor | `Check auth-service logs for code 401` |
| **Actual Result** | Filled during execution | `Pass`, `Fail`, notes |
| **Defect Link** | Reference bug ID when failing | `BUG-AUTH-023` |

## 2. Writing Guidelines

1. **Atomic Steps**: Each step is a single user or system action.
2. **Clear Expectations**: Include timings, messages, and state changes.
3. **Independence**: Avoid dependencies on other cases; describe setup explicitly.
4. **Data Privacy**: Use anonymized data or variables; reference fixtures.
5. **Accessibility & NFRs**: Note accessibility checks (WCAG), localization, performance thresholds, or resiliency requirements when applicable.

## 3. Coverage Checklist

Ensure suites address:
- [ ] **Happy Path**: Standard success flow.
- [ ] **Negative Path**: Invalid inputs, error states.
- [ ] **Boundary Values**: Min/Max limits, empty states, special chars.
- [ ] **Security & Permissions**: Auth, authorization, injection.
- [ ] **Accessibility**: Keyboard navigation, screen reader output, contrast.
- [ ] **Localization**: Languages, time zones, currency.
- [ ] **Performance/Resiliency**: Latency, throttling, retries, offline.
- [ ] **Observability**: Logs/metrics emitted as expected.

## 4. Example

```markdown
**ID**: TC-CART-005
**Requirement**: REQ-CART-12
**Title**: Cart - Add Item - Update Count
**Type**: Functional (Regression)
**Priority**: High
**Automation**: Manual (Planned automation in `tests/cart/add-item.spec.ts`)
**Preconditions**: User is on product page. Cart is empty.
**Test Data**: SKU=SKU-12345, Qty=1
**Steps**:
1. Click "Add to Cart" button.
2. Observe the cart icon in the header.
**Expected Result**: Cart icon badge updates from 0 to 1 within 1s; toast "Item added" appears.
**Observability Notes**: Verify `cart-service` log contains event `cart.item_added`.
**Actual Result**: _Filled during execution_
```
