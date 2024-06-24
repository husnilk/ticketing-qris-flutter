import 'package:myapp/data/models/response/product_response.dart';

class OrderItem{
  final Product product;
  int quantity;

  OrderItem({required this.product, required this.quantity});

}