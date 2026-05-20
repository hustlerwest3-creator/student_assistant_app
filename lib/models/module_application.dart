// Student Assistant Application - TPG316C Assignment
// Group Members:
// 221021198 - AM MATONA
// 221021493 - M MAKHASANE
// 222072446 - PN MONGWE
// 222071364 - N TLALI
// 222071216 - IKF NDLOVU
// Date: May 2026

class ModuleApplication {
  final String id;
  final String applicationId;
  final String academicLevel;
  final String moduleName;
  final String supportingDocumentUrl;
  final String? additionalNotes;

  ModuleApplication({
    required this.id,
    required this.applicationId,
    required this.academicLevel,
    required this.moduleName,
    required this.supportingDocumentUrl,
    this.additionalNotes,
  });

  factory ModuleApplication.fromJson(Map<String, dynamic> json) {
    return ModuleApplication(
      id: json['id'],
      applicationId: json['application_id'],
      academicLevel: json['academic_level'],
      moduleName: json['module_name'],
      supportingDocumentUrl: json['supporting_document_url'],
      additionalNotes: json['additional_notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'application_id': applicationId,
      'academic_level': academicLevel,
      'module_name': moduleName,
      'supporting_document_url': supportingDocumentUrl,
      'additional_notes': additionalNotes,
    };
  }

  ModuleApplication copyWith({
    String? id,
    String? applicationId,
    String? academicLevel,
    String? moduleName,
    String? supportingDocumentUrl,
    String? additionalNotes,
  }) {
    return ModuleApplication(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      academicLevel: academicLevel ?? this.academicLevel,
      moduleName: moduleName ?? this.moduleName,
      supportingDocumentUrl:
          supportingDocumentUrl ?? this.supportingDocumentUrl,
      additionalNotes: additionalNotes ?? this.additionalNotes,
    );
  }
}
