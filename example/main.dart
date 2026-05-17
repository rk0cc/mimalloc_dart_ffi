import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart'
    hide
        malloc,
        calloc,
        MallocAllocator,
        CallocAllocator; // Hide default allocators if concerned about wrongfully uses.
import 'package:mimalloc_ffi/mimalloc_ffi.dart';

String _toFormattedHexString(int code) =>
    '0x${code.toRadixString(16).toUpperCase().padLeft(2, '0')}';

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
  final charPtr = str
      .toNativeUtf8(allocator: miMalloc)
      .cast<
        ffi.Uint8
      >(); // Specify allocator to miMalloc instead of default malloc.

  List<int> utf8Code = [];
  int utf8Len = 0;
  while (charPtr[utf8Len] != 0) {
    utf8Code.add(charPtr[utf8Len++]);
  }
  utf8Code.add(0); // Intentionally append null-terminated

  print("UTF-8 sequence: ${utf8Code.map(_toFormattedHexString)}");
  print("String from pointer: ${charPtr.cast<Utf8>().toDartString()}");

  miMalloc.free(
    charPtr,
  ); // It does not matter free function is called from miMalloc or miCalloc.
}
