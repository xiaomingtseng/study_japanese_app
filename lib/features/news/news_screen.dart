import 'package:flutter/material.dart';
import 'package:study_japanese/core/http/news.dart';

class NewsScreen extends StatelessWidget {
  final NHKEasyNews newsService = NHKEasyNews();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NHK Easy News')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: newsService.fetchLatestNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('發生錯誤: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return ListTile(
                  title: Text(news['title'] ?? '無標題'),
                  subtitle: Text(news['date'] ?? '未知日期'),
                  onTap: () {
                    final newsUrl = news['news_web_url'] ?? '';
                    if (newsUrl.isNotEmpty) {
                      Navigator.pushNamed(
                        context,
                        '/newsDetail',
                        arguments: newsUrl, // 傳遞新聞的 URI
                      );
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('無法打開新聞，缺少網址')));
                    }
                  },
                );
              },
            );
          } else {
            return Center(child: Text('沒有新聞資料'));
          }
        },
      ),
    );
  }
}
