import 'package:flutter/material.dart';

import '../../theme/mocha.dart';

class NoItemsFoundIndicator extends StatelessWidget {
  const NoItemsFoundIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.cancel_sharp,
          color: CatppuccinMocha.red,
          size: 36,
        ),
        SizedBox(width: 12),
        Text('No conventions found', style: TextStyle(fontSize: 20, color: CatppuccinMocha.red)),
      ],
    );
  }
}
