import 'dart:math' as math;

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../injection.dart';
import '../../models/convention.dart';
import '../../theme/mocha.dart';
import '../../theme/text_styles.dart';

class ConventionInfo extends StatelessWidget {
  const ConventionInfo({
    super.key,
    required this.convention,
  });

  final Convention convention;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              if (convention.websiteAddress != null) {
                try {
                  Uri uri = Uri.parse(convention.websiteAddress!);
                  launchUrl(uri);
                } catch (e) {
                  getIt<Logger>().e('Error launching url', error: e);
                  return;
                }
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
                const SizedBox(width: 6),
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
          if (convention.getLocationInfo().isNotEmpty) Text(convention.getLocationInfo()),
          if (convention.getLocationInfo().isNotEmpty) const SizedBox(width: 3),
          Text(
            '${DateFormat('dd MMMM yyyy').format(convention.startDate)} - ${DateFormat('dd MMMM yyyy').format(convention.endDate)}',
            style: listDateStyle,
          ),
          const SizedBox(height: 3),
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
