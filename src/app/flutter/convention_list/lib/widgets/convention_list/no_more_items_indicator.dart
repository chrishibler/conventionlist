import 'package:flutter/material.dart';

import '../../theme/mocha.dart';

class NoMoreItemsIndicator extends StatelessWidget {
  const NoMoreItemsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.pin_end_outlined,
          color: CatppuccinMocha.red,
          size: 36,
        ),
        SizedBox(width: 12),
        Text('No more conventions', style: TextStyle(fontSize: 20, color: CatppuccinMocha.sapphire)),
      ],
    );
  }
}
