
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_delivery_app/providers/add_bankdetails_provider.dart';
import 'package:medical_delivery_app/providers/withdraw_wallet_provider.dart';
import 'package:medical_delivery_app/view/account/add_account_details.dart';
import 'package:provider/provider.dart';
import 'package:medical_delivery_app/providers/wallet_provider.dart';

class WithdrawlScreen extends StatefulWidget {
  const WithdrawlScreen({super.key});

  @override
  State<WithdrawlScreen> createState() => _WithdrawlScreenState();
}

class _WithdrawlScreenState extends State<WithdrawlScreen> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  int? _selectedAccountIndex;

  @override
  void initState() {
    super.initState();
    // Ensure wallet data is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().autoRefreshIfNeeded();
      // Load bank details
      context.read<AddBankDetailsProvider>().getBankDetails();
      // Load withdrawal history
      context.read<WithdrawWalletProvider>();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _selectAccount(int index) {
    setState(() {
      _selectedAccountIndex = index;
    });
  }

  double? _getEnteredAmount() {
    try {
      final text = _amountController.text.trim();
      if (text.isEmpty) return null;
      return double.parse(text);
    } catch (e) {
      return null;
    }
  }

  bool _isValidWithdrawal(WalletProvider walletProvider, AddBankDetailsProvider bankProvider) {
    final enteredAmount = _getEnteredAmount();
    if (enteredAmount == null || enteredAmount <= 0) return false;
    if (_selectedAccountIndex == null || bankProvider.bankDetailsList.isEmpty) return false;
    return true;
  }

  String? _getWithdrawalError(WalletProvider walletProvider, AddBankDetailsProvider bankProvider) {
    final enteredAmount = _getEnteredAmount();
    
    if (enteredAmount == null) return null;
    
    if (enteredAmount <= 0) {
      return 'Please enter a valid amount';
    }
    
    if (_selectedAccountIndex == null || bankProvider.bankDetailsList.isEmpty) {
      return 'Please select a bank account';
    }
    
    return null;
  }

  Future<void> _processWithdrawal(WalletProvider walletProvider, AddBankDetailsProvider bankProvider, WithdrawWalletProvider withdrawProvider) async {
    // Clear any previous messages
    withdrawProvider.clearMessages();

    final amount = _getEnteredAmount()!;
    final selectedAccount = bankProvider.bankDetailsList[_selectedAccountIndex!];
    
    // Call the provider's withdraw method
    final success = await withdrawProvider.submitWithdrawal(
      amount: amount,
      bankId: selectedAccount.id!, // Assuming the bank model has an id field
    );

    if (success && mounted) {
      await walletProvider.refreshWalletData();
      // Show success dialog and navigate back
      _showWithdrawalSuccessDialog(amount, selectedAccount.bankName);
      // Refresh wallet data
      // walletProvider.refreshWalletData();
      // Clear the form
      _amountController.clear();
      setState(() {
        _selectedAccountIndex = null;
      });
    }
    // Error handling is done automatically by the provider
  }

  void _showWithdrawalSuccessDialog(double amount, String bankName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 28,
            ),
            SizedBox(width: 12),
            Text('Successful'),
          ],
        ),
        content: Text(
          'Your withdrawal of ₹${amount.toStringAsFixed(2)} to $bankName has been processed successfully. The amount will be credited to your bank account within 2-3 business days.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(true); // 👈 RETURN RESULT
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountsList(AddBankDetailsProvider bankProvider) {
    if (bankProvider.isLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (bankProvider.errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700], size: 24),
            const SizedBox(height: 8),
            Text(
              'Error loading bank accounts',
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              bankProvider.errorMessage!,
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => bankProvider.getBankDetails(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (bankProvider.bankDetailsList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No Bank Accounts Added',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please add a bank account to proceed with withdrawal',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ...bankProvider.bankDetailsList.asMap().entries.map((entry) {
          final index = entry.key;
          final bankDetails = entry.value;
          final isSelected = _selectedAccountIndex == index;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => _selectAccount(index),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6C63FF)
                        : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    // Bank Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Color(0xFF6C63FF),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Bank Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bankDetails.bankName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            bankDetails.accountHolderName,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '**** **** ${bankDetails.accountNumber.substring(bankDetails.accountNumber.length - 4)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (bankDetails.upiId.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.payment,
                                  size: 12,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  bankDetails.upiId,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Checkbox
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6C63FF)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF6C63FF)
                              : Colors.grey[400]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            ),
          ),
        ),
        title: const Text(
          'Withdrawal',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Consumer3<WalletProvider, AddBankDetailsProvider, WithdrawWalletProvider>(
        builder: (context, walletProvider, bankProvider, withdrawProvider, child) {
          if (walletProvider.isLoading && !walletProvider.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading wallet data...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          if (walletProvider.hasError && !walletProvider.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load wallet data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => walletProvider.retryLoadWalletData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Earnings Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      walletProvider.earningsDateRange.isNotEmpty
                          ? 'Total Earnings On ${walletProvider.earningsDateRange}'
                          : 'Total Earnings On 10 Apr - 16 Apr',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      walletProvider.totalEarnings,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),

                // Wallet and Tips Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wallet Balance',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              walletProvider.walletBalance,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer Tips',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              walletProvider.customerTips,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Enter Amount Section
                const Text(
                  'Enter Amount',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Amount Input Field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (_getWithdrawalError(walletProvider, bankProvider) != null || 
                             withdrawProvider.hasError)
                          ? Colors.red
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _amountController,
                    focusNode: _amountFocusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      setState(() {}); // Rebuild to update validation
                      // Clear previous messages when user starts typing
                      if (withdrawProvider.hasError || withdrawProvider.hasSuccess) {
                        withdrawProvider.clearMessages();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Withdrawal Amount',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      prefixText: '₹ ',
                      prefixStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                // Show withdrawal error or available balance
                const SizedBox(height: 8),
                if (_getWithdrawalError(walletProvider, bankProvider) != null)
                  Text(
                    _getWithdrawalError(walletProvider, bankProvider)!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),

                const SizedBox(height: 30),

                // Withdrawal Money To Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Withdraw Money To',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddAccountDetails(),
                          ),
                        );
                        // If account was added successfully, refresh the list
                        if (result == true) {
                          bankProvider.getBankDetails();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              color: Color(0xFF6C63FF),
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Add Account',
                              style: TextStyle(
                                color: Color(0xFF6C63FF),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Bank Accounts List
                _buildBankAccountsList(bankProvider),

                const SizedBox(height: 40),

                // Show withdrawal error from provider if any
                if (withdrawProvider.hasError)
                  Row(
                    children: [
                      // Icon(Icons.error, color: Colors.red[700], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Insufficient Wallet balance',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => withdrawProvider.clearError(),
                        icon: Icon(Icons.close, size: 16, color: Colors.red[700]),
                      ),
                    ],
                  ),

                // Show success message from provider if any
                if (withdrawProvider.hasSuccess)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      border: Border.all(color: Colors.green[200]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[700], size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            withdrawProvider.successMessage!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => withdrawProvider.clearSuccess(),
                          icon: Icon(Icons.close, size: 16, color: Colors.green[700]),
                        ),
                      ],
                    ),
                  ),

                // Withdraw Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: withdrawProvider.isWithdrawing
                        ? null
                        : (_isValidWithdrawal(walletProvider, bankProvider)
                            ? () => _processWithdrawal(walletProvider, bankProvider, withdrawProvider)
                            : null),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _isValidWithdrawal(walletProvider, bankProvider) &&
                                !withdrawProvider.isWithdrawing
                            ? const Color(0xFF6C63FF)
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: withdrawProvider.isWithdrawing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF6C63FF),
                              ),
                            ),
                          )
                        : Text(
                            'Confirm Withdrawal',
                            style: TextStyle(
                              color: _isValidWithdrawal(walletProvider, bankProvider) &&
                                      !withdrawProvider.isWithdrawing
                                  ? const Color(0xFF6C63FF)
                                  : Colors.grey[400],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}