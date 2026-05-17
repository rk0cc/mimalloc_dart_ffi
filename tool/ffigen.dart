import 'dart:io';

import 'package:ffigen/ffigen.dart';

const String mimallocMIT = """/*
  Copyright (c) 2018-2025, Microsoft Research, Daan Leijen
  
  This is free software; you can redistribute it and/or modify it 
  under the terms of the MIT license. 

  A copy of the license can be found in the file "LICENSE" at the root 
  of this distribution.
*/
""";

void main(List<String> args) {
  final pkgRoot = Platform.script.resolve("../");
  final mimallocRoot = pkgRoot.resolve("mimalloc/");
  final mimallocInclude = mimallocRoot.resolve("include/");

  FfiGenerator(
    output: Output(
      dartFile: pkgRoot.resolve("lib/src/mimalloc.g.dart"),
      preamble: mimallocMIT,
    ),
    headers: Headers(
      entryPoints: [mimallocInclude.resolve("mimalloc.h")],
      compilerOptions: ["-Imimalloc/include"],
    ),
    functions: Functions.includeSet(const <String>{
      "mi_malloc",
      "mi_calloc",
      "mi_free",
    }),
  ).generate();
}
