import 'package:flutter/material.dart';

import 'color.dart';



InputDecoration inputDecoration(
    {String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? labelText,
    bool isDense = true,
    bool addVPadding = false}) {
  return InputDecoration(
    alignLabelWithHint: true,
    contentPadding: EdgeInsets.symmetric(
        horizontal: 16, vertical: addVPadding ? 12.0 : 0.0),
    filled: true,
    fillColor: black5,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    //  isDense: isDense,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(
          color: Color(0xFFD1D2D8),
        )),
    disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(
          color: Color(0xFFD1D2D8),
        )),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(
          color: kPrimaryColor.withOpacity(0.5),
        )),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(
          color: Colors.red,
        )),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: BorderSide(
          color: Colors.red,
        )),
    hintText: hintText,
    labelText: labelText,
  );
}
