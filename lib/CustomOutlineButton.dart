import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const CustomOutlineButton({Key key, this.text, this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        border: Border.all(color: this.color, width: 1.0),
        color: Colors.white,
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: RawMaterialButton(
        fillColor: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Lalezar',
                fontWeight: FontWeight.w400,
                color: this.color),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
