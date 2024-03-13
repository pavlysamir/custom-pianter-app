// import 'package:flex_color_picker/flex_color_picker.dart';
// import 'package:flutter/material.dart';

// void selectColor(BuildContext context, Color selectedColor, Color newColor,
//     Function() changeColor) {
//   ColorIndicator(
//       width: 40,
//       height: 40,
//       borderRadius: 0,
//       color: selectedColor,
//       elevation: 1,
//       onSelectFocus: false,
//       onSelect: () async {
//         // Wait for the dialog to return color selection result.
//         newColor = await showColorPickerDialog(
//           // The dialog needs a context, we pass it in.
//           context,
//           // We use the dialogSelectColor, as its starting color.
//           selectedColor,
//           title: Text('ColorPicker',
//               style: Theme.of(context).textTheme.titleLarge),
//           width: 40,
//           height: 40,
//           spacing: 0,
//           runSpacing: 0,
//           borderRadius: 0,
//           wheelDiameter: 165,
//           enableOpacity: true,
//           showColorCode: true,
//           colorCodeHasColor: true,
//           pickersEnabled: <ColorPickerType, bool>{
//             ColorPickerType.wheel: true,
//           },
//           copyPasteBehavior: const ColorPickerCopyPasteBehavior(
//             copyButton: true,
//             pasteButton: true,
//             longPressMenu: true,
//           ),
//           actionButtons: const ColorPickerActionButtons(
//             okButton: true,
//             closeButton: true,
//             dialogActionButtons: false,
//           ),
//           constraints: const BoxConstraints(
//               minHeight: 480, minWidth: 320, maxWidth: 320),
//         );
//         // We update the dialogSelectColor, to the returned result
//         // color. If the dialog was dismissed it actually returns
//         // the color we started with. The extra update for that
//         // below does not really matter, but if you want you can
//         // check if they are equal and skip the update below.
//         setState(() {
//           selectedColor = newColor;
//         });
        
//       });
// }
