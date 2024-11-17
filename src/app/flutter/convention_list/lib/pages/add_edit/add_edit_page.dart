import 'package:convention_list/pages/add_edit/add_edit_view.dart';
import 'package:flutter/material.dart';

import '../../models/convention.dart';

class AddEditPage extends StatelessWidget {
  const AddEditPage({super.key, this.convention, this.refresh});

  final Convention? convention;
  final Future<void> Function()? refresh;

  @override
  Widget build(BuildContext context) {
    return AddEditView(
      returnRoute: '/edit',
      convention: convention,
      refresh: refresh,
    );
  }
}
