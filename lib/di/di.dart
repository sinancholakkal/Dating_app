import 'package:dating_app/services/auth_services.dart';
import 'package:dating_app/services/chat_service.dart';
import 'package:dating_app/services/coins_service.dart';
import 'package:dating_app/services/favorite_service.dart';
import 'package:dating_app/services/lookingfor_service.dart';
import 'package:dating_app/services/request_services.dart';
import 'package:dating_app/services/swip_service.dart';
import 'package:dating_app/services/user_actions_services.dart';
import 'package:dating_app/services/user_profile_services.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.instance;
void setUpDi(){
  di.registerLazySingleton(() => AuthServices(),);
  di.registerLazySingleton(()=>ChatServices());
  di.registerLazySingleton(()=>CoinsServices());
  di.registerLazySingleton(()=>FavoriteServices());
  di.registerLazySingleton(()=>RequestService());
  di.registerLazySingleton(()=>SwipeServices());
  di.registerLazySingleton(()=>UserActionsService());
  di.registerLazySingleton(()=>UserProfileService());
  di.registerLazySingleton(()=>LookingforService());
}