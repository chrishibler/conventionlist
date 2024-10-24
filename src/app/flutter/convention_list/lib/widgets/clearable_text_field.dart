import 'package:convention_list/theme/mocha.dart';
import 'package:flutter/material.dart';

class ClearableTextField extends StatefulWidget {
  const ClearableTextField({
    super.key,
    required this.hintText,
    this.onChanged,
  });

  final void Function(String)? onChanged;
  final String hintText;

  @override
  State<ClearableTextField> createState() => _ClearableTextFieldState();
}

class _ClearableTextFieldState extends State<ClearableTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.addListener(() {
      widget.onChanged!(_controller.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(fontSize: 20.0, color: CatppuccinMocha.overlay2),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Opacity(
                  opacity: 0.85,
                  child: Icon(Icons.clear),
                ),
                onPressed: () => setState(() => _controller.clear()),
              ),
      ),
      onChanged: widget.onChanged,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
