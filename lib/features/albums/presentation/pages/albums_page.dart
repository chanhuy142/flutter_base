import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/albums_bloc.dart';

class AlbumsPage extends StatelessWidget {
  const AlbumsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AlbumsBloc>(
      create: (_) => getIt<AlbumsBloc>()..add(const AlbumsEvent.started()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Albums')),
        body: BlocBuilder<AlbumsBloc, AlbumsState>(
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
