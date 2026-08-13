// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "add_to_wallet",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "add-to-wallet", targets: ["add_to_wallet", "add_to_wallet_objc"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        // Swift implementation. Depends on the Objective-C target below, which
        // wraps a PassKit initializer that can raise an NSException — something
        // Swift cannot catch, so that shim has to stay in Objective-C.
        .target(
            name: "add_to_wallet",
            dependencies: [
                "add_to_wallet_objc",
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/add_to_wallet",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "add_to_wallet_objc",
            dependencies: [],
            path: "Sources/add_to_wallet_objc",
            cSettings: [
                .headerSearchPath("include/add_to_wallet")
            ]
        ),
    ]
)
