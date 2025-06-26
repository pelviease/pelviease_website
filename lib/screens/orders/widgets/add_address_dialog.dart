import 'package:flutter/material.dart';
import 'package:pelviease_website/backend/models/order_item_model.dart';
import 'package:pelviease_website/backend/providers/checkout_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddAddressDialog extends StatefulWidget {
  const AddAddressDialog({super.key});

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  bool _isDefaultAddress = false;

  Color get primaryColor => Theme.of(context).colorScheme.primary;
  Color get secondaryColor => Theme.of(context).colorScheme.secondary;
  Color get accentColor => Theme.of(context).colorScheme.secondaryContainer;
  Color get backgroundColor => Theme.of(context).colorScheme.surface;
  Color get surfaceColor => Theme.of(context).colorScheme.surface;
  Color get textPrimaryColor =>
      Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
  Color get textSecondaryColor =>
      Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: textSecondaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: TextStyle(
          color: textPrimaryColor,
          fontSize: 16,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Add New Address',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Information Section
                      Text(
                        'Personal Information',
                        style: TextStyle(
                          color: textPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildTextFormField(
                        controller: _fullNameController,
                        label: 'Full Name *',
                        validator: (value) => value?.isEmpty == true
                            ? 'Please enter your full name'
                            : null,
                      ),

                      _buildTextFormField(
                        controller: _phoneNumberController,
                        label: 'Phone Number *',
                        keyboardType: TextInputType.phone,
                        validator: (value) => value?.isEmpty == true
                            ? 'Please enter your phone number'
                            : null,
                      ),

                      const SizedBox(height: 16),

                      // Address Information Section
                      Text(
                        'Address Information',
                        style: TextStyle(
                          color: textPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildTextFormField(
                        controller: _addressLine1Controller,
                        label: 'Address Line 1 *',
                        validator: (value) => value?.isEmpty == true
                            ? 'Please enter your address'
                            : null,
                      ),

                      _buildTextFormField(
                        controller: _addressLine2Controller,
                        label: 'Address Line 2 (Optional)',
                        validator: (value) => null,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              controller: _cityController,
                              label: 'City *',
                              validator: (value) => value?.isEmpty == true
                                  ? 'Please enter city'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextFormField(
                              controller: _stateController,
                              label: 'State *',
                              validator: (value) => value?.isEmpty == true
                                  ? 'Please enter state'
                                  : null,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              controller: _postalCodeController,
                              label: 'Postal Code *',
                              keyboardType: TextInputType.number,
                              validator: (value) => value?.isEmpty == true
                                  ? 'Please enter postal code'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextFormField(
                              controller: _countryController,
                              label: 'Country *',
                              validator: (value) => value?.isEmpty == true
                                  ? 'Please enter country'
                                  : null,
                            ),
                          ),
                        ],
                      ),

                      // Default Address Checkbox
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                value: _isDefaultAddress,
                                onChanged: (value) {
                                  setState(() {
                                    _isDefaultAddress = value ?? false;
                                  });
                                },
                                activeColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Set as default address',
                                    style: TextStyle(
                                      color: textPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Use this address for future orders',
                                    style: TextStyle(
                                      color: textSecondaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: textSecondaryColor, width: 1),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: textSecondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final address = DeliveryAddress(
                            id: const Uuid().v4(),
                            fullName: _fullNameController.text,
                            phoneNumber: _phoneNumberController.text,
                            addressLine1: _addressLine1Controller.text,
                            addressLine2: _addressLine2Controller.text,
                            city: _cityController.text,
                            state: _stateController.text,
                            postalCode: _postalCodeController.text,
                            country: _countryController.text,
                            isDefault: _isDefaultAddress,
                          );
                          await Provider.of<CheckoutProvider>(context,
                                  listen: false)
                              .addAddress(address);
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Address',
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
          ],
        ),
      ),
    );
  }
}
