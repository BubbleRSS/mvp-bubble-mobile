class Flavor {
  final int? id;
  final String title;
  final String icon;
  final String color;

  Flavor({
    this.id,
    required this.title,
    required this.icon,
    required this.color,
  });

  factory Flavor.fromMap(Map<String, dynamic> map) {
    return Flavor(
      id: map['id'],
      title: map['title'],
      icon: map['icon'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'color': color,
    };
  }
}
