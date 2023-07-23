import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sorgulapp/home.dart';
import 'package:sorgulapp/pages/panel.dart';
import 'package:sorgulapp/photo_add_page.dart';
import 'package:sorgulapp/splashs/splash1.dart';
import 'package:translator/translator.dart';

import 'controller.dart';
import 'firebase_constants.dart';

class AuthController extends GetxController {
  int currentPage = 0;
  int currentPage2 = 0;

  Controller _controller = Get.put(Controller());
  static AuthController authInstance = Get.find();
  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());

    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user != null) {
      // user is logged in
      Get.offAll(() => (currentPage == 0 ? PanelPage() : PhotoAddPage()));
    } else {
      // user is null as in user is not available or not logged in
      Get.offAll(() => currentPage2 == 0 ? MyHomePage() : MainContent());
    }
  }

  void register(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      currentPage = 1;
    } on FirebaseAuthException catch (e) {
      // this is solely for the Firebase Auth Exception
      // for example : password did not match

      // Get.snackbar("Error", e.message!);
      final translator = GoogleTranslator();
      var translation =
          await translator.translate(e.message.toString(), to: 'tr');
      Get.snackbar("Dikkat", "Hatalı giriş!");
    } catch (e) {
      // this is temporary. you can handle different kinds of activities
      //such as dialogue to indicate what's wrong
      print(e.toString());
    }
  }

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: _controller.mail, password: password);
      currentPage = 0;
    } on FirebaseAuthException catch (e) {
      // this is solely for the Firebase Auth Exception
      // for example : password did not match

      final translator = GoogleTranslator();
      var translation =
          await translator.translate(e.message.toString(), to: 'tr');
      Get.snackbar("Dikkat", "Hatalı giriş!");
    } catch (e) {
      print(e.toString());
    }
  }

  void signOut() {
    try {
      auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteUser() {
    auth.currentUser!.delete();
  }
}
