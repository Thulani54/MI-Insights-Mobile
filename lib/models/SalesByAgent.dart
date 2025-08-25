class SalesByAgent {
  final String agent_name;
  final int sales;
  SalesByAgent(this.agent_name, this.sales);
}

class QuotesByAgent {
  final String agent_name;
  final int sales;
  final double amount;
  QuotesByAgent(this.agent_name, this.sales, this.amount);
}

class QuotesByClient {
  final String client_name;
  final double amount;
  QuotesByClient(this.client_name, this.amount);
}

class SalesByAgent2 {
  final String employee_name;
  final int total_sales;
  final double total_collected;
  final double lapse_rate;
  final double ntu_rate;
  final double cash_collected;
  final double debit_order_collected;
  // Newly added fields
  final double eft_collected;
  final double persal_collected;
  final double salary_deduction_collected;
  final double total_cash_clients;
  final double total_debit_order_clients;
  final double total_salary_deduction_clients;
  final double total_persal_clients;
  final double percentage_cash_clients;
  final double percentage_debit_order_clients;
  final double percentage_salary_deduction_clients;
  final double percentage_persal_clients;

  SalesByAgent2(
    this.employee_name,
    this.total_sales,
    this.total_collected,
    this.lapse_rate,
    this.ntu_rate,
    this.cash_collected,
    this.debit_order_collected,
    this.eft_collected,
    this.persal_collected,
    this.salary_deduction_collected,
    this.total_cash_clients,
    this.total_debit_order_clients,
    this.total_salary_deduction_clients,
    this.total_persal_clients,
    this.percentage_cash_clients,
    this.percentage_debit_order_clients,
    this.percentage_salary_deduction_clients,
    this.percentage_persal_clients,
  );
}

class SalesByAgentSale {
  final String policy_number;
  final String inception_date;
  final String sale_datetime;
  final String product;
  final String product_type;
  final String payment_type;
  final double totalAmountPayable;
  final String status;
  final String actual_status;
  final String description;
  final String reference;
  SalesByAgentSale(
    this.policy_number,
    this.inception_date,
    this.sale_datetime,
    this.product,
    this.product_type,
    this.payment_type,
    this.totalAmountPayable,
    this.status,
    this.actual_status,
    this.description,
    this.reference,
  );
}

class SalesByAgentLead {
  final int onololeadid;
  final String title;
  final String first_name;
  final String last_name;
  final String product;
  final String lead_status;
  final int assigned_to;
  final String customer_id_number;
  final String timestamp;
  final String cell_number;
  final String reference;
  final String product_type;
  final String status;
  final String hang_up_reason;
  final String hang_up_desc2;
  final String hang_up_desc3;

  SalesByAgentLead(
    this.onololeadid,
    this.title,
    this.first_name,
    this.last_name,
    this.product,
    this.lead_status,
    this.assigned_to,
    this.customer_id_number,
    this.timestamp,
    this.cell_number,
    this.reference,
    this.product_type,
    this.status,
    this.hang_up_reason,
    this.hang_up_desc2,
    this.hang_up_desc3,
  );
}

class FieldsSalesByAgent {
  final int cec_employeeid;
  final String employee_name;
  final int total_leads;
  final int completed_leads;
  final double completion_percentage;
  final double decline_rate;
  final int submitted;
  final int completed;
  final int not_qualified;
  final int no_documents_count;
  final int rejected_by_server_count;
  final int incomplete_no_desc_count;
  final int transfer_count;
  final int call_back_count;
  final int no_contact_voice_mail_count;
  final int no_contact_no_answer_count;
  final int does_not_qualify_count;
  final int prank_call_count;
  final int duplicate_lead_count;
  final int mystery_shopper_count;
  final int not_interested_count;
  final int no_contact_number_does_not_exist_count;

  FieldsSalesByAgent({
    required this.cec_employeeid,
    required this.employee_name,
    required this.total_leads,
    required this.completed_leads,
    required this.completion_percentage,
    required this.decline_rate,
    required this.submitted,
    required this.completed,
    required this.not_qualified,
    required this.no_documents_count,
    required this.rejected_by_server_count,
    required this.incomplete_no_desc_count,
    required this.transfer_count,
    required this.call_back_count,
    required this.no_contact_voice_mail_count,
    required this.no_contact_no_answer_count,
    required this.does_not_qualify_count,
    required this.prank_call_count,
    required this.duplicate_lead_count,
    required this.mystery_shopper_count,
    required this.not_interested_count,
    required this.no_contact_number_does_not_exist_count,
  });

  factory FieldsSalesByAgent.fromJson(Map<String, dynamic> json) {
    return FieldsSalesByAgent(
      cec_employeeid: json['cec_employeeid'],
      employee_name: json['employee_name'],
      total_leads: json['total_leads'],
      completed_leads: json['completed_leads'],
      completion_percentage: json['completion_percentage'],
      decline_rate: json['decline_rate'],
      submitted: json['submitted'],
      completed: json['completed'],
      not_qualified: json['not_qualified'],
      no_documents_count: json['no_documents_count'],
      rejected_by_server_count: json['rejected_by_server_count'],
      incomplete_no_desc_count: json['incomplete_no_desc_count'],
      transfer_count: json['transfer_count'],
      call_back_count: json['call_back_count'],
      no_contact_voice_mail_count: json['no_contact_voice_mail_count'],
      no_contact_no_answer_count: json['no_contact_no_answer_count'],
      does_not_qualify_count: json['does_not_qualify_count'],
      prank_call_count: json['prank_call_count'],
      duplicate_lead_count: json['duplicate_lead_count'],
      mystery_shopper_count: json['mystery_shopper_count'],
      not_interested_count: json['not_interested_count'],
      no_contact_number_does_not_exist_count:
          json['no_contact_number_does_not_exist_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cec_employeeid': cec_employeeid,
      'employee_name': employee_name,
      'total_leads': total_leads,
      'completed_leads': completed_leads,
      'completion_percentage': completion_percentage,
      'decline_rate': decline_rate,
      'submitted': submitted,
      'completed': completed,
      'not_qualified': not_qualified,
      'no_documents_count': no_documents_count,
      'rejected_by_server_count': rejected_by_server_count,
      'incomplete_no_desc_count': incomplete_no_desc_count,
      'transfer_count': transfer_count,
      'call_back_count': call_back_count,
      'no_contact_voice_mail_count': no_contact_voice_mail_count,
      'no_contact_no_answer_count': no_contact_no_answer_count,
      'does_not_qualify_count': does_not_qualify_count,
      'prank_call_count': prank_call_count,
      'duplicate_lead_count': duplicate_lead_count,
      'mystery_shopper_count': mystery_shopper_count,
      'not_interested_count': not_interested_count,
      'no_contact_number_does_not_exist_count':
          no_contact_number_does_not_exist_count,
    };
  }
}
