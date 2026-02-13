import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("About Us",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.white ),),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Image
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.local_hospital,
                size: 70,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            // App Name & Tagline
            // const Text(
            //   "MediDeliver",
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.teal,
            //   ),
            // ),
            const SizedBox(height: 6),
            Text(
              "Fast & Reliable Medicine Delivery",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),

            // About Us Description
            Text(
              "MediDeliver is committed to making healthcare accessible by "
              "delivering medicines and medical supplies to your doorstep. "
              "We ensure fast, reliable, and secure service so you can focus "
              "on what truly matters – your health.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),

            // Key Features
            _buildFeatureCard(
              icon: Icons.local_shipping,
              title: "Fast Delivery",
              description: "Get your medicines delivered at your doorstep quickly and safely.",
            ),
            _buildFeatureCard(
              icon: Icons.verified_user,
              title: "Trusted Service",
              description: "100% genuine medicines from verified pharmacies.",
            ),
            _buildFeatureCard(
              icon: Icons.support_agent,
              title: "24/7 Support",
              description: "We are here to assist you anytime, anywhere.",
            ),
            const SizedBox(height: 30),

            // Contact Info
            Column(
              children: [
                const Text(
                  "Contact Us",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.email, color: Colors.blue, size: 20),
                    SizedBox(width: 6),
                    Text("simcurarx@gmail.com"),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.phone, color: Colors.blue, size: 20),
                    SizedBox(width: 6),
                    Text(" +91-8309056333"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Feature Card Widget
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.teal[50],
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 6),
                Text(description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
