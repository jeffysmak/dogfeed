import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saloon_app/AppStrings.dart';
import 'package:saloon_app/models/AppConfig.dart';
import 'package:saloon_app/models/AppUser.dart';
import 'package:saloon_app/models/Pet.dart';
import 'package:saloon_app/models/PetFeed.dart';

class FirestoreHelper {
  static Future<AppUser> insertUserData(AppUser user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection(AppStrings.KEY_USERS).doc(user.email).set(user.toMap()).catchError(
      (err) {
        print('FirestoreError insertUserData : $err');
      },
    );
    user.id = FirebaseAuth.instance.currentUser.uid;
    return user;
  }

  static Future<AppUser> getUserData(User user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot profileDocument = await firestore.collection(AppStrings.KEY_USERS).doc(user.email).get().catchError(
      (err) {
        print('FirestoreError getUserData : $err');
      },
    );
    if (profileDocument.exists && profileDocument.data() != null) {
      return AppUser.fromMap(profileDocument.data(), profileDocument.id);
    }
    return null;
  }

  static Future<Pet> insertPetData(Pet pet) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection(AppStrings.KEY_PETS).add(pet.toMap()).catchError(
      (err) {
        print('FirestoreError insertPetData : $err');
      },
    );
    return pet;
  }

  static Future<Pet> updatePetData(Pet pet) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection(AppStrings.KEY_PETS).doc(pet.docID).set(pet.toMap()).catchError(
      (err) {
        print('FirestoreError updatePetData : $err');
      },
    );
    return pet;
  }

  static Future<Pet> getPetByProfile(String docID) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot = await firestore.collection(AppStrings.KEY_PETS).doc(docID).get();
    if (documentSnapshot != null && documentSnapshot.exists && documentSnapshot.data() != null) {
      return Pet.fromMap(documentSnapshot.data(), docID: documentSnapshot.id);
    }
    return null;
  }

  static Future<Pet> findPetById(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection(AppStrings.KEY_PETS).where('id', isEqualTo: (id.toUpperCase())).get();
    if (snapshot != null && snapshot.docs != null && snapshot.docs.length > 0) {
      Pet pet = Pet.fromMap(snapshot.docs.first, docID: snapshot.docs.first.id);
      return pet;
    }
    return null;
  }

  static Future<bool> checkUserAlreadyExist(String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot = await firestore.collection(AppStrings.KEY_USERS).doc(email).get();
    return documentSnapshot != null && documentSnapshot.exists && documentSnapshot.data() != null;
  }

  static Future<AppUser> insertAppUser(AppUser appUser, Pet pet) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection(AppStrings.KEY_USERS).doc(appUser.email).set(appUser.toMap());
    pet.id = '${DateTime.now().millisecondsSinceEpoch}';
    DocumentReference reference = await firestore.collection(AppStrings.KEY_PETS).add(pet.toMap());
  }

  static Future<AppConfig> getAppConfig() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot = await firestore.collection('AppConfig').doc('FeedTimes').get();
    return AppConfig.fromMap(documentSnapshot.data());
  }

  static Future<void> pushPetFeed(Pet pet) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('pets').doc(pet.docID).update(pet.toMap());
  }
}
