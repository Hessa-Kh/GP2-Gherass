import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/inventory/controller/inventory_controller.dart';
import 'package:gherass/module/inventory/view/widgets/inventory_widgets.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../util/image_util.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/svg_icon_widget.dart';

class Staticstics extends StatelessWidget {
  const Staticstics({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<InventoryController>();
    return Obx(
      () => Container(
        // Apply gradient to the body
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade100, // Lighter violet towards the center
              Colors.white, // White at the bottom
            ],
          ),
        ),

        child: RefreshIndicator(
          onRefresh: () async{
             controller.onInit();
          },
          child: Scaffold(
            // Add gradient to the background
            backgroundColor:
                Colors.transparent, // Transparent so the gradient is visible
            appBar: CommonAppBar(title: "Statistics".tr),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // First Container
                        Expanded(
                          child: Container(
                            height: 120,
                            width: 200,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFECE4D7),
                                  offset: Offset(0, 4),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgIcon(ImageUtil.filled_bag, size: 24,color: AppTheme.lightPurple,),
                                          SizedBox(width: 5,),
                                          Text(
                                            "Total Products".tr,
                                            style: TextStyle(
                                              color: AppTheme.hintDarkGray,
                                              // fontSize: 12,
                                              fontSize: 12,

                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Container(
                                      //   margin: EdgeInsets.all(10),
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.orange[100],
                                      //     borderRadius: BorderRadius.all(
                                      //       Radius.circular(10),
                                      //     ),
                                      //     boxShadow: [
                                      //       BoxShadow(
                                      //         color: Color(0xFFECE4D7),
                                      //         offset: Offset(0, 4),
                                      //         blurRadius: 10.0,
                                      //         spreadRadius: 2.0,
                                      //       ),
                                      //     ],
                                      //   ),
                                      //   child: Center(
                                      //     child: Text(
                                      //       '16% @',
                                      //       style: TextStyle(
                                      //         color: Colors.orange[800],
                                      //         fontSize: 14,
                                      //         fontWeight: FontWeight.bold,
                                      //       ),
                                      //       textAlign: TextAlign.left,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Center(child: Text(controller.farmerProducts.length.toString()??"",style: Styles.boldTextView(20, AppTheme.black),)),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),

                        // Second Container
                        Expanded(
                          child: Container(
                            height: 120,
                            width: 200,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFECE4D7),
                                  offset: Offset(0, 4),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgIcon(ImageUtil.wallet, size: 24,color: AppTheme.lightPurple,),
                                          SizedBox(width: 5),
                                          Text(
                                            "Total Sales".tr,
                                            style: TextStyle(
                                              color: AppTheme.hintDarkGray,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Container(
                                      //   margin: EdgeInsets.all(10),
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.orange[100],
                                      //     borderRadius: BorderRadius.all(
                                      //       Radius.circular(10),
                                      //     ),
                                      //     boxShadow: [
                                      //       BoxShadow(
                                      //         color: Color(0xFFECE4D7),
                                      //         offset: Offset(0, 4),
                                      //         blurRadius: 10.0,
                                      //         spreadRadius: 2.0,
                                      //       ),
                                      //     ],
                                      //   ),
                                      //   child: Center(
                                      //     child: Text(
                                      //       '16% @',
                                      //       style: TextStyle(
                                      //         color: Colors.orange[800],
                                      //         fontSize: 14,
                                      //         fontWeight: FontWeight.bold,
                                      //       ),
                                      //       textAlign: TextAlign.left,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Center(child: Text("${controller.totalSaleAmount.value.toString()} ${"SAR".tr}",
                                    style: Styles.boldTextView(20, AppTheme.black))),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 500,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFECE4D7),
                          offset: Offset(0, 4),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: LineChartSample1(),
                  ),
                  InventoryWidget().statisticProdListWidget(),
                ],
              ),
            ), // Your widget for the body,
          ),
        ),
      ),
    );
  }
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({Key? key}) : super(key: key);

  @override
  State<LineChartSample1> createState() => _LineChartSample1State();
}

class _LineChartSample1State extends State<LineChartSample1> {
  String selectedPeriod = 'Last 7 Days'; // Default selection changed from 'Weekly'

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<InventoryController>();

    return AspectRatio(
      aspectRatio: 1.4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Header (Total Sales + Dropdown)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Sales'.tr,
                  style: TextStyle(
                    color: AppTheme.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedPeriod,
                  underline: SizedBox(),
                  items: ['Last 7 Days', 'Monthly', 'Yearly'].map((period) {
                    return DropdownMenuItem(
                      value: period,
                      child: Text(period),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPeriod = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Chart Area
            Expanded(
              child: LineChart(_buildChart(controller)),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildChart(InventoryController controller) {
    List<FlSpot> spots = [];
    double maxX = 6;
    double maxY = 1000; // Default value for max Y

    // Adjusting spots and X, Y limits based on selected period
    if (selectedPeriod == 'Last 7 Days') {
      spots = List.generate(7, (index) {
        // Calculate the date for the last 7 days (including today)
        DateTime date = DateTime.now().subtract(Duration(days: 6 - index));
        double dailySales = controller.getSaleForDay(date);  // Use DateTime here instead of dayName
        return FlSpot(index.toDouble(), dailySales); // Generate a spot for the sale of that day
      });
      maxX = 6; // X axis should show 7 days (0 to 6)
    } 
    else if (selectedPeriod == 'Monthly') {
      spots = List.generate(12, (index) {
        return FlSpot(index.toDouble(), controller.getSaleForMonth(index));
      });
      maxX = 11;
    } else if (selectedPeriod == 'Yearly') {
      int startYear = 2020;
      int currentYear = DateTime.now().year;
      spots = List.generate(currentYear - startYear + 1, (index) {
        return FlSpot(index.toDouble(), controller.getSaleForYear(startYear + index));
      });
      maxX = (currentYear - startYear).toDouble();
    }

    // Calculate the maxY dynamically based on the data points
    maxY = _calculateMaxY(spots);

    return LineChartData(
      minX: 0,
      maxX: maxX,
      minY: 0,
      maxY: maxY,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) => Colors.black.withOpacity(0.8),
          tooltipRoundedRadius: 8,
        ),
      ),
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: _bottomTitles()),
        leftTitles: AxisTitles(sideTitles: _leftTitles()),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: AppTheme.hintDarkGray),
          left: BorderSide(color: AppTheme.hintDarkGray),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.deepPurple.shade400,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.deepPurple.shade200.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  // Helper method to get day string from index
  String _getDayFromIndex(int index) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[index];
  }

  // Calculate max Y value for scaling
  double _calculateMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 1000;
    double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    
    // We ensure the maximum Y value is a bit higher than the largest value
    return maxY == 0 ? 1000 : (maxY * 1.2).ceilToDouble(); // Add 20% margin
  }

  // General bottom titles for last 7 days, monthly, yearly
  SideTitles _bottomTitles() {
    if (selectedPeriod == 'Last 7 Days') {
      return _bottomTitlesLast7Days();
    } else if (selectedPeriod == 'Monthly') {
      return _bottomTitlesMonthly();
    } else {
      return _bottomTitlesYearly(2020);
    }
  }

  // Last 7 Days bottom titles
  SideTitles _bottomTitlesLast7Days() => SideTitles(
    showTitles: true,
    interval: 1,
    getTitlesWidget: (value, meta) {
      // Generate date labels for the last 7 days, including today
      DateTime date = DateTime.now().subtract(Duration(days: 6 - value.toInt())); // Last 7 days
      String dateString = DateFormat('d MMM').format(date); // Format date as "day month"
      return Text(dateString, style: const TextStyle(fontSize: 12));
    },
    reservedSize: 32,
  );

  // Monthly bottom titles
  SideTitles _bottomTitlesMonthly() => SideTitles(
    showTitles: true,
    interval: 1,
    getTitlesWidget: (value, meta) {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      if (value.toInt() >= 0 && value.toInt() < months.length) {
        return Text(months[value.toInt()], style: const TextStyle(fontSize: 12));
      }
      return const SizedBox.shrink();
    },
    reservedSize: 32,
  );

  // Yearly bottom titles
  SideTitles _bottomTitlesYearly(int startYear) => SideTitles(
    showTitles: true,
    interval: 1,
    getTitlesWidget: (value, meta) {
      int year = startYear + value.toInt();
      return Text(year.toString(), style: const TextStyle(fontSize: 12));
    },
    reservedSize: 50,
  );

  // Left titles (Y axis labels)
  SideTitles _leftTitles() => SideTitles(
    showTitles: true,
    interval: 500,
    getTitlesWidget: (value, meta) {
      if (value % 500 == 0) {
        return Text('\$${value.toInt()}', style: const TextStyle(fontSize: 12));
      }
      return const SizedBox.shrink();
    },
    reservedSize: 40,
  );
}
