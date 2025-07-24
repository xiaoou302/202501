import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({Key? key, required this.currentIndex, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to make height responsive to different devices
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      // Adjust height based on bottom padding (for devices with notches)
      height: 70 + bottomPadding,
      decoration: BoxDecoration(
        color: Color(0xFF0A0F1F).withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Padding(
        // Add bottom padding for devices with notches
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, FontAwesomeIcons.book, 'Journal'),
            _buildNavItem(1, FontAwesomeIcons.qrcode, 'Share'),
            _buildNavItem(2, FontAwesomeIcons.wind, 'Breathe'),
            _buildNavItem(3, FontAwesomeIcons.cog, 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            transform: isActive
                ? Matrix4.translationValues(0, -3, 0)
                : Matrix4.translationValues(0, 0, 0),
            child: Icon(
              icon,
              color: isActive ? Color(0xFFD97C29) : Color(0xFFA0AEC0),
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Color(0xFFD97C29) : Color(0xFFA0AEC0),
              fontSize: 12,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Color(0xFFD97C29),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFD97C29).withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
 