import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants/Constants.dart';
import '../models/CustomerProfile.dart';
import '../screens/Reports/Executive/CustomersReport.dart';

class SalesBellCurveChart extends StatelessWidget {
  final int selectedButton;
  final int daysDifference;
  final int customersIndex;
  final int targetIndex7;

  SalesBellCurveChart({
    Key? key,
    required this.customersIndex,
    required this.selectedButton,
    required this.daysDifference,
    required this.targetIndex7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get customer profile from Constants
    final CustomerProfile customerProfile = Constants.currentCustomerProfile;

    if (customerProfile == null) {
      return Container(
        height: 320,
        child: Center(
          child: Text(
            "No customer data available",
            style: TextStyle(color: Colors.grey.withOpacity(0.55)),
          ),
        ),
      );
    }

    // Extract data from CustomerProfile
    final ageDistributionData = _getAgeDistributionData(customerProfile);
    final ageDistributionLists = _getAgeDistributionLists(customerProfile);

    if (ageDistributionData.isEmpty) {
      return Container(
        height: 320,
        child: Center(
          child: Text(
            "No data available for the selected range",
            style: TextStyle(color: Colors.grey.withOpacity(0.55)),
          ),
        ),
      );
    }

    // Generate spots for line chart
    flypes? spots =
        generateSkewedSpots(ageDistributionLists["main_member"] ?? []);
    flypes? spots2 = generateSkewedSpots(ageDistributionLists["partner"] ?? []);
    flypes? spots3 = generateSkewedSpots(ageDistributionLists["child"] ?? []);
    flypes? spots4 =
        generateSkewedSpots(ageDistributionLists["extended_family"] ?? []);

    // Generate bar chart data
    List<BarChartGroupData> barGroups =
        _generateBarGroups(ageDistributionData, context);

    // Generate line chart data
    List<LineChartBarData> lines =
        _generateLineChartData(spots, spots2, spots3, spots4);

    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Column(
        children: [
          if (targetIndex7 == 0)
            _buildLineChart(lines, spots, spots2, spots3, spots4),
          if (targetIndex7 == 1) _buildBarChart(barGroups),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: MemberTypeGrid(),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getAgeDistributionData(
      CustomerProfile customerProfile) {
    // Get age distribution by gender and type based on selected button and customers index
    // This replaces the complex Constants access logic

    if (customersIndex == 0) {
      // Total data - use original age distribution
      return customerProfile.genderDistribution.ageGroups
          .map((ageRange, ageGenderData) {
        return MapEntry(ageRange, {
          'main_member': {
            'male': _getMainMemberMaleForAge(customerProfile, ageRange),
            'female': _getMainMemberFemaleForAge(customerProfile, ageRange),
          },
          'partner': {
            'male': _getPartnerMaleForAge(customerProfile, ageRange),
            'female': _getPartnerFemaleForAge(customerProfile, ageRange),
          },
          'child': {
            'male': _getChildMaleForAge(customerProfile, ageRange),
            'female': _getChildFemaleForAge(customerProfile, ageRange),
          },
        });
      });
    } else if (customersIndex == 1) {
      // Enforced policies data
      return _getEnforcedAgeDistribution(customerProfile);
    } else {
      // Not enforced policies data
      return _getNotEnforcedAgeDistribution(customerProfile);
    }
  }

  Map<String, List<dynamic>> _getAgeDistributionLists(
      CustomerProfile customerProfile) {
    // Extract age distribution lists from CustomerProfile
    // This would need to be added to your CustomerProfile model
    // For now, calculating from existing data

    return {
      "main_member": _calculateMainMemberAges(customerProfile),
      "partner": _calculatePartnerAges(customerProfile),
      "child": _calculateChildAges(customerProfile),
      "extended_family": _calculateExtendedFamilyAges(customerProfile),
    };
  }

  List<dynamic> _calculateMainMemberAges(CustomerProfile customerProfile) {
    List<int> ages = [];
    customerProfile.mainMemberAges.forEach((ageRange, memberGroup) {
      int middleAge = _getMiddleAge(ageRange);
      for (int i = 0; i < memberGroup.mainMember; i++) {
        ages.add(middleAge);
      }
    });
    return ages;
  }

  List<dynamic> _calculatePartnerAges(CustomerProfile customerProfile) {
    List<int> ages = [];
    customerProfile.mainMemberAges.forEach((ageRange, memberGroup) {
      int middleAge = _getMiddleAge(ageRange);
      for (int i = 0; i < memberGroup.partner; i++) {
        ages.add(middleAge);
      }
    });
    return ages;
  }

  List<dynamic> _calculateChildAges(CustomerProfile customerProfile) {
    List<int> ages = [];
    customerProfile.mainMemberAges.forEach((ageRange, memberGroup) {
      int middleAge = _getMiddleAge(ageRange);
      for (int i = 0; i < memberGroup.child; i++) {
        ages.add(middleAge);
      }
    });
    return ages;
  }

  List<dynamic> _calculateExtendedFamilyAges(CustomerProfile customerProfile) {
    // Extended family logic - implement based on your data structure
    return [];
  }

  int _getMiddleAge(String ageRange) {
    List<String> rangeParts = ageRange.split('-');
    if (rangeParts.length == 2) {
      int startAge = int.tryParse(rangeParts[0]) ?? 0;
      int endAge = int.tryParse(rangeParts[1]) ?? 0;
      return ((startAge + endAge) / 2).round();
    }
    return 25; // Default fallback
  }

  int _getMainMemberMaleForAge(
      CustomerProfile customerProfile, String ageRange) {
    // Extract main member male count for specific age range
    // This would come from your age_distribution_by_gender_and_type data
    // For now, calculating from existing data
    final memberGroup = customerProfile.mainMemberAges[ageRange];
    if (memberGroup != null) {
      // Assuming roughly 50/50 split for main members
      return (memberGroup.mainMember * 0.5).round();
    }
    return 0;
  }

  int _getMainMemberFemaleForAge(
      CustomerProfile customerProfile, String ageRange) {
    final memberGroup = customerProfile.mainMemberAges[ageRange];
    if (memberGroup != null) {
      return (memberGroup.mainMember * 0.5).round();
    }
    return 0;
  }

  int _getPartnerMaleForAge(CustomerProfile customerProfile, String ageRange) {
    final memberGroup = customerProfile.mainMemberAges[ageRange];
    if (memberGroup != null) {
      return (memberGroup.partner * 0.7).round(); // Assuming more male partners
    }
    return 0;
  }

  int _getPartnerFemaleForAge(
      CustomerProfile customerProfile, String ageRange) {
    final memberGroup = customerProfile.mainMemberAges[ageRange];
    if (memberGroup != null) {
      return (memberGroup.partner * 0.3).round();
    }
    return 0;
  }

  int _getChildMaleForAge(CustomerProfile customerProfile, String ageRange) {
    final memberGroup = customerProfile.mainMemberAges[ageRange];
    if (memberGroup != null) {
      return (memberGroup.child * 0.5).round();
    }
    return 0;
  }

  int _getChildFemaleForAge(CustomerProfile customerProfile, String ageRange) {
    final memberGroup = customerProfile.mainMemberAges[ageRange];
    if (memberGroup != null) {
      return (memberGroup.child * 0.5).round();
    }
    return 0;
  }

  Map<String, dynamic> _getEnforcedAgeDistribution(
      CustomerProfile customerProfile) {
    // Calculate enforced policies distribution
    // Use the enforcement percentages from membersCountsData
    final enforcementRate =
        customerProfile.membersCountsData.mainMember.enforcedPercentage / 100;

    return customerProfile.genderDistribution.ageGroups
        .map((ageRange, ageGenderData) {
      return MapEntry(ageRange, {
        'main_member': {
          'male': (_getMainMemberMaleForAge(customerProfile, ageRange) *
                  enforcementRate)
              .round(),
          'female': (_getMainMemberFemaleForAge(customerProfile, ageRange) *
                  enforcementRate)
              .round(),
        },
        'partner': {
          'male': (_getPartnerMaleForAge(customerProfile, ageRange) *
                  enforcementRate)
              .round(),
          'female': (_getPartnerFemaleForAge(customerProfile, ageRange) *
                  enforcementRate)
              .round(),
        },
        'child': {
          'male':
              (_getChildMaleForAge(customerProfile, ageRange) * enforcementRate)
                  .round(),
          'female': (_getChildFemaleForAge(customerProfile, ageRange) *
                  enforcementRate)
              .round(),
        },
      });
    });
  }

  Map<String, dynamic> _getNotEnforcedAgeDistribution(
      CustomerProfile customerProfile) {
    // Calculate not enforced policies distribution
    final notEnforcementRate =
        customerProfile.membersCountsData.mainMember.notEnforcedPercentage /
            100;

    return customerProfile.genderDistribution.ageGroups
        .map((ageRange, ageGenderData) {
      return MapEntry(ageRange, {
        'main_member': {
          'male': (_getMainMemberMaleForAge(customerProfile, ageRange) *
                  notEnforcementRate)
              .round(),
          'female': (_getMainMemberFemaleForAge(customerProfile, ageRange) *
                  notEnforcementRate)
              .round(),
        },
        'partner': {
          'male': (_getPartnerMaleForAge(customerProfile, ageRange) *
                  notEnforcementRate)
              .round(),
          'female': (_getPartnerFemaleForAge(customerProfile, ageRange) *
                  notEnforcementRate)
              .round(),
        },
        'child': {
          'male': (_getChildMaleForAge(customerProfile, ageRange) *
                  notEnforcementRate)
              .round(),
          'female': (_getChildFemaleForAge(customerProfile, ageRange) *
                  notEnforcementRate)
              .round(),
        },
      });
    });
  }

  List<BarChartGroupData> _generateBarGroups(
      Map<String, dynamic> data, BuildContext context) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];

    return List.generate(ageGroups.length, (index) {
      final ageRange = ageGroups[index];
      double cumulativeAmount = 0;

      List<BarChartRodStackItem> rodStackItems = [];

      // Define the order of colors
      Map<Color, int> colorOrder = {
        Colors.green: 1,
        Colors.blue: 2,
        Colors.purple: 3,
        Colors.orange: 4,
      };

      // Add stack items for main_member, partner, and child
      ['main_member', 'partner', 'child'].forEach((role) {
        if (data[ageRange] != null && data[ageRange][role] != null) {
          final maleFrequency = (data[ageRange][role]["male"] ?? 0).toDouble();
          final femaleFrequency =
              (data[ageRange][role]["female"] ?? 0).toDouble();

          double totalFrequency = maleFrequency + femaleFrequency;
          if (totalFrequency > 0) {
            rodStackItems.add(BarChartRodStackItem(
              cumulativeAmount,
              cumulativeAmount + totalFrequency,
              getColorForRole(role),
            ));
            cumulativeAmount += totalFrequency;
          }
        }
      });

      // Sort by predefined color order
      rodStackItems
          .sort((a, b) => colorOrder[a.color]!.compareTo(colorOrder[b.color]!));
      rodStackItems = rodStackItems.reversed.toList();

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: cumulativeAmount,
            width: 22,
            rodStackItems: rodStackItems,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      );
    });
  }

  List<LineChartBarData> _generateLineChartData(
    flypes? spots,
    flypes? spots2,
    flypes? spots3,
    flypes? spots4,
  ) {
    List<LineChartBarData> lines = [];

    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.blue,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots2 != null) {
      lines.add(LineChartBarData(
        spots: spots2.flspots,
        isCurved: true,
        color: Colors.orange,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots3 != null) {
      lines.add(LineChartBarData(
        spots: spots3.flspots,
        isCurved: true,
        color: Colors.purple,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots4 != null) {
      lines.add(LineChartBarData(
        spots: spots4.flspots,
        isCurved: true,
        color: Colors.green,
        dotData: FlDotData(show: false),
      ));
    }

    return lines;
  }

  Widget _buildLineChart(
    List<LineChartBarData> lines,
    flypes? spots,
    flypes? spots2,
    flypes? spots3,
    flypes? spots4,
  ) {
    return Container(
      height: 320,
      child: LineChart(
        LineChartData(
          lineBarsData: lines,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.round().toString(),
                    style: TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 30),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: TextStyle(fontSize: 8.5),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (value) => Colors.blueGrey,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  if (touchedSpot.y == 0) {
                    return null;
                  }
                  return LineTooltipItem(
                    touchedSpot.y.toString(),
                    const TextStyle(color: Colors.black),
                  );
                }).toList();
              },
            ),
            touchCallback: (FlTouchEvent flTouchEvent,
                LineTouchResponse? touchResponse) {},
            handleBuiltInTouches: false,
          ),
          minX: 0,
          maxX: 100,
          extraLinesData: ExtraLinesData(
            verticalLines: [
              if (spots != null)
                VerticalLine(
                  x: spots.mean_hor,
                  color: Colors.blue,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              if (spots2 != null)
                VerticalLine(
                  x: spots2.mean_hor,
                  color: Colors.orange,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              if (spots3 != null)
                VerticalLine(
                  x: spots3.mean_hor,
                  color: Colors.green,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              if (spots4 != null)
                VerticalLine(
                  x: spots4.mean_hor,
                  color: Colors.purple,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(List<BarChartGroupData> barGroups) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];

    return Container(
      height: 320,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  if (value.round() < ageGroups.length) {
                    return Text(
                      ageGroups[value.round()],
                      style: TextStyle(fontSize: 7),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 30),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    formatLargeNumber3(value.round().toString()),
                    style: TextStyle(fontSize: 8.5),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: Colors.grey, width: 1),
              right: BorderSide(color: Colors.transparent),
              bottom: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.20),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey,
                strokeWidth: 1,
              );
            },
          ),
          barGroups: barGroups,
          groupsSpace: 10,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (value) => Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                if (rod.toY == 0) {
                  return null;
                }
                return BarTooltipItem(
                  rod.toY.toString(),
                  const TextStyle(color: Colors.black),
                );
              },
            ),
            touchCallback:
                (FlTouchEvent flTouchEvent, BarTouchResponse? touchResponse) {},
            handleBuiltInTouches: false,
          ),
        ),
      ),
    );
  }

  Color getColorForRole(String type) {
    switch (type) {
      case 'main_member':
        return Colors.blue;
      case 'partner':
        return Colors.orange;
      case 'child':
        return Colors.purple;
      case 'extended':
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }
}

class ClaimsBellCurveChart extends StatelessWidget {
  final int Selected_Button;
  final int days_difference;
  final int customers_index;
  final int target_index_7;

  ClaimsBellCurveChart({
    Key? key,
    required this.customers_index,
    required this.Selected_Button,
    required this.days_difference,
    required this.target_index_7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    flypes? spots;
    flypes? spots2;
    flypes? spots3;
    flypes? spots4;

    List<BarChartGroupData> barGroups1 = [];
    if (Selected_Button == 1) {
      if (customers_index == 0) {
        spots = generateSkewedSpots(
          Constants.claims_age_distribution_lists_1a_1_1,
        );

        spots2 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_1a_2_1,
        );
        spots3 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_1a_3_1,
        );
        spots4 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_1a_4_1,
        );
      }
      if (customers_index == 1) {
        spots = generateSkewedSpots(
          Constants.claims_age_distribution_lists_1a_1_2,
        );
        spots2 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_1a_2_2,
        );
        spots3 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_1a_3_2,
        );
        spots4 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_1a_4_2,
        );
      }
      if (customers_index == 2) {
        spots = generateSkewedSpots(
          Constants.claims_age_distribution_lists_1a_1_3,
        );
        spots2 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_1a_2_3,
        );
        spots3 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_1a_3_3,
        );
        spots4 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_1a_4_3,
        );
        //print("dgdsjhsdhjk21 ${Constants.age_distribution_lists_1a_1_3}");
        //print("dgdsjhsdhjk22 ${Constants.age_distribution_lists_1a_2_3}");
        //print("dgdsjhsdhjk23 ${Constants.age_distribution_lists_1a_3_3}");
        //print("dgdsjhsdhjk24 ${Constants.age_distribution_lists_1a_4_3}");
      }
    } else if (Selected_Button == 2) {
      if (customers_index == 0) {
        spots = generateSkewedSpots(
          Constants.claims_age_distribution_lists_2a_1_1,
        );
        spots2 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_2a_2_1,
        );
        spots3 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_2a_3_1,
        );
        spots4 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_2a_4_1,
        );
      }
      if (customers_index == 1) {
        spots = generateSkewedSpots(
          Constants.claims_age_distribution_lists_2a_1_2,
        );
        spots2 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_2a_2_2,
        );
        spots3 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_2a_3_2,
        );
        spots4 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_2a_4_2,
        );
      }
      if (customers_index == 2) {
        spots = generateSkewedSpots(
          Constants.claims_age_distribution_lists_2a_1_3,
        );
        spots2 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_2a_2_3,
        );
        spots3 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_2a_3_3,
        );
        spots4 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_2a_4_3,
        );
        //print("dgdsjhsdhjk21 ${Constants.age_distribution_lists_1a_1_3}");
        //print("dgdsjhsdhjk22 ${Constants.age_distribution_lists_1a_2_3}");
        //print("dgdsjhsdhjk23 ${Constants.age_distribution_lists_1a_3_3}");
        //print("dgdsjhsdhjk24 ${Constants.age_distribution_lists_1a_4_3}");
      }
    } else if (Selected_Button == 3) {
      if (customers_index == 0) {
        spots = generateSkewedSpots(
          Constants.claims_age_distribution_lists_3a_1_1,
        );
        spots2 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_3a_2_1,
        );
        spots3 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_3a_3_1,
        );
        spots4 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_3a_4_1,
        );
      }
      if (customers_index == 1) {
        spots = generateSkewedSpots(
          Constants.claims_age_distribution_lists_3a_1_2,
        );
        spots2 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_3a_2_2,
        );
        spots3 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_3a_3_2,
        );
        spots4 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_3a_4_2,
        );
      }
      if (customers_index == 2) {
        spots = generateSkewedSpots(
          Constants.claims_age_distribution_lists_3a_1_3,
        );
        spots2 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_3a_2_3,
        );
        spots3 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_3a_3_3,
        );
        spots4 = generateSkewedSpots(
          Constants.claims_age_distribution_lists_3a_4_3,
        );
        //print("dgdsjhsdhjk21 ${Constants.age_distribution_lists_1a_1_3}");
        //print("dgdsjhsdhjk22 ${Constants.age_distribution_lists_1a_2_3}");
        //print("dgdsjhsdhjk23 ${Constants.age_distribution_lists_1a_3_3}");
        //print("dgdsjhsdhjk24 ${Constants.age_distribution_lists_1a_4_3}");
      }
    }
    bool noDataAvailable =
        (spots == null && spots2 == null && spots3 == null && spots4 == null) ||
            (spots?.flspots.length ?? 0) < 3 &&
                (spots2?.flspots.length ?? 0) < 3 &&
                (spots3?.flspots.length ?? 0) < 3 &&
                (spots4?.flspots.length ?? 0) < 3;

    if (noDataAvailable == true) {
      return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
        child: Container(
          height: 700,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No data available for the selected range",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 12),
              Icon(
                Icons.auto_graph_sharp,
                color: Colors.grey,
              )
            ],
          ),
        ),
      );
    }

    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];

    Map<String, dynamic> data = {};
    if (Selected_Button == 1) {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_1a_1;
      } else if (customers_index == 1) {
        data = Constants.claims_age_distribution_by_gender_and_type_1a_2;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_1a_3;

        print("hhgg $data");
      }
    } else if (Selected_Button == 2) {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_2a_1;
      } else if (customers_index == 1) {
        data = Constants.claims_age_distribution_by_gender_and_type_2a_2;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_2a_3;
      }
    } else if (Selected_Button == 3) {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_3a_1;
      } else if (customers_index == 1) {
        data = Constants.claims_age_distribution_by_gender_and_type_3a_2;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_3a_3;
      }
    }

    barGroups1 = List.generate(ageGroups.length, (index) {
      final ageRange = ageGroups[index];
      double cumulativeAmount = 0;

      // Assuming 'data' is structured to access the frequencies for males and females under different roles
      List<BarChartRodStackItem> rodStackItems = [];

      // Define the order of colors if it's not already defined
      Map<Color, int> colorOrder = {
        Colors.green: 1,
        Colors.blue: 2,
        Colors.purple: 3,
        Colors.orange: 3,
      };

      // Add stack items for main_member, partner, and child
      ['main_member', 'partner', "child"].forEach((role) {
        final maleFrequency = data[role]["male"][ageRange].toDouble();
        final femaleFrequency = data[role]["female"][ageRange]!.toDouble();

        double totalFrequency = maleFrequency + femaleFrequency;
        rodStackItems.add(BarChartRodStackItem(cumulativeAmount,
            cumulativeAmount + totalFrequency, getColorForRole(role)));

        cumulativeAmount += totalFrequency;
      });

      // Sort by predefined color order
      rodStackItems
          .sort((a, b) => colorOrder[a.color]!.compareTo(colorOrder[b.color]!));
      rodStackItems = rodStackItems.reversed.toList();

      // Print for debugging
      print(rodStackItems);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: cumulativeAmount,
            width: 22,
            rodStackItems: rodStackItems,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      );
    });

    // barGroups = List.generate(ageGroups.length, (index) {
    //   final ageRange = ageGroups[index];
    //   print("Data: ${data}");
    //
    //   // Main member frequencies
    //   final maleFrequency = data["main_member"]["male"]![ageRange]!.toDouble();
    //   final femaleFrequency =
    //       data["main_member"]["female"]![ageRange]!.toDouble();
    //
    //   // Partner frequencies
    //   final maleFrequency1 = data["partner"]["male"]![ageRange]!.toDouble();
    //   final femaleFrequency1 = data["partner"]["female"]![ageRange]!.toDouble();
    //
    //   // Child frequencies
    //   final maleFrequency3 = data["child"]["male"]![ageRange]!.toDouble();
    //   final femaleFrequency3 = data["child"]["female"]![ageRange]!.toDouble();
    //
    //   int numberOfBars = 9;
    //   double chartWidth = MediaQuery.of(context).size.width;
    //   double maxBarWidth = 30; // Maximum width of a bar
    //   double minBarSpace = 10; // Minimum space between bars
    //
    //   double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));
    //
    //   return BarChartGroupData(
    //     x: index,
    //     barRods: [
    //       BarChartRodData(
    //         toY: maleFrequency +
    //             femaleFrequency, // Total frequency of main members
    //         color: Colors.blue,
    //         width: barWidth,
    //         borderRadius: BorderRadius.circular(0),
    //       ),
    //       BarChartRodData(
    //         toY: maleFrequency1 +
    //             femaleFrequency1, // Total frequency of partners
    //         color: Colors.grey,
    //         width: barWidth,
    //         borderRadius: BorderRadius.circular(0),
    //       ),
    //       BarChartRodData(
    //         toY: maleFrequency3 +
    //             femaleFrequency3, // Total frequency of children
    //         color: Colors.pink,
    //         width: barWidth,
    //         borderRadius: BorderRadius.circular(0),
    //       ),
    //     ],
    //     barsSpace: minBarSpace,
    //   );
    // });

    // Simplified conditional addition of LineChartBarData
    List<LineChartBarData> lines = [];

    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.blue,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots2 != null) {
      lines.add(LineChartBarData(
        spots: spots2.flspots,
        isCurved: true,
        color: Colors.orange,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots3 != null) {
      lines.add(LineChartBarData(
        spots: spots3.flspots,
        isCurved: true,
        color: Colors.green,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots4 != null) {
      lines.add(LineChartBarData(
        spots: spots4.flspots,
        isCurved: true,
        color: Colors.purple,
        dotData: FlDotData(show: false),
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Column(
        children: [
          if (target_index_7 == 0)
            Container(
                height: 320,
                child: LineChart(
                  LineChartData(
                    lineBarsData: lines,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.round().toString(),
                              style: TextStyle(fontSize: 11),
                            );
                          },
                        ),
                        /*axisNameWidget: Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 0.0),
                                                                            child: Text(
                                                                              'Sales',
                                                                              style: TextStyle(
                                                                                  fontSize: 11,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Colors.black),
                                                                            ),
                                                                          ),*/
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false, reservedSize: 30),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(2),
                              style: TextStyle(fontSize: 8.5),
                            );
                          },
                        ),
                        /*axisNameWidget: Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 0.0),
                                                                            child: Text(
                                                                              'Sales',
                                                                              style: TextStyle(
                                                                                  fontSize: 11,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Colors.black),
                                                                            ),
                                                                          ),*/
                      ),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (value) {
                          return Colors.blueGrey;
                        },
                      ),
                      //touchCallback: (FlTouchEvent flTouchEvent,LineTouchResponse touchResponse) {},
                      handleBuiltInTouches: false,
                    ),
                    minX: 0,
                    maxX: 100,
                    extraLinesData: ExtraLinesData(
                      /*   horizontalLines: [
                                  if (spots != null)
                                    HorizontalLine(
                                      y: spots.mean_hor,
                                      color: Colors.red,
                                      strokeWidth: 1,
                                      dashArray: [5, 5],
                                    ),
                                ],*/
                      verticalLines: [
                        if (spots != null)
                          VerticalLine(
                            x: spots.mean_hor,
                            color: Colors.blue,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          ),
                        if (spots2 != null)
                          VerticalLine(
                            x: spots2.mean_hor,
                            color: Colors.orange,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          ),
                        if (spots3 != null)
                          VerticalLine(
                            x: spots3.mean_hor,
                            color: Colors.green,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          ),
                        if (spots4 != null)
                          VerticalLine(
                            x: spots4.mean_hor,
                            color: Colors.purple,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          ),
                      ],
                    ),
                  ),
                )),
          if (target_index_7 == 1)
            Container(
              height: 320,
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            ageGroups[value.round()].toString(),
                            style: TextStyle(fontSize: 7),
                          );
                        },
                      ),
                      /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: false, reservedSize: 30),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        getTitlesWidget: (value, meta) {
                          if (value != value.round()) {
                            return Container();
                          } else
                            return Text(
                              formatLargeNumber3(value.round().toString()),
                              style: TextStyle(fontSize: 8.5),
                            );
                        },
                      ),
                      /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      left: BorderSide(color: Colors.grey, width: 1),
                      right: BorderSide(color: Colors.transparent),
                      bottom: BorderSide(color: Colors.transparent),
                      top: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  /*maxY:(target_index == 0
                            ? getBarMaxData("male", _selectedButton,
                            customers_index, grid_index, days_difference)
                            : getBarMaxClaimsData(
                            "male",
                            _selectedButton,
                            customers_index,
                            grid_index,
                            days_difference)) +
                            5*/
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.20),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: barGroups1,
                  groupsSpace: 10, // Adjust space between bar groups
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (value) {
                        return Colors.blueGrey;
                      },
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (rod.toY == 0) {
                          return null; // Don't show tooltip for values of 0
                        }
                        return BarTooltipItem(
                          rod.toY.toString(),
                          const TextStyle(color: Colors.black),
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent flTouchEvent,
                        BarTouchResponse? touchResponse) {},
                    handleBuiltInTouches: false,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: MemberTypeGrid(),
          ),
        ],
      ),
    );
  }

  Color getColorForRole(String type) {
    switch (type) {
      case 'main_member':
        return Colors.blue;
      case 'partner':
        return Colors.orange;
      case 'child':
        return Colors.purple; // Changed to purple for distinct visualization
      case 'extended':
        return Colors.orange;
      default:
        print("Roledsd: $type");
        return Colors.green; // Default case for unexpected types
    }
  }
}

class AgesDistMainBellCurveChart extends StatelessWidget {
  final int Selected_Button;
  final int days_difference;
  final int customers_index;
  final int target_index_7;

  const AgesDistMainBellCurveChart({
    Key? key,
    required this.Selected_Button,
    required this.days_difference,
    required this.customers_index,
    required this.target_index_7,
  }) : super(key: key);
//The graph is not skewed.
  @override
  Widget build(BuildContext context) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];
    List<BarChartGroupData> barGroups = [];
    Map<String, dynamic> data = {};
    List<double> all_ages = [];
    print("dgdsjhsdhjk1a ${Selected_Button} $customers_index");
    if (Selected_Button == 1) {
      if (customers_index == 0) {
        data = Constants.age_distribution_by_gender_and_type_1a_1;
        all_ages = Constants.age_distribution_lists_1a_1_1;
      } else if (customers_index == 1) {
        data = Constants.age_distribution_by_gender_and_type_1a_2;
        all_ages = Constants.age_distribution_lists_1a_2_1;
      } else if (customers_index == 2) {
        data = Constants.age_distribution_by_gender_and_type_1a_3;
        all_ages = Constants.age_distribution_lists_1a_3_1;
        print("fggfhg $all_ages");
        print("hhgg $data");
      }
    } else if (Selected_Button == 2) {
      if (customers_index == 0) {
        data = Constants.age_distribution_by_gender_and_type_2a_1;
        all_ages = Constants.age_distribution_lists_2a_1_1;
      } else if (customers_index == 1) {
        data = Constants.age_distribution_by_gender_and_type_2a_2;
        all_ages = Constants.age_distribution_lists_2a_2_1;
      } else if (customers_index == 2) {
        data = Constants.age_distribution_by_gender_and_type_2a_3;
        all_ages = Constants.age_distribution_lists_2a_3_1;
      }
    } else if (Selected_Button == 3) {
      if (customers_index == 0) {
        data = Constants.age_distribution_by_gender_and_type_3a_1;
        all_ages = Constants.age_distribution_lists_3a_1_1;
      } else if (customers_index == 1) {
        data = Constants.age_distribution_by_gender_and_type_3a_2;
        all_ages = Constants.age_distribution_lists_3a_2_1;
      } else if (customers_index == 2) {
        data = Constants.age_distribution_by_gender_and_type_3a_3;
        all_ages = Constants.age_distribution_lists_3a_3_1;
      }
    }

    flypes? spots = generateSkewedSpots2(
      all_ages,
    );
    if (all_ages.length == 0) {
      return Container(
        child: Center(
            child: Text(
          "No data available for the selected range",
          style: TextStyle(color: Colors.grey.withOpacity(0.55)),
        )),
      );
    } else {
      if (kDebugMode) {
        // print("hggghjhj0 ${all_ages}");
      }
    }
    print("dgdsjhsdhjk1_1 ${spots!.mean_hor}");

    // Simplified conditional addition of LineChartBarData
    List<LineChartBarData> lines = [];

    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.blue,
        dotData: FlDotData(show: false),
      ));
    }

    barGroups = List.generate(ageGroups.length, (index) {
      final ageRange = ageGroups[index];
      final maleFrequency = data["main_member"]["male"]![ageRange]!.toDouble();
      final femaleFrequency =
          data["main_member"]["female"]![ageRange]!.toDouble();
      double totalFrequency = maleFrequency + femaleFrequency;
      int numberOfBars = 9;
      double chartWidth = MediaQuery.of(context).size.width;
      double maxBarWidth = 30; // Maximum width of a bar
      double minBarSpace = 10; // Minimum space between bars

      double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalFrequency,
            color: Colors.grey,
            width: barWidth,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: minBarSpace,
      );
    });
    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Column(
        children: [
          //Text(all_ages.toString()),
          Stack(
            children: [
              if (target_index_7 == 1)
                Container(
                  height: 320,
                  child: BarChart(
                    BarChartData(
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                ageGroups[value.round()].toString(),
                                style: TextStyle(fontSize: 7),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false, reservedSize: 30),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              if (value != value.round()) {
                                return Container();
                              }
                              return Text(
                                formatLargeNumber3(value.round().toString()),
                                style: TextStyle(fontSize: 8.5),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: Colors.grey, width: 1),
                          right: BorderSide(color: Colors.transparent),
                          bottom: BorderSide(color: Colors.transparent),
                          top: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      /*maxY:(target_index == 0
                            ? getBarMaxData("male", _selectedButton,
                            customers_index, grid_index, days_difference)
                            : getBarMaxClaimsData(
                            "male",
                            _selectedButton,
                            customers_index,
                            grid_index,
                            days_difference)) +
                            5*/
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.20),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      barGroups: barGroups,
                      groupsSpace: 10, // Adjust space between bar groups
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (value) {
                            return Colors.blueGrey;
                          },
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            if (rod.toY == 0) {
                              return null; // Don't show tooltip for values of 0
                            }
                            return BarTooltipItem(
                              rod.toY.toString(),
                              const TextStyle(color: Colors.black),
                            );
                          },
                        ),
                        touchCallback: (FlTouchEvent flTouchEvent,
                            BarTouchResponse? touchResponse) {},
                        handleBuiltInTouches: false,
                      ),
                    ),
                  ),
                ),
              if (target_index_7 == 0)
                if (all_ages.length >= 2)
                  SizedBox(
                      height: 320,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: lines,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 20,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.round().toString(),
                                    style: TextStyle(fontSize: 11),
                                  );
                                },
                              ),
                              /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: false, reservedSize: 30),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 8.5),
                                  );
                                },
                              ),
                              /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                            ),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (value) {
                                return Colors.blueGrey;
                              },
                            ),
                            //touchCallback: (FlTouchEvent flTouchEvent,LineTouchResponse touchResponse) {},
                            handleBuiltInTouches: false,
                          ),
                          minX: 0,
                          maxX: 100,
                          extraLinesData: ExtraLinesData(
                            /*   horizontalLines: [
                                      if (spots != null)
                                        HorizontalLine(
                                          y: spots.mean_hor,
                                          color: Colors.red,
                                          strokeWidth: 1,
                                          dashArray: [5, 5],
                                        ),
                                    ],*/
                            verticalLines: [
                              if (spots != null)
                                VerticalLine(
                                  x: spots.mean_hor,
                                  color: Colors.blue,
                                  strokeWidth: 1,
                                  dashArray: [5, 5],
                                ),
                            ],
                          ),
                        ),
                      )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: MemberTypeGrid1(),
          )
        ],
      ),
    );
  }
}

class ClaimsAgesDistMainBellCurveChart extends StatelessWidget {
  final int Selected_Button;
  final int days_difference;
  final int customers_index;
  final int target_index_7;

  const ClaimsAgesDistMainBellCurveChart({
    Key? key,
    required this.Selected_Button,
    required this.days_difference,
    required this.customers_index,
    required this.target_index_7,
  }) : super(key: key);
//The graph is not skewed.
  @override
  Widget build(BuildContext context) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];
    List<BarChartGroupData> barGroups = [];
    Map<String, dynamic> data = {};
    List<double> all_ages = [];
    print("dgdsjhsdhjk1a ${Selected_Button} $customers_index");
    if (Selected_Button == 1) {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_1a_1;
        all_ages = Constants.claims_age_distribution_lists_1a_1_1;
      } else if (customers_index == 1) {
        data = Constants.claims_age_distribution_by_gender_and_type_1a_2;
        all_ages = Constants.claims_age_distribution_lists_1a_2_1;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_1a_3;
        all_ages = Constants.claims_age_distribution_lists_1a_3_1;
        print("fggfhg $all_ages");
        print("hhgg $data");
      }
    } else if (Selected_Button == 2) {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_2a_1;
        all_ages = Constants.claims_age_distribution_lists_2a_1_1;
      } else if (customers_index == 1) {
        data = Constants.claims_age_distribution_by_gender_and_type_2a_2;
        all_ages = Constants.claims_age_distribution_lists_2a_2_1;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_2a_3;
        all_ages = Constants.claims_age_distribution_lists_2a_3_1;
      }
    } else if (Selected_Button == 3) {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_3a_1;
        all_ages = Constants.claims_age_distribution_lists_3a_1_1;
      } else if (customers_index == 1) {
        data = Constants.claims_age_distribution_by_gender_and_type_3a_2;
        all_ages = Constants.claims_age_distribution_lists_3a_2_1;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_3a_3;
        all_ages = Constants.claims_age_distribution_lists_3a_3_1;
      }
    }
    if (all_ages.length < 3) {
      return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
        child: Container(
            height: 700,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No data available for the selected range",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 12),
                Icon(
                  Icons.auto_graph_sharp,
                  color: Colors.grey,
                )
              ],
            )),
      );
    }

    flypes? spots = generateSkewedSpots2(
      all_ages,
    );
    print("dgdsjhsdhjk1_1 ${spots!.mean_hor}");

    // Simplified conditional addition of LineChartBarData
    List<LineChartBarData> lines = [];

    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.blue,
        dotData: FlDotData(show: false),
      ));
    }

    barGroups = List.generate(ageGroups.length, (index) {
      final ageRange = ageGroups[index];
      final maleFrequency = data["main_member"]["male"]![ageRange]!.toDouble();
      final femaleFrequency =
          data["main_member"]["female"]![ageRange]!.toDouble();
      double totalFrequency = maleFrequency + femaleFrequency;
      int numberOfBars = 9;
      double chartWidth = MediaQuery.of(context).size.width;
      double maxBarWidth = 30; // Maximum width of a bar
      double minBarSpace = 10; // Minimum space between bars

      double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalFrequency,
            color: Colors.grey,
            width: barWidth,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: minBarSpace,
      );
    });
    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Column(
        children: [
          //Text(all_ages.toString()),
          Stack(
            children: [
              if (target_index_7 == 1)
                Container(
                  height: 320,
                  child: BarChart(
                    BarChartData(
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                ageGroups[value.round()].toString(),
                                style: TextStyle(fontSize: 7),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false, reservedSize: 30),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              if (value != value.round()) {
                                return Container();
                              }
                              return Text(
                                formatLargeNumber3(value.round().toString()),
                                style: TextStyle(fontSize: 8.5),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: Colors.grey, width: 1),
                          right: BorderSide(color: Colors.transparent),
                          bottom: BorderSide(color: Colors.transparent),
                          top: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      /*maxY:(target_index == 0
                            ? getBarMaxData("male", _selectedButton,
                            customers_index, grid_index, days_difference)
                            : getBarMaxClaimsData(
                            "male",
                            _selectedButton,
                            customers_index,
                            grid_index,
                            days_difference)) +
                            5*/
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.20),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      barGroups: barGroups,
                      groupsSpace: 10, // Adjust space between bar groups
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (value) {
                            return Colors.blueGrey;
                          },
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            if (rod.toY == 0) {
                              return null; // Don't show tooltip for values of 0
                            }
                            return BarTooltipItem(
                              rod.toY.toString(),
                              const TextStyle(color: Colors.black),
                            );
                          },
                        ),
                        touchCallback: (FlTouchEvent flTouchEvent,
                            BarTouchResponse? touchResponse) {},
                        handleBuiltInTouches: false,
                      ),
                    ),
                  ),
                ),
              if (target_index_7 == 0)
                if (all_ages.length >= 2)
                  SizedBox(
                      height: 320,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: lines,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 20,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.round().toString(),
                                    style: TextStyle(fontSize: 11),
                                  );
                                },
                              ),
                              /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: false, reservedSize: 30),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toStringAsFixed(2),
                                    style: TextStyle(fontSize: 8.5),
                                  );
                                },
                              ),
                              /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                            ),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (value) {
                                return Colors.blueGrey;
                              },
                            ),
                            //touchCallback: (FlTouchEvent flTouchEvent,LineTouchResponse touchResponse) {},
                            handleBuiltInTouches: false,
                          ),
                          minX: 0,
                          maxX: 100,
                          extraLinesData: ExtraLinesData(
                            /*   horizontalLines: [
                                      if (spots != null)
                                        HorizontalLine(
                                          y: spots.mean_hor,
                                          color: Colors.red,
                                          strokeWidth: 1,
                                          dashArray: [5, 5],
                                        ),
                                    ],*/
                            verticalLines: [
                              if (spots != null)
                                VerticalLine(
                                  x: spots.mean_hor,
                                  color: Colors.blue,
                                  strokeWidth: 1,
                                  dashArray: [5, 5],
                                ),
                            ],
                          ),
                        ),
                      )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: target_index_7 == 0 ? MemberTypeGrid1() : MemberTypeGrid1a(),
          )
        ],
      ),
    );
  }
}

class ClaimsAgesDistPartnerBellCurveChart extends StatelessWidget {
  final int Selected_Button;
  final int days_difference;
  final int customers_index;
  final int target_index_7;

  ClaimsAgesDistPartnerBellCurveChart({
    Key? key,
    required this.Selected_Button,
    required this.days_difference,
    required this.customers_index,
    required this.target_index_7,
  }) : super(key: key);
//The graph is not skewed.
  @override
  Widget build(BuildContext context) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];
    List<BarChartGroupData> barGroups = [];
    Map<String, dynamic> data = {};
    List<double> all_ages = [];
    if (Selected_Button == 1) {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_1a_1;
        all_ages = Constants.claims_age_distribution_lists_1a_2_2;
      } else if (customers_index == 1) {
        data = Constants.claims_age_distribution_by_gender_and_type_1a_2;
        all_ages = Constants.claims_age_distribution_lists_1a_2_2;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_1a_3;
        all_ages = Constants.claims_age_distribution_lists_1a_3_2;
      }
    } else if (Selected_Button == 2) {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_2a_1;
        all_ages = Constants.claims_age_distribution_lists_2a_2_2;
      } else if (customers_index == 1) {
        data = Constants.claims_age_distribution_by_gender_and_type_2a_2;
        all_ages = Constants.claims_age_distribution_lists_2a_2_2;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_2a_3;
        all_ages = Constants.claims_age_distribution_lists_2a_3_2;
      }
    } else if (Selected_Button == 3) {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_3a_1;
        all_ages = Constants.claims_age_distribution_lists_3a_2_2;
      } else if (customers_index == 1) {
        data = Constants.age_distribution_by_gender_and_type_3a_2;
        all_ages = Constants.claims_age_distribution_lists_3a_2_2;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_3a_3;
        all_ages = Constants.claims_age_distribution_lists_3a_3_2;
      }
    }
    if (all_ages.length < 3) {
      return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
        child: Container(
            height: 700,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No data available for the selected range",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 12),
                Icon(
                  Icons.auto_graph_sharp,
                  color: Colors.grey,
                )
              ],
            )),
      );
    }
    flypes? spots = generateSkewedSpots2(
      all_ages,
    );
    ("dgdsjhsdhjk2 ${spots!.mean_hor}");

    // Simplified conditional addition of LineChartBarData
    List<LineChartBarData> lines = [];

    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.orange,
        dotData: FlDotData(show: false),
      ));
    }

    barGroups = List.generate(ageGroups.length, (index) {
      final ageRange = ageGroups[index];
      final maleFrequency = data["partner"]["male"]![ageRange]!.toDouble();
      final femaleFrequency = data["partner"]["female"]![ageRange]!.toDouble();
      double totalFrequency = maleFrequency + femaleFrequency;
      int numberOfBars = 9;
      double chartWidth = MediaQuery.of(context).size.width;
      double maxBarWidth = 30; // Maximum width of a bar
      double minBarSpace = 10; // Minimum space between bars

      double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));

      return BarChartGroupData(
        x: index,
        showingTooltipIndicators: [index],
        barRods: [
          BarChartRodData(
            toY: totalFrequency,
            color: Colors.grey,
            width: barWidth,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: minBarSpace,
      );
    });

    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Column(
        children: [
          Stack(
            children: [
              if (target_index_7 == 1)
                Container(
                  height: 320,
                  child: BarChart(
                    BarChartData(
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                ageGroups[value.round()].toString(),
                                style: TextStyle(fontSize: 7),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false, reservedSize: 30),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              String v1 = value.toStringAsFixed(2);
                              print("dfdd $v1");
                              if (v1 == "1.00") {
                                print(value.toStringAsFixed(2));
                                return Text(
                                  formatLargeNumber3((1).toString()),
                                  style: TextStyle(fontSize: 8.5),
                                );
                              }
                              if (value != value.round()) {
                                return Container();
                              }

                              return Text(
                                formatLargeNumber3(value.round().toString()),
                                style: TextStyle(fontSize: 8.5),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: Colors.grey, width: 1),
                          right: BorderSide(color: Colors.transparent),
                          bottom: BorderSide(color: Colors.transparent),
                          top: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      /*maxY:(target_index == 0
                            ? getBarMaxData("male", _selectedButton,
                            customers_index, grid_index, days_difference)
                            : getBarMaxClaimsData(
                            "male",
                            _selectedButton,
                            customers_index,
                            grid_index,
                            days_difference)) +
                            5*/
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.20),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      barGroups: barGroups,
                      groupsSpace: 10, // Adjust space between bar groups
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (value) {
                            return Colors.blueGrey;
                          },
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            if (rod.toY == 0) {
                              return null; // Don't show tooltip for values of 0
                            }
                            return BarTooltipItem(
                              rod.toY.toString(),
                              const TextStyle(color: Colors.black),
                            );
                          },
                        ),
                        touchCallback: (FlTouchEvent flTouchEvent,
                            BarTouchResponse? touchResponse) {},
                        handleBuiltInTouches: false,
                      ),
                    ),
                  ),
                ),
              if (target_index_7 == 0)
                Container(
                    height: 320,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: lines,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.round().toString(),
                                  style: TextStyle(fontSize: 11),
                                );
                              },
                            ),
                            /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: false, reservedSize: 20),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 8.5),
                                );
                              },
                            ),
                            /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (value) {
                              return Colors.blueGrey;
                            },
                          ),
                          //touchCallback: (FlTouchEvent flTouchEvent,LineTouchResponse touchResponse) {},
                          handleBuiltInTouches: false,
                        ),
                        minX: 0,
                        maxX: 100,
                        extraLinesData: ExtraLinesData(
                          /*   horizontalLines: [
                                      if (spots != null)
                                        HorizontalLine(
                                          y: spots.mean_hor,
                                          color: Colors.red,
                                          strokeWidth: 1,
                                          dashArray: [5, 5],
                                        ),
                                    ],*/
                          verticalLines: [
                            if (spots != null)
                              VerticalLine(
                                x: spots.mean_hor,
                                color: Colors.blue,
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              ),
                          ],
                        ),
                      ),
                    )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: target_index_7 == 0 ? MemberTypeGrid2() : MemberTypeGrid2a(),
          )
        ],
      ),
    );
  }
}

class AgesDistPartnerBellCurveChart extends StatelessWidget {
  final int Selected_Button;
  final int days_difference;
  final int customers_index;
  final int target_index_7;

  AgesDistPartnerBellCurveChart({
    Key? key,
    required this.Selected_Button,
    required this.days_difference,
    required this.customers_index,
    required this.target_index_7,
  }) : super(key: key);
//The graph is not skewed.
  @override
  Widget build(BuildContext context) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];
    List<BarChartGroupData> barGroups = [];
    Map<String, dynamic> data = {};
    List<double> all_ages = [];
    if (Selected_Button == 1) {
      if (customers_index == 0) {
        data = Constants.age_distribution_by_gender_and_type_1a_1;
        all_ages = Constants.age_distribution_lists_1a_2_2;
      } else if (customers_index == 1) {
        data = Constants.age_distribution_by_gender_and_type_1a_2;
        all_ages = Constants.age_distribution_lists_1a_2_2;
      } else if (customers_index == 2) {
        data = Constants.age_distribution_by_gender_and_type_1a_3;
        all_ages = Constants.age_distribution_lists_1a_3_2;
      }
    } else if (Selected_Button == 2) {
      if (customers_index == 0) {
        data = Constants.age_distribution_by_gender_and_type_2a_1;
        all_ages = Constants.age_distribution_lists_2a_2_2;
      } else if (customers_index == 1) {
        data = Constants.age_distribution_by_gender_and_type_2a_2;
        all_ages = Constants.age_distribution_lists_2a_2_2;
      } else if (customers_index == 2) {
        data = Constants.age_distribution_by_gender_and_type_2a_3;
        all_ages = Constants.age_distribution_lists_2a_3_2;
      }
    } else if (Selected_Button == 3) {
      if (customers_index == 0) {
        data = Constants.age_distribution_by_gender_and_type_3a_1;
        all_ages = Constants.age_distribution_lists_3a_2_2;
      } else if (customers_index == 1) {
        data = Constants.age_distribution_by_gender_and_type_3a_2;
        all_ages = Constants.age_distribution_lists_3a_2_2;
      } else if (customers_index == 2) {
        data = Constants.age_distribution_by_gender_and_type_3a_3;
        all_ages = Constants.age_distribution_lists_3a_3_2;
      }
    }
    flypes? spots = generateSkewedSpots2(
      all_ages,
    );

    // Simplified conditional addition of LineChartBarData
    List<LineChartBarData> lines = [];

    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.orange,
        dotData: FlDotData(show: false),
      ));
    }
    if (all_ages.length < 3) {
      return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
        child: Container(
            height: 700,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No data available for the selected range",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 12),
                Icon(
                  Icons.auto_graph_sharp,
                  color: Colors.grey,
                )
              ],
            )),
      );
    }

    barGroups = List.generate(ageGroups.length, (index) {
      final ageRange = ageGroups[index];
      final maleFrequency = data["partner"]["male"]![ageRange]!.toDouble();
      final femaleFrequency = data["partner"]["female"]![ageRange]!.toDouble();
      double totalFrequency = maleFrequency + femaleFrequency;
      int numberOfBars = 9;
      double chartWidth = MediaQuery.of(context).size.width;
      double maxBarWidth = 30; // Maximum width of a bar
      double minBarSpace = 10; // Minimum space between bars

      double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));

      return BarChartGroupData(
        x: index,
        showingTooltipIndicators: [index],
        barRods: [
          BarChartRodData(
            toY: totalFrequency,
            color: Colors.grey,
            width: barWidth,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: minBarSpace,
      );
    });
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Column(
        children: [
          Stack(
            children: [
              if (target_index_7 == 1)
                Container(
                  height: 320,
                  child: BarChart(
                    BarChartData(
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                ageGroups[value.round()].toString(),
                                style: TextStyle(fontSize: 7),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false, reservedSize: 30),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              if (value != value.round()) {
                                return Container();
                              }
                              return Text(
                                formatLargeNumber3(value.round().toString()),
                                style: TextStyle(fontSize: 8.5),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: Colors.grey, width: 1),
                          right: BorderSide(color: Colors.transparent),
                          bottom: BorderSide(color: Colors.transparent),
                          top: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      /*maxY:(target_index == 0
                            ? getBarMaxData("male", _selectedButton,
                            customers_index, grid_index, days_difference)
                            : getBarMaxClaimsData(
                            "male",
                            _selectedButton,
                            customers_index,
                            grid_index,
                            days_difference)) +
                            5*/
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.20),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      barGroups: barGroups,
                      groupsSpace: 10, // Adjust space between bar groups
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (value) {
                            return Colors.blueGrey;
                          },
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            if (rod.toY == 0) {
                              return null; // Don't show tooltip for values of 0
                            }
                            return BarTooltipItem(
                              rod.toY.toString(),
                              const TextStyle(color: Colors.black),
                            );
                          },
                        ),
                        touchCallback: (FlTouchEvent flTouchEvent,
                            BarTouchResponse? touchResponse) {},
                        handleBuiltInTouches: false,
                      ),
                    ),
                  ),
                ),
              if (target_index_7 == 0)
                Container(
                    height: 320,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: lines,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.round().toString(),
                                  style: TextStyle(fontSize: 11),
                                );
                              },
                            ),
                            /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: false, reservedSize: 20),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 8.5),
                                );
                              },
                            ),
                            /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (value) {
                              return Colors.blueGrey;
                            },
                          ),
                          //touchCallback: (FlTouchEvent flTouchEvent,LineTouchResponse touchResponse) {},
                          handleBuiltInTouches: false,
                        ),
                        minX: 0,
                        maxX: 100,
                        extraLinesData: ExtraLinesData(
                          /*   horizontalLines: [
                                      if (spots != null)
                                        HorizontalLine(
                                          y: spots.mean_hor,
                                          color: Colors.red,
                                          strokeWidth: 1,
                                          dashArray: [5, 5],
                                        ),
                                    ],*/
                          verticalLines: [
                            if (spots != null)
                              VerticalLine(
                                x: spots.mean_hor,
                                color: Colors.blue,
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              ),
                          ],
                        ),
                      ),
                    )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: MemberTypeGrid2(),
          )
        ],
      ),
    );
  }
}

class AgesDistChildBellCurveChart extends StatelessWidget {
  final int Selected_Button;
  final int days_difference;
  final int customers_index;
  final int target_index_7;

  AgesDistChildBellCurveChart({
    Key? key,
    required this.Selected_Button,
    required this.days_difference,
    required this.customers_index,
    required this.target_index_7,
  }) : super(key: key);
//The graph is not skewed.
  @override
  Widget build(BuildContext context) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];
    List<BarChartGroupData> barGroups = [];
    Map<String, dynamic> data = {};
    List<double> all_ages = [];
    print("fggf ${Selected_Button} $customers_index");
    if (Selected_Button == 1) {
      if (customers_index == 0) {
        data = Constants.age_distribution_by_gender_and_type_1a_1;
        all_ages = Constants.age_distribution_lists_1a_3_1;
      } else if (customers_index == 1) {
        data = Constants.age_distribution_by_gender_and_type_1a_2;
        all_ages = Constants.age_distribution_lists_1a_3_2;
      } else if (customers_index == 2) {
        data = Constants.age_distribution_by_gender_and_type_1a_3;
        all_ages = Constants.age_distribution_lists_1a_3_3;
      }
    } else if (Selected_Button == 2) {
      if (customers_index == 0) {
        data = Constants.age_distribution_by_gender_and_type_2a_1;
        all_ages = Constants.age_distribution_lists_2a_3_1;
      } else if (customers_index == 1) {
        data = Constants.age_distribution_by_gender_and_type_2a_2;
        all_ages = Constants.age_distribution_lists_2a_3_2;
      } else if (customers_index == 2) {
        data = Constants.age_distribution_by_gender_and_type_2a_3;
        all_ages = Constants.age_distribution_lists_2a_3_3;
      }
    } else if (Selected_Button == 3) {
      if (customers_index == 0) {
        data = Constants.age_distribution_by_gender_and_type_3a_1;
        all_ages = Constants.age_distribution_lists_3a_3_1;
      } else if (customers_index == 1) {
        data = Constants.age_distribution_by_gender_and_type_3a_2;
        all_ages = Constants.age_distribution_lists_3a_3_2;
      } else if (customers_index == 2) {
        data = Constants.age_distribution_by_gender_and_type_3a_3;
        all_ages = Constants.age_distribution_lists_3a_3_3;
      }
    } else {
      if (customers_index == 0) {
        data = Constants.age_distribution_by_gender_and_type_3b_1;
        all_ages = Constants.age_distribution_lists_3b_3_1;
      } else if (customers_index == 1) {
        data = Constants.age_distribution_by_gender_and_type_3b_2;
        all_ages = Constants.age_distribution_lists_3b_3_2;
      } else if (customers_index == 2) {
        data = Constants.age_distribution_by_gender_and_type_3b_3;
        all_ages = Constants.age_distribution_lists_3b_3_3;
      }
    }
    if (all_ages.length < 3) {
      return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
        child: Container(
            height: 700,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No data available for the selected range",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 12),
                Icon(
                  Icons.auto_graph_sharp,
                  color: Colors.grey,
                )
              ],
            )),
      );
    }
    flypes? spots = generateSkewedSpots2(
      all_ages,
    );
    //print("dgdsjhsdhjk1 ${spots!.mean_hor}");

    // Simplified conditional addition of LineChartBarData
    List<LineChartBarData> lines = [];

    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.purple,
        dotData: FlDotData(show: false),
      ));
    }
    if (all_ages.length == 0) {
      return Container(
        child: Center(
            child: Text(
          "No data available for the selected range",
          style: TextStyle(color: Colors.grey.withOpacity(0.55)),
        )),
      );
    } else {
      if (kDebugMode) {
        print("hggghjhj0 ${all_ages}");
      }
    }

    barGroups = List.generate(ageGroups.length, (index) {
      final ageRange = ageGroups[index];
      final maleFrequency = data["child"]["male"]![ageRange]!.toDouble();
      final femaleFrequency = data["child"]["female"]![ageRange]!.toDouble();
      double totalFrequency = maleFrequency + femaleFrequency;
      int numberOfBars = 9;
      double chartWidth = MediaQuery.of(context).size.width;
      double maxBarWidth = 30; // Maximum width of a bar
      double minBarSpace = 10; // Minimum space between bars

      double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalFrequency,
            color: Colors.grey,
            width: barWidth,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: minBarSpace,
      );
    });
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Column(
        children: [
          Stack(
            children: [
              if (target_index_7 == 1)
                Container(
                  height: 320,
                  child: BarChart(
                    BarChartData(
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                ageGroups[value.round()].toString(),
                                style: TextStyle(fontSize: 7),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false, reservedSize: 30),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              if (value != value.round()) {
                                return Container();
                              }
                              return Text(
                                formatLargeNumber3(value.round().toString()),
                                style: TextStyle(fontSize: 8.5),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: Colors.grey, width: 1),
                          right: BorderSide(color: Colors.transparent),
                          bottom: BorderSide(color: Colors.transparent),
                          top: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      /*maxY:(target_index == 0
                            ? getBarMaxData("male", _selectedButton,
                            customers_index, grid_index, days_difference)
                            : getBarMaxClaimsData(
                            "male",
                            _selectedButton,
                            customers_index,
                            grid_index,
                            days_difference)) +
                            5*/
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.20),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      barGroups: barGroups,
                      groupsSpace: 10, // Adjust space between bar groups
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (value) {
                            return Colors.blueGrey;
                          },
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            if (rod.toY == 0) {
                              return null; // Don't show tooltip for values of 0
                            }
                            return BarTooltipItem(
                              rod.toY.toString(),
                              const TextStyle(color: Colors.black),
                            );
                          },
                        ),
                        touchCallback: (FlTouchEvent flTouchEvent,
                            BarTouchResponse? touchResponse) {},
                        handleBuiltInTouches: false,
                      ),
                    ),
                  ),
                ),
              if (target_index_7 == 0)
                Container(
                    height: 320,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: lines,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.round().toString(),
                                  style: TextStyle(fontSize: 11),
                                );
                              },
                            ),
                            /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: false, reservedSize: 30),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 8.5),
                                );
                              },
                            ),
                            /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (value) {
                              return Colors.blueGrey;
                            },
                          ),
                          //touchCallback: (FlTouchEvent flTouchEvent,LineTouchResponse touchResponse) {},
                          handleBuiltInTouches: false,
                        ),
                        minX: 0,
                        maxX: 100,
                        extraLinesData: ExtraLinesData(
                          /*   horizontalLines: [
                                      if (spots != null)
                                        HorizontalLine(
                                          y: spots.mean_hor,
                                          color: Colors.red,
                                          strokeWidth: 1,
                                          dashArray: [5, 5],
                                        ),
                                    ],*/
                          verticalLines: [
                            if (spots != null)
                              VerticalLine(
                                x: spots.mean_hor,
                                color: Colors.blue,
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              ),
                          ],
                        ),
                      ),
                    )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: MemberTypeGrid3(),
          )
        ],
      ),
    );
  }
}

class ClaimsAgesDistChildBellCurveChart extends StatelessWidget {
  final int Selected_Button;
  final int days_difference;
  final int customers_index;
  final int target_index_7;

  ClaimsAgesDistChildBellCurveChart({
    Key? key,
    required this.Selected_Button,
    required this.days_difference,
    required this.customers_index,
    required this.target_index_7,
  }) : super(key: key);
//The graph is not skewed.
  @override
  Widget build(BuildContext context) {
    List<String> ageGroups = [
      "0-10",
      "11-20",
      "21-30",
      "31-40",
      "41-50",
      "51-60",
      "61-70",
      "71-80",
      "81-90",
      "91-100",
      "101-110",
      "111-120"
    ];
    List<BarChartGroupData> barGroups = [];
    Map<String, dynamic> data = {};
    List<double> all_ages = [];
    if (Selected_Button == 1) {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_1a_1;
        all_ages = Constants.claims_age_distribution_lists_1a_3_1;
      } else if (customers_index == 1) {
        data = Constants.claims_age_distribution_by_gender_and_type_1a_2;
        all_ages = Constants.claims_age_distribution_lists_1a_3_2;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_1a_3;
        all_ages = Constants.claims_age_distribution_lists_1a_3_3;
      }
    } else if (Selected_Button == 2) {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_2a_1;
        all_ages = Constants.claims_age_distribution_lists_2a_3_1;
      } else if (customers_index == 1) {
        data = Constants.claims_age_distribution_by_gender_and_type_2a_2;
        all_ages = Constants.claims_age_distribution_lists_2a_3_2;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_2a_3;
        all_ages = Constants.claims_age_distribution_lists_2a_3_3;
      }
    } else if (Selected_Button == 3 && days_difference < 31) {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_3a_1;
        all_ages = Constants.claims_age_distribution_lists_3a_3_1;
      } else if (customers_index == 1) {
        data = Constants.claims_age_distribution_by_gender_and_type_3a_2;
        all_ages = Constants.claims_age_distribution_lists_3a_3_2;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_3a_3;
        all_ages = Constants.claims_age_distribution_lists_3a_3_3;
      }
    } else {
      if (customers_index == 0) {
        data = Constants.claims_age_distribution_by_gender_and_type_3b_1;
        all_ages = Constants.claims_age_distribution_lists_3b_3_1;
      } else if (customers_index == 1) {
        data = Constants.claims_age_distribution_by_gender_and_type_3b_2;
        all_ages = Constants.claims_age_distribution_lists_3b_3_2;
      } else if (customers_index == 2) {
        data = Constants.claims_age_distribution_by_gender_and_type_3b_2;
        all_ages = Constants.claims_age_distribution_lists_3b_3_2;
      }
    }
    flypes? spots = generateSkewedSpots2(
      all_ages,
    );
    if (all_ages.length == 0) {
      return Container(
        child: Center(
            child: Text(
          "No data available for the selected range",
          style: TextStyle(color: Colors.grey.withOpacity(0.55)),
        )),
      );
    } else {
      if (kDebugMode) {
        //print("hggghjhj0 ${all_ages}");
      }
    }
    //print("dgdsjhsdhjk1 ${spots!.mean_hor}");

    // Simplified conditional addition of LineChartBarData
    List<LineChartBarData> lines = [];
    if (all_ages.length == 0) {
      return Container(
        child: Center(
            child: Text(
          "No data available for the selected range",
          style: TextStyle(color: Colors.grey.withOpacity(0.55)),
        )),
      );
    } else {
      if (kDebugMode) {
        print("hggghjhj0 ${all_ages}");
      }
    }
    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.purple,
        dotData: FlDotData(show: false),
      ));
    }

    barGroups = List.generate(ageGroups.length, (index) {
      final ageRange = ageGroups[index];
      final maleFrequency = data["child"]["male"]![ageRange]!.toDouble();
      final femaleFrequency = data["child"]["female"]![ageRange]!.toDouble();
      double totalFrequency = maleFrequency + femaleFrequency;
      int numberOfBars = 9;
      double chartWidth = MediaQuery.of(context).size.width;
      double maxBarWidth = 30; // Maximum width of a bar
      double minBarSpace = 10; // Minimum space between bars

      double barWidth = min(maxBarWidth, (chartWidth / (2 * numberOfBars)));

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalFrequency,
            color: Colors.grey,
            width: barWidth,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
        barsSpace: minBarSpace,
      );
    });
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Column(
        children: [
          Stack(
            children: [
              if (target_index_7 == 1)
                Container(
                  height: 320,
                  child: BarChart(
                    BarChartData(
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                ageGroups[value.round()].toString(),
                                style: TextStyle(fontSize: 7),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false, reservedSize: 30),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                formatLargeNumber3(value.round().toString()),
                                style: TextStyle(fontSize: 8.5),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(color: Colors.grey, width: 1),
                          right: BorderSide(color: Colors.transparent),
                          bottom: BorderSide(color: Colors.transparent),
                          top: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      /*maxY:(target_index == 0
                            ? getBarMaxData("male", _selectedButton,
                            customers_index, grid_index, days_difference)
                            : getBarMaxClaimsData(
                            "male",
                            _selectedButton,
                            customers_index,
                            grid_index,
                            days_difference)) +
                            5*/
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.20),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      barGroups: barGroups,
                      groupsSpace: 10, // Adjust space between bar groups
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (value) {
                            return Colors.blueGrey;
                          },
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            if (rod.toY == 0) {
                              return null; // Don't show tooltip for values of 0
                            }
                            return BarTooltipItem(
                              rod.toY.toString(),
                              const TextStyle(color: Colors.black),
                            );
                          },
                        ),
                        touchCallback: (FlTouchEvent flTouchEvent,
                            BarTouchResponse? touchResponse) {},
                        handleBuiltInTouches: false,
                      ),
                    ),
                  ),
                ),
              if (target_index_7 == 0)
                Container(
                    height: 320,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: lines,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.round().toString(),
                                  style: TextStyle(fontSize: 11),
                                );
                              },
                            ),
                            /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: false, reservedSize: 30),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toStringAsFixed(2),
                                  style: TextStyle(fontSize: 8.5),
                                );
                              },
                            ),
                            /*axisNameWidget: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(top: 0.0),
                                                                                child: Text(
                                                                                  'Sales',
                                                                                  style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.black),
                                                                                ),
                                                                              ),*/
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (value) {
                              return Colors.blueGrey;
                            },
                          ),
                          //touchCallback: (FlTouchEvent flTouchEvent,LineTouchResponse touchResponse) {},
                          handleBuiltInTouches: false,
                        ),
                        minX: 0,
                        maxX: 100,
                        extraLinesData: ExtraLinesData(
                          /*   horizontalLines: [
                                      if (spots != null)
                                        HorizontalLine(
                                          y: spots.mean_hor,
                                          color: Colors.red,
                                          strokeWidth: 1,
                                          dashArray: [5, 5],
                                        ),
                                    ],*/
                          verticalLines: [
                            if (spots != null)
                              VerticalLine(
                                x: spots.mean_hor,
                                color: Colors.blue,
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              ),
                          ],
                        ),
                      ),
                    )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: target_index_7 == 0 ? MemberTypeGrid3() : MemberTypeGrid3a(),
          )
        ],
      ),
    );
  }
}

class SalesBellCurveChart2 extends StatelessWidget {
  final Map<String, List<dynamic>> all_ages;

  SalesBellCurveChart2({Key? key, required this.all_ages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print("dgdsjhsdhjk1 ${all_ages["main_member"]}");
    //print("dgdsjhsdhjk2 ${all_ages["partner"]}");
    //print("dgdsjhsdhjk3 ${all_ages["extended_family"]}");
    //print("dgdsjhsdhjk4 ${all_ages["child"]}");
    flypes? spots = generateSkewedSpots(
      all_ages["main_member"] ?? [],
    );
    flypes? spots2 = generateSkewedSpots(all_ages["partner"] ?? []);
    flypes? spots3 = generateSkewedSpots(all_ages["extended_family"] ?? []);
    flypes? spots4 = generateSkewedSpots(all_ages["child"] ?? []);
    if (all_ages.length == 0) {
      return Container(
        child: Center(
            child: Text(
          "No data available for the selected range",
          style: TextStyle(color: Colors.grey.withOpacity(0.55)),
        )),
      );
    } else {
      if (kDebugMode) {
        //print("hggghjhj7 ${all_ages}");
      }
    }

    // Simplified conditional addition of LineChartBarData
    List<LineChartBarData> lines = [];

    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.blue,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots2 != null) {
      lines.add(LineChartBarData(
        spots: spots2.flspots,
        isCurved: true,
        color: Colors.orange,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots3 != null) {
      lines.add(LineChartBarData(
        spots: spots3.flspots,
        isCurved: true,
        color: Colors.green,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots4 != null) {
      lines.add(LineChartBarData(
        spots: spots4.flspots,
        isCurved: true,
        color: Colors.purple,
        dotData: FlDotData(show: false),
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                  height: 320,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: lines,
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.round().toString(),
                                style: TextStyle(fontSize: 11),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 0.0),
                                                                        child: Text(
                                                                          'Sales',
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),*/
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false, reservedSize: 30),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              bool shouldShowTitle = value % 1 == 0;
                              return Text(
                                formatLargeNumber3(value.round().toString()),
                                style: TextStyle(fontSize: 8.5),
                              );
                            },
                          ),
                          /*axisNameWidget: Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 0.0),
                                                                        child: Text(
                                                                          'Sales',
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),*/
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (value) {
                            return Colors.blueGrey;
                          },
                        ),
                        //touchCallback: (FlTouchEvent flTouchEvent,LineTouchResponse touchResponse) {},
                        handleBuiltInTouches: false,
                      ),
                      minX: 0,
                      maxX: 100,
                      extraLinesData: ExtraLinesData(
                        /*   horizontalLines: [
                              if (spots != null)
                                HorizontalLine(
                                  y: spots.mean_hor,
                                  color: Colors.red,
                                  strokeWidth: 1,
                                  dashArray: [5, 5],
                                ),
                            ],*/
                        verticalLines: [
                          if (spots != null)
                            VerticalLine(
                              x: spots.mean_hor,
                              color: Colors.blue,
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            ),
                          if (spots2 != null)
                            VerticalLine(
                              x: spots2.mean_hor,
                              color: Colors.orange,
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            ),
                          if (spots3 != null)
                            VerticalLine(
                              x: spots3.mean_hor,
                              color: Colors.green,
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            ),
                          if (spots4 != null)
                            VerticalLine(
                              x: spots4.mean_hor,
                              color: Colors.purple,
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            ),
                        ],
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: MemberTypeGrid(),
              )
            ],
          ),
        ],
      ),
    );
  }
}

/*class ClaimsBellCurveChart extends StatelessWidget {
  final List<int> ages;

  ClaimsBellCurveChart({Key? key, required this.ages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ages.length < 2) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomCard(
          surfaceTintColor: Colors.white,
          color: Colors.white,
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              child: Center(
                child: Text(
                  "No data available",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final mean = ages.reduce((a, b) => a + b) / ages.length;
    final stdDev = sqrt(
        ages.fold(0.0, (prev, next) => prev + pow(next - mean, 2)) /
            ages.length);

    double gaussian(double x) {
      return (1 / (stdDev * sqrt(2 * pi))) *
          exp(-pow(x - mean, 2) / (2 * pow(stdDev, 2)));
    }

    List<FlSpot> spots = List.generate(200, (i) {
      final x = mean - 4 * stdDev + (8 * stdDev / 199) * i;

      if (x < 0) {
        return FlSpot(0, 0);
      } else if (x > 100) {
        return FlSpot(105, 0);
      } else {
        return FlSpot(x, gaussian(x));
      }
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomCard(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              height: 250,
              child: Column(
                children: [
                  LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.blue,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: false,
                            color: Constants.ctaColorLight.withOpacity(0.1),
                          ),
                        ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.round().toString(),
                                style: TextStyle(fontSize: 11),
                              );
                            },
                          ),
                          */
/*axisNameWidget: Padding(
                                                                    padding:
                                                                        const EdgeInsets.only(top: 0.0),
                                                                    child: Text(
                                                                      'Sales',
                                                                      style: TextStyle(
                                                                          fontSize: 11,
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Colors.black),
                                                                    ),
                                                                  ),*/
/*
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            reservedSize: 20,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text("");
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false, reservedSize: 30),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toStringAsFixed(2),
                                style: TextStyle(fontSize: 8.5),
                              );
                            },
                          ),
                          */
/*axisNameWidget: Padding(
                                                                    padding:
                                                                        const EdgeInsets.only(top: 0.0),
                                                                    child: Text(
                                                                      'Sales',
                                                                      style: TextStyle(
                                                                          fontSize: 11,
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Colors.black),
                                                                    ),
                                                                  ),*/
/*
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                           getTooltipColor:(value){
                                                                                  return Colors.blueGrey;
                                                                                },
                        ),
                        //touchCallback: (FlTouchEvent flTouchEvent,LineTouchResponse touchResponse) {},
                        handleBuiltInTouches: false,
                      ),
                      minX: 0,
                      maxX: 100,
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: gaussian(mean),
                            color: Colors.red,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          ),
                        ],
                        verticalLines: [
                          VerticalLine(
                            x: mean,
                            color: Colors.green,
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}*/

flypes? generateGaussianSpots(List<dynamic> data) {
  List<double> ages = data.map((item) {
    try {
      return double.parse(item.toString());
    } catch (e) {
      print("Error converting to double: $e");
      return 0.0; // Default value in case of parsing error
    }
  }).toList();

  if (ages.length <= 2) {
    return null;
  }

  double mean = ages.reduce((a, b) => a + b) / ages.length;
  double stdDev = sqrt(
      ages.fold(0.0, (prev, next) => prev + pow(next - mean, 2)) / ages.length);

  double gaussian(double x) {
    return (1 / (stdDev * sqrt(2 * pi))) *
        exp(-pow(x - mean, 2) / (2 * pow(stdDev, 2)));
  }

  return flypes(
      List.generate(200, (i) {
        final x = mean - 4 * stdDev + (8 * stdDev / 199) * i;
        if (x < 0 || x > 100) {
          return null;
        } else {
          return FlSpot(x, gaussian(x));
        }
      }).whereType<FlSpot>().toList(),
      mean);
}

class MemberTypeGrid extends StatelessWidget {
  final List<CustomersTypGridItem> reprintTypes = [
    CustomersTypGridItem('Main', Colors.blue),
    CustomersTypGridItem('Partner', Colors.orange),
    CustomersTypGridItem('Child', Colors.purple),
    CustomersTypGridItem('Extended', Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 2.5,
        ),
        itemCount: reprintTypes.length,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center, // Center the contents
            child: Row(
              mainAxisSize: MainAxisSize
                  .min, // Use the minimum space that the row can take.
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(360),
                    color: reprintTypes[index].color,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  reprintTypes[index].type,
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MemberTypeGrid1 extends StatelessWidget {
  final List<CustomersTypGridItem> reprintTypes = [
    CustomersTypGridItem('Main Member', Colors.blue),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Container(
        alignment: Alignment.center, // Center the contents
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Use the minimum space that the row can take.
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                color: reprintTypes[0].color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              reprintTypes[0].type,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemberTypeGrid1a extends StatelessWidget {
  final List<CustomersTypGridItem> reprintTypes = [
    CustomersTypGridItem('Main Member', Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Container(
        alignment: Alignment.center, // Center the contents
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Use the minimum space that the row can take.
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                color: reprintTypes[0].color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              reprintTypes[0].type,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemberTypeGrid2 extends StatelessWidget {
  final List<CustomersTypGridItem> reprintTypes = [
    CustomersTypGridItem('Partner', Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Container(
        alignment: Alignment.center, // Center the contents
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Use the minimum space that the row can take.
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                color: reprintTypes[0].color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              reprintTypes[0].type,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemberTypeGrid2a extends StatelessWidget {
  final List<CustomersTypGridItem> reprintTypes = [
    CustomersTypGridItem('Partner', Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Container(
        alignment: Alignment.center, // Center the contents
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Use the minimum space that the row can take.
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                color: reprintTypes[0].color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              reprintTypes[0].type,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemberTypeGrid3 extends StatelessWidget {
  final List<CustomersTypGridItem> reprintTypes = [
    CustomersTypGridItem('Child', Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Container(
        alignment: Alignment.center, // Center the contents
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Use the minimum space that the row can take.
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                color: reprintTypes[0].color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              reprintTypes[0].type,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemberTypeGrid3a extends StatelessWidget {
  final List<CustomersTypGridItem> reprintTypes = [
    CustomersTypGridItem('Child', Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Container(
        alignment: Alignment.center, // Center the contents
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Use the minimum space that the row can take.
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                color: reprintTypes[0].color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              reprintTypes[0].type,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomersTypGridItem {
  final String type;
  final Color color;

  CustomersTypGridItem(this.type, this.color);
}

class flypes {
  final List<FlSpot> flspots;
  final double mean_hor;

  flypes(this.flspots, this.mean_hor);
}

flypes? generateSkewedSpots(List<dynamic> data) {
  if (data.isEmpty) {
    return null;
  }
  //print("smo $data");
  List<double> ages = data.map((item) {
    try {
      return double.parse(item.toString());
    } catch (e) {
      print("Error converting to double: $e");
      return 0.0; // Default value in case of parsing error
    }
  }).toList();

  if (ages.length <= 2) {
    return null; // Return null if there are not enough data points
  } else {
    ages.sort();
  }

  double mean = ages.reduce((a, b) => a + b) / ages.length;
  double stdDev = sqrt(
      ages.fold(0.0, (prev, next) => prev + pow(next - mean, 2)) /
          (ages.length - 1));

  double gaussian(double x) {
    return (1 / (stdDev * sqrt(2 * pi))) *
        exp(-pow(x - mean, 2) / (2 * pow(stdDev, 2)));
  }

  // Generate points for the Gaussian curve
  List<FlSpot> spots = List.generate(200, (i) {
    final x = mean - 4 * stdDev + (8 * stdDev / 199) * i;
    if (x < 0 || x > 100) {
      return null;
    } else {
      return FlSpot(x, gaussian(x));
    }
  }).whereType<FlSpot>().toList();

  return spots.isNotEmpty
      ? flypes(spots, mean)
      : null; // Return null if no valid spots
}

flypes? generateSkewedSpots2(List<dynamic> data) {
  if (data.isEmpty) {
    return null;
  }
  List<double> ages = data.map((item) {
    try {
      return double.parse(item.toString());
    } catch (e) {
      print("Error converting to double: $e");
      return 0.0; // Default value in case of parsing error
    }
  }).toList();
  ages.sort();

  if (ages.length <= 2) {
    return null; // Return null if there are not enough data points
  }

  double mean = ages.reduce((a, b) => a + b) / ages.length;
  double stdDev = sqrt(
      ages.fold(0.0, (prev, next) => prev + pow(next - mean, 2)) /
          (ages.length - 1));

  // Calculate skewness
  double skewness =
      ages.fold(0.0, (prev, next) => prev + pow(next - mean, 3)) / ages.length;
  skewness /= pow(stdDev, 3);
  skewness *= (ages.length / ((ages.length - 1) * (ages.length - 2)));

  double gaussian(double x) {
    return (1 / (stdDev * sqrt(2 * pi))) *
        exp(-pow(x - mean, 2) / (2 * pow(stdDev, 2)));
  }

  // Use skewness to adjust the distribution; this is a conceptual adjustment
  double adjustForSkewness(double x) {
    // Simple non-linear transformation based on skewness sign
    return x + skewness * 0.1; // This is a heuristic adjustment
  }

  List<FlSpot> spots = List.generate(200, (i) {
    final x = mean - 4 * stdDev + (8 * stdDev / 199) * i;
    final adjustedX = adjustForSkewness(x); // Adjust x based on skewness
    if (adjustedX < 0 || adjustedX > 100) {
      return null;
    } else {
      return FlSpot(adjustedX, gaussian(x));
    }
  }).whereType<FlSpot>().toList();

  return spots.isNotEmpty
      ? flypes(spots, mean)
      : null; // Return null if no valid spots
}

class AgesDistBellCurveChart extends StatelessWidget {
  final int targetIndex;
  final int selectedButton;
  final int customersIndex;
  final int gridIndex;
  final int daysDifference;

  AgesDistBellCurveChart({
    Key? key,
    this.targetIndex = 0,
    this.selectedButton = 1,
    this.customersIndex = 0,
    this.gridIndex = 1,
    this.daysDifference = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get customer profile from Constants
    final CustomerProfile? customerProfile = Constants.currentCustomerProfile;

    if (customerProfile == null) {
      return Container(
        height: 320,
        child: Center(
          child: Text('No customer data available'),
        ),
      );
    }

    // Extract age distribution data from CustomerProfile
    Map<String, List<dynamic>> allAges =
        _extractAgeDistributionData(customerProfile);

    print("dgdsjhsdhjk1 ${allAges["main_member"]}");
    print("dgdsjhsdhjk2 ${allAges["partner"]}");
    print("dgdsjhsdhjk3 ${allAges["extended_family"]}");
    print("dgdsjhsdhjk4 ${allAges["child"]}");

    // Generate spots for different member types
    flypes? spots = generateSkewedSpots(allAges["main_member"] ?? []);
    flypes? spots2 = generateSkewedSpots(allAges["partner"] ?? []);
    flypes? spots3 = generateSkewedSpots(allAges["extended_family"] ?? []);
    flypes? spots4 = generateSkewedSpots(allAges["child"] ?? []);

    // Build line chart data
    List<LineChartBarData> lines =
        _buildLineChartData(spots, spots2, spots3, spots4);

    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 24, top: 12),
      child: Column(
        children: [
          Stack(
            children: [
              if (target_index_7 == 1)
                _buildLineChart(lines, spots, spots2, spots3, spots4),
              if (target_index_7 == 0) _buildBarChart(customerProfile),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: MemberTypeGrid(),
          )
        ],
      ),
    );
  }

  Map<String, List<dynamic>> _extractAgeDistributionData(
      CustomerProfile customerProfile) {
    // Extract age distribution data based on target index (customers vs claims)
    if (targetIndex == 0) {
      // Customer data - you'll need to add age distribution lists to CustomerProfile
      // For now, using dummy data structure - update based on your actual data structure
      return {
        "main_member": _getMainMemberAges(customerProfile),
        "partner": _getPartnerAges(customerProfile),
        "extended_family": _getExtendedFamilyAges(customerProfile),
        "child": _getChildAges(customerProfile),
      };
    } else {
      // Claims data
      return {
        "main_member": _getClaimsMainMemberAges(customerProfile),
        "partner": _getClaimsPartnerAges(customerProfile),
        "extended_family": _getClaimsExtendedFamilyAges(customerProfile),
        "child": _getClaimsChildAges(customerProfile),
      };
    }
  }

  List<dynamic> _getMainMemberAges(CustomerProfile profile) {
    // Extract main member ages from the profile
    // You'll need to add age_distribution_lists to your CustomerProfile model
    // For now, calculating from main_member_ages
    List<int> ages = [];
    profile.mainMemberAges.forEach((ageRange, memberGroup) {
      // Extract age from range like "21-30" -> use middle value 25
      List<String> rangeParts = ageRange.split('-');
      if (rangeParts.length == 2) {
        int startAge = int.tryParse(rangeParts[0]) ?? 0;
        int endAge = int.tryParse(rangeParts[1]) ?? 0;
        int middleAge = ((startAge + endAge) / 2).round();

        // Add age for each main member in this range
        for (int i = 0; i < memberGroup.mainMember; i++) {
          ages.add(middleAge);
        }
      }
    });
    return ages;
  }

  List<dynamic> _getPartnerAges(CustomerProfile profile) {
    List<int> ages = [];
    profile.mainMemberAges.forEach((ageRange, memberGroup) {
      List<String> rangeParts = ageRange.split('-');
      if (rangeParts.length == 2) {
        int startAge = int.tryParse(rangeParts[0]) ?? 0;
        int endAge = int.tryParse(rangeParts[1]) ?? 0;
        int middleAge = ((startAge + endAge) / 2).round();

        for (int i = 0; i < memberGroup.partner; i++) {
          ages.add(middleAge);
        }
      }
    });
    return ages;
  }

  List<dynamic> _getExtendedFamilyAges(CustomerProfile profile) {
    // Extended family data - implement based on your data structure
    return [];
  }

  List<dynamic> _getChildAges(CustomerProfile profile) {
    List<int> ages = [];
    profile.mainMemberAges.forEach((ageRange, memberGroup) {
      List<String> rangeParts = ageRange.split('-');
      if (rangeParts.length == 2) {
        int startAge = int.tryParse(rangeParts[0]) ?? 0;
        int endAge = int.tryParse(rangeParts[1]) ?? 0;
        int middleAge = ((startAge + endAge) / 2).round();

        for (int i = 0; i < memberGroup.child; i++) {
          ages.add(middleAge);
        }
      }
    });
    return ages;
  }

  List<dynamic> _getClaimsMainMemberAges(CustomerProfile profile) {
    // Extract claims age data - implement based on your claims data structure
    return profile.deceasedAgesList; // Using deceased ages as example
  }

  List<dynamic> _getClaimsPartnerAges(CustomerProfile profile) {
    // Claims partner ages - implement based on your data structure
    return [];
  }

  List<dynamic> _getClaimsExtendedFamilyAges(CustomerProfile profile) {
    // Claims extended family ages - implement based on your data structure
    return [];
  }

  List<dynamic> _getClaimsChildAges(CustomerProfile profile) {
    // Claims child ages - implement based on your data structure
    return [];
  }

  List<LineChartBarData> _buildLineChartData(
    flypes? spots,
    flypes? spots2,
    flypes? spots3,
    flypes? spots4,
  ) {
    List<LineChartBarData> lines = [];

    if (spots != null) {
      lines.add(LineChartBarData(
        spots: spots.flspots,
        isCurved: true,
        color: Colors.blue,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots2 != null) {
      lines.add(LineChartBarData(
        spots: spots2.flspots,
        isCurved: true,
        color: Colors.orange,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots3 != null) {
      lines.add(LineChartBarData(
        spots: spots3.flspots,
        isCurved: true,
        color: Colors.green,
        dotData: FlDotData(show: false),
      ));
    }
    if (spots4 != null) {
      lines.add(LineChartBarData(
        spots: spots4.flspots,
        isCurved: true,
        color: Colors.purple,
        dotData: FlDotData(show: false),
      ));
    }

    return lines;
  }

  Widget _buildLineChart(
    List<LineChartBarData> lines,
    flypes? spots,
    flypes? spots2,
    flypes? spots3,
    flypes? spots4,
  ) {
    return Container(
      height: 320,
      child: LineChart(
        LineChartData(
          lineBarsData: lines,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.round().toString(),
                    style: TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 30),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: TextStyle(fontSize: 8.5),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (value) {
                return Colors.blueGrey;
              },
            ),
            handleBuiltInTouches: false,
          ),
          minX: 0,
          maxX: 100,
          extraLinesData: ExtraLinesData(
            verticalLines: [
              if (spots != null)
                VerticalLine(
                  x: spots.mean_hor,
                  color: Colors.blue,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              if (spots2 != null)
                VerticalLine(
                  x: spots2.mean_hor,
                  color: Colors.orange,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              if (spots3 != null)
                VerticalLine(
                  x: spots3.mean_hor,
                  color: Colors.green,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              if (spots4 != null)
                VerticalLine(
                  x: spots4.mean_hor,
                  color: Colors.purple,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(CustomerProfile customerProfile) {
    return Container(
      height: 320,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BarChart(
          BarChartData(
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  interval: 1,
                  reservedSize: 60,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        value.toString(),
                        style: TextStyle(fontSize: 9),
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 45,
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    // Get age ranges from CustomerProfile instead of Constants
                    List<String> ageRanges =
                        customerProfile.mainMemberAges.keys.toList();
                    if (value.round() < ageRanges.length) {
                      return RotatedBox(
                        quarterTurns: 3,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationZ(pi),
                          child: Text(
                            ageRanges[value.round()],
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    // Calculate maxY from CustomerProfile data
                    double maxY =
                        _calculateMaxYFromProfile(customerProfile) + 5;

                    if (value == maxY) {
                      return RotatedBox(
                        quarterTurns: 3,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationZ(pi),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Text(
                              formatLargeNumber3(value.toInt().toString()) +
                                  "%",
                              style: TextStyle(fontSize: 9),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  getTitlesWidget: (value, meta) {
                    return Text(value.toInt().toString());
                  },
                ),
                axisNameWidget: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: RotatedBox(
                    quarterTurns: 4,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationZ(pi),
                      child: Text(
                        'Males',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(color: Colors.grey, width: 1),
                right: BorderSide(color: Colors.transparent),
                bottom: BorderSide(color: Colors.transparent),
                top: BorderSide(color: Colors.transparent),
              ),
            ),
            maxY: _calculateMaxYFromProfile(customerProfile) + 5,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.20),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                );
              },
            ),
            barGroups: _getBarGroupDataFromProfile(customerProfile),
            groupsSpace: 10,
            alignment: BarChartAlignment.spaceAround,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (value) {
                  return Colors.blueGrey;
                },
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  if (rod.toY == 0) {
                    return null;
                  }
                  return BarTooltipItem(
                    rod.toY.toString(),
                    const TextStyle(color: Colors.black),
                  );
                },
              ),
              touchCallback: (FlTouchEvent flTouchEvent,
                  BarTouchResponse? touchResponse) {},
              handleBuiltInTouches: false,
            ),
          ),
        ),
      ),
    );
  }

  double _calculateMaxYFromProfile(CustomerProfile customerProfile) {
    // Calculate maximum Y value from customer profile data
    if (targetIndex == 0) {
      // Customer data
      final genderTotals = customerProfile.genderDistribution.totals;
      return genderTotals.malePercentage > genderTotals.femalePercentage
          ? genderTotals.malePercentage * 100
          : genderTotals.femalePercentage * 100;
    } else {
      // Claims data
      final claimsGenderTotals = customerProfile.claimsData.genderTotals;
      return claimsGenderTotals.malePercentage >
              claimsGenderTotals.femalePercentage
          ? claimsGenderTotals.malePercentage * 100
          : claimsGenderTotals.femalePercentage * 100;
    }
  }

  List<BarChartGroupData> _getBarGroupDataFromProfile(
      CustomerProfile customerProfile) {
    List<BarChartGroupData> barGroups = [];

    // Create bar groups from customer profile data
    int index = 0;
    customerProfile.mainMemberAges.forEach((ageRange, memberGroup) {
      double malePercentage =
          _calculateMalePercentageForAgeGroup(customerProfile, ageRange);
      double femalePercentage =
          _calculateFemalePercentageForAgeGroup(customerProfile, ageRange);

      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: targetIndex == 0 ? malePercentage : femalePercentage,
              color: targetIndex == 0 ? Colors.blue : Colors.pink,
              width: 16,
            ),
          ],
        ),
      );
      index++;
    });

    return barGroups;
  }

  double _calculateMalePercentageForAgeGroup(
      CustomerProfile customerProfile, String ageRange) {
    // Calculate male percentage for specific age group from gender distribution
    final ageGenderData =
        customerProfile.genderDistribution.ageGroups[ageRange];
    if (ageGenderData != null && ageGenderData.total > 0) {
      return (ageGenderData.male / ageGenderData.total) * 100;
    }
    return 0.0;
  }

  double _calculateFemalePercentageForAgeGroup(
      CustomerProfile customerProfile, String ageRange) {
    // Calculate female percentage for specific age group from gender distribution
    final ageGenderData =
        customerProfile.genderDistribution.ageGroups[ageRange];
    if (ageGenderData != null && ageGenderData.total > 0) {
      return (ageGenderData.female / ageGenderData.total) * 100;
    }
    return 0.0;
  }
}
