import 'package:flutter/material.dart';
// import '../core/database/db.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar will delete after stable version'),
      ),
      backgroundColor: const Color.fromRGBO(202, 66, 66, 1),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height, // 限制最小高度為螢幕高度
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                // user analysis area
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.analytics, size: 50),
                        color: const Color.fromARGB(255, 255, 225, 169),
                        onPressed: () {
                          Navigator.pushNamed(context, '/userAnalysis');
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.settings, size: 50),
                        color: const Color.fromARGB(255, 41, 141, 255),
                        onPressed: () {
                          Navigator.pushNamed(context, '/setting');
                        },
                      ),
                    ),
                  ],
                ),

                // title area
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                  indent: 16,
                  endIndent: 16,
                ),
                // Spacer to push buttons to the bottom
                const Spacer(),
                // content area (buttons)
                _buildTrainButton(
                  context,
                  title: '單字練習',
                  onPressed: () {
                    Navigator.pushNamed(context, '/wordPractice');
                  },
                  color: Colors.blue,
                ),
                const SizedBox(height: 16), // 間距
                _buildTrainButton(
                  context,
                  title: '文法練習',
                  onPressed: () {
                    Navigator.pushNamed(context, '/grammarPractice');
                  },
                  color: Colors.green,
                ),
                const SizedBox(height: 16), // 間距
                _buildTrainButton(
                  context,
                  title: '聽力練習',
                  onPressed: () {
                    Navigator.pushNamed(context, '/listeningPractice');
                  },
                  color: Colors.orange,
                ),
                const Spacer(), // Spacer to add even spacing at the bottom
              ],
            ),
          ),
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
