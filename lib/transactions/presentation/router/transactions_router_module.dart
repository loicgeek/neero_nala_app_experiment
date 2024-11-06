import 'package:auto_route/auto_route.dart';
import 'package:neero_nala_app/app/presentation/router/app_route_transition_builder.dart';
import 'package:neero_nala_app/transactions/presentation/screens/transactions_list_screen.dart';

part 'transactions_router_module.gr.dart';

@AutoRouterConfig(
  generateForDir: ['lib/transactions/presentation/screens'],
)
class TransactionsRouterModule extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute<TransactionsListRoute>(
          path: '/',
          page: TransactionsListRoute.page,
          transitionsBuilder: appRouteTransitionBuilder,
        )
      ];
}
