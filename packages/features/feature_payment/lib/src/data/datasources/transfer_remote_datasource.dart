// packages/features/feature_payment/lib/src/data/datasources/transfer_remote_datasource.dart

import "dart:convert";
import "package:core_network/core_network.dart";
import "package:dio/dio.dart";
import "../models/transfer_receipt_model.dart";

abstract class TransferRemoteDataSource {
  Future<TransferReceiptModel> postTransfer({
    required String sourceId,
    required String targetId,
    required double amount,
    required String currency,
  });
}

class TransferRemoteDataSourceImpl implements TransferRemoteDataSource {
  final ApiClient _apiClient;

  const TransferRemoteDataSourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<TransferReceiptModel> postTransfer({
    required String sourceId,
    required String targetId,
    required double amount,
    required String currency,
  }) async {
    try {
      final payload = {
        "source_account": sourceId,
        "target_account": targetId,
        "amount": amount,
        "currency": currency,
      };

      final response = await _apiClient.client.post(
        "/v1/transfers",
        data: jsonEncode(payload),
      );

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> dataMap = response.data as Map<String, dynamic>;
        return TransferReceiptModel.fromJson(dataMap);
      } else {
        throw ServerException(
          message: "Transfer authorization rejected.",
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? "Network error occurred during payment execution.",
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: "Unexpected error during payment execution: $e");
    }
  }
}

