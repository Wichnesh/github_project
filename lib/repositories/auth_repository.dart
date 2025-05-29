import 'dart:io';
import 'package:dio/dio.dart';
import '../utils/constants.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<String> exchangeCodeForToken(String code) async {
    final response = await _dio.post(
      AppConstants.githubTokenUrl,
      options: Options(headers: {
        HttpHeaders.acceptHeader: 'application/json',
      }),
      data: {
        'client_id': AppConstants.clientId,
        'client_secret': AppConstants.clientSecret,
        'code': code,
        'redirect_uri': AppConstants.redirectUri,
      },
    );

    if (response.statusCode == 200 && response.data['access_token'] != null) {
      return response.data['access_token'];
    } else {
      throw Exception('Token exchange failed');
    }
  }
}
