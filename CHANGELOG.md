## 1.1.2

No changes to the plugin. Repo tooling only: added `AGENTS.md` and `docs/agents/`, which
configure the issue tracker, triage labels and domain-doc layout that the engineering
skills read. None of it ships to consumers, so upgrading from 1.1.1 is a no-op.

## 1.1.1

* Synced `s.version` in `add_to_wallet.podspec`, which was still `0.0.1` while the
  package was at `1.1.0`.
* Documented the 1.1.0 event routing fixes below — they were shipped but never
  written down, so consumers had no warning that `onPressed` starts firing.
* Dropped the `onPassAdded` flag from the platform view creation params. It was sent
  on every build but never read by `PKAddPassButtonNativeView`.
* The dispatcher test for unknown keys now asserts. It had no `expect`, so it passed
  even when routing was broken.

## 1.1.0

**Breaking requirements**

* Minimum Flutter is now **3.44.0**. The Swift package declares a dependency on the
  `FlutterFramework` Swift package, which Flutter only generates from 3.44.0 onwards.
* Minimum iOS deployment target is now **13.0** (was 8.0 in the podspec).

**Changes**

* Added Swift Package Manager support. The iOS sources moved from `ios/Classes/` to a
  Swift package at `ios/add_to_wallet/`, split into a Swift target (`add_to_wallet`) and
  an Objective-C target (`add_to_wallet_objc`) as SwiftPM requires. Apps on Flutter 3.44+
  pick this up automatically; no consumer changes are needed.
* CocoaPods is still fully supported — the podspec builds both targets as a single pod.
* The Objective-C `AddToWalletPlugin` registration shim was removed and the Swift plugin
  class renamed `SwiftAddToWalletPlugin` → `AddToWalletPlugin`. This is transparent if you
  rely on the generated plugin registrant, but breaks code that calls
  `SwiftAddToWalletPlugin.register(with:)` directly.
* Added an empty `PrivacyInfo.xcprivacy` privacy manifest.

**Breaking behaviour — event routing fixed**

Both bugs below predate 1.1.0 and made the button's callbacks unusable. Fixing them
changes what existing consumers observe at runtime:

* `onPressed` now fires. `_invokeAddButtonPressed()` had no caller, so
  `add_button_pressed` never reached Dart and the documented `onPressed` API never
  fired at all. Any navigation, analytics or state mutation in an `onPressed`
  callback will start executing where it previously did not.
* `onPassAdded` is now scoped to the button that was actually tapped.
  `AddToWalletButton` used to call `setMethodCallHandler` on the shared
  `add_to_wallet` channel from `onPlatformViewCreated`. A channel holds exactly one
  handler, so this replaced `AddToWallet`'s dispatcher and destroyed key based
  routing: `onPassAdded` fired on whichever button mounted last, regardless of which
  one was tapped, and the handler was never removed on dispose. Both callbacks now
  go through the existing per key handler, dispatched on `call.method`, and the
  handler is removed in `dispose()`.

## 1.0.0

* Add an `onPassAdded` callback to `AddToWalletButton`, invoked once a pass has
  been added to the library.
* Various fixes to platform view recreation when button parameters change.

(Retroactive entry — releases between 0.0.2 and 1.0.0 were not recorded here.)

## 0.0.2

* Add `onPressed` registering on addToWallet button pressed

## 0.0.1

* Expose AddToWallet widget to render native iOS
