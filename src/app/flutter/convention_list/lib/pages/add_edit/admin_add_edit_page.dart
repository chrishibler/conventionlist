import 'package:convention_list/pages/add_edit/add_edit_view.dart';
import 'package:flutter/material.dart';

import '../../models/convention.dart';

class AdminAddEditPage extends StatelessWidget {
  const AdminAddEditPage({super.key, this.convention, this.refresh});

  final Convention? convention;
  final Future<void> Function()? refresh;

  @override
  Widget build(BuildContext context) {
    return AddEditView(
      returnRoute: '/admin',
      convention: convention,
      refresh: refresh,
    );
  }
}
