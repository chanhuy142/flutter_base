import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/posts/presentation/pages/posts_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/posts',
  routes: <GoRoute>[
    GoRoute(
      path: '/posts',
      name: 'posts',
      builder: (context, state) => const PostsPage(),
    ),
  ],
);
