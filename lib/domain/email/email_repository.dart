abstract interface class EmailRepository {
  Future<void> sendEmail(Uri uri);
}
