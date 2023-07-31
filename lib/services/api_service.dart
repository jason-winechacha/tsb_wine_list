import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tsb_wine_list/models/alcohol_model.dart';
import 'package:tsb_wine_list/utils/logger.dart';

class ApiService {
  static const String baseUrl = "https://api.tapshop.bar/alcohol/list/public";

  static Future<List<AlcoholModel>> getAlcoholList() async {
    List<AlcoholModel> alcoholInstances = [];
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final alcohols = jsonDecode(response.body)["alcohols"];
      for (var alcohol in alcohols) {
        final instance = AlcoholModel.fromJson(alcohol);
        alcoholInstances.add(instance);
      }
      return alcoholInstances;
    }
    throw Error();
  }

  static Future<AlcoholModel> getAlcoholById(int id) async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final alcohols = jsonDecode(response.body)["alcohols"];
      for (var alcohol in alcohols) {
        final item = AlcoholModel.fromJson(alcohol);
        if (item.id == id) {
          return item;
        }
      }
      return AlcoholModel.fromJson({"id": id});
    }
    throw Error();
  }

  static Future<List<AlcoholModel>> searchAlcoholList(String keyword) async {
    List<AlcoholModel> alcoholInstances = [];
    final url = Uri.parse('$baseUrl?search=$keyword');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final alcohols = jsonDecode(response.body)["alcohols"];
      for (var alcohol in alcohols) {
        final instance = AlcoholModel.fromJson(alcohol);
        alcoholInstances.add(instance);
      }
      return alcoholInstances;
    }
    throw Error();
  }

  static Future<String> getFlagEmoji(String countryCode) async {
    final url = Uri.parse('https://restcountries.com/v3.1/alpha/$countryCode');
    logger.e(url);
    final response = await http.get(url);
    logger.e(response.statusCode);
    logger.e(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)[0]["flag"] ?? '🏳️';
    }
    throw Error();
  }
}
