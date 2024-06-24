import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/product_remote_datasource.dart';
import '../../../../data/models/response/product_response.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource productRemoteDatasource;

  ProductBloc(this.productRemoteDatasource) : super(const ProductState.initial()) {
    on<_GetProducts>((event, emit) async {
      emit(const _Loading());
      final response = await productRemoteDatasource.getProducts();

      response.fold(
          (error) => emit(_Error(error)),
          (data) => emit(_Success(data.data ?? []))
      );
    });
  }
}
