import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'repositories/auth_repository.dart';
import 'services/api_client.dart';
import 'services/secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Shared instances
  final apiClient = ApiClient();
  final storageService = SecureStorageService();
  final authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            storageService: storageService,
            apiClient: apiClient,
            authRepository: authRepository,
          )..add(AppStarted()), // Check if token exists on startup
        ),
      ],
      child: const App(),
    );
  }
}
