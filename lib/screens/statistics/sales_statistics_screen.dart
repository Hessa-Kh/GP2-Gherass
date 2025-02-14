import 'package:flutter/material.dart';
import '../../widgets/statistics/sales_card.dart';
import '../../widgets/statistics/product_card.dart';
import '../../widgets/statistics/total_sales_card.dart';
import '../../widgets/statistics/sales_statistics_widget.dart'; 
import '../../widgets/statistics/all_products.dart'; 

class SalesStatisticsScreen extends StatelessWidget {
  const SalesStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SalesStatisticsWidget(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: const Text(
                      'إحصائيات المبيعات',
                      style: TextStyle(
                        color: Color.fromRGBO(16, 16, 16, 1),
                        fontSize: 20,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: const SalesCard(
                          amount: 42200,
                          percentageChange: 16,
                          isPositiveChange: true,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: const ProductsCard(
                          totalProducts: 125,
                          percentageChange: 10.5,
                          isPositiveChange: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: const TotalSalesCard(
                        percentageChange: 10.0,
                        timeframe: 'Weekly',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 450,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AllProducts(),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
