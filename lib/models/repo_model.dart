class RepoModel {
  final String name;
  final String visibility;
  final String defaultBranch;

  RepoModel({
    required this.name,
    required this.visibility,
    required this.defaultBranch,
  });

  factory RepoModel.fromJson(Map<String, dynamic> json) {
    return RepoModel(
      name: json['name'] ?? '',
      visibility: json['visibility'] ?? 'public',
      defaultBranch: json['default_branch'] ?? '',
    );
  }
}
