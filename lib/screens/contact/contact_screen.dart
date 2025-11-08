import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pelviease_website/backend/providers/auth_provider.dart';
import 'package:pelviease_website/backend/providers/contact_provider.dart';
import 'package:pelviease_website/widgets/footer.dart';
import 'package:provider/provider.dart';

// Assuming these are your theme colors
const Color lightcyclamen = Color(0xFFF8C8DC);

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: isMobile
              ? _buildMobileLayout(context, size)
              : _buildDesktopLayout(context, size),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, Size size) {
    return Column(
      children: [
        // Contact Us Box
        Container(
          width: size.width * 0.9,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF483149),
            borderRadius: BorderRadius.circular(42),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Contact Us',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '+91 91826 64777',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'techarinoinnovpvtltd@gmail.com',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_pin, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'H.NO. 7-1-302/45/4, 5th Floor, B.K Guda, Sanjeev Reddy Nagar,\nAmeerpet, Hyderabad-500038, Telangana.',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 120,
                child: Image.asset(
                  'assets/images/contactus.png',
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.image, color: Colors.white),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Reach Out Anytime Form
        Container(
          width: size.width * 0.9,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightcyclamen,
            borderRadius: BorderRadius.circular(42),
          ),
          child: const ContactForm(),
        ),
        const SizedBox(
          height: 20,
        ),
        const FooterSection(),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, Size size) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                color: Colors.white,
                width: size.width * 0.7,
                height: size.height * 0.8,
              ),
              // Reach Out Anytime Form Box
              Positioned(
                right: 20,
                top: 32,
                child: Container(
                  width: size.width * 0.5,
                  height: size.height * 0.75,
                  decoration: BoxDecoration(
                    color: lightcyclamen,
                    borderRadius: BorderRadius.circular(42),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      SizedBox(width: size.width * 0.11),
                      Expanded(child: ContactForm()),
                    ],
                  ),
                ),
              ),
              // Contact Us Box
              Positioned(
                left: 0,
                top: 46,
                bottom: 24,
                child: Container(
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Color(0xFF483149),
                    borderRadius: BorderRadius.circular(42),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Contact Us',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.phone,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '+91 91826 64777',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.email,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'techarinoinnovpvtltd@gmail.com',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'H.NO. 7-1-302/45/4, 5th Floor, B.K Guda, Sanjeev Reddy Nagar,\nAmeerpet, Hyderabad-500038, Telangana.',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 120,
                        child: Image.asset(
                          'assets/images/contactus.png',
                          height: 80,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:
                                  const Icon(Icons.image, color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const FooterSection(),
        ],
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  bool isSubmiting = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();

  void _submitForm(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated == false) {
      context.goNamed("authScreen");
      return;
    }

    if (!context.mounted) return;
    setState(() {
      isSubmiting = true;
    });

    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ContactProvider>(context, listen: false);
      await provider.submitForm(
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        company: _companyController.text,
        subject: _subjectController.text,
        question: _questionController.text,
        context: context,
      );
    }
    // clear all controller
    _formKey.currentState!.reset();
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _companyController.clear();
    _subjectController.clear();
    _questionController.clear();
    setState(() {
      isSubmiting = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _subjectController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Reach Out Anytime',
                style: TextStyle(
                  color: const Color(0xFF4A2C6D),
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Name and Phone Fields
              isMobile
                  ? Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name *',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFF4A2C6D), width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFF4A2C6D), width: 2),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name *',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xFF4A2C6D), width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xFF4A2C6D), width: 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 15),
              // Email and Company Fields
              isMobile
                  ? Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email *',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFF4A2C6D), width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _companyController,
                          decoration: InputDecoration(
                            labelText: 'Company',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFF4A2C6D), width: 2),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email *',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xFF4A2C6D), width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _companyController,
                            decoration: InputDecoration(
                              labelText: 'Company',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xFF4A2C6D), width: 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 15),
              // Subject Field
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject *',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFF4A2C6D), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              // Question Field
              TextFormField(
                controller: _questionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Question *',
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFF4A2C6D), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () => _submitForm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A2C6D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Submit',
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
  }
}
