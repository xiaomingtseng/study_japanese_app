import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar will delete after stable version'),
      ),
      backgroundColor: Color.fromRGBO(202, 66, 66, 1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //title area
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '歡迎來到日語學習應用',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),

            // contenet area
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTrainButton(
                    context,
                    title: '單字練習',
                    onPressed: () {
                      Navigator.pushNamed(context, '/wordPractice');
                    },
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  _buildTrainButton(
                    context,
                    title: '文法練習',
                    onPressed: () {
                      Navigator.pushNamed(context, '/grammarPractice');
                    },
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  _buildTrainButton(
                    context,
                    title: '聽力練習',
                    onPressed: () {
                      Navigator.pushNamed(context, '/listeningPractice');
                    },
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTrainButton(
  BuildContext context, {
  required String title,
  // required Icon icon,
  required Color color,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: () {
      // call the onPressed function passed as a parameter
      onPressed();
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    ),
    child: Text(
      title,
      style: const TextStyle(fontSize: 20, color: Colors.white),
    ),
  );
}
