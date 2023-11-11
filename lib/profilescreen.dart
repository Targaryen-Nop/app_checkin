import 'dart:io';
import 'package:checkin_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;

  String birthDate = 'Date of Birth';

  Color primary = const Color.fromRGBO(12, 45, 92, 1);

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 98);

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${Users.id.toLowerCase()}_profilepic.jpg");
    await ref.putFile(File(image!.path));
  ref.getDownloadURL().then((value) {
    setState(() {
      Users.profilePiclink = value;
    });
  });

  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: (){
              pickUploadProfilePic();
            },
            child: Container(
              margin: EdgeInsets.only(top: 80, bottom: 24),
              height: 120,
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: primary),
              child: Center(
                child: Users.profilePiclink == ""  ? const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 80,
                ) : Image.network(Users.profilePiclink),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Username : ${Users.username}',
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
                fontSize: screenWidth / 20,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          textField("First Name", "First Name", _firstnameController),
          textField("Last Name", "Last Name", _lastnameController),
          textField("Phone", "Phone", _phoneController),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Date of Birth',
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                              primary: primary,
                              secondary: primary,
                              onSecondary: Colors.white),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(primary: primary),
                          ),
                          textTheme: const TextTheme(
                            headline4: TextStyle(fontFamily: 'NexaBold'),
                            overline: TextStyle(fontFamily: 'NexaBold'),
                            button: TextStyle(fontFamily: 'NexaBold'),
                          )),
                      child: child!);
                },
              ).then((value) {
                setState(() {
                  birthDate = DateFormat('dd/MM/yyyy').format(value!);
                });
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: kToolbarHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black54),
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 11, top: 10),
                margin: const EdgeInsets.only(bottom: 12),
                alignment: Alignment.centerLeft,
                child: Text(
                  birthDate,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontFamily: "NexaBold",
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () async {
              String firstName = _firstnameController.text;
              String lastName = _lastnameController.text;
              String phone = _phoneController.text;
              String address = _addressController.text;

              if (Users.conEdit) {
                if (firstName.isEmpty) {
                  showSnackBar('Please enter your firstname');
                } else if (lastName.isEmpty) {
                  showSnackBar('Please enter your lastname');
                } else if (phone.isEmpty) {
                  showSnackBar('Please enter your phone');
                } else if (birthDate.isEmpty) {
                  showSnackBar('Please enter your birthdate');
                } else {
                  await FirebaseFirestore.instance
                      .collection('Employee')
                      .doc(Users.id)
                      .update({
                    'firstName': firstName,
                    'lastName': lastName,
                    'birthDate': birthDate,
                    'phone': phone,
                    'conEdit': false
                  });
                }
              } else {
                showSnackBar('Dont Have Edit anythings');
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: kToolbarHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black54),
                color: primary,
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 11, top: 10),
                margin: const EdgeInsets.only(bottom: 12),
                alignment: Alignment.centerLeft,
                child: const Center(
                  child: Text(
                    'Save Data',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "NexaBold",
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textField(
      String hint, String title, TextEditingController controller) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black54,
              fontFamily: "NexaBold",
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.black54,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
                fontSize: 14,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(text),
      ),
    );
  }
}
