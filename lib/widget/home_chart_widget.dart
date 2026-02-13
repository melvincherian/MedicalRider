// // // import 'package:flutter/material.dart';

// // // class CustomLineChart extends StatelessWidget {
// // //   const CustomLineChart({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return CustomPaint(
// // //       size: const Size(double.infinity, double.infinity),
// // //       painter: LineChartPainter(),
// // //     );
// // //   }
// // // }

// // // class LineChartPainter extends CustomPainter {
// // //   final List<double> dataPoints = [200, 400, 300, 600, 200, 500, 450];
// // //   final List<String> labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

// // //   @override
// // //   void paint(Canvas canvas, Size size) {
// // //     final paint = Paint()
// // //       ..color = Colors.blue
// // //       ..strokeWidth = 2.5
// // //       ..style = PaintingStyle.stroke;

// // //     final fillPaint = Paint()
// // //       ..shader = LinearGradient(
// // //         colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.05)],
// // //         begin: Alignment.topCenter,
// // //         end: Alignment.bottomCenter,
// // //       ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
// // //       ..style = PaintingStyle.fill;

// // //     final gridPaint = Paint()
// // //       ..color = Colors.grey[300]!
// // //       ..strokeWidth = 0.5;

// // //     final textStyle = TextStyle(color: Colors.grey[600], fontSize: 10);

// // //     // Calculate positions
// // //     final padding = 40.0;
// // //     final chartWidth = size.width - padding * 2;
// // //     final chartHeight = size.height - padding * 2;
// // //     final maxValue = 800.0;
// // //     final stepX = chartWidth / (dataPoints.length - 1);

// // //     // Draw horizontal grid lines and y-axis labels
// // //     for (int i = 0; i <= 4; i++) {
// // //       final y = padding + chartHeight - (i * chartHeight / 4);
// // //       canvas.drawLine(
// // //         Offset(padding, y),
// // //         Offset(size.width - padding, y),
// // //         gridPaint,
// // //       );

// // //       // Y-axis labels
// // //       final value = (i * maxValue / 4).toInt();
// // //       final textPainter = TextPainter(
// // //         text: TextSpan(text: value.toString(), style: textStyle),
// // //         textDirection: TextDirection.ltr,
// // //       );
// // //       textPainter.layout();
// // //       textPainter.paint(
// // //         canvas,
// // //         Offset(padding - 30, y - textPainter.height / 2),
// // //       );
// // //     }

// // //     // Create path for line and fill
// // //     final linePath = Path();
// // //     final fillPath = Path();

// // //     // Start fill path from bottom
// // //     fillPath.moveTo(padding, padding + chartHeight);

// // //     for (int i = 0; i < dataPoints.length; i++) {
// // //       final x = padding + (i * stepX);
// // //       final y =
// // //           padding + chartHeight - (dataPoints[i] / maxValue * chartHeight);

// // //       if (i == 0) {
// // //         linePath.moveTo(x, y);
// // //         fillPath.lineTo(x, y);
// // //       } else {
// // //         linePath.lineTo(x, y);
// // //         fillPath.lineTo(x, y);
// // //       }

// // //       // Draw dots
// // //       canvas.drawCircle(Offset(x, y), 4, Paint()..color = Colors.blue);
// // //       canvas.drawCircle(Offset(x, y), 2, Paint()..color = Colors.white);

// // //       // Draw x-axis labels
// // //       if (i < labels.length) {
// // //         final textPainter = TextPainter(
// // //           text: TextSpan(text: labels[i], style: textStyle),
// // //           textDirection: TextDirection.ltr,
// // //         );
// // //         textPainter.layout();
// // //         textPainter.paint(
// // //           canvas,
// // //           Offset(x - textPainter.width / 2, size.height - 20),
// // //         );
// // //       }
// // //     }

// // //     // Close fill path
// // //     fillPath.lineTo(padding + chartWidth, padding + chartHeight);
// // //     fillPath.close();

// // //     // Draw fill first, then line
// // //     canvas.drawPath(fillPath, fillPaint);
// // //     canvas.drawPath(linePath, paint);
// // //   }

// // //   @override
// // //   bool shouldRepaint(CustomPainter oldDelegate) => false;
// // // }














// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:medical_delivery_app/providers/chart_provider.dart';
// // import 'package:medical_delivery_app/models/chart_model.dart';

// // class CustomLineChart extends StatelessWidget {
// //   const CustomLineChart({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<ChartProvider>(
// //       builder: (context, chartProvider, child) {
// //         if (chartProvider.isLoading) {
// //           return const Center(
// //             child: CircularProgressIndicator(),
// //           );
// //         }

// //         if (chartProvider.error.isNotEmpty) {
// //           return Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   Icons.error_outline,
// //                   color: Colors.red,
// //                   size: 48,
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Text(
// //                   'Failed to load chart data',
// //                   style: TextStyle(color: Colors.red, fontSize: 16),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 ElevatedButton(
// //                   onPressed: () => chartProvider.refreshData(),
// //                   child: const Text('Retry'),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }

// //         if (!chartProvider.hasChartData) {
// //           return const Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   Icons.show_chart,
// //                   color: Colors.grey,
// //                   size: 48,
// //                 ),
// //                 SizedBox(height: 16),
// //                 Text(
// //                   'No chart data available',
// //                   style: TextStyle(color: Colors.grey, fontSize: 16),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }

// //         return CustomPaint(
// //           size: const Size(double.infinity, double.infinity),
// //           painter: LineChartPainter(
// //             dataPoints: chartProvider.chartDataPoints,
// //             currentFilter: chartProvider.currentFilter,
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// // class LineChartPainter extends CustomPainter {
// //   final List<ChartData> dataPoints;
// //   final String currentFilter;

// //   LineChartPainter({
// //     required this.dataPoints,
// //     required this.currentFilter,
// //   });

// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     if (dataPoints.isEmpty) return;

// //     final paint = Paint()
// //       ..color = Colors.blue
// //       ..strokeWidth = 2.5
// //       ..style = PaintingStyle.stroke;

// //     final fillPaint = Paint()
// //       ..shader = LinearGradient(
// //         colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.05)],
// //         begin: Alignment.topCenter,
// //         end: Alignment.bottomCenter,
// //       ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
// //       ..style = PaintingStyle.fill;

// //     final gridPaint = Paint()
// //       ..color = Colors.grey[300]!
// //       ..strokeWidth = 0.5;

// //     final textStyle = TextStyle(color: Colors.grey[600], fontSize: 10);

// //     // Calculate positions
// //     final padding = 50.0;
// //     final chartWidth = size.width - padding * 2;
// //     final chartHeight = size.height - padding * 2;
    
// //     // Extract values and calculate max
// //     final values = dataPoints.map((e) => e.value ?? 0.0).toList();
// //     final maxValue = values.isNotEmpty 
// //         ? (values.reduce((a, b) => a > b ? a : b) * 1.2) // Add 20% padding
// //         : 100.0;
// //     final minValue = values.isNotEmpty 
// //         ? (values.reduce((a, b) => a < b ? a : b) * 0.8) // Reduce by 20% for padding
// //         : 0.0;
    
// //     final valueRange = maxValue - minValue;
// //     final stepX = dataPoints.length > 1 ? chartWidth / (dataPoints.length - 1) : 0;

// //     // Draw horizontal grid lines and y-axis labels
// //     for (int i = 0; i <= 4; i++) {
// //       final y = padding + chartHeight - (i * chartHeight / 4);
// //       canvas.drawLine(
// //         Offset(padding, y),
// //         Offset(size.width - padding, y),
// //         gridPaint,
// //       );

// //       // Y-axis labels
// //       final value = minValue + (i * valueRange / 4);
// //       final textPainter = TextPainter(
// //         text: TextSpan(
// //           text: '\$${value.toStringAsFixed(0)}',
// //           style: textStyle,
// //         ),
// //         textDirection: TextDirection.ltr,
// //       );
// //       textPainter.layout();
// //       textPainter.paint(
// //         canvas,
// //         Offset(padding - 35, y - textPainter.height / 2),
// //       );
// //     }

// //     // Create path for line and fill
// //     final linePath = Path();
// //     final fillPath = Path();

// //     // Start fill path from bottom
// //     fillPath.moveTo(padding, padding + chartHeight);

// //     for (int i = 0; i < dataPoints.length; i++) {
// //       final x = dataPoints.length == 1 
// //           ? padding + chartWidth / 2 
// //           : padding + (i * stepX);
      
// //       final normalizedValue = valueRange > 0 
// //           ? ((values[i] - minValue) / valueRange)
// //           : 0.0;
// //       final y = padding + chartHeight - (normalizedValue * chartHeight);

// //       if (i == 0) {
// //         linePath.moveTo(x, y);
// //         fillPath.lineTo(x, y);
// //       } else {
// //         linePath.lineTo(x, y);
// //         fillPath.lineTo(x, y);
// //       }

// //       // Draw dots with hover effect
// //       canvas.drawCircle(Offset(x, y), 5, Paint()..color = Colors.blue);
// //       canvas.drawCircle(Offset(x, y), 3, Paint()..color = Colors.white);

// //       // Draw value labels above dots
// //       final valueText = '\$${values[i].toStringAsFixed(0)}';
// //       final valueTextPainter = TextPainter(
// //         text: TextSpan(
// //           text: valueText,
// //           style: TextStyle(
// //             color: Colors.blue[700],
// //             fontSize: 9,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         textDirection: TextDirection.ltr,
// //       );
// //       valueTextPainter.layout();
// //       valueTextPainter.paint(
// //         canvas,
// //         Offset(x - valueTextPainter.width / 2, y - 20),
// //       );

// //       // Draw x-axis labels
// //       String label = _getLabel(dataPoints[i], i);
// //       final textPainter = TextPainter(
// //         text: TextSpan(text: label, style: textStyle),
// //         textDirection: TextDirection.ltr,
// //       );
// //       textPainter.layout();
// //       textPainter.paint(
// //         canvas,
// //         Offset(x - textPainter.width / 2, size.height - 25),
// //       );
// //     }

// //     // Close fill path
// //     if (dataPoints.length == 1) {
// //       fillPath.lineTo(padding + chartWidth / 2, padding + chartHeight);
// //     } else {
// //       fillPath.lineTo(padding + chartWidth, padding + chartHeight);
// //     }
// //     fillPath.close();

// //     // Draw fill first, then line
// //     canvas.drawPath(fillPath, fillPaint);
// //     canvas.drawPath(linePath, paint);

// //     // Draw chart title
// //     final titleTextPainter = TextPainter(
// //       text: TextSpan(
// //         text: _getChartTitle(),
// //         style: TextStyle(
// //           color: Colors.grey[800],
// //           fontSize: 14,
// //           fontWeight: FontWeight.bold,
// //         ),
// //       ),
// //       textDirection: TextDirection.ltr,
// //     );
// //     titleTextPainter.layout();
// //     titleTextPainter.paint(
// //       canvas,
// //       Offset(
// //         (size.width - titleTextPainter.width) / 2,
// //         10,
// //       ),
// //     );
// //   }

// //   String _getLabel(ChartData chartData, int index) {
// //     // Priority: label > date > time > index
// //     if (chartData.label != null && chartData.label!.isNotEmpty) {
// //       return chartData.label!;
// //     }
    
// //     if (chartData.date != null && chartData.date!.isNotEmpty) {
// //       // Try to format date if it's in a standard format
// //       try {
// //         final date = DateTime.parse(chartData.date!);
// //         switch (currentFilter) {
// //           case 'today':
// //           case 'yesterday':
// //             return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
// //           case 'thisWeek':
// //             return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
// //           case 'thisMonth':
// //             return '${date.day}';
// //           default:
// //             return '${date.day}/${date.month}';
// //         }
// //       } catch (e) {
// //         // If date parsing fails, return as is
// //         return chartData.date!.length > 6 
// //             ? chartData.date!.substring(0, 6) 
// //             : chartData.date!;
// //       }
// //     }
    
// //     if (chartData.time != null && chartData.time!.isNotEmpty) {
// //       return chartData.time!;
// //     }
    
// //     return 'Day ${index + 1}';
// //   }

// //   String _getChartTitle() {
// //     switch (currentFilter) {
// //       case 'today':
// //         return 'Today\'s Earnings';
// //       case 'yesterday':
// //         return 'Yesterday\'s Earnings';
// //       case 'thisWeek':
// //         return 'This Week\'s Earnings';
// //       case 'thisMonth':
// //         return 'This Month\'s Earnings';
// //       default:
// //         return 'Earnings Chart';
// //     }
// //   }

// //   @override
// //   bool shouldRepaint(LineChartPainter oldDelegate) {
// //     return dataPoints != oldDelegate.dataPoints ||
// //         currentFilter != oldDelegate.currentFilter;
// //   }
// // }

// // // Usage Widget
// // class ChartScreen extends StatefulWidget {
// //   const ChartScreen({super.key});

// //   @override
// //   State<ChartScreen> createState() => _ChartScreenState();
// // }

// // class _ChartScreenState extends State<ChartScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Fetch initial data
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       context.read<ChartProvider>().fetchThisWeekChart();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Earnings Chart'),
// //         elevation: 0,
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black,
// //       ),
// //       body: Column(
// //         children: [
// //           // Summary Cards
// //           Container(
// //             padding: const EdgeInsets.all(16),
// //             child: Consumer<ChartProvider>(
// //               builder: (context, chartProvider, child) {
// //                 return Row(
// //                   children: [
// //                     Expanded(
// //                       child: _buildSummaryCard(
// //                         'Total Earnings',
// //                         chartProvider.formattedTotalEarnings,
// //                         Icons.trending_up,
// //                         Colors.green,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 16),
// //                     Expanded(
// //                       child: _buildSummaryCard(
// //                         'Wallet Balance',
// //                         chartProvider.formattedWalletBalance,
// //                         Icons.account_balance_wallet,
// //                         Colors.blue,
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),

// //           // Filter Buttons
// //           Container(
// //             height: 50,
// //             padding: const EdgeInsets.symmetric(horizontal: 16),
// //             child: Consumer<ChartProvider>(
// //               builder: (context, chartProvider, child) {
// //                 return Row(
// //                   children: [
// //                     _buildFilterChip('Today', 'today', chartProvider),
// //                     const SizedBox(width: 8),
// //                     _buildFilterChip('Yesterday', 'yesterday', chartProvider),
// //                     const SizedBox(width: 8),
// //                     _buildFilterChip('This Week', 'thisWeek', chartProvider),
// //                     const SizedBox(width: 8),
// //                     _buildFilterChip('This Month', 'thisMonth', chartProvider),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),

// //           // Chart
// //           Expanded(
// //             child: Container(
// //               margin: const EdgeInsets.all(16),
// //               padding: const EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(12),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.grey.withOpacity(0.1),
// //                     spreadRadius: 1,
// //                     blurRadius: 10,
// //                     offset: const Offset(0, 1),
// //                   ),
// //                 ],
// //               ),
// //               child: const CustomLineChart(),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: color.withOpacity(0.2)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(icon, color: color, size: 20),
// //               const SizedBox(width: 8),
// //               Text(
// //                 title,
// //                 style: TextStyle(
// //                   fontSize: 12,
// //                   color: Colors.grey[600],
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //               color: color,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFilterChip(String label, String filter, ChartProvider provider) {
// //     final isSelected = provider.currentFilter == filter;
// //     return GestureDetector(
// //       onTap: () => provider.fetchChartData(filter: filter),
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //         decoration: BoxDecoration(
// //           color: isSelected ? Colors.blue : Colors.grey[200],
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //         child: Text(
// //           label,
// //           style: TextStyle(
// //             color: isSelected ? Colors.white : Colors.grey[600],
// //             fontSize: 12,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }



















// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:medical_delivery_app/providers/chart_provider.dart';
// import 'package:medical_delivery_app/models/chart_model.dart';

// class CustomLineChart extends StatelessWidget {
//   const CustomLineChart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ChartProvider>(
//       builder: (context, chartProvider, child) {
//         if (chartProvider.isLoading) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         if (chartProvider.error.isNotEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   color: Colors.red,
//                   size: 48,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Failed to load chart data',
//                   style: TextStyle(color: Colors.red, fontSize: 16),
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: () => chartProvider.refreshData(),
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           );
//         }

//         if (!chartProvider.hasChartData) {
//           return const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.show_chart,
//                   color: Colors.grey,
//                   size: 48,
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'No chart data available',
//                   style: TextStyle(color: Colors.grey, fontSize: 16),
//                 ),
//               ],
//             ),
//           );
//         }

//         return CustomPaint(
//           size: const Size(double.infinity, double.infinity),
//           painter: LineChartPainter(
//             dataPoints: chartProvider.chartDataPoints,
//             currentFilter: chartProvider.currentFilter,
//           ),
//         );
//       },
//     );
//   }
// }

// class LineChartPainter extends CustomPainter {
//   final List<ChartData> dataPoints;
//   final String currentFilter;

//   LineChartPainter({
//     required this.dataPoints,
//     required this.currentFilter,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (dataPoints.isEmpty) return;

//     final paint = Paint()
//       ..color = Colors.blue
//       ..strokeWidth = 2.5
//       ..style = PaintingStyle.stroke;

//     final fillPaint = Paint()
//       ..shader = LinearGradient(
//         colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.05)],
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//       ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
//       ..style = PaintingStyle.fill;

//     final gridPaint = Paint()
//       ..color = Colors.grey[300]!
//       ..strokeWidth = 0.5;

//     final textStyle = TextStyle(color: Colors.grey[600], fontSize: 10);

//     // Calculate positions
//     final padding = 50.0;
//     final chartWidth = size.width - padding * 2;
//     final chartHeight = size.height - padding * 2;
    
//     // Extract values and calculate max
//     final values = dataPoints.map((e) => e.value ?? 0.0).toList();
//     final maxValue = values.isNotEmpty 
//         ? (values.reduce((a, b) => a > b ? a : b) * 1.2) // Add 20% padding
//         : 100.0;
//     final minValue = values.isNotEmpty 
//         ? (values.reduce((a, b) => a < b ? a : b) * 0.8) // Reduce by 20% for padding
//         : 0.0;
    
//     final valueRange = maxValue - minValue;
//     final stepX = dataPoints.length > 1 ? chartWidth / (dataPoints.length - 1) : 0;

//     // Draw horizontal grid lines and y-axis labels
//     for (int i = 0; i <= 4; i++) {
//       final y = padding + chartHeight - (i * chartHeight / 4);
//       canvas.drawLine(
//         Offset(padding, y),
//         Offset(size.width - padding, y),
//         gridPaint,
//       );

//       // Y-axis labels
//       final value = minValue + (i * valueRange / 4);
//       final textPainter = TextPainter(
//         text: TextSpan(
//           text: '\$${value.toStringAsFixed(0)}',
//           style: textStyle,
//         ),
//         textDirection: TextDirection.ltr,
//       );
//       textPainter.layout();
//       textPainter.paint(
//         canvas,
//         Offset(padding - 35, y - textPainter.height / 2),
//       );
//     }

//     // Create path for line and fill
//     final linePath = Path();
//     final fillPath = Path();

//     // Start fill path from bottom
//     fillPath.moveTo(padding, padding + chartHeight);

//     for (int i = 0; i < dataPoints.length; i++) {
//       final x = dataPoints.length == 1 
//           ? padding + chartWidth / 2 
//           : padding + (i * stepX);
      
//       final normalizedValue = valueRange > 0 
//           ? ((values[i] - minValue) / valueRange)
//           : 0.0;
//       final y = padding + chartHeight - (normalizedValue * chartHeight);

//       if (i == 0) {
//         linePath.moveTo(x, y);
//         fillPath.lineTo(x, y);
//       } else {
//         linePath.lineTo(x, y);
//         fillPath.lineTo(x, y);
//       }

//       // Draw dots with hover effect
//       canvas.drawCircle(Offset(x, y), 5, Paint()..color = Colors.blue);
//       canvas.drawCircle(Offset(x, y), 3, Paint()..color = Colors.white);

//       // Draw value labels above dots
//       final valueText = '\$${values[i].toStringAsFixed(0)}';
//       final valueTextPainter = TextPainter(
//         text: TextSpan(
//           text: valueText,
//           style: TextStyle(
//             color: Colors.blue[700],
//             fontSize: 9,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         textDirection: TextDirection.ltr,
//       );
//       valueTextPainter.layout();
//       valueTextPainter.paint(
//         canvas,
//         Offset(x - valueTextPainter.width / 2, y - 20),
//       );

//       // Draw x-axis labels
//       String label = _getLabel(dataPoints[i], i);
//       final textPainter = TextPainter(
//         text: TextSpan(text: label, style: textStyle),
//         textDirection: TextDirection.ltr,
//       );
//       textPainter.layout();
//       textPainter.paint(
//         canvas,
//         Offset(x - textPainter.width / 2, size.height - 25),
//       );
//     }

//     // Close fill path
//     if (dataPoints.length == 1) {
//       fillPath.lineTo(padding + chartWidth / 2, padding + chartHeight);
//     } else {
//       fillPath.lineTo(padding + chartWidth, padding + chartHeight);
//     }
//     fillPath.close();

//     // Draw fill first, then line
//     canvas.drawPath(fillPath, fillPaint);
//     canvas.drawPath(linePath, paint);

//     // Draw chart title
//     final titleTextPainter = TextPainter(
//       text: TextSpan(
//         text: _getChartTitle(),
//         style: TextStyle(
//           color: Colors.grey[800],
//           fontSize: 14,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//     );
//     titleTextPainter.layout();
//     titleTextPainter.paint(
//       canvas,
//       Offset(
//         (size.width - titleTextPainter.width) / 2,
//         10,
//       ),
//     );
//   }

//   String _getLabel(ChartData chartData, int index) {
//     // Priority: label > date > time > index
//     if (chartData.label != null && chartData.label!.isNotEmpty) {
//       return chartData.label!;
//     }
    
//     if (chartData.date != null && chartData.date!.isNotEmpty) {
//       // Try to format date if it's in a standard format
//       try {
//         final date = DateTime.parse(chartData.date!);
//         switch (currentFilter) {
//           case 'today':
//           case 'yesterday':
//             return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
//           case 'thisWeek':
//             return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
//           case 'thisMonth':
//             return '${date.day}';
//           default:
//             return '${date.day}/${date.month}';
//         }
//       } catch (e) {
//         // If date parsing fails, return as is
//         return chartData.date!.length > 6 
//             ? chartData.date!.substring(0, 6) 
//             : chartData.date!;
//       }
//     }
    
//     if (chartData.time != null && chartData.time!.isNotEmpty) {
//       return chartData.time!;
//     }
    
//     return 'Day ${index + 1}';
//   }

//   String _getChartTitle() {
//     switch (currentFilter) {
//       case 'today':
//         return 'Today\'s Earnings';
//       case 'yesterday':
//         return 'Yesterday\'s Earnings';
//       case 'thisWeek':
//         return 'This Week\'s Earnings';
//       case 'thisMonth':
//         return 'This Month\'s Earnings';
//       default:
//         return 'Earnings Chart';
//     }
//   }

//   @override
//   bool shouldRepaint(LineChartPainter oldDelegate) {
//     return dataPoints != oldDelegate.dataPoints ||
//         currentFilter != oldDelegate.currentFilter;
//   }
// }

// // Usage Widget
// class ChartScreen extends StatefulWidget {
//   const ChartScreen({super.key});

//   @override
//   State<ChartScreen> createState() => _ChartScreenState();
// }

// class _ChartScreenState extends State<ChartScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch initial data
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ChartProvider>().fetchThisWeekChart();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Earnings Chart'),
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//       ),
//       body: Column(
//         children: [
//           // Summary Cards
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: Consumer<ChartProvider>(
//               builder: (context, chartProvider, child) {
//                 return Row(
//                   children: [
//                     Expanded(
//                       child: _buildSummaryCard(
//                         'Total Earnings',
//                         chartProvider.formattedTotalEarnings,
//                         Icons.trending_up,
//                         Colors.green,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: _buildSummaryCard(
//                         'Wallet Balance',
//                         chartProvider.formattedWalletBalance,
//                         Icons.account_balance_wallet,
//                         Colors.blue,
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),

//           // Filter Buttons
//           Container(
//             height: 50,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Consumer<ChartProvider>(
//               builder: (context, chartProvider, child) {
//                 return Row(
//                   children: [
//                     _buildFilterChip('Today', 'today', chartProvider),
//                     const SizedBox(width: 8),
//                     _buildFilterChip('Yesterday', 'yesterday', chartProvider),
//                     const SizedBox(width: 8),
//                     _buildFilterChip('This Week', 'thisWeek', chartProvider),
//                     const SizedBox(width: 8),
//                     _buildFilterChip('This Month', 'thisMonth', chartProvider),
//                   ],
//                 );
//               },
//             ),
//           ),

//           // Chart
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 10,
//                     offset: const Offset(0, 1),
//                   ),
//                 ],
//               ),
//               child: const CustomLineChart(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: color, size: 20),
//               const SizedBox(width: 8),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(String label, String filter, ChartProvider provider) {
//     final isSelected = provider.currentFilter == filter;
//     return GestureDetector(
//       onTap: () => provider.fetchChartData(filter: filter),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue : Colors.grey[200],
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.grey[600],
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_delivery_app/providers/chart_provider.dart';
import 'package:medical_delivery_app/models/chart_model.dart';

class CustomLineChart extends StatelessWidget {
  const CustomLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartProvider>(
      builder: (context, chartProvider, child) {
        if (chartProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (chartProvider.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load chart data',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  chartProvider.error,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => chartProvider.refreshData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!chartProvider.hasChartData) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.show_chart,
                  color: Colors.grey,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  'No chart data available',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return CustomPaint(
          size: const Size(double.infinity, double.infinity),
          painter: LineChartPainter(
            dataPoints: chartProvider.chartDataPoints,
            currentFilter: chartProvider.currentFilter,
          ),
        );
      },
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<ChartData> dataPoints;
  final String currentFilter;

  LineChartPainter({
    required this.dataPoints,
    required this.currentFilter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue.withOpacity(0.3), Colors.blue.withOpacity(0.05)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    final textStyle = TextStyle(color: Colors.grey[600], fontSize: 10);

    // Calculate positions
    final padding = 50.0;
    final chartWidth = size.width - padding * 2;
    final chartHeight = size.height - padding * 2;
    
    // Extract values using the chartValue getter
    final values = dataPoints.map((e) => e.chartValue).toList();
    print('Chart values: $values'); // Debug print
    
    final maxValue = values.isNotEmpty 
        ? (values.reduce((a, b) => a > b ? a : b) * 1.2) // Add 20% padding
        : 100.0;
    final minValue = values.isNotEmpty 
        ? (values.reduce((a, b) => a < b ? a : b) * 0.8) // Reduce by 20% for padding
        : 0.0;
    
    final valueRange = maxValue - minValue;
    final stepX = dataPoints.length > 1 ? chartWidth / (dataPoints.length - 1) : 0;

    print('Max: $maxValue, Min: $minValue, Range: $valueRange'); // Debug print

    // Draw horizontal grid lines and y-axis labels
    for (int i = 0; i <= 4; i++) {
      final y = padding + chartHeight - (i * chartHeight / 4);
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        gridPaint,
      );

      // Y-axis labels
      final value = minValue + (i * valueRange / 4);
      final textPainter = TextPainter(
        text: TextSpan(
          text: '₹${value.toStringAsFixed(0)}',
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(padding - 35, y - textPainter.height / 2),
      );
    }

    // Create path for line and fill
    final linePath = Path();
    final fillPath = Path();

    // Start fill path from bottom
    fillPath.moveTo(padding, padding + chartHeight);

    for (int i = 0; i < dataPoints.length; i++) {
      final x = dataPoints.length == 1 
          ? padding + chartWidth / 2 
          : padding + (i * stepX);
      
      final normalizedValue = valueRange > 0 
          ? ((values[i] - minValue) / valueRange)
          : 0.0;
      final y = padding + chartHeight - (normalizedValue * chartHeight);

      print('Point $i: value=${values[i]}, normalized=$normalizedValue, x=$x, y=$y'); // Debug print

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw dots with hover effect
      canvas.drawCircle(Offset(x, y), 6, Paint()..color = Colors.blue);
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = Colors.white);

      // Draw value labels above dots
      final valueText = '₹${values[i].toStringAsFixed(0)}';
      final valueTextPainter = TextPainter(
        text: TextSpan(
          text: valueText,
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      valueTextPainter.layout();
      valueTextPainter.paint(
        canvas,
        Offset(x - valueTextPainter.width / 2, y - 25),
      );

      // Draw x-axis labels
      String label = _getLabel(dataPoints[i], i);
      final textPainter = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 25),
      );
    }

    // Close fill path
    if (dataPoints.length == 1) {
      fillPath.lineTo(padding + chartWidth / 2, padding + chartHeight);
    } else {
      fillPath.lineTo(padding + chartWidth, padding + chartHeight);
    }
    fillPath.close();

    // Draw fill first, then line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, paint);

    // Draw chart title
    final titleTextPainter = TextPainter(
      text: TextSpan(
        text: _getChartTitle(),
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    titleTextPainter.layout();
    titleTextPainter.paint(
      canvas,
      Offset(
        (size.width - titleTextPainter.width) / 2,
        10,
      ),
    );
  }

  String _getLabel(ChartData chartData, int index) {
    // Priority: label > day > date > time > index
    if (chartData.label != null && chartData.label!.isNotEmpty) {
      return chartData.label!;
    }
    
    if (chartData.day != null && chartData.day!.isNotEmpty) {
      return chartData.day!.length > 8 
          ? chartData.day!.substring(0, 8) 
          : chartData.day!;
    }
    
    if (chartData.date != null && chartData.date!.isNotEmpty) {
      // Try to format date if it's in a standard format
      try {
        final date = DateTime.parse(chartData.date!);
        switch (currentFilter) {
          case 'today':
          case 'yesterday':
            return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
          case 'thisWeek':
            return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7];
          case 'thisMonth':
            return '${date.day}';
          default:
            return '${date.day}/${date.month}';
        }
      } catch (e) {
        // If date parsing fails, return as is
        return chartData.date!.length > 6 
            ? chartData.date!.substring(0, 6) 
            : chartData.date!;
      }
    }
    
    if (chartData.time != null && chartData.time!.isNotEmpty) {
      return chartData.time!;
    }
    
    return 'Day ${index + 1}';
  }

  String _getChartTitle() {
    switch (currentFilter) {
      case 'today':
        return 'Today\'s Earnings';
      case 'yesterday':
        return 'Yesterday\'s Earnings';
      case 'thisWeek':
        return 'This Week\'s Earnings';
      case 'thisMonth':
        return 'This Month\'s Earnings';
      default:
        return 'Earnings Chart';
    }
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return dataPoints != oldDelegate.dataPoints ||
        currentFilter != oldDelegate.currentFilter;
  }
}