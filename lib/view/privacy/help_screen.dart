// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HelpScreen extends StatelessWidget {
//   const HelpScreen({super.key});

//   // Support number & email
//   final String supportNumber = "tel:+919876543210"; 
//   final String supportEmail = "mailto:support@medicalapp.com?subject=App Support&body=Hello, I need help with...";

//   Future<void> _launchUrl(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       throw Exception("Could not launch $url");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Help & Support",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Colors.blue,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),

//             // FAQ Section
//             const Text(
//               "Frequently Asked Questions",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             _buildFaqItem("How do I track my medical order?",
//                 "You can track your order in the 'My Orders' section with real-time updates."),
//             _buildFaqItem("What should I do if my medicine is delayed?",
//                 "Please contact support immediately if your order is delayed."),
//             _buildFaqItem("Can I return a medicine?",
//                 "Returns are only available for unopened packages within 7 days."),
//             const SizedBox(height: 20),

//             // Contact Support Section
//             const Text(
//               "Need More Help?",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               elevation: 2,
//               child: ListTile(
//                 leading: const Icon(Icons.call, color: Colors.blue),
//                 title: const Text("Call Support"),
//                 subtitle: const Text("Get in touch with our support team"),
//                 onTap: () {
//                   _launchUrl(supportNumber);
//                 },
//               ),
//             ),
//             const SizedBox(height: 10),

//             Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               elevation: 2,
//               child: ListTile(
//                 leading: const Icon(Icons.email, color: Colors.blue),
//                 title: const Text("Email Support"),
//                 subtitle: const Text("Send us your queries via email"),
//                 onTap: () {
//                   _launchUrl(supportEmail);
//                 },
//               ),
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFaqItem(String question, String answer) {
//     return ExpansionTile(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       tilePadding: const EdgeInsets.symmetric(horizontal: 12),
//       title: Text(
//         question,
//         style: const TextStyle(fontWeight: FontWeight.w600),
//       ),
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           child: Text(answer, style: TextStyle(color: Colors.grey.shade700)),
//         )
//       ],
//     );
//   }
// }














import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  // Support number & email
  final String supportNumber = "tel:+918309056333";
  final String supportEmail =
      "mailto:simcurarx@gmail.com?subject=App Support&body=Hello, I need help with...";

  List<dynamic> faqs = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchFaqs();
  }

  Future<void> _fetchFaqs() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('http://31.97.206.144:7021/api/admin/allfaq'),
      );


      print('response status code for allfaqs ${response.statusCode}');
      print('response bodyyyyyyyyyyy for faqs ${response.body}');


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          faqs = data['faqs'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load FAQs';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Help & Support",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchFaqs,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // FAQ Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Frequently Asked Questions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (!isLoading)
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.blue),
                      onPressed: _fetchFaqs,
                      tooltip: 'Refresh FAQs',
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Loading, Error, or FAQ List
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (errorMessage.isNotEmpty)
                Center(
                  child: Column(
                    children: [
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchFaqs,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (faqs.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No FAQs available at the moment.'),
                  ),
                )
              else
                ...faqs.map((faq) => _buildFaqItem(
                      faq['question'] ?? 'No question',
                      faq['answer'] ?? 'No answer',
                    )),

              const SizedBox(height: 20),

              // Contact Support Section
              const Text(
                "Need More Help?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.call, color: Colors.blue),
                  title: const Text("Call Support"),
                  subtitle: const Text("Get in touch with our support team"),
                  onTap: () {
                    _launchUrl(supportNumber);
                  },
                ),
              ),
              const SizedBox(height: 10),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.email, color: Colors.blue),
                  title: const Text("Email Support"),
                  subtitle: const Text("Send us your queries via email"),
                  onTap: () {
                    _launchUrl(supportEmail);
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(answer, style: TextStyle(color: Colors.grey.shade700)),
        )
      ],
    );
  }
}
