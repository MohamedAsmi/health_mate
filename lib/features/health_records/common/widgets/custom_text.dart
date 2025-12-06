import 'package:flutter/material.dart';
import 'package:healthmate/theme/app_theme.dart';

class CustomText extends StatelessWidget {
  final String data;
  final double? fontsize;
  final FontWeight? fontWeight;
  final Color? color;

  const CustomText(this.data, {super.key, this.fontsize, this.fontWeight, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontSize: fontsize ?? 12,
        fontWeight: fontWeight ??  FontWeight.w500,
        color: color ?? AppTheme.onPrimaryColor,
      ),
    );
  }
}
