import 'package:flutter/material.dart';

class BubbleRow extends StatefulWidget {
  final Function callback;
  const BubbleRow({required this.callback, super.key});

  @override
  State<BubbleRow> createState() => _BubbleRowState();
}

class _BubbleRowState extends State<BubbleRow> {
  List<String> bubbles = [
    "전체",
    "레드",
    "화이트",
    "스파클링",
    "로제",
    "내추럴",
    "주정강화",
    "샴페인",
    "위스키",
  ];

  int hoverIdx = -1;
  int selectedIdx = 0;

  void _handleItemClick(int index) {
    widget.callback(bubbles[index]);

    setState(() {
      selectedIdx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          bubbles.length,
          (index) => GestureDetector(
            onTap: () => _handleItemClick(index),
            child: Container(
              decoration: BoxDecoration(
                color: selectedIdx == index || hoverIdx == index
                    ? Colors.white
                    : const Color(0xFF252126),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(4),
              child: Text(
                bubbles[index],
                style: TextStyle(
                  color: selectedIdx == index || hoverIdx == index
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
