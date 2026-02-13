
// import 'package:flutter/material.dart';
// import 'package:medical_delivery_app/widget/home_chart_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:medical_delivery_app/withdrawl/withdrawl_screen.dart';
// import 'package:medical_delivery_app/providers/wallet_provider.dart';
// import 'package:medical_delivery_app/providers/chart_provider.dart';

// class WalletScreen extends StatefulWidget {
//   const WalletScreen({super.key});

//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }

// class _WalletScreenState extends State<WalletScreen> {
//   String selectedTimePeriod = 'thisWeek';
  
//   final Map<String, String> timePeriodLabels = {
//     'today': 'Today',
//     'thisWeek': 'This Week',
//     'one Month': 'One Month',
//     'three Month': 'Three Month',
//     'six Months': 'Six Month',
//     '12 Months': '12 Months',
//   };

//   @override
//   void initState() {
//     super.initState();
//     // Load wallet data when screen initializes
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadData();
//     });
//   }

//   // Separate method for loading data
//   Future<void> _loadData() async {
//     await context.read<WalletProvider>().loadWalletData();
//     await context.read<ChartProvider>().fetchChartData(filter: selectedTimePeriod);
//   }

//   Future<void> _refreshWalletData() async {
//     await context.read<WalletProvider>().refreshWalletData();
    
//     await context.read<ChartProvider>().fetchChartData(filter: selectedTimePeriod);
//   }
  
//   void _onTimePeriodChanged(String? newValue) {
//     if (newValue != null && newValue != selectedTimePeriod) {
//       setState(() {
//         selectedTimePeriod = newValue;
//       });
//       // Fetch new chart data based on selected time period
//       context.read<ChartProvider>().fetchChartData(filter: selectedTimePeriod);
//     }
//   }

//   // Update the withdrawal button navigation to handle refresh
//   Future<void> _navigateToWithdrawal() async {
//     // Navigate and wait for result
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const WithdrawlScreen(),
//       ),
//     );
    
//     // If withdrawal was successful, refresh data
//     if (result == true && mounted) {
//       await _refreshWalletData();
//       setState(() {}); // Rebuild to show updated data
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: Container(
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(
//             Icons.person_outline,
//             color: Colors.black,
//             size: 25,
//           ),
//         ),
//         title: const Text(
//           'Wallet',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: Consumer<WalletProvider>(
//         builder: (context, walletProvider, child) {
//           if (walletProvider.isLoading && !walletProvider.hasData) {
//             return const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text(
//                     'Loading wallet data...',
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (walletProvider.hasError && !walletProvider.hasData) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.error_outline,
//                       size: 64,
//                       color: Colors.grey[400],
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Failed to load wallet data',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey[800],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       walletProvider.errorMessage ?? 'Unknown error occurred',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () => walletProvider.retryLoadWalletData(),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF6C63FF),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           return RefreshIndicator(
//             onRefresh: _refreshWalletData,
//             color: const Color(0xFF6C63FF),
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 20),
                    
//                     // Total Earnings Section
//                     Text(
//                       walletProvider.earningsDateRange.isNotEmpty
//                           ? 'Total Earnings On ${walletProvider.earningsDateRange}'
//                           : 'Total Earnings On 10 Apr - 16 Apr',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           walletProvider.totalEarnings,
//                           style: const TextStyle(
//                             fontSize: 36,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),
//                     const Divider(),
//                     const SizedBox(height: 30),

//                     // Wallet Balance and Customer Tips Section
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Colors.grey[300]!, width: 1),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Wallet Balance',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey[600],
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   walletProvider.walletBalance,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Colors.grey[300]!, width: 1),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Customer Tips',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey[600],
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   walletProvider.customerTips,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 30),

//                     // Your Earnings Section with Dropdown
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Your Earnings',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey[300]!),
//                             borderRadius: BorderRadius.circular(30),
//                             color: Colors.white,
//                           ),
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButton<String>(
//                               value: selectedTimePeriod,
//                               icon: Icon(
//                                 Icons.keyboard_arrow_down,
//                                 color: Colors.grey[600],
//                                 size: 20,
//                               ),
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               dropdownColor: Colors.white,
//                               elevation: 8,
//                               borderRadius: BorderRadius.circular(8),
//                               items: timePeriodLabels.entries.map((entry) {
//                                 return DropdownMenuItem<String>(
//                                   value: entry.key,
//                                   child: Text(
//                                     entry.value,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                               onChanged: _onTimePeriodChanged,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),

//                     // Chart Container
//                     Container(
//                       height: 300,
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey[200]!),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             spreadRadius: 1,
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: CustomLineChart(),
//                     ),

//                     const SizedBox(height: 20),

//                     // Error message if any (while data exists)
//                     if (walletProvider.hasError && walletProvider.hasData)
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 20),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.red[50],
//                           border: Border.all(color: Colors.red[200]!),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.warning_amber, color: Colors.red[700], size: 16),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 'Failed to refresh: ${walletProvider.errorMessage}',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.red[700],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                     // Withdraw Button - UPDATED
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: OutlinedButton(
//                         onPressed: _navigateToWithdrawal, // Use the new navigation method
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(
//                             color: Color(0xFF6C63FF),
//                             width: 2,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           backgroundColor: Colors.white,
//                           elevation: 0,
//                         ),
//                         child: const Text(
//                           'Withdrawl',
//                           style: TextStyle(
//                             color: Color(0xFF6C63FF),
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
                    
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }