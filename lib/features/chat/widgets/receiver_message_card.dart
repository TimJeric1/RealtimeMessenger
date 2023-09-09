import 'package:flutter/material.dart';
import '../../../common/models/enums/message_enum.dart';
import '../../../common/utils/colors.dart';
import 'display_text_image_gif.dart';

class ReceiverMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;

  const ReceiverMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
  }) : super(key: key);

  EdgeInsets _messagePadding() {
    return (type == MessageEnum.text)
        ? const EdgeInsets.only(
      left: 10,
      right: 30,
      top: 5,
      bottom: 20,
    )
        : const EdgeInsets.only(
      left: 5,
      top: 5,
      right: 5,
      bottom: 25,
    );
  }

  Widget _dateLabel() {
    return Positioned(
      bottom: 4,
      right: 10,
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.white60,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: myMessageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: _messagePadding(),
                child: DisplayTextImageGIF(
                  message: message,
                  type: type,
                ),
              ),
              _dateLabel(),
            ],
          ),
        ),
      ),
    );
  }
}
