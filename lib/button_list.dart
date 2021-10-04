
import 'package:flutter/material.dart';
class button_list extends StatelessWidget {
  late final Color color;
  late final String text;
  late final Function onPressed;
  final Function backup=(){};
  button_list({required this.color,required this.text,required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed ?? backup(),
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}