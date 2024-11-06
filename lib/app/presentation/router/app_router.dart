import 'package:auto_route/auto_route.dart';
import 'package:neero_nala_app/transactions/presentation/router/transactions_router_module.dart';

@AutoRouterConfig(generateForDir: ['lib/app/presentation'])
class AppRouter extends RootStackRouter {
  @override
  final List<AutoRoute> routes = [
    ...TransactionsRouterModule().routes,
  ];
}
