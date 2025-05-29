import 'package:dio/dio.dart';
import '../models/repo_model.dart';
import '../services/api_client.dart';

class GitHubRepository {
  final Dio _dio = ApiClient().dio;

  Future<List<RepoModel>> getUserRepos() async {
    final response = await _dio.get('/user/repos');

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((json) => RepoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch repositories');
    }
  }
}
