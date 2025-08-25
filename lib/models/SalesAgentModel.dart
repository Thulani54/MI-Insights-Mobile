class SalesAgentModel {
  final int cecEmployeeId;
  final int cecClientId;
  final String folderName;
  final String clientName;
  final String? clientPhone;
  final String clientFsp;
  final int cecJobtitleId;
  final String employeeTitle;
  final String employeeGender;
  final int? employeeAge;
  final String ethnicity;
  final String initials;
  final String employeeName;
  final String employeePreferredName;
  final String employeeSurname;
  final DateTime employeeDob;
  final String disability;
  final String specifyDisability;
  final String citizenship;
  final String employeeMaritalStatus;
  final int numberOfKids;
  final String employeeNationality;
  final String willingToRelocate;
  final String homeLanguage;
  final String employeeIdPassportNumber;
  final String employeeEmail;
  final String employeeNumber;
  final String employeeAppointmentType;
  final DateTime employeeStartDate;
  final DateTime? employeeEndDate; // Nullable
  final String salary;
  final String salaryPer;
  final String payType;
  final String payPeriod;

  SalesAgentModel({
    required this.cecEmployeeId,
    required this.cecClientId,
    required this.folderName,
    required this.clientName,
    this.clientPhone,
    required this.clientFsp,
    required this.cecJobtitleId,
    required this.employeeTitle,
    required this.employeeGender,
    this.employeeAge,
    required this.ethnicity,
    required this.initials,
    required this.employeeName,
    required this.employeePreferredName,
    required this.employeeSurname,
    required this.employeeDob,
    required this.disability,
    required this.specifyDisability,
    required this.citizenship,
    required this.employeeMaritalStatus,
    required this.numberOfKids,
    required this.employeeNationality,
    required this.willingToRelocate,
    required this.homeLanguage,
    required this.employeeIdPassportNumber,
    required this.employeeEmail,
    required this.employeeNumber,
    required this.employeeAppointmentType,
    required this.employeeStartDate,
    this.employeeEndDate,
    required this.salary,
    required this.salaryPer,
    required this.payType,
    required this.payPeriod,
    // Initialize other fields...
  });

  factory SalesAgentModel.fromJson(Map<String, dynamic> json) {
    return SalesAgentModel(
      cecEmployeeId: json['cec_employeeid'] as int,
      cecClientId: json['cec_client_id'] as int,
      folderName: json['folder_name'] ?? "",
      clientName: json['client_name'] ?? "",
      clientPhone: json['client_phone'] ?? "",
      clientFsp: json['client_fsp'] ?? "",
      cecJobtitleId: json['cec_jobtitleid'] ?? 0,
      employeeTitle: json['employee_title'] ?? "",
      employeeGender: json['employee_gender'] ?? "",
      employeeAge: json['employee_age'] as int?,
      ethnicity: json['ethnicity'] ?? "",
      initials: json['initials'] ?? "",
      employeeName: json['employee_name'] ?? "",
      employeePreferredName: json['employee_prefered_name'] ?? "",
      employeeSurname: json['employee_surname'] ?? "",
      employeeDob: DateTime.parse(json['employee_dob'] as String),
      disability: json['disability'] ?? "",
      specifyDisability: json['specify_disability'] ?? "",
      citizenship: json['citizenship'] ?? "",
      employeeMaritalStatus: json['employee_marital_status'] ?? "",
      numberOfKids: json['number_of_kids'] ?? 0,
      employeeNationality: json['employee_nationality'] ?? "",
      willingToRelocate: json['willing_to_relocate'] ?? "",
      homeLanguage: json['home_language'] ?? "",
      employeeIdPassportNumber: json['employee_id_passport_number'] ?? "",
      employeeEmail: json['employee_email'] ?? "",
      employeeNumber: json['employee_number'] ?? "",
      employeeAppointmentType: json['employee_appointmenttype'] ?? "",
      employeeStartDate: DateTime.parse(json['employee_startdate'] ?? ""),
      employeeEndDate: json['employee_enddate'] == null
          ? null
          : DateTime.parse(json['employee_enddate'] as String),
      salary: json['salary'] ?? "",
      salaryPer: json['salary_per'] ?? "",
      payType: json['pay_type'] ?? "",
      payPeriod: json['pay_period'] ?? "",
    );
  }
}
