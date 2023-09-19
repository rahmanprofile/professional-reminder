class Models {
  final int? id;
  final String title;
  final String body;

  Models({
    this.id,
    required this.title,
    required this.body,
  });

  Models.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        body = res['body'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
