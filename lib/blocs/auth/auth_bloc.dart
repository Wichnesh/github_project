import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/secure_storage.dart';
import '../../services/api_client.dart';
import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SecureStorageService storageService;
  final ApiClient apiClient;
  final AuthRepository authRepository;

  AuthBloc({
    required this.storageService,
    required this.apiClient,
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedInWithCode>(_onLoggedInWithCode);
    on<LoggedOut>(_onLoggedOut);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final token = await storageService.getToken();

    if (token != null) {
      apiClient.setAuthToken(token);
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onLoggedInWithCode(LoggedInWithCode event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await authRepository.exchangeCodeForToken(event.code);
      await storageService.saveToken(token);
      apiClient.setAuthToken(token);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await storageService.deleteToken();
    apiClient.clearAuthToken();
    emit(AuthUnauthenticated());
  }
}
