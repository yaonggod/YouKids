import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:youkids/src/models/course_models/course_detail_model.dart';
import 'package:youkids/src/providers/course_providers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  NaverMapController? _controller;
  String? selectedMarkerId;
  late ScrollController scrollController;
  List<Course_detail_model> courses = [];
  List? bookmarks;
  List<NMarker> coursePlaces = [];
  bool isMaxHeightReached = false;
  double latitude = 37.5;
  double longitude = 127.0;
  double zoomLevel = 15.0;
  bool isLoading = true;
  bool isLoadingCurCoords = true;
  bool isCourseList = true;
  CourseProviders courseProviders = CourseProviders();

  void toggleButtonText() {
    setState(() {
      isCourseList = !isCourseList;
    });
  }

  Future initCourses() async {
    String api = dotenv.get("api_key");
    String userId = "";
    Uri uri = Uri.parse(api + userId);
    courses = await courseProviders.getCourse(uri);
  }

  Future initBookmark() async {
    String api = dotenv.get("api_key2");
    String userId = "";
    final response = await http.get(Uri.parse(api + userId));

    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      setState(() {
        bookmarks = decodedJson['result']['bookmarks'];
      });
      print(bookmarks);
    }
  }

  Future<void> getCurrentLocation() async {
    // 위치 권한 받음
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((response) {
        setState(() {
          latitude = response.latitude;
          longitude = response.longitude;
          isLoadingCurCoords = false;
        });
      });
      _updateCamera();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _initCurrentLocation() async {
    await getCurrentLocation();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initCourses().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    initBookmark();
    // _initCurrentLocation();
    scrollController = ScrollController();
    scrollController.addListener(() {
      // maxheight에 도달했으면
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        setState(() {
          isMaxHeightReached = true;
        });
      } else {
        setState(() {
          isMaxHeightReached = false;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _updateCamera() async {
    final cameraPosition = await _controller!.getCameraPosition();

    final currentZoom = cameraPosition.zoom;

    _controller!.updateCamera(
      NCameraUpdate.fromCameraPosition(NCameraPosition(
        target: NLatLng(latitude - pow(1 / 1.55, currentZoom), longitude),
        zoom: currentZoom,
      )),
    );
  }

  Future<void> _findMyCoords() async {
    await _initCurrentLocation();
    if (!isLoadingCurCoords) {
      if (_controller != null) {
        _updateCamera();
        final marker = NMarker(
            icon:
                NOverlayImage.fromAssetImage("lib/src/assets/icons/myMark.png"),
            size: NMarker.autoSize,
            id: "curCoord",
            position: NLatLng(latitude, longitude));
        _controller!.addOverlay(marker);
      }
    }
  }

  Future<void> _startNavigation(Course_detail_model course) async {
    if (await NaviApi.instance.isKakaoNaviInstalled()) {
      List<Location> viaList = [];

      // 경유지 추가
      for (var place in course.places) {
        viaList.add(Location(
          name: place.name,
          x: place.longitude.toString(),
          y: place.latitude.toString(),
        ));
      }
      print(viaList.toString());
      // 카카오내비로 경로 안내 연결
      await NaviApi.instance.shareDestination(
        // 마지막 경유지가 목적지
        destination: viaList.last,

        // 첫번째 ~ 마지막-1번째 까지 경유지
        viaList: viaList.sublist(0, viaList.length - 1),

        // wgs84 좌표계 옵션
        option: NaviOption(coordType: CoordType.wgs84),
      );
    } else {
      //카카오내비가 없는 경우

      // 카카오내비 설치 페이지 이동
      launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
    }
  }

  void _onCourseClicked(Course_detail_model course) {
    // Naver map contorller 불러오기
    if (_controller != null) {
      for (int i = 0; i < coursePlaces.length; i++) {
        _controller!.deleteOverlay(
            NOverlayInfo(type: NOverlayType.marker, id: i.toString()));
      }
      // 코스의 중간 지점 계산
      double middleLatitude = 0.0;
      double middleLongitude = 0.0;

      for (var place in course.places) {
        middleLatitude += place.latitude;
        middleLongitude += place.longitude;
      }

      middleLatitude /= course.places.length;
      middleLongitude /= course.places.length;

      // 중간 지점으로 카메라 이동
      _controller!.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: NLatLng(middleLatitude - 0.2, middleLongitude),
            zoom: 8.5,
          ),
        ),
      );

      // 해당 코스 마커 렌더링
      int i = 0;
      for (var place in course.places) {
        final marker = NMarker(
          icon:
              NOverlayImage.fromAssetImage("lib/src/assets/icons/mapMark.png"),
          size: NMarker.autoSize,
          id: i.toString(),
          position: NLatLng(place.latitude, place.longitude),
        );
        i++;

        // 마커 지도 위에 렌더링
        _controller!.addOverlay(marker);
      }
    }
  }

  void _onBookmarkClicked(double x, double y) {
    if (_controller != null) {
      // for (int i = 0; i < coursePlaces.length; i++) {
      //   _controller!.deleteOverlay(
      //       NOverlayInfo(type: NOverlayType.marker, id: i.toString()));
      // }
      _controller!.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: NLatLng(x - 0.2, y),
            zoom: 8.5,
          ),
        ),
      );

      // 해당 코스 마커 렌더링
      int i = 0;
      final marker = NMarker(
        icon: NOverlayImage.fromAssetImage("lib/src/assets/icons/mapMark.png"),
        size: NMarker.autoSize,
        id: i.toString(),
        position: NLatLng(x, y),
      );

      // 마커 지도 위에 렌더링
      _controller!.addOverlay(marker);
    }
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
        ],
      ),
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(
                    37.5110317,
                    127.0602133,
                  ),
                  zoom: 15,
                ),
                locale: Locale.fromSubtags(languageCode: 'Ko')),
            onMapReady: (controller) {
              setState(() {
                _controller = controller; // NaverMapController 초기화
              });
            },
          ),
          //상단 찜, 코스 목록 토글 버튼
          Positioned(
            top: 10,
            left: (MediaQuery.of(context).size.width - 80) / 2,
            height: 25,
            child: ElevatedButton(
              onPressed: () async {
                toggleButtonText();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFFF6766E),
                backgroundColor: Color(0xFFF6766E),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                fixedSize: Size(80, 25),
              ),
              child: Text(
                isCourseList ? '코스 목록' : '찜 목록',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            minChildSize: 0.06,
            maxChildSize: 0.5,
            initialChildSize: 0.06,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 70,
                            ),
                            if (!isCourseList)
                              ...(bookmarks ?? []).map((bookmark) {
                                return GestureDetector(
                                  onTap: () => {
                                    _onBookmarkClicked(
                                        bookmark['latitude'] ?? 36,
                                        bookmark['longitude'] ?? 127)
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                  bookmark?['name'] ?? '',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                subtitle: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 8.0),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        'lib/src/assets/icons/course_white.svg',
                                                        height: 16,
                                                      ),
                                                      SizedBox(width: 5.0),
                                                      Text(bookmark?[
                                                              'address'] ??
                                                          ''),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Divider(
                                            color: Color(0xFF949494),
                                            thickness: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            if (isCourseList)
                              ...courses.asMap().entries.map((entry) {
                                final course = entry.value;
                                return GestureDetector(
                                  onTap: () => _onCourseClicked(course),
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                  course.courseName,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: TextButton(
                                                    onPressed: () async {
                                                      _startNavigation(course);
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Color(
                                                                  0xFFF6766E)),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                        ),
                                                      ),
                                                      padding: MaterialStateProperty
                                                          .all<EdgeInsetsGeometry>(
                                                              EdgeInsets.zero),
                                                    ),
                                                    child: SvgPicture.asset(
                                                      'lib/src/assets/icons/navi.svg',
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '경로 안내',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        ...course.places
                                            .asMap()
                                            .entries
                                            .map((placeEntry) {
                                          final placeIndex = placeEntry.key;
                                          final place = placeEntry.value;
                                          return Column(
                                            children: [
                                              ListTile(
                                                contentPadding: EdgeInsets.only(
                                                    left: 16.0, right: 16.0),
                                                // 왼쪽 패딩 조정
                                                title: Text(place.name),

                                                subtitle: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 8.0),
                                                  // title과 subtitle 사이의 간격을 조절
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        'lib/src/assets/icons/course_white.svg',
                                                        height: 16,
                                                      ),
                                                      SizedBox(width: 5.0),
                                                      // 아이콘과 텍스트 사이 간격 조정
                                                      Text(place.address),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Divider(
                                                  color: Color(0xFF949494),
                                                  thickness: placeIndex ==
                                                          course.places.length -
                                                              1
                                                      ? 1.5
                                                      : 0.5,
                                                  height: placeIndex ==
                                                          course.places.length -
                                                              1
                                                      ? 50.0
                                                      : 0.0,
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                    IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          // boxShadow: [
                          //   BoxShadow(
                          //     blurRadius: 100
                          //   )
                          // ]
                        ),
                        child: Column(
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10, bottom: 5),
                                    height: 8,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              flex: 1,
                            ),
                            Flexible(
                                child: Text(
                                  isCourseList ? '코스 목록' : '찜 목록',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                flex: 1),
                          ],
                        ),
                        height: 65,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 1,
      ),
      floatingActionButton: Container(
        height: 45,
        width: 45,
        // margin: EdgeInsets.symmetric(vertical: 35),
        child: FloatingActionButton(
          onPressed: () async {
            _findMyCoords();
          },
          backgroundColor: const Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: SvgPicture.asset('lib/src/assets/icons/coords.svg'),
        ),
      ),
    );
  }
}
