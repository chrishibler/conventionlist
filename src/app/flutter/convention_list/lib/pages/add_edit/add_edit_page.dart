import 'package:convention_list/pages/add_edit/add_edit_view.dart';
import 'package:convention_list/pages/add_edit/add_edit_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../../models/convention.dart';

class AddEditPage extends StatelessWidget {
  const AddEditPage({super.key, this.convention});

  final Convention? convention;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddEditViewCubit>(param1: convention),
      child: AddEditView(),
    );
  }
}
