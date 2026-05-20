// Student Assistant Application - TPG316C Assignment
// Group Members:
// 221021198 - AM MATONA
// 221021493 - M MAKHASANE
// 222072446 - PN MONGWE
// 222071364 - N TLALI
// 222071216 - IKF NDLOVU
// Date: May 2026

class AppConstants {
  static const String appName = 'Student Assistant Hub';
  static const String storageBucket = 'assistant_documents';
  static const String avatarsBucket = 'avatars';

  static const List<String> academicLevels = [
    'First Year',
    'Second Year',
    'Third Year',
  ];

  static const int maxModulesPerApplication = 2;
  static const int minYearOfStudy = 1;
  static const int maxYearOfStudy = 4;

  // APPLICATION STATUS CONSTANTS
  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';
}
