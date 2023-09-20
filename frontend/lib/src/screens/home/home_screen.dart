import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/home/indoor_recom_list_screen.dart';
import 'package:youkids/src/screens/home/review_recom_list_screen.dart';
import 'package:youkids/src/screens/home/week_recom_list_screen.dart';
import 'package:youkids/src/screens/shop/shop_detail_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:youkids/src/widgets/home_widgets/card_frame_widget.dart';
import 'package:youkids/src/widgets/home_widgets/child_icon_widget.dart';


import '../../providers/auth_model.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email'); // Returns 'john_doe' if it exists, otherwise returns null.
  }

  void someFunction() async {
    await removeData();
    print('Email removed from SharedPreferences');
  }

  removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
  }

  _checkLoginStatus() async {
    String? email = await getEmail();
    print(email);
    setState(() {
      _isLoggedIn = email != null;  // 이메일이 null이 아니면 로그인된 것으로 판단
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
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
          _isLoggedIn == false ? IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> LoginScreen()),
              );
            },
            icon: const Icon(
              Icons.account_circle_rounded,
              size: 28,
            ),
          ) : Container(),
          IconButton(
            icon: Icon(Icons.delete),  // 예시 아이콘. 원하는 아이콘으로 변경하세요.
            onPressed: () async {
              await removeData();
              print('Email removed from SharedPreferences');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '아이 맞춤 형 장소',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const ChildIconWidget(),
              setHomeMenu(
                context,
                '이번 주 추천 장소',
                const WeekRecomListScreen(),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShopDetailScreen(),
                        ),
                      );
                    },
                    child: const CardFrame21Widget(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShopDetailScreen(),
                            ),
                          );
                        },
                        child: const CardFrame11Widget(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShopDetailScreen(),
                            ),
                          );
                        },
                        child: const CardFrame11Widget(),
                      ),
                    ],
                  ),
                ],
              ),
              setHomeMenu(
                context,
                '저번 주 리뷰 많은 장소',
                const ReviewRecomlistScreen(),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShopDetailScreen(),
                        ),
                      );
                    },
                    child: const CardFrame21Widget(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShopDetailScreen(),
                            ),
                          );
                        },
                        child: const CardFrame11Widget(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShopDetailScreen(),
                            ),
                          );
                        },
                        child: const CardFrame11Widget(),
                      ),
                    ],
                  ),
                ],
              ),
              setHomeMenu(
                context,
                '실내 장소',
                const IndoorRecomlistScreen(),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShopDetailScreen(),
                        ),
                      );
                    },
                    child: const CardFrame21Widget(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShopDetailScreen(),
                            ),
                          );
                        },
                        child: const CardFrame11Widget(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShopDetailScreen(),
                            ),
                          );
                        },
                        child: const CardFrame11Widget(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 0,
      ),
    );
  }

  // Home Screen에서 추천 장소 메뉴와 routing해주는 위젯 받는 함수
  Padding setHomeMenu(BuildContext context, String title, Widget routingPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => routingPage,
                ),
              );
            },
            child: const Text(
              '더보기',
              style: TextStyle(
                color: Color(0xffFF7E76),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
