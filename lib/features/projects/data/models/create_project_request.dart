import 'package:equatable/equatable.dart';

/// Request body for POST /api/project (create project only).
class CreateProjectRequest extends Equatable {
  final String name;
  final String description;

  const CreateProjectRequest({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
      };

  @override
  List<Object?> get props => [name, description];
}
