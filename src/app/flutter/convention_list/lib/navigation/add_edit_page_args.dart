import '../models/convention.dart';

class AddEditPageArgs {
  final String returnRoute;
  final Convention? convention;
  final Future<void> Function()? refresh;

  AddEditPageArgs({
    required this.returnRoute,
    this.convention,
    this.refresh,
  });
}
