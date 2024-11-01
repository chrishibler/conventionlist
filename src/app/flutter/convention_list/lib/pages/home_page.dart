import 'dart:math' as math;

import 'package:convention_list/services/api.dart';
import 'package:convention_list/services/geo_service.dart';
import 'package:convention_list/theme/mocha.dart';
import 'package:convention_list/widgets/clearable_text_field.dart';
import 'package:convention_list/widgets/drawer.dart';
import 'package:convention_list/widgets/drawer_item.dart';
import 'package:dio/dio.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/convention.dart';
import '../models/position.dart';
import '../models/response_page.dart';
import '../models/search_params.dart';
import '../theme/text_styles.dart';
import '../widgets/app_progress_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PagingController<int, Convention> _pagingController = PagingController(firstPageKey: 1);
  final dio = Dio();
  final BehaviorSubject<String> searchSubject = BehaviorSubject<String>();
  OrderBy orderBy = OrderBy.distance;
  String? search;
  Position? position;

  Future<void> _setupPosition() async {
    try {
      position = await GeoService.getPosition();
    } catch (e) {
      print(e);
      orderBy = OrderBy.startDate;
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      ResponsePage page = await Api().getConventions(
        orderBy: orderBy,
        pageKey: pageKey,
        search: search,
        position: position,
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

    searchSubject.debounceTime(const Duration(milliseconds: 300)).listen((text) {
      search = text;
      _pagingController.refresh();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: ClearableTextField(
          hintText: 'Search',
          onChanged: (text) => searchSubject.add(text),
        ),
      ),
      endDrawer: AppDrawer(additionalItems: [
        orderBy == OrderBy.startDate
            ? DrawerItem(
                icon: Icons.near_me,
                text: 'Sort by distance',
                onTap: () async {
                  Position? pos;
                  try {
                    pos = await GeoService.getPosition();
                  } catch (e) {
                    print(e); // TODO: Show an error
                    return;
                  }
                  setState(() {
                    position = pos;
                    orderBy = OrderBy.distance;
                  });
                  _pagingController.refresh();
                })
            : DrawerItem(
                icon: Icons.text_rotate_vertical,
                text: 'Sort by Start Date',
                onTap: () {
                  setState(() {
                    orderBy = OrderBy.startDate;
                  });
                  _pagingController.refresh();
                }),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: _ConventionList(
            pagingController: _pagingController,
            positionSetup: _setupPosition(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

Widget _getListTile(Convention convention) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (convention.websiteAddress != null) {
              launchUrl(Uri.parse(convention.websiteAddress!));
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
              const SizedBox(width: 12),
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

class _ConventionList extends StatelessWidget {
  const _ConventionList({super.key, required this.pagingController, required this.positionSetup});

  final Future<void> positionSetup;
  final PagingController<int, Convention> pagingController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: positionSetup,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Future not done, return a temporary loading widget
          return const Center(
            child: AppProgressIndicator(),
          );
        }

        return PagedListView<int, Convention>(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, item, index) => _getListTile(item),
            firstPageErrorIndicatorBuilder: (_) => _FirstPageErrorIndicator(
              error: pagingController.error,
              onTap: () => pagingController.refresh(),
            ),
            newPageErrorIndicatorBuilder: (_) => _ErrorIndicator(
              error: pagingController.error,
              onTap: () => pagingController.retryLastFailedRequest(),
            ),
            firstPageProgressIndicatorBuilder: (_) => const AppProgressIndicator(),
            newPageProgressIndicatorBuilder: (_) => const AppProgressIndicator(),
            noItemsFoundIndicatorBuilder: (_) => const _NoItemsFoundIndicator(),
            noMoreItemsIndicatorBuilder: (_) => const _NoMoreItemsIndicator(),
          ),
        );
      },
    );
  }
}

class _NoItemsFoundIndicator extends StatelessWidget {
  const _NoItemsFoundIndicator({super.key});

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

class _NoMoreItemsIndicator extends StatelessWidget {
  const _NoMoreItemsIndicator({super.key});

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

class _FirstPageErrorIndicator extends StatelessWidget {
  const _FirstPageErrorIndicator({
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
          _ErrorIndicator(error: error, onTap: onTap),
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

class _ErrorIndicator extends StatelessWidget {
  const _ErrorIndicator({
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
