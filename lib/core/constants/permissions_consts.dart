class AppPermissions {
  // Users
  static const String usersView = "Users.View";
  static const String usersCreate = "Users.Create";
  static const String usersEdit = "Users.Edit";
  static const String usersDelete = "Users.Delete";

  // Roles
  static const String rolesView = "Roles.View";
  static const String rolesCreate = "Roles.Create";
  static const String rolesEdit = "Roles.Edit";
  static const String rolesDelete = "Roles.Delete";

  // Template Score Priorities
  static const String templateScorePrioritiesView = "TemplateScorePriorities.View";
  static const String templateScorePrioritiesCreate = "TemplateScorePriorities.Create";
  static const String templateScorePrioritiesEdit = "TemplateScorePriorities.Edit";
  static const String templateScorePrioritiesDelete = "TemplateScorePriorities.Delete";

  // Locations
  static const String locationsView = "Locations.View";
  static const String locationsCreate = "Locations.Create";
  static const String locationsEdit = "Locations.Edit";
  static const String locationsDelete = "Locations.Delete";

  // Equipments
  static const String equipmentsView = "Equipments.View";
  static const String equipmentsCreate = "Equipments.Create";
  static const String equipmentsEdit = "Equipments.Edit";
  static const String equipmentsDelete = "Equipments.Delete";

  // Custom Lists
  static const String customListsView = "CustomLists.View";
  static const String customListsCreate = "CustomLists.Create";
  static const String customListsEdit = "CustomLists.Edit";
  static const String customListsDelete = "CustomLists.Delete";

  // Public Library
  static const String publicLibraryView = "PublicLibrary.View";
  static const String publicLibraryImport = "PublicLibrary.Import";

  // Templates
  static const String templatesView = "Templates.View";
  static const String templatesCreate = "Templates.Create";
  static const String templatesEdit = "Templates.Edit";
  static const String templatesDelete = "Templates.Delete";

  // Inspections
  static const String inspectionsView = "Inspections.View";
  static const String inspectionsCreate = "Inspections.Create";
  static const String inspectionsEdit = "Inspections.Edit";
  static const String inspectionsDelete = "Inspections.Delete";

  // Work Items
  static const String workItemsView = "WorkItems.View";
  static const String workItemsCreate = "WorkItems.Create";
  static const String workItemsEdit = "WorkItems.Edit";
  static const String workItemsDelete = "WorkItems.Delete";

  // Reports
  static const String reportsInspectionMetrics = "Reports.InspectionMetrics";
  static const String companyInformationView = "CompanyInformation.View";
  static const String zonesView = "Zones.View";
  static const String zonesCreate = "Zones.Create";
  static const String zonesEdit = "Zones.Edit";
  static const String zonesDelete = "Zones.Delete";

  static const String scheduledInspectionsView = "ScheduledInspections.View";
  static const String scheduledInspectionsCreate = "ScheduledInspections.Create";
  static const String scheduledInspectionsEdit = "ScheduledInspections.Edit";
  static const String scheduledInspectionsDelete = "ScheduledInspections.Delete";

  // Violations
  static const String violationsView = "Violations.View";
  static const String violationsCreate = "Violations.Create";
  static const String violationsEdit = "Violations.Edit";
  static const String violationsDelete = "Violations.Delete";

  // Helper list of all permissions (optional)
  static const List<String> all = [
    usersView,
    usersCreate,
    usersEdit,
    usersDelete,
    rolesView,
    rolesCreate,
    rolesEdit,
    rolesDelete,
    templateScorePrioritiesView,
    templateScorePrioritiesCreate,
    templateScorePrioritiesEdit,
    templateScorePrioritiesDelete,
    locationsView,
    locationsCreate,
    locationsEdit,
    locationsDelete,
    equipmentsView,
    equipmentsCreate,
    equipmentsEdit,
    equipmentsDelete,
    customListsView,
    customListsCreate,
    customListsEdit,
    customListsDelete,
    publicLibraryView,
    publicLibraryImport,
    templatesView,
    templatesCreate,
    templatesEdit,
    templatesDelete,
    inspectionsView,
    inspectionsCreate,
    inspectionsEdit,
    inspectionsDelete,
    workItemsView,
    workItemsCreate,
    workItemsEdit,
    workItemsDelete,
    reportsInspectionMetrics,
  ];
}

