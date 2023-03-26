import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:year_in_pixel_app/models/year_data.dart';
import 'dart:convert';

import 'day_cell.dart';

class MainTableWidget extends StatefulWidget {
  @override
  _MainTableWidgetState createState() => _MainTableWidgetState();
}

class _MainTableWidgetState extends State<MainTableWidget> {
  final dio = Dio();
  bool _isLoading = true;
  late int currYear = 2023;

  static const months = [
    "Я",
    "Ф",
    "М",
    "А",
    "М",
    "И",
    "И",
    "А",
    "С",
    "О",
    "Н",
    "Д"
  ];
  late YearData yearData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void changeYear(newYear) async {
    setState(() {
      currYear = newYear;
    });
    fetchData();
  }

  void fetchData() async {
    setState(() {
      _isLoading = true;
    });

    Response response;
    response = await dio
        .get('https://mandarinshow.ru/api/pixels/year/${currYear}/uid/1');

    if (response.statusCode == 200) {
      setState(() {
        var jsonData = jsonDecode(response.data);
        yearData = YearData.fromJson(jsonData[0]);
        _isLoading = false;
      });
    } else {
      print('Ошибка получения данных: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Color(0xFF000000),
                      width: 1.0,
                      style: BorderStyle.solid),
                ),
                child: Stack(
                  children: [Center(child: CircularProgressIndicator())],
                )))
        : Container(
            // width: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Color(0xFF000000),
                  width: 1.0,
                  style: BorderStyle.solid),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 5, right: 15, top: 20, bottom: 20),
              child: Column(children: [
                Column(children: [
                  Container(
                    width: 300,
                    child: Row(children: [
                      TextButton(
                        onPressed: () {
                          if ((yearData.year >= DateTime.now().year - 5)) {
                            changeYear(--currYear);
                          }
                        },
                        child: const Icon(
                          Icons.arrow_left,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(), // <-- SEE HERE
                      Text(currYear.toString()),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          if (yearData.year < DateTime.now().year) {
                            changeYear(++currYear);
                          }
                        },
                        child:
                            const Icon(Icons.arrow_right, color: Colors.black),
                      ),
                    ]),
                  )
                ]),
                Column(children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                        // border: TableBorder.all(width: 1.0, color: Colors.black),
                        defaultColumnWidth: const FixedColumnWidth(25.0),
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Container(
                                margin: EdgeInsets.all(2),
                                height: 22,
                                width: 22,
                              ),
                            ),
                            for (int monthIndex = 0;
                                monthIndex < months.length;
                                monthIndex++)
                              Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: HexColor.fromHex('#ffcc00'),
                                    border: Border.all(
                                        color: Color(0xFF000000),
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                  ),
                                  height: 22,
                                  width: 22,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        months[monthIndex],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ]),
                          for (int i = 1; i <= 31; i++)
                            TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  height: 22,
                                  width: 22,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        i.toString(),
                                        style: TextStyle(fontSize: 10.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              for (int monthIndex = 0;
                                  monthIndex < months.length;
                                  monthIndex++)
                                DayCellWidget(
                                    year: yearData.year,
                                    day: i,
                                    month: monthIndex + 1,
                                    type: yearData.months[monthIndex][i - 1])
                            ])
                        ]),
                  ),
                ]),
              ]),
            ),
          );
  }
}
