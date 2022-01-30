import 'dart:convert';

import 'package:disler_new/model/order_detail_model.dart';
import 'package:disler_new/model/order_model.dart';
import 'package:disler_new/model/product_model.dart';
import 'package:disler_new/networking/ApiResponse.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'ApiResponse.dart';

class ApiDriver {
  final String environment = "test";
  final String oldCompanyId = 'ff80818171b2ad0501720ab097fd0006';
  // final String companyId = '402880ea77243ec40177244020840000';

  getBaseUrl() {
    return environment == "live"
        ? 'https://www.fagnum.com/api/ecom-store/'
        : "https://www.fagnum.com/api/ecom-store/";
  }

  // getAuthUrl() {
  //   return environment == "live"
  //       ? "https://auth.fagnum.com/ecom-auth"
  //       : 'https://d207-2405-201-6814-4993-5433-b161-4187-3598.ngrok.io/ecom-auth';
  // }

  Future<ApiResponse<dynamic>> getData(String type) async {
    print(type);
    final http.Response response = await http.post(getBaseUrl() + type,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'companyId': oldCompanyId}));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      return null;
    } else {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (!responseMap["status"]) {
        print(responseMap["status"]);
        throw Exception('Failed to load data models');
      } else {
        return ApiResponse.fromMap(responseMap);
      }
    }
  }

  Future<ApiResponse<dynamic>> changeToDelivered(String orderId) async {
    final http.Response response = await http.post(
        getBaseUrl() + '/login', //TODO:change it
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'companyId': oldCompanyId,
          'orderId': orderId,
          'status': 'Delivered'
        }));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      return null;
    } else {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (!responseMap["status"]) {
        print(responseMap["status"]);
        throw Exception('Failed to load data models');
      } else {
        return ApiResponse.fromMap(responseMap);
      }
    }
  }

  Future<ApiResponse<dynamic>> login(String email, String password) async {
    final http.Response response = await http.post(getBaseUrl() + 'login',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'companyId': oldCompanyId,
          'email': email,
          'password': password
        }));
    print(email + "" + password);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      return null;
    } else {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (!responseMap["status"]) {
        print(responseMap["status"]);
        throw Exception('Failed to load data models');
      } else {
        return ApiResponse.fromMap(responseMap);
      }
    }
  }

  Future<ApiResponse<dynamic>> forgotPassword(String email) async {
    final http.Response response = await http.post(
        getBaseUrl() + '/forgot-password',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'companyId': oldCompanyId, 'email': email}));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 404) {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      return ApiResponse.fromMap(responseMap);
    } else if (response.statusCode != 200) {
      return null;
    } else {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (!responseMap["status"]) {
        print(responseMap["status"]);
        throw Exception('Failed to load data models');
      } else {
        return ApiResponse.fromMap(responseMap);
      }
    }
  }

  Future<ApiResponse<dynamic>> updatePassword(
      String email, String password) async {
    final http.Response response = await http.post(
        getBaseUrl() + '/update-password',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'companyId': oldCompanyId,
          'email': email,
          'password': password
        }));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 404) {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      return ApiResponse.fromMap(responseMap);
    } else if (response.statusCode != 200) {
      return null;
    } else {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (!responseMap["status"]) {
        print(responseMap["status"]);
        throw Exception('Failed to load data models');
      } else {
        return ApiResponse.fromMap(responseMap);
      }
    }
  }

  Future<ApiResponse<dynamic>> register(
      String email,
      String password,
      String confirmPassword,
      String name,
      String shopName,
      String sReferral,
      String contactNumber,
      String city,
      String address,
      String area,
      String pincode) async {
    final http.Response response = await http.post(
      getBaseUrl() + 'signup',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          "name": name,
          'companyId': oldCompanyId,
          "shopName": shopName,
          "sReferral": sReferral,
          "contactNumber": contactNumber,
          "city": city,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'address': address,
          'area': area,
          'pincode': pincode,
        },
      ),
    );
    print(jsonEncode(
      <String, String>{
        "name": name,
        'companyId': oldCompanyId,
        "shopName": shopName,
        "sReferral": sReferral,
        "contactNumber": contactNumber,
        "city": city,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'address': address,
        'area': area,
        'pincode': pincode,
      },
    ));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 400) {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      return ApiResponse.fromMap(responseMap);
    }
    if (response.statusCode != 200) {
      return null;
    } else {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (!responseMap["status"]) {
        print(responseMap["status"]);
        throw Exception('Failed to load data models');
      } else {
        return ApiResponse.fromMap(responseMap);
      }
    }
  }

  Future<ApiResponse<dynamic>> getCategoryData(
      {String url,
      String extendedUrl,
      int index,
      bool otherData,
      bool brand}) async {
    print(extendedUrl);
    print(url);
    final http.Response response = await http.post(
      getBaseUrl() + extendedUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: otherData
          ? brand
              ? jsonEncode(
                  <String, String>{
                    'companyId': oldCompanyId,
                    'fmcgBrandId': url,
                    'index': index.toString()
                  },
                )
              : jsonEncode(
                  <String, String>{
                    'companyId': oldCompanyId,
                    'fmcgDistributorId': url,
                    'index': index.toString()
                  },
                )
          : jsonEncode(
              <String, String>{
                'companyId': oldCompanyId,
                'url': url,
                'index': index.toString()
              },
            ),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      return null;
    } else {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (!responseMap["status"]) {
        print(responseMap["status"]);
        throw Exception('Failed to load data models');
      } else {
        return ApiResponse.fromMap(responseMap);
      }
    }
  }

  Future<ApiResponse<dynamic>> getSubCategory(String categoryId) async {
    print('/sub-category-by-category-id');
    final http.Response response = await http.post(
        getBaseUrl() + 'sub-category-by-category-id',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "categoryId": categoryId,
          "companyId": oldCompanyId
        }));
    print(categoryId);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to save data');
    } else {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (!responseMap["status"]) {
        print(responseMap["status"]);
        throw Exception('Failed to load data models');
      } else {
        return ApiResponse.fromMap(responseMap);
      }
    }
  }

  Future<ApiResponse<dynamic>> orderDetails(
      {OrderDetailModel orderDetailModel,
      List<ProductModel> productModel}) async {
    int i;
    List<OrderProduct> order = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String emailId = prefs.getString('emailId');
    for (i = 0; i < productModel.length; i++) {
      order.add(OrderProduct(
          ecomInventoryId: productModel[i].ecomInventoryId,
          quantity: productModel[i].quantity.toString(),
          weight: productModel[i].weight,
          productId: productModel[i].productId));
    }

    String bodyStr = jsonEncode(<String, dynamic>{
      // "name": orderDetailModel.name,
      // "area": orderDetailModel.area,
      // "city": orderDetailModel.city,
      "companyId": oldCompanyId,
      // "contactNumber": orderDetailModel.contactNumber,
      // "contestName": orderDetailModel.contestName,
      // "country": orderDetailModel.country,
      "emailId": emailId,
      // "houseNo": orderDetailModel.houseNo,
      // "paymentOption": orderDetailModel.paymentOption,
      // "paymentOrderId": orderDetailModel.paymentOrderId,
      // "referralCode": orderDetailModel.referralCode,
      // "state": orderDetailModel.state,
      "products": order
    });

    print(jsonEncode(<String, dynamic>{
      "companyId": oldCompanyId,
      "emailId": emailId,
      "products": order
    }));

    final http.Response response =
        await http.post(getBaseUrl() + '/order-submit',
            headers: <String, String>{
              'Content-Typecart': 'application/json; charset=UTF-8',
            },
            body: bodyStr);

    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to save data');
    } else {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (!responseMap["status"]) {
        print(responseMap["status"]);
        return ApiResponse(
            message: "Something went wrong!", status: false, data: []);
      } else {
        return ApiResponse.fromMap(responseMap);
      }
    }
  }

  Future<ApiResponse<dynamic>> getInventory(String value) async {
    final http.Response response = await http.post(
        getBaseUrl() + '/ecom-inventory/search',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "param": "item",
          "companyId": oldCompanyId,
          "value": value
        }));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 204) {
      throw Error();
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to save data');
    } else {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (responseMap["status"]) {
        print(responseMap["status"]);
        throw Exception('Failed to load data models');
      } else {
        return ApiResponse.fromMap(responseMap);
      }
    }
  }

  Future<ApiResponse<dynamic>> getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String emailId = prefs.getString('emailId');
    // String accessToken = prefs.getString('accessToken');
    final http.Response response = await http.post(getBaseUrl() + '/get-order',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          //'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, String>{
          "emailId": emailId,
          "companyId": oldCompanyId,
        }));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 204) {
      throw Error();
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to save data');
    } else {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (responseMap["status"]) {
        print(responseMap["status"]);
        throw Exception('Failed to load data models');
      } else {
        return ApiResponse.fromMap(responseMap);
      }
    }
  }

  Future<ApiResponse<dynamic>> getProduct(String value) async {
    final http.Response response = await http.post(
        getBaseUrl() + '/product-search',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{"companyId": oldCompanyId, "name": value}));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 204) {
      throw Error();
    }
    if (response.statusCode != 200) {
      throw Error();
    } else {
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      if (!responseMap["status"]) {
        print(responseMap["status"]);
        throw Exception('Failed to load data models');
      } else {
        return ApiResponse.fromMap(responseMap);
      }
    }
  }
}
