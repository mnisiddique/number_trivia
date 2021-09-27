import 'package:flutter/material.dart';

class Label extends StatefulWidget {
  final String number;
  final String text;
  final bool requiredSymbol;
  Label({this.number, this.text, this.requiredSymbol = false});
  @override
  _LabelState createState() => _LabelState();
}

class _LabelState extends State<Label> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(
            widget.number,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color.fromRGBO(0, 128, 0, 0.67),
                fontFamily: 'Roboto',
                fontSize: 11.0,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(width: 4.0),
          Text(
            widget.text,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color.fromRGBO(27, 94, 32, 0.67),
                fontFamily: 'Roboto',
                fontSize: 13.0,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(width: 4.0),
          widget.requiredSymbol
              ? Text(
                  "*",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 0, 0, 0.67),
                    fontFamily: 'Roboto',
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
