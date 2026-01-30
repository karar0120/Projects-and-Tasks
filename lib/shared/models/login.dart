import 'package:equatable/equatable.dart';

class Login extends Equatable{
  final Result? result;

  const Login(
      {this.result,
      });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      result :
      json['payload'] != null ? Result.fromJson(json['payload']) : null,
    );
  }

  @override
  List<Object?> get props =>[
    result,
  ];

}

class Result extends Equatable{
  final String? accessToken;
  final String? refreshToken;
  final String?encryptedPassword;
  final int? expireInSeconds;
  final int? tenantId;
  final int? userId;
  final User? user;
  final String? timeZone;
  final List<String>? permissions;
  final bool?isFeatureCustomized;
  final bool? isGalleryRestricted;

  const Result(
      {this.accessToken,
        this.refreshToken,
        this.expireInSeconds,
        this.tenantId,
        this.userId,
        this.timeZone,
        this.permissions,
        this.encryptedPassword,
        this.isFeatureCustomized,
        this.isGalleryRestricted,
        this.user,
      });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      accessToken : json['token'],
      refreshToken: json['refreshToken'],
      encryptedPassword:json['encryptedPassword'],
      expireInSeconds : json['expireInSeconds'],
      tenantId : json['tenantId'],
      userId : json['userId'],
      permissions : json['grantedPermissions'].cast<String>(),
       user :json['user'] != null ? User.fromJson(json['user']) : null,
      isFeatureCustomized:json['isFeatureCustomized'],
      isGalleryRestricted: json['isGalleryRestricted'],
    );
  }

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    expireInSeconds,
    tenantId,
    userId,
    timeZone,
    permissions,
    encryptedPassword,
    isFeatureCustomized,
    isGalleryRestricted,
  ];

}

class User {
  int? id;
  String? userName;
  String? email;
  String? firstName;
  String? lastName;
  int? tenantId;
  bool? isActive;

  User(
      {this.id,
      this.userName,
      this.email,
      this.firstName,
      this.lastName,
      this.tenantId,
      this.isActive});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      tenantId: json['tenantId'],
      isActive: json['isActive'],
    );
  }

}