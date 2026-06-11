import 'package:bloc/bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import 'package:etrip/features/auth/data/services/firestore_user_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirestoreUserService _firestoreService = FirestoreUserService();

  UserBloc() : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onUpdateUser);
    on<LogoutUser>((event, emit) {
      emit(UserInitial());
    });
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      if (event.userId.isEmpty) {
        emit(UserUnauthenticated());
        return;
      }
      final user = _firestoreService.getUserProfile(event.userId);
      if (user == null) {
        emit(UserUnauthenticated());
        return;
      }
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError("Failed to load profile: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await _firestoreService.updateUserProfile(event.updatedUser);
      emit(UserLoaded(event.updatedUser));
    } catch (e) {
      emit(UserError("Error updating profile"));
    }
  }
}
