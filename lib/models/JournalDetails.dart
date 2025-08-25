class JournalDetails {
  String appUserId;
  String journalId;
  String journalTitle;
  String journalEntry;
  String journalImage;
  bool favorite;

  JournalDetails({
    required this.appUserId,
    required this.journalId,
    required this.journalTitle,
    required this.journalEntry,
    required this.journalImage,
    required this.favorite,
  });
}
