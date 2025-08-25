import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/Constants.dart';
import '../../customwidgets/CustomCard.dart';
import '../../models/Attendance.dart';

class AttendanceRegisterScreen extends StatefulWidget {
  @override
  _AttendanceRegisterScreenState createState() =>
      _AttendanceRegisterScreenState();
}

class _AttendanceRegisterScreenState extends State<AttendanceRegisterScreen> {
  late Future<List<EmployeeAttendance>> _employeesFuture;

  Future<List<EmployeeAttendance>> fetchEmployees() async {
    final response = await http.get(
      Uri.parse(
          'https://miinsightsapps.net/admin/getBranchEmployeesAttendanceWeb?cec_employeeid=3&cec_client_id=1&type=branch'),
      /*Uri.parse(
          'https://miinsightsapps.net/admin/getBranchEmployeesAttendanceByBranch?branch_id=&cec_client_id=1&startDate=2024-08-29&endDate=2024-08-29'),*/
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cookie':
            'userid=expiry=2023-12-28&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=379&empid=9819&empfirstname=Everest&emplastname=Everest&email=Master@everestmpu.com&username=Master@everestmpu.com&dob=7/7/1990 12:00:00 AM&fullname=Everest Everest&userRole=184&userImage=Master@everestmpu.com.jpg&employedAt=head office 1&role=leader&branchid=379&jobtitle=Policy Administrator / Agent&dialing_strategy=&clientname=Everest Financial Services&foldername=&client_abbr=EV&pbx_account=&device_id=&servername=http://localhost:55661'
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => EmployeeAttendance.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  @override
  void initState() {
    super.initState();
    _employeesFuture = fetchEmployees();
  }

  final List<Map<String, dynamic>> attendanceCodes = [
    {"text": "Unmarked", "color": Colors.grey},
    {"text": "P", "color": Colors.green},
    {"text": "LC", "color": Colors.yellow},
    {"text": "AL", "color": Colors.orange},
    {"text": "ML", "color": Colors.black},
    {"text": "PC", "color": Colors.blue},
    {"text": "DO", "color": Colors.purple},
    {"text": "T", "color": Colors.teal},
    {"text": "S", "color": Colors.red},
    {"text": "SL", "color": Colors.cyan},
    {"text": "R", "color": Colors.brown},
    {"text": "FR", "color": Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 6,
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.6),
          centerTitle: true,
          title: const Text(
            "Employee Attendance",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )),
      body: FutureBuilder<List<EmployeeAttendance>>(
        future: _employeesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Constants.ctaColorLight,
              strokeWidth: 1.8,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No employees found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final employee = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EmployeeDetailScreen(employee: employee),
                        ),
                      );
                    },
                    child: CustomCard(
                      color: Colors.white,
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  AssetImage('assets/img/default-user (1).png')
                                      as ImageProvider,
                            ),
                            /*  CircleAvatar(
                              radius: 30,
                              backgroundImage: employee.userImage != null
                                  ? NetworkImage(
                                      'https://miinsightsapps.net/images/${employee.userImage}')
                                  : AssetImage(
                                          'assets/img/default-user (1).png')
                                      as ImageProvider,
                            ),*/
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(employee.employeeName +
                                      " " +
                                      employee.employeeSurname),
                                  Text(employee.role),
                                  Text(
                                    employee.cellphone!,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  if (employee.attendanceStatus != "")
                                    Text(
                                      "Cuurently : ${getAttendanceDescription(employee.attendanceStatus)}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Constants.ctaColorLight,
                                          fontWeight: FontWeight.w500),
                                    ),
                                ],
                              ),
                            )),
                            CircularAttendanceWidget(
                                employee: employee,
                                attendanceCodes: attendanceCodes),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  String getAttendanceDescription(String? code) {
    final Map<String, String> attendanceCodes = {
      "P": "Present",
      "LC": "Late Coming",
      "AL": "Annual Leave",
      "ML": "Maternity Leave",
      "PC": "Paternity Leave",
      "DO": "Day Off",
      "T": "Training",
      "S": "Suspended",
      "SL": "Sick Leave",
      "R": "Resigned",
      "FR": "Family Responsibility Leave",
    };

    return attendanceCodes[code] ??
        "Unmarked"; // Return "Unmarked" if the code is not found
  }
}

class EmployeeDetailScreen extends StatelessWidget {
  final EmployeeAttendance employee;

  EmployeeDetailScreen({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 6,
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.6),
          centerTitle: true,
          title: Text(
            "${employee.employeeName} ${employee.employeeSurname}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: employee.userImage != null
                  ? NetworkImage(
                      'https://miinsightsapps.net/images/${employee.userImage}')
                  : AssetImage('assets/placeholder.jpg') as ImageProvider,
            ),
            SizedBox(height: 16),
            Text(
                'Name: ${employee.employeeTitle} ${employee.employeeName} ${employee.employeeSurname}'),
            SizedBox(height: 8),
            Text('Gender: ${employee.employeeGender}'),
            SizedBox(height: 8),
            Text('Email: ${employee.employeeEmail}'),
            SizedBox(height: 8),
            Text('Phone: ${employee.cellphone}'),
            SizedBox(height: 8),
            Text('Role: ${employee.role}'),
            SizedBox(height: 8),
            Text('Employment Status: ${employee.employmentStatus}'),
            SizedBox(height: 8),
            Text('ID/Passport: ${employee.employeeIdPassportNumber}'),
          ],
        ),
      ),
    );
  }
}

class CircularAttendanceWidget extends StatefulWidget {
  final employee;
  final List<Map<String, dynamic>> attendanceCodes;

  CircularAttendanceWidget(
      {Key? key, required this.attendanceCodes, this.employee})
      : super(key: key);

  @override
  _CircularAttendanceWidgetState createState() =>
      _CircularAttendanceWidgetState();
}

class _CircularAttendanceWidgetState extends State<CircularAttendanceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Check if employee status is not empty

    if (widget.employee.attendanceStatus != null &&
        widget.employee.attendanceStatus.isNotEmpty) {
      // Find the index of the status in the attendanceCodes list
      final index = widget.attendanceCodes.indexWhere(
          (code) => code['text'] == widget.employee.attendanceStatus);
      print("ggffg ${widget.employee.attendanceStatus} $index");

      if (index != -1) {
        _currentIndex = index; // Set _currentIndex to the found index
      }
    }

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextCode() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.attendanceCodes.length;
      print("dfddf $_currentIndex");
      print("dfddf ${widget.employee.cecAttendanceRegisterId}");
      print("dfddf ${widget.attendanceCodes[_currentIndex]['text']}");
      setAttendanceStatus(widget.employee.cecAttendanceRegisterId,
          widget.attendanceCodes[_currentIndex]['text']);
    });
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final currentCode = widget.attendanceCodes[_currentIndex];

    return GestureDetector(
      onTap: _nextCode,
      child: RotationTransition(
        turns: _animation,
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: currentCode['color'],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              currentCode['text'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: currentCode['text'] == "Unmarked" ? 10 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> setAttendanceStatus(
    int attendanceRegisterId, String attendanceStatus) async {
  var url = Uri.parse(
      'https://miinsightsapps.net/admin/setAttendance?cec_attendance_register_id=$attendanceRegisterId&attendance_status=$attendanceStatus&cec_attendance_register_id=$attendanceRegisterId&attendance_status=$attendanceStatus');

  var headers = {
    "Cookie":
        "userid=expiry=2020-07-02&client_modules=1001#1002#1003#1004#1005#1006#1007#1008#1009#1010#1011#1012#1013#1014#1015#1017#1018#1020#1021#1022#1024#1025#1026#1027#1028#1029#1030#1031#1032#1033#1034#1035&clientid=1&empid=3&empfirstname=Mncedisi&emplastname=Khumalo&email=mncedisi@athandwe.co.za&username=mncedisi@athandwe.co.za&dob=8/28/1985 12:00:00 AM&fullname=Mncedisi Khumalo&userRole=5&userImage=mncedisi@athandwe.co.za.jpg&employedAt=branch&role=leader&branchid=6&branchname=Boulders&jobtitle=Administrative Assistant&dialing_strategy=Campaign Manager&clientname=Athandwe&foldername=maafrica&client_abbr=AS&pbx_account=pbx1051ef0a&soft_phone_ip=&agent_type=branch&mip_username=mnces@mip.co.za&agent_email=hfg2@ghf.com&ViciDial_phone_login=99&ViciDial_phone_password=&ViciDial_agent_user=&ViciDial_agent_password=&device_id=Error retrieving Instance ID token. &servername=http://localhost:55661"
  };

  try {
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // If the server returns a successful response, you can handle it here
      print('Attendance status updated successfully.');
      var responseData = jsonDecode(response.body);
      print(responseData); // You can print or handle the response as needed
    } else {
      // If the server did not return a 200 OK response, handle it here
      print('Failed to update attendance status: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error updating attendance status: $e');
  }
}
