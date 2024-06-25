class Bubble {
  final int? id; // Nullable ID
  final int? teaId;
  final String? header;
  final String? description;
  final String? imageProfile;
  final String? imageSource;
  final String? datetime;
  final String? link; 

  Bubble({
    this.id,
    this.teaId,
    this.header,
    this.description,
    this.imageProfile,
    this.imageSource,
    this.datetime,
    this.link
  });

  factory Bubble.fromMap(Map<String, dynamic> map) {
    return Bubble(
      id: map['id'],
      teaId: map['tea_id'],
      header: map['header'],
      description: map['description'],
      imageProfile: map['image_profile'],
      imageSource: map['image_source'],
      datetime: map['datetime'],
      link: map['link']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tea_id': teaId,
      'header': header,
      'description': description,
      'image_profile': imageProfile,
      'image_source': imageSource,
      'datetime': datetime,
      'link': link
    };
  }
}
