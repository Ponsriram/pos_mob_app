import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

/// Employee model — maps to backend EmployeeResponse
class EmployeeModel {
  final String id;
  final String storeId;
  final String? userId;
  final String name;
  final String employeeCode;
  final String? phone;
  final String? email;
  final String role;
  final bool isActive;
  final Map<String, dynamic>? permissions;
  final DateTime createdAt;

  const EmployeeModel({
    required this.id,
    required this.storeId,
    this.userId,
    required this.name,
    required this.employeeCode,
    this.phone,
    this.email,
    this.role = 'cashier',
    this.isActive = true,
    this.permissions,
    required this.createdAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      userId: json['user_id'] as String?,
      name: json['name'] as String,
      employeeCode: json['employee_code'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String? ?? 'cashier',
      isActive: json['is_active'] as bool? ?? true,
      permissions: json['permissions'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

abstract class EmployeeRepository {
  Future<Either<Failure, List<EmployeeModel>>> getEmployees(String storeId);
  Future<Either<Failure, EmployeeModel>> createEmployee(
    Map<String, dynamic> data,
  );
}

class EmployeeRepositoryImpl implements EmployeeRepository {
  final ApiClient _client;

  EmployeeRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<EmployeeModel>>> getEmployees(
    String storeId,
  ) async {
    try {
      final response = await _client.get(
        '/employees',
        queryParameters: {'store_id': storeId},
      );
      final employees = (response as List)
          .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(employees);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to fetch employees: $e'));
    }
  }

  @override
  Future<Either<Failure, EmployeeModel>> createEmployee(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/employees', data: data);
      return right(EmployeeModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    } catch (e) {
      return left(Failure(message: 'Failed to create employee: $e'));
    }
  }
}
