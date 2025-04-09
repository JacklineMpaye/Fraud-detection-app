import 'package:flutter/material.dart';
import 'package:fraud_dashboard/const.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171821),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 800;
          
          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: isSmallScreen ? 120 : 80,
                floating: true,
                pinned: true,
                backgroundColor: Color(primaryColorCode),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: isSmallScreen 
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FraudSense',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildNavButton('Home', context),
                                _buildNavButton('How it works', context),
                                _buildNavButton('About us', context),
                                _buildPrimaryButton('Get Started', context),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Text(
                            'FraudSense',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          _buildNavButton('Home', context),
                          _buildNavButton('How it works', context),
                          _buildNavButton('About us', context),
                          _buildPrimaryButton('Get Started', context),
                        ],
                      ),
                ),
              ),

              // Hero Section with Flutter Graphic
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 20 : 40,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      _buildCustomHeroGraphic(),
                      const SizedBox(height: 40),
                      Text(
                        'Build a fortress of trust around your financial transactions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 28 : 36,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'AI-driven fraud detection, ensuring integrity and building customer confidence',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: isSmallScreen ? 16 : 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      _buildPrimaryButton('Get Started', context, isLarge: true),
                    ],
                  ),
                ),
              ),

              // Features Section
              SliverPadding(
                padding: EdgeInsets.all(isSmallScreen ? 20 : 40),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isSmallScreen ? 1 : 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: isSmallScreen ? 1.8 : 1.5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildFeatureCard(context, index),
                    childCount: 3,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCustomHeroGraphic() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF252732),
            Color(primaryColorCode).withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(primaryColorCode).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background elements
          Positioned(
            right: 20,
            top: 20,
            child: Icon(
              Icons.lock_outline,
              size: 60,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          Positioned(
            left: 30,
            bottom: 40,
            child: Icon(
              Icons.account_balance,
              size: 50,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(primaryColorCode).withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(primaryColorCode),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.verified_user,
                    size: 60,
                    color: Color(primaryColorCode),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'FraudSense',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, BuildContext context, {bool isLarge = false}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(primaryColorCode),
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 32 : 16,
          vertical: isLarge ? 16 : 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: isLarge ? 18 : 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, int index) {
    final features = [
      {
        'title': 'Real-time Monitoring',
        'description': '24/7 transaction surveillance',
        'icon': Icons.monitor_heart_outlined,
      },
      {
        'title': 'AI Detection',
        'description': 'Machine learning powered analysis',
        'icon': Icons.psychology_outlined,
      },
      {
        'title': 'Instant Alerts',
        'description': 'Get notified of suspicious activity',
        'icon': Icons.notifications_active_outlined,
      },
    ];

    return Card(
      color: const Color(0xFF252732),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              features[index]['icon'] as IconData,
              color: Color(primaryColorCode),
              size: 40,
            ),
            const SizedBox(height: 20),
            Text(
              features[index]['title'] as String,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              features[index]['description'] as String,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}