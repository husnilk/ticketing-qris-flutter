import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/core.dart';
import 'package:myapp/presentation/home/bloc/product/product_bloc.dart';
import 'package:myapp/presentation/home/pages/order_detail_page.dart';
import 'package:myapp/presentation/home/widgets/order_detail_card.dart';

import '../bloc/checkout/checkout_bloc.dart';
import '../widgets/order_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    context.read<ProductBloc>().add(const ProductEvent.getProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Penjualan Tiket"),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          final products = state.maybeWhen(
            success: (products) => products, orElse: () => [],
          );
          if(products.isEmpty) {
            return const Center(
              child: Text("No Data"),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SpaceHeight(20.0),
            itemBuilder: (context, index) =>
                OrderCard(
                  item: products[index],
                ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            top: 24.0, bottom: 40.0, right: 24.0, left: 24.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Order Summary'),
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, state){
                      return state.maybeWhen(
                        success: (checkout) {
                          final total = checkout.fold<int>(
                            0,
                            (previousValue, element) =>
                                previousValue +
                                element.product.price! * element.quantity,
                          );
                          return Text(
                            total.currencyFormatRp,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          );
                        },
                        orElse: () => const Text(
                          '0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      );
                    },
                  )
                  ,
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Button.filled(
                onPressed: () {
                  context.push(const OrderDetailPage());
                },
                label: 'Process',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
