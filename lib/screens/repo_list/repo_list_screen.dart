import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/repo_list/repo_list_bloc.dart';
import '../../blocs/repo_list/repo_list_event.dart';
import '../../blocs/repo_list/repo_list_state.dart';
import '../../repositories/github_repository.dart';
import '../../models/repo_model.dart';
import '../login/login_screen.dart';
import '../repo_detail/repo_detail_screen.dart';

class RepoListScreen extends StatelessWidget {
  const RepoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RepoListBloc(GitHubRepository())..add(FetchRepos()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Your GitHub Repositories"),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(LoggedOut());
                },
              )
            ],
          ),
            body: BlocBuilder<RepoListBloc, RepoListState>(
              builder: (context, state) {
                if (state is RepoListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RepoListLoaded) {
                  final repos = state.repos;
                  return Scrollbar(
                    thumbVisibility: true,
                    radius: const Radius.circular(10),
                    thickness: 6,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: repos.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final repo = repos[index];
                          final isPrivate = repo.visibility.toLowerCase() == 'private';

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                            child: Material(
                              elevation: 6,
                              borderRadius: BorderRadius.circular(16),
                              shadowColor: Colors.black.withOpacity(0.15),
                              color: Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RepoDetailScreen(repoName: repo.name, owner: repo.owner),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Repo Name
                                      Text(
                                        repo.name,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      // Default Branch
                                      Row(
                                        children: [
                                          const Icon(Icons.source, size: 16, color: Colors.grey),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Branch: ${repo.defaultBranch}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 12),

                                      // Visibility Badge
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isPrivate ? Colors.red[50] : Colors.green[50],
                                            border: Border.all(
                                              color: isPrivate ? Colors.red[200]! : Colors.green[200]!,
                                            ),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            isPrivate ? '🔒 Private' : '🌐 Public',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: isPrivate ? Colors.red[700] : Colors.green[700],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  );
                } else if (state is RepoListError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            )

        ),
      ),
    );
  }
}
