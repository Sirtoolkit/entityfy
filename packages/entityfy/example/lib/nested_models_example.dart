import 'package:entityfy/entityfy.dart';

// This file demonstrates nested model usage with @Entityfy annotation

part 'nested_models_example.entityfy.g.dart';

/// Address model that will be used in other models
@Entityfy(generateEntity: true, generateUiModel: true)
class AddressModel {

  const AddressModel({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String,
    );
  }
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }
}

/// User model with nested address
/// This demonstrates how nested models with @Entityfy work together
@Entityfy(generateEntity: true, generateUiModel: true)
class UserModel {

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.previousAddresses,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      previousAddresses: (json['previousAddresses'] as List<dynamic>)
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final AddressModel address;
  final List<AddressModel> previousAddresses;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address.toJson(),
      'previousAddresses': previousAddresses.map((e) => e.toJson()).toList(),
    };
  }
}

/// Company model with nested user models
@Entityfy(generateEntity: true)
class CompanyModel {

  const CompanyModel({
    required this.id,
    required this.name,
    required this.owner,
    required this.employees,
    required this.headquartersAddress,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      owner: UserModel.fromJson(json['owner'] as Map<String, dynamic>),
      employees: (json['employees'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      headquartersAddress: AddressModel.fromJson(
          json['headquartersAddress'] as Map<String, dynamic>),
    );
  }
  final String id;
  final String name;
  final UserModel owner;
  final List<UserModel> employees;
  final AddressModel headquartersAddress;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner': owner.toJson(),
      'employees': employees.map((e) => e.toJson()).toList(),
      'headquartersAddress': headquartersAddress.toJson(),
    };
  }
}
