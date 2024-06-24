import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/core/constants/constants.dart';
import 'package:myapp/data/datasources/auth_local_datasource.dart';
import 'package:myapp/data/models/response/product_response.dart';

class ProductRemoteDatasource {
  final String baseUrl = Variables.baseUrl;

  Future<Either<String, ProductResponse>> getProducts() async {

    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(Uri.parse('$baseUrl/api/api-products'), headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}'
    });

    if(response.statusCode == 200){
      return Right(ProductResponse.fromJson(response.body));
    }else{
      return Left(response.body);
    }
  }
}