import 'dart:ffi' as ffi;

import 'package:mimalloc_ffi/src/allocator.dart';
import 'package:test/test.dart';

void main() {
  group("Create allocation", () {
    test("throws when exceeding byte size", () {
      final int maxInt = -1 ^ (1 << 63);

      expect(() => miCalloc<ffi.Int8>(maxInt), throwsArgumentError);
      expect(() => miCalloc<ffi.Int16>(maxInt), throwsArgumentError);
      expect(() => miCalloc<ffi.Int32>(maxInt), throwsArgumentError);
    });

    test("throws negative byte size", () {
      expect(() => miCalloc<ffi.Char>(-1), throwsArgumentError);
    });
  });
}