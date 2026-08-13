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

## 0.0.2

* Add `onPressed` registering on addToWallet button pressed

## 0.0.1

* Expose AddToWallet widget to render native iOS
