import 'package:convention_list/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/convention.dart';
import '../../widgets/app_progress_indicator.dart';
import '../../widgets/clearable_text_field.dart';
import '../../widgets/convention_list/error_indicators.dart';
import 'manage_cubit.dart';
import 'manage_list_tile.dart';

class ManageView extends StatelessWidget {
  final bool showSearchField;

  const ManageView({
    super.key,
    required this.showSearchField,
  });

  @override
  Widget build(BuildContext context) {
    GoRouter.of(context).routerDelegate.removeListener(() => context.read<ManageCubit>().pagingController.refresh());
    GoRouter.of(context).routerDelegate.addListener(() => context.read<ManageCubit>().pagingController.refresh());
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: ClearableTextField(
          hintText: 'Search',
          onChanged: (text) => {
            context.read<ManageCubit>().searchSubject.add(text),
          },
        ),
      ),
      endDrawer: const AppDrawer(),
      body: PagedListView<int, Convention>(
        pagingController: context.read<ManageCubit>().pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => ManageListTile(
            convention: item,
            refresh: () async {
              context.read<ManageCubit>().pagingController.refresh();
            },
            onDeleteConvention: () {
              context.read<ManageCubit>().pagingController.refresh();
            },
          ),
          firstPageErrorIndicatorBuilder: (_) => FirstPageErrorIndicator(
            error: context.read<ManageCubit>().pagingController.error,
            onTap: () => context.read<ManageCubit>().pagingController.refresh(),
          ),
          newPageErrorIndicatorBuilder: (_) => ErrorIndicator(
            error: context.read<ManageCubit>().pagingController.error,
            onTap: () => context.read<ManageCubit>().pagingController.retryLastFailedRequest(),
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
