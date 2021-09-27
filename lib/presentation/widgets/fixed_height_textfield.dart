import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_trivia/presentation/widgets/input_label.dart';

class FixedHeightTextField extends StatefulWidget {
  final double textFieldHeight = 36.0;
  final Function(String) onChange;
  final TextInputType keyboardType;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final String hintText;
  final String errorMsg;
  final String labelNumber;
  final String labelText;
  final String text;
  final int maxLength;
  final bool isReadOnly;
  final bool required;
  final inputFormatters;

  FixedHeightTextField(
      {this.onChange,
      this.keyboardType,
      this.textStyle,
      this.hintStyle,
      this.hintText,
      this.maxLength,
      this.labelNumber,
      this.labelText,
      this.text,
      this.isReadOnly = false,
      this.errorMsg,
      this.required = false,
      this.inputFormatters});

  @override
  _FixedHeightTFState createState() {
    return _FixedHeightTFState();
  }
}

class _FixedHeightTFState extends State<FixedHeightTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.required
            ? Label(
                number: widget.labelNumber,
                text: widget.labelText,
                requiredSymbol: true,
              )
            : Label(
                number: widget.labelNumber,
                text: widget.labelText,
              ),
        _textField()
      ],
    );
  }

  Widget _textField() {
    return SizedBox(
      height: widget.textFieldHeight,
      child: TextField(
        onChanged: widget.onChange,
        controller: widget.text != null
            ? TextEditingController(text: widget.text)
            : null,
        keyboardType: widget.keyboardType,
        readOnly: widget.isReadOnly,
        maxLength: widget.maxLength ?? TextField.noMaxLength,
        style: _inputTextStyle(),
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: _getHintText(),
          contentPadding: EdgeInsets.only(left: 16.0, right: 16.0, top: 9.0),
          hintStyle: widget.hintStyle,
          counterText: "",
          border: _getBorder(),
          enabledBorder: _getBorder(),
          focusedBorder: _getBorder(),
        ),
      ),
    );
  }

  OutlineInputBorder _getBorder() {
    if (widget.isReadOnly) {
      return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[500]),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      );
    }
    return OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(27, 94, 32, 0.67)),
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );
  }

  String _getHintText() {
    final localizedText = widget.hintText;
    if (localizedText == null) {
      return widget.hintText;
    }
    return localizedText;
  }

  TextStyle _inputTextStyle() {
    if (widget.isReadOnly) {
      return TextStyle(
          fontFamily: "Roboto",
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Color(0x9122241C),
          decoration: TextDecoration.none);
    }
    return widget.textStyle;
  }
}
