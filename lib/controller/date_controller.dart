import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateController extends GetxController {
  final RxInt _dayIndex = (-1).obs;
  final RxInt _monthIndex = (-1).obs;
  final RxInt _yearIndex = (-1).obs;
  final List _months = [
    ["Jan", 1],
    ["Feb", 2],
    ["Mar", 3],
    ["Apr", 4],
    ["May", 5],
    ["Jun", 6],
    ["Jul", 7],
    ["Aug", 8],
    ["Sep", 9],
    ["Oct", 10],
    ["Nov", 11],
    ["Dec", 12],
  ];

  void showCustomDays(BuildContext context, RxInt selectedDay) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Day"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: const Text(
                "Ok",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
          content: SizedBox(
            height: 160,
            // width: 400,
            child: GridView.builder(
              itemCount: 31,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    selectedDay.value = index + 1;
                    _dayIndex.value = index;
                  },
                  child: Obx(
                    () => Container(
                      height: 25,
                      width: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _dayIndex.value == index
                            ? Colors.deepOrangeAccent
                            : null,
                      ),
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showCustomMonths(BuildContext context, RxInt selectedMonth) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Select Month",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: const Text(
                "Ok",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
          content: SizedBox(
            height: 300,
            child: GridView.builder(
              itemCount: _months.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _monthIndex.value = index;
                    selectedMonth.value = _months[index][1];
                  },
                  child: Obx(
                    () => Container(
                      margin: const EdgeInsets.all(15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: _monthIndex.value == index
                            ? Border.all(
                                width: 2,
                                color: Colors.deepOrangeAccent,
                              )
                            : null,
                      ),
                      child: Text(
                        _months[index][0],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showYearRange(BuildContext context, RxInt selectedYear) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Select Year",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: const Text(
                "Ok",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
          content: SizedBox(
            height: 250,
            child: GridView.builder(
              itemCount: 75,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _yearIndex.value = index;
                    selectedYear.value = index + 1950;
                  },
                  child: Obx(
                    () => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: _yearIndex.value == index
                            ? Border.all(
                                color: Colors.deepOrangeAccent,
                              )
                            : null,
                      ),
                      child: Text(
                        (index + 1950).toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          // color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  DateTime getDate(int selectedDay, int selectedMonth, int selectedYear) {
    // Ensure the date is valid
    if (selectedDay < 1 ||
        selectedDay > 31 ||
        selectedMonth < 1 ||
        selectedMonth > 12 ||
        selectedYear < 1) {
      throw ArgumentError('Invalid date');
    }
    return DateTime(selectedYear, selectedMonth, selectedDay);
  }
}
