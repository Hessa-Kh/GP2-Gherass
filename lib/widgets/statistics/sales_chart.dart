import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesChart extends StatelessWidget {
  final String timeframe;

  const SalesChart({super.key, required this.timeframe});

  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;
    List<String> labels = [];
    List<FlSpot> spots = [];
    double maxY = 0;

    if (timeframe == 'Weekly') {
      labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      spots = [
        FlSpot(0, 200),
        FlSpot(1, 250),
        FlSpot(2, 300),
        FlSpot(3, 176),
        FlSpot(4, 400),
        FlSpot(5, 350),
        FlSpot(6, 450),
      ];
      maxY = 500;
    } else if (timeframe == 'Monthly') {
      labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      spots = [
        FlSpot(0, 1500),
        FlSpot(1, 1800),
        FlSpot(2, 2000),
        FlSpot(3, 1700),
        FlSpot(4, 2200),
        FlSpot(5, 2100),
        FlSpot(6, 2300),
        FlSpot(7, 2500),
        FlSpot(8, 2400),
        FlSpot(9, 2600),
        FlSpot(10, 2700),
        FlSpot(11, 2800),
      ];
      maxY = 3000;
    } else if (timeframe == 'Yearly') {
      labels = List.generate(currentYear - 2020 + 1, (index) => (2020 + index).toString());
      spots = List.generate(currentYear - 2020 + 1, (index) {
        return FlSpot(index.toDouble(), (15000 + (index * 1000)).toDouble());
      });
      maxY = 20000;
    }

    double yInterval = maxY / 5;

    return Column(
      children: [
        SizedBox(
          height: 240,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: spots.length.toDouble() - 1,
              minY: 0,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: yInterval,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: const Color(0xFFF0F0F0),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: yInterval,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '\$${value.toInt()}',
                        style: const TextStyle(
                          color: Color(0xFFCED4DA),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                    reservedSize: 40,
                  ),
                ),
                bottomTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    getTitlesWidget: (value, meta) {
      int index = value.toInt();
      if (index >= 0 && index < labels.length) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 4.0),
          child: Text(
            labels[index], 
            style: const TextStyle(
              color: Color(0xFFCED4DA),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    },
    reservedSize: 40, 
    interval: 1, 
  ),
),

                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: const Color(0xFFA280FF),
                  barWidth: 2,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 6,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: const Color(0xFFA280FF),
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFFA280FF).withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
