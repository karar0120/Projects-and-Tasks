import 'package:equatable/equatable.dart';

class GenderModel extends Equatable {
  final dynamic id;
  final dynamic name;



  const GenderModel({
    required this.id,
    required this.name,

  });

  factory GenderModel.fromJson(Map<String, dynamic> json){
    return GenderModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  List<Object?> get props =>[
    id,
    name,
  ];
}