import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AccountSettingsPage extends StatelessWidget {
  // Centralized colors for reusability
  final Color primaryColor = Color(0xFF1E88E5);
  final Color accentColor = Color(0xFF1565C0);
  final Color backgroundColor = Color(0xFFF5F5F5);
  final Color cardColor = Colors.white;
  final Color textPrimary = Color(0xFF212121);
  final Color logoutColor = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isLargeScreen = screenWidth > 600;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('Account Settings'),
          backgroundColor: primaryColor,
          elevation: 2,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 500 : double.infinity),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle('Your Calendar'),
                  calendarCard(),
                  SizedBox(height: 30),
                  sectionTitle('Profile Settings'),
                  SizedBox(height: 10),
                  actionButton(
                    icon: Icons.person,
                    label: 'View / Edit Profile',
                    color: primaryColor,
                    onPressed: () {},
                  ),
                  SizedBox(height: 20),
                  sectionTitle('Privacy Settings'),
                  SizedBox(height: 10),
                  actionButton(
                    icon: Icons.lock,
                    label: 'Change Password',
                    color: accentColor,
                    onPressed: () {},
                  ),
                  SizedBox(height: 10),
                  actionButton(
                    icon: Icons.photo_camera,
                    label: 'Edit Profile Picture',
                    color: accentColor,
                    onPressed: () {},
                  ),
                  SizedBox(height: 20),
                  sectionTitle('Logout'),
                  SizedBox(height: 10),
                  actionButton(
                    icon: Icons.logout,
                    label: 'Logout',
                    color: logoutColor,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Common Section Title Widget
  Widget sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
    );
  }

  // Calendar Card Widget
  Widget calendarCard() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: accentColor,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: Colors.white),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
      ),
    );
  }

  // Common Action Button Widget
  Widget actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(50),
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        elevation: 2,
      ),
      icon: Icon(icon, size: 24),
      label: Text(label, style: TextStyle(fontSize: 16)),
      onPressed: onPressed,
    );
  }
}
