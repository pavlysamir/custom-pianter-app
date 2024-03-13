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
  List<DrawingArea> points = [];
  late Color selectedColor;
  late double strokeWidth;

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height * 0.80,
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
                  onPanDown: (details) {
                    setState(() {
                      points.add(DrawingArea(
                          point: details.localPosition,
                          areaPaint: Paint()
                            ..strokeCap = StrokeCap.round
                            ..isAntiAlias = true
                            ..color = selectedColor
                            ..strokeWidth = strokeWidth));
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      points.add(DrawingArea(
                          point: details.localPosition,
                          areaPaint: Paint()
                            ..strokeCap = StrokeCap.round
                            ..isAntiAlias = true
                            ..color = selectedColor
                            ..strokeWidth = strokeWidth));
                    });
                  },
                  onPanEnd: (details) {
                    // setState(() {

                    // });
                  },
                  child: SizedBox.expand(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                      child: CustomPaint(
                        painter: MyCustomPainter(points: points),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
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
                            points.clear();
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
        )
      ]),
    ));
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      // Use the dialogPickerColor as start color.
      color: selectedColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) => setState(() => selectedColor = color),
      width: 40,
      height: 40,
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
