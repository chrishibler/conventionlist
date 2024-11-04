import 'package:convention_list/services/api.dart';
import 'package:convention_list/services/geo_service.dart';
import 'package:convention_list/widgets/clearable_text_field.dart';
import 'package:convention_list/widgets/drawer.dart';
import 'package:convention_list/widgets/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/convention.dart';
import '../models/position.dart';
import '../models/response_page.dart';
import '../models/search_params.dart';
import '../widgets/app_progress_indicator.dart';
import '../widgets/convention_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PagingController<int, Convention> _pagingController = PagingController(firstPageKey: 1);
  final BehaviorSubject<String> searchSubject = BehaviorSubject<String>();
  OrderBy orderBy = OrderBy.startDate;
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
                    setState(() {
                      orderBy = OrderBy.startDate;
                    });
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
          child: FutureBuilder<void>(
              future: _setupPosition(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  // Future not done, return a temporary loading widget
                  return const Center(
                    child: AppProgressIndicator(),
                  );
                }

                return ConventionList(
                  pagingController: _pagingController,
                  positionSetup: _setupPosition(),
                  onNameTapped: (Convention convention) {
                    if (convention.websiteAddress != null) {
                      launchUrl(Uri.parse(convention.websiteAddress!));
                    }
                  },
                );
              }),
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
