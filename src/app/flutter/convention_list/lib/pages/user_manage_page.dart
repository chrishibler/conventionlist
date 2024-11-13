import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/convention.dart';
import '../models/response_page.dart';
import '../services/api.dart';
import 'manage_view.dart';

class UserManagePage extends StatelessWidget {
  const UserManagePage({super.key});

  Future<void> _fetchPage(
    int pageKey,
    PagingController<int, Convention> controller,
  ) async {
    try {
      ResponsePage page = await Api().getUserConventions(
        pageKey: pageKey,
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
      showSearchField: false,
      editRoute: '/manage/edit',
      pageTitle: 'Manage Conventions',
    );
  }
}
