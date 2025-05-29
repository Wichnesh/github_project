import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';

class RepoListScreen extends StatelessWidget {
  const RepoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories'),
        actions: [
          IconButton(
            onPressed: () {
              // Log out and clear token
              context.read<AuthBloc>().add(LoggedOut());
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(
        child: Text('List of GitHub Repositories will appear here.'),
      ),
    );
  }
}
