import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'constants.dart';
import 'firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  }

  else{
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: UploadingImageToFirebaseStorage(),
    );
  }
}

// class FireStorageService extends ChangeNotifier {
//   FireStorageService();
//   static Future<dynamic> loadImage(BuildContext context, String Image) async {
//     return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
//   }
// }
//
// Future<Widget> _getImage(BuildContext context, String imageName) async {
//   late Image image;
//   await FireStorageService.loadImage(context, imageName).then((value) {
//     image = Image.network(value.toString(), fit: BoxFit.scaleDown);
//   });
//   return image;
// }

class UploadingImageToFirebaseStorage extends StatefulWidget{
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class  _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage>{
  late File imageFile;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('PrintFile: ${pickedFile.toString()}');
      setState(() {
        imageFile = File(pickedFile.path);
      });
    } else {
      print('PickedFile: is null');
    }
    if (imageFile != null) {
      return imageFile;
    }
  }


  Future uploadImageToFirebase(BuildContext context) async{
    late String imageUrl;
    String fileName = basename(imageFile.path);
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    uploadTask.whenComplete(() async{
      try{
        imageUrl = await firebaseStorageRef.getDownloadURL();
      }catch(onError){
        print("Error");
      }
      return imageUrl;

    });
  }


  @override
  Widget build(BuildContext context) {
    //final Storage storage = Storage();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20,),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 85,
                child: ClipOval(
                  child: users.containsKey('imageUrl') ? Image.network(
                        '${users['imageUrl']}') : Container(),
                      ),

                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  getImage();
                },
                child: Text( "Change Photo"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange.shade900, textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, fontFamily: 'Spartan',),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: ),
            )
            //const SizedBox(height: 24,),
            // textField("Name","Jane Doe"),
            // textField("Email","janedoe@xyz.com"),
            // textField("Location", "Delhi"),
            // textField("Phone Number","9845XXXXXX"),
            Container(
              padding: EdgeInsets.all(15.0),
              height: 50,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade700,
                    Colors.orange.shade900
                  ],
                ),
              ),
              child: TextButton(
                onPressed: () {
                  uploadImageToFirebase(context);
                },
                child: Text('Save Changes'),
                style: TextButton.styleFrom( textStyle: const TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontFamily: 'Spartan',),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Widget textField(String title, String hint){
  return Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: "Spartan",
            fontSize: 20,
            color: Colors.orange.shade900,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom:12),
        child: TextFormField(
          cursorColor: Colors.white,
          maxLines: 1,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blueGrey.withOpacity(0.15),
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white,
              fontFamily: "Spartan",
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                )
            ),
          ),
        ),
      ),
    ],
  );
}



