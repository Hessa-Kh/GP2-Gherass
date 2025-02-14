import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sales_chart.dart';

class TotalSalesCard extends StatefulWidget {
  final double percentageChange;
  final String timeframe;

  const TotalSalesCard({
    super.key,
    required this.percentageChange,
    this.timeframe = 'Weekly', 
  });

  @override
  _TotalSalesCardState createState() => _TotalSalesCardState();
}

class _TotalSalesCardState extends State<TotalSalesCard> {
  String selectedTimeframe = 'Weekly'; 
  final List<String> timeframes = ['Weekly', 'Monthly', 'Yearly'];
  

  double getTotalSales(String timeframe) {
    switch (timeframe) {
      case 'Weekly':
        return 150000; 
      case 'Monthly':
        return 600000; 
      case 'Yearly':
        return 7200000; 
      default:
        return 150000; 
    }
  }

  void _showTimeframeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: timeframes.map((String value) {
              return ListTile(
                title: Text(value),
                onTap: () {
                  setState(() {
                    selectedTimeframe = value;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalSales = getTotalSales(selectedTimeframe); 

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 5), 
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إجمالي المبيعات',
                    style: TextStyle(
                      color: Color(0xFF8C8C8C),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.15,
                    ),
                  ),
                  SizedBox(height: 8), 
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          NumberFormat.currency(symbol: '', decimalDigits: 0).format(totalSales), 
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF212529),
                            fontFamily: 'Inter',
                            letterSpacing: -0.4,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(width: 4), 
                        Text(
                          'SAR',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF212529),
                            fontFamily: 'Inter',
                            letterSpacing: -0.4,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEA),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${widget.percentageChange.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Color(0xFFFFB91B),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.10,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_downward,
                          size: 16,
                          color: Color(0xFFFFB91B),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _showTimeframeSelector(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE8E8E8)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        selectedTimeframe,
                        style: const TextStyle(
                          color: Color(0xFF8C8C8C),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.13,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Color(0xFF8C8C8C),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SalesChart(timeframe: selectedTimeframe),
        ],
      ),
    );
  }
}
