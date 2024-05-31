import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/widgets/loading_widget.dart';

class VieAllPostedPics extends StatelessWidget {
  final RxList<String> allPostedPics;
  final int? initalPage;
  const VieAllPostedPics({
    super.key,
    required this.allPostedPics,
    this.initalPage,
  });

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: initalPage ?? 0);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: SizedBox(
          height: 580,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: pageController,
            itemCount: allPostedPics.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error),
                ),
                width: double.infinity,
                placeholder: (context, url) {
                  return const Center(
                    child: Loader(color: Colors.deepOrangeAccent),
                  );
                },
                imageUrl: allPostedPics[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
