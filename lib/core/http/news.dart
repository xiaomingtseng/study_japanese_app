import 'dart:convert';
import 'package:http/http.dart' as http;

class NHKEasyNews {
  static const String _baseUrl =
      'https://www3.nhk.or.jp/news/easy/news-list.json';

  // 獲取最新新聞
  Future<List<Map<String, dynamic>>> fetchLatestNews({int limit = 10}) async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // 解析 JSON 數據為 List
        final List<dynamic> newsList = json.decode(response.body);

        // 提取所有新聞項目
        final List<dynamic> allNews = [];
        for (var dailyNews in newsList) {
          dailyNews.forEach((date, newsItems) {
            allNews.addAll(newsItems);
          });
        }

        // 限制返回的新聞數量
        final limitedNewsList = allNews.take(limit).toList();

        // 轉換為所需的格式
        return limitedNewsList.map((news) {
          return {
            'title': news['title'] ?? '無標題',
            'date': news['news_prearranged_time'] ?? '未知日期',
            'news_id': news['news_id'] ?? '',
            'news_web_url': news['news_web_url'] ?? '',
          };
        }).toList();
      } else {
        throw Exception('無法獲取新聞，狀態碼: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('獲取新聞時發生錯誤: $e');
    }
  }
}
