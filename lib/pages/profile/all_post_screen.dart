import 'package:flutter/material.dart';
import 'package:linkingpal/pages/home/home_screen.dart';

class AllPostScreen extends StatelessWidget {
  const AllPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 1),
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        )
                      ],
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "AllPosts",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 1),
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        )
                      ],
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.more_vert_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: 10,
              //     itemBuilder: (context, index) {
              //       return const AltPageView();
              //     },
              //   ),
              // ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
