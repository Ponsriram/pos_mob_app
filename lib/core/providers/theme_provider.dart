import 'package:flutter/material.dart';
import 'package:pos_app/core/theme/apptheme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeData build() => AppTheme.lightTheme;

  void toggleTheme() {
    state = state == AppTheme.lightTheme ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

  void setTheme(ThemeData theme) {
    state = theme;
  }

  
}
