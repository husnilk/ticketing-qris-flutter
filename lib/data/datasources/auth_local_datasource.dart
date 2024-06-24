import 'package:myapp/data/models/response/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource{

  Future<void> saveAuthData(LoginResponse response) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('auth_data', response.toJson());
  }

  Future<void> removeAuthData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('auth_data');
  }

  Future<LoginResponse> getAuthData() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('auth_data');
    if (data != null){
      return LoginResponse.fromJson(data);
    }else{
      throw Exception('Data not found');
    }
  }

  Future<bool> isLogin() async {
    final pref = await SharedPreferences.getInstance();
    return pref.containsKey('auth_data');
  }

}