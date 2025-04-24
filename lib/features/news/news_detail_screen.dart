// filepath: d:\Github\flutter\study_japanese_app\lib\features\news\news_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class NewsDetailScreen extends StatefulWidget {
  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  String? newsContent; // 儲存解析後的新聞內容
  bool isLoading = true; // 加載狀態
  String? errorMessage; // 錯誤訊息

  @override
  void initState() {
    super.initState();
    _fetchNewsContent();
  }

  Future<void> _fetchNewsContent() async {
    final String newsUrl = ModalRoute.of(context)?.settings.arguments as String;

    try {
      // 發送 HTTP 請求
      final response = await http.get(Uri.parse(newsUrl));

      if (response.statusCode == 200) {
        // 解析 HTML
        final document = html_parser.parse(response.body);

        // 提取新聞內容（假設內容在 <section class="content--detail-main"> 中）
        final contentElement = document.querySelector('.content--detail-main');
        setState(() {
          newsContent = contentElement?.text.trim() ?? '無法提取新聞內容';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = '無法加載新聞，狀態碼: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '加載新聞時發生錯誤: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('新聞詳細內容')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    newsContent ?? '無內容',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
    );
  }
}
