import 'package:convention_list/theme/mocha.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpinKitSpinningLines(
      color: CatppuccinMocha.green,
    );
  }
}
