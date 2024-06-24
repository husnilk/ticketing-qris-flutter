import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/datasources/auth_remote_datasource.dart';
import 'package:myapp/data/datasources/product_remote_datasource.dart';
import 'package:myapp/presentation/auth/bloc/login/login_bloc.dart';
import 'package:myapp/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:myapp/presentation/auth/splash_page.dart';
import 'package:myapp/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:myapp/presentation/home/bloc/product/product_bloc.dart';

import 'core/core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(ProductRemoteDatasource()),
        ),
        BlocProvider(create: (context) => CheckoutBloc())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Variables.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          dialogTheme: const DialogTheme(elevation: 0),
          textTheme: GoogleFonts.outfitTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.outfit(
              color: AppColors.primary,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.black,
            ),
            centerTitle: true,
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
