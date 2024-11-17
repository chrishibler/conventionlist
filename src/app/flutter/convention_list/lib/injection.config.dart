// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:convention_list/services/api.dart' as _i367;
import 'package:convention_list/services/auth_service.dart' as _i781;
import 'package:convention_list/services/geo_service.dart' as _i598;
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
    gh.lazySingleton<_i781.AuthService>(() => _i781.AuthService());
    gh.lazySingleton<_i598.GeoService>(() => _i598.GeoService());
    gh.lazySingleton<_i367.Api>(
        () => _i367.Api(authService: gh<_i781.AuthService>()));
    return this;
  }
}
