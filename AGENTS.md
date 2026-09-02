# AGENTS.md

Flutter plugin exposing the native iOS `PKAddPassButton` (Apple Wallet). Dart in `lib/`,
a Swift package in `ios/add_to_wallet/` split into a Swift target (`add_to_wallet`) and an
Objective-C target (`add_to_wallet_objc`), consumable by both SwiftPM and CocoaPods.

## Agent skills

### Issue tracker

GitHub Issues on `doitcare/add_to_apple_wallet`, via the `gh` CLI. This clone is a fork
with an `upstream` remote, so **every** `gh` call needs an explicit
`--repo doitcare/add_to_apple_wallet` or it targets the parent repo instead. See
`docs/agents/issue-tracker.md`.

### Triage labels

The five canonical roles, each label string equal to its name. See
`docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` and one `docs/adr/` at the repo root, both created lazily
by `/domain-modeling` rather than upfront. See `docs/agents/domain.md`.
