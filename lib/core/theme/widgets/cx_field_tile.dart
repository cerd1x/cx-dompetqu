import 'package:material_ui/material_ui.dart';
import 'package:mix/mix.dart';

import 'package:cx_dompetqiu/core/theme/dompet_brand.dart';
import 'package:cx_dompetqiu/core/theme/widgets/cx_icons.dart';

/// Tile input bergaya `csinput` yang bisa ditap untuk membuka pemilih
/// (tanggal, aset, dsb).
///
/// Sebelumnya kelas ini bernama `FieldTile` dan tinggal di
/// `features/assets/view/widgets/asset_picker_field.dart`, sehingga fitur lain
/// (mis. `DateField` di order) harus mengimpor widget milik fitur assets.
/// Setelah dipindah ke `core/`, tidak ada lagi ketergantungan antarfitur dan
/// tile ini juga dipakai internal oleh
/// [CxPickerFieldWithModalTopbar].
class CxFieldTile extends StatelessWidget {
  const CxFieldTile({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    required this.leading,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final IconData leading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Box(
            style: BoxStyler()
                .padding(
                  EdgeInsetsGeometryMix.value(
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                )
                .decoration(
                  DecorationMix.value(
                    BoxDecoration(
                      color: DompetBrand.csFill,
                      borderRadius: BorderRadius.circular(DompetBrand.radius),
                      border: Border.all(color: DompetBrand.csBorder, width: 1),
                    ),
                  ),
                ),
            child: Row(
              children: [
                Icon(leading, size: 18, color: Colors.white54),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                const Icon(
                  CxIcons.chevronRightRounded,
                  size: 18,
                  color: Colors.white38,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
