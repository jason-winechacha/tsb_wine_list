import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tsb_wine_list/models/alcohol_model.dart';
import 'package:tsb_wine_list/services/api_service.dart';
import 'package:tsb_wine_list/utils/logger.dart';

class AlcoholDetail extends StatefulWidget {
  // final int id;
  final AlcoholModel alcohol;

  // const AlcoholDetail({required this.id, super.key});
  const AlcoholDetail({required this.alcohol, super.key});

  @override
  State<AlcoholDetail> createState() => _AlcoholDetailState();
}

class _AlcoholDetailState extends State<AlcoholDetail> {
  // bool isLoading = true;
  String flagEmoji = '';
  // AlcoholModel alcohol = AlcoholModel(
  //   name: "",
  //   nameKr: "",
  //   imageUrl: "",
  //   descriptionTap: "",
  //   category: "",
  //   country: "",
  //   countryCode: "",
  //   id: 0,
  //   price: 0,
  //   volume: 0,
  // );

  @override
  void initState() {
    // getAlcohol(widget.id);
    countryToEmoji(widget.alcohol.countryCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.alcohol.nameKr,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(children: [
        Positioned(
          top: 20,
          right: 20,
          child: Text(
            flagEmoji,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: widget.alcohol.id,
                child: Container(
                  height: 350,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.network(
                    widget.alcohol.imageUrl,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        // The image has finished loading
                        return child;
                      } else {
                        // The image is still loading
                        return CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.alcohol.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                widget.alcohol.nameKr,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              IconButton(
                onPressed: () => copyToClipboard(widget.alcohol.nameKr),
                icon: const Icon(Icons.copy_outlined),
                color: Colors.blueAccent,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoRow(Colors.blueGrey, widget.alcohol.category),
                  _buildInfoRow(
                      Colors.blueGrey,
                      NumberFormat.currency(locale: 'ko_KR', symbol: '₩')
                          .format(widget.alcohol.price)),
                  _buildInfoRow(Colors.blueGrey,
                      "${widget.alcohol.volume.toString()} ml"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.alcohol.descriptionTap,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildInfoRow(Color color, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> countryToEmoji(String countryCode) async {
    final emoji = await ApiService.getFlagEmoji(countryCode);
    logger.e(emoji);
    setState(() {
      flagEmoji = emoji;
    });
  }

  void copyToClipboard(String value) {
    Clipboard.setData(ClipboardData(text: value));
    logger.e('변수 값이 클립보드에 복사되었습니다: $value');

    Fluttertoast.showToast(
      msg: '텍스트가 클립보드에 복사되었습니다.',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
    );
  }

  // Future<void> getAlcohol(int id) async {
  //   final item = await ApiService.getAlcoholById(id);
  //   setState(() {
  //     alcohol = item;
  //     countryToEmoji(item.countryCode);
  //     isLoading = false;
  //   });
  // }
}
