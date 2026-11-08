import 'dart:async';
import 'package:flutter/material.dart' show Alignment, Color;
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dompetqu/core/database/entities/app_setting_entity.dart';
import 'package:dompetqu/core/database/objectbox_database.dart';
import 'ui_style.dart';

part 'generated/ui_style_controller.g.dart';

const String kUiStylePrefsKey = 'ui_style';

/// Kontrol penampilan UI yang berubah saat runtime dan dipersist ke
/// ObjectBox. Mengubah [UiStyle] langsung memicu rebuild tema global (lihat
/// `AppTheme.fromStyle` di `app_theme.dart`).
///
/// Karena slider opacity/blur bisa menembak berkali-kali, persistensi dibuat
/// debounce 50 ms — state in-memory selalu update seketika, hanya penulisan
/// ke disk yang digabung.
@Riverpod(keepAlive: true)
class UiStyleController extends _$UiStyleController {
  Timer? _persistDebounce;

  ObjectBoxDatabase get _db => GetIt.instance.get<ObjectBoxDatabase>();

  @override
  Future<UiStyle> build() async {
    ref.onDispose(() => _persistDebounce?.cancel());
    final entity = _findByKey(kUiStylePrefsKey);
    if (entity == null) return const UiStyle();
    return UiStyle.fromJson(entity.value) ?? const UiStyle();
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
    final entity = _findByKey(kUiStylePrefsKey);
    if (entity != null) {
      _db.appSettingBox.remove(entity.id);
    }
  }

  Future<void> _update(UiStyle Function(UiStyle) mutate) {
    state = AsyncData(mutate(state.value ?? const UiStyle()));
    return _schedulePersist();
  }

  Future<void> _schedulePersist() {
    _persistDebounce?.cancel();
    final completer = Completer<void>();
    _persistDebounce = Timer(const Duration(milliseconds: 50), () async {
      final style = state.value;
      if (style == null) return;
      try {
        final entity =
            _findByKey(kUiStylePrefsKey) ??
            AppSettingEntity(key: kUiStylePrefsKey);
        entity.value = style.toJson();
        _db.appSettingBox.put(entity);
        if (!completer.isCompleted) completer.complete();
      } catch (error) {
        if (!completer.isCompleted) completer.completeError(error);
      }
    });
    return completer.future;
  }

  AppSettingEntity? _findByKey(String key) {
    for (final e in _db.appSettingBox.getAll()) {
      if (e.key == key) return e;
    }
    return null;
  }
}
