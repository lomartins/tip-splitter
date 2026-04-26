import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TapToEditField extends StatefulWidget {
  const TapToEditField({
    super.key,
    required this.value,
    required this.onSubmitted,
    this.suffix,
    this.style,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.inputFormatters,
  });

  final String value;
  final ValueChanged<String> onSubmitted;
  final String? suffix;
  final TextStyle? style;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<TapToEditField> createState() => _TapToEditFieldState();
}

class _TapToEditFieldState extends State<TapToEditField> {
  bool _editing = false;
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant TapToEditField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing && oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _editing) {
      _commit();
    }
  }

  void _commit() {
    setState(() => _editing = false);
    widget.onSubmitted(_controller.text);
  }

  void _startEditing() {
    setState(() {
      _controller.text = widget.value;
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
      _editing = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? Theme.of(context).textTheme.headlineSmall;
    if (_editing) {
      return TextField(
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        style: style,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
          suffixText: widget.suffix,
        ),
        onSubmitted: (_) => _commit(),
      );
    }
    return InkWell(
      onTap: _startEditing,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          widget.suffix == null ? widget.value : '${widget.value}${widget.suffix}',
          style: style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
