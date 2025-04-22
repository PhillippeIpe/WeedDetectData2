import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'about.dart';
import 'history_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userEmail; // Add user email parameter

  const DashboardScreen({
    super.key,
    required this.userEmail,
  }); // Update constructor

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Make pages a getter to ensure fresh instances with current user email
  List<Widget> get _pages => [
    const HomeScreen(),
    CameraScreen(
      userEmail: widget.userEmail,
    ), // Pass user email to CameraScreen
     HistoryScreen(userEmail: widget.userEmail),
    const AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF26129),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "WEED",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              "DETECTION",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF5D6253),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF5D6253),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: "Camera"),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (unchanged)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF5D6253).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF26129).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.agriculture, color: Color(0xFFF26129)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Weed Detection",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF5D6253),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Top performers section with onTap
            const Text(
              "Common Rice Weeds",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildWeedCard(
                    context,
                    "Sphenoclea Zeylanica",
                    "Chickenspike",
                    Icons.grass,
                    Colors.green,
                    "Common in lowland rice fields, grows up to 1m tall. Competes aggressively with rice plants.",
                  ),
                  const SizedBox(width: 12),
                  _buildWeedCard(
                    context,
                    "Pistia Stratiotes",
                    "Water Lettuce",
                    Icons.water_drop,
                    Colors.teal,
                    "Floating aquatic weed that forms dense mats, blocking sunlight from reaching rice plants.",
                  ),
                  const SizedBox(width: 12),
                  _buildWeedCard(
                    context,
                    "Ludwigia Octovalvis",
                    "Water Primrose",
                    Icons.water,
                    Colors.blue,
                    "Semi-aquatic weed with yellow flowers, competes for nutrients in rice paddies.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // All detectable weeds with onTap
            const Text(
              "Other Rice Weeds",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildGridWeedItem(
                  context,
                  "Cyperus Rotundus",
                  "Purple Nutsedge",
                  Icons.park,
                  "Perennial sedge with purple flower heads, difficult to eradicate once established.",
                ),
                _buildGridWeedItem(
                  context,
                  "Echinochloa Crusgalli",
                  "Barnyardgrass",
                  Icons.grass,
                  "Fast-growing grass weed that resembles rice in early growth stages.",
                ),
                _buildGridWeedItem(
                  context,
                  "Cyperus Iria",
                  "Rice Flat Sedge",
                  Icons.nature,
                  "Common sedge weed in rice fields, competes for nutrients and space.",
                ),
                _buildGridWeedItem(
                  context,
                  "Leptochloa Chinensis",
                  "Chinese Sprangletop",
                  Icons.eco,
                  "Grass weed with distinctive seed heads, reduces rice yields significantly.",
                ),
                _buildGridWeedItem(
                  context,
                  "Fimbristylis Littoralis",
                  "Lesser Fimbry",
                  Icons.forest,
                  "Sedge weed found in wet areas, competes with rice for resources.",
                ),
                _buildGridWeedItem(
                  context,
                  "Echinochloa Glabrescens",
                  "Rough Barnyardgrass",
                  Icons.grass,
                  "Similar to barnyardgrass but with rougher leaves and stems.",
                ),
                _buildGridWeedItem(
                  context,
                  "Cyperus Difformis",
                  "Variable Flatsedge",
                  Icons.grass,
                  "Small sedge weed that grows in dense clumps in rice fields.",
                ),
              ],
            ),

            const SizedBox(height: 24),

            // System Performance (unchanged)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "System Performance",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF5D6253),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildStatItem("10", "Weed Types", Icons.list)),
                      Expanded(child: _buildStatItem("300+", "Tests Run", Icons.analytics)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeedCard(BuildContext context, String name, String commonName, IconData icon, Color color, String description) {
    return GestureDetector(
      onTap: () => _showWeedInfo(context, name, commonName, description),
      child: SizedBox(
        width: 160,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  commonName,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridWeedItem(BuildContext context, String name, String commonName, IconData icon, String description) {
    return GestureDetector(
      onTap: () => _showWeedInfo(context, name, commonName, description),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF5D6253), size: 24),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                commonName,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWeedInfo(BuildContext context, String name, String commonName, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              commonName,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        content: Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(
                color: Color(0xFF5D6253),
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5D6253), size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFF5D6253),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}