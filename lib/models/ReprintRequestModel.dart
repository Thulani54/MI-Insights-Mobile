class ReprintRequestModel {
  final int id;
  final String requesttype;
  final String requestdescription;
  final String requestuser;
  final String status;
  final String authorizer;
  final String reprintcode;
  ReprintRequestModel(this.id, this.requesttype, this.requestdescription,
      this.requestuser, this.status, this.authorizer, this.reprintcode);
}
