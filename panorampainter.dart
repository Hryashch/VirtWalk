import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:ui' as ui;

Future<Image> mergeImages(List<String> imageUrls) async {
  List<Uint8List> imageBytesList = [];

  for (String url in imageUrls) {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      imageBytesList.add(response.bodyBytes);
    } else {
      print('Failed to load image from $url');
    }
  }

  ui.PictureRecorder recorder = ui.PictureRecorder();
  ui.Canvas canvas = ui.Canvas(recorder);
  double totalWidth = 0.0;
  double maxHeight = 0.0;

  for (Uint8List bytes in imageBytesList) {
    ui.Image image = await decodeImageFromList(bytes);
    if (image != null) {
      canvas.drawImage(image, Offset(totalWidth, 0), Paint());
      totalWidth += image.width.toDouble();
      maxHeight = maxHeight > image.height.toDouble() ? maxHeight : image.height.toDouble();
    }
  }

  ui.Image finalImage = await recorder.endRecording().toImage(totalWidth.toInt(), maxHeight.toInt());
  ByteData? byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
  if (byteData != null) {
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return Image.memory(pngBytes);
  } else {
    // Handle error if conversion to ByteData fails
    throw Exception('Failed to convert canvas to image bytes');
  }

}
