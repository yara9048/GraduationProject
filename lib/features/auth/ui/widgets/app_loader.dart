import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final double? size;
  final Color? color;

  const AppLoader({Key? key, this.size = 30, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? Theme.of(context).primaryColor,
        strokeWidth: 3,
      ),
    );
  }
}
