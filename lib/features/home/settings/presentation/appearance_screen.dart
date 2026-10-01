import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/dompet_brand.dart';
import '../../../../core/theme/ui_style.dart';
import '../../../../core/theme/ui_style_controller.dart';
import '../../../../core/theme/widgets/dompet_card.dart';

/// Palet preset untuk color picker — kombinasi gold/purple/pink & warna netral.
const List<Color> kUiPalette = [
  Color(0xFFD4A574), // gold primary
  Color(0xFFFFD79B), // gold light
  Color(0xFFA37A3E), // gold dark
  Color(0xFF8B5CF6), // purple
  Color(0xFF7C3AED), // purple 600
  Color(0xFFF4A6D6), // pink
  Color(0xFFEC4899), // pink 500
  Color(0xFF10B981), // emerald
  Color(0xFF3B82F6), // blue
  Color(0xFF06B6D4), // cyan
  Color(0xFFF59E0B), // amber
  Color(0xFFEF4444), // red
];

/// Pengaturan penampilan (appearance): warna primary/secondary/tertiary,
/// gradient, opacity glass, dan blur — semua dikendalikan via
/// [UiStyleController.uiStyleControllerProvider].
class AppearanceScreen extends ConsumerStatefulWidget {
  const AppearanceScreen({super.key});

  @override
  ConsumerState<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends ConsumerState<AppearanceScreen> {
  double _opacityPreview = kUiGlassOpacity;
  double _blurPreview = kUiBlurSigma;

  @override
  Widget build(BuildContext context) {
    final uiStyle =
        ref.watch(uiStyleControllerProvider).value ?? const UiStyle();
    _syncPreviews(uiStyle);

    final preview = uiStyle.copyWith(
      glassOpacity: _opacityPreview,
      blurSigma: _blurPreview,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: preview.gradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(title: 'Penampilan', onBack: () => context.pop()),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      _LivePreview(style: preview),
                      _ColorPickerCard(
                        title: 'Primary',
                        selected: uiStyle.primary,
                        onPick: (color) => ref
                            .read(uiStyleControllerProvider.notifier)
                            .setPrimary(color),
                      ),
                      _ColorPickerCard(
                        title: 'Secondary',
                        selected: uiStyle.secondary,
                        onPick: (color) => ref
                            .read(uiStyleControllerProvider.notifier)
                            .setSecondary(color),
                      ),
                      _ColorPickerCard(
                        title: 'Tertiary',
                        selected: uiStyle.tertiary,
                        onPick: (color) => ref
                            .read(uiStyleControllerProvider.notifier)
                            .setTertiary(color),
                      ),
                      _GradientPickerCard(
                        style: uiStyle,
                        onPick: (colors) => ref
                            .read(uiStyleControllerProvider.notifier)
                            .setGradientColors(colors),
                        onDirection: (begin, end) => ref
                            .read(uiStyleControllerProvider.notifier)
                            .setGradientDirection(begin, end),
                      ),
                      _OpacitySliderCard(
                        value: _opacityPreview,
                        onChanged: (v) => setState(() => _opacityPreview = v),
                        onChangeEnd: (v) => ref
                            .read(uiStyleControllerProvider.notifier)
                            .setGlassOpacity(v),
                      ),
                      _BlurSliderCard(
                        value: _blurPreview,
                        onChanged: (v) => setState(() => _blurPreview = v),
                        onChangeEnd: (v) => ref
                            .read(uiStyleControllerProvider.notifier)
                            .setBlurSigma(v),
                      ),
                      _ResetCard(
                        onReset: () async {
                          final confirmed = await _confirmReset(context);
                          if (confirmed == true && context.mounted) {
                            await ref
                                .read(uiStyleControllerProvider.notifier)
                                .reset();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _syncPreviews(UiStyle uiStyle) {
    if (uiStyle.glassOpacity == _opacityPreview) return;
    _opacityPreview = uiStyle.glassOpacity;
    _blurPreview = uiStyle.blurSigma;
  }

  Future<bool?> _confirmReset(BuildContext context) => showDialog<bool>(
    context: context,
    routeSettings: const RouteSettings(name: 'appearance-reset-confirm'),
    builder: (dialogCtx) => AlertDialog(
      title: const Text('Reset penampilan?'),
      content: const Text(
        'Warna, gradient, opacity, dan blur kembali ke tema bawaan DompetQu.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogCtx).pop(false),
          child: const Text('BATAL'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogCtx).pop(true),
          child: const Text('RESET'),
        ),
      ],
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_outlined),
            color: Colors.white,
            tooltip: 'back',
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Kartu preview langsung dari nilai [UiStyle] — mencontohkan bagaimana
/// gradient + frosted glass (opacity & blur) terlihat.
class _LivePreview extends StatelessWidget {
  const _LivePreview({required this.style});

  final UiStyle style;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.solid,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DompetBrand.radius),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: style.gradientColors,
              begin: style.gradientBegin,
              end: style.gradientEnd,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: style.blurSigma,
                    sigmaY: style.blurSigma,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: style.glassFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: style.glassBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 48,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 90,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 12,
                child: Text(
                  'opacity ${_pct(style.glassOpacity)} · blur ${style.blurSigma.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorPickerCard extends StatelessWidget {
  const _ColorPickerCard({
    required this.title,
    required this.selected,
    required this.onPick,
  });

  final String title;
  final Color selected;
  final ValueChanged<Color> onPick;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            '#${(selected.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}',
            style: const TextStyle(fontSize: 12, color: Colors.white54),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final color in kUiPalette)
                _Swatch(
                  color: color,
                  selected: color == selected,
                  onTap: () => onPick(color),
                ),
              _Swatch(
                color: selected,
                selected: false,
                isCustom: true,
                onTap: () => _pickCustom(context, selected, onPick),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Swatch bundar; `+` membuka dialog input warna hex untuk pilihan custom.
class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
    this.isCustom = false,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final bool isCustom;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isCustom ? 'pilih warna custom' : 'pilih warna',
      button: true,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? Colors.white : Colors.white24,
              width: selected ? 3 : 1,
            ),
          ),
          child: isCustom
              ? const Icon(Icons.add, size: 20, color: Colors.white)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

Future<void> _pickCustom(
  BuildContext context,
  Color initial,
  ValueChanged<Color> onPick,
) async {
  final controller = TextEditingController(
    text: (initial.toARGB32() & 0xFFFFFF)
        .toRadixString(16)
        .padLeft(6, '0')
        .toUpperCase(),
  );
  final picked = await showDialog<Color>(
    context: context,
    routeSettings: const RouteSettings(name: 'color-custom-dialog'),
    builder: (dialogCtx) => AlertDialog(
      title: const Text('Warna custom'),
      content: TextField(
        controller: controller,
        autofocus: true,
        style: const TextStyle(fontFamily: 'monospace'),
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          LengthLimitingTextInputFormatter(6),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
        ],
        decoration: const InputDecoration(
          labelText: 'HEX',
          prefixText: '#',
          hintText: 'D4A574',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogCtx).pop(),
          child: const Text('BATAL'),
        ),
        FilledButton(
          onPressed: () {
            final value = int.tryParse(controller.text, radix: 16);
            Navigator.of(
              dialogCtx,
            ).pop(value == null ? null : Color(0xFF000000 | value));
          },
          child: const Text('TERAPKAN'),
        ),
      ],
    ),
  );
  controller.dispose();
  if (picked != null) onPick(picked);
}

/// Komposisi gradient yang bisa dipilih — minimal 2 warna, maksimal brand.
class _GradientPickerCard extends StatelessWidget {
  const _GradientPickerCard({
    required this.style,
    required this.onPick,
    required this.onDirection,
  });

  final UiStyle style;
  final ValueChanged<List<Color>> onPick;
  final void Function(Alignment begin, Alignment end) onDirection;

  bool _selected(List<Color> colors) {
    final a = style.gradientColors;
    if (a.length != colors.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != colors[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final presets = <(String, List<Color>)>[
      ('2 warna', [style.primary, style.secondary]),
      ('3 warna', [style.primary, style.secondary, style.tertiary]),
      ('Pink duo', [style.secondary, style.tertiary]),
      (
        'Brand',
        const [Color(0xFFFFD79B), kUiPrimary, kUiSecondary, kUiTertiary],
      ),
    ];
    final directions = <(String, Alignment, Alignment)>[
      ('↘', Alignment.topLeft, Alignment.bottomRight),
      ('→', Alignment.centerLeft, Alignment.centerRight),
      ('↓', Alignment.topCenter, Alignment.bottomCenter),
    ];

    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Gradient',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (label, colors) in presets)
                _GradientChip(
                  label: label,
                  colors: colors,
                  selected: _selected(colors),
                  onTap: () => onPick(colors),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Arah', style: TextStyle(fontSize: 13)),
              const Spacer(),
              for (final (icon, begin, end) in directions)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: ChoiceChip(
                    label: Text(icon),
                    selected:
                        style.gradientBegin == begin &&
                        style.gradientEnd == end,
                    onSelected: (_) => onDirection(begin, end),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GradientChip extends StatelessWidget {
  const _GradientChip({
    required this.label,
    required this.colors,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final List<Color> colors;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.white : Colors.white24,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}

class _OpacitySliderCard extends StatelessWidget {
  const _OpacitySliderCard({
    required this.value,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'Opacity glass',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(_pct(value), style: const TextStyle(color: Colors.white54)),
            ],
          ),
          Slider(
            value: value.clamp(0.0, 1.0),
            min: 0.0,
            max: 1.0,
            divisions: 40,
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ],
      ),
    );
  }
}

class _BlurSliderCard extends StatelessWidget {
  const _BlurSliderCard({
    required this.value,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'Blur',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                value == 0 ? 'mati' : '${value.toStringAsFixed(1)} px',
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),
          Slider(
            value: value.clamp(0.0, 30.0),
            min: 0.0,
            max: 30.0,
            divisions: 60,
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ],
      ),
    );
  }
}

class _ResetCard extends StatelessWidget {
  const _ResetCard({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return DompetCard(
      variant: DompetCardVariant.csGlassSurface,
      child: OutlinedButton.icon(
        onPressed: onReset,
        icon: const Icon(Icons.restart_alt),
        label: const Text('Reset ke bawaan'),
        style: OutlinedButton.styleFrom(
          foregroundColor: DompetBrand.pink,
          minimumSize: const Size.fromHeight(44),
          side: BorderSide(color: DompetBrand.pink.withValues(alpha: 0.5)),
        ),
      ),
    );
  }
}

String _pct(double value) => '${(value * 100).round()}%';
