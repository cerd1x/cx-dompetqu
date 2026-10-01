import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../dompet_brand.dart';

/// Picker selector berbentuk roda (wheel) bergaya CS glass.
///
/// Menampilkan daftar item dalam scroll vertikal atau horizontal dengan
/// indikator seleksi di bagian tengah. Item terpilih menyala dengan
/// aksen gold; item di luar pusat meredup.
///
/// [axis] menentukan arah scroll:
/// - `Axis.vertical` (default): scroll vertikal seperti iOS picker
/// - `Axis.horizontal`: scroll horizontal menggunakan RotatedBox
///
/// Contoh penggunaan:
/// ```dart
/// CsSelectorWheelPicker<String>(
///   items: ['A', 'B', 'C'],
///   selectedItem: selected,
///   onChanged: (v) => setState(() => selected = v),
/// )
/// ```
class CsSelectorWheelPicker<T> extends StatefulWidget {
  const CsSelectorWheelPicker({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.itemHeight = 12,
    this.visibleItems = 3,
    this.textStyle,
    this.selectedTextStyle,
    this.gapBetweenItem = 1,
    this.itemLabel,
    this.wheelWidth = 100,
    this.axis = Axis.vertical,
  });

  final List<T> items;
  final T selectedItem;
  final ValueChanged<T> onChanged;
  final double itemHeight;
  final int visibleItems;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final double gapBetweenItem;
  final String Function(T item)? itemLabel;
  final double wheelWidth;
  final Axis axis;

  @override
  State<CsSelectorWheelPicker<T>> createState() =>
      _CsSelectorWheelPickerState<T>();
}

class _CsSelectorWheelPickerState<T> extends State<CsSelectorWheelPicker<T>> {
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final initialIndex = widget.items.indexOf(widget.selectedItem);
    _scrollController = FixedExtentScrollController(
      initialItem: initialIndex.clamp(0, widget.items.length - 1),
    );
  }

  @override
  void didUpdateWidget(CsSelectorWheelPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItem != widget.selectedItem) {
      final newIndex = widget.items.indexOf(widget.selectedItem);
      if (newIndex >= 0 && newIndex < widget.items.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              _scrollController.hasClients &&
              _scrollController.selectedItem != newIndex) {
            _scrollController.jumpToItem(newIndex);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onSelectedChanged(int index) {
    if (index >= 0 && index < widget.items.length) {
      final selected = widget.items[index];
      if (selected != widget.selectedItem) {
        widget.onChanged(selected);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.axis == Axis.vertical;
    final itemCount = widget.items.length;

    if (!isVertical) {
      return _buildHorizontalWheel(itemCount);
    }

    return _buildVerticalWheel(itemCount);
  }

  Widget _buildVerticalWheel(int itemCount) {
    final totalHeight =
        widget.visibleItems * widget.itemHeight +
        (widget.visibleItems - 1) * widget.gapBetweenItem;

    return Box(
      style: BoxStyler.height(totalHeight)
          .width(widget.wheelWidth)
          .gradient(DompetBrand.gradientWithAlpha(.4))
          .borderRadius(.circular(20))
          .borderAll(color: DompetBrand.csBorder, width: 1.5),
      child: ListWheelScrollView.useDelegate(
        controller: _scrollController,
        itemExtent: 15,
        diameterRatio: 1.4,
        perspective: 0.002,
        squeeze: 0.9,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: _onSelectedChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= itemCount) {
              return const SizedBox.shrink();
            }
            final isSelected = widget.items[index] == widget.selectedItem;
            final item = widget.items[index];
            return _WheelItem(
              label: widget.itemLabel != null
                  ? widget.itemLabel!(item)
                  : item.toString(),
              isSelected: isSelected,
              textStyle: isSelected
                  ? (widget.selectedTextStyle ??
                        const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: DompetBrand.blackBg,
                        ))
                  : (widget.textStyle ??
                        const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        )),
            );
          },
          childCount: itemCount,
        ),
      ),
    );
  }

  Widget _buildHorizontalWheel(int itemCount) {
    // Calculate width based on item count and item width
    final itemWidth = widget.wheelWidth / widget.visibleItems;
    final totalWidth =
        itemCount * itemWidth + (itemCount - 1) * widget.gapBetweenItem;

    return SizedBox(
      height: widget.itemHeight * 2,
      width: totalWidth.clamp(0, MediaQuery.of(context).size.width * 0.5),
      child: RotatedBox(
        quarterTurns: 3, // Rotate 270 degrees to make vertical wheel horizontal
        child: ListWheelScrollView.useDelegate(
          controller: _scrollController,
          itemExtent: widget.wheelWidth,
          diameterRatio: .5,
          perspective: 0.002,
          squeeze: 0.1,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: _onSelectedChanged,
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              if (index < 0 || index >= itemCount) {
                return const SizedBox.shrink();
              }
              final isSelected = widget.items[index] == widget.selectedItem;
              final item = widget.items[index];
              final effectiveStyle = isSelected
                  ? (widget.selectedTextStyle ??
                        const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: DompetBrand.blackBg,
                        ))
                  : (widget.textStyle ??
                        const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ));
              return _WheelItem(
                label: widget.itemLabel != null
                    ? widget.itemLabel!(item)
                    : item.toString(),
                isSelected: isSelected,
                textStyle: effectiveStyle,
              );
            },
            childCount: itemCount,
          ),
        ),
      ),
    );
  }
}

class _WheelItem extends StatelessWidget {
  const _WheelItem({
    required this.label,
    required this.isSelected,
    required this.textStyle,
  });

  final String label;
  final bool isSelected;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        child: Text(
          label,
          style: textStyle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
