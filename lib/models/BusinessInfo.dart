class BusinessInfo {
  final String address_1;
  final String address_2;
  final String city;
  final String province;
  final String country;
  final String area_code;
  final String postal_address_1;
  final String postal_address_2;
  final String postal_city;
  final String postal_province;
  final String postal_country;
  final String postal_code;
  final String tel_no;
  final String cell_no;
  final String comp_name;
  final String vat_number;
  final String client_fsp;
  final String logo;
  BusinessInfo({
    required this.address_1,
    required this.address_2,
    required this.city,
    required this.province,
    required this.country,
    required this.area_code,
    required this.postal_address_1,
    required this.postal_address_2,
    required this.postal_city,
    required this.postal_province,
    required this.postal_country,
    required this.postal_code,
    required this.tel_no,
    required this.cell_no,
    required this.comp_name,
    required this.vat_number,
    required this.client_fsp,
    required this.logo,
  });
  Map<String, dynamic> toJson() {
    return {
      'address_1': address_1,
      'address_2': address_2,
      'city': city,
      'province': province,
      'country': country,
      'area_code': area_code,
      'postal_address_1': postal_address_1,
      'postal_address_2': postal_address_2,
      'postal_city': postal_city,
      'postal_province': postal_province,
      'postal_country': postal_country,
      'postal_code': postal_code,
      'tel_no': tel_no,
      'cell_no': cell_no,
      'comp_name': comp_name,
      'vat_number': vat_number,
      'client_fsp': client_fsp,
      'logo': logo,
    };
  }

  factory BusinessInfo.fromJson(Map<String, dynamic> json) {
    return BusinessInfo(
      address_1: json['address_1'] as String,
      address_2: json['address_2'] as String,
      city: json['city'] as String,
      province: json['province'] as String,
      country: json['country'] as String,
      area_code: json['area_code'] as String,
      postal_address_1: json['postal_address_1'] as String,
      postal_address_2: json['postal_address_2'] as String,
      postal_city: json['postal_city'] as String,
      postal_province: json['postal_province'] as String,
      postal_country: json['postal_country'] as String,
      postal_code: json['postal_code'] as String,
      tel_no: json['tel_no'] as String,
      cell_no: json['cell_no'] as String,
      comp_name: json['comp_name'] as String,
      vat_number: json['vat_number'] as String,
      client_fsp: json['client_fsp'] as String,
      logo: json['logo'] as String,
    );
  }
}
