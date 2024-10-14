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
import '../widgets/app_progress_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PagingController<int, Convention> _pagingController = PagingController(firstPageKey: 2);
  final dio = Dio();

  Future<void> _fetchPage(int pageKey) async {
    try {
      final String url = 'https://api.conventionlist.org/conventions?page=$pageKey';
      final response = await dio.get(url);
      ResponsePage page = ResponsePage.fromJson(response.data);
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
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/logo-sm.png')),
        ),
        title: const ClearableTextField(hintText: 'Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedListView<int, Convention>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) => _getListTile(item),
              firstPageErrorIndicatorBuilder: (_) => _FirstPageErrorIndicator(
                error: _pagingController.error,
                onTap: () => _pagingController.refresh(),
              ),
              newPageErrorIndicatorBuilder: (_) => _ErrorIndicator(
                error: _pagingController.error,
                onTap: () => _pagingController.retryLastFailedRequest(),
              ),
              firstPageProgressIndicatorBuilder: (_) => const AppProgressIndicator(),
              newPageProgressIndicatorBuilder: (_) => const AppProgressIndicator(),
              noItemsFoundIndicatorBuilder: (_) => const _NoItemsFoundIndicator(),
              noMoreItemsIndicatorBuilder: (_) => const Placeholder(),
            ),
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
        Text(
          convention.name,
          style: listConventionNameStyle,
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
