import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/convention.dart';
import '../theme/mocha.dart';
import 'app_progress_indicator.dart';
import 'convention_list_tile.dart';

class ConventionList extends StatelessWidget {
  const ConventionList({
    super.key,
    required this.pagingController,
    this.positionSetup,
    this.onNameTapped,
  });

  final void Function(Convention)? onNameTapped;
  final Future<void>? positionSetup;
  final PagingController<int, Convention> pagingController;

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Convention>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) => ConventionListTile(
            convention: item,
            onNameTapped: (con) {
              if (con.websiteAddress != null) {
                launchUrl(Uri.parse(con.websiteAddress!));
              }
            }),
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
