import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myapp/data/datasources/auth_remote_datasource.dart';
import 'package:myapp/data/models/request/login_request.dart';
import 'package:myapp/data/models/response/login_response.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasource authRemoteDatasource;

  LoginBloc(this.authRemoteDatasource) : super(const _Initial()) {
    on<_Login>((event, emit) async {
      emit(const _Loading());

      final LoginRequest request = LoginRequest(
        email: event.email,
        password: event.password,
      );

      final response = await authRemoteDatasource.login(request);
      response.fold(
          (error) => emit(_Error(error)), (data) => emit(_Success(data)));
    });
  }
}
