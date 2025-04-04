import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('日文小幫手')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //title area
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '歡迎來到日語學習應用',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            //content area
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '這裡是內容區域',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Icon(
                      Icons.school,
                      size: 50,
                      color: Color.fromARGB(0, 7, 85, 187),
                    ),
                  ],
                ),
              ),
            ),
            //button area
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('開始學習'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
