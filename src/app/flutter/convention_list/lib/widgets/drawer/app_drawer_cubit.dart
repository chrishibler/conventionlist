import 'package:convention_list/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'app_drawer_cubit.freezed.dart';

@injectable
class AppDrawerCubit extends Cubit<AppDrawerState> {
  AppDrawerCubit({required this.authService, required this.logger})
      : super(
          AppDrawerState(isLoggedIn: authService.credentials != null),
        );

  final AuthService authService;
  final Logger logger;

  Future<void> loginLogout() async {
    try {
      if (state.isLoggedIn) {
        await authService.logout();
      } else {
        await authService.login();
      }
      emit(state.copyWith(isLoggedIn: authService.credentials != null));
    } catch (e) {
      logger.e('Error logging out', error: e);
    }
  }
}

@freezed
class AppDrawerState with _$AppDrawerState {
  const factory AppDrawerState({required bool isLoggedIn}) = _AppDrawerState;
}
