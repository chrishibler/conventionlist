import 'package:convention_list/services/api.dart';
import 'package:convention_list/services/geo_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/convention.dart';
import '../../models/position.dart';
import '../../models/response_page.dart';
import '../../models/search_params.dart';

part 'home_page_cubit.freezed.dart';

@injectable
class HomePageCubit extends Cubit<HomePageState> {
  final PagingController<int, Convention> pagingController = PagingController(firstPageKey: 1);
  late final Future<Position> positionFuture;
  final GeoService geoService;
  final Api api;
  final BehaviorSubject<String> searchSubject = BehaviorSubject<String>();
  OrderBy _orderBy = OrderBy.distance;
  String? search = '';

  HomePageCubit({
    required this.api,
    required this.geoService,
  }) : super(const HomePageState.initial(orderBy: OrderBy.distance)) {
    positionFuture = geoService.getPosition();

    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey: pageKey);
    });

    searchSubject.debounceTime(const Duration(milliseconds: 300)).listen((text) {
      if (search == text) {
        return;
      }
      search = text;
      pagingController.refresh();
    });
  }

  OrderBy get orderBy {
    return _orderBy;
  }

  set orderBy(OrderBy orderBy) {
    _orderBy = orderBy;
    emit(state.copyWith(orderBy: orderBy));
  }

  Future<void> fetchPage({required int pageKey}) async {
    Position position = await positionFuture;
    ResponsePage page = await api.getConventions(
      orderBy: orderBy,
      pageKey: pageKey,
      search: search,
      position: position,
    );

    bool isLastPage = page.totalPages == page.currentPage;
    if (isLastPage) {
      pagingController.appendLastPage(page.conventions);
    } else {
      pagingController.appendPage(page.conventions, pageKey + 1);
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}

@freezed
class HomePageState with _$HomePageState {
  const factory HomePageState({
    required OrderBy orderBy,
  }) = _HomePageState;

  const factory HomePageState.initial({required OrderBy orderBy}) = _HomePageStateInitial;
}
