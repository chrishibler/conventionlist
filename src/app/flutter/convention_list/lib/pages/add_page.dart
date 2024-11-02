import 'package:convention_list/models/new_convention.dart';
import 'package:convention_list/util/constants.dart';
import 'package:convention_list/widgets/app_progress_indicator.dart';
import 'package:convention_list/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../services/api.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isBusy = false;

  void setIsBusy(bool busy) {
    setState(() {
      _isBusy = busy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Convention'), actions: [
        _isBusy
            ? const AppProgressIndicator(size: 24)
            : IconButton(
                icon: const Icon(Icons.save),
                onPressed: () async {
                  setIsBusy(true);
                  try {
                    bool success = await _saveConvention();
                    if (context.mounted) {
                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Some fields are invalid.')),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Save failed. $e')),
                      );
                    }
                  } finally {
                    setIsBusy(false);
                  }
                },
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
          child: FormBuilder(
            key: _formKey,
            enabled: !_isBusy,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'name',
                    decoration: const InputDecoration(
                      label: Text('Name'),
                      isDense: true,
                    ),
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderDropdown(
                    name: 'category',
                    items: const [
                      DropdownMenuItem<int>(value: 0, child: Text('None')),
                      DropdownMenuItem<int>(value: 1, child: Text('Sci-Fi and Fantasy')),
                      DropdownMenuItem<int>(value: 2, child: Text('Anime')),
                      DropdownMenuItem<int>(value: 3, child: Text('Gaming')),
                      DropdownMenuItem<int>(value: 4, child: Text('Comics')),
                      DropdownMenuItem<int>(value: 5, child: Text('Book')),
                      DropdownMenuItem<int>(value: 6, child: Text('Collectibles')),
                      DropdownMenuItem<int>(value: 7, child: Text('Sports')),
                    ],
                    decoration: const InputDecoration(
                      label: Text('Category'),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderTextField(
                    name: 'description',
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
                    decoration: const InputDecoration(
                      label: Text('Website Address'),
                      isDense: true,
                    ),
                    validator: FormBuilderValidators.url(),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderTextField(
                    name: 'venueName',
                    decoration: const InputDecoration(
                      label: Text('Venue Name'),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderTextField(
                    name: 'address1',
                    decoration: const InputDecoration(
                      label: Text('Address 1'),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderTextField(
                    name: 'address2',
                    decoration: const InputDecoration(
                      label: Text('Address 2'),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderTextField(
                    name: 'city',
                    decoration: const InputDecoration(
                      label: Text('City'),
                      isDense: true,
                    ),
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderTextField(
                    name: 'state',
                    decoration: const InputDecoration(
                      label: Text('State/Province'),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderTextField(
                    name: 'postalCode',
                    decoration: const InputDecoration(
                      label: Text('Postal Code'),
                      isDense: true,
                    ),
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 12),
                  FormBuilderDropdown<String>(
                    name: 'country',
                    initialValue: 'United States',
                    decoration: const InputDecoration(
                      label: Text('Country'),
                      isDense: true,
                    ),
                    items: countryNames
                        .map(
                          (c) => DropdownMenuItem(value: c, child: Text(c)),
                        )
                        .toList(growable: false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _saveConvention() async {
    if (_formKey.currentState == null) {
      return false;
    }

    bool isValid = _formKey.currentState!.saveAndValidate();
    if (!isValid) {
      return false;
    }

    var value = _formKey.currentState!.value;

    NewConvention newCon = NewConvention(
      name: value['name'],
      startDate: value['startDate'],
      endDate: value['endDate'],
      description: value['description'],
      category: value['category'] ?? 0,
      websiteAddress: value['websiteAddress'],
      venueName: value['venueName'],
      address1: value['address1'],
      address2: value['address2'],
      city: value['city'],
      state: value['state'],
      postalCode: value['postalCode'],
      country: value['country'],
    );

    await Api().postConvention(newCon);
    return true;
  }
}
