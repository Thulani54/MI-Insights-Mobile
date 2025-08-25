class EmployeeAttendance {
  final int cecEmployeeId;
  final int cecClientId;
  final String employmentStatus;
  final String employeeTitle;
  final String employeeGender;
  final String employeeName;
  final String employeeSurname;
  final String employeeEmail;
  final String employeeNumber;
  final String employeeIdPassportNumber;
  final String? userImage;
  final String? deviceId;
  final int organoId;
  final String role;
  final String type;
  final int cecAttendanceRegisterId;
  final String? attendanceStatus;
  final String? attendanceStatusMorning;
  final String date;
  final String? status;
  final String cellphone;

  EmployeeAttendance({
    required this.cecEmployeeId,
    required this.cecClientId,
    required this.employmentStatus,
    required this.employeeTitle,
    required this.employeeGender,
    required this.employeeName,
    required this.employeeSurname,
    required this.employeeEmail,
    required this.employeeNumber,
    required this.employeeIdPassportNumber,
    this.userImage,
    this.deviceId,
    required this.organoId,
    required this.role,
    required this.type,
    required this.cecAttendanceRegisterId,
    this.attendanceStatus,
    this.attendanceStatusMorning,
    required this.date,
    this.status,
    required this.cellphone,
  });

  factory EmployeeAttendance.fromJson(Map<String, dynamic> json) {
    return EmployeeAttendance(
      cecEmployeeId: json['cec_employeeid'],
      cecClientId: json['cec_client_id'],
      employmentStatus: json['employment_status'],
      employeeTitle: json['employee_title'],
      employeeGender: json['employee_gender'],
      employeeName: json['employee_name'],
      employeeSurname: json['employee_surname'],
      employeeEmail: json['employee_email'],
      employeeNumber: json['employee_number'],
      employeeIdPassportNumber: json['employee_id_passport_number'],
      userImage: json['userImage'],
      deviceId: json['device_id'],
      organoId: json['organo_id'],
      role: json['role'],
      type: json['type'],
      cecAttendanceRegisterId: json['cec_attendance_register_id'],
      attendanceStatus: json['attendance_status'],
      attendanceStatusMorning: json['attendance_status_morning'],
      date: json['date'],
      status: json['status'],
      cellphone: json['cellphone'],
    );
  }
}
