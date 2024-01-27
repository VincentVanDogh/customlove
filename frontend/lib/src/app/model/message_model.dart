class Message {
  int? id;
  bool isImage;
  int conversationId;
  int senderId;
  int receiverId;
  String message;
  DateTime timestamp;

  Message({
    this.id,
    this.isImage = false,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json['id'],
        isImage: json['is_image'],
        conversationId: json['conversation_id'],
        senderId: json['sender_id'],
        receiverId: json['receiver_id'],
        message: json['message'],
        timestamp: DateTime.parse(json['timestamp']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_image': isImage,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'timestamp': timestamp.toString()
    };
  }

  String getPreview({int length = 40}) {
    if (message.length > length) {
      return "${message.substring(0, length)}...";
    }

    return message;
  }
}
