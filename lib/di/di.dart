import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/services/moderation_services.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.instance;
void setUpDi(){
  di.registerLazySingleton(() => AuthServices(),);
}