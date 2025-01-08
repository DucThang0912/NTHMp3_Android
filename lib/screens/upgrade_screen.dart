import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PlanFeature {
  final String title;
  final bool isIncluded;
  PlanFeature(this.title, this.isIncluded);
}

class SubscriptionPlan {
  final String name;
  final String price;
  final String duration;
  final Color color;
  final List<PlanFeature> features;
  final bool isPopular;

  SubscriptionPlan({
    required this.name,
    required this.price,
    required this.duration,
    required this.color,
    required this.features,
    this.isPopular = false,
  });
}

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      SubscriptionPlan(
        name: 'Cơ bản',
        price: '29.000',
        duration: 'tháng',
        color: Colors.blue,
        features: [
          PlanFeature('Không quảng cáo', true),
          PlanFeature('Chất lượng âm thanh cao', true),
          PlanFeature('Nghe offline', false),
          PlanFeature('Chia sẻ với gia đình', false),
        ],
      ),
      SubscriptionPlan(
        name: 'Premium',
        price: '59.000',
        duration: 'tháng',
        color: Colors.purple,
        features: [
          PlanFeature('Không quảng cáo', true),
          PlanFeature('Chất lượng âm thanh cao', true),
          PlanFeature('Nghe offline', true),
          PlanFeature('Chia sẻ với gia đình', false),
        ],
        isPopular: true,
      ),
      SubscriptionPlan(
        name: 'Gia đình',
        price: '99.000',
        duration: 'tháng',
        color: Colors.green,
        features: [
          PlanFeature('Không quảng cáo', true),
          PlanFeature('Chất lượng âm thanh cao', true),
          PlanFeature('Nghe offline', true),
          PlanFeature('Chia sẻ với gia đình', true),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Nâng cấp tài khoản',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Chọn gói phù hợp với bạn',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Trải nghiệm âm nhạc không giới hạn',
              style: GoogleFonts.montserrat(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return _buildPlanCard(context, plan);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, SubscriptionPlan plan) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            plan.color.withOpacity(0.2),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: plan.color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          if (plan.isPopular)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: plan.color,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Phổ biến',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.name,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      plan.price,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' VNĐ/${plan.duration}',
                      style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...plan.features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(
                            feature.isIncluded
                                ? Icons.check_circle
                                : Icons.remove_circle,
                            color: feature.isIncluded
                                ? plan.color
                                : Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            feature.title,
                            style: GoogleFonts.montserrat(
                              color: feature.isIncluded
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement upgrade logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: plan.color,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Chọn gói này',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}