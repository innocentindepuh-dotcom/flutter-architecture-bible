// packages/features/feature_payment/lib/src/domain/value_objects/money.dart

import "package:core_network/core_network.dart";
import "package:fpdart/fpdart.dart";

class Money {
  final double amount;
  final String currency;

  const Money._(this.amount, this.currency);

  static Either<Failure, Money> create(double amount, String currency) {
    if (amount <= 0) {
      return const Left(ValidationFailure(message: "Transfer amount must be strictly greater than zero."));
    }
    if (currency.trim().length != 3) {
      return const Left(ValidationFailure(message: "Invalid ISO currency code format."));
    }
    return Right(Money._(amount, currency.toUpperCase().trim()));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          currency == other.currency;

  @override
  int get hashCode => amount.hashCode ^ currency.hashCode;

  @override
  String toString() => "$currency ${amount.toStringAsFixed(2)}";
}

