import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle,
              color: Colors.redAccent,
              size: 40,
            ),
            Gap(20),
            Text("About"),
          ],
        ),
        elevation: 4,
        scrolledUnderElevation: 4,
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Youtube DL v0.1",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            Gap(12),
            Text(
              "Developed by :",
              style: TextStyle(color: Colors.redAccent),
            ),
            Gap(12),
            Text(
              "Tsiresy Milà.",
              style: TextStyle(fontSize: 15,),
            ),
            Gap(6),
            Text(
              "tsiresymila@gmail.com.",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
    );
  }
}
