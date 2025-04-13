import 'package:flutter/material.dart';
import 'package:say_it/app_pages.dart';
import 'package:say_it/utils/app_logger.dart';

/// AppRouter: Navigation Service
class AppRouter {
  /// Global navigator key for context-less navigation
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  /// Map for quick lookup
  static final Map<String, AppPage> _routeMap = {
    for (final page in AppPages.list) page.name: page
  };

  /// Internal route stack to track active routes
  static final List<_RouteEntry> _stack = [];

  /// Attach to MaterialApp: `onGenerateRoute: AppRouter.onGenerateRoute`
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final config = _routeMap[settings.name];
    if (config == null) {
      return MaterialPageRoute(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Route not found'))),
      );
    }

    // Add to custom stack
    _stack.add(_RouteEntry(settings.name!, settings.arguments));
    _log('PUSH', settings.name!);

    return _buildRouteWithTransition(
      settings,
      config.pageBuilder,
      config.transition,
    );
  }

  /// Push named route
  static Future<dynamic> pushNamed(String route, {Object? arguments}) {
    _stack.add(_RouteEntry(route, arguments));
    _log('PUSH', route);
    return navigatorKey.currentState!.pushNamed(route, arguments: arguments);
  }

  /// Push and remove all
  static Future<dynamic> pushAndRemoveUntilNamed(String route,
      {Object? arguments}) {
    _stack.clear();
    _stack.add(_RouteEntry(route, arguments));
    _log('PUSH_AND_REMOVE_ALL', route);
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      route,
      (_) => false,
      arguments: arguments,
    );
  }

  /// Push and replace
  static Future<dynamic> pushReplacementNamed(String route,
      {Object? arguments}) {
    if (_stack.isNotEmpty) _stack.removeLast();
    _stack.add(_RouteEntry(route, arguments));
    _log('REPLACE', route);
    return navigatorKey.currentState!
        .pushReplacementNamed(route, arguments: arguments);
  }

  /// Pop current route
  static void pop<T extends Object?>([T? result]) {
    if (_stack.isNotEmpty) {
      _log('POP', _stack.last.name);
      _stack.removeLast();
    }
    navigatorKey.currentState!.pop(result);
  }

  /// Pop until condition
  static void popUntil(bool Function(Route<dynamic>) predicate) {
    while (_stack.isNotEmpty) {
      _log('POP_UNTIL', _stack.last.name);
      _stack.removeLast();
    }
    navigatorKey.currentState!.popUntil(predicate);
  }

  /// Get current arguments
  static T? getArguments<T>() {
    if (_stack.isEmpty) return null;
    final last = _stack.last.arguments;
    return last is T ? last : null;
  }

  /// Get current route name (top of stack)
  static String? get currentRoute {
    if (_stack.isEmpty) return null;
    return _stack.last.name;
  }

  /// Get a copy of the route stack (for debug/logging/inspection)
  static List<Map<String, dynamic>> get routeStack {
    return _stack
      .map((entry) => {
            'name': entry.name,
            'arguments': entry.arguments,
          })
      .toList(growable: false);
  }

  /// Logs for every navigation
  static void _log(String action, String route) {
    AppLogger.warning('[AppRouter] $action → $route');
  }

  // -------------------- Transitions --------------------

  /// Actual route builder with transition logic
  static PageRouteBuilder _buildRouteWithTransition(
    RouteSettings settings,
    WidgetBuilder pageBuilder,
    RouteTransition transition,
  ) {
    switch (transition) {
      case RouteTransition.fade:
        return _fadeRouteBuilder(pageBuilder, settings);
      case RouteTransition.scale:
        return _scaleRouteBuilder(pageBuilder, settings);
      case RouteTransition.none:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => pageBuilder(_),
          transitionDuration: Duration.zero,
        );
      case RouteTransition.slide:
      default:
        return _slideRouteBuilder(pageBuilder, settings);
    }
  }

  /// Transitions: Slide (default)
  static PageRouteBuilder _slideRouteBuilder(WidgetBuilder builder, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => builder(_),
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Transitions: Fade
  static PageRouteBuilder _fadeRouteBuilder(WidgetBuilder builder, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => builder(_),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Transitions: Scale
  static PageRouteBuilder _scaleRouteBuilder(WidgetBuilder builder, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => builder(_),
      transitionsBuilder: (_, animation, __, child) => ScaleTransition(
        scale: animation,
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

/// Types of route transitions supported
enum RouteTransition { slide, fade, scale, none }

/// Route stack entry
class _RouteEntry {
  final String name;
  final Object? arguments;

  _RouteEntry(this.name, this.arguments);
}

/// Individual route config like GetPage in GetX
class AppPage {
  final String name;
  final WidgetBuilder pageBuilder;
  final RouteTransition transition;

  const AppPage({
    required this.name,
    required this.pageBuilder,
    this.transition = RouteTransition.slide, // default transition
  });
}
