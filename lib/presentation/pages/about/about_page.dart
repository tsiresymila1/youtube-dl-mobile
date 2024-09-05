import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
            Text(
              "About",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 4,
        scrolledUnderElevation: 4,
      ),
      body:  Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Youtube DL v0.1",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const Gap(12),
            const Text(
              "Developed by :",
              style: TextStyle(color: Colors.redAccent),
            ),
            const Gap(12),
            const Text(
              "Tsiresy Milà.",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const Gap(6),
            InkWell(
              onTap: (){
                final uri = Uri.parse("mailto:tsiresymila@gmail.com");
                launchUrl(uri).then((_){});
              },
              child: const Text(
                "tsiresymila@gmail.com",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red),
              ),
            ),
            const Gap(6),
            InkWell(
              onTap: (){
                final uri = Uri.parse("tel:+261342083574");
                launchUrl(uri).then((_){});
              },
              child: const Text(
                "0342083574",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
