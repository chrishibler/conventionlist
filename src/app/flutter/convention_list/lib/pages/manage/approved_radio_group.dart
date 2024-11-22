import 'package:flutter/material.dart';

class ApprovedRadioGroup extends StatefulWidget {
  const ApprovedRadioGroup({super.key, required this.onChanged});

  final void Function(bool?) onChanged;

  @override
  State<ApprovedRadioGroup> createState() => _ApprovedRadioGroupState();
}

class _ApprovedRadioGroupState extends State<ApprovedRadioGroup> {
  bool? approved;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<bool?>(
          title: const Text('All'),
          value: null,
          groupValue: approved,
          onChanged: widget.onChanged,
        ),
        RadioListTile<bool?>(
          title: const Text('Approved'),
          value: true,
          groupValue: approved,
          onChanged: _onValueChanged,
        ),
        RadioListTile<bool?>(
          title: const Text('Unapproved'),
          value: false,
          groupValue: approved,
          onChanged: _onValueChanged,
        )
      ],
    );
  }

  void _onValueChanged(bool? value) {
    setState(() {
      approved = value;
    });
    widget.onChanged(value);
  }
}
