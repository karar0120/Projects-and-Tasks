enum Permissions{
  Pages_Users,
  Pages_Clients,
  Pages_Roles,
  Pages_MyInfo,
  Pages_BookingConfiguration,
  Pages_BookingPageConfiguration,
  Pages_TitleConfiguration,
  Pages_AvailabilityConfiguration,
  Pages_Categories,
  Pages_Services,
  Pages_BookingsByAdmin,
  Pages_UsersSummaryReport,
  Pages_TotalBookingsReport,
  Pages_TotalRegisterationReport,
  Pages_ClientReviews,
  Pages_WalletDetails,
  Pages_BankAccounts,
  Pages_WithDrawals,
  Pages_Users__CREATE,
  Pages_Users__UPDATE,
  Pages_Users__DELETE,
  Pages_Clients__CREATE,
  Pages_Clients__UPDATE,
  Pages_Clients__DELETE,
  Pages_Roles__CREATE,
  Pages_Roles__UPDATE,
  Pages_Roles__DELETE,
  Pages_MyInfo_CREATE,
  Pages_MyInfo_UPDATE,
  Pages_MyInfo_DELETE,
  Pages_BookingConfiguration_CREATE,
  Pages_BookingConfiguration_UPDATE,
  Pages_BookingConfiguration_DELETE,
  Pages_BookingPageConfiguration_CREATE,
  Pages_BookingPageConfiguration_UPDATE,
  Pages_BookingPageConfiguration_DELETE,
  Pages_TitleConfiguration_CREATE,
  Pages_TitleConfiguration_UPDATE,
  Pages_TitleConfiguration_DELETE,
  Pages_AvailabilityConfiguration_CREATE,
  Pages_AvailabilityConfiguration_UPDATE,
  Pages_AvailabilityConfiguration_DELETE,
  Pages_Categories_CREATE,
  Pages_Categories_UPDATE,
  Pages_Categories_DELETE,
  Pages_Services_CREATE,
  Pages_Services_UPDATE,
  Pages_Services_DELETE,
  Pages_BookingsByAdmin_CREATE,
  Pages_BookingsByAdmin_UPDATE,
  Pages_BookingsByAdmin_DELETE,
  Pages_ClientReviews_CREATE,
  Pages_ClientReviews_UPDATE,
  Pages_ClientReviews_DELETE,
  Pages_WalletDetails_CREATE,
  Pages_WalletDetails_UPDATE,
  Pages_WalletDetails_DELETE,
  Pages_BankAccounts_CREATE,
  Pages_BankAccounts_UPDATE,
  Pages_BankAccounts_DELETE,
  Pages_WithDrawals_CREATE,
  Pages_WithDrawals_UPDATE,
  Pages_WithDrawals_DELETE
}
const List permissions= [
  "Pages.Users",
  "Pages.Clients",
  "Pages.Roles",
  "Pages.MyInfo",
  "Pages.BookingConfiguration",
  "Pages.BookingPageConfiguration",
  "Pages.TitleConfiguration",
  "Pages.AvailabilityConfiguration",
  "Pages.Categories",
  "Pages.Services",
  "Pages.BookingsByAdmin",
  "Pages.UsersSummaryReport",
  "Pages.TotalBookingsReport",
  "Pages.TotalRegisterationReport",
  "Pages.ClientReviews",
  "Pages.WalletDetails",
  "Pages.BankAccounts",
  "Pages.WithDrawals",
  "Pages.Users_CREATE",
  "Pages.Users_UPDATE",
  "Pages.Users_DELETE",
  "Pages.Clients_CREATE",
  "Pages.Clients_UPDATE",
  "Pages.Clients_DELETE",
  "Pages.Roles_CREATE",
  "Pages.Roles_UPDATE",
  "Pages.Roles_DELETE",
  "Pages.MyInfo.CREATE",
  "Pages.MyInfo.UPDATE",
  "Pages.MyInfo.DELETE",
  "Pages.BookingConfiguration.CREATE",
  "Pages.BookingConfiguration.UPDATE",
  "Pages.BookingConfiguration.DELETE",
  "Pages.BookingPageConfiguration.CREATE",
  "Pages.BookingPageConfiguration.UPDATE",
  "Pages.BookingPageConfiguration.DELETE",
  "Pages.TitleConfiguration.CREATE",
  "Pages.TitleConfiguration.UPDATE",
  "Pages.TitleConfiguration.DELETE",
  "Pages.AvailabilityConfiguration.CREATE",
  "Pages.AvailabilityConfiguration.UPDATE",
  "Pages.AvailabilityConfiguration.DELETE",
  "Pages.Categories.CREATE",
  "Pages.Categories.UPDATE",
  "Pages.Categories.DELETE",
  "Pages.Services.CREATE",
  "Pages.Services.UPDATE",
  "Pages.Services.DELETE",
  "Pages.BookingsByAdmin.CREATE",
  "Pages.BookingsByAdmin.UPDATE",
  "Pages.BookingsByAdmin.DELETE",
  "Pages.ClientReviews.CREATE",
  "Pages.ClientReviews.UPDATE",
  "Pages.ClientReviews.DELETE",
  "Pages.WalletDetails.CREATE",
  "Pages.WalletDetails.UPDATE",
  "Pages.WalletDetails.DELETE",
  "Pages.BankAccounts.CREATE",
  "Pages.BankAccounts.UPDATE",
  "Pages.BankAccounts.DELETE",
  "Pages.WithDrawals.CREATE",
  "Pages.WithDrawals.UPDATE",
  "Pages.WithDrawals.DELETE"
];

enum WorkItemPriorityEnum {
  minor(1),
  medium(2),
  high(3),
  veryHigh(4),
  critical(5);

  const WorkItemPriorityEnum(this.value);
  final int value;

  static WorkItemPriorityEnum? fromValue(int? value) {
    if (value == null) return null;
    return WorkItemPriorityEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WorkItemPriorityEnum.minor,
    );
  }

  static WorkItemPriorityEnum? fromString(String? priority) {
    if (priority == null) return null;
    
    // Handle both numeric string and text formats
    final priorityLower = priority.toLowerCase();
    
    switch (priorityLower) {
      case 'minor':
      case '1':
        return WorkItemPriorityEnum.minor;
      case 'medium':
      case '2':
        return WorkItemPriorityEnum.medium;
      case 'high':
      case '3':
        return WorkItemPriorityEnum.high;
      case 'veryhigh':
      case 'very_high':
      case '4':
        return WorkItemPriorityEnum.veryHigh;
      case 'critical':
      case '5':
        return WorkItemPriorityEnum.critical;
      default:
        return WorkItemPriorityEnum.minor;
    }
  }

  String get displayName {
    switch (this) {
      case WorkItemPriorityEnum.minor:
        return 'Minor';
      case WorkItemPriorityEnum.medium:
        return 'Medium';
      case WorkItemPriorityEnum.high:
        return 'High';
      case WorkItemPriorityEnum.veryHigh:
        return 'VeryHigh';
      case WorkItemPriorityEnum.critical:
        return 'Critical';
    }
  }

  String getLocalizationKey() {
    switch (this) {
      case WorkItemPriorityEnum.minor:
        return 'priority_minor';
      case WorkItemPriorityEnum.medium:
        return 'priority_medium';
      case WorkItemPriorityEnum.high:
        return 'priority_high';
      case WorkItemPriorityEnum.veryHigh:
        return 'priority_very_high';
      case WorkItemPriorityEnum.critical:
        return 'priority_critical';
    }
  }

  /// Get the API format string (e.g., "VeryHigh" instead of "Very High")
  String get apiFormat {
    switch (this) {
      case WorkItemPriorityEnum.minor:
        return 'Minor';
      case WorkItemPriorityEnum.medium:
        return 'Medium';
      case WorkItemPriorityEnum.high:
        return 'High';
      case WorkItemPriorityEnum.veryHigh:
        return 'VeryHigh';
      case WorkItemPriorityEnum.critical:
        return 'Critical';
    }
  }
}

enum WorkItemStatusEnum {
  new_(1),
  active(2),
  completed(3),
  onHold(4);

  const WorkItemStatusEnum(this.value);
  final int value;

  static WorkItemStatusEnum? fromValue(int? value) {
    if (value == null) return null;
    return WorkItemStatusEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WorkItemStatusEnum.new_,
    );
  }

  static WorkItemStatusEnum? fromString(String? status) {
    if (status == null) return null;
    
    // Handle both numeric string and text formats
    final statusLower = status.toLowerCase().trim();
    
    switch (statusLower) {
      case 'new':
      case '1':
        return WorkItemStatusEnum.new_;
      case 'active':
      case '2':
        return WorkItemStatusEnum.active;
      case 'completed':
      case 'complete':
      case '3':
        return WorkItemStatusEnum.completed;
      case 'onhold':
      case 'on_hold':
      case 'hold':
      case '4':
        return WorkItemStatusEnum.onHold;
      default:
        return WorkItemStatusEnum.new_;
    }
  }

  String get displayName {
    switch (this) {
      case WorkItemStatusEnum.new_:
        return 'New';
      case WorkItemStatusEnum.active:
        return 'Active';
      case WorkItemStatusEnum.completed:
        return 'Completed';
      case WorkItemStatusEnum.onHold:
        return 'On Hold';
    }
  }

  String getLocalizationKey() {
    switch (this) {
      case WorkItemStatusEnum.new_:
        return 'status_new';
      case WorkItemStatusEnum.active:
        return 'status_active';
      case WorkItemStatusEnum.completed:
        return 'status_completed';
      case WorkItemStatusEnum.onHold:
        return 'status_on_hold';
    }
  }

  /// Get the API format string (e.g., "OnHold" instead of "On Hold")
  String get apiFormat {
    switch (this) {
      case WorkItemStatusEnum.new_:
        return 'New';
      case WorkItemStatusEnum.active:
        return 'Active';
      case WorkItemStatusEnum.completed:
        return 'Completed';
      case WorkItemStatusEnum.onHold:
        return 'OnHold';
    }
  }
}

