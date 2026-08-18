# Task Creation: Dual Companion transports

## Goal

Ship one Companion experience that preserves the existing Frame/WebSocket path on stable Repeaters and adds Mobile Companion REST/SSE v1 where available. Operators can choose Auto, Companion API, or Legacy Frame per companion without duplicate RF sends, silent client eviction, or history loss.

## Context inspected

- `origin/main` Frame implementation in `frontend/src/lib/stores/useCompanionStore.ts` and `frontend/src/lib/meshcore-frame/`.
- REST/SSE implementation on `feat/companion-api`, including API commands, wire types, mappers, persistence, outbound ledger, store tests, and Companion UI.
- Repeater Mobile Companion API architecture, OpenAPI contract, legacy-state migration notes, and Frame-vs-REST parity inventory in `/Users/dduran/dev/openhop_repeater`.
- Approved product direction from 2026-08-13: existing users keep Frame behavior; new identities default to Auto; exactly one Console transport is active per selected companion.

## Requirements inventory

### Critical requirements

- One Console build must work with stable Frame-only Repeater and API-v1 Repeater.
- Preserve existing Frame behavior, IndexedDB history, protocol-gated controls, pause/resume, and external-client protection.
- Add Auto, Companion API, and Legacy Frame preferences keyed by full companion public key.
- Auto prefers positively detected API v1 and uses Frame only when API is definitively unsupported.
- Never fall back on authentication failures, transient API failures, malformed contracts, or SSE-only outages.
- Never run both Companion event feeds, evict a Frame client automatically, or replay an indeterminate operation through the other transport.
- Catalog discovery must remain available when `/api/v1/companions` is absent or failing.
- Existing identities with no saved preference and Frame enabled remain on Frame for the compatibility release; new/API-only identities default to Auto.

### Non-functional requirements

- Transport and persistence boundaries remain testable without React.
- Common UI behavior is driven by normalized capabilities rather than transport-name checks.
- Switching is atomic, identity-verified, generation-safe, and accessible to keyboard/screen-reader users.
- Existing configuration fields are preserved when not explicitly edited.
- No generated `frontend/dist`, release scripts, or publishing workflow changes in this implementation.

### Good-to-haves

- Session-only override from API failure to Frame.
- Additive telemetry for requested mode, active mode, probe result, and switch reason without message content.
- A future site-wide default layered beneath browser-local overrides.

### Stack and architecture context

- Stack: React 18, TypeScript, Zustand 5, Vite 6, Vitest/happy-dom.
- Boundaries: transport-neutral domain state and command outcomes; Frame and REST/SSE adapters; one session coordinator; existing store remains the UI facade.
- Integrations: legacy `/api/companion/*`, `/ws/companion_frame`, `/api/acl_info`, `/api/identities`, `/api/v1/server_info`, `/api/v1/companions`, REST sync/history/actions, SSE.
- Persistence: legacy per-key IndexedDB remains Frame-owned; REST cursor/epoch/outbound ledger remains REST-owned; preference and read state are full-key scoped.
- Constraint: current `origin/main` and `feat/companion-api` diverge, so implementation starts from fresh `origin/main` and ports reviewed API slices instead of merging the feature branch wholesale.

### Unknowns and assumptions

- Assumption: Console uses its existing operator JWT for API v1; pairing/device-token administration remains out of this UI scope.
- Assumption: 404/405 from the public discovery route is the compatibility signal for a Frame-only backend.
- Unknown: future site-wide policy persistence; browser-local preference is the approved first release behavior.

## Iteration layering

### Iteration 1: Compatibility seam

- Outcome: transport selection and capability policy exist as pure, red/green-tested code while Frame remains behaviorally unchanged.
- Scope: normalized modes, probe outcomes, persistence keys, catalog separation, adapter/session contracts.
- Deferred: REST runtime and UI selector.

### Iteration 2: End-to-end dual mode

- Outcome: one selected companion can bootstrap and operate through either Frame or REST/SSE, with an explicit mode selector and one active session.
- Scope: adapters, coordinator, store facade, common chat actions, safe switching, mode/status UX.
- Deferred: optional telemetry and broad visual polish.

### Iteration 3: Compatibility completion and hardening

- Outcome: Frame-only operator controls, persistence migration, failure states, old/new backend contract tests, browser smoke coverage, and documentation are complete.
- Scope: full capability matrix, migration/rollback tests, accessibility, exact failure copy, integration validation.
- Deferred: site-wide defaults and any deprecation of Frame.

## Vertical slices

1. **Prove transport selection without changing Frame runtime**
   - Value: existing users retain current behavior while selection rules become executable.
   - Work: add mode/capability/probe types, pure resolver, full-key preference persistence, and characterization tests.
   - Dependencies: approved behavior matrix.
   - Acceptance: old backend resolves Frame; compatible backend can resolve REST; auth/transient/SSE errors never silently choose Frame; existing-vs-new defaults are covered.
   - Verification: focused Vitest policy suite and typecheck.
   - Change Review focus: unsupported-vs-unavailable classification and migration default.

2. **Establish the adapter and session contract around the existing Frame path**
   - Value: Frame remains the compatibility baseline behind a real variation seam.
   - Work: extract wire/lifecycle effects from the store into a Frame session adapter, keeping protocol negotiation, ACL gating, queue drain, local history, and command behavior intact.
   - Dependencies: slice 1 contracts.
   - Acceptance: origin/main Frame characterization tests remain green; adapter bootstrap/events/actions produce normalized domain outcomes; no UI regression.
   - Verification: existing Frame, store-lifecycle, import, ownership, and hardware-conformance suites.
   - Change Review focus: no semantic change or client-eviction regression.

3. **Add REST/SSE v1 as a second adapter**
   - Value: API-enabled installations gain durable, multi-client chat without occupying Frame.
   - Work: port reviewed API commands/types/mappers, snapshot/sync/SSE session, outbound ledger, idempotent sends, supported actions, and adapter contract tests.
   - Dependencies: slice 1 contract; compatible Repeater fixture.
   - Acceptance: API bootstrap, history, reconnect, snapshot reset, safe retry, principal/key/epoch isolation, and actions pass focused tests.
   - Verification: REST adapter, wire, mapper, ledger, and fault-injection Vitest suites.
   - Change Review focus: idempotency and stale-context safety.

4. **Coordinate exactly one active Companion session**
   - Value: operators can choose transports without duplicate state or RF dispatch.
   - Work: add coordinator state machine, identity verification, sticky Auto behavior, transactional switching, operation drain/quarantine, and stale-generation guards; keep `useCompanionStore` as a thin facade.
   - Dependencies: slices 2 and 3.
   - Acceptance: one event consumer maximum; API SSE loss stays API; full-key mismatch fails closed; in-flight/indeterminate mutations prevent unsafe switch; old session events cannot mutate new state.
   - Verification: coordinator tests with both adapters and race/fault cases.
   - Change Review focus: lifecycle ownership and atomic switch invariants.

5. **Expose explicit connection choice and capability-aware UI**
   - Value: users understand and control the active path without confusing it with external Frame access.
   - Work: add Connection modal/radio cards, requested+active status, availability states, error recovery, takeover confirmation, and capability gating; rename/separate external Frame listener settings.
   - Dependencies: slice 4 state contract.
   - Acceptance: Auto/API/Frame can be selected; status names resolved transport; no automatic eviction; configured identities remain recoverable when API list fails; controls explain unavailable capability.
   - Verification: component tests plus browser interaction/a11y smoke.
   - Change Review focus: misleading empty/error states, keyboard behavior, and destructive confirmation.

6. **Preserve storage, settings, and rollback behavior**
   - Value: upgrading does not erase history, mutate inherited bindings, or cross-contaminate sessions.
   - Work: retain Frame IndexedDB, scope REST persistence, migrate selected conversation once, preserve missing listener settings, isolate paused state and unread lineage, and document legacy namespace adoption.
   - Dependencies: slices 2–5.
   - Acceptance: legacy history remains readable in Frame; REST never imports/replays it; listener edit round-trips unchanged fields; key/epoch/principal transitions isolate data; rollback path is documented.
   - Verification: migration, storage, configuration serialization, and rollback tests.
   - Change Review focus: data loss, credential/identity bleed, and configuration mutation.

7. **Validate the mixed-version release candidate**
   - Value: the exact integration SHA is demonstrably safe across supported deployments.
   - Work: run old/new backend fixtures, real browser smoke, full frontend gates, production build without packaging `dist`, and document supported matrix/limitations.
   - Dependencies: all prior slices.
   - Acceptance: old backend/Frame, new backend/API, dual-enabled, occupied Frame, dropped SSE, auth failure, upgrade, and rollback scenarios pass; no skipped critical tests.
   - Verification: Node 20 CI-equivalent commands, contract fixture lane, browser smoke, and change review.
   - Change Review focus: backward compatibility and proof quality.

## Risks and dependencies

- Store extraction is high-collision work; mitigate with characterization tests and slice-by-slice refactoring.
- Frame and REST do not share retry/history semantics; keep those concerns adapter-owned and never merge automatically.
- API-v1 is not on stable Repeater main; live validation requires the compatible backend worktree/fixture.
- Existing global lint debt prevents repository-wide lint from being a clean gate; enforce changed-file lint and record baseline separately.
- The release pipeline has independent security/versioning blockers and remains out of scope until this change passes review.

## Subagent opportunities

- Transport policy/persistence: pure module and tests, independent after contracts are fixed.
- REST adapter: API-specific files and tests, no Frame/store/UI edits.
- Frame adapter characterization/extraction: Frame-specific files and tests, no REST/UI edits.
- Parent integrates coordinator/store/UI and verifies all delegated diffs.

## Handoff

Next module: `implementation` because the behavior, boundaries, safety rules, rollout default, and proof gates are approved and sequenced.

### Checkpoint

Keystone checkpoint: task-creation -> implementation

- Completed: approved requirements converted into seven dependency-ordered vertical slices with acceptance and verification gates.
- Blocked by: none; isolated worktree is clean.
- Next check: write and observe the failing transport-policy tests before runtime edits.
- Action: continue now.
- Todo tail: Next / upcoming task: implementation — establish the red signal for slice 1 transport selection.

## Implementation checkpoint — 2026-08-13

- Implemented browser-local `Auto`, `Companion API`, and `Legacy Frame` selection per full public key while retaining the stable Frame catalog and listener controls.
- Added positively detected REST/SSE v1 sessions with pinned principal/key/epoch identity, durable idempotency, bounded server history, and no silent fallback for auth, transient, or invalid API failures.
- Preserved Frame ownership/ACL behavior and IndexedDB history; Frame now verifies the configured full identity before publishing state or opening storage.
- Added capability-aware UI, explicit active-path status, sparse channel-slot handling, old-v1 capacity compatibility, and transport-neutral connected/send behavior.
- Added race and isolation guards for switching, pause during mutation, credential refresh, cross-tab account changes, stale actions, snapshot lineage replacement, unread events, and terminal session failures.
- Added full-key catalog rebind quarantine that survives reloads and account changes per authenticated principal until an explicit selection acknowledges it.
- Verification: changed-file ESLint clean; TypeScript clean; 66 test files / 813 tests pass on the final rerun; production static build/package validation passes with existing chunk warnings; `git diff --check` passes. Generated `dist` output was restored to its exact pre-build state.
- One scheduler-sensitive `parsePacketPath` wall-clock ratio assertion transiently failed once; the isolated performance suite then passed three consecutive runs and the next complete 813-test run passed.
- Independent product and security change reviews are GREEN with no live P0–P2 blockers.
- Browser smoke reached and interacted with the login surface without console/runtime errors. An authenticated end-to-end Companion run still requires a live mixed-version backend fixture and credentials.
- No commit, merge, push, release, generated distribution, or publishing workflow change was made.

### Checkpoint

Keystone checkpoint: implementation -> change-review

- Completed: dual-transport compatibility implementation and local executable gates.
- Blocked by: no local implementation blocker; live authenticated mixed-backend proof remains an external integration gate.
- Next check: authenticated old-backend Frame and API-v1 backend browser smoke before promotion.
- Action: hand off the GREEN source branch without committing generated distribution artifacts.
