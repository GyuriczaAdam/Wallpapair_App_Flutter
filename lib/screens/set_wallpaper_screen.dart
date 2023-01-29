import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/cubit/wallpaper_cubit.dart';
import 'package:wallpaper_app/extra/WallpaperModel.dart';
import 'package:wallpaper_app/extra/constants.dart';
import 'package:wallpaper_app/extra/location_enum.dart';
import 'package:wallpaper_app/extra/snackbar.dart';
import 'package:wallpaper_app/widgets/loading_indicator.dart';

class SetWallpaperScreen extends StatefulWidget {
  final WallpaperModel wallpaperModel;

  const SetWallpaperScreen({Key? key, required this.wallpaperModel})
      : super(key: key);

  @override
  State<SetWallpaperScreen> createState() => _SetWallpaperScreenState();
}

class _SetWallpaperScreenState extends State<SetWallpaperScreen> {
  File? wallpaperFile;

  @override
  void initState() {
    super.initState();
    context
        .read<WallpaperCubit>()
        .downloadWallpaper(widget.wallpaperModel.original)
        .then((file) {
      setState(() {
        wallpaperFile = file;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: BlocListener<WallpaperCubit, WallpaperState>(
            listener: (context, state) {
              if(state is WallpaperAppliedSuccessful){
                Snackbar.show(context,'Wallpaper applied successfully',ContentType.success);
              }else if (state is WallpaperAppliedFailed){
                Snackbar.show(context,'Wallpaper apply failed!',ContentType.failure);
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                wallpaperFile == null
                    ? LoadingIndicator()
                    : Image.file(wallpaperFile!, fit: BoxFit.cover),
                if (wallpaperFile != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<WallpaperCubit>().setWallpaper(
                                  wallpaperFile!.path, WallpaperLocation.home);
                            },
                            child: Text('Home Screen'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<WallpaperCubit>().setWallpaper(
                                  wallpaperFile!.path, WallpaperLocation.both);
                            },
                            child: Text('Both'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<WallpaperCubit>().setWallpaper(
                                  wallpaperFile!.path, WallpaperLocation.lock);
                            },
                            child: Text('Lock screen'),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                    top: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder()),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: black,
                        )))
              ],
            ),
          )),
    );
  }
}
