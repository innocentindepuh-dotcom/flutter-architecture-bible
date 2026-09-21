// packages/features/feature_payment/lib/src/domain/entities/transfer_receipt.dart

import "value_objects/money.dart";

class TransferReceipt {
  final String transactionReference;
  final DateTime timestamp;
  final Money debitedAmount;

  const TransferReceipt({
    required this.transactionReference;
    required this.timestamp;
    required this.debitedAmount;
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferReceipt &&
          runtimeType == other.runtimeType &&
          transactionReference == other.transactionReference;

  @override
  int get hashCode => transactionReference.hashCode;

  @override
  String toString() => "TransferReceipt(reference: $transactionReference, amount: $debitedAmount)";
}

