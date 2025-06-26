import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/models/order_item_model.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:pelviease_website/backend/providers/cart_provider.dart';
import 'package:pelviease_website/backend/providers/order_item_provider.dart';
import 'package:pelviease_website/const/enums/payment_enum.dart';
import 'package:pelviease_website/const/theme.dart';
import 'package:provider/provider.dart';

// Enum for address types
enum AddressType { home, office, other }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  PaymentType _selectedPayment = PaymentType.cash;
  String userId = "";
  String userName = "";
  // Map to track checkout status for each productId, defaulting to true
  final Map<String, bool> _checkoutStatus = {};
  AddressType _selectedAddressType = AddressType.home;

  // Controllers for dynamic address fields
  final _fullNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _streetController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      if (cartProvider.cartItems.isEmpty) {
        cartProvider.fetchCartItems();
      } else {
        for (var item in cartProvider.cartItems) {
          _checkoutStatus[item.productId] = true;
        }
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileNumberController.dispose();
    _pinCodeController.dispose();
    _houseNumberController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _loadUserDetails() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLoading) {
      Future.delayed(Duration(milliseconds: 200), _loadUserDetails);
      return;
    }
    userId = authProvider.user?.id ?? '';
    userName = authProvider.user?.name ?? '';
    print("User ID: $userId, User Name: $userName");
    final userAddress = authProvider.user?.address;
    if (userAddress == null || userAddress.isEmpty) {
      _fullNameController.text =
          userName.isNotEmpty ? userName : "Lokesh Surya Prakash";
      _mobileNumberController.text = "+916303642297";
      _pinCodeController.text = "641001";
      _houseNumberController.text = "22B";
      _streetController.text = "Green Farm Road";
      _landmarkController.text = "Near Coimbatore Dairy";
      _cityController.text = "Coimbatore";
      _stateController.text = "Tamil Nadu";
      _countryController.text = "India";
    } else {
      try {
        final Map<String, dynamic> addressMap =
            userAddress is Map<String, dynamic>
                ? userAddress as Map<String, dynamic>
                : {};
        _fullNameController.text = addressMap["fullName"] ?? userName;
        _mobileNumberController.text =
            addressMap["mobileNumber"] ?? "+91XXXXXXXXXX";
        _pinCodeController.text = addressMap["pinCode"] ?? "641001";
        _houseNumberController.text = addressMap["houseNumber"] ?? "22B";
        _streetController.text = addressMap["street"] ?? "Green Farm Road";
        _landmarkController.text =
            addressMap["landmark"] ?? "Near Coimbatore Dairy";
        _cityController.text = addressMap["city"] ?? "Coimbatore";
        _stateController.text = addressMap["state"] ?? "Tamil Nadu";
        _countryController.text = addressMap["country"] ?? "India";
      } catch (e) {
        print("Error parsing address: $e");
        _fullNameController.text = userName;
        _mobileNumberController.text = "+91XXXXXXXXXX";
      }
    }
  }

  Future<void> _updateUserAddressAndPhoneNumber(
      String userId, Map<String, dynamic> address, String phoneNumber) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user?.address == null ||
        authProvider.user!.address!.isEmpty) {
      try {
        await authProvider.updateAddressAndPhoneNumber(
            userId: userId, address: address, phoneNumber: phoneNumber);
      } catch (e) {
        print('Failed to update user address: $e');
      }
    }
  }

  void _placeOrder(CartProvider cartProvider, OrderProvider orderProvider) {
    if (!_formKey.currentState!.validate()) return;

    if (cartProvider.cartItems.isEmpty) return;

    // Map the address into the required structure
    final addressMap = {
      "fullName": _fullNameController.text,
      "mobileNumber": _mobileNumberController.text,
      "pinCode": _pinCodeController.text,
      "houseNumber": _houseNumberController.text,
      "street": _streetController.text,
      "landmark": _landmarkController.text,
      "city": _cityController.text,
      "state": _stateController.text,
      "country": _countryController.text,
      "addressType": _selectedAddressType.toString().split('.').last,
    };

    // Update user document with address if not exists
    _updateUserAddressAndPhoneNumber(
        userId, addressMap, _mobileNumberController.text);

    // Iterate through cart items and place orders only for checked items
    for (var cartItem in cartProvider.cartItems) {
      if (_checkoutStatus[cartItem.productId] ?? false) {
        final order = OrderItem(
          userId: userId,
          productId: cartItem.productId,
          description: cartItem.description,
          userName: userName,
          productName: cartItem.name,
          price: cartItem.price,
          quantity: cartItem.quantity,
          image: cartItem.image,
          address: addressMap,
          phoneNumber: _mobileNumberController.text,
          paymentType: _selectedPayment.name,
          orderDate: DateTime.now(),
          status: 'Shipped',
        );
        orderProvider.placeOrder(order, userId, userName);
        // Remove only the checked item from the cart
        cartProvider.removeItem(cartItem.productId);
      }
    }
    context.go('/orders');
  }

  @override
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Container(
          color: backgroundColor,
          child: cartProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : cartProvider.errorMessage != null
                  ? Center(child: Text(cartProvider.errorMessage!))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Orders',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            // Removed Expanded, added shrinkWrap: true to ListView.builder
                            ListView.builder(
                              shrinkWrap:
                                  true, // Allows the list to size to its content
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevents inner scrolling
                              itemCount: cartProvider.cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartProvider.cartItems[index];
                                if (!_checkoutStatus
                                    .containsKey(item.productId)) {
                                  _checkoutStatus[item.productId] = true;
                                }
                                return Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.pink[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value:
                                            _checkoutStatus[item.productId] ??
                                                true,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _checkoutStatus[item.productId] =
                                                value ?? false;
                                          });
                                        },
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Image.network(
                                          item.image,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(
                                              Icons.medical_services,
                                              color: Colors.purple[300],
                                              size: 36,
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              item.description,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              '₹ ${(item.price * item.quantity).toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Status: ${orderProvider.orders.isNotEmpty ? orderProvider.orders.last.status : 'Processing'}',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              'Estimated Delivery: ${DateTime.now().add(Duration(days: 10)).toString().split(' ')[0]}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'TOTAL: ₹ ${(item.price * item.quantity).toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Shipping Address',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _fullNameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Full Name',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your full name';
                                      }
                                      if (value.length < 2) {
                                        return 'Name must be at least 2 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: _mobileNumberController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Mobile Number',
                                    ),
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your mobile number';
                                      }
                                      if (!RegExp(r'^\+91\d{10}$')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid Indian mobile number (e.g., +911234567890)';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: _pinCodeController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Pin Code',
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: _houseNumberController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'House Number',
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: _streetController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Street',
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: _landmarkController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Landmark',
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: _cityController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'City',
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: _stateController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'State',
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextFormField(
                                    controller: _countryController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Country',
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  DropdownButton<AddressType>(
                                    value: _selectedAddressType,
                                    items: AddressType.values
                                        .map((AddressType type) {
                                      return DropdownMenuItem<AddressType>(
                                        value: type,
                                        child: Text(
                                            type.toString().split('.').last),
                                      );
                                    }).toList(),
                                    onChanged: (AddressType? newValue) {
                                      setState(() {
                                        _selectedAddressType = newValue!;
                                      });
                                    },
                                    hint: Text('Select Address Type'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Payment Option',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            DropdownButton<PaymentType>(
                              value: _selectedPayment,
                              items: PaymentType.values
                                  .map((PaymentType paymentType) {
                                return DropdownMenuItem<PaymentType>(
                                  value: paymentType,
                                  child: Text(paymentType.toString()),
                                );
                              }).toList(),
                              onChanged: (PaymentType? newValue) {
                                setState(() {
                                  _selectedPayment = newValue!;
                                });
                              },
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () =>
                                    _placeOrder(cartProvider, orderProvider),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Proceed to Checkout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
