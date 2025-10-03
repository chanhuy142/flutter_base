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
        body: BlocConsumer<PostsBloc, PostsState>(
          listenWhen: (prev, curr) => prev.errorMessage != curr.errorMessage,
          listener: (BuildContext context, PostsState state) {
            final String? msg = state.errorMessage;
            if (msg != null && msg.isNotEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $msg')));
            }
          },
          builder: (BuildContext context, PostsState state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<Post> posts = state.posts;
            return ListView.separated(
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
            );
          },
        ),
      ),
    );
  }
}
