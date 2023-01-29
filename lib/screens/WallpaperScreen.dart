import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/cubit/wallpaper_cubit.dart';
import 'package:wallpaper_app/extra/constants.dart';
import 'package:wallpaper_app/widgets/image_card.dart';
import 'package:wallpaper_app/widgets/loading_indicator.dart';
import 'package:wallpaper_app/widgets/not_found.dart';

import '../extra/WallpaperModel.dart';
import '../extra/snackbar.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({Key? key}) : super(key: key);

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 110,
        title: Text(
          'WallpapAir',
          style: TextStyle(
              fontSize: 40,
              fontFamily: montserrat,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.pink],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(46),
          child: Neumorphic(
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: _controller,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: InputBorder.none,
                  hintText: 'Search Wallpaper',
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.redAccent),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        context
                            .read<WallpaperCubit>()
                            .getWallpaper(_controller.text);
                      },
                      child: Icon(Icons.search))),
              onSubmitted: (value) =>
                  context.read<WallpaperCubit>().getWallpaper(value),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<WallpaperCubit, WallpaperState>(
                builder: (_, state) {
                  if (state is WallpaperLoading) {
                    return const Center(child: LoadingIndicator());
                  } else if (state is WallpaperError) {
                    return Center(child: const NotFoundIllustration());
                  }
                  List<WallpaperModel> wallpapers = [];
                  if (state is WallpaperLoaded) {
                    wallpapers = state.wallpapers;
                  } else {
                    wallpapers = context.read<WallpaperCubit>().wallpapers;
                  }
                  return MasonryGridView.count(
                      itemCount: wallpapers.length,
                      crossAxisCount: 2,
                      itemBuilder: (_, index) {
                        return ImageCard(wallpaper: wallpapers[index]);
                      });
                },
                listener: (_, state) {}),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
