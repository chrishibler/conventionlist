import 'package:convention_list/pages/home/home_page_cubit.dart';
import 'package:convention_list/widgets/clearable_text_field.dart';
import 'package:convention_list/widgets/drawer.dart';
import 'package:convention_list/widgets/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../injection.dart';
import '../../models/convention.dart';
import '../../models/search_params.dart';
import '../../widgets/app_progress_indicator.dart';
import '../../widgets/convention_list/convention_info.dart';
import '../../widgets/convention_list/error_indicators.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomePageCubit>(),
      child: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 90,
              title: ClearableTextField(
                hintText: 'Search',
                onChanged: (text) => context.read<HomePageCubit>().searchSubject.add(text),
              ),
            ),
            endDrawer: AppDrawer(additionalItems: [
              state.orderBy == OrderBy.startDate
                  ? DrawerItem(
                      icon: Icons.near_me,
                      text: 'Sort by distance',
                      onTap: () {
                        context.read<HomePageCubit>().orderBy = OrderBy.distance;
                        context.read<HomePageCubit>().pagingController.refresh();
                      })
                  : DrawerItem(
                      icon: Icons.text_rotate_vertical,
                      text: 'Sort by Start Date',
                      onTap: () {
                        context.read<HomePageCubit>().orderBy = OrderBy.startDate;
                        context.read<HomePageCubit>().pagingController.refresh();
                      }),
            ]),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: RefreshIndicator(
                onRefresh: () => Future.sync(
                  () => context.read<HomePageCubit>().pagingController.refresh(),
                ),
                child: PagedListView<int, Convention>(
                  pagingController: context.read<HomePageCubit>().pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, item, index) => ConventionInfo(
                      convention: item,
                    ),
                    firstPageErrorIndicatorBuilder: (_) => FirstPageErrorIndicator(
                      error: context.read<HomePageCubit>().pagingController.error,
                      onTap: () => context.read<HomePageCubit>().pagingController.refresh(),
                    ),
                    newPageErrorIndicatorBuilder: (_) => ErrorIndicator(
                      error: context.read<HomePageCubit>().pagingController.error,
                      onTap: () => context.read<HomePageCubit>().pagingController.retryLastFailedRequest(),
                    ),
                    firstPageProgressIndicatorBuilder: (_) => const AppProgressIndicator(),
                    newPageProgressIndicatorBuilder: (_) => const AppProgressIndicator(),
                    noItemsFoundIndicatorBuilder: (_) => const NoItemsFoundIndicator(),
                    noMoreItemsIndicatorBuilder: (_) => const NoMoreItemsIndicator(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
