import 'package:convention_list/theme/mocha.dart';
import 'package:convention_list/widgets/clearable_text_field.dart';
import 'package:dio/dio.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '../models/convention.dart';
import '../models/response_page.dart';
import '../theme/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PagingController<int, Convention> _pagingController =
      PagingController(firstPageKey: 2);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final dio = Dio();
      final String url =
          'https://api.conventionlist.org/conventions?page=$pageKey';
      final response = await dio.get(url);
      ResponsePage page = ResponsePage.fromJson(response.data);
      bool isLastPage = page.totalPages == page.currentPage;
      if (isLastPage) {
        _pagingController.appendLastPage(page.conventions);
      } else {
        _pagingController.appendPage(page.conventions, pageKey + 1);
      }
    } catch (error) {
      _pagingController.error = error;
      print(error);
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
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/logo-sm.png')),
        ),
        title: const ClearableTextField(hintText: 'Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: PagedListView<int, Convention>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) => _getListTile(item)),
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
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        convention.name,
        style: listConventionNameStyle,
      ),
      Text(
        '${DateFormat('dd MMMM yyyy').format(convention.startDate)} - ${DateFormat('dd MMMM yyyy').format(convention.endDate)}',
        style: listDateStyle,
      ),
      ExpandableText(
        (convention.description ?? '').replaceAll('\n', ' '),
        expandText: 'show more',
        collapseText: 'show less',
        maxLines: 3,
        linkColor: CatppuccinMocha.sapphire,
      ),
      const SizedBox(height: 24),
    ],
  );
}
