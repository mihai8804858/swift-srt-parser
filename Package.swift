// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "swift-srt-parser",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SRTParser", targets: ["SRTParser"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-parsing", .upToNextMajor(from: "0.13.0"))
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
                .target(name: "SRTParser")
            ],
            path: "Tests"
        )
    ]
)
