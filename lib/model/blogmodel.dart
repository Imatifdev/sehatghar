class Blog {
  String id;
  String categoryId;
  String subCategoryId;
  String status;
  DateTime createdAt;
  String image;
  AgentId agentId;
  String title;
  String routeTitle;
  String content;

  Blog({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.status,
    required this.createdAt,
    required this.image,
    required this.agentId,
    required this.title,
    required this.routeTitle,
    required this.content,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['_id'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      image: json['image'],
      agentId: json['agentId'] != null
          ? AgentId.fromJson(json['agentId'])
          : AgentId(id: '', name: '', firstName: ''),
      title: json['title'],
      routeTitle: json['route_title'],
      content: json['content'],
    );
  }
}

class AgentId {
  String id;
  String? image;
  String name;
  String firstName;

  AgentId({
    required this.id,
    this.image,
    required this.name,
    required this.firstName,
  });

  factory AgentId.fromJson(Map<String, dynamic> json) {
    return AgentId(
      id: json['_id'] ?? '', // Use empty string as default value if _id is null
      image: json['image'],
      name: json['name'] ??
          '', // Use empty string as default value if name is null
      firstName: json['first_name'] ??
          '', // Use empty string as default value if first_name is null
    );
  }
}
