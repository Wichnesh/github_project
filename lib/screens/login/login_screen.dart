import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../screens/repo_list/repo_list_screen.dart';
import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();

    _linkSub = _appLinks.uriLinkStream.listen((uri) {
      if (uri.toString().startsWith(AppConstants.redirectUri)) {
        final code = uri.queryParameters['code'];
        if (code != null) {
          context.read<AuthBloc>().add(LoggedInWithCode(code));
        }
      }
    });
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  Future<void> _launchGitHubLogin() async {
    final url =
        'https://github.com/login/oauth/authorize?client_id=${AppConstants.clientId}&redirect_uri=${AppConstants.redirectUri}&scope=repo';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      _showError('Could not launch GitHub login');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login with GitHub')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            _showError(state.message);
          } else if (state is AuthAuthenticated) {
            // ✅ Navigate after successful login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RepoListScreen()),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: ElevatedButton.icon(
              onPressed: _launchGitHubLogin,
              icon: const Icon(Icons.login),
              label: const Text('Login with GitHub'),
            ),
          );
        },
      ),
    );
  }
}
