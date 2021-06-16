import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saloon_app/Globals.dart';
import 'package:saloon_app/helper/AuthenticationHelper.dart';
import 'package:saloon_app/helper/FirestoreHelper.dart';
import 'package:saloon_app/helper/StorageHelper.dart';
import 'package:saloon_app/models/AppConfig.dart';
import 'package:saloon_app/models/AppUser.dart';
import 'package:saloon_app/models/AuthCallback.dart';
import 'package:saloon_app/models/Pet.dart';

class AuthenticationProvider extends ChangeNotifier {
  AppUser appUser;
  Pet pet;
  User firebaseUser;

  void setAppUser(AppUser appUser) {
    this.appUser = appUser;
  }

  void setPet(Pet p) {
    this.pet = p;
    notifyListeners();
  }

  void initializeUser() async {
    if (appUser != null) return;
    this.firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      AppUser signedinUser = await FirestoreHelper.getUserData(firebaseUser);
      this.appUser = signedinUser;
    }
    this.pet = await FirestoreHelper.getPetByProfile(appUser.petID);
    notifyListeners();
  }

  Future<AuthCallback> signUp(Function callbacks) async {
    firebaseUser = await AuthenticationHelper.signUserUp(appUser, callbacks);
    print('User created ${firebaseUser != null}');
    if (firebaseUser != null) {
      String petImageURL = await StorageHelper.uploadPhoto(pet.petImageFile, 'PETS');
      pet.displayPic = petImageURL;
      pet.id = Globals.generatePetId(firebaseUser.uid);
      pet.users.add(firebaseUser.email);
      this.appUser = await FirestoreHelper.insertUserData(appUser);
      this.pet = await FirestoreHelper.insertPetData(pet);
      return AuthCallback('Registration successful', false);
    }
    return AuthCallback('Registration un successful', true);
  }

  Future<AuthCallback> signUpAndFindPet(Function callbacks) async {
    firebaseUser = await AuthenticationHelper.signUserUp(appUser, callbacks);
    print('User created ${firebaseUser != null}');
    if (firebaseUser != null) {
      print('LENGTH ${pet.users.length}');
      pet.users.add(firebaseUser.email);
      print('LENGTH ${pet.users.length}');
      this.appUser.petID = pet.id;
      this.appUser = await FirestoreHelper.insertUserData(appUser);
      this.pet = await FirestoreHelper.updatePetData(pet);
      return AuthCallback('Registration successful', false);
    }
    return AuthCallback('Registration un successful', true);
  }
}
