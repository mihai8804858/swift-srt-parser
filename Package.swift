// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "swift-srt-parser",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SRTParser", targets: ["SRTParser"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.15.3"),
        .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "1.7.3")
    ],
    targets: [
        .target(
            name: "SRTParser",
            dependencies: [
                .product(name: "Parsing", package: "swift-parsing")
            ],
            path: "Sources",
            resources: [.copy("Resources/PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "SRTParserTests",
            dependencies: [
                .target(name: "SRTParser"),
                .product(name: "CustomDump", package: "swift-custom-dump")
            ],
            path: "Tests",
            resources: [.copy("Resources/Subtitles")]
        )
    ],
    swiftLanguageModes: [.v6]
)
