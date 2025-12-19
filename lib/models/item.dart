class Item {
  final int? id;
  final String title;
  final String image;
  final String description;

  Item({
    this.id,
    required this.title,
    required this.image,
    required this.description,
  });

  factory Item.emptyItem() {
    return Item(id: null, title: '', image: '', description: '');
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'description': description,
      if(id != null) 'id': id,
    };
  }
}
