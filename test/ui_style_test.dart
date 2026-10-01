import 'package:dompetqu/core/theme/ui_style.dart';
import 'package:dompetqu/core/theme/ui_style_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('UiStyle serialization', () {
    test('toJson/fromJson roundtrip mempertahankan semua nilai', () {
      const style = UiStyle(
        primary: Color(0xFF123456),
        secondary: Color(0xFF654321),
        tertiary: Color(0xFFAABBCC),
        gradientColors: [Color(0xFF111111), Color(0xFF222222)],
        gradientBegin: Alignment.topCenter,
        gradientEnd: Alignment.bottomRight,
        glassOpacity: 0.42,
        blurSigma: 12.5,
      );

      final restored = UiStyle.fromJson(style.toJson());

      expect(restored, isNotNull);
      expect(restored!.primary, style.primary);
      expect(restored.secondary, style.secondary);
      expect(restored.tertiary, style.tertiary);
      expect(restored.gradientColors, style.gradientColors);
      expect(restored.gradientBegin, style.gradientBegin);
      expect(restored.gradientEnd, style.gradientEnd);
      expect(restored.glassOpacity, style.glassOpacity);
      expect(restored.blurSigma, style.blurSigma);
    });

    test('default roundtrip konsisten', () {
      const style = UiStyle();
      final restored = UiStyle.fromJson(style.toJson());
      expect(restored, style);
    });

    test('fromJson mengembalikan null untuk input rusak', () {
      expect(UiStyle.fromJson('{not json'), isNull);
      expect(UiStyle.fromJson('42'), isNull);
    });
  });

  group('UiStyleController', () {
    test('setPrimary & setGradientColors mengubah state', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller =
          container.read(uiStyleControllerProvider.notifier);
      await container.read(uiStyleControllerProvider.future);

      await controller.setPrimary(const Color(0xFF123456));
      await controller.setGradientColors([
        const Color(0xFF111111),
        const Color(0xFF222222),
      ]);

      final style = container.read(uiStyleControllerProvider).value;
      expect(style!.primary, const Color(0xFF123456));
      expect(style.gradientColors, [
        const Color(0xFF111111),
        const Color(0xFF222222),
      ]);
    });

    test('reset mengembalikan ke default & menghapus persistensi', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller =
          container.read(uiStyleControllerProvider.notifier);
      await container.read(uiStyleControllerProvider.future);

      await controller.setPrimary(const Color(0xFF123456));
      expect(controller.state.value!.primary, const Color(0xFF123456));

      await controller.reset();
      expect(controller.state.value, isNotNull);
      expect(controller.state.value!.primary, kUiPrimary);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(kUiStylePrefsKey), isNull);
    });
  });
}