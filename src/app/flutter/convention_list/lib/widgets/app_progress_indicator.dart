import 'package:convention_list/theme/mocha.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    super.key,
    this.size = 70,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SpinKitSpinningLines(
      color: CatppuccinMocha.green,
      size: size,
    );
  }
}
