import 'package:flutter/material.dart';

class MultipleToggleButtons extends StatefulWidget {
  final Function handleFilter;
  const MultipleToggleButtons({super.key, required this.handleFilter});

  @override
  _MultipleToggleButtonsState createState() => _MultipleToggleButtonsState();
}

class _MultipleToggleButtonsState extends State<MultipleToggleButtons> {
  final List<Map<String, dynamic>> _filters = [
    {"category": "레드", "selected": true},
    {"category": "화이트", "selected": true},
    {"category": "스파클링", "selected": true},
    {"category": "로제", "selected": true},
    {"category": "내추럴", "selected": true},
    {"category": "주정강화", "selected": true},
    {"category": "샴페인", "selected": true},
    {"category": "위스키", "selected": true}
  ];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected:
          List<bool>.from(_filters.map((data) => data['selected']).toList()),
      onPressed: (int index) {
        setState(() {
          _filters[index]['selected'] = !_filters[index]['selected'];
        });
        widget.handleFilter(
            _filters.where((element) => element['selected']).toList());
      },
      children: _filters.map((elem) => Text(elem['category'])).toList(),
    );
  }
}
