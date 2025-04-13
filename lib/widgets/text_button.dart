import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:say_it/constants/app_colors.dart';

class AppTextButton extends StatelessWidget {
  final String title;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final BoxDecoration? decoration;
  final bool isIcon;
  final Color? buttonColor;
  final void Function()? onTap;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final bool loading;
  final Color? loadingColor;

  const AppTextButton(
      {super.key,
      this.height,
      this.width,
      this.margin,
      this.padding,
      this.decoration,
      required this.title,
      this.textColor,
      this.onTap,
      this.isIcon = false,
      this.fontSize,
      this.fontWeight,
      this.buttonColor,
      this.borderRadius,
      this.borderColor,
      this.loading = false,
      this.loadingColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      child: Container(
        height: height ?? 45,
        width: width ?? double.infinity,
        padding: padding,
        margin: margin,
        decoration: decoration ??
            BoxDecoration(
              border: Border.all(color: borderColor ?? Colors.transparent),
              borderRadius: borderRadius ?? BorderRadius.circular(10),
              color: buttonColor ?? AppColors.appColor.shade600,
            ),
        child: Center(
            child: loading
                ? CupertinoActivityIndicator(
                    color: loadingColor ?? textColor)
                : Text(title,
                    style: TextStyle(
                            fontSize: fontSize ?? 17,
                            color: textColor ?? AppColors.appColor.shade100)
                        .copyWith(
                            fontWeight: fontWeight ?? FontWeight.normal))),
      ),
    );
  }
}
