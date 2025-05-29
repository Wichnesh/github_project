import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/secure_storage.dart';
import '../../services/api_client.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SecureStorageService storageService;
  final ApiClient apiClient;

  AuthBloc({required this.storageService, required this.apiClient}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
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

  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    await storageService.saveToken(event.token);
    apiClient.setAuthToken(event.token);
    emit(AuthAuthenticated());
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await storageService.deleteToken();
    apiClient.clearAuthToken();
    emit(AuthUnauthenticated());
  }
}
