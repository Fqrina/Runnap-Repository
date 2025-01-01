  import 'package:flutter/material.dart';
import 'main_section_widget.dart';

class ProfileSectionWidget extends StatelessWidget {
  const ProfileSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "images/profile.png",
          width: 44,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "   User",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text("",
                style: TextStyle(
                  fontSize: 10,
                ))
          ],
        ),
        Expanded(child: SizedBox()),
        InkWell(
          splashColor: Colors.red,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("images/ic.png"),
              ),
            ),
            child: Ink.image(
              image: AssetImage("images/ic.png"),
              width: 44,
              height: 44,
              child: InkWell(
                splashColor: Colors.orangeAccent,
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ),
          ),
          onTap: () {
            Scaffold.of(context).openEndDrawer();
          },
        )
      ],
    );
  }
}
