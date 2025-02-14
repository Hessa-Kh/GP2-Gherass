import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FarmerReviewsPage extends StatelessWidget {
  const FarmerReviewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تقييم المزرعة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white, // AppBar background white
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous screen
          },
        ),
      ),
      backgroundColor: Colors.white, // Entire Scaffold background white
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('farmers').doc('farmerId').snapshots(),
        builder: (context, snapshot) {
          // Default values
          String farmLogo = 'https://via.placeholder.com/150';
          String farmName = 'اسم المزرعة';
          double rating = 0.0;
          int totalReviews = 0;
          Map<String, int> ratingDistribution = {
            '5': 0,
            '4': 0,
            '3': 0,
            '2': 0,
            '1': 0,
          };
          List reviews = [];

          if (snapshot.hasData && snapshot.data != null) {
            var farmerData = snapshot.data!;
            farmLogo = farmerData['farm_profile_image'] ?? farmLogo;
            farmName = farmerData['farm_name'] ?? farmName;
            rating = farmerData['rating']?.toDouble() ?? rating;
            reviews = farmerData['reviews'] ?? [];
            totalReviews = reviews.length;
            ratingDistribution = {
              '5': farmerData['5_stars'] ?? 0,
              '4': farmerData['4_stars'] ?? 0,
              '3': farmerData['3_stars'] ?? 0,
              '2': farmerData['2_stars'] ?? 0,
              '1': farmerData['1_star'] ?? 0,
            };
          }

          return Container(
            color: Colors.white, // Main Container background white
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Farm profile section
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(farmLogo),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            farmName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Rating overview card
                    Card(
                      color: Colors.white, // White background for card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'تقييم العملاء',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                RatingBarIndicator(
                                  rating: rating,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 28.0,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '$totalReviews تقييم',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 10),

                            // Rating distribution
                            ...ratingDistribution.entries.map((entry) {
                              double percentage = totalReviews > 0
                                  ? (entry.value / totalReviews) * 100
                                  : 0.0;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Text('${entry.key} نجوم', style: const TextStyle(fontSize: 16)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: percentage / 100,
                                        color: Colors.amber,
                                        backgroundColor: Colors.grey.shade300,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('${percentage.toStringAsFixed(0)}%'),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Reviews list
                    if (reviews.isNotEmpty)
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.white, // White background for review cards
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.account_circle,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            reviews[index]['reviewer'] ?? 'مجهول',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          RatingBarIndicator(
                                            rating: (reviews[index]['rating']?.toDouble() ?? 0.0),
                                            itemBuilder: (context, index) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 16.0,
                                            direction: Axis.horizontal,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    reviews[index]['comment'] ?? 'لا يوجد تعليق',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    else
                      const Center(
                        child: Text('لا توجد تقييمات حالياً'),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
