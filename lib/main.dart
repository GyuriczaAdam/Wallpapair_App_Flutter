import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/cubit/wallpaper_cubit.dart';
import 'package:wallpaper_app/extra/constants.dart';
import 'package:wallpaper_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WallpaperCubit()..getWallpaper(),
      child: MaterialApp(
        title: 'WallPaper App',
        theme: theme,
        home: const  SplashScreen(),
      ),
    );
  }
}


