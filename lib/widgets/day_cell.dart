import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:year_in_pixel_app/models/menuSelection.dart';

import '../providers/menuSelectionProvider.dart';
import 'line_painter.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class DayCellWidget extends StatefulWidget {
  final int day;
  final int month;
  final int year;
  final String type;

  DayCellWidget(
      {required this.year,
      required this.month,
      required this.day,
      required this.type});

  @override
  _DayCellWidgetState createState() => _DayCellWidgetState();
}

class _DayCellWidgetState extends State<DayCellWidget> {
  late int day;
  late int month;
  late int year;
  late String type;

  late int currYear;
  late int currMonth;
  late int currDay;

  @override
  void initState() {
    DateTime now = DateTime.now();
    currYear = now.year;
    currMonth = now.month;
    currDay = now.day;

    super.initState();
    year = widget.year;
    month = widget.month;
    day = widget.day;
    type = widget.type;

    if (type == "0" &&
        (currYear > year ||
            (month * 31) + day <= ((currMonth) * 31) + currDay - 3)) {
      type = "7";
    }
  }

  final Map<String, Widget?> typeStyleChild = {
    "0": null,
    "1": null,
    "2": null,
    "3": null,
    "4": null,
    "5": null,
    "6": null,
    "7": Container(
      width: 300,
      height: 400,
      child: CustomPaint(painter: LinePainter()),
    ),
    "8": null
  };

  final Map<String, Color?> typeStyleColor = {
    "0": Colors.transparent,
    "1": Colors.red,
    "2": Colors.orange,
    "3": Colors.yellow,
    "4": Colors.purple,
    "5": Colors.cyan,
    "6": Colors.green,
    "7": Colors.transparent,
    "8": Colors.black,
  };

  final dio = Dio();

  void updateDay(int year, int month, int day, String type) async {
    Response response = await dio.get(
      "https://mandarinshow.ru/api/pixels/year/${year}/uid/1/type/update",
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      queryParameters: {
        "year": year,
        "month": month - 1,
        "day": day - 1,
        "info": type
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        this.type = type;
      });
    } else {
      print('Ошибка получения данных: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuSelectionProvider = Provider.of<MenuSelectionProvider>(context);
    final selectedMenu = menuSelectionProvider.selectedMenu;

    if (type == "0") {
      return Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: typeStyleColor[type],
          border: Border.all(
              color: Color(0xFF000000), width: 1.0, style: BorderStyle.solid),
        ),
        height: 22,
        width: 22,
        child: Material(child: InkWell(
          onTap: () {
            var newDayType = MenuSelection().menuItemType[selectedMenu];
            if (newDayType != null) {
              if ((month * 31) + day < ((currMonth) * 31) + currDay + 1) {
                updateDay(year, month, day, newDayType);
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Выберите настроение (кнопочка справа)"),
              ));
            }
          }, // Handle your callback
        )),
      );
    } else if (type == "7") {
      return Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: typeStyleColor[type],
          border: Border.all(
              color: Color(0xFF000000), width: 1.0, style: BorderStyle.solid),
        ),
        height: 22,
        width: 22,
        child: typeStyleChild[type],
      );
    } else {
      return Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: typeStyleColor[type],
          border: Border.all(
              color: Color(0xFF000000), width: 1.0, style: BorderStyle.solid),
        ),
        height: 22,
        width: 22,
      );
    }
  }
}
