import 'package:convention_list/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '../models/convention.dart';
import '../models/response_page.dart';
import '../services/api.dart';
import '../theme/mocha.dart';
import '../theme/text_styles.dart';
import '../widgets/app_progress_indicator.dart';
import '../widgets/convention_list/error_indicators.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  final PagingController<int, Convention> _pagingController = PagingController(firstPageKey: 1);

  Future<void> _fetchPage(int pageKey) async {
    try {
      ResponsePage page = await Api().getUserConventions(
        pageKey: pageKey,
      );
      bool isLastPage = page.totalPages == page.currentPage;
      if (isLastPage) {
        _pagingController.appendLastPage(page.conventions);
      } else {
        _pagingController.appendPage(page.conventions, pageKey + 1);
      }
    } catch (error) {
      _pagingController.error = error.toString();
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Conventions'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      endDrawer: const AppDrawer(),
      body: PagedListView<int, Convention>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => _ConventionListTile(
            convention: item,
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
    super.key,
    required this.convention,
    this.onDeleteConvention,
  });

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
                            await context.push('/edit', extra: convention);
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
