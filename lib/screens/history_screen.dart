import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'database_helper.dart';
import 'weed_details.dart';
import 'dart:io';

class HistoryScreen extends StatefulWidget {
  final String userEmail;

  const HistoryScreen({super.key, required this.userEmail});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _weedHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeedHistory();
  }

  Future<void> _loadWeedHistory() async {
    try {
      final history = await DatabaseHelper.instance.getUserWeeds(widget.userEmail);
      setState(() {
        _weedHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading history: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load history')),
      );
    }
  }

  Future<void> _deleteWeed(int weedId) async {
    try {
      await DatabaseHelper.instance.deleteUserWeed(weedId, widget.userEmail);
      await _loadWeedHistory(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Weed record deleted')),
      );
    } catch (e) {
      print('Error deleting weed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete record')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detection History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF5D6253),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _weedHistory.isEmpty
              ? const Center(
                  child: Text(
                    'No detection history found',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _weedHistory.length,
                  itemBuilder: (context, index) {
                    final weed = _weedHistory[index];
                    return _buildWeedCard(weed, context);
                  },
                ),
    );
  }

  Widget _buildWeedCard(Map<String, dynamic> weed, BuildContext context) {
    final imagePath = weed['image_path'] as String?; 
    final weedName = weed['name'] as String? ?? 'Unknown Weed';  
    final date = DateTime.tryParse(weed['created_at'] as String? ?? '') ?? DateTime.now();  

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WeedDetailsScreen(
                weedName: weedName,
                height: weed['height'] as String? ?? 'Unknown',
                dangerLevel: weed['danger_level'] as String? ?? 'Unknown',
                treatable: weed['treatable'] as String? ?? 'Unknown',
                treatmentInfo: (weed['treatment_info'] as String?)
                    ?.split('; ') ?? ['No treatment info available'],
                image: imagePath != null ? File(imagePath) : null,
                confidence: 0, // You might want to store confidence in DB
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image preview
              if (imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo, size: 40, color: Colors.grey),
                ),
              const SizedBox(width: 12),
              // Weed info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weedName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Detected: ${_formatDate(date)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Height: ${weed['height'] as String? ?? 'Unknown'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              // Delete button
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteWeed(weed['id'] as int),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Improved date formatting with proper time handling
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    
    return '$day/$month/$year $hour:$minute';
  }
} 