import 'dart:io';
import 'package:flutter/material.dart';

class WeedDetailsScreen extends StatelessWidget {
  final String weedName;
  final String height;
  final String dangerLevel;
  final String treatable;
  final List<String> treatmentInfo;
  final File? image;
  final double confidence;

  const WeedDetailsScreen({
    super.key,
    required this.weedName,
    required this.height,
    required this.dangerLevel,  
    required this.treatable,
    required this.treatmentInfo,
    this.image,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weed Information',
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            fontFamily: 'Poppins', 
            color: Colors.white
          ),
        ),
        backgroundColor: const Color(0xFF5D6253),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  image!, 
                  height: 500,
                  width: double.infinity, 
                  fit: BoxFit.cover
                ),
              ),
            const SizedBox(height: 20),

            // Weed Header with Confidence
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF26129),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    weedName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.analytics, color: Colors.amber, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      '${confidence.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Stats Cards (original design)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard("Height", height),
                _buildInfoCard("Danger", dangerLevel),
                _buildInfoCard("Treatable", treatable),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Treatment Plan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  for (int i = 0; i < treatmentInfo.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5D6253).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    "${i + 1}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5D6253),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _getTreatmentTitle(treatmentInfo[i]),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 52),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildTreatmentSteps(treatmentInfo[i]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < treatmentInfo.length - 1)
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Colors.black12,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTreatmentTitle(String treatment) {
    final parts = treatment.split(':');
    return parts[0].trim();
  }

  List<Widget> _buildTreatmentSteps(String treatment) {
    final steps = treatment.split('\n').skip(1).where((s) => s.trim().isNotEmpty).toList();
    if (steps.isEmpty) {
      return [
        Text(
          treatment.contains(':') ? treatment.split(':')[1].trim() : treatment,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ];
    }
    
    return steps.map((step) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.circle,
            size: 8,
            color: Color(0xFF5D6253),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              step.trim(),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}