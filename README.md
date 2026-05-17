# Bring excellent performance of dynamic memory allocation library into Dart

mimalloc is developed by Daan Leijen with significant improvment of efficiency in comparison with default allocator from the systems. This is a Dart ported package by usign [`ffigen`](https://pub.dev/packages/ffigen) and [hooks](https://dart.dev/tools/hooks) approach to compile mimalloc v3 from [Git repository](https://github.com/microsoft/mimalloc) and replicate `malloc` and `calloc` features from [`ffi` package](https://pub.dev/packages/ffi).

**REMARK 1: This package aims to deliver an alternative option of dynamic memory allocation without overriding original dynamic memory allocation function.**

**REMARK 2: It is unnecessary to import this library if mimalloc is loaded through override method.**

## How to uses

1. Add `mimalloc_ffi` package by either editing `pubspec.yaml` or execute this command:
    ```shell
    dart pub add mimalloc_ffi
    ```
    * It is strongly recommanded to add `ffi` at the same time if string conversion or arena of allocation are demanded.
1. Import library:
    ```dart
    import "package:mimalloc_ffi/mimalloc_ffi.dart";
    // It is suggested to hide system allocators to avoid accidential uses
    import "package:ffi/ffi.dart"
        hide
            malloc,
            calloc,
            MallocAllocator,
            CallocAllocator;
    ```
1. (Only appliable when using APIs from `ffi` packages) Ensure optional arguement `wrappedAllocator` is specified to either `miMalloc` or `miCalloc`:
    ```dart
    import "dart:ffi" as ffi;

    final arenaResult = using<String>(
        (arena) {
            // Do something with arena
        },
        miCalloc,
    );
    final zoneArenaResult = withZoneArena(
        computationFunc,
        miCalloc,
    );

    // String handling
    void handleStr() {
        const String sampleText = "範本";

        final utf8Str = sampleText.toNativeUtf8(allocator: miMalloc);
        final utf16Str = sampleText.toNativeUtf16(allocator: miMalloc);
        
        // Remember free dynamic allocated library
        <ffi.Pointer>[utf8Str, utf16Str].forEach(miMalloc.free);
    }
    ```

# Licenses

* MIT license for mimalloc source code and `mimalloc.g.dart` through `ffigen` tool.
* Remaining part in this package are applied in BSD-3 license.
