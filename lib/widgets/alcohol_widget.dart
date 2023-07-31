import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tsb_wine_list/models/alcohol_model.dart';
import 'package:tsb_wine_list/utils/logger.dart';

class Alcohol extends StatefulWidget {
  final AlcoholModel alcohol;

  const Alcohol({
    super.key,
    required this.alcohol,
  });

  @override
  State<Alcohol> createState() => _AlcoholState();
}

class _AlcoholState extends State<Alcohol> {
  bool isLongPressing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/alcohol', arguments: {"alcohol": widget.alcohol});
      },
      onLongPress: () => copyToClipboard(widget.alcohol.nameKr),
      onTapDown: (details) {
        setState(() {
          isLongPressing = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          isLongPressing = false;
        });
      },
      onLongPressEnd: (details) {
        setState(() {
          isLongPressing = false;
        });
      },
      child: Column(
        children: [
          Hero(
            tag: widget.alcohol.id,
            child: Container(
              height: 200,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              width: MediaQuery.of(context).size.width * 0.42,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: isLongPressing
                    ? Colors.lightBlueAccent
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.network(widget.alcohol.imageUrl),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.25, // Set the desired width
                      child: Text(
                        widget.alcohol.name,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.25, // Set the desired width
                      child: Text(
                        widget.alcohol.nameKr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  NumberFormat.currency(locale: 'ko_KR', symbol: '₩')
                      .format(widget.alcohol.price),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
        // ),
      ),
    );
  }

  void copyToClipboard(String value) {
    Clipboard.setData(ClipboardData(text: value));
    logger.e('변수 값이 클립보드에 복사되었습니다: $value');

    Fluttertoast.showToast(
      msg: '텍스트가 클립보드에 복사되었습니다.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
