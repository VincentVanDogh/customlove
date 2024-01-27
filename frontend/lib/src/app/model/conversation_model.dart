class Conversation {
  int id;
  int user1Id;
  int user2Id;

  Conversation({
    required this.id,
    required this.user1Id,
    required this.user2Id
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
        id: json['id'],
        user1Id: json['user1_id'],
        user2Id: json['user2_id']
    );
  }

  int? getOtherUserId(int? id) {
    if (id == null) {
      return null;
    }

    if (user1Id == id) {
      return user2Id;
    }

    return user1Id;
  }
}
