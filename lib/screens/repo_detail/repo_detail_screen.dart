import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/repo_detail/repo_detail_bloc.dart';
import '../../blocs/repo_detail/repo_detail_event.dart';
import '../../blocs/repo_detail/repo_detail_state.dart';
import '../../models/commit_model.dart';
import '../../repositories/github_repository.dart';

class RepoDetailScreen extends StatelessWidget {
  final String owner;
  final String repoName;

  const RepoDetailScreen({
    super.key,
    required this.owner,
    required this.repoName,
  });

  String formatDate(String dateStr) {
    final dt = DateTime.parse(dateStr).toLocal();
    return DateFormat.yMMMEd().add_jm().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RepoDetailBloc(GitHubRepository())
        ..add(LoadRepoDetail(owner: owner, repo: repoName)),
      child: Scaffold(
        appBar: AppBar(title: Text('Repository: $repoName')),
        body: BlocBuilder<RepoDetailBloc, RepoDetailState>(
          builder: (context, state) {
            if (state is RepoDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is RepoDetailLoaded) {
              final branches = state.commitsPerBranch;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: branches.length,
                  itemBuilder: (context, index) {
                    final branchName = branches.keys.elementAt(index);
                    final List<CommitModel> commits = branches[branchName]!;

                    return Card(
                      elevation: 6,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '🌿 ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  branchName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24, thickness: 1),


                            ...commits.map((commit) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${getCommitEmoji(commit.message)} ",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            commit.message,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.person, size: 14, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Text(
                                                commit.author,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Text(
                                                formatDate(commit.date),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(height: 20),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }
              );
            }

            if (state is RepoDetailError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String getCommitEmoji(String message) {
    final msg = message.toLowerCase();

    if (msg.contains('feature') || msg.contains('launch')) return '🚀';
    if (msg.contains('fix') || msg.contains('bug')) return '🐛';
    if (msg.contains('clean') || msg.contains('refactor')) return '🧹';
    if (msg.contains('add') || msg.contains('new')) return '✨';
    if (msg.contains('doc') || msg.contains('readme') || msg.contains('comment')) return '📝';
    if (msg.contains('config') || msg.contains('tool')) return '🔧';
    if (msg.contains('remove') || msg.contains('delete')) return '🔥';
    if (msg.contains('build') || msg.contains('maintain')) return '🛠️';
    if (msg.contains('ui') || msg.contains('style')) return '🎨';
    if (msg.contains('test')) return '✅';

    return '🔧'; // fallback
  }

}
