import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:surai_crafts/models/category_model.dart';
import 'package:surai_crafts/models/product_model.dart';
import 'package:surai_crafts/viewmodels/auth_viewmodel.dart';
import 'package:surai_crafts/viewmodels/category_viewmodel.dart';
import 'package:surai_crafts/viewmodels/product_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/global_ui_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthViewModel _authViewModel;
  late CategoryViewModel _categoryViewModel;
  late ProductViewModel _productViewModel;

  TextEditingController _searchController = TextEditingController();
  late String _searchQuery;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _categoryViewModel = Provider.of<CategoryViewModel>(context, listen: false);
      _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
      refresh();
    });
    super.initState();
  }

  Future<void> refresh() async {
    _categoryViewModel.getCategories();
    _productViewModel.getProducts();
    _authViewModel.getMyProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CategoryViewModel, AuthViewModel, ProductViewModel>(
      builder: (context, categoryVM, authVM, productVM, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(top: 60),
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/logo1.jpg",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 20),
                        WelcomeText(authVM),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [...categoryVM.categories.map((e) => CategoryCard(e))],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Our Products",
                            style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: GridView.count(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: [...productVM.products.map((e) => ProductCard(e))],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            HomeHeader(),
          ],
        );
      },
    );
  }

  Widget HomeHeader() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        height: 100, // Adjust the height as needed
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(15),
        child: Image.asset(
          "assets/images/logo2.jpg",
          height: 500, // Adjust the height as needed
          width: 600, // Adjust the width as needed
        ),
      ),
    );
  }

  Widget WelcomeText(AuthViewModel authVM) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Welcome,",
            style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            authVM.loggedInUser != null ? authVM.loggedInUser!.name.toString() : "Guest",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget CategoryCard(CategoryModel e) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/single-category", arguments: e.id.toString());
      },
      child: Container(
        width: 120,
        height: 120,
        padding: EdgeInsets.all(10),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.network(
              e.imageUrl.toString(),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget ProductCard(ProductModel e) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/single-product", arguments: e.id);
      },
      child: Container(
        width: 250,
        child: Card(
          elevation: 5,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  e.imageUrl.toString(),
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/images/paint1.png',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          e.productName.toString(),
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        Text(
                          "Rs. " + e.productPrice.toString(),
                          style: TextStyle(fontSize: 15, color: Colors.brown),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
