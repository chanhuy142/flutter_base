import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/comments_bloc.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentsBloc>(
      create: (_) => getIt<CommentsBloc>()..add(const CommentsEvent.started()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Comments')),
        body: BlocBuilder<CommentsBloc, CommentsState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (items) => ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, idx) => ListTile(title: Text(items[idx].toString())),
              ),
              failure: (msg) => Center(child: Text('Error: $msg')),
            );
          },
        ),
      ),
    );
  }
}
