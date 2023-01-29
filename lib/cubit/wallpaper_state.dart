part of 'wallpaper_cubit.dart';

@immutable
abstract class WallpaperState {}

class WallpaperLoading extends WallpaperState {}

class WallpaperLoaded extends WallpaperState {
  List<WallpaperModel> wallpapers;

  WallpaperLoaded({required this.wallpapers});
}

class WallpaperError extends WallpaperState {
  String message;
  WallpaperError({required this.message});
}

class WallpaperAppliedSuccessful extends WallpaperState {

}


class WallpaperAppliedFailed extends WallpaperState {

}