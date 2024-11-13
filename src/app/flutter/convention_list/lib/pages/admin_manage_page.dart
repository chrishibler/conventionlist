import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rxdart/rxdart.dart';

import '../models/convention.dart';
import '../models/response_page.dart';
import '../models/search_params.dart';
import '../services/api.dart';
import 'manage_view.dart';

class AdminManagePage extends StatefulWidget {
  const AdminManagePage({super.key});

  @override
  State<AdminManagePage> createState() => _AdminManagePageState();
}

class _AdminManagePageState extends State<AdminManagePage> {
  final BehaviorSubject<SearchArgs> searchSubject = BehaviorSubject<SearchArgs>();
  OrderBy orderBy = OrderBy.distance;
  String? search;

  @override
  void initState() {
    searchSubject.debounceTime(const Duration(milliseconds: 300)).listen((args) {
      search = args.search;
      args.controller.refresh();
    });
    super.initState();
  }

  Future<void> _fetchPage(
    int pageKey,
    PagingController<int, Convention> controller,
  ) async {
    try {
      ResponsePage page = await Api().getConventions(
        orderBy: orderBy,
        pageKey: pageKey,
        search: search,
      );
      bool isLastPage = page.totalPages == page.currentPage;
      if (isLastPage) {
        controller.appendLastPage(page.conventions);
      } else {
        controller.appendPage(page.conventions, pageKey + 1);
      }
    } catch (error) {
      controller.error = error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ManageView(
      fetchPage: _fetchPage,
      showSearchField: true,
      editRoute: '/admin/edit',
      onSearchChanged: (searchArgs) => searchSubject.add(searchArgs),
    );
  }
}
