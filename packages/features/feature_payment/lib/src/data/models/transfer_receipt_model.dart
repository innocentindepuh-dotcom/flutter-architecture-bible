// packages/features/feature_payment/lib/src/data/models/transfer_receipt_model.dart

import "../../domain/entities/transfer_receipt.dart";
import "../../domain/value_objects/money.dart";

class TransferReceiptModel {
  final String reference;
  final String timestampIso;
  final double amount;
  final String currency;

  const TransferReceiptModel({
    required this.reference;
    required this.timestampIso;
    required this.amount;
    required this.currency;
  });

  factory TransferReceiptModel.fromJson(Map<String, dynamic> json) {
    return TransferReceiptModel(
      reference: json["reference"] as String,
      timestampIso: json["timestamp"] as String,
      amount: (json["amount"] as num).toDouble(),
      currency: json["currency"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "reference": reference,
      "timestamp": timestampIso,
      "amount": amount,
      "currency": currency,
    };
  }

  TransferReceipt toEntity() {
    final moneyEntity = Money.create(amount, currency).getOrElse(
      (failure) => throw FormatException("Corrupted financial currency payload: ${failure.message}"),
    );
    return TransferReceipt(
      transactionReference: reference,
      timestamp: DateTime.parse(timestampIso),
      debitedAmount: moneyEntity,
    );
  }
}

