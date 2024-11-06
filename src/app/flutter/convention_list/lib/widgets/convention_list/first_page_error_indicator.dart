import 'package:flutter/material.dart';

import '../../theme/mocha.dart';
import 'error_indicator.dart';

class FirstPageErrorIndicator extends StatelessWidget {
  const FirstPageErrorIndicator({
    super.key,
    required this.error,
    required this.onTap,
  });

  final Function() onTap;
  final String error;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ErrorIndicator(error: error, onTap: onTap),
          const SizedBox(height: 6),
          Text(
            error,
            style: const TextStyle(
              fontSize: 12,
              color: CatppuccinMocha.red,
            ),
          ),
        ],
      ),
    );
  }
}
