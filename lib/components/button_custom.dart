import 'package:flutter/material.dart';

class ButtomCustom extends StatefulWidget {
  final String title;
  final VoidCallback function;
  final double width;
  final double height;
  final Color color;

  const ButtomCustom(
      {super.key,
      required this.title,
      required this.function,
      this.width = 110,
      this.height = 40,
      this.color = const Color.fromARGB(255, 87, 0, 150)});

  @override
  _ButtonCustom createState() => _ButtonCustom();
}

class _ButtonCustom extends State<ButtomCustom> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
            ),
            onPressed: widget.function,
            child: Text(widget.title)));
  }
}
