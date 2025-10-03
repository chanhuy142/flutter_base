import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/posts/presentation/pages/posts_page.dart';
import '../../features/comments/presentation/pages/comments_page.dart';

import '../../features/albums/presentation/pages/albums_page.dart';
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/posts',
  routes: <GoRoute>[
    GoRoute(
      path: '/posts',
      name: 'posts',
      builder: (context, state) => const PostsPage(),
    ),
    GoRoute(
      path: '/comments',
      name: 'comments',
      builder: (context, state) => const CommentsPage(),
    ),
      GoRoute(
      path: '/albums',
      name: 'albums',
      builder: (context, state) => const AlbumsPage(),
    ),
],
);


