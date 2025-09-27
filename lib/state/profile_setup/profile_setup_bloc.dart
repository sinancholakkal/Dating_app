import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'profile_setup_event.dart';
part 'profile_setup_state.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  ProfileSetupBloc() : super(ProfileSetupInitial()) {
    on<ProfileSetupEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
