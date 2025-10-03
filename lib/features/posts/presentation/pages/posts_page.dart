import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/post.dart';
import '../bloc/posts_bloc.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsBloc>(
      create: (_) => getIt<PostsBloc>()..add(const PostsEvent.started()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Posts')),
        body: BlocBuilder<PostsBloc, PostsState>(
          builder: (BuildContext context, PostsState state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (List<Post> posts) => ListView.separated(
                itemCount: posts.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (BuildContext context, int index) {
                  final Post post = posts[index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.body),
                    leading: CircleAvatar(child: Text(post.id.toString())),
                  );
                },
              ),
              failure: (String message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error: $message'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



