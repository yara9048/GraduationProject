import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtpInputTemplate extends StatefulWidget {
  final int numberOfFields;
  final double fieldWidth;
  final double fieldHeight;
  final BorderRadius borderRadius;
  final Color fillColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Function(String) onSubmit;

  final String? errorText;
  final bool hasError;
  final Function(String)? onChanged;

  OtpInputTemplate({
    required this.numberOfFields,
    required this.fieldWidth,
    required this.fieldHeight,
    required this.borderRadius,
    required this.fillColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.onSubmit,
    this.errorText,
    this.hasError = false,
    this.onChanged,
  });

  @override
  _OtpInputTemplateState createState() => _OtpInputTemplateState();
}

class _OtpInputTemplateState extends State<OtpInputTemplate> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late bool _hasError;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.numberOfFields, (_) => TextEditingController());
    _focusNodes = List.generate(widget.numberOfFields, (_) => FocusNode());
    _hasError = widget.hasError;
  }

  @override
  void didUpdateWidget(covariant OtpInputTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hasError != widget.hasError) {
      setState(() => _hasError = widget.hasError);
    }
  }

  void _onChanged(String value, int index) {
    if (_hasError) setState(() => _hasError = false);

    if (value.length == 1 && index < widget.numberOfFields - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    String code = _controllers.map((c) => c.text).join();

    widget.onChanged?.call(code);

    if (code.length == widget.numberOfFields) {
      widget.onSubmit(code);
    }
  }

  String getCode() {
    return _controllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.numberOfFields, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: widget.fieldWidth,
              height: widget.fieldHeight,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: widget.fillColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: widget.borderRadius,
                    borderSide: BorderSide(
                      color: _hasError ? Color(0xffE76F51) : widget.borderColor,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: widget.borderRadius,
                    borderSide: BorderSide(
                      color: _hasError ? Color(0xffE76F51) : widget.focusedBorderColor,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => _onChanged(value, index),
              ),
            );
          }),
        ),
        if (_hasError && widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Color(0xffE76F51), fontSize: 14),
            ),
          )
      ],
    );
  }
}
