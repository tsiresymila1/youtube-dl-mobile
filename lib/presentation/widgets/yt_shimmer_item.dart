import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class YTShimmerItem extends StatelessWidget {
  const YTShimmerItem({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 200.0, // Adjust the height as needed
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: const Icon(Icons.play_circle_fill, color: Colors.redAccent, size: 40.0),
            ),
            title: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 16.0,
                color: Colors.white,
              ),
            ),
            subtitle: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 12.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}