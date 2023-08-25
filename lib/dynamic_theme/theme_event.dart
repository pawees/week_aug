part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {}

class ThemeFetchEvent extends ThemeEvent {}

class ThemePostEvent extends ThemeEvent {}

