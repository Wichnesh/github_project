import 'package:dio/dio.dart';
import '../models/branch_model.dart';
import '../models/commit_model.dart';
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

  Future<List<BranchModel>> getBranches(String owner, String repo) async {
    final response = await _dio.get('/repos/$owner/$repo/branches');
    final data = response.data as List;
    return data.map((e) => BranchModel.fromJson(e)).toList();
  }

  Future<List<CommitModel>> getCommits(String owner, String repo, String branch) async {
    final response = await _dio.get('/repos/$owner/$repo/commits', queryParameters: {
      'sha': branch,
      'per_page': 5,
    });
    final data = response.data as List;
    return data.map((e) => CommitModel.fromJson(e)).toList();
  }

}
