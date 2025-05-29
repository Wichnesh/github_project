class BranchModel {
  final String name;

  BranchModel({required this.name});

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(name: json['name']);
  }
}
