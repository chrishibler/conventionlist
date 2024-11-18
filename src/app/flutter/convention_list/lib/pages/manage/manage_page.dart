import 'package:convention_list/pages/manage/manage_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import 'manage_view.dart';

class ManagePage extends StatelessWidget {
  final bool showSearchField;

  const ManagePage({super.key, required this.showSearchField});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ManageCubit>(),
      child: ManageView(
        showSearchField: showSearchField,
      ),
    );
  }
}
