import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) {
      return;
    }

    final bool winBuild = input.config.code.targetOS == OS.windows;

    final builder = CBuilder.library(
      name: "mimalloc",
      assetName: "src/mimalloc.g.dart",
      sources: const <String>["mimalloc/src/static.c"],
      includes: const <String>["mimalloc/include"],
      std: "c11",
      flags: ["/nologo", "Advapi32.lib"],
      defines: <String, String?>{
        "MI_SHARED_LIB": null,
        "MI_SHARED_LIB_EXPORT": null,
        if (winBuild) ...{"MI_WIN_NOREDIRECT": null},
      },
    );

    await builder.run(input: input, output: output);
  });
}
