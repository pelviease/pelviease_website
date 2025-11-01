@JS()
library;

import 'package:js/js.dart';

/// Razorpay JavaScript class binding
@JS('Razorpay')
class Razorpay {
  external Razorpay(RazorpayOptions options);
  external void open();
  external void on(String event, Function handler);
  external void close();
}

/// Razorpay options for the checkout
@JS()
@anonymous
class RazorpayOptions {
  external String get key;
  external String get amount;
  external String get currency;
  external String get name;
  external String get description;
  external String? get image;
  external String? get order_id;
  external Function get handler;
  external dynamic get prefill;
  external dynamic get notes;
  external dynamic get theme;
  external dynamic get modal;

  external factory RazorpayOptions({
    String key,
    String amount,
    String currency,
    String name,
    String description,
    String? image,
    String? order_id,
    Function handler,
    dynamic prefill,
    dynamic notes,
    dynamic theme,
    dynamic modal,
  });
}

/// Payment response structure
@JS()
@anonymous
class PaymentResponse {
  external String get razorpay_payment_id;
  external String? get razorpay_order_id;
  external String? get razorpay_signature;

  external factory PaymentResponse({
    String razorpay_payment_id,
    String? razorpay_order_id,
    String? razorpay_signature,
  });
}

/// Payment error structure
@JS()
@anonymous
class PaymentError {
  external String get code;
  external String get description;
  external String get source;
  external String get step;
  external String get reason;
  external dynamic get metadata;

  external factory PaymentError({
    String code,
    String description,
    String source,
    String step,
    String reason,
    dynamic metadata,
  });
}
