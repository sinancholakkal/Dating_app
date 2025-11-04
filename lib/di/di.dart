import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:dating_app/services/coins_service.dart';
import 'package:dating_app/services/favorite_service.dart';
import 'package:dating_app/services/moderation_services.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.instance;
void setUpDi(){
  di.registerLazySingleton(() => AuthServices(),);
  di.registerLazySingleton(()=>ChatServices());
  di.registerLazySingleton(()=>CoinsServices());
  di.registerLazySingleton(()=>FavoriteServices());
}