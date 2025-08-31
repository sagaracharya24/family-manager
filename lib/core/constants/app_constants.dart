class AppConstants {
  static const String appName = 'OurHome';
  static const String appVersion = '1.0.0';
  
  // Collections
  static const String usersCollection = 'users';
  static const String homesCollection = 'homes';
  static const String familyMembersCollection = 'family_members';
  static const String scannedDataCollection = 'scanned_data';
  static const String permissionsCollection = 'permissions';
  
  // User Status
  static const String userStatusPending = 'pending';
  static const String userStatusApproved = 'approved';
  static const String userStatusRejected = 'rejected';
  
  // User Roles
  static const String roleSuperAdmin = 'super_admin';
  static const String roleAdmin = 'admin';
  static const String roleFamilyMember = 'family_member';
  
  // Permissions
  static const String permissionCreateFamily = 'create_family';
  static const String permissionManageMembers = 'manage_members';
  static const String permissionScanImages = 'scan_images';
  static const String permissionViewReports = 'view_reports';
  static const String permissionExportData = 'export_data';
  
  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String scannedImagesPath = 'scanned_images';
  static const String documentsPath = 'documents';
}