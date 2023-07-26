import 'package:flutter/material.dart';
import 'package:tsb_wine_list/models/alcohol_model.dart';
import 'package:tsb_wine_list/services/api_service.dart';
import 'package:tsb_wine_list/utils/logger.dart';
import 'package:tsb_wine_list/widgets/filter_component.dart';
import 'package:tsb_wine_list/widgets/toggle_buttons.dart';
import 'package:tsb_wine_list/widgets/alcohol_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AlcoholModel> alcohols = [];
  List<String> filters = [
    "레드",
    "화이트",
    "스파클링",
    "로제",
    "내추럴",
    "주정강화",
    "샴페인",
    "위스키"
  ];
  double minRange = 0;
  double maxRange = 1500000;
  bool isLoading = true;
  late ScrollController _gridScrollController;
  bool _showTopButton = false;
  bool isAscending = false;

  @override
  void initState() {
    fetchData();
    _gridScrollController = ScrollController();

    _gridScrollController.addListener(() {
      if (_gridScrollController.offset >= 100) {
        // 임의로 100 이상부터 보이게 설정
        setState(() {
          _showTopButton = true;
        });
      } else {
        setState(() {
          _showTopButton = false;
        });
      }
    });
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      final data = await ApiService.getAlcoholList();

      setState(() {
        alcohols = data;
        isLoading = false;
      });
    } catch (error) {
      logger.e(error);
    }
  }

  final TextEditingController _searchController = TextEditingController();

  void _performSearch() async {
    String keyword = _searchController.text;
    final data = await ApiService.searchAlcoholList(keyword);
    setState(() {
      alcohols = data;
    });
  }

  void handleFilter(List<Map<String, dynamic>> selected) {
    setState(() {
      filters = List<String>.from(
          selected.map((elem) => (elem)['category']).toList());
    });
  }

  void handleRange(double min, double max) {
    setState(() {
      minRange = min;
      maxRange = max;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        title: const Text(
          "TSB 와인 리스트",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: (isLoading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (alcohols.isNotEmpty)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: MultipleToggleButtons(handleFilter: handleFilter),
                    ),
                    ElevatedButton(
                        onPressed: switchPriceOrder,
                        child: Text(isAscending ? "최저가순" : "최고가순")),
                    SizedBox(
                      height: 100,
                      child: FilterComponent(handleRange: handleRange),
                    ),
                    Expanded(
                      child: makeList(alcohols
                          .where((data) => filters.contains(data.category))
                          .where((data) =>
                              data.price >= minRange &&
                              data.price <= maxRange &&
                              data.price != 0)
                          .toList()),
                    )
                  ],
                )
              : const Center(
                  child: Text(
                    "검색 결과가 없습니다.",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_showTopButton)
            FloatingActionButton(
              onPressed: () {
                // 최상단으로 올라가는 기능 추가
                _gridScrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            ),
          const SizedBox(height: 16), // 버튼 사이 간격 조절
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('와인 검색'),
                    content: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: '키워드를 입력하세요.',
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _performSearch();
                        },
                        child: const Text('검색'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  GridView makeList(List<AlcoholModel> alcohols) {
    if (isAscending) {
      alcohols.sort((a, b) => a.price.compareTo(b.price));
    } else {
      alcohols.sort((a, b) => b.price.compareTo(a.price));
    }

    return GridView.builder(
      itemCount: alcohols.length,
      controller: _gridScrollController,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        var alcohol = alcohols[index];
        return Alcohol(
          alcohol: alcohol,
        );
      },
    );
  }

  void switchPriceOrder() {
    setState(() {
      isAscending = !isAscending;
    });
  }
}
