import 'package:convention_list/util/constants.dart';
import 'package:convention_list/widgets/app_progress_indicator.dart';
import 'package:convention_list/widgets/drawer/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../../models/category.dart' as model_category;
import 'add_edit_view_cubit.dart';

class AddEditView extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  AddEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Convention'), centerTitle: true, actions: [
        BlocListener<AddEditViewCubit, AddEditViewState>(
          listener: (context, state) async {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Save failed. ${state.error}')),
              );
            } else if (state.isFinished) {
              context.pop();
            }
          },
          child: BlocBuilder<AddEditViewCubit, AddEditViewState>(
            builder: (context, state) {
              return state.isBusy
                  ? const AppProgressIndicator(size: 24)
                  : IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () async {
                        await context.read<AddEditViewCubit>().saveConvention(_formKey.currentState);
                      },
                    );
            },
          ),
        ),
        Builder(builder: (builderContext) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () async {
              Scaffold.of(builderContext).openEndDrawer();
            },
          );
        }),
      ]),
      endDrawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AddEditViewCubit, AddEditViewState>(
            builder: (context, state) {
              return FormBuilder(
                key: _formKey,
                enabled: !state.isBusy,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (state.isAdmin) const SizedBox(height: 6),
                      if (state.isAdmin)
                        FormBuilderCheckbox(
                          name: 'isApproved',
                          title: const Text('Is Approved'),
                          initialValue: state.convention?.isApproved,
                        ),
                      const SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'name',
                        initialValue: state.convention?.name,
                        decoration: const InputDecoration(
                          label: Text('Name'),
                          isDense: true,
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 12),
                      FormBuilderDropdown(
                        name: 'category',
                        initialValue: state.convention?.category,
                        items: model_category.Category.values
                            .map(
                              (c) => DropdownMenuItem<model_category.Category>(
                                value: c,
                                child: Text(c.val),
                              ),
                            )
                            .toList(),
                        decoration: const InputDecoration(
                          label: Text('Category'),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'description',
                        initialValue: state.convention?.description,
                        decoration: const InputDecoration(
                          label: Text('Description'),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              name: 'startDate',
                              inputType: InputType.date,
                              initialValue: state.convention?.startDate,
                              decoration: const InputDecoration(
                                label: Text('Start Date'),
                                isDense: true,
                              ),
                              validator: (val) {
                                if (val == null) {
                                  return 'This field cannot be empty';
                                }
                                var endDate = _formKey.currentState?.fields['endDate']?.value as DateTime?;
                                if (endDate != null && endDate.isBefore(val)) {
                                  return 'Start date must be before end date';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FormBuilderDateTimePicker(
                              name: 'endDate',
                              initialValue: state.convention?.endDate,
                              inputType: InputType.date,
                              decoration: const InputDecoration(
                                label: Text('End Date'),
                                isDense: true,
                              ),
                              validator: (val) {
                                if (val == null) {
                                  return 'This field cannot be empty';
                                }
                                var startDate = _formKey.currentState?.fields['startDate']?.value as DateTime?;
                                if (startDate != null && startDate.isAfter(val)) {
                                  return 'End date must be after start date';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'websiteAddress',
                        initialValue: state.convention?.websiteAddress,
                        decoration: const InputDecoration(
                          label: Text('Website Address'),
                          isDense: true,
                        ),
                        validator: FormBuilderValidators.url(),
                      ),
                      const SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'venueName',
                        initialValue: state.convention?.venueName,
                        decoration: const InputDecoration(
                          label: Text('Venue Name'),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'address1',
                        initialValue: state.convention?.address1,
                        decoration: const InputDecoration(
                          label: Text('Address 1'),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'address2',
                        initialValue: state.convention?.address2,
                        decoration: const InputDecoration(
                          label: Text('Address 2'),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'city',
                        initialValue: state.convention?.city,
                        decoration: const InputDecoration(
                          label: Text('City'),
                          isDense: true,
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'state',
                        initialValue: state.convention?.state,
                        decoration: const InputDecoration(
                          label: Text('State/Province'),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'postalCode',
                        initialValue: state.convention?.postalCode,
                        decoration: const InputDecoration(
                          label: Text('Postal Code'),
                          isDense: true,
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 12),
                      FormBuilderTypeAhead(
                        name: 'country',
                        initialValue: state.convention == null ? 'United States' : state.convention!.country,
                        itemBuilder: (context, text) => Text(text),
                        suggestionsCallback: (text) =>
                            countryNames.map((c) => c.toLowerCase()).where((c) => c.startsWith(text)).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
