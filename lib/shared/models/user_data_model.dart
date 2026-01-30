import 'package:equatable/equatable.dart';

class UserDataModel extends Equatable {
  final Result? result;

  const UserDataModel({
    this.result,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
    );
  }

  @override
  List<Object?> get props => [
    result,
  ];
}

class Result extends Equatable {
  final String? userName;
  final String? name;
  final String? surName;
  final String? nameAr;
  final String? emailAddress;
  final String? phoneNumber;
  final String? phoneCode;
  final String? position;
  final String? positionAr;
  final bool? isActive;
  final String? fullName;
  final String? creationTime;
  final List<String>? roleNames;
  final String? rolesDetails;
  final int? gender;
  final String? instagram;
  final String? facebook;
  final int? imageId;
  final String? lastLoginDate;
  final String? totalBookingsAmount;
  final String? file;
  final int? id;

  const Result(
      {this.userName,
        this.name,
        this.surName,
        this.nameAr,
        this.emailAddress,
        this.phoneNumber,
        this.phoneCode,
        this.position,
        this.positionAr,
        this.isActive,
        this.fullName,
        this.creationTime,
        this.roleNames,
        this.rolesDetails,
        this.gender,
        this.instagram,
        this.facebook,
        this.imageId,
        this.lastLoginDate,
        this.totalBookingsAmount,
        this.file,
        this.id});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      userName: json['userName'],
      name: json['name'],
      surName: json['surName'],
      nameAr: json['nameAr'],
      emailAddress: json['emailAddress'],
      phoneNumber: json['phoneNumber'],
      phoneCode: json['phoneCode'],
      position: json['position'],
      positionAr: json['positionAr'],
      isActive: json['isActive'],
      fullName: json['fullName'],
      creationTime: json['creationTime'],
      roleNames: json['roleNames'].cast<String>(),
      rolesDetails: json['rolesDetails'],
      gender: json['gender'],
      instagram: json['instagram'],
      facebook: json['facebook'],
      imageId: json['imageId'],
      lastLoginDate: json['lastLoginDate'],
      totalBookingsAmount: json['totalBookingsAmount'],
      file: json['file'],
      id: json['id'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    userName,
    name,
    surName,
    nameAr,
    emailAddress,
    phoneNumber,
    phoneCode,
    position,
    positionAr,
    isActive,
    fullName,
    creationTime,
    roleNames,
    rolesDetails,
    gender,
    instagram,
    facebook,
    imageId,
    lastLoginDate,
    totalBookingsAmount,
    file,
    id
  ];
}
