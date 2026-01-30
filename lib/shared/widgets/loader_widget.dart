import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../Core/styles/Colors.dart';

class LoaderWidget extends StatelessWidget {
  final double sizeLoader;
  /// Loader color. Defaults to gunmetalBlue; use Colors.white for in-button loaders on dark buttons.
  final Color? color;

  const LoaderWidget({super.key, required this.sizeLoader, this.color});

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery so we don't depend on ScreenUtilInit (avoids LateInitializationError)
    final size = MediaQuery.sizeOf(context).shortestSide * sizeLoader;
    final minSize = sizeLoader <= 0.06 ? 18.0 : 24.0;
    return Center(
      child: SpinKitThreeBounce(
        color: color ?? ColorConsts.gunmetalBlue,
        size: size.clamp(minSize, 120.0),
      ),
    );
  }
}
