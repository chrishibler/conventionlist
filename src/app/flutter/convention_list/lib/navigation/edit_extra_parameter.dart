import '../models/convention.dart';

class EditExtraParameter {
  Convention convention;
  Future<void> Function() refresh;

  EditExtraParameter({required this.convention, required this.refresh});
}
