import 'package:equatable/equatable.dart';

class GeneralInformationModal extends Equatable {
  final String? businessName;
  final String? businessNameAr;
  final String? emailAddress;
  final String? phoneCode;
  final String? phoneNumber;
  final String? address;
  final double? longitude;
  final double? latitude;
  final String? defaultLang;
  final int? currencyId;
  final int? countryId;
  final int? industryId;
  final String? timeZone;
  final double? tax;
  final double? walletBalance;
  final Logo? logo;
  final Currency? currency;
  final bool? isPaidSubscription;
  final bool? hasSubscribedBefore;
  final bool? isAutoRecurring;
  final String? subscriptionValidUntil;
  final int? packagePriceId;
  final String? subscriptionStartDate;
  final bool? sendBookingEmailToStaff;
  final bool? isStaffRestricted;

  const GeneralInformationModal({
    this.businessName,
    this.businessNameAr,
    this.emailAddress,
    this.phoneCode,
    this.phoneNumber,
    this.address,
    this.longitude,
    this.latitude,
    this.defaultLang,
    this.currencyId,
    this.countryId,
    this.industryId,
    this.timeZone,
    this.tax,
    this.walletBalance,
    this.logo,
    this.currency,
    this.isPaidSubscription,
    this.hasSubscribedBefore,
    this.isAutoRecurring,
    this.subscriptionValidUntil,
    this.packagePriceId,
    this.subscriptionStartDate,
    this.sendBookingEmailToStaff,
    this.isStaffRestricted,
  });

  factory GeneralInformationModal.fromJson(Map<String, dynamic> json) {
    return GeneralInformationModal(
      businessName: json['businessName'],
      businessNameAr: json['businessNameAr'],
      emailAddress: json['emailAddress'],
      phoneCode: json['phoneCode'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      defaultLang: json['defaultLang'],
      currencyId: json['currencyId'],
      countryId: json['countryId'],
      industryId: json['industryId'],
      timeZone: json['timeZone'],
      tax: json['tax'],
      isPaidSubscription: json['isPaidSubscription'],
      hasSubscribedBefore: json['hasSubscribedBefore'],
      isAutoRecurring: json['isAutoRecurring'],
      walletBalance: json['walletBalance'],
      logo: json['logo'] != null ? Logo.fromJson(json['logo']) : null,
      currency:
      json['currency'] != null ? Currency.fromJson(json['currency']) : null,
      subscriptionValidUntil: json['subscriptionValidUntil'],
      packagePriceId: json['packagePriceId'],
      subscriptionStartDate: json['subscriptionStartDate'],
      sendBookingEmailToStaff: json['sendBookingEmailToStaff'],
      isStaffRestricted: json['isStaffRestricted'],
    );
  }

  @override
  List<Object?> get props => [
    businessName,
    businessNameAr,
    emailAddress,
    phoneCode,
    phoneNumber,
    address,
    longitude,
    latitude,
    defaultLang,
    currencyId,
    countryId,
    industryId,
    timeZone,
    tax,
    isPaidSubscription,
    hasSubscribedBefore,
    isAutoRecurring,
    walletBalance,
    logo,
    currency,
    subscriptionValidUntil,
    packagePriceId,
    subscriptionStartDate,
    sendBookingEmailToStaff,
    isStaffRestricted,
  ];
}

class Logo extends Equatable {
  final int? id;
  final String? fileName;
  final String? generatedFileName;
  final String? fileType;
  final String? path;

  const Logo(
      {this.id,
        this.fileName,
        this.generatedFileName,
        this.fileType,
        this.path});

  factory Logo.fromJson(Map<String, dynamic> json) {
    return Logo(
      id: json['id'],
      fileName: json['fileName'],
      generatedFileName: json['generatedFileName'],
      fileType: json['fileType'],
      path: json['path'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    fileName,
    path,
    generatedFileName,
    fileType,
  ];
}

class Currency extends Equatable {
  final int? id;
  final String? currencyCode;
  final String? name;
  final String? nameAr;

  const Currency({this.id, this.currencyCode, this.name, this.nameAr});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'],
      currencyCode: json['currencyCode'],
      name: json['name'],
      nameAr: json['nameAr'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    nameAr,
    currencyCode,
  ];
}
