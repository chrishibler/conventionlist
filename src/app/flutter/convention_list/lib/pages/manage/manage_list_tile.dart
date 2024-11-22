import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../injection.dart';
import '../../models/convention.dart';
import '../../navigation/edit_extra_parameter.dart';
import '../../services/api.dart';
import '../../theme/mocha.dart';
import '../../theme/text_styles.dart';

class ManageListTile extends StatelessWidget {
  ManageListTile({
    super.key,
    required this.convention,
    required this.refresh,
    this.onDeleteConvention,
  });

  final Future<void> Function() refresh;
  static const maxNameCharacters = 20;
  final void Function()? onDeleteConvention;
  final Convention convention;
  final Api api = getIt<Api>();

  String _truncateNameIfNeeded(String name) {
    return name.length > maxNameCharacters ? '${name.substring(0, maxNameCharacters)}...' : name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _truncateNameIfNeeded(convention.name),
                      style: listConventionNameStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: CatppuccinMocha.sky),
                          onPressed: () async {
                            await context.push(
                              '/manage/edit',
                              extra: EditExtraParameter(
                                convention: convention,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: CatppuccinMocha.red),
                          onPressed: () async {
                            try {
                              bool? confirmed = await _showDeleteConfirmationDialog(context);
                              if (confirmed == true) {
                                await api.deleteConvention(convention);
                                if (onDeleteConvention != null) {
                                  onDeleteConvention!();
                                }
                              }
                            } catch (e) {
                              getIt<Logger>().e('Problem deleting convention', error: e);
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            '${DateFormat('dd MMMM yyyy').format(convention.startDate)} - ${DateFormat('dd MMMM yyyy').format(convention.endDate)}',
            style: listDateStyle,
          ),
        ],
      ),
    );
  }
}

Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Confirmation'),
        content: const Text('Are you sure you want to delete this convention?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context.pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop(true);
            },
            style: TextButton.styleFrom(
              foregroundColor: CatppuccinMocha.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
