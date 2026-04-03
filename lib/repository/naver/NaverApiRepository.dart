
import 'package:dio/dio.dart';
import 'package:fitmate_app/config/AppConfig.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final naverApiRepositoryProvider = Provider<NaverApiRepository>((ref) {
  return NaverApiRepository();
});

class NaverApiRepository {
  final Dio dio = Dio();
  final String clientId = AppConfig.naverClientId;
  final String clientSecret = AppConfig.naverClientSecret;

  Future<List<Map<String, dynamic>>> searchPlace(String keyword) async {
    String url = 'https://openapi.naver.com/v1/search/local.json';
    Map<String, dynamic> queryString = {
      'query': keyword,
      'display': 5,
    };
    Map<String, dynamic> hearers = {
      'X-Naver-Client-Id': clientId,
      'X-Naver-Client-Secret': clientSecret,
    };

    final response = await dio.get(
        url,
        queryParameters: queryString,
        options: Options(
          headers: hearers
        )
    );

    final htmlTagRegex = RegExp(r'<[^>]*>');
    List<String> keysToKeep = ['title', 'roadAddress', 'address'];
    List<Map<String, dynamic>> filteredItems = List<Map<String, dynamic>>.from(response.data['items']).map((item) {
      return Map.fromEntries(item.entries.where((entry) => keysToKeep.contains(entry.key)).map((entry) {
        return MapEntry(entry.key, (entry.value as String).replaceAll(htmlTagRegex, ''));
      }));
    }).toList();

    return filteredItems;
  }
}