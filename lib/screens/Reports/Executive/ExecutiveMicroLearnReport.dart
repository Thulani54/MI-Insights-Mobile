import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../constants/Constants.dart';
import '../../../customwidgets/CustomCard.dart';

class ExecutiveMicroLearnReport extends StatefulWidget {
  const ExecutiveMicroLearnReport({Key? key}) : super(key: key);

  @override
  State<ExecutiveMicroLearnReport> createState() =>
      _ExecutiveMicroLearnReportState();
}

class _ExecutiveMicroLearnReportState extends State<ExecutiveMicroLearnReport>
    with SingleTickerProviderStateMixin {
  int selectedButton = 1;
  int selectedTab = 0;
  String selectedModule = 'All Modules';
  String selectedTeam = 'All Teams';
  bool isLoading = false;

  late TabController _tabController;
  MicroLearnData? microLearnData;

  final List<String> modules = [
    'All Modules',
    'Product Knowledge',
    'Sales Skills',
    'Compliance',
    'Customer Service',
    'Systems Training',
  ];

  final List<String> teams = [
    'All Teams',
    'Sales Team A',
    'Sales Team B',
    'Sales Team C',
    'Customer Service',
    'Operations',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMicroLearnData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMicroLearnData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final now = DateTime.now();
      String startDate, endDate;

      if (selectedButton == 1) {
        // 1 month view
        startDate =
            DateTime(now.year, now.month, 1).toIso8601String().split('T')[0];
        endDate = now.toIso8601String().split('T')[0];
      } else if (selectedButton == 2) {
        // 12 months view
        startDate = DateTime(now.year - 1, now.month, now.day)
            .toIso8601String()
            .split('T')[0];
        endDate = now.toIso8601String().split('T')[0];
      } else {
        // Custom date range - for now use last 30 days
        startDate =
            now.subtract(Duration(days: 30)).toIso8601String().split('T')[0];
        endDate = now.toIso8601String().split('T')[0];
      }

      // For now, use mock data directly
      // TODO: Integrate with actual API when ready
      microLearnData = _generateMockData();
    } catch (e) {
      print('Error loading microlearn data: $e');
      // Use mock data as fallback
      microLearnData = _generateMockData();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  MicroLearnData _generateMockData() {
    return MicroLearnData(
      totalParticipants: 1250,
      totalCompleted: 875,
      totalPassed: 750,
      averageScore: 78.5,
      passRate: 85.7,
      topPerformers: _generatePerformers(true),
      bottomPerformers: _generatePerformers(false),
    );
  }

  List<MicroLearnPerformer> _generatePerformers(bool isTop) {
    final names = [
      'John Smith',
      'Jane Doe',
      'Mike Johnson',
      'Sarah Williams',
      'Chris Brown',
      'Emma Wilson',
      'David Miller',
      'Lisa Anderson',
      'Tom Davis',
      'Mary Taylor',
      'James Moore',
      'Jennifer Martin'
    ];

    return List.generate(10, (index) {
      final score = isTop ? (95 - index * 2) : (45 + index * 3);
      return MicroLearnPerformer(
        name: names[index % names.length],
        score: score.toDouble(),
        attempts: Random().nextInt(3) + 1,
        passed: score >= 70,
        module: modules[Random().nextInt(modules.length - 1) + 1],
        team: teams[Random().nextInt(teams.length - 1) + 1],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Microlearning Results'),
        backgroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          _buildSummaryCards(),
          _buildPassRateBar(),
          _buildFilters(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildTopPerformersTab(),
                _buildBottomPerformersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDateButton('1 Mth View', 1),
          SizedBox(width: 16),
          _buildDateButton('12 Mths View', 2),
          SizedBox(width: 16),
          _buildDateButton('Select Dates', 3),
        ],
      ),
    );
  }

  Widget _buildDateButton(String text, int button) {
    final isSelected = selectedButton == button;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedButton = button;
        });
        _loadMicroLearnData();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Constants.ctaColorLight : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    if (isLoading) {
      return Container(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Participants',
              value: '${microLearnData?.totalParticipants ?? 0}',
              subtitle: 'Total enrolled',
              color: Colors.blue,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Completed',
              value: '${microLearnData?.totalCompleted ?? 0}',
              subtitle: 'Finished course',
              color: Colors.orange,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Average Score',
              value:
                  '${microLearnData?.averageScore?.toStringAsFixed(1) ?? 0}%',
              subtitle: 'Overall average',
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return CustomCard(
      elevation: 4,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassRateBar() {
    final passRate = microLearnData?.passRate ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomCard(
        elevation: 4,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Pass Rate',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              LinearPercentIndicator(
                animation: true,
                lineHeight: 24.0,
                animationDuration: 1000,
                percent: passRate / 100,
                center: Text(
                  "${passRate.toStringAsFixed(1)}%",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                barRadius: const Radius.circular(12),
                progressColor: Colors.green,
                backgroundColor: Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              label: 'Module',
              value: selectedModule,
              items: modules,
              onChanged: (value) {
                setState(() {
                  selectedModule = value!;
                });
                _loadMicroLearnData();
              },
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildDropdown(
              label: 'Team',
              value: selectedTeam,
              items: teams,
              onChanged: (value) {
                setState(() {
                  selectedTeam = value!;
                });
                _loadMicroLearnData();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.grey.shade100,
      child: TabBar(
        controller: _tabController,
        indicatorColor: Constants.ctaColorLight,
        labelColor: Constants.ctaColorLight,
        unselectedLabelColor: Colors.grey.shade600,
        tabs: [
          Tab(text: 'Overview'),
          Tab(text: 'Top Performers'),
          Tab(text: 'Bottom Performers'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildModulePerformanceCard(),
          SizedBox(height: 16),
          _buildTeamPerformanceCard(),
        ],
      ),
    );
  }

  Widget _buildModulePerformanceCard() {
    return CustomCard(
      elevation: 4,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Module Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...modules.skip(1).map((module) => _buildModuleRow(module)),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleRow(String module) {
    final score = 60 + Random().nextInt(40);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(module),
          ),
          Expanded(
            flex: 3,
            child: LinearPercentIndicator(
              animation: true,
              lineHeight: 20.0,
              animationDuration: 500,
              percent: score / 100,
              center: Text(
                "$score%",
                style: TextStyle(fontSize: 12),
              ),
              barRadius: const Radius.circular(10),
              progressColor: score >= 70 ? Colors.green : Colors.orange,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamPerformanceCard() {
    return CustomCard(
      elevation: 4,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...teams.skip(1).map((team) => _buildTeamRow(team)),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamRow(String team) {
    final participants = 50 + Random().nextInt(100);
    final passRate = 60 + Random().nextInt(40);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(team),
          ),
          Expanded(
            child: Text(
              '$participants',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: LinearPercentIndicator(
              animation: true,
              lineHeight: 16.0,
              animationDuration: 500,
              percent: passRate / 100,
              center: Text(
                "$passRate%",
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
              barRadius: const Radius.circular(8),
              progressColor: passRate >= 70 ? Colors.green : Colors.orange,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformersTab() {
    return PerformersListWidget(
      performers: microLearnData?.topPerformers ?? [],
      isTop: true,
      isLoading: isLoading,
    );
  }

  Widget _buildBottomPerformersTab() {
    return PerformersListWidget(
      performers: microLearnData?.bottomPerformers ?? [],
      isTop: false,
      isLoading: isLoading,
    );
  }
}

class PerformersListWidget extends StatelessWidget {
  final List<MicroLearnPerformer> performers;
  final bool isTop;
  final bool isLoading;

  const PerformersListWidget({
    Key? key,
    required this.performers,
    required this.isTop,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomCard(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 6,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.35),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isTop ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(360),
              ),
              child: Center(
                child: Text(
                  "#",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Text(
                "Agent Name",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              width: 60,
              child: Text(
                "Pass/Fail",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              width: 50,
              child: Text(
                "Score",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              width: 60,
              child: Text(
                "Attempts",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Constants.ctaColorLight,
        ),
      );
    }

    if (performers.isEmpty) {
      return Center(
        child: Text(
          "No data available",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 0),
      itemCount: performers.length,
      itemBuilder: (context, index) {
        return _buildPerformerItem(performers[index], index);
      },
    );
  }

  Widget _buildPerformerItem(MicroLearnPerformer performer, int index) {
    final displayIndex = isTop ? index + 1 : performers.length - index;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                width: 35,
                child: Text(
                  "$displayIndex",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  performer.name,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Container(
                width: 60,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: performer.passed
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      performer.passed ? "Pass" : "Fail",
                      style: TextStyle(
                        fontSize: 12,
                        color: performer.passed ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 50,
                child: Text(
                  "${performer.score.toInt()}%",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: performer.passed ? Colors.green : Colors.orange,
                  ),
                ),
              ),
              Container(
                width: 60,
                child: Text(
                  "${performer.attempts}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey.withOpacity(0.2),
        ),
      ],
    );
  }
}

// Service class for future API integration
class MicroLearnService {
  static Future<MicroLearnData?> fetchMicroLearnData({
    required String startDate,
    required String endDate,
    String? module,
    String? team,
  }) async {
    // TODO: Implement actual API call
    // For now, return null to use mock data
    return null;
  }
}

// Data Models
class MicroLearnData {
  final int totalParticipants;
  final int totalCompleted;
  final int totalPassed;
  final double averageScore;
  final double passRate;
  final List<MicroLearnPerformer> topPerformers;
  final List<MicroLearnPerformer> bottomPerformers;

  MicroLearnData({
    required this.totalParticipants,
    required this.totalCompleted,
    required this.totalPassed,
    required this.averageScore,
    required this.passRate,
    required this.topPerformers,
    required this.bottomPerformers,
  });
}

class MicroLearnPerformer {
  final String name;
  final double score;
  final int attempts;
  final bool passed;
  final String module;
  final String team;

  MicroLearnPerformer({
    required this.name,
    required this.score,
    required this.attempts,
    required this.passed,
    required this.module,
    required this.team,
  });
}
