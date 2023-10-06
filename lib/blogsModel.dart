class blogs {
  final String id;
  final String urlLink;
  final String title;

  const blogs({
    required this.id, required this.urlLink, required this.title
  });

  factory blogs.fromJson(Map<String, dynamic> json) {
    return blogs(
      id: json['id'] as String,
      title: json['title'] as String,
      urlLink: json['image_url'] as String,

    );
  }
}

