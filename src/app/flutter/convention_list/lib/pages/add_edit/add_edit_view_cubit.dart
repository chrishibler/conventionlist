import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../models/category.dart';
import '../../models/convention.dart';
import '../../models/new_convention.dart';
import '../../services/api.dart';
import '../../services/auth_service.dart';
import '../../util/permissions.dart';

part 'add_edit_view_cubit.freezed.dart';

@injectable
class AddEditViewCubit extends Cubit<AddEditViewState> {
  AddEditViewCubit({
    required this.api,
    required this.authService,
    @factoryParam Convention? convention,
  }) : super(AddEditViewState(convention: convention)) {
    emit(
      state.copyWith(
        isAdmin: authService.permissions.contains(Permissions.manageAllConventions),
      ),
    );
  }

  final AuthService authService;
  final Api api;

  Future<bool> saveConvention(FormBuilderState? formState) async {
    if (formState == null) {
      return false;
    }

    bool isValid = formState.saveAndValidate();
    if (!isValid) {
      return false;
    }

    var value = formState.value;

    emit(state.copyWith(isBusy: true, error: null));
    try {
      if (state.convention == null) {
        NewConvention newCon = NewConvention(
          name: value['name'],
          startDate: value['startDate'],
          endDate: value['endDate'],
          description: value['description'],
          category: value['category'] ?? Category.unlisted,
          websiteAddress: value['websiteAddress'],
          venueName: value['venueName'],
          address1: value['address1'],
          address2: value['address2'],
          city: value['city'],
          state: value['state'],
          postalCode: value['postalCode'],
          country: value['country'],
          isApproved: value['isApproved'] ?? false,
        );

        await api.postConvention(newCon);
      } else {
        Convention convention = Convention(
          id: state.convention!.id,
          position: state.convention!.position,
          name: value['name'],
          startDate: value['startDate'],
          endDate: value['endDate'],
          description: value['description'],
          category: value['category'] ?? Category.unlisted,
          websiteAddress: value['websiteAddress'],
          venueName: value['venueName'],
          address1: value['address1'],
          address2: value['address2'],
          city: value['city'],
          state: value['state'],
          postalCode: value['postalCode'],
          country: value['country'],
          isApproved: value['isApproved'] ?? false,
        );
        await api.putConvention(convention);
      }
      emit(state.copyWith(error: null, isBusy: false, isFinished: true));
      return true;
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isBusy: false));
      return false;
    }
  }
}

@freezed
class AddEditViewState with _$AddEditViewState {
  const factory AddEditViewState({
    Convention? convention,
    @Default(false) bool isFinished,
    @Default(false) bool isAdmin,
    @Default(false) bool isBusy,
    String? error,
  }) = _AddEditViewState;
}
