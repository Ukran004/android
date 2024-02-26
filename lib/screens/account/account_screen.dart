import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seven_steps/services/local_notification_service.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  void logout() async{
    _ui.loadState(true);
    try{
      await _auth.logout().then((value){
        Navigator.of(context).pushReplacementNamed('/login');
      })
          .catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
      });
    }catch(err){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    }
    _ui.loadState(false);
  }

  late GlobalUIViewModel _ui;
  late AuthViewModel _auth;
  @override
  void initState() {
    _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    _auth = Provider.of<AuthViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Image.asset(
            "assets/images/user.png",
            height: 200,
            width: 300,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(_auth.loggedInUser!.email.toString(),style: TextStyle(
              fontSize: 20,
                fontFamily: 'WorkSansSemiBold',
            ),),
          ),
          SizedBox(
            height: 10,
          ),
          makeSettings(
              icon: Icon(Icons.sell),
              title: "My Products",
              subtitle: "Get listing of my products",
              onTap: (){
                Navigator.of(context).pushNamed("/my-products");
              }
          ),
          makeSettings(
              icon: Icon(Icons.logout),
              title: "Logout",
              subtitle: "Logout from this application",
              onTap: (){
                logout();
              }
          ),
          makeSettings(
              icon: Icon(Icons.android),
              title: "Version",
              subtitle: "7.1.7",
              onTap: (){

              }
          )
        ],
      ),
    );
  }

  makeSettings({required Icon icon, required String title, required String subtitle, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
            elevation: 4,
            color: Colors.white,
            child: ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                leading: icon,
                title: Text(
                  title,
                ),
                subtitle: Text(
                  subtitle,
                ))),
      ),
    );
  }
}