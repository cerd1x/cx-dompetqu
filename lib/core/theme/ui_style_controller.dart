import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui_style.dart';

part 'ui_style_controller.g.dart';

const String kUiStylePrefsKey = 'ui_style';

/// Kontrol penampilan UI yang berubah saat runtime dan dipersist ke
/// `SharedPreferences`. Mengubah [UiStyle] langsung memicu rebuild tema
/// global (lihat `AppTheme.fromStyle` di `app_theme.dart`).
///
/// Karena slider opacity/blur bisa menembak berkali-kali, persistensi dibuat
/// debounce 50 ms — state in-memory selalu update seketika, hanya penulisan
/// ke disk yang digabung.
@Riverpod(keepAlive: true)
class UiStyleController extends _$UiStyleController {
  Timer? _persistDebounce;

  @override
  Future<UiStyle> build() async {
    ref.onDispose(() => _persistDebounce?.cancel());
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(kUiStylePrefsKey);
    if (raw == null) return const UiStyle();
    return UiStyle.fromJson(raw) ?? const UiStyle();
  }

  Future<void> setPrimary(Color color) =>
      _update((s) => s.copyWith(primary: color));

  Future<void> setSecondary(Color color) =>
      _update((s) => s.copyWith(secondary: color));

  Future<void> setTertiary(Color color) =>
      _update((s) => s.copyWith(tertiary: color));

  Future<void> setGradientColors(List<Color> colors) =>
      _update((s) => s.copyWith(gradientColors: colors));

  Future<void> setGradientDirection(Alignment begin, Alignment end) =>
      _update((s) => s.copyWith(gradientBegin: begin, gradientEnd: end));

  Future<void> setGlassOpacity(double opacity) =>
      _update((s) => s.copyWith(glassOpacity: opacity));

  Future<void> setBlurSigma(double sigma) =>
      _update((s) => s.copyWith(blurSigma: sigma));

  /// Kembalikan semua nilai ke default brand.
  Future<void> reset() async {
    _persistDebounce?.cancel();
    state = const AsyncData(UiStyle());
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kUiStylePrefsKey);
  }

  Future<void> _update(UiStyle Function(UiStyle) mutate) {
    state = AsyncData(
      mutate(state.value ?? const UiStyle()),
    );
    return _schedulePersist();
  }

  Future<void> _schedulePersist() {
    _persistDebounce?.cancel();
    final completer = Completer<void>();
    _persistDebounce = Timer(const Duration(milliseconds: 50), () async {
      final style = state.value;
      if (style == null) return;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(kUiStylePrefsKey, style.toJson());
        if (!completer.isCompleted) completer.complete();
      } catch (error) {
        if (!completer.isCompleted) completer.completeError(error);
      }
    });
    return completer.future;
  }
}