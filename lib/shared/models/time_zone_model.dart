import 'package:equatable/equatable.dart';

class TimeZoneModel extends Equatable {
  final String id;
  final String name;



  const TimeZoneModel({
    required this.id,
    required this.name,
  });

  factory TimeZoneModel.fromJson(Map<String, dynamic> json){
    return TimeZoneModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
  ];
}
