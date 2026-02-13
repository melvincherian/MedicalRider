// import 'package:flutter/material.dart';

// class AddAccountDetails extends StatelessWidget {
//   const AddAccountDetails({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Add Account Details",
//           style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.blue,
//         leading: IconButton(onPressed: (){
//           Navigator.of(context).pop();
//         }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildTextField(
//                 label: "Account Holder Name",
//                 hint: "Enter account holder name",
//                 icon: Icons.person,
//               ),
//               const SizedBox(height: 16),
//               _buildTextField(
//                 label: "Account Number",
//                 hint: "Enter account number",
//                 icon: Icons.confirmation_number,
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 16),
//               _buildTextField(
//                 label: "IFSC Code",
//                 hint: "Enter IFSC code",
//                 icon: Icons.code,
//                 textCapitalization: TextCapitalization.characters,
//               ),
//               const SizedBox(height: 16),
//               _buildTextField(
//                 label: "Bank Name",
//                 hint: "Enter bank name",
//                 icon: Icons.account_balance,
//               ),
//               const SizedBox(height: 16),
//               _buildTextField(
//                 label: "UPI ID",
//                 hint: "example@upi",
//                 icon: Icons.payment,
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 2,
//                   ),
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       // handle save action
//                     }
//                   },
//                   child: const Text(
//                     "Save Details",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     TextCapitalization textCapitalization = TextCapitalization.none,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 6),
//         TextFormField(
//           keyboardType: keyboardType,
//           textCapitalization: textCapitalization,
//           decoration: InputDecoration(
//             prefixIcon: Icon(icon, color: Colors.blue),
//             hintText: hint,
//             filled: true,
//             fillColor: Colors.grey.shade100,
//             contentPadding:
//                 const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey.shade400),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: Colors.grey.shade300),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.teal, width: 1.5),
//             ),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Please enter $label";
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
// }














// add_account_details.dart
import 'package:flutter/material.dart';
import 'package:medical_delivery_app/providers/add_bankdetails_provider.dart';
import 'package:provider/provider.dart';

class AddAccountDetails extends StatefulWidget {
  const AddAccountDetails({super.key});

  @override
  State<AddAccountDetails> createState() => _AddAccountDetailsState();
}

class _AddAccountDetailsState extends State<AddAccountDetails> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for form fields
  final _accountHolderNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _upiIdController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _accountHolderNameController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _bankNameController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text('Success'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Text('Error'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = Provider.of<AddBankDetailsProvider>(context, listen: false);
    
    final success = await provider.addBankDetails(
      accountHolderName: _accountHolderNameController.text.trim(),
      accountNumber: _accountNumberController.text.trim(),
      ifscCode: _ifscCodeController.text.trim().toUpperCase(),
      bankName: _bankNameController.text.trim(),
      upiId: _upiIdController.text.trim().toLowerCase(),
    );

    if (success) {
      _showSuccessDialog('Bank details added successfully!');
    } else {
      _showErrorDialog(provider.errorMessage ?? 'Failed to add bank details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Account Details",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Consumer<AddBankDetailsProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show error message if any
                      if (provider.errorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, 
                                   color: Colors.red.shade600, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  provider.errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => provider.clearError(),
                                icon: Icon(Icons.close, 
                                          color: Colors.red.shade600, size: 18),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      
                      _buildTextField(
                        controller: _accountHolderNameController,
                        label: "Account Holder Name",
                        hint: "Enter account holder name",
                        icon: Icons.person,
                        validator: provider.validateAccountHolderName,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _accountNumberController,
                        label: "Account Number",
                        hint: "Enter account number",
                        icon: Icons.confirmation_number,
                        keyboardType: TextInputType.number,
                        validator: provider.validateAccountNumber,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _ifscCodeController,
                        label: "IFSC Code",
                        hint: "Enter IFSC code (e.g., HDFC0001234)",
                        icon: Icons.code,
                        textCapitalization: TextCapitalization.characters,
                        validator: provider.validateIFSCCode,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _bankNameController,
                        label: "Bank Name",
                        hint: "Enter bank name",
                        icon: Icons.account_balance,
                        validator: provider.validateBankName,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _upiIdController,
                        label: "UPI ID",
                        hint: "example@upi",
                        icon: Icons.payment,
                        keyboardType: TextInputType.emailAddress,
                        validator: provider.validateUPIId,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          onPressed: provider.isLoading ? null : _saveDetails,
                          child: provider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  "Save Details",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Loading overlay
              if (provider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.blue),
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}