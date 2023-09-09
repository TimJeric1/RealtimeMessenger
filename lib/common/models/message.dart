



import 'enums/message_enum.dart';

class Message {
  final String senderId;
  final String recieverid;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;

  const Message({
    required this.senderId,
    required this.recieverid,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Message &&
              runtimeType == other.runtimeType &&
              senderId == other.senderId &&
              recieverid == other.recieverid &&
              text == other.text &&
              type == other.type &&
              timeSent == other.timeSent &&
              messageId == other.messageId);

  @override
  int get hashCode =>
      senderId.hashCode ^
      recieverid.hashCode ^
      text.hashCode ^
      type.hashCode ^
      timeSent.hashCode ^
      messageId.hashCode;

  @override
  String toString() {
    return 'Message{' +
        ' senderId: $senderId,' +
        ' recieverid: $recieverid,' +
        ' text: $text,' +
        ' type: $type,' +
        ' timeSent: $timeSent,' +
        ' messageId: $messageId,'+
        '}';
  }

  Message copyWith({
    String? senderId,
    String? recieverid,
    String? text,
    MessageEnum? type,
    DateTime? timeSent,
    String? messageId,
    bool? isSeen,
    String? repliedMessage,
    String? repliedTo,
    MessageEnum? repliedMessageType,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      recieverid: recieverid ?? this.recieverid,
      text: text ?? this.text,
      type: type ?? this.type,
      timeSent: timeSent ?? this.timeSent,
      messageId: messageId ?? this.messageId,
    );
  }

  Map<String, dynamic> toMapJson() {
    return {
      'senderId': this.senderId,
      'recieverid': this.recieverid,
      'text': this.text,
      'type': this.type.enumToString(),
      'timeSent': this.timeSent.millisecondsSinceEpoch,
      'messageId': this.messageId,
    };
  }

  factory Message.fromMapJson(Map<String, dynamic> map) {

    return Message(
      senderId: map['senderId'] as String,
      recieverid: map['recieverid'] as String,
      text: map['text'] as String,
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverid': recieverid,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      recieverid: map['recieverid'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? '',
    );
  }
//</editor-fold>
}
