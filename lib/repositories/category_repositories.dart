import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository {
  CollectionReference<CategoryModel> categoryRef =
  FirebaseService.db.collection("categories").withConverter<CategoryModel>(
    fromFirestore: (snapshot, _) {
      return CategoryModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );
  Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if (!hasData) {
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>> getCategory(String categoryId) async {
    try {
      print(categoryId);
      final response = await categoryRef.doc(categoryId).get();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  List<CategoryModel> makeCategory() {
    return [
      CategoryModel(
          categoryName: "Casual",
          status: "active",
          imageUrl:
          "https://assets.myntassets.com/dpr_1.5,q_60,w_400,c_limit,fl_progressive/assets/images/18274390/2022/5/14/c64644f6-840f-4496-bb42-19359e9881771652523841987RoadsterMenBrownTexturedPUSneakers1.jpg"),
      CategoryModel(
          categoryName: "Formal",
          status: "active",
          imageUrl:
          "https://media.karousell.com/media/photos/products/2022/7/23/men_formal_shoes_blue_black_br_1658590215_1c815789.jpg"),
      CategoryModel(
          categoryName: "Sport",
          status: "active",
          imageUrl:
          "https://assets.myntassets.com/dpr_1.5,q_60,w_400,c_limit,fl_progressive/assets/images/17755112/2022/4/4/3e291b2e-2e6a-4699-9f42-ea6d8d9512eb1649088875683ASIANMenWhiteSportsShoes1.jpg"),
      CategoryModel(
          categoryName: "slippers",
          status: "active",
          imageUrl:
          "https://www.realsimple.com/thmb/zn-wqk1cosENpIo7b6I6TkVAo6k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/equick-slippers-for-women-and-men-shower-quick-drying-bathroom-sandals-tout-012be75839d242cdadc05fabc66e9d06.jpg"),
    ];
  }
}