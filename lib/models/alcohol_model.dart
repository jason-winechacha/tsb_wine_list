class AlcoholModel {
  final String name,
      nameKr,
      imageUrl,
      descriptionTap,
      category,
      country,
      countryCode;
  final int id, price, volume;

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
        countryCode = json['country'] != null ? json['country']['code'] : "";
}
