class McpServer {
  const McpServer({
    required this.id,
    required this.name,
    required this.url,
  });

  final String id;
  final String name;
  final String url;

  factory McpServer.fromJson(Map<String, dynamic> json) {
    return McpServer(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'url': url};
}
