import 'package:flutter/material.dart';
import 'package:taskapp/utils/AppTheme.dart';

// ignore: must_be_immutable
class CustomElevation extends StatelessWidget {
  final Widget child;

  double radius=25;

  CustomElevation({required this.child}) : assert(child != null);
  //, this.radius

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.all(Radius.circular(radius)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.appButtonGrey, //Colors.blue.withOpacity(0.1),
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: this.child,
    );
  }
}