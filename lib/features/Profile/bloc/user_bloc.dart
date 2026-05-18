import 'package:bloc/bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import 'package:egyptopia/core/mock_data.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
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
      emit(UserLoaded(mockUser));
    } catch (e) {
      emit(UserError("Failed to load profile"));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      emit(UserLoaded(event.updatedUser));
    } catch (e) {
      emit(UserError("Error updating profile"));
    }
  }
}