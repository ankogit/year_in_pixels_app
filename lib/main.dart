import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:year_in_pixel_app/providers/menuSelectionProvider.dart';
import 'package:year_in_pixel_app/widgets/main_table.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patterns_canvas/patterns_canvas.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:lottie/lottie.dart';

import 'models/menuSelection.dart';

// class MyPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTWH(80, 50, 200, 100);
//     DiagonalStripesLight(
//             bgColor: Colors.lightGreenAccent, fgColor: Colors.black)
//         .paintOnRect(canvas, size, rect);

//     final path = Path();
//     path.moveTo(120, 200);
//     path.lineTo(300, 280);
//     path.quadraticBezierTo(20, 400, 40, 300);
//     path.close();
//     Crosshatch(bgColor: Colors.yellow, fgColor: Colors.black)
//         .paintOnPath(canvas, size, path);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     // TODO: implement shouldRepaint
//     throw UnimplementedError();
//   }
// }
class ContainerPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // final Rect halfCanvas =
    // Rect.fromLTWH(0, size.height, size.width, size.height);
    SubtlePatch(
            bgColor: Colors.white,
            fgColor: HexColor.fromHex("#eeeeee"),
            featuresCount: 40)
        .paintOnWidget(canvas, size);
    // Dots(
    //         bgColor: Color(0xff0509050),
    //         fgColor: Color(0xfffdbf6f),
    //         featuresCount: 100)
    //     .paintOnWidget(canvas, size);

    // VerticalStripesThick(
    // bgColor: Color(0xff0509050), fgColor: Color(0xfffdbf6f))
    // .paintOnWidget(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final MenuSelectionProvider _menuSelectionProvider = MenuSelectionProvider();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _menuSelectionProvider,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'Year in Pixels'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MenuItem? selectedMenu;

  final typeStyleColor = {
    MenuItem.item1: Colors.red,
    MenuItem.item2: Colors.orange,
    MenuItem.item3: Colors.yellow,
    MenuItem.item4: Colors.purple,
    MenuItem.item5: Colors.cyan,
    MenuItem.item6: Colors.green,
  };
  @override
  Widget build(BuildContext context) {
    final _menuSelectionProvider = Provider.of<MenuSelectionProvider>(context);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: CustomPaint(
        painter: ContainerPatternPainter(),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: InteractiveViewer(
                boundaryMargin: EdgeInsets.all(double.infinity),
                minScale: 0.2,
                child: Container(
                  margin: const EdgeInsets.only(top: 100.0),
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: Center(
                    // Center is a layout widget. It takes a single child and positions it
                    // in the middle of the parent.
                    child: Column(
                      // Column is also a layout widget. It takes a list of children and
                      // arranges them vertically. By default, it sizes itself to fit its
                      // children horizontally, and tries to be as tall as its parent.
                      //
                      // Invoke "debug painting" (press "p" in the console, choose the
                      // "Toggle Debug Paint" action from the Flutter Inspector in Android
                      // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                      // to see the wireframe for each widget.
                      //
                      // Column has various properties to control how it sizes itself and
                      // how it positions its children. Here we use mainAxisAlignment to
                      // center the children vertically; the main axis here is the vertical
                      // axis because Columns are vertical (the cross axis would be
                      // horizontal).
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MainTableWidget(),

                        // CustomPaint(
                        //   size: const Size(double.infinity, double.infinity),
                        //   painter: MyPainter(),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: typeStyleColor[selectedMenu] ?? Colors.white,
                    border: Border.all(
                        color: Colors.black,
                        width: 2,
                        style: BorderStyle.solid)),
                child: PopupMenuButton<MenuItem>(
                  tooltip: "Настроение",
                  initialValue: selectedMenu,
                  // Callback that sets the selected popup menu item.
                  onSelected: (MenuItem item) {
                    setState(() {
                      selectedMenu = item;
                      _menuSelectionProvider.selectedMenu = item;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<MenuItem>>[
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.item1,
                      child: Text('Отличный'),
                    ),
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.item2,
                      child: Text('Хороший'),
                    ),
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.item3,
                      child: Text('Обычный'),
                    ),
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.item4,
                      child: Text('Устал'),
                    ),
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.item5,
                      child: Text('Плохой'),
                    ),
                    const PopupMenuItem<MenuItem>(
                      value: MenuItem.item6,
                      child: Text('Болею'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
