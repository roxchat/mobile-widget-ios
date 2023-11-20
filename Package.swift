// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "RoxChatMobileWidget",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RoxChatMobileWidget",
            targets: ["RoxChatMobileWidget"]),
    ],
    dependencies: [
        .package(url: "https://github.com/roxchat/mobile-sdk-ios.git", exact: "3.0.4"),
        .package(url: "https://github.com/kean/Nuke.git", from: "12.0.0"),
        .package(url: "https://github.com/evgenyneu/Cosmos.git", from: "20.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
        .package(url: "https://github.com/Flipboard/FLAnimatedImage.git", from: "1.0.17"),
        .package(url: "https://github.com/roxchat/mobile-keyboard-ios.git", exact: "1.0.0")
    ],
    targets: [
        .target(
            name: "RoxChatMobileWidget",
            dependencies: [
                .product(name: "RoxchatClientLibrary", package: "mobile-sdk-ios"),
                .product(name: "Nuke", package: "Nuke"),
                .product(name: "Cosmos", package: "Cosmos"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "FLAnimatedImage", package: "FLAnimatedImage"),
                .product(name: "RoxChatKeyboard", package: "mobile-keyboard-ios")
            ],
            path: "Sources")
    ]
)
