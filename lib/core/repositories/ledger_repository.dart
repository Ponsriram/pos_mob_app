import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

// ── Models ─────────────────────────────────────────────

class TaxRuleModel {
  final String id;
  final String groupId;
  final String name;
  final double rate;

  const TaxRuleModel({
    required this.id,
    required this.groupId,
    required this.name,
    required this.rate,
  });

  factory TaxRuleModel.fromJson(Map<String, dynamic> json) {
    return TaxRuleModel(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      name: json['name'] as String? ?? '',
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
    );
  }
}

class TaxGroupModel {
  final String id;
  final String storeId;
  final String name;
  final String? description;
  final bool isInclusive;
  final bool isActive;
  final List<TaxRuleModel> rules;

  const TaxGroupModel({
    required this.id,
    required this.storeId,
    required this.name,
    this.description,
    required this.isInclusive,
    required this.isActive,
    this.rules = const [],
  });

  factory TaxGroupModel.fromJson(Map<String, dynamic> json) {
    return TaxGroupModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      isInclusive: json['is_inclusive'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      rules:
          (json['rules'] as List?)
              ?.map((e) => TaxRuleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CityLedgerAccountModel {
  final String id;
  final String storeId;
  final String name;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;
  final String? gstNumber;
  final double creditLimit;
  final double currentBalance;
  final bool isActive;
  final DateTime createdAt;

  const CityLedgerAccountModel({
    required this.id,
    required this.storeId,
    required this.name,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.gstNumber,
    required this.creditLimit,
    required this.currentBalance,
    required this.isActive,
    required this.createdAt,
  });

  factory CityLedgerAccountModel.fromJson(Map<String, dynamic> json) {
    return CityLedgerAccountModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String? ?? '',
      contactPerson: json['contact_person'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      gstNumber: json['gst_number'] as String?,
      creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 0,
      currentBalance: (json['current_balance'] as num?)?.toDouble() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

class CityLedgerTransactionModel {
  final String id;
  final String accountId;
  final String transactionType;
  final double amount;
  final String? orderId;
  final String? description;
  final String? reference;
  final String? createdBy;
  final DateTime createdAt;

  const CityLedgerTransactionModel({
    required this.id,
    required this.accountId,
    required this.transactionType,
    required this.amount,
    this.orderId,
    this.description,
    this.reference,
    this.createdBy,
    required this.createdAt,
  });

  factory CityLedgerTransactionModel.fromJson(Map<String, dynamic> json) {
    return CityLedgerTransactionModel(
      id: json['id'] as String,
      accountId: json['account_id'] as String,
      transactionType: json['transaction_type'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      orderId: json['order_id'] as String?,
      description: json['description'] as String?,
      reference: json['reference'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

// ── Abstract Interface ─────────────────────────────────

abstract class LedgerRepository {
  // Tax Groups
  Future<Either<Failure, TaxGroupModel>> createTaxGroup(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<TaxGroupModel>>> listTaxGroups({
    required String storeId,
  });
  Future<Either<Failure, TaxGroupModel>> updateTaxGroup(
    String groupId,
    Map<String, dynamic> data,
  );

  // City Ledger Accounts
  Future<Either<Failure, CityLedgerAccountModel>> createAccount(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<CityLedgerAccountModel>>> listAccounts({
    required String storeId,
    bool activeOnly = true,
  });
  Future<Either<Failure, CityLedgerAccountModel>> updateAccount(
    String accountId,
    Map<String, dynamic> data,
  );

  // Transactions
  Future<Either<Failure, CityLedgerTransactionModel>> createTransaction(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<CityLedgerTransactionModel>>> listTransactions({
    required String accountId,
    int limit = 50,
    int offset = 0,
  });
}

// ── Implementation ─────────────────────────────────────

class LedgerRepositoryImpl implements LedgerRepository {
  final ApiClient _client;
  LedgerRepositoryImpl(this._client);

  // ── Tax Groups ──

  @override
  Future<Either<Failure, TaxGroupModel>> createTaxGroup(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/ledger/tax-groups', data: data);
      return right(TaxGroupModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<TaxGroupModel>>> listTaxGroups({
    required String storeId,
  }) async {
    try {
      final data = await _client.get(
        '/ledger/tax-groups',
        queryParameters: {'store_id': storeId},
      );
      final list = (data as List)
          .map((e) => TaxGroupModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, TaxGroupModel>> updateTaxGroup(
    String groupId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/ledger/tax-groups/$groupId',
        data: data,
      );
      return right(TaxGroupModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── City Ledger Accounts ──

  @override
  Future<Either<Failure, CityLedgerAccountModel>> createAccount(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/ledger/accounts', data: data);
      return right(
        CityLedgerAccountModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CityLedgerAccountModel>>> listAccounts({
    required String storeId,
    bool activeOnly = true,
  }) async {
    try {
      final data = await _client.get(
        '/ledger/accounts',
        queryParameters: {'store_id': storeId, 'active_only': activeOnly},
      );
      final list = (data as List)
          .map(
            (e) => CityLedgerAccountModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, CityLedgerAccountModel>> updateAccount(
    String accountId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/ledger/accounts/$accountId',
        data: data,
      );
      return right(
        CityLedgerAccountModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Transactions ──

  @override
  Future<Either<Failure, CityLedgerTransactionModel>> createTransaction(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/ledger/transactions', data: data);
      return right(
        CityLedgerTransactionModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CityLedgerTransactionModel>>> listTransactions({
    required String accountId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final data = await _client.get(
        '/ledger/transactions',
        queryParameters: {
          'account_id': accountId,
          'limit': limit,
          'offset': offset,
        },
      );
      final list = (data as List)
          .map(
            (e) =>
                CityLedgerTransactionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }
}
