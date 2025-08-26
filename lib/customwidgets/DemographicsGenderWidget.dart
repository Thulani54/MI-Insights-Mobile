import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../models/CustomerProfile.dart';
import 'CustomCard.dart';

class DemographicsGenderWidget extends StatelessWidget {
  final CustomerProfile customerProfile;
  final int selectedButton;
  final int targetIndex;
  final int gridIndex; // Add this parameter
  final bool isLoading;

  final String dateRange;

  const DemographicsGenderWidget({
    Key? key,
    required this.customerProfile,
    required this.selectedButton,
    required this.targetIndex,
    required this.gridIndex, // Add this parameter
    required this.isLoading,
    required this.dateRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        // _buildHeader(),
        _buildContent(context),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    // Calculate progress based on the selected category
    final genderData = _getGenderDataByCategory();
    final totalMembers = targetIndex == 0
        ? customerProfile.totalMembers
        : customerProfile.claimsData.totalMembers;

    final enforcedMembers = targetIndex == 0
        ? customerProfile.onInforcedPolicies
        : customerProfile.claimsData.onInforcedPolicies;

    double progressValue = totalMembers > 0
        ? enforcedMembers / totalMembers.clamp(1, double.infinity)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6),
      child: LinearPercentIndicator(
        animation: true,
        lineHeight: 20.0,
        animationDuration: 500,
        percent: progressValue.clamp(0.0, 1.0),
        center: Text("${(progressValue * 100).toStringAsFixed(1)}%"),
        barRadius: const Radius.circular(12),
        progressColor: Colors.green,
      ),
    );
  }

  Widget _buildHeader() {
    String title;
    String categoryName = _getCategoryName();

    if (selectedButton == 1) {
      title =
          "Demographics on Gender - $categoryName (MTD - ${_getMonthAbbreviation(DateTime.now().month)})";
    } else if (selectedButton == 2) {
      title = "Demographics on Gender - $categoryName (12 Months View)";
    } else {
      title = "Demographics on Gender - $categoryName ($dateRange)";
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  String _getCategoryName() {
    switch (gridIndex) {
      case 0:
        return "Main Members";
      case 1:
        return "All Lives";
      case 2:
        return "Dependents";
      case 3:
        return "Spouses";
      default:
        return "Main Members";
    }
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return _buildLoadingWidget();
    }
    return _buildGenderVisualization1(context);
  }

  Widget _buildLoadingWidget() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 12.0, top: 12, right: 16, bottom: 12),
      child: CustomCard(
        elevation: 6,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: Container(
          height: 300,
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.blue, // Replace with Constants.ctaColorLight
                  strokeWidth: 1.8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSection({
    required double percentage,
    required int count,
    required String label,
    required Color color,
    required String iconPath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            "${(percentage * 100).toStringAsFixed(1)}%",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          height: 1,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Text(
            "${_formatLargeNumber(count.toString())} lives",
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderVisualization({
    required String iconPath,
    required double percentage,
    required Color color,
  }) {
    // Calculate total figure height: head (30px) + body (170px) = 200px
    const double totalFigureHeight = 200.0;
    const double headHeight = 30.0;
    const double bodyHeight = 170.0;
    
    // Calculate how much of the total figure should be filled
    double fillHeight = totalFigureHeight * percentage;
    
    // Determine head and body coloring based on fill height
    bool shouldColorHead = fillHeight > bodyHeight; // Head gets colored when fill exceeds body height
    double bodyFillPercentage = fillHeight <= bodyHeight ? 
        (fillHeight / bodyHeight) : 1.0; // Body fill percentage

    return Container(
      width: 200,
      height: 230,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          // Head - colored based on total figure percentage
          Container(
            height: 30,
            width: 30,
            margin: const EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(
              color: shouldColorHead ? color : Colors.grey.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(360),
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 200,
                  height: 170,
                  colorFilter: ColorFilter.mode(
                      Colors.grey.withValues(alpha: 0.6), BlendMode.srcIn),
                  fit: BoxFit.contain,
                ),
                ClipPath(
                  clipper: CustomClipPath(percentage: bodyFillPercentage),
                  child: SvgPicture.asset(
                    iconPath,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    width: 200,
                    height: 170,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String _formatLargeNumber(String number) {
    // Add your number formatting logic here
    int num = int.tryParse(number) ?? 0;
    if (num >= 1000000) {
      return "${(num / 1000000).toStringAsFixed(1)}M";
    } else if (num >= 1000) {
      return "${(num / 1000).toStringAsFixed(1)}K";
    }
    return num.toString();
  }

  Widget _buildGenderVisualization1(BuildContext context) {
    final genderData = _getGenderDataByCategory();

    return Container(
      height: 300,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 12.0, top: 8, right: 16, bottom: 12),
        child: CustomCard(
          surfaceTintColor: Colors.white,
          color: Colors.white,
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  // Male Section
                  Expanded(
                    child: _buildGenderSection(
                      percentage: genderData.malePercentage,
                      count: genderData.totalMale,
                      label: "Male",
                      color: Colors.lightBlue,
                      iconPath: 'assets/icons/man-toilet-color-icon.svg',
                    ),
                  ),
                  // Male Visualization
                  Expanded(
                    child: _buildGenderVisualization(
                      iconPath: 'assets/icons/man-toilet-color-icon.svg',
                      percentage: genderData.malePercentage,
                      color: Colors.lightBlue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Female Visualization
                  Expanded(
                    child: _buildGenderVisualization(
                      iconPath: 'assets/icons/women-toilet-color-icon.svg',
                      percentage: genderData.femalePercentage,
                      color: Colors.green,
                    ),
                  ),
                  // Female Section
                  Expanded(
                    child: _buildGenderSection(
                      percentage: genderData.femalePercentage,
                      count: genderData.totalFemale,
                      label: "Female ",
                      color: Colors.green,
                      iconPath: 'assets/icons/women-toilet-color-icon.svg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Add this new method to get gender data based on category
  GenderTotals _getGenderDataByCategory() {
    final membersData = targetIndex == 0
        ? customerProfile.membersCountsData
        : customerProfile.claimsData.membersCountsData;

    int totalMale = 0;
    int totalFemale = 0;

    switch (gridIndex) {
      case 0: // Main
        totalMale = membersData.mainMember.genders.male.total;
        totalFemale = membersData.mainMember.genders.female.total;
        break;

      case 1: // All Lives
        totalMale = membersData.mainMember.genders.male.total +
            membersData.partner.genders.male.total +
            membersData.child.genders.male.total +
            membersData.adultChild.genders.male.total +
            membersData.beneficiary.genders.male.total +
            membersData.extendedFamily.genders.male.total;

        totalFemale = membersData.mainMember.genders.female.total +
            membersData.partner.genders.female.total +
            membersData.child.genders.female.total +
            membersData.adultChild.genders.female.total +
            membersData.beneficiary.genders.female.total +
            membersData.extendedFamily.genders.female.total;
        break;

      case 2: // Dependents
        totalMale = membersData.child.genders.male.total +
            membersData.adultChild.genders.male.total +
            membersData.beneficiary.genders.male.total;

        totalFemale = membersData.child.genders.female.total +
            membersData.adultChild.genders.female.total +
            membersData.beneficiary.genders.female.total;
        break;

      case 3: // Spouse
        totalMale = membersData.partner.genders.male.total;
        totalFemale = membersData.partner.genders.female.total;
        break;

      default:
        totalMale = membersData.mainMember.genders.male.total;
        totalFemale = membersData.mainMember.genders.female.total;
        break;
    }

    int total = totalMale + totalFemale;
    double malePercentage = total > 0 ? totalMale / total : 0.0;
    double femalePercentage = total > 0 ? totalFemale / total : 0.0;

    return GenderTotals(
      totalMale: totalMale,
      totalFemale: totalFemale,
      total: total,
      malePercentage: malePercentage,
      femalePercentage: femalePercentage,
    );
  }
}

// Custom clipper for gender visualization (if not already defined)
class CustomClipPath extends CustomClipper<Path> {
  final double percentage;

  CustomClipPath({required this.percentage});

  @override
  Path getClip(Size size) {
    Path path = Path();
    
    // Use the percentage directly for accurate representation
    double clipHeight = size.height * percentage;

    // Clip from bottom up to include the full body (head to feet) based on percentage
    path.addRect(
        Rect.fromLTWH(0, size.height - clipHeight, size.width, clipHeight));

    return path;
  }

  @override
  bool shouldReclip(CustomClipPath oldClipper) {
    return oldClipper.percentage != percentage;
  }
}
