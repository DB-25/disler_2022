import 'dart:async';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:disler_new/components/horizontal_category.dart';
import 'package:disler_new/components/icon_btn.dart';
import 'package:disler_new/components/password_field.dart';
import 'package:disler_new/components/search_field.dart';
import 'package:disler_new/model/banner_model.dart';
import 'package:disler_new/model/brand_model.dart';
import 'package:disler_new/model/category_model.dart';
import 'package:disler_new/model/product_model.dart';
import 'package:disler_new/networking/ApiResponse.dart';
import 'package:disler_new/networking/api_driver.dart';
import 'package:disler_new/screens/address_page.dart';
import 'package:disler_new/screens/login_screen.dart';
import 'package:disler_new/screens/order_history.dart';
import 'package:disler_new/screens/vertical_view_page_2.dart';
import 'package:disler_new/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'inventory_page.dart';
import 'search_result.dart';

final ValueNotifier<bool> autoLoginBool = ValueNotifier<bool>(false);

final ValueNotifier<bool> admin = ValueNotifier<bool>(false);

class HomePage2 extends StatefulWidget {
  final BannerModel bannerModel;
  final List<CategoryModel> categoryModel;
  final List<ProductModel> popularProductModel;
  final List<ProductModel> bestDealModel;
  final List<BrandModel> brandModel;
  final List<BrandModel> distributorModel;

  HomePage2(
      {this.bannerModel,
      this.popularProductModel,
      this.bestDealModel,
      this.categoryModel,
      this.brandModel,
      this.distributorModel});

  @override
  _HomePage2State createState() => _HomePage2State(
      bannerModel: bannerModel,
      popular: popularProductModel,
      bestDeals: bestDealModel,
      categoryModel: categoryModel,
      brand: brandModel,
      distributor: distributorModel);
}

class _HomePage2State extends State<HomePage2>
    with SingleTickerProviderStateMixin {
  ApiDriver apiDriver = new ApiDriver();
  BannerModel bannerModel;
  List<CategoryModel> categoryModel;
  List<ProductModel> bestDeals;
  List<ProductModel> popular;
  List<BrandModel> brand;
  List<BrandModel> distributor;

  _HomePage2State(
      {this.bannerModel,
      this.popular,
      this.bestDeals,
      this.categoryModel,
      this.brand,
      this.distributor});

  _handleSignOut() {
    _googleSignIn.disconnect();
  }

  autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    admin.value = prefs.containsKey('admin') ? true : false;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    admin.notifyListeners();
    if (prefs.containsKey('autoLogin')) {
      _googleSignIn.signInSilently();
      autoLoginBool.value = prefs.getBool('autoLogin');
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      autoLoginBool.notifyListeners();
    }
    setState(() {});
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void initState() {
    autoLogin();

    //
    // for (int i = 0; i < productModelLength; i++) {
    //   if (i < (productModelLength / 2))
    //     bestDeals.add(productModel[i]);
    //   else
    //     popular.add(productModel[i]);

    _controller = TabController(length: 2, initialIndex: 0, vsync: this);
    _controller.addListener(_handleTabSelection);

    refresh();
    super.initState();
  }

  void refresh() {
    Future.delayed(new Duration(seconds: 1), () {
      setState(() {});
    });
    Future.delayed(new Duration(seconds: 2), () {
      setState(() {});
    });
    Future.delayed(new Duration(seconds: 3), () {
      setState(() {
        loading = false;
      });
    });
    Future.delayed(new Duration(seconds: 5), () {
      setState(() {});
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  File _image;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  bool loading = true;
  TabController _controller;

  var formData = {
    'confirmPassword': '',
    'password': '',
  };

  Color getColor(int num) {
    num = num % 5;
    if (num == 0) return Color(0xff066E4B);
    if (num == 1) return Colors.blueAccent;
    if (num == 2) return Colors.brown;
    if (num == 3) return Colors.redAccent;
    if (num == 4) return Color(0xffFEBE50);
    return Color(0xff183B8C);
  }

  Widget displayBrand(
      List<BrandModel> data, double itemWidth, double itemHeight) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.count(
        // primary: true,
        physics: new NeverScrollableScrollPhysics(),
        childAspectRatio: (itemWidth.round() / itemHeight.round()),
        crossAxisCount: 2,

        shrinkWrap: true,
        children: List.generate(
          data.length,
          (index) => GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerticalViewPage2(
                    subCategory: null,
                    title: data[index].name,
                    url: _controller.index == 0
                        ? data[index].fmcgBrandId
                        : data[index].fmcgDistributorId,
                    extendedUrl: _controller.index == 0
                        ? 'product-by-fmcg-brand'
                        : 'product-by-fmcg-distributor',
                    bestDeals: null,
                    brandData: true,
                  ),
                ),
              );
            },
            child: loading
                ? Stack(children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: itemWidth,
                        height: itemHeight,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey),
                      ),
                    ),
                    Container(
                      width: itemWidth - 10,
                      height: itemHeight - 8,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Text(
                            "Loading..",
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ])
                : Stack(children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: itemWidth,
                        height: itemHeight,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: getColor(index)),
                      ),
                    ),
                    Container(
                      width: itemWidth - 10,
                      height: itemHeight - 8,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Text(
                            data[index].name,
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ]),
          ),
        ),
      ),
    );
  }

  Widget displayEmpty(int quantity, double itemWidth, double itemHeight) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.count(
        // primary: true,
        physics: new NeverScrollableScrollPhysics(),
        childAspectRatio: (itemWidth.round() / itemHeight.round()),
        crossAxisCount: 2,
        shrinkWrap: true,
        children: List.generate(
            quantity,
            (index) => Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: itemWidth,
                      height: itemHeight,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[200]),
                    ),
                  ),
                  Container(
                    width: itemWidth - 10,
                    height: itemHeight - 8,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          "Loading..",
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                ])),
      ),
    );
  }

  Future<void> _showMyDialog({String title, String body}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog2({String title, String body}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: PasswordField(
                      hintText: "New Password",
                      icon: Icons.lock,
                      validator:
                          passwordValidator("Password must not be empty"),
                      onSaved: (val) => formData['password'] = val,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: PasswordField(
                      hintText: "Confirm Password",
                      icon: Icons.lock,
                      validator:
                          passwordValidator("Password must not be empty"),
                      onSaved: (val) => formData['confirmPassword'] = val,
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('UPDATE'),
              onPressed: () async {
                _formKey.currentState.save();
                if (!_formKey.currentState.validate()) return;
                if (formData['password'] != formData['confirmPassword']) {
                  _showMyDialog(
                    title: 'Check Password',
                    body: 'Please check your password.',
                  );
                  return;
                }
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String email = prefs.getString('email');
                ApiResponse updatePassword =
                    await apiDriver.updatePassword(email, formData['password']);
                Navigator.of(context).pop();
                print(updatePassword.message);
                if (updatePassword != null)
                  _showMyDialog(
                      title: updatePassword.message,
                      body: updatePassword.message);
              },
            ),
            TextButton(
              child: Text('CANCEL'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 10;
    final double itemWidth = size.width / 2;
    //int productModelLength = productModel.length;
    // productModel.sublist(0, (productModelLength / 2).floor());
    // popular = productModel.sublist((productModelLength / 2).floor());
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            Container(
              width: SizeConfig.screenWidth * 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 0,
                    child: Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.segment,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchResult()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5, top: 10),
                        child: SearchField(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      margin: EdgeInsets.only(left: 10, top: 10, right: 0),
                      child: IconBtn(
                        icon: Icon(Icons.add_a_photo, color: Colors.black45),
                        press: () {
                          getImage();
                          if (_image != null)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddressPage(
                                          products: null,
                                        )));
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      margin: EdgeInsets.only(left: 5, top: 10, right: 5),
                      child: IconBtn(
                        icon: Icon(Icons.notifications_active,
                            color: Colors.black45),
                        press: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /*IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchResult()));
              }),*/

            /*IconButton(
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.black,
              ),
              onPressed: () {
                getImage();
                if (_image != null)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressPage(
                                products: null,
                              )));
              }),*/
          ],
          elevation: 0,
          leading: Container(),
          /*leading: IconButton(
            icon: Icon(
              Icons.segment,
              color: Colors.black54,
            ),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),*/
          /* title: Text(
            'Qirana',
            style: TextStyle(color: Colors.black54),
          ),*/
          backgroundColor: Colors.white,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.only(top: 32),
            children: <Widget>[
              Container(
                  color: Colors.white,
                  child: Image.asset(
                    'assets/banner.jpg',
                    fit: BoxFit.fill,
                  )),
              /*Text(
                      'Qirana',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),*/

              ValueListenableBuilder<bool>(
                  valueListenable: autoLoginBool,
                  builder: (BuildContext context, bool value, Widget child) {
                    return (value)
                        ? Container()
                        : ListTile(
                            title: Text(
                              "Log In",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black54,
                                fontSize: 18,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                          );
                  }),
              ValueListenableBuilder<bool>(
                  valueListenable: admin,
                  builder: (BuildContext context, bool value, Widget child) {
                    return (value)
                        ? ListTile(
                            title: Text(
                              'Check Inventory',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Inventory()));
                            },
                          )
                        : Container();
                  }),
              // ListTile(
              //   title: Text(
              //     'Shop by Category',
              //     style: TextStyle(
              //         fontSize: 18,
              //         color: Colors.black54,
              //         fontWeight: FontWeight.w700),
              //   ),
              //   onTap: () {},
              // ),
              ListTile(
                title: Text(
                  'Orders',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ManualOrder()));
                },
              ),
              ListTile(
                title: Text(
                  'Update Password',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700),
                ),
                onTap: () {
                  _showMyDialog2(title: 'Update Password', body: '');
                },
              ),
              ValueListenableBuilder<bool>(
                  valueListenable: autoLoginBool,
                  builder: (BuildContext context, bool value, Widget child) {
                    return (value)
                        ? ListTile(
                            title: Text(
                              'Log Out',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFff5860),
                                  fontWeight: FontWeight.w700),
                            ),
                            onTap: () async {
                              setState(() {
                                _handleSignOut();
                              });
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              autoLoginBool.value = false;
                              // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                              autoLoginBool.notifyListeners();
                              String emailIdFromLocal =
                                  prefs.containsKey('emailId')
                                      ? prefs.getString('emailId')
                                      : "";
                              String passwordFromLocal =
                                  prefs.containsKey('password')
                                      ? prefs.getString('password')
                                      : "";

                              await prefs.clear();
                              await prefs.setString('email', emailIdFromLocal);
                              await prefs.setString(
                                  'emailId', emailIdFromLocal);

                              await prefs.setString(
                                  'password', passwordFromLocal);
                              admin.value = false;
                              // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                              admin.notifyListeners();
                              //
                              // await SQLiteDbProvider.db.dropDB();
                              setState(() {});
                              SystemChannels.platform
                                  .invokeMethod('SystemNavigator.pop');
                            },
                          )
                        : Container();
                  }),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: SizedBox(
                      height: 5,
                    ),
                  ),
                  categoryModel == null
                      ? Flexible(
                          child: Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : Flexible(
                          child: HorizontalCategory(
                            showTitle: false,
                            categoryModel: categoryModel,
                            duration: 2,
                          ),
                        ),
                  Flexible(
                    child: SizedBox(
                      height: 5,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: SizedBox(
                          height: 180.0,
                          width: MediaQuery.of(context).size.width,
                          child: loading
                              ? Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : (bannerModel != null)
                                  ? Carousel(
                                      images: [
                                        NetworkImage(ApiDriver().getBaseUrl() +
                                            '/wp' +
                                            bannerModel.bannerOne),
                                        NetworkImage(ApiDriver().getBaseUrl() +
                                            '/wp' +
                                            bannerModel.bannerTwo),
                                        NetworkImage(ApiDriver().getBaseUrl() +
                                            '/wp' +
                                            bannerModel.bannerThree)
                                      ],
                                      boxFit: BoxFit.fill,
                                      showIndicator: true,
                                      dotIncreaseSize: 1.3,
                                      dotBgColor: Colors.black.withOpacity(0),
                                      dotColor: Colors.white70,
                                      borderRadius: false,
                                      moveIndicatorFromBottom: 180.0,
                                      noRadiusForIndicator: true,
                                      overlayShadow: false,
                                      overlayShadowColors: Colors.white,
                                      overlayShadowSize: 0.7,
                                    )
                                  : Carousel(
                                      images: [
                                        AssetImage('assets/no_image.png'),
                                        AssetImage('assets/no_image.png'),
                                        AssetImage('assets/no_image.png'),
                                      ],
                                      boxFit: BoxFit.fill,
                                      showIndicator: true,
                                      dotIncreaseSize: 1.3,
                                      dotBgColor: Colors.black.withOpacity(0),
                                      dotColor: Colors.white70,
                                      borderRadius: false,
                                      moveIndicatorFromBottom: 180.0,
                                      noRadiusForIndicator: true,
                                      overlayShadow: false,
                                      overlayShadowColors: Colors.white,
                                      overlayShadowSize: 0.7,
                                    ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TabBar(
                        labelStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                        labelColor: Colors.black,
                        indicatorColor: Color(0xFFff5860),
                        controller: _controller,
                        unselectedLabelColor: Colors.black54,
                        tabs: [
                          Tab(
                            text: 'Brand',
                          ),
                          Tab(
                            text: 'Distributor',
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      height: MediaQuery.of(context).size.height + 150,
                      child: TabBarView(
                        controller: _controller,
                        children: [
                          Container(
                            child: brand != null
                                ? loading
                                    ? displayEmpty(6, itemWidth, itemHeight)
                                    : displayBrand(brand, itemWidth, itemHeight)
                                : Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'No Data Found',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                          ),
                          Container(
                            child: distributor != null
                                ? loading
                                    ? displayEmpty(6, itemWidth, itemHeight)
                                    : displayBrand(
                                        distributor, itemWidth, itemHeight)
                                : Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'No Data Found',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
