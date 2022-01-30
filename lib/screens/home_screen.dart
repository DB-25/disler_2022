import 'dart:async';

import 'package:disler_new/model/banner_model.dart';
import 'package:disler_new/model/brand_model.dart';
import 'package:disler_new/model/category_model.dart';
import 'package:disler_new/model/product_model.dart';
import 'package:disler_new/networking/ApiResponse.dart';
import 'package:disler_new/networking/api_driver.dart';
import 'package:disler_new/routes.dart';
import 'package:disler_new/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cart_page.dart';
import 'favorite_page.dart';
import 'home_page_2.dart';
import 'profile_page.dart';
import 'search_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  List<int> navigationStack = [];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (navigationStack.isEmpty) navigationStack.add(0);
      if (navigationStack.last != index) navigationStack.add(index);
      if (_selectedIndex == 0)
        _navigatorKey.currentState.pushNamed('/');
      else if (_selectedIndex == 1)
        _navigatorKey.currentState.pushNamed(searchRoute);
      else if (_selectedIndex == 2)
        _navigatorKey.currentState.pushNamed(cartRoute);
      else if (_selectedIndex == 3)
        _navigatorKey.currentState.pushNamed(favRoute);
      else if (_selectedIndex == 4)
        _navigatorKey.currentState.pushNamed(profileRoute);
    });
  }

  Future<bool> _exitApp() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("NO"),
                ),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("YES"),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    getDataForAll();
    super.initState();
  }

  ApiDriver apiDriver = new ApiDriver();
  BannerModel bannerModel;
  List<CategoryModel> categoryModel = [];
  List<ProductModel> popularProductModel = [];
  List<ProductModel> bestDealModel = [];
  List<BrandModel> brandDetails = [];
  List<BrandModel> distributorDetails = [];

  void getDataForAll() async {
    ApiResponse responseBanner = await apiDriver.getData('banner-all');
    if (responseBanner != null && responseBanner.data.length > 0)
      getBannerDetails(responseBanner.data[0]);
    ApiResponse responseCategory = await apiDriver.getData('category-all');
    // ApiResponse responsePopularDeals = await apiDriver.getData('product-slider');
    // ApiResponse responseBestDeals = await apiDriver.getData('best-deal');
    if (responseCategory != null) getCategoryDetails(responseCategory.data);
    // if (responsePopularDeals != null) getPopularDealsDetails(responsePopularDeals.data);
    // if (responseBestDeals != null) getBestDealsDetails(responseBestDeals.data);
    ApiResponse responseBrand = await apiDriver.getData('fmcg-brand-all');
    ApiResponse responseDistributor =
        await apiDriver.getData('fmcg-distributor-all');
    if (responseDistributor != null)
      getDistributorDetails(responseDistributor.data);
    if (responseBrand != null) getBrandDetails(responseBrand.data);
  }

  void getBrandDetails(List data) {
    for (var i = 0; i < data.length; i++) {
      brandDetails.add(BrandModel.fromMap(data[i]));
    }
    print(brandDetails[1].name);
  }

  void getDistributorDetails(List data) {
    for (var i = 0; i < data.length; i++) {
      distributorDetails.add(BrandModel.fromMap(data[i]));
    }
  }

  void getPopularDealsDetails(List data) {
    for (var i = 0; i < data.length; i++) {
      popularProductModel.add(ProductModel.fromMap(data[i]));
    }
  }

  void getBestDealsDetails(List data) {
    for (var i = 0; i < data.length; i++) {
      bestDealModel.add(ProductModel.fromMap(data[i]));
    }
  }

  void getCategoryDetails(List data) {
    for (var i = 0; i < data.length; i++) {
      categoryModel.add(CategoryModel.fromMap(data[i]));
    }
  }

  void getBannerDetails(Map<String, dynamic> map) {
    bannerModel = BannerModel.fromMap(map);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: () async {
          if (navigationStack.isNotEmpty) {
            _navigatorKey.currentState.pop();
            navigationStack.removeLast();
            setState(() {
              _onItemTapped(navigationStack.last);
            });
            return false;
          } else if (navigationStack.isEmpty) {
            _exitApp();
          }
          return true;
        },
        child: Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            // Manage your route names here
            switch (settings.name) {
              case '/':
                builder = (BuildContext context) => HomePage2(
                      popularProductModel: popularProductModel,
                      bestDealModel: popularProductModel,
                      bannerModel: bannerModel,
                      categoryModel: categoryModel,
                      brandModel: brandDetails,
                      distributorModel: distributorDetails,
                    );
                break;
              case searchRoute:
                builder = (BuildContext context) => Search(
                      productModel: popularProductModel,
                    );
                break;
              case cartRoute:
                builder = (BuildContext context) => Cart();
                break;
              case favRoute:
                builder = (BuildContext context) => Fav();
                break;
              case profileRoute:
                builder = (BuildContext context) => Profile();
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }
            // You can also return a PageRouteBuilder and
            // define custom transitions between pages
            return MaterialPageRoute(
              builder: builder,
              settings: settings,
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 200,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange[500],
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
        iconSize: 30,
      ),
    );
  }
}
