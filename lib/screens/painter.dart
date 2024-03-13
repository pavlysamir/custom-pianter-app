import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:painter_art/models/drawing_area.dart';
import 'package:painter_art/screens/my_custom_painter.dart';

class Painter extends StatefulWidget {
  const Painter({super.key});

  @override
  State<Painter> createState() => _PainterState();
}

class _PainterState extends State<Painter> {
  late double strokeWidth;

  final List<Color> availableColors = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown,
  ];

  List<DrawingPoint> historyDrawingPoints = [];
  List<DrawingPoint> drawingPoints = [];
  Color selectedColor = Colors.black;
  // double selectedWidth = 2.0;
  DrawingPoint? currentDrawingPoint;

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromRGBO(138, 35, 135, 1.0),
                  Color.fromRGBO(233, 64, 87, 1.0),
                  Color.fromRGBO(242, 113, 33, 1.0),
                ])),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.010,
                ),
                Container(
                  height: height * 0.75,
                  width: width * 0.80,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        ),
                      ]),
                  child: GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        currentDrawingPoint = DrawingPoint(
                          id: DateTime.now().microsecondsSinceEpoch,
                          offsets: [details.localPosition],
                          color: selectedColor,
                          width: strokeWidth,
                        );
                        if (currentDrawingPoint != null) {
                          drawingPoints.add(currentDrawingPoint!);
                          historyDrawingPoints = List.of(drawingPoints);
                        }
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        if (currentDrawingPoint != null) {
                          currentDrawingPoint = currentDrawingPoint!.copyWith(
                            offsets: [
                              ...currentDrawingPoint!.offsets,
                              details.localPosition
                            ],
                          );
                          drawingPoints.last = currentDrawingPoint!;
                          historyDrawingPoints = List.of(drawingPoints);
                        }
                      });
                    },
                    onPanEnd: (_) {
                      currentDrawingPoint = null;
                    },
                    child: SizedBox.expand(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        child: CustomPaint(
                          painter: DrawingPainter(drawingPoints: drawingPoints),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.010,
                ),
                Container(
                  width: width * 0.80,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.color_lens,
                            color: selectedColor,
                          ),
                          onPressed: () {
                            colorPickerDialog();
                          }),
                      Expanded(
                        child: Slider(
                          min: 1.0,
                          max: 5.0,
                          label: "Stroke $strokeWidth",
                          activeColor: selectedColor,
                          value: strokeWidth,
                          onChanged: (double value) {
                            setState(() {
                              strokeWidth = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.layers_clear,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              drawingPoints.clear();
                            });
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.010,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (drawingPoints.isNotEmpty &&
                            historyDrawingPoints.isNotEmpty) {
                          setState(() {
                            drawingPoints.removeLast();
                          });
                        }
                      },
                      child: Container(
                        width: width * 0.15,
                        height: height * 0.07,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Icon(Icons.undo),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (drawingPoints.length <
                              historyDrawingPoints.length) {
                            final index = drawingPoints.length;
                            drawingPoints.add(historyDrawingPoints[index]);
                          }
                        });
                      },
                      child: Container(
                        width: width * 0.15,
                        height: height * 0.07,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Icon(Icons.redo),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      // Use the dialogPickerColor as start color.
      color: selectedColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) => setState(() => selectedColor = color),
      width: 40,
      height: 30,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      // customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      // New in version 3.0.0 custom transitions support.
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }
}
