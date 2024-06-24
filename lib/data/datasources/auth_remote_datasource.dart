import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/core/core.dart';
import 'package:myapp/data/datasources/auth_local_datasource.dart';
import 'package:myapp/data/models/request/login_request.dart';
import 'package:myapp/data/models/response/login_response.dart';

class AuthRemoteDatasource {
  final String baseUrl = Variables.baseUrl;

  Future<Either<String, LoginResponse>> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: request.toJson(),
    );

    if (response.statusCode == 200) {
      return Right(LoginResponse.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, String>> logout() async{
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('$baseUrl/api/logout'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}'
      }
    );

    if(response.statusCode == 200){
      return const Right('Logout success');
    }else{
      return Left(response.body);
    }
  }
}
