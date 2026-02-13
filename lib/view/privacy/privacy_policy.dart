import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy Policy",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: const Color(0xFF175889),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Introduction",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF175889),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "We value your trust and are committed to protecting your personal information. "
              "This privacy policy explains how we collect, use, and safeguard your data when you use our Medical Delivery App.",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              "Information We Collect",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF175889),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "• Personal details such as name, phone number, and address\n"
              "• Medical prescription details (if provided)\n"
              // "• Payment and transaction information\n"
              "• App usage data to improve our services",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              "How We Use Your Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF175889),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "• To deliver medicines and healthcare products\n"
              "• To process payments securely\n"
              "• To communicate updates and order notifications\n"
              "• To comply with medical and legal regulations",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              "Data Protection",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF175889),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "We implement strict security measures to safeguard your personal data. "
              "Your information is encrypted and only accessible to authorized personnel.",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              "Third-Party Services",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF175889),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "We may share limited information with trusted partners for payment processing "
              "and delivery services, but we never sell your personal data.",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            const Text(
              "Your Rights",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF175889),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "You have the right to access, update, or request deletion of your data. "
              "You may also opt out of promotional communications at any time.",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF175889),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "I Understand",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
