import 'dart:ffi';

import 'package:meta/meta.dart';

import 'mimalloc.g.dart';

abstract final class _MiMallocBasedAllocator implements Allocator {
  const _MiMallocBasedAllocator._();

  static void _checkAllocated(Pointer ptr, int byteCount) {
    if (ptr.address == 0) {
      throw ArgumentError("Could not allocate $byteCount bytes.");
    }
  }

  @nonVirtual
  @override
  void free(Pointer pointer) {
    mi_free(pointer.cast<Void>());
  }
}

/// Manages memory on the native heap with optimization applied from `mimalloc` library.
/// 
/// This [Allocator] behave identical with `malloc` that the allocated memory values
/// are not zero-filled. Uses [MiCallocAllocator] if zero-initialize is preferred.
final class MiMallocAllocator extends _MiMallocBasedAllocator {
  const MiMallocAllocator._() : super._();

  @override
  Pointer<T> allocate<T extends NativeType>(int byteCount, {int? alignment}) {
    final Pointer<T> result = mi_malloc(byteCount).cast<T>();

    _MiMallocBasedAllocator._checkAllocated(result, byteCount);

    return result;
  }
}

/// Manages memory on the native heap with optimization applied from `mimalloc`
/// library with zero-filled values during allocation.
/// 
/// This [Allocator] behave identical with `calloc`.
final class MiCallocAllocator extends _MiMallocBasedAllocator {
  const MiCallocAllocator._() : super._();

  @override
  Pointer<T> allocate<T extends NativeType>(int byteCount, {int? alignment}) {
    final Pointer<T> result = mi_calloc(byteCount, 1).cast<T>();

    _MiMallocBasedAllocator._checkAllocated(result, byteCount);

    return result;
  }
}

/// Manages memory on the native heap with optimization applied from `mimalloc` library.
/// 
/// This [Allocator] behave identical with `malloc` that the allocated memory values
/// are not zero-filled. Uses [miCalloc] if zero-initialize is preferred.
const MiMallocAllocator miMalloc = MiMallocAllocator._();

/// Manages memory on the native heap with optimization applied from `mimalloc`
/// library with zero-filled values during allocation.
/// 
/// This [Allocator] behave identical with `calloc`.
const MiCallocAllocator miCalloc = MiCallocAllocator._();
