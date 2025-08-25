class claims_sections_gridmodel {
  String id;
  String amount;
  claims_sections_gridmodel(
    this.id,
    this.amount,
  );
}

class Claims_Details {
  String claim_reference;
  String policy_number;
  String claim_first_name;
  String claim_last_name;
  String claim_cell_number;
  double amount;
  String policy_status;
  String policy_reference;
  String policy_life;
  String claim_id_num;
  String claim_date;
  String claim_status_description;
  Claims_Details(
    this.claim_reference,
    this.policy_number,
    this.claim_first_name,
    this.claim_last_name,
    this.claim_cell_number,
    this.amount,
    this.policy_status,
    this.policy_reference,
    this.policy_life,
    this.claim_id_num,
    this.claim_date,
    this.claim_status_description,
  );
}
