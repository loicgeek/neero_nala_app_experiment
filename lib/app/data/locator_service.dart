import 'package:get_it/get_it.dart';
import 'package:neero_nala_app/app/presentation/router/app_router.dart';

final getIt = GetIt.instance;
Future setupLocator() async {
  // app routing ...

  final appRouter = AppRouter();
  getIt.registerSingleton<AppRouter>(appRouter);

  //end  app routing ...
}
