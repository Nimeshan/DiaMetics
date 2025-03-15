import 'package:flutter/material.dart';
import 'HamburgerMenu.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF2893E),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, size: 20),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.lightbulb, size: 20),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.local_hospital, size: 20),
            ),
          ],
        ),
        drawer: const HamburgerMenu(), // Attach the drawer
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Diabetic Risk Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircularPercentIndicator(
                    radius: 65.0,
                    lineWidth: 6.0,
                    percent: 220 / 360,
                    center: const Text(
                      "220",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    progressColor: Colors.red,
                    backgroundColor: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Diabetic Risk Level",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "High",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Sugar Intake",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AspectRatio(
                aspectRatio: 1.2,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text(
                                  "Today",
                                  style: TextStyle(fontSize: 10),
                                );
                              case 1:
                                return const Text(
                                  "Yesterday",
                                  style: TextStyle(fontSize: 10),
                                );
                            }
                            return const Text("");
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        bottom: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 360),
                          FlSpot(1, 90),
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 1.5,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "You have Eaten",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Card(
                color: Color(0xFFFBECEC), // Background color for the card
                elevation: 4, // Adds shadow to the card
                margin: EdgeInsets.symmetric(
                    horizontal: 16), // Adds horizontal padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16), // Adds inner padding
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            8), // Rounded corners for the image
                        child: Image.asset(
                          "assets/food.jpg",
                          width: 50, // Image width
                          height: 50, // Image height
                          fit: BoxFit.cover, // Ensures the image fits nicely
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Food Name",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "25g sugar",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Color(0xFFFBECEC), // Background color for the card
                elevation: 4, // Adds shadow to the card
                margin: EdgeInsets.symmetric(
                    horizontal: 16), // Adds horizontal padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16), // Adds inner padding
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            8), // Rounded corners for the image
                        child: Image.asset(
                          "assets/food.jpg",
                          width: 50, // Image width
                          height: 50, // Image height
                          fit: BoxFit.cover, // Ensures the image fits nicely
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Food Name",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "25g sugar",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Color(0xFFFBECEC), // Background color for the card
                elevation: 4, // Adds shadow to the card
                margin: EdgeInsets.symmetric(
                    horizontal: 16), // Adds horizontal padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16), // Adds inner padding
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            8), // Rounded corners for the image
                        child: Image.asset(
                          "assets/food.jpg",
                          width: 50, // Image width
                          height: 50, // Image height
                          fit: BoxFit.cover, // Ensures the image fits nicely
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Food Name",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "25g sugar",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
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
