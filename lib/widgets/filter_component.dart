import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterComponent extends StatefulWidget {
  final Function handleRange;
  const FilterComponent({super.key, required this.handleRange});

  @override
  _FilterComponentState createState() => _FilterComponentState();
}

class _FilterComponentState extends State<FilterComponent> {
  static const double _minPrice = 0;
  static const double _maxPrice = 1500000;
  RangeValues _selectedRange = const RangeValues(_minPrice, _maxPrice);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RangeSlider(
          values: _selectedRange,
          min: _minPrice,
          max: _maxPrice,
          divisions: 20,
          labels: RangeLabels(
              NumberFormat.currency(locale: 'ko_KR', symbol: '₩')
                  .format(_selectedRange.start),
              NumberFormat.currency(locale: 'ko_KR', symbol: '₩')
                  .format(_selectedRange.end)),
          onChanged: (RangeValues values) {
            setState(() {
              _selectedRange = values;
              widget.handleRange(values.start, values.end);
            });
          },
        ),
      ],
    );
  }
}
