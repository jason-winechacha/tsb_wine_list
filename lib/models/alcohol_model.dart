class AlcoholModel {
  String name,
      nameKr,
      imageUrl,
      descriptionTap,
      category,
      country,
      countryCode,
      itemCd;
  int id, price, volume;

  AlcoholModel({
    required this.name,
    required this.nameKr,
    required this.imageUrl,
    required this.descriptionTap,
    required this.category,
    required this.country,
    required this.countryCode,
    required this.id,
    required this.price,
    required this.volume,
    required this.itemCd,
  });

  AlcoholModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] ?? "",
        nameKr = json['nameKr'] ?? "",
        imageUrl = json['imageURL'] ?? "",
        descriptionTap = json['descriptionTap'] ?? "",
        category = json['wineMetaData'] != null &&
                json['wineMetaData']['wineCategory'] != null
            ? json['wineMetaData']['wineCategory']['name_kr']
            : json['alcoholCategory']['name_kr'],
        price = json['price'],
        volume = json['volume'],
        country = json['country'] != null ? json['country']['name'] : "",
        countryCode = json['country'] != null ? json['country']['code'] : "",
        itemCd = json['itemCd'] ?? "";

  void init() {
    name = "";
    nameKr = "";
    imageUrl = "";
    descriptionTap = "";
    category = "";
    country = "";
    countryCode = "";
    itemCd = "";

    id = 0;
    price = 0;
    volume = 0;
  }
}
