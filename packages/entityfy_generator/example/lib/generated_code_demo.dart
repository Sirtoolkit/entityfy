// This file shows what the entityfy_generator actually generates
// This is for demonstration purposes - normally this would be auto-generated

// Example of what gets generated for a simple model:

/*
Given this input:

@Entityfy(generateEntity: true, generateUiModel: true)
class PersonModel {
  final String id;
  final String name;
  final int age;
  
  const PersonModel({
    required this.id,
    required this.name,
    required this.age,
  });
}

The generator would create:
*/

// ============================================================================
// GENERATED ENTITY CLASS
// ============================================================================

class PersonEntity {
  const PersonEntity({required this.id, required this.name, required this.age});

  factory PersonEntity.fromJson(Map<String, dynamic> json) {
    return PersonEntity(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      age: json['age'] as int? ?? 0,
    );
  }
  final String id;
  final String name;
  final int age;

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'age': age};
  }
}

// ============================================================================
// GENERATED UI MODEL CLASS
// ============================================================================

class PersonUiModel {
  const PersonUiModel({
    required this.id,
    required this.name,
    required this.age,
  });

  factory PersonUiModel.fromJson(Map<String, dynamic> json) {
    return PersonUiModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      age: json['age'] as int? ?? 0,
    );
  }
  final String id;
  final String name;
  final int age;

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'age': age};
  }
}

// ============================================================================
// GENERATED ENTITY MAPPER EXTENSION
// ============================================================================

// extension PersonModelEntityMapper on PersonModel {
//   PersonEntity toEntity() {
//     return PersonEntity(
//       id: id,
//       name: name,
//       age: age,
//     );
//   }
// }

// ============================================================================
// GENERATED UI MODEL MAPPER EXTENSION
// ============================================================================

// extension PersonEntityUiModelMapper on PersonEntity {
//   PersonUiModel toUiModel() {
//     return PersonUiModel(
//       id: id,
//       name: name,
//       age: age,
//     );
//   }
// }

void demonstrateGeneratedCode() {
  print('Example of Generated Code Usage:');
  print('================================');

  // Create sample data
  final person = PersonEntity(id: '1', name: 'Alice Johnson', age: 28);

  // Use generated fromJson
  final personFromJson = PersonEntity.fromJson({
    'id': '2',
    'name': 'Bob Smith',
    'age': 35,
  });

  // Use generated toJson
  final personJson = person.toJson();

  print('Created PersonEntity: ${person.name}, age ${person.age}');
  print('From JSON: ${personFromJson.name}, age ${personFromJson.age}');
  print('To JSON: $personJson');

  // If this were real generated code, you could also use:
  // final originalModel = PersonModel(id: '1', name: 'Alice', age: 28);
  // final entity = originalModel.toEntity();
  // final uiModel = entity.toUiModel();

  print('\n🔧 Generator Features Demonstrated:');
  print('  ✅ Automatic class generation');
  print('  ✅ JSON serialization methods');
  print('  ✅ Type-safe conversion');
  print('  ✅ Null-safe default values');
  print('  ✅ Preserves original constructor patterns');
}

// Example of what gets generated for nested models:

/*
Given nested models with @Entityfy:

@Entityfy(generateEntity: true)
class CompanyModel {
  final String id;
  final String name;
  final PersonModel owner;
  final List<PersonModel> employees;
}

The generated mapper would look like:

extension CompanyModelEntityMapper on CompanyModel {
  CompanyEntity toEntity() {
    return CompanyEntity(
      id: id,
      name: name,
      owner: owner.toEntity(),                    // Automatic nested conversion
      employees: employees.map((e) => e.toEntity()).toList(),  // List conversion
    );
  }
}
*/

void demonstrateNestedGeneration() {
  print('\n🔗 Nested Model Generation:');
  print('===========================');

  print('For nested models, the generator automatically:');
  print('  • Detects @Entityfy annotated properties');
  print('  • Calls .toEntity() on single nested objects');
  print('  • Maps .toEntity() over Lists of nested objects');
  print('  • Handles deep nesting recursively');
  print('  • Maintains type safety throughout');
}
