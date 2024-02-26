import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seven_steps/models/category_model.dart';
import 'package:seven_steps/models/product_model.dart';
import 'package:seven_steps/models/user_model.dart';
import 'package:seven_steps/repositories/auth_repositories.dart';
import 'package:seven_steps/repositories/favorite_repositories.dart';
import 'package:seven_steps/services/firebase_service.dart';
import 'package:seven_steps/viewmodels/global_ui_viewmodel.dart';

import '../models/favorite_model.dart';
import '../repositories/category_repositories.dart';
import '../repositories/product_repositories.dart';

class ProductViewModel with ChangeNotifier {
  ProductRepository _productRepository = ProductRepository();
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  Future<void> getProducts() async{
    _products=[];
    notifyListeners();
    try{
      var response = await _productRepository.getAllProducts();
      for (var element in response) {
        print(element.id);
        _products.add(element.data());
      }
      notifyListeners();
    }catch(e){
      print(e);
      _products = [];
      notifyListeners();
    }
  }


  Future<void> addProduct(ProductModel product) async{
    try{
      var response = await _productRepository.addProducts(product: product);
    }catch(e){
      notifyListeners();
    }
  }

}