// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-runtime-interposer",
    products: [
        .library(
            name: "SwiftRuntimeInterposerC",
            type: .dynamic,
            targets: ["SwiftRuntimeInterposerC"]
        ),
        .library(
            name: "SwiftRuntimeInterposerSwift",
            targets: ["SwiftRuntimeInterposerSwift"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftRuntimeInterposerC",
            path: "Sources/SwiftRuntimeInterposerC",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include"),
            ],
            linkerSettings: [
                .linkedLibrary("dl", .when(platforms: [.linux])),
            ]
        ),
        .target(
            name: "SwiftRuntimeInterposerSwift",
            dependencies: [
                "SwiftRuntimeInterposerC",
            ],
            path: "Sources/SwiftRuntimeInterposerSwift"
        ),
    ]
)
