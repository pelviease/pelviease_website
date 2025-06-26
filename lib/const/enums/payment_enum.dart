enum PaymentType {
  cash,
  creditCard,
  debitCard,
  bankTransfer,
  upi;

  @override
  String toString() {
    return switch (this) {
      PaymentType.cash => 'Cash',
      PaymentType.creditCard => 'Credit Card',
      PaymentType.debitCard => 'Debit Card',
      PaymentType.bankTransfer => 'Bank Transfer',
      PaymentType.upi => 'UPI',
    };
  }

  String get value => name;

  static PaymentType fromString(String value) {
    return switch (value) {
      'Cash' => PaymentType.cash,
      'Credit Card' => PaymentType.creditCard,
      'Debit Card' => PaymentType.debitCard,
      'Bank Transfer' => PaymentType.bankTransfer,
      'UPI' => PaymentType.upi,
      _ => PaymentType.cash,
    };
  }
}
