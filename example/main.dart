import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart'
    hide
        malloc,
        calloc,
        MallocAllocator,
        CallocAllocator; // Hide default allocators if concerned about wrongfully uses.
import 'package:mimalloc_ffi/mimalloc_ffi.dart';

void main(List<String> args) {
  // Simple allocation
  const List<int> dialCode = [9, 1, 3];
  final dialCodePtr = miCalloc<ffi.Int>(
    dialCode.length,
  ); // Allocate 3 (signed) int pointers

  for (int i = 0; i < dialCode.length; i++) {
    dialCodePtr[i] = dialCode[i];
  }

  print(dialCodePtr.value); // Normally appeared as '9'
  miCalloc.free(dialCodePtr);

  // Parse Dart string to native char sequence
  final str = "変身";
  final charPtr = str.toNativeUtf8(
    allocator: miMalloc,
  ); // Specify allocator to miMalloc instead of default malloc.

  print("First byte is: ${charPtr.cast<ffi.Uint8>().value}");
  print("String from pointer: ${charPtr.toDartString()}");

  miMalloc.free(
    charPtr,
  ); // It does not matter free function is called from miMalloc or miCalloc.
}
