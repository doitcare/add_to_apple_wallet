# AddToWallet Flutter plugin

A flutter plugin exposing the native `Add To Wallet` iOS button.

## Requirements

- Flutter >= 3.44.0
- iOS >= 13.0

## How

This plugin registers a native view factory and exposes it as a stateful widget into any flutter ecosystem. The intended use is for iOS mobile platform but the plugin should be safely usable in any other if you provide the widget with a `unsupportedPlatformChild` child widget.

## Swift Package Manager

The plugin ships both a Swift package (`ios/add_to_wallet/Package.swift`) and a CocoaPods podspec, so it works either way:

- **Swift Package Manager** is used automatically on Flutter 3.44+, where it is enabled by default. There is nothing to add to your app — Flutter wires the package into your Xcode project when you build. If your app still has a `Podfile`, you can remove it once every plugin you depend on supports SPM.
- **CocoaPods** is used when SPM is turned off with `flutter config --no-enable-swift-package-manager`. Note that on Flutter 3.44+ merely having a `Podfile` is not enough to keep this plugin on CocoaPods — SPM is on by default, so the Swift package is what gets used unless you disable the feature.

For background on migrating an app, see the Flutter guide: https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers

Internally the iOS code is split into a Swift target (`add_to_wallet`) and an Objective-C target (`add_to_wallet_objc`), because a single SwiftPM target cannot mix the two languages. The Objective-C target exists to wrap `PKAddPassesViewController(issuerData:signature:error:)` in `@try/@catch` — Swift cannot catch the `NSException` that initializer can raise.

## References

- How this works under the carpet: https://flutter.dev/docs/development/platform-integration/platform-views
