import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linkingpal/models/post_model.dart';
import 'package:linkingpal/widgets/loading_widget.dart';

class FullDetailsOfPost extends StatelessWidget {
  final PostModel postModel;
  final int initalPage;
  const FullDetailsOfPost({
    super.key,
    required this.postModel,
    required this.initalPage,
  });

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: initalPage);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: SizedBox(
          height: 580,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            itemCount: postModel.files.length,
            onPageChanged: (value) {
              // _currentViewPic.value = value + 1;
            },
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
                imageUrl: postModel.files[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
