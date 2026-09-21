---
name: Selenium + Java test conventions
description: Best practices for Selenium WebDriver tests in Java.
applyTo: "**/src/test/java/**/*.java"
---

# Selenium + Java — test conventions

## Waiting & synchronisation
- Never use `Thread.sleep()`. Use explicit waits: `new WebDriverWait(driver, Duration.ofSeconds(10)).until(ExpectedConditions...)`.
- Do not mix implicit and explicit waits — pick explicit and stay consistent.

## Locators
- Prefer stable `By.id` / `By.cssSelector`; avoid absolute XPath.
- Encapsulate locators in the Page Object Model — no raw `findElement` calls in tests.

## Structure
- One Page Object per page/component; tests call page methods, never touch the DOM directly.
- Manage the driver in setup/teardown (`@BeforeEach`/`@AfterEach`); quit the driver reliably.
- Use `WebDriverManager` (or Selenium Manager) for driver binaries — no hardcoded driver paths.

## Assertions
- Use AssertJ or JUnit assertions with clear messages.

## Anti-patterns
- No `Thread.sleep`, no absolute XPath, no shared static WebDriver across tests, no logic in tests that belongs in a Page Object.
