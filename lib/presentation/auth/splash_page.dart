import 'package:flutter/material.dart';
import 'package:myapp/core/core.dart';
import 'package:myapp/data/datasources/auth_local_datasource.dart';
import 'package:myapp/presentation/auth/login_page.dart';
import 'package:myapp/presentation/home/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2),
            ()=> AuthLocalDatasource().isLogin()
        ),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            print(snapshot.data);
            if (snapshot.data == true){
              return const MainPage();
            }else{
              return const LoginPage();
            }
          }

          return Padding(
            padding: const EdgeInsets.all(96.0),
            child: Center(
              child: Assets.images.logoBlue.image(),
            ),
          );
        }
      ),
    );
  }
}
