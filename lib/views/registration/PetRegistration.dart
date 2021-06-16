import 'package:flutter/material.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saloon_app/BusyLoader.dart';
import 'package:saloon_app/helper/FirestoreHelper.dart';
import 'package:saloon_app/models/AuthCallback.dart';
import 'package:saloon_app/models/Pet.dart';
import 'package:saloon_app/providers/AuthenticationProvider.dart';
import 'dart:io';

class DogRegistration extends StatefulWidget {
  @override
  _DogRegistrationState createState() => _DogRegistrationState();
}

class _DogRegistrationState extends State<DogRegistration> {
  ValueNotifier<bool> petIdNotifier = ValueNotifier<bool>(false);
  AuthenticationProvider authenticationProvider;
  ValueNotifier<PickedFile> pickedFileNotifier = ValueNotifier(null);
  ValueNotifier<bool> busyNotifier = ValueNotifier(false);
  ValueNotifier<Pet> petNotifier = ValueNotifier(null);
  TextEditingController fieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: ValueListenableBuilder<Pet>(
                        valueListenable: petNotifier,
                        builder: (context, Pet pet, __) {
                          if (pet == null) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: petIdNotifier,
                              builder: (_, value, __) {
                                return Text(
                                  value ? 'Add Pet To Your Profile' : 'Register Your Pet',
                                  style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                                );
                              },
                            );
                          }
                          return Text(
                            'Add \'${pet.name}\' to your profile',
                            style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ValueListenableBuilder(
                        valueListenable: petNotifier,
                        builder: (_, Pet pet, __) {
                          if (pet == null) {
                            return ValueListenableBuilder<PickedFile>(
                              valueListenable: pickedFileNotifier,
                              builder: (_, file, __) {
                                if (petIdNotifier.value) {
                                  return CircleImageInkWell(
                                    image: AssetImage('assets/images/placeholder.png'),
                                    onPressed: null,
                                    size: 150,
                                  );
                                }
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
                            );
                          }
                          return CircleImageInkWell(
                            image: NetworkImage('${pet.displayPic}'),
                            onPressed: handleImagePicker,
                            size: 150,
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      color: Color(0xfff5f5f5),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: petIdNotifier,
                        builder: (_, value, __) {
                          return TextFormField(
                            controller: fieldController,
                            style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: value ? 'Pet Id' : 'Pet name',
                              prefixIcon: Icon(Icons.pets),
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                      child: ValueListenableBuilder(
                        valueListenable: petNotifier,
                        builder: (_, Pet pet, __) {
                          if (pet == null) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: petIdNotifier,
                              builder: (_, value, __) {
                                return MaterialButton(
                                  onPressed: value ? findPet : registerPet,
                                  child: Text(
                                    value ? 'CONTINUE' : 'REGISTER',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'SFUIDisplay',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  color: Color(0xffff2d55),
                                  elevation: 0,
                                  minWidth: 400,
                                  height: 50,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                );
                              },
                            );
                          }
                          return MaterialButton(
                            onPressed: continueWithPet,
                            child: Text(
                              'CONTINUE',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'SFUIDisplay',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: Color(0xffff2d55),
                            elevation: 0,
                            minWidth: 400,
                            height: 50,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          );
                        },
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: petNotifier,
                      builder: (_, Pet pet, __) {
                        if (pet == null) {
                          return Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Center(
                              child: ValueListenableBuilder(
                                valueListenable: petIdNotifier,
                                builder: (_, bool value, __) {
                                  if (value) {
                                    return GestureDetector(
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Register a new pet ?",
                                              style: TextStyle(
                                                fontFamily: 'SFUIDisplay',
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '\n\nRegister Pet !',
                                              style: TextStyle(
                                                fontFamily: 'SFUIDisplay',
                                                color: Color(0xffff2d55),
                                                fontSize: 15,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () => petIdNotifier.value = !petIdNotifier.value,
                                    );
                                  }
                                  return GestureDetector(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Already have a pet id ?",
                                            style: TextStyle(
                                              fontFamily: 'SFUIDisplay',
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '\n\nAdd Pet By Id',
                                            style: TextStyle(
                                              fontFamily: 'SFUIDisplay',
                                              color: Color(0xffff2d55),
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () => petIdNotifier.value = !petIdNotifier.value,
                                  );
                                },
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: busyNotifier,
            builder: (_, bool busy, __) {
              if (busy) {
                return Positioned.fill(
                  child: Center(
                    child: BusyLoader(),
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  void continueWithPet() async {
    authenticationProvider.setPet(petNotifier.value);
    AuthCallback callback = await authenticationProvider.signUpAndFindPet(showSnackBar);
    showSnackBar(callback);
    if (!callback.error) {
      // on success
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
  }

  void findPet() async {
    if (fieldController.text.isEmpty) {
      showSnackBar(AuthCallback('Please enter pet id', true));
      return;
    }
    if (fieldController.text.length < 7) {
      showSnackBar(AuthCallback('Please enter valid pet id', true));
      return;
    }
    updateBusyState();
    Pet pet = await FirestoreHelper.findPetById(fieldController.text);
    if (pet != null) {
      if (pet.users.length < 5) {
        petNotifier.value = pet;
        fieldController.text = pet.name;
        updateBusyState();
        return;
      }
      updateBusyState();
      showSnackBar(AuthCallback('Maximum users been added...', true));
      return;
    }
    updateBusyState();
    showSnackBar(AuthCallback('Couldn\'t find pet', true));
    return;
  }

  void registerPet() async {
    if (pickedFileNotifier.value == null) {
      showSnackBar(AuthCallback('Please add your pet image', true));
      return;
    }
    if (fieldController.text.isEmpty) {
      showSnackBar(AuthCallback('Please add your pet name', true));
      return;
    }
    updateBusyState();
    authenticationProvider.setPet(Pet(fieldController.text, File(pickedFileNotifier.value.path)));
    AuthCallback callback = await authenticationProvider.signUp(showSnackBar);
    showSnackBar(callback);
    if (!callback.error) {
      // on success
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
  }

  void updateBusyState() {
    busyNotifier.value = !busyNotifier.value;
  }

  showSnackBar(AuthCallback callback) {
    SnackBar snackBar = SnackBar(
      content: Text(callback.message, style: TextStyle(color: Colors.white)),
      backgroundColor: callback.error ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handleImagePicker() async {
    PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 35);
    if (file != null) {
      pickedFileNotifier.value = file;
    }
  }
}
