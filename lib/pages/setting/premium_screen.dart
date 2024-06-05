import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF060C1F),
        title: const Text(
          "Choose Package",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                PremiumCard(
                  currentWidth: currentWidth,
                  cardTitle: "Daily",
                  price: 299,
                ),
                PremiumCard(
                  currentWidth: currentWidth,
                  cardTitle: 'Weekly',
                  price: 599,
                ),
                PremiumCard(
                  currentWidth: currentWidth,
                  cardTitle: 'Monthly',
                  price: 599,
                ),
                PremiumCard(
                  currentWidth: currentWidth,
                  cardTitle: 'Yearly',
                  price: 599,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumCard extends StatelessWidget {
  final String cardTitle;
  final int price;
  const PremiumCard({
    super.key,
    required this.currentWidth,
    required this.cardTitle,
    required this.price,
  });

  final double currentWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: currentWidth / 1.4,
          height: 290,
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                offset: Offset(-15, -20),
                blurRadius: 1,
                spreadRadius: 2,
                color: Color.fromARGB(24, 255, 255, 255),
              )
            ],
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF060C1F),
          ),
          child: Column(
            children: [
              Image.asset("assets/images/premium-pack.png", width: 50),
              Text(
                cardTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                "Select or re-select activities/moods multiple times and have unlimited swipes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$$price ",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Text(
                    "/ ",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    cardTitle,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 150,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 4),
                        color: Color.fromARGB(34, 0, 0, 0),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ]),
                child: const Text(
                  "Add Now",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
