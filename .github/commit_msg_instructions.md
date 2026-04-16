# Global Git Commit Instructions

Follow these commit message guidelines strictly.

## Format

<type>(<scope>)!: <JIRA-TICKET> <description>

[optional body]

[optional footer(s)]

- Leave exactly one blank line between the header line and the body.
- The description should summarize what the commit does in 50 characters or less, excluding the Jira ticket.
- The header line must always include the Jira ticket immediately after the colon.
- The first letter of the description text after the Jira ticket must be capitalized.
- Use lowercase for type and scope.
- Do not end the description with a period.
- Use imperative mood.

## Allowed types

Use one of the following types:
feat, fix, docs, style, refactor, perf, test, chore, ci, build, revert, deprecate.

You may also include scopes for clarity, for example:
api, ui, auth, accounts, onboarding.

- Do not use business entities or domain model names as scopes.
- If the change is in an API endpoint regarding a business entity, use `api` as the scope.

## Body

- The body should explain what and why, not how.
- Use bullet points (`*`) for multiline bodies.
- Wrap lines at around 72 characters.
- Keep it concise and relevant to the staged change only.

## Footer

- Footers are optional and used for metadata or references.
- Include `BREAKING CHANGE:` for incompatible updates.
- Reference Jira or related issues using `Refs:` or `Closes:`.

## Output

- Output only the final commit message text.
- Do not include explanations or commentary.
- Base the message only on the currently staged changes.
- If the Jira ticket cannot be inferred from the staged changes or branch name, use `NO-JIRA` as a fallback.

## Examples

feat(auth): PROJ-1234 Add JWT token refresh endpoint

* adds /auth/refresh-token endpoint
* supports biometric login renewal
* preserves fallback login behavior

fix(ui): PROJ-5678 Correct button alignment on mobile

refactor(api)!: PROJ-9012 Remove deprecated /v1/users route

BREAKING CHANGE: Old /v1/users is no longer available, use /v2/users instead.
Closes: PROJ-9012

chore(build): NO-JIRA Update spring boot to 3.3.2

docs: NO-JIRA Update README with environment setup instructions