// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-runtime-interposer",
    products: [
        // The dylib to preload (LD_PRELOAD) and to link against from Swift
        // code. Combines the C interposer with the Swift API in one image —
        // the C target must not have its own dynamic product: it is linked
        // statically into this dylib, and SwiftPM 6.4+ cannot build a target
        // both statically and dynamically.
        .library(
            name: "SwiftRuntimeInterposerSwift",
            type: .dynamic,
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
