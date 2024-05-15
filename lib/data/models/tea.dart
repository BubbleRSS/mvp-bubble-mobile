class Tea {
  final int? id;
  final int flavorId;
  final String rssLink;
  final String title;

  Tea({
    this.id,
    required this.flavorId,
    required this.rssLink,
    required this.title,
  });

  factory Tea.fromMap(Map<String, dynamic> map) {
    return Tea(
      id: map['id'],
      flavorId: map['flavor_id'],
      rssLink: map['rss_link'],
      title: map['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'flavor_id': flavorId,
      'rss_link': rssLink,
      'title': title,
    };
  }
}
