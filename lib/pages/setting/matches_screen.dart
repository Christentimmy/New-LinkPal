import 'package:flutter/material.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 1),
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    "My Matches",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 1),
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: _searchController,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: 10,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 250,
                      child: Stack(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/rena.jpg",
                              fit: BoxFit.cover,
                              height: 250,
                              width: double.infinity,
                            ),
                          ),

                          // Dark gradient overlay at bottom
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8)
                                    ],
                                    stops: const [0.0, 0.9],
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Michelle, 23",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 15,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "New York, USA",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row testing(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 250,
          padding: const EdgeInsets.symmetric(vertical: 15),
          width: MediaQuery.of(context).size.width / 2.1,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/rena.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Michelle, 23"),
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 5),
                  Text("New York, USA"),
                ],
              )
            ],
          ),
        ),
        Container(
          height: 250,
          padding: const EdgeInsets.symmetric(vertical: 15),
          width: MediaQuery.of(context).size.width / 2.1,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/rena.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Michelle, 23"),
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 5),
                  Text("New York, USA"),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
