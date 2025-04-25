import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/inventory/controller/inventory_controller.dart';
import 'package:gherass/module/inventory/view/widgets/inventory_widgets.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';
import 'package:fl_chart/fl_chart.dart';

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
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;
  String selectedPeriod = 'Weekly'; // Default value

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  // Function to return chart data based on selected period
  LineChartData getChartData(InventoryController controller) {
    switch (selectedPeriod) {
      case 'Monthly':
        return _LineChart().sampleDataMonthly; // Monthly data
      case 'Yearly':
        return _LineChart().sampleDataYearly; // Yearly data
      default:
        return _LineChart().sampleDataWeekly(controller); // Weekly data
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<InventoryController>();
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 37),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      'Total Sales'.tr,
                      style: TextStyle(
                        color: AppTheme.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    // DropdownButton<String>(
                    //   value: selectedPeriod,
                    //   icon: const Icon(Icons.arrow_drop_down),
                    //   elevation: 16,
                    //   style: const TextStyle(color: Colors.black),
                    //   onChanged: (String? newValue) {
                    //     setState(() {
                    //       selectedPeriod = newValue!;
                    //     });
                    //   },
                    //   items:
                    //       <String>[
                    //         'Weekly',
                    //         'Monthly',
                    //         'Yearly',
                    //       ].map<DropdownMenuItem<String>>((String value) {
                    //         return DropdownMenuItem<String>(
                    //           value: value,
                    //           child: Text(value),
                    //         );
                    //       }).toList(),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                     Text(
                "${controller.totalSaleAmount.value.toString()} ${"SAR".tr}",
                      style: TextStyle(
                        color: AppTheme.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    // Container(
                    //   height: 30,
                    //   width: 80,
                    //   margin: EdgeInsets.all(10),
                    //   decoration: BoxDecoration(
                    //     color: Colors.orange[100],
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
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
              const SizedBox(height: 37),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: LineChart(
                    getChartData(controller), // Use the dynamic data based on selected period
                    duration: const Duration(milliseconds: 250),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart();

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<InventoryController>();
    return LineChart(
      sampleDataWeekly(controller), // Default to weekly data
      duration: const Duration(milliseconds: 250),
    );
  }

  // Weekly data (7 days)
  LineChartData  sampleDataWeekly (InventoryController controller){
    return  LineChartData(
      lineTouchData: lineTouchData1,
      gridData: gridData,
      titlesData: titlesDataWeekly,
      borderData: borderData,
      lineBarsData: lineBarsDataWeekly(controller),
      minX: 0,
      maxX: 7, // 7 days
      maxY: 2500,
      minY: 0,
    );
  }

  // Monthly data (12 months)
  LineChartData get sampleDataMonthly => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesDataMonthly,
    borderData: borderData,
    lineBarsData: lineBarsDataMonthly,
    minX: 0,
    maxX: 12, // 12 months
    maxY: 2000,
    minY: 0,
  );

  // Yearly data (8 years)
  LineChartData get sampleDataYearly => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesDataYearly,
    borderData: borderData,
    lineBarsData: lineBarsDataYearly,
    minX: 0,
    maxX: 5, // 8 years
    maxY: 2500,
    minY: 0,
  );

  // Line data for weekly chart
  List<LineChartBarData>  lineBarsDataWeekly(InventoryController controller){
    return [lineChartBarDataWeekly(controller)];
  }

  // Line data for monthly chart
  List<LineChartBarData> get lineBarsDataMonthly => [lineChartBarDataMonthly];

  // Line data for yearly chart
  List<LineChartBarData> get lineBarsDataYearly => [lineChartBarDataYearly];

  // Line data for weekly chart
  LineChartBarData  lineChartBarDataWeekly(InventoryController controller) {
    return LineChartBarData(
    isCurved: true,
    color: Colors.deepPurple.shade400,
    barWidth: 2.0,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.deepPurple.shade300, Colors.white],
      ),
    ),
    spots:  [
      FlSpot(0, 0),
      FlSpot(1, controller.totalSaleAmount.value/7),
      FlSpot(2, controller.totalSaleAmount.value/6),
      FlSpot(3, controller.totalSaleAmount.value/5),
      FlSpot(4, controller.totalSaleAmount.value/4),
      FlSpot(5, controller.totalSaleAmount.value/3),
      FlSpot(6, controller.totalSaleAmount.value/2),
      FlSpot(7, controller.totalSaleAmount.value/1),
    ],
  );}

  // Line data for monthly chart
  LineChartBarData get lineChartBarDataMonthly => LineChartBarData(
    isCurved: true,
    color: Colors.deepPurple.shade400,
    barWidth: 2.0,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.deepPurple.shade300, Colors.white],
      ),
    ),
    spots: const [
      FlSpot(0, 500),
      FlSpot(1, 1200),
      FlSpot(2, 1300),
      FlSpot(3, 500),
      FlSpot(4, 2000),
      FlSpot(5, 1500),
      FlSpot(6, 300),
      FlSpot(7, 1200),
      FlSpot(8, 800),
      FlSpot(9, 500),
      FlSpot(10, 1800),
      FlSpot(11, 1500),
      FlSpot(12, 1700),
    ],
  );

  // Line data for yearly chart
  LineChartBarData get lineChartBarDataYearly => LineChartBarData(
    isCurved: true,
    color: Colors.deepPurple.shade400,
    barWidth: 2.0,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.deepPurple.shade300, Colors.white],
      ),
    ),
    spots: const [
      FlSpot(0, 500),
      FlSpot(1, 1600),
      FlSpot(2, 700),
      FlSpot(3, 800),
      FlSpot(4, 1850),
      FlSpot(5, 900),
    ],
  );

  // Titles for weekly x-axis (week numbers)
  SideTitles get bottomTitlesWeekly => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: (double value, TitleMeta meta) {
      const style = TextStyle(fontSize: 14, color: AppTheme.hintDarkGray);
      switch (value.toInt()) {
        case 0:
          return const Text('');
        case 1:
          return const Text('Sun', style: style);
        case 2:
          return const Text('Mon', style: style);
        case 3:
          return const Text('Tues', style: style);
        case 4:
          return const Text('Wed', style: style);
        case 5:
          return const Text('Thu', style: style);
        case 6:
          return const Text('Fri', style: style);
        case 7:
          return const Text('Sat', style: style);
        default:
          return const Text('');
      }
    },
  );

  // Titles for monthly x-axis
  SideTitles get bottomTitlesMonthly => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: (double value, TitleMeta meta) {
      const style = TextStyle(fontSize: 14, color: AppTheme.hintDarkGray);
      switch (value.toInt()) {
        case 0:
          return const Text('');
        case 1:
          return const Text('Jan', style: style);
        case 2:
          return const Text('Feb', style: style);
        case 3:
          return const Text('Mar', style: style);
        case 4:
          return const Text('Apr', style: style);
        case 5:
          return const Text('May', style: style);
        case 6:
          return const Text('Jun', style: style);
        case 7:
          return const Text('Jul', style: style);
        case 8:
          return const Text('Aug', style: style);
        case 9:
          return const Text('Sep', style: style);
        case 10:
          return const Text('Oct', style: style);
        case 11:
          return const Text('Nov', style: style);
        case 12:
          return const Text('Dec', style: style);
        default:
          return const Text('');
      }
    },
  );

  // Titles for yearly x-axis
  SideTitles get bottomTitlesYearly => SideTitles(
    showTitles: true,
    interval: 1,
    reservedSize: 50,
    getTitlesWidget: (double value, TitleMeta meta) {
      const style = TextStyle(fontSize: 14, color: AppTheme.hintDarkGray);
      switch (value.toInt()) {
        case 1:
          return const Text('2021', style: style);
        case 2:
          return const Text('2022', style: style);
        case 3:
          return const Text('2023', style: style);
        case 4:
          return const Text('2025', style: style);
        case 5:
          return const Text('2024', style: style);
        default:
          return const Text('');
      }
    },
  );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(color: AppTheme.hintDarkGray, width: 1),
      left: const BorderSide(color: AppTheme.hintDarkGray, width: 1),
      right: const BorderSide(color: Colors.transparent),
      top: const BorderSide(color: Colors.transparent),
    ),
  );

  // Line touch data configuration
  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) => Colors.black.withOpacity(0.8),
      tooltipRoundedRadius: 10.0,
    ),
  );

  // Titles data for Weekly
  FlTitlesData get titlesDataWeekly => FlTitlesData(
    bottomTitles: AxisTitles(sideTitles: bottomTitlesWeekly),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
      drawBelowEverything: false,
    ),
  );

  // Titles data for Monthly
  FlTitlesData get titlesDataMonthly => FlTitlesData(
    bottomTitles: AxisTitles(sideTitles: bottomTitlesMonthly),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
      drawBelowEverything: false,
    ),
  );

  // Titles data for Yearly
  FlTitlesData get titlesDataYearly => FlTitlesData(
    bottomTitles: AxisTitles(sideTitles: bottomTitlesYearly),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
      drawBelowEverything: false,
    ),
  );

  // Custom Y-axis titles (Profit in SAR)
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 14, color: AppTheme.hintDarkGray);
    String text;
    if (value == 0) {
      text = '\$0';
    } else if (value == 500) {
      text = '5,00';
    } else if (value == 1000) {
      text = '1,000';
    } else if (value == 1500) {
      text = '1,500';
    } else if (value == 2000) {
      text = '2,000';
    } else if (value == 2500) {
      text = '2,500';
    } else {
      return Container();
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 500,
    reservedSize: 50,
  );
}
