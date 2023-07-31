import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tsb_wine_list/models/alcohol_model.dart';
import 'package:tsb_wine_list/services/api_service.dart';
import 'package:tsb_wine_list/utils/logger.dart';
import 'package:tsb_wine_list/widgets/bubble_row.dart';
import 'package:tsb_wine_list/widgets/filter_component.dart';
import 'package:tsb_wine_list/widgets/alcohol_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AlcoholModel> alcohols = [];
  double minRange = 0;
  double maxRange = 1500000;
  bool isLoading = true;
  late ScrollController _gridScrollController;
  bool _showTopButton = false;
  bool isAscending = false;
  String selectedCategory = "전체";
  String searchKeyword = "";

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
      searchKeyword = keyword;
    });
    _searchController.text = "";
  }

  void _resetSearch() async {
    String keyword = "";
    final data = await ApiService.searchAlcoholList(keyword);

    setState(() {
      alcohols = data;
      searchKeyword = keyword;
    });

    _searchController.text = "";
  }

  void handleRange(double min, double max) {
    setState(() {
      minRange = min;
      maxRange = max;
    });
  }

  void handleBubbleClick(String selected) {
    setState(() {
      selectedCategory = selected;
    });
  }

  List<AlcoholModel> filterItemsByCategory(
      List<AlcoholModel> itemList, String category) {
    if (category.toLowerCase() == "전체") {
      return itemList;
    } else {
      List<AlcoholModel> filteredItems =
          itemList.where((item) => item.category == category).toList();
      return filteredItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text(
          "TSB 상품 리스트",
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
                      height: 20,
                    ),
                    BubbleRow(callback: handleBubbleClick),
                    SizedBox(
                      child: FilterComponent(handleRange: handleRange),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (searchKeyword.isNotEmpty)
                              ? Container(
                                  padding: const EdgeInsets.all(
                                    10,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                      border: Border.all(
                                        color: Colors.black,
                                      )),
                                  child: Row(
                                    children: [
                                      Text(searchKeyword),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: _resetSearch,
                                        child: const Icon(
                                          FontAwesomeIcons.x, // 아이콘 코드
                                          size: 13.0,
                                        ),
                                      )
                                    ],
                                  ))
                              : Container(),
                          ElevatedButton(
                              onPressed: switchPriceOrder,
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Colors.grey.shade200,
                                ),
                                foregroundColor: const MaterialStatePropertyAll(
                                  Colors.black,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.list, // 아이콘 코드
                                    size: 15.0,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text("가격순"),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  isAscending
                                      ? const Icon(
                                          FontAwesomeIcons.arrowUp, // 아이콘 코드
                                          size: 15.0,
                                        )
                                      : const Icon(
                                          FontAwesomeIcons.arrowDown, // 아이콘 코드
                                          size: 15.0,
                                        ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: makeList(alcohols
                          // .where((data) => filters.contains(data.category))
                          .where((data) =>
                              data.price >= minRange &&
                              data.price <= maxRange &&
                              data.price != 0 &&
                              data.itemCd != "")
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
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary,
                          ),
                        ),
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

    alcohols = filterItemsByCategory(alcohols, selectedCategory);

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
