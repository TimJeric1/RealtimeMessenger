import 'dart:io';
import 'dart:typed_data';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Uint8List stringTobytes(String source) {
  final List<int> list = [];
  source.runes.forEach((rune) {
    if (rune >= 0x10000) {
      rune -= 0x10000;
      int firstWord = (rune >> 10) + 0xD800;
      list.add(firstWord >> 8);
      list.add(firstWord & 0xFF);
      int secondWord = (rune & 0x3FF) + 0xDC00;
      list.add(secondWord >> 8);
      list.add(secondWord & 0xFF);
    } else {
      list.add(rune >> 8);
      list.add(rune & 0xFF);
    }
  });
  Uint8List bytes = Uint8List.fromList(list);
  return bytes;
}

String bytesToString(Uint8List bytes) {
  StringBuffer buffer = StringBuffer();

  for (int i = 0; i < bytes.length;) {
    int firstWord = (bytes[i] << 8) + bytes[i + 1];
    if (0xD800 <= firstWord && firstWord <= 0xDBFF) {
      int secondWord = (bytes[i + 2] << 8) + bytes[i + 3];
      buffer.writeCharCode(
          ((firstWord - 0xD800) << 10) + (secondWord - 0xDC00) + 0x10000);
      i += 4;
    } else {
      buffer.writeCharCode(firstWord);
      i += 2;
    }
  }
  String outcome = buffer.toString();
  return outcome;
}


Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
      context: context,
      apiKey: 'PXXwAnwOsO7k1Q6Jk0mmEmBiEcucu1RG',
    );
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return gif;
}

