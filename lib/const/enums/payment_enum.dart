enum PaymentType {
  cash,
  // creditCard,
  // debitCard,
  // bankTransfer,
  // upi;
  online;

  @override
  String toString() {
    return switch (this) {
      PaymentType.cash => 'Cash',
      // PaymentType.creditCard => 'Credit Card',
      // PaymentType.debitCard => 'Debit Card',
      // PaymentType.bankTransfer => 'Bank Transfer',
      // PaymentType.upi => 'UPI',
      PaymentType.online => 'Online',
    };
  }

  String get value => name;

  static PaymentType fromString(String value) {
    return switch (value) {
      'Cash' => PaymentType.cash,
      // 'Credit Card' => PaymentType.creditCard,
      // 'Debit Card' => PaymentType.debitCard,
      // 'Bank Transfer' => PaymentType.bankTransfer,
      // 'UPI' => PaymentType.upi,
      'Online' => PaymentType.online,
      _ => PaymentType.cash,
    };
  }
}
