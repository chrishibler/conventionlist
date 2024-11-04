import 'dart:math' as math;

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/convention.dart';
import '../theme/mocha.dart';
import '../theme/text_styles.dart';

class ConventionListTile extends StatelessWidget {
  const ConventionListTile({
    super.key,
    required this.convention,
    this.onNameTapped,
    this.showDescription = true,
    this.trailing = const [],
  });

  final void Function(Convention)? onNameTapped;
  final Convention convention;
  final bool showDescription;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (onNameTapped != null) {
                onNameTapped!(convention);
              }
            },
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    convention.name,
                    style: listConventionNameStyle,
                  ),
                ),
                if (onNameTapped != null) const SizedBox(width: 12),
                if (onNameTapped != null)
                  Transform.rotate(
                    angle: -45 * math.pi / 180,
                    child: const Icon(
                      Icons.link,
                      size: 16,
                      color: CatppuccinMocha.green,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${DateFormat('dd MMMM yyyy').format(convention.startDate)} - ${DateFormat('dd MMMM yyyy').format(convention.endDate)}',
            style: listDateStyle,
          ),
          if (showDescription) const SizedBox(height: 3),
          if (showDescription)
            ExpandableText(
              (convention.description ?? '').replaceAll('\n', ' '),
              expandText: 'show more',
              collapseText: 'show less',
              maxLines: 3,
              linkColor: CatppuccinMocha.sapphire,
            ),
        ],
      ),
    );
  }
}
