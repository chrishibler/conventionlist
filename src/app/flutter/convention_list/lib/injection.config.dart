// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:convention_list/models/convention.dart' as _i612;
import 'package:convention_list/pages/add_edit/add_edit_view_cubit.dart'
    as _i14;
import 'package:convention_list/pages/home/home_page_cubit.dart' as _i498;
import 'package:convention_list/pages/manage/manage_cubit.dart' as _i499;
import 'package:convention_list/pages/map/map_cubit.dart' as _i270;
import 'package:convention_list/register_module.dart' as _i821;
import 'package:convention_list/services/api.dart' as _i367;
import 'package:convention_list/services/auth_service.dart' as _i781;
import 'package:convention_list/services/geo_service.dart' as _i598;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i781.AuthService>(() => _i781.AuthService());
    gh.lazySingleton<_i598.GeoService>(() => _i598.GeoService());
    gh.factory<String>(
      () => registerModule.baseUrl,
      instanceName: 'BaseUrl',
    );
    gh.lazySingleton<_i361.Dio>(
        () => registerModule.dio(gh<String>(instanceName: 'BaseUrl')));
    gh.lazySingleton<_i367.Api>(() => _i367.Api(
          authService: gh<_i781.AuthService>(),
          dio: gh<_i361.Dio>(),
        ));
    gh.factory<_i270.MapCubit>(() => _i270.MapCubit(
          api: gh<_i367.Api>(),
          geoService: gh<_i598.GeoService>(),
        ));
    gh.factory<_i498.HomePageCubit>(() => _i498.HomePageCubit(
          api: gh<_i367.Api>(),
          geoService: gh<_i598.GeoService>(),
        ));
    gh.factoryParam<_i14.AddEditViewCubit, _i612.Convention?, dynamic>((
      convention,
      _,
    ) =>
        _i14.AddEditViewCubit(
          api: gh<_i367.Api>(),
          authService: gh<_i781.AuthService>(),
          convention: convention,
        ));
    gh.factory<_i499.ManageCubit>(() => _i499.ManageCubit(
          gh<_i367.Api>(),
          gh<_i781.AuthService>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i821.RegisterModule {}
