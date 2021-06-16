import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedCornerButtonSolid extends StatelessWidget {
  Function onTap;
  String title;

  RoundedCornerButtonSolid(this.onTap, this.title);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(title, style: GoogleFonts.alata(fontWeight: FontWeight.bold)),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith((states) => 0),
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).accentColor),
      ),
    );
  }
}

class RoundedCornerButtonOutlined extends StatelessWidget {
  Function onTap;
  String title;

  RoundedCornerButtonOutlined(this.onTap, this.title);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          title,
          style: GoogleFonts.alata(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith((states) => 0),
        shape: MaterialStateProperty.resolveWith(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(
              width: 2,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        overlayColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade300),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => Colors.transparent,
        ),
      ),
    );
  }
}

class FlatButtonWithIcon extends StatelessWidget {
  Function onTap;
  String title;
  IconData iconData;

  FlatButtonWithIcon(this.onTap, this.title, this.iconData);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(iconData),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title,
          style: GoogleFonts.alata(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith((states) => 0),
        shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
        overlayColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade300),
        backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
      ),
    );
  }
}
