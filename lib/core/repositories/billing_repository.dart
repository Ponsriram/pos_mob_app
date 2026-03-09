import 'package:fpdart/fpdart.dart';
import 'package:pos_app/core/error/failure.dart';
import 'package:pos_app/core/error/api_exception.dart';
import 'package:pos_app/core/network/api_client.dart';

// ── Models ─────────────────────────────────────────────

class KOTItemModel {
  final String id;
  final String kotId;
  final String orderItemId;
  final String productName;
  final int quantity;
  final String? notes;

  const KOTItemModel({
    required this.id,
    required this.kotId,
    required this.orderItemId,
    required this.productName,
    required this.quantity,
    this.notes,
  });

  factory KOTItemModel.fromJson(Map<String, dynamic> json) {
    return KOTItemModel(
      id: json['id'] as String,
      kotId: json['kot_id'] as String,
      orderItemId: json['order_item_id'] as String,
      productName: json['product_name'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      notes: json['notes'] as String?,
    );
  }
}

class KOTModel {
  final String id;
  final String orderId;
  final String storeId;
  final String kotNumber;
  final String? kitchenSection;
  final String status;
  final int reprintCount;
  final DateTime createdAt;
  final List<KOTItemModel> items;

  const KOTModel({
    required this.id,
    required this.orderId,
    required this.storeId,
    required this.kotNumber,
    this.kitchenSection,
    required this.status,
    required this.reprintCount,
    required this.createdAt,
    this.items = const [],
  });

  factory KOTModel.fromJson(Map<String, dynamic> json) {
    return KOTModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      storeId: json['store_id'] as String,
      kotNumber: json['kot_number'] as String? ?? '',
      kitchenSection: json['kitchen_section'] as String?,
      status: json['status'] as String? ?? 'printed',
      reprintCount: json['reprint_count'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      items:
          (json['items'] as List?)
              ?.map((e) => KOTItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class InvoiceModel {
  final String id;
  final String orderId;
  final String storeId;
  final String invoiceNumber;
  final double grossAmount;
  final double taxAmount;
  final double discountAmount;
  final double serviceCharge;
  final double netAmount;
  final List<dynamic>? taxBreakdown;
  final DateTime issuedAt;

  const InvoiceModel({
    required this.id,
    required this.orderId,
    required this.storeId,
    required this.invoiceNumber,
    required this.grossAmount,
    required this.taxAmount,
    required this.discountAmount,
    required this.serviceCharge,
    required this.netAmount,
    this.taxBreakdown,
    required this.issuedAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      storeId: json['store_id'] as String,
      invoiceNumber: json['invoice_number'] as String? ?? '',
      grossAmount: (json['gross_amount'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      serviceCharge: (json['service_charge'] as num?)?.toDouble() ?? 0,
      netAmount: (json['net_amount'] as num?)?.toDouble() ?? 0,
      taxBreakdown: json['tax_breakdown'] as List?,
      issuedAt: json['issued_at'] != null
          ? DateTime.parse(json['issued_at'] as String)
          : DateTime.now(),
    );
  }
}

class BillTemplateModel {
  final String id;
  final String storeId;
  final String templateType;
  final String name;
  final String language;
  final String content;
  final String? headerText;
  final String? footerText;
  final String? logoUrl;
  final bool isDefault;
  final bool isActive;
  final DateTime createdAt;

  const BillTemplateModel({
    required this.id,
    required this.storeId,
    required this.templateType,
    required this.name,
    required this.language,
    required this.content,
    this.headerText,
    this.footerText,
    this.logoUrl,
    required this.isDefault,
    required this.isActive,
    required this.createdAt,
  });

  factory BillTemplateModel.fromJson(Map<String, dynamic> json) {
    return BillTemplateModel(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      templateType: json['template_type'] as String? ?? '',
      name: json['name'] as String? ?? '',
      language: json['language'] as String? ?? 'en',
      content: json['content'] as String? ?? '',
      headerText: json['header_text'] as String?,
      footerText: json['footer_text'] as String?,
      logoUrl: json['logo_url'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

// ── Abstract Interface ─────────────────────────────────

abstract class BillingRepository {
  // KOTs
  Future<Either<Failure, KOTModel>> createKOT(Map<String, dynamic> data);
  Future<Either<Failure, KOTModel>> getKOT(String kotId);
  Future<Either<Failure, List<KOTModel>>> listKOTs({
    required String storeId,
    String? orderId,
    String? status,
  });
  Future<Either<Failure, KOTModel>> updateKOTStatus(
    String kotId,
    Map<String, dynamic> data,
  );

  // Invoices
  Future<Either<Failure, InvoiceModel>> generateInvoice(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, InvoiceModel>> getInvoice(String invoiceId);
  Future<Either<Failure, List<InvoiceModel>>> listInvoices({
    required String storeId,
    int limit = 50,
    int offset = 0,
  });

  // Bill Templates
  Future<Either<Failure, BillTemplateModel>> createTemplate(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<BillTemplateModel>>> listTemplates({
    required String storeId,
    String? templateType,
  });
  Future<Either<Failure, BillTemplateModel>> updateTemplate(
    String templateId,
    Map<String, dynamic> data,
  );
}

// ── Implementation ─────────────────────────────────────

class BillingRepositoryImpl implements BillingRepository {
  final ApiClient _client;
  BillingRepositoryImpl(this._client);

  // ── KOTs ──

  @override
  Future<Either<Failure, KOTModel>> createKOT(Map<String, dynamic> data) async {
    try {
      final response = await _client.post('/billing/kots', data: data);
      return right(KOTModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, KOTModel>> getKOT(String kotId) async {
    try {
      final response = await _client.get('/billing/kots/$kotId');
      return right(KOTModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<KOTModel>>> listKOTs({
    required String storeId,
    String? orderId,
    String? status,
  }) async {
    try {
      final params = <String, dynamic>{'store_id': storeId};
      if (orderId != null) params['order_id'] = orderId;
      if (status != null) params['status'] = status;
      final data = await _client.get('/billing/kots', queryParameters: params);
      final list = (data as List)
          .map((e) => KOTModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, KOTModel>> updateKOTStatus(
    String kotId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/billing/kots/$kotId/status',
        data: data,
      );
      return right(KOTModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Invoices ──

  @override
  Future<Either<Failure, InvoiceModel>> generateInvoice(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/billing/invoices', data: data);
      return right(InvoiceModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, InvoiceModel>> getInvoice(String invoiceId) async {
    try {
      final response = await _client.get('/billing/invoices/$invoiceId');
      return right(InvoiceModel.fromJson(response as Map<String, dynamic>));
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<InvoiceModel>>> listInvoices({
    required String storeId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final params = <String, dynamic>{
        'store_id': storeId,
        'limit': limit,
        'offset': offset,
      };
      final data = await _client.get(
        '/billing/invoices',
        queryParameters: params,
      );
      final list = (data as List)
          .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  // ── Bill Templates ──

  @override
  Future<Either<Failure, BillTemplateModel>> createTemplate(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.post('/billing/templates', data: data);
      return right(
        BillTemplateModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<BillTemplateModel>>> listTemplates({
    required String storeId,
    String? templateType,
  }) async {
    try {
      final params = <String, dynamic>{'store_id': storeId};
      if (templateType != null) params['template_type'] = templateType;
      final data = await _client.get(
        '/billing/templates',
        queryParameters: params,
      );
      final list = (data as List)
          .map((e) => BillTemplateModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(list);
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }

  @override
  Future<Either<Failure, BillTemplateModel>> updateTemplate(
    String templateId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _client.put(
        '/billing/templates/$templateId',
        data: data,
      );
      return right(
        BillTemplateModel.fromJson(response as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      return left(apiFailure(e));
    }
  }
}
