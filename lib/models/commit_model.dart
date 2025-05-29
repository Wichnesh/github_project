class CommitModel {
  final String message;
  final String author;
  final String date;

  CommitModel({
    required this.message,
    required this.author,
    required this.date,
  });

  factory CommitModel.fromJson(Map<String, dynamic> json) {
    return CommitModel(
      message: json['commit']['message'] ?? '',
      author: json['commit']['author']['name'] ?? '',
      date: json['commit']['author']['date'] ?? '',
    );
  }
}
