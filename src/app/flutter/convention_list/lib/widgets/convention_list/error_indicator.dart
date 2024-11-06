import 'package:flutter/material.dart';

import '../../theme/mocha.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    super.key,
    required this.error,
    required this.onTap,
  });

  final String error;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: CatppuccinMocha.red,
            size: 20,
          ),
          SizedBox(width: 12),
          Text(
            'An error occurred. Tap to retry.',
            style: TextStyle(
              fontSize: 20,
              color: CatppuccinMocha.red,
            ),
          ),
        ],
      ),
    );
  }
}
