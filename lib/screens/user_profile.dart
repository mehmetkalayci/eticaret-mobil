import 'package:ecommerce_mobile/screens/user_profile_edit.dart';
import 'package:ecommerce_mobile/screens/user_promotions.dart';
import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      slivers: <Widget>[
        MyAppBar("Hesabım", Icon(Icons.person_rounded), context),
        SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(
                        width: 3, color: Color.fromARGB(255, 202, 202, 202)),
                  ),
                  child: Image.asset(
                    "assets/images/pp.jpg",
                    height: 100,
                  ),
                ),
              ),
              Text(
                "Mehmet Kalaycı",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              Text(
                "Firma Adı",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "534-609-80-67",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 5),
              MaterialButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Çıkış Yap"),
                    SizedBox(width: 10),
                    Icon(Icons.exit_to_app)
                  ],
                ),
              ),
              SizedBox(height: 30),
              /****************************************************/
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: UserProfileEditPage(),
                        ),
                      );
                    },
                    height: 60,
                    color: Colors.grey.shade200,
                    focusElevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.verified_user_rounded),
                        SizedBox(width: 10),
                        Text(
                          "Bilgileri Düzenle",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_rounded)
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: UserPromotionPage(),
                        ),
                      );
                    },
                    height: 60,
                    color: Colors.grey.shade200,
                    focusElevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.discount_rounded),
                        SizedBox(width: 10),
                        Text(
                          "Bana Özel",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_rounded)
                      ],
                    )),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              //   child: MaterialButton(
              //     onPressed: () {},
              //     height: 60,
              //     color: Colors.red.shade600,
              //     textColor: Colors.white,
              //     focusElevation: 0,
              //     highlightElevation: 0,
              //     hoverElevation: 0,
              //     elevation: 0,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Row(
              //       children: [
              //         Icon(Icons.logout_rounded),
              //         SizedBox(width: 10),
              //         Text(
              //           "Çıkış Yap",
              //           style: TextStyle(
              //               fontSize: 18, fontWeight: FontWeight.w400),
              //         ),
              //         Spacer(),
              //         Icon(Icons.arrow_forward_rounded)
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
