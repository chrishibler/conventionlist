import 'package:convention_list/navigation/edit_extra_parameter.dart';
import 'package:convention_list/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '../models/convention.dart';
import '../services/api.dart';
import '../theme/mocha.dart';
import '../theme/text_styles.dart';
import '../widgets/app_progress_indicator.dart';
import '../widgets/clearable_text_field.dart';
import '../widgets/convention_list/error_indicators.dart';

class ManageView extends StatefulWidget {
  const ManageView({
    super.key,
    required this.fetchPage,
    required this.editRoute,
    this.pageTitle,
    this.showSearchField = false,
    this.onSearchChanged,
  });

  final String editRoute;
  final bool showSearchField;
  final String? pageTitle;
  final Future<void> Function(int, PagingController<int, Convention>) fetchPage;
  final void Function(SearchArgs)? onSearchChanged;

  @override
  State<ManageView> createState() => _ManageViewState();
}

class _ManageViewState extends State<ManageView> {
  String? search;
  final PagingController<int, Convention> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      widget.fetchPage(pageKey, _pagingController);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: widget.showSearchField
            ? ClearableTextField(
                hintText: 'Search',
                onChanged: (text) => {
                  if (widget.onSearchChanged != null)
                    {
                      widget.onSearchChanged!(
                        SearchArgs(
                          search: text,
                          controller: _pagingController,
                        ),
                      )
                    }
                },
              )
            : const Text('Manage Conventions'),
        centerTitle: true,
      ),
      endDrawer: const AppDrawer(),
      body: PagedListView<int, Convention>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => _ConventionListTile(
            convention: item,
            editRoute: widget.editRoute,
            refresh: () async {
              _pagingController.refresh();
            },
            onDeleteConvention: () {
              _pagingController.refresh();
            },
          ),
          firstPageErrorIndicatorBuilder: (_) => FirstPageErrorIndicator(
            error: _pagingController.error,
            onTap: () => _pagingController.refresh(),
          ),
          newPageErrorIndicatorBuilder: (_) => ErrorIndicator(
            error: _pagingController.error,
            onTap: () => _pagingController.retryLastFailedRequest(),
          ),
          firstPageProgressIndicatorBuilder: (_) => const AppProgressIndicator(),
          newPageProgressIndicatorBuilder: (_) => const AppProgressIndicator(),
          noItemsFoundIndicatorBuilder: (_) => const NoItemsFoundIndicator(),
          noMoreItemsIndicatorBuilder: (_) => const NoMoreItemsIndicator(),
        ),
      ),
    );
  }
}

class _ConventionListTile extends StatelessWidget {
  const _ConventionListTile({
    required this.convention,
    required this.editRoute,
    required this.refresh,
    this.onDeleteConvention,
  });

  final Future<void> Function() refresh;
  final String editRoute;
  static const maxNameCharacters = 20;
  final void Function()? onDeleteConvention;
  final Convention convention;

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
                              editRoute,
                              extra: EditExtraParameter(
                                refresh: refresh,
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
                                await Api().deleteConvention(convention);
                                if (onDeleteConvention != null) {
                                  onDeleteConvention!();
                                }
                              }
                            } catch (e) {
                              print(e);
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
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
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

class SearchArgs {
  SearchArgs({required this.search, required this.controller});

  final PagingController<int, Convention> controller;
  final String search;
}
