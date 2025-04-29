class CategoryModel {
  String? slug;
  String? name;
  String? url;

  CategoryModel({this.slug, this.name, this.url});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        slug: json['slug'], name: json['name'], url: json['url']);
  }
}
