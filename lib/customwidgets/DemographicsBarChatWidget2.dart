import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../models/CustomerProfile.dart';
import 'CustomCard.dart';

class DemographicsBarChartWidget2 extends StatelessWidget {
  final CustomerProfile customerProfile;
  final int selectedButton;
  final int targetIndex;
  final int customersIndex;
  final int gridIndex;
  final int daysDifference;

  const DemographicsBarChartWidget2({
    Key? key,
    required this.customerProfile,
    required this.selectedButton,
    required this.targetIndex,
    required this.customersIndex,
    required this.gridIndex,
    required this.daysDifference,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 370,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 12.0, top: 8, right: 16, bottom: 12),
        child: CustomCard(
          surfaceTintColor: Colors.white,
          color: Colors.white,
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.only(left: 36.0, right: 36.0, top: 12),
            child: _hasBarChartData()
                ? Row(
                    children: [
                      // Male Bar Chart
                      Expanded(
                          child: RotatedBox(
                              quarterTurns: 3,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationZ(0),
                                child: BarChart(
                                  BarChartData(
                                    barTouchData: BarTouchData(
                                      enabled: true,
                                      touchTooltipData: BarTouchTooltipData(
                                        // tooltipBgColor: Colors.black87,
                                        tooltipRoundedRadius: 4,
                                        getTooltipItem:
                                            (group, groupIndex, rod, rodIndex) {
                                          return BarTooltipItem(
                                            '${_getAgeRangeLabel(group.x.toInt())}\n${rod.toY.toStringAsFixed(2)}%',
                                            TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          reservedSize: 45,
                                          showTitles: true,
                                          interval: 1,
                                          getTitlesWidget: (value, meta) {
                                            return RotatedBox(
                                                quarterTurns: 3,
                                                child: Transform(
                                                  alignment: Alignment.center,
                                                  transform: Matrix4.rotationZ(
                                                      math.pi),
                                                  child: Text(
                                                    _getAgeRangeLabel(
                                                        value.round()),
                                                    style:
                                                        TextStyle(fontSize: 9),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          reservedSize: 45,
                                          showTitles: false,
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: 20,
                                          getTitlesWidget: (value, meta) {
                                            // Show percentage labels at intervals
                                            if (value % 20 == 0) {
                                              return RotatedBox(
                                                  quarterTurns: 3,
                                                  child: Transform(
                                                    alignment: Alignment.center,
                                                    transform:
                                                        Matrix4.rotationZ(
                                                            math.pi),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 2.0),
                                                      child: Text(
                                                        "${value.toInt()}%",
                                                        style: TextStyle(
                                                            fontSize: 8),
                                                      ),
                                                    ),
                                                  ));
                                            }
                                            return SizedBox.shrink();
                                          },
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                          axisNameWidget: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 48.0),
                                              child: RotatedBox(
                                                quarterTurns: 4,
                                                child: Transform(
                                                  alignment: Alignment.center,
                                                  transform: Matrix4.rotationZ(
                                                      math.pi),
                                                  child: Text(
                                                    'Male',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ))),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.grey, width: 1),
                                        right: BorderSide(
                                            color: Colors.transparent),
                                        bottom: BorderSide(
                                            color: Colors.transparent),
                                        top: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                    maxY: 100, // Fixed max at 100%
                                    minY: 0,
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                      drawHorizontalLine: true,
                                      horizontalInterval: 20,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: Colors.grey.withOpacity(0.20),
                                          strokeWidth: 1,
                                        );
                                      },
                                    ),
                                    barGroups: _getBarChartData("male"),
                                    groupsSpace: 10,
                                    alignment: BarChartAlignment.spaceAround,
                                  ),
                                ),
                              ))),
                      // Female Bar Chart
                      Expanded(
                          child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: BarChart(
                            BarChartData(
                              titlesData: FlTitlesData(
                                show: true,
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 20,
                                    getTitlesWidget: (value, meta) {
                                      // Show percentage labels at intervals
                                      if (value % 20 == 0) {
                                        return RotatedBox(
                                          quarterTurns: 1,
                                          child: Transform(
                                            alignment: Alignment.center,
                                            transform:
                                                Matrix4.rotationY(math.pi),
                                            child: Text(
                                              "${value.toInt()}%",
                                              style: TextStyle(fontSize: 8),
                                            ),
                                          ),
                                        );
                                      }
                                      return SizedBox.shrink();
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                  axisNameWidget: Padding(
                                    padding: const EdgeInsets.only(right: 44.0),
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationX(math.pi),
                                      child: Text(
                                        'Female',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  left:
                                      BorderSide(color: Colors.grey, width: 1),
                                  right: BorderSide(color: Colors.transparent),
                                  bottom: BorderSide(color: Colors.transparent),
                                  top: BorderSide(color: Colors.transparent),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 20,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey.withOpacity(0.20),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              maxY: 100, // Fixed max at 100%
                              minY: 0,
                              barGroups: _getBarChartData("female"),
                              groupsSpace: 10,
                              alignment: BarChartAlignment.spaceAround,
                            ),
                          ),
                        ),
                      )),
                    ],
                  )
                : Container(
                    height: 250,
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
          ),
        ),
      ),
    );
  }

  // Helper methods

  bool _hasBarChartData() {
    if (customerProfile.isEmpty) {
      return false;
    }

    final maleData = _getBarChartData("male");
    final femaleData = _getBarChartData("female");

    return maleData.isNotEmpty && femaleData.isNotEmpty;
  }

  List<BarChartGroupData> _getBarChartData(String type) {
    if (targetIndex == 0) {
      return _getBarGroupData(type);
    } else {
      return _getBarGroupClaimsData(type);
    }
  }

  String _getAgeRangeLabel(int index) {
    List<String> ageGroups = [
      '0-10',
      '11-20',
      '21-30',
      '31-40',
      '41-50',
      '51-60',
      '61-70',
      '71-80',
      '81-90',
      '91-100',
      '101-110',
      '111-120'
    ];

    if (index >= 0 && index < ageGroups.length) {
      return ageGroups[index];
    }
    return '';
  }

  String _formatLargeNumber3(String number) {
    int num = int.tryParse(number) ?? 0;
    if (num >= 1000000) {
      return "${(num / 1000000).toStringAsFixed(1)}M";
    } else if (num >= 1000) {
      return "${(num / 1000).toStringAsFixed(1)}K";
    }
    return num.toString();
  }

  // Data retrieval methods

  List<BarChartGroupData> _getBarGroupData(String type) {
    if (customerProfile.isEmpty) {
      return [];
    }

    GenderDistribution genderDistribution =
        _getGenderDistributionByCategory(false);
    return _convertGenderDistributionToBarChart(genderDistribution, type);
  }

  List<BarChartGroupData> _getBarGroupClaimsData(String type) {
    if (customerProfile.isEmpty) {
      return [];
    }

    GenderDistribution genderDistribution =
        _getGenderDistributionByCategory(true);
    return _convertGenderDistributionToBarChart(genderDistribution, type);
  }

  GenderDistribution _getGenderDistributionByCategory(bool isClaims) {
    // Use the proper implementation that handles all member types
    return _getGenderDistributionByCategory2(isClaims);
  }

  GenderDistribution _getGenderDistributionByCategory2(bool isClaims) {
    // Create filtered gender distribution based on gridIndex selection
    Map<String, AgeGenderData> filteredAgeGroups = {};

    List<String> ageGroups = [
      '0-10',
      '11-20',
      '21-30',
      '31-40',
      '41-50',
      '51-60',
      '61-70',
      '71-80',
      '81-90',
      '91-100',
      '101-110',
      '111-120'
    ];

    for (String ageGroup in ageGroups) {
      int maleTotal = 0;
      int femaleTotal = 0;

      switch (gridIndex) {
        case 0: // Main Members only
          maleTotal = _getMemberTypeAgeGenderCount(
              'main_member', ageGroup, 'male', isClaims);
          femaleTotal = _getMemberTypeAgeGenderCount(
              'main_member', ageGroup, 'female', isClaims);
          break;

        case 1: // All Lives - sum all member types
          maleTotal = _getMemberTypeAgeGenderCount(
                  'main_member', ageGroup, 'male', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'child', ageGroup, 'male', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'beneficiary', ageGroup, 'male', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'adult_child', ageGroup, 'male', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'partner', ageGroup, 'male', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'extended_family', ageGroup, 'male', isClaims);

          femaleTotal = _getMemberTypeAgeGenderCount(
                  'main_member', ageGroup, 'female', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'child', ageGroup, 'female', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'beneficiary', ageGroup, 'female', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'adult_child', ageGroup, 'female', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'partner', ageGroup, 'female', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'extended_family', ageGroup, 'female', isClaims);
          break;

        case 2: // Dependents - Children + Adult Children + Beneficiaries
          maleTotal = _getMemberTypeAgeGenderCount(
                  'child', ageGroup, 'male', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'adult_child', ageGroup, 'male', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'beneficiary', ageGroup, 'male', isClaims);

          femaleTotal = _getMemberTypeAgeGenderCount(
                  'child', ageGroup, 'female', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'adult_child', ageGroup, 'female', isClaims) +
              _getMemberTypeAgeGenderCount(
                  'beneficiary', ageGroup, 'female', isClaims);
          break;

        case 3: // Partners only
          maleTotal = _getMemberTypeAgeGenderCount(
              'partner', ageGroup, 'male', isClaims);
          femaleTotal = _getMemberTypeAgeGenderCount(
              'partner', ageGroup, 'female', isClaims);
          break;

        default:
          // Fallback to all lives
          final baseData = isClaims
              ? customerProfile.claimsData.genderDistribution.ageGroups
              : customerProfile.genderDistribution.ageGroups;
          if (baseData.containsKey(ageGroup)) {
            maleTotal = baseData[ageGroup]!.male;
            femaleTotal = baseData[ageGroup]!.female;
          }
          break;
      }

      filteredAgeGroups[ageGroup] =
          AgeGenderData(male: maleTotal, female: femaleTotal);
    }

    return GenderDistribution(ageGroups: filteredAgeGroups);
  }

  // Helper method to get member type age gender count from the raw data
  int _getMemberTypeAgeGenderCount(
      String memberType, String ageGroup, String gender, bool isClaims) {
    // Since we don't have direct access to age_distribution_by_gender_and_type in the model,
    // we'll distribute the member type totals proportionally across age groups
    // based on the overall age distribution

    final membersData = isClaims
        ? customerProfile.claimsData.membersCountsData
        : customerProfile.membersCountsData;

    final overallAgeData = isClaims
        ? customerProfile.claimsData.genderDistribution.ageGroups
        : customerProfile.genderDistribution.ageGroups;

    // Get total count for this member type and gender
    int memberTypeTotal = 0;
    switch (memberType) {
      case 'main_member':
        memberTypeTotal = (gender == 'male'
            ? membersData.mainMember.genders.male.total
            : membersData.mainMember.genders.female.total) as int;
        break;
      case 'child':
        memberTypeTotal = (gender == 'male'
            ? membersData.child.genders.male.total
            : membersData.child.genders.female.total) as int;
        break;
      case 'beneficiary':
        memberTypeTotal = (gender == 'male'
            ? membersData.beneficiary.genders.male.total
            : membersData.beneficiary.genders.female.total) as int;
        break;
      case 'adult_child':
        memberTypeTotal = (gender == 'male'
            ? membersData.adultChild.genders.male.total
            : membersData.adultChild.genders.female.total) as int;
        break;
      case 'partner':
        memberTypeTotal = (gender == 'male'
            ? membersData.partner.genders.male.total
            : membersData.partner.genders.female.total) as int;
        break;
      case 'extended_family':
        memberTypeTotal = (gender == 'male'
            ? membersData.extendedFamily.genders.male.total
            : membersData.extendedFamily.genders.female.total) as int;
        break;
      default:
        return 0;
    }

    // If no data for this member type, return 0
    if (memberTypeTotal == 0) return 0;

    // Calculate proportion based on overall age distribution
    if (overallAgeData.containsKey(ageGroup)) {
      final ageGroupData = overallAgeData[ageGroup]!;
      int ageGroupGenderTotal =
          gender == 'male' ? ageGroupData.male : ageGroupData.female;

      // Calculate total for this gender across all age groups
      int totalGenderCount = 0;
      for (var data in overallAgeData.values) {
        totalGenderCount += gender == 'male' ? data.male : data.female;
      }

      if (totalGenderCount > 0) {
        double proportion = ageGroupGenderTotal / totalGenderCount;
        return (memberTypeTotal * proportion).round();
      }
    }

    return 0;
  }

  List<BarChartGroupData> _convertGenderDistributionToBarChart(
      GenderDistribution genderDistribution, String type) {
    List<BarChartGroupData> barGroups = [];

    // Updated age groups to match your JSON data
    List<String> ageGroupOrder = [
      '0-10',
      '11-20',
      '21-30',
      '31-40',
      '41-50',
      '51-60',
      '61-70',
      '71-80',
      '81-90',
      '91-100',
      '101-110',
      '111-120'
    ];

    // Calculate total population (male + female combined) for percentage calculation
    int totalPopulation = 0;
    for (var ageGroup in genderDistribution.ageGroups.values) {
      totalPopulation += ageGroup.male + ageGroup.female;
    }

    int index = 0;

    for (String ageGroup in ageGroupOrder) {
      double percentageValue = 0;

      if (genderDistribution.ageGroups.containsKey(ageGroup)) {
        final ageGenderData = genderDistribution.ageGroups[ageGroup]!;
        int count = 0;

        if (type == "male") {
          count = ageGenderData.male;
        } else if (type == "female") {
          count = ageGenderData.female;
        }

        // Convert to percentage (0-100 scale) relative to total population
        if (totalPopulation > 0) {
          percentageValue = (count / totalPopulation) * 100;
        }
      }

      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: percentageValue,
              color: type == "male" ? Colors.blue : Colors.green,
              width: 20,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );

      index++;
    }

    return barGroups;
  }

  double _getBarMaxData(String type) {
    return 100; // Always 100% for percentage charts
  }

  double _getBarMaxClaimsData(String type) {
    return 100; // Always 100% for percentage charts
  }

  double _calculateMaxValueFromGenderDistribution(
      GenderDistribution genderDistribution, String type) {
    return 100; // Always 100% for percentage charts
  }
}
