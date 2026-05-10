# Swift Runtime Interposer

`swift-runtime-interposer` provides a small Linux-only runtime interposer for Swift ARC entry points together with a Swift wrapper around the exported counters.

It exists primarily to support tools that need coarse ARC traffic statistics on Linux when private Swift runtime hooks are unavailable or unsafe to patch directly, such as on Swift 6.3+.

## What it contains

- `SwiftRuntimeInterposerC`
  A dynamic library that interposes selected public Swift runtime symbols and counts allocations, retains, and releases.
- `SwiftRuntimeInterposerSwift`
  A Swift wrapper that exposes a small API for enabling counting, disabling counting, resetting counters, and reading the current statistics.

## How it works

The C library is intended to be injected with `LD_PRELOAD`. It resolves the next implementation of each interposed Swift runtime symbol with `dlsym(RTLD_NEXT, ...)`, forwards the original call, and updates atomically tracked counters while counting is enabled.

The Swift wrapper links against the same package and provides the convenience API used by higher-level tools.

## Scope and limitations

- Linux-oriented: the current implementation only provides the Unix/Linux interposer.
- Best-effort counts: this only sees calls that pass through the interposed public runtime symbols.
- Not a stable ABI contract with the Swift runtime: if the runtime changes symbol names or calling behavior, the interposer may need updating.
- Intended for tooling and measurement, not for production application logic.

## Package layout

```text
Sources/
  SwiftRuntimeInterposerC/
    include/interposer.h
    src/interposer-unix.c
  SwiftRuntimeInterposerSwift/
    SwiftRuntimeInterposerSwift.swift
```

## Using it from another package

Add the package dependency and use the Swift wrapper in your code:

```swift
.package(url: "https://github.com/ordo-one/swift-runtime-interposer.git", .upToNextMajor(from: "1.0.0"))
```

```swift
.product(name: "SwiftRuntimeInterposerSwift", package: "swift-runtime-interposer")
```

If you need the interposer to actually intercept runtime calls, make sure the built `libSwiftRuntimeInterposerC.so` is loaded with `LD_PRELOAD` before launching the target process.

## License

Apache 2.0. See [LICENSE](LICENSE).
