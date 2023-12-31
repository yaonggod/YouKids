import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youkids/src/screens/capsule/capsule_list_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';

class CapsuleScreen extends StatelessWidget {
  const CapsuleScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'YouKids',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg',
                height: 24),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: CapsuleListScreen(),
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 3,
      ),
    );
  }
}
