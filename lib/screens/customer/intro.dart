import 'dart:io';

import 'package:beverly_hills_shopping_app/components/custom_text_field.dart';
import 'package:beverly_hills_shopping_app/enums.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final TextEditingController firstNameCustomerController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile _imageFile;
  String _pickedImageFilePath = "";
  dynamic _pickImageError;

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CustomerHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: PrimaryColorDark,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 19.0,
      ),
      descriptionPadding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 16.0),
      titlePadding: EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 16.0),
      pageColor: SecondaryColorLight,
      imagePadding: EdgeInsets.zero,
      footerPadding: EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 0.0),
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: SecondaryColorLight,
      pages: [
        PageViewModel(
          title: "Let's Set a Profile Picture",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: PrimaryColorLight,
                  ),
                  child: Center(
                    child: _pickedImageFilePath != ""
                        ? Image.file(File(_pickedImageFilePath))
                        : Image.asset(
                            'images/user.png',
                            fit: BoxFit.cover,
                            height: 130,
                            width: 130,
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  print("tapped");
                  _onImageButtonPressed(ImageSource.gallery, context);
                },
                splashColor: PrimaryColorLight,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 120,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: PrimaryColorDark),
                  ),
                  child: Center(
                    child: Text(
                      "Upload Picture",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: PrimaryColorDark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          footer: Text(
            "Upload a photo from your gallery and set it as your profile picture.\n\nDon't worry!\nIt can be changed at any time in your profile.",
            textAlign: TextAlign.justify,
            style: TextStyle(
                color: PrimaryColorDark,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Let us get to know about you a little more ..",
          bodyWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField(
                controller: firstNameCustomerController,
                height: 60,
                width: width,
                hintText: "First name",
                icon: Icons.person_add_alt_1,
                iconSize: 22,
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: firstNameCustomerController,
                height: 60,
                width: width,
                hintText: "Last name",
                icon: Icons.person_add_alt_1_outlined,
                iconSize: 22,
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: firstNameCustomerController,
                height: 60,
                width: width,
                hintText: "Mobile number",
                icon: Icons.phone,
                iconSize: 22,
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: firstNameCustomerController,
                height: 60,
                width: width,
                hintText: "Address line 1",
                icon: Icons.note,
                iconSize: 22,
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: firstNameCustomerController,
                height: 60,
                width: width,
                hintText: "Address line 2",
                icon: Icons.note,
                iconSize: 22,
              ),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: firstNameCustomerController,
                height: 60,
                width: width,
                hintText: "Address line 3",
                icon: Icons.note,
                iconSize: 22,
              ),
            ],
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Time to Go Shopping!",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text("Time to Go Shopping!")],
          ),
          decoration: pageDecoration.copyWith(
            titlePadding: EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 16.0),
            titleTextStyle: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w700,
              color: PrimaryColorDark,
            ),
          ),
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: false,
      skipFlex: 0,
      nextFlex: 0,
      next: const Icon(Icons.arrow_forward_ios),
      nextColor: SecondaryColorDark,
      done: InkWell(
        splashColor: PrimaryColorLight,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 60,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: PrimaryColorDark),
          ),
          child: Center(
            child: Text(
              "DONE",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: PrimaryColorDark,
              ),
            ),
          ),
        ),
      ),
      doneColor: SecondaryColorDark,
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: PrimaryColorDark,
        activeSize: Size(22.0, 10.0),
        activeColor: SecondaryColorDark,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }

  void _onImageButtonPressed(ImageSource source, BuildContext context) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
      );
      setState(() {
        _imageFile = pickedFile;
        _pickedImageFilePath = _imageFile.path;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }
}
