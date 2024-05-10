class Bubble {
  final int? id; // Nullable ID
  final int teaId;
  final String header;
  final String description;
  final String imageSource;
  final String datetime;

  Bubble({
    this.id,
    required this.teaId,
    required this.header,
    required this.description,
    required this.imageSource,
    required this.datetime,
  });

  factory Bubble.fromMap(Map<String, dynamic> map) {
    return Bubble(
      id: map['id'],
      teaId: map['tea_id'],
      header: map['header'],
      description: map['description'],
      imageSource: map['image_source'],
      datetime: map['datetime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tea_id': teaId,
      'header': header,
      'description': description,
      'image_source': imageSource,
      'datetime': datetime,
    };
  }
}
