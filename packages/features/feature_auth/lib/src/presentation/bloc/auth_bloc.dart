// packages/features/feature_auth/lib/src/presentation/bloc/auth_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_with_email_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmailUseCase _loginWithEmailUseCase;
  final AuthRepository _authRepository;

  AuthBloc({
    required LoginWithEmailUseCase loginWithEmailUseCase,
    required AuthRepository authRepository,
  })  : _loginWithEmailUseCase = loginWithEmailUseCase,
        _authRepository = authRepository,
        super(const AuthInitialState()) {
    on<LoginSubmittedEvent>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoadingState());

    final result = await _loginWithEmailUseCase(
      LoginParams(
        emailRaw: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthFailureState(errorMessage: failure.message)),
      (userEntity) => emit(AuthenticatedState(user: userEntity)),
    );
  }
}