class WalletModel {
  final String wallet;
  final String totalEarningsMessage;

  WalletModel({
    required this.wallet,
    required this.totalEarningsMessage,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      wallet: json['wallet'] ?? '₹0.00',
      totalEarningsMessage: json['totalEarningsMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet': wallet,
      'totalEarningsMessage': totalEarningsMessage,
    };
  }

  // Helper methods to extract numeric values
  double get walletAmount {
    try {
      String cleanedWallet = wallet.replaceAll('₹', '').replaceAll(',', '');
      return double.parse(cleanedWallet);
    } catch (e) {
      return 0.0;
    }
  }

  String get totalEarningsAmount {
    try {
      // Extract amount from message like "Total Earnings from 10 Apr - 16 Apr: ₹0.00"
      final regex = RegExp(r'₹([\d,]+\.?\d*)');
      final match = regex.firstMatch(totalEarningsMessage);
      if (match != null) {
        return '₹${match.group(1)}';
      }
      return '₹0.00';
    } catch (e) {
      return '₹0.00';
    }
  }

  String get earningsDateRange {
    try {
      // Extract date range from message
      final regex = RegExp(r'from (.+?):');
      final match = regex.firstMatch(totalEarningsMessage);
      if (match != null) {
        return match.group(1) ?? '';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  @override
  String toString() {
    return 'WalletModel{wallet: $wallet, totalEarningsMessage: $totalEarningsMessage}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletModel &&
          runtimeType == other.runtimeType &&
          wallet == other.wallet &&
          totalEarningsMessage == other.totalEarningsMessage;

  @override
  int get hashCode => wallet.hashCode ^ totalEarningsMessage.hashCode;
}