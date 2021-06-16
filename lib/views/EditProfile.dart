import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  GlobalKey<FormState> profileForm = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController userAddressController = TextEditingController();
  TextEditingController userLocationController = TextEditingController();
  ValueNotifier<bool> busyNotifier = ValueNotifier(false);
  int dateTimeMillisChoosen;
  ValueNotifier<bool> scrollListenable = ValueNotifier<bool>(false);

  ValueNotifier<PickedFile> pickedFileNotifier = ValueNotifier(null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // appUser = context.read<FirebaseAppUserProvider>().appUser;
    // nameController.text = appUser.name;
    // phoneController.text = appUser.phoneNumber;
    // emailController.text = appUser.emailAddress;
    // if (appUser.dateOfBirth != null) {
    //   dateOfBirthController.text = Constants.setAge(appUser.dateOfBirth);
    // }
    // genderController.text = appUser.gender;
    // userAddressController.text = appUser.userAddress;
    // userLocationController.text = appUser.pickedDeliveryAddress.address;
    // f1.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text('My Profile'),
        leading: IconButton(icon: Icon(Icons.west_sharp), onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: profileForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ValueListenableBuilder<PickedFile>(
                        valueListenable: pickedFileNotifier,
                        builder: (_, file, __) {
                          if (file != null) {
                            return CircleImageInkWell(
                              image: FileImage(File(file.path)),
                              onPressed: handleImagePicker,
                              size: 150,
                            );
                          }
                          return CircleImageInkWell(
                            image: AssetImage('assets/images/placeholder.png'),
                            onPressed: handleImagePicker,
                            size: 150,
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0.w, vertical: 0.75.h),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(color: Colors.black87, fontSize: 12.0.sp),
                            alignLabelWithHint: true,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).accentColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0.w, vertical: 0.75.h),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(color: Colors.black87, fontSize: 12.0.sp),
                            alignLabelWithHint: true,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).accentColor),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: busyNotifier,
              builder: (_, bool busy, __) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    busy ? Padding(padding: const EdgeInsets.all(16.0), child: CircularProgressIndicator()) : SizedBox(),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      width: double.infinity,
                      height: 46,
                      child: RaisedButton(
                        child: Text('UPDATE', style: TextStyle(color: Colors.white)),
                        color: Theme.of(context).accentColor,
                        onPressed: busy ? null : saveAndContinue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void saveAndContinue() async {
    if (!profileForm.currentState.validate()) {
      return;
    }
    busyNotifier.value = true;
    // appUser.name = nameController.text;
    // appUser.userAddress = userAddressController.text;
    // appUser.gender = genderController.text;
    // appUser.dateOfBirth = dateTimeMillisChoosen;
    // appUser.emailAddress = emailController.text;
    // appUser.referralCode = Provider.of<FirebaseAppUserProvider>(context, listen: false).generateUserReferralCode(appUser.name);
    // if (pickedLocation != null) {
    //   appUser.pickedDeliveryAddress = pickedLocation;
    // }
    // if (currentLocation != null) {
    //   appUser.currentAddress = currentLocation;
    // }
    // FirestoreHelper.createUserInsideDatabase(
    //   appUser,
    //   (AppUser appUser) {
    //     Provider.of<FirebaseAppUserProvider>(context, listen: false).updateAppUser(appUser);
    //     Navigator.pop(context);
    //   },
    // );
  }

  void handleImagePicker() async {
    PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 35);
    if (file != null) {
      pickedFileNotifier.value = file;
    }
  }
}
