import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../HomePage.dart';
import '../../constants/Constants.dart';

import '../Testing/LeadInformationPage.dart';

class OnboardingWelcomePage extends StatefulWidget {
  const OnboardingWelcomePage({Key? key}) : super(key: key);

  @override
  _OnboardingWelcomePageState createState() => _OnboardingWelcomePageState();
}

class _OnboardingWelcomePageState extends State<OnboardingWelcomePage> {
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkIfCompleted();
  }

  Future<void> _checkIfCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool completed = false;
    //bool completed = prefs.getBool('test_welcome_completed') ?? false;

    if (completed) {
      // If already completed, go to homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else {
      setState(() {
        _isCompleted = false;
      });
    }
  }

  Future<void> _markCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('test_welcome_completed', true);
  }

  Future<void> _navigateToProductSelection() async {
    // Show product selection modal
    await _showProductSelectionModal();
  }

  Future<void> _showProductSelectionModal() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProductSelectionModal(),
    );
  }

  Widget _buildProductSelectionModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Choose Your Product',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Select a product to explore its modules',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Product List
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildProductCard(
                  'MI Insights',
                  'Comprehensive analytics and reporting platform',
                  [
                    'Sales',
                    'Collections',
                    'Marketing',
                    'Claims',
                    'Maintenance'
                  ],
                  'assets/mi_logo_new.png',
                  Colors.blue,
                ),
                SizedBox(height: 16),
                _buildProductCard(
                  'Micro Distribution',
                  'Distribution management and compliance platform',
                  ['FAIS', 'Compliance', 'Distribution Management'],
                  'assets/mi_logo_new.png',
                  Colors.green,
                ),
                SizedBox(height: 16),
                _buildProductCard(
                  'MI Analytics',
                  'Advanced data analytics and business intelligence',
                  [
                    'Business Intelligence',
                    'Data Visualization',
                    'Predictive Analytics'
                  ],
                  'assets/mi_logo_new.png',
                  Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String description,
      List<String> modules, String imagePath, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          _showModuleSelection(title, modules, color);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.apps,
                      color: color,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: color,
                    size: 20,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Modules:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: modules
                    .map((module) => Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            module,
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showModuleSelection(
      String productName, List<String> modules, Color color) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$productName Modules'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: modules
              .map((module) => ListTile(
                    leading: Icon(Icons.check_circle_outline, color: color),
                    title: Text(module),
                    onTap: () {
                      Navigator.pop(context);
                      _proceedToLeadCapture(productName, module);
                    },
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _proceedToLeadCapture(String product, String module) async {
    await _markCompleted();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LeadInformationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      height: 120,
                      child: Image.asset(
                        "assets/logos/MI AnalytiX 2 Tone.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Welcome Text
                    Text(
                      'Welcome to MI Analytix Demo',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),

                    Text(
                      'Experience the power of our analytics platform with our interactive demo',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),

                    // Features List
                    _buildFeatureItem(Icons.analytics, 'Real-time Analytics'),
                    SizedBox(height: 16),
                    _buildFeatureItem(
                        Icons.dashboard, 'Interactive Dashboards'),
                    // SizedBox(height: 16),
                    // _buildFeatureItem(Icons.insights, 'Business Insights'),
                    //SizedBox(height: 16),
                    // _buildFeatureItem(Icons.trending_up, 'Performance Tracking'),
                  ],
                ),
              ),

              // Join Now Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Constants.ctaColorLight!,
                      Constants.ctaColorLight!.withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Constants.ctaColorLight!.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.rocket_launch,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Ready to get started?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Explore our products and unlock powerful insights for your business',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _navigateToProductSelection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Constants.ctaColorLight,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Join Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Skip Demo Button
              TextButton(
                onPressed: () async {
                  await _markCompleted();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                child: Text(
                  'Skip to Demo',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Constants.ctaColorLight!.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Constants.ctaColorLight,
            size: 20,
          ),
        ),
        SizedBox(width: 16),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
