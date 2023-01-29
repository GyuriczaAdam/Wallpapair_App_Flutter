import 'dart:convert';
import 'dart:io';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_app/extra/WallpaperModel.dart';
import 'package:wallpaper_app/extra/location_enum.dart';

import '../extra/constants.dart';

part 'wallpaper_state.dart';

class WallpaperCubit extends Cubit<WallpaperState> {
  WallpaperCubit() : super(WallpaperLoading());
  List<WallpaperModel> wallpapers = [];
  String _lastQuery = 'budapest';

  Future<void> getWallpaper([String? query]) async {
    query == null ? query = _lastQuery : _lastQuery = query;
    emit(WallpaperLoading());

    wallpapers = await _getWallpaper(query);
    emit(WallpaperLoaded(wallpapers: wallpapers));
  }

  Future<File?> downloadWallpaper(String url) async {
    try {
      Directory dir = await getTemporaryDirectory();
      var response = await get(Uri.parse(url));
      var filePath = '${dir.path}/${DateTime.now().toIso8601String()}.jpg';
      File file = File(filePath);
      file.writeAsBytesSync(response.bodyBytes);
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<void> setWallpaper(String path, WallpaperLocation location) async {
    try {
      if (location == WallpaperLocation.both) {
        await _setWallpaper(path, WallpaperLocation.home);
        await _setWallpaper(path, WallpaperLocation.lock);
      } else {
        await _setWallpaper(path, location);
      }
      emit(WallpaperAppliedSuccessful());
    } on Exception catch (e) {
      emit(WallpaperAppliedFailed());
    }
  }

  Future<void> _setWallpaper(String path, WallpaperLocation location) async {
    await AsyncWallpaper.setWallpaperFromFile(
        filePath: path, wallpaperLocation: location.value, goToHome: false);
  }

  Future<List<WallpaperModel>> _getWallpaper(String query) async {
    query = query.replaceAll(' ', '+');
    try {
      final Response response = await get(
        Uri.parse('https://api.pexels.com/v1/search?query=$query&per_page=60'),
        headers: {'Authorization': key},
      );
      if (response.statusCode == 200) {
        final List<WallpaperModel> wallpapers = [];
        final Map<String, dynamic> data = jsonDecode(response.body);
        data['photos'].forEach((element) {
          wallpapers.add(WallpaperModel.fromJson(element['src']));
        });
        return wallpapers;
      } else {
        throw Exception();
      }
    } catch (_) {
      emit(WallpaperError(message: "message"));
      throw Exception();
    }
  }
}
