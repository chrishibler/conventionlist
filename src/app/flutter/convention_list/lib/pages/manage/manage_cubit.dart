import 'package:convention_list/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/convention.dart';
import '../../models/response_page.dart';
import '../../models/search_params.dart';
import '../../services/api.dart';

part 'manage_cubit.freezed.dart';

@injectable
class ManageCubit extends Cubit<ManageState> {
  final BehaviorSubject<String> searchSubject = BehaviorSubject<String>();
  final PagingController<int, Convention> pagingController = PagingController(firstPageKey: 1);
  final Api api;
  final AuthService authService;
  String? search;
  bool? approved;

  ManageCubit(this.api, this.authService) : super(ManageState(isAdmin: authService.isAdmin)) {
    pagingController.addPageRequestListener((pageKey) async {
      await _fetchPage(pageKey);
    });

    searchSubject.debounceTime(const Duration(milliseconds: 300)).listen((text) {
      search = text;
      pagingController.refresh();
    });
  }

  void setApproved(bool? approved) {
    this.approved = approved;
    pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      ResponsePage page = authService.isAdmin
          ? await api.getConventions(
              orderBy: OrderBy.startDate,
              pageKey: pageKey,
              search: search,
              approved: approved,
            )
          : await api.getUserConventions(pageKey: pageKey, search: search);
      bool isLastPage = page.totalPages == page.currentPage;
      if (isLastPage) {
        pagingController.appendLastPage(page.conventions);
      } else {
        pagingController.appendPage(page.conventions, pageKey + 1);
      }
    } catch (error) {
      pagingController.error = error.toString();
    }
  }
}

@freezed
class ManageState with _$ManageState {
  const factory ManageState({required bool isAdmin}) = _ManageState;
}
