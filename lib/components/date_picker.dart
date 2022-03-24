import 'package:flutter/material.dart';

import 'package:flutter_app/utils/color.dart';

class DatePicker {
  DateTime selectedDate = DateTime.now();

  Future<DateTime?> show(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal.shade200,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: MyColor.accentColor,
              )
            )
          ),
          child: child!,
        );
      }
    );
  }
}