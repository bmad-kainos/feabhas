# Effort Estimation Reference

Quick reference for estimating testing effort for different ticket types.

## Unit Tests

### Quick (1-2 hours)
- Simple validation functions
- Single-method tests with fixtures
- 5-10 test cases per function
- Example: Certificate field validation, date parsing

### Medium (2-4 hours)
- Multiple related functions
- Mock setup required (certificates, API responses)
- Edge cases and error scenarios
- 15-25 test cases
- Example: Certificate chain validation, OAuth token parsing

## Integration Tests

### Quick (2-4 hours)
- Single workflow file validation
- GitHub Actions workflow syntax checks
- Simple environment variable validation
- 5-10 test cases
- Example: CI workflow triggers on PR, workflow syntax valid

### Medium (4-8 hours)
- Multi-step CI/CD validation
- Tool integration (pytest, coverage, linting)
- Build success/failure scenarios
- Credential retrieval (mocked)
- 15-30 test cases
- Example: Full CI pipeline, SonarQube integration, coverage gates

### High (8-12 hours)
- Complex pipeline orchestration
- Multiple environment configurations
- Advanced mocking/stubbing
- Deployment dry-runs
- 30+ test cases
- Example: Multi-environment deploy pipeline, infrastructure-as-code validation

## E2E Tests

### Medium (6-10 hours)
- Single external system integration
- API endpoint testing
- OAuth flow (with test provider)
- Basic security validation
- 10-20 test cases
- Example: API gateway deployment, single WAF rule test, request routing

### High (12-20 hours)
- Multiple external systems
- Complex workflows (proxy + auth + backend)
- Security testing (WAF multiple rules, malicious payloads)
- Full deployment verification
- 20-50 test cases
- Example: Full gateway deployment + OAuth + a core API endpoint, comprehensive WAF testing

### Very High (20+ hours)
- Full system integration
- Multi-provider tests (OAuth + certificate + multiple APIs)
- Load testing or performance validation
- Multiple environment rollout
- 50+ test cases

## Effort Factors

### Reduces Effort (-1-2 hours)
- ✅ Existing test framework/fixtures
- ✅ Mock/stub libraries available
- ✅ Clear AC acceptance criteria
- ✅ Previous similar tests in codebase
- ✅ Test environment pre-provisioned

### Increases Effort (+1-3 hours)
- ❌ Need to build custom mocks
- ❌ External service test access unavailable
- ❌ Credentials/secrets setup required
- ❌ Flaky/unreliable test environment
- ❌ Complex data preparation
- ❌ Multiple dependent tickets

### Significant Blockers (+4-8 hours or Makes Automated Testing Impossible)
- ❌❌ No test environment available
- ❌❌ External partner integration (limited test access)
- ❌❌ One-time infrastructure setup (not repeatable)
- ❌❌ Manual approval required between steps
- ❌❌ Non-deterministic behavior (race conditions, timing-dependent)

## Ticket Type Patterns

### Infrastructure/Deployment Tickets
- **Usually**: Integration or E2E
- **Example**: "Deploy to the API gateway", "Configure WAF"
- **Typical effort**: 8-15 hours
- **Risk**: Often requires actual environment; may need manual validation first

### Validation/Certificate Tickets
- **Usually**: Unit
- **Example**: "Validate certificates", "Cover validation"
- **Typical effort**: 2-4 hours
- **Risk**: Low; testable in isolation

### CI/CD/Pipeline Tickets
- **Usually**: Integration
- **Example**: "Implement CI workflow", "SonarQube integration"
- **Typical effort**: 4-8 hours
- **Risk**: Medium; depends on GitHub Actions test harness

### API/Proxy Tickets
- **Usually**: E2E
- **Example**: "Deploy proxy", "Call API via the gateway"
- **Typical effort**: 10-20 hours
- **Risk**: High; requires multiple external systems

### Tools/Utilities Tickets
- **Usually**: Unit
- **Example**: "Create analysis skill", "Git history tool"
- **Typical effort**: 3-6 hours
- **Risk**: Low; testable with mocks/fixtures

## Estimation Rules of Thumb

1. **Unit tests**: ~0.5-1 hour per function, +1-2 hours for setup
2. **Integration tests**: ~1-2 hours per integration point, +2-4 hours for mocking
3. **E2E tests**: ~2-3 hours per external system, +3-5 hours for environment setup
4. **Infrastructure tests**: ~4-6 hours minimum (manual validation often required first)

## Example Ticket Analysis

### Example Unit Ticket
- 1 component (e.g. a validator or parser)
- 4 test areas (happy path, edge cases, boundary values, error handling)
- ~15-20 test cases
- Mocking: Simple (mock dependencies or use test data)
- **Estimated: 2-3 hours**

### Example Integration Ticket
- 1 workflow (e.g. a CI step or service interaction)
- 4-5 test scenarios (trigger, pass, fail, error path)
- ~10-15 test cases
- Mocking: Medium (mock events or external services)
- **Estimated: 4-6 hours**

### Example E2E Ticket
- 3 systems (e.g. API gateway, auth provider, backend service)
- 5-6 test scenarios (auth, routing, data flow, error handling)
- ~15-25 test cases
- Mocking: Low (need real systems for full E2E)
- Setup: Medium (credentials, environment configuration)
- **Estimated: 12-16 hours**

---

**Note**: These estimates assume:
- Developer has basic familiarity with pytest/testing
- Test infrastructure is available
- Environments are pre-provisioned
- Acceptance criteria are clear

Adjust up to +50% if this is your first time with the tech stack.
