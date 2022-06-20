import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

import 'List_images.dart';




class Home_screen extends StatefulWidget {
  const Home_screen({Key? key}) : super(key: key);

  @override
  State<Home_screen> createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {
  bool done = false;
  bool uploading = false;
  double val = 0;
  CollectionReference? imgRef;
  firebase_storage.Reference? ref;

  List<File> _image = [];
  List<String> imgUrl = [];
  final picker = ImagePicker();
  List<String> a = List<String>.filled(0, '', growable: true);


  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgRef = FirebaseFirestore.instance.collection("imageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff204B4B), Color(0xff000000)])),
        child: Stack(
          children: [
            SafeArea(
              child: Container(
                margin:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                height: MediaQuery.of(context).size.height ,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(-4, -4),
                          spreadRadius: .2,
                          blurRadius: 2,
                          color: Colors.white38,
                          inset: true),
                      BoxShadow(
                          offset: Offset(4, 4),
                          spreadRadius: .2,
                          blurRadius: 2,
                          color: Colors.black,
                          inset: true)
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xff204B4B), Color(0xff000000)])),
                child: GridView.builder(
                    itemCount: _image.length,
                    gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      childAspectRatio: .8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black12,
                        ),
                        child: Stack(
                          children: [
                            _image != null
                                ? ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.file(_image[index], fit: BoxFit.cover, height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width ,))
                                : const SizedBox(),
                            // Positioned(
                            //   right: 0,
                            //   child: Checkbox(
                            //       value: done,
                            //       onChanged: (newvalue) {
                            //         setState(() {
                            //           if (selectedIndex == _image[index]) {
                            //             done = !done;
                            //             log(done.toString());
                            //           }
                            //           log(done.toString());
                            //
                            //           //  _image[index] = done;
                            //         });
                            //       }),
                            // ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
           Positioned(
             top: 400,
             right: 150,
             child:  uploading ? Column(
             children:  [
               const  Text('Uploading....', style: TextStyle(
                   fontWeight: FontWeight.w700,
                   fontSize: 16,
                   color: Colors.white
               ),),
               SizedBox(height: 10,),
               Center(child: CircularProgressIndicator(
                 value: val,
                 color: Colors.white,),),
             ],
           ): const SizedBox(),),
            Positioned(
              bottom: 140,
              left: 70,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile().whenComplete(() =>
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context)=>
                              ListImages()), (route) => false));
                  log('Uploaded');
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 35, right: 35),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey,
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(-4, -4),
                            spreadRadius: .2,
                            blurRadius: 2,
                            color: Colors.white38,
                            inset: true),
                        BoxShadow(
                            offset: Offset(4, 4),
                            spreadRadius: .2,
                            blurRadius: 2,
                            color: Colors.black,
                            inset: true)
                      ]),
                  child: Center(
                    child: Text(
                      "Upload",
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 70,
              left: 70,
              child: GestureDetector(
                onTap: () {
                  chooseImage();
                  log('done');
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 35, right: 35),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey,
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(-4, -4),
                            spreadRadius: .2,
                            blurRadius: 2,
                            color: Colors.white38,
                            inset: true),
                        BoxShadow(
                            offset: Offset(4, 4),
                            spreadRadius: .2,
                            blurRadius: 2,
                            color: Colors.black,
                            inset: true)
                      ]),
                  child: Center(
                    child: Text(
                      "Select Pic from Galary",
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // get() {
  //   imgRef = FirebaseFirestore.instance.collection('products');
  // }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref?.putFile(img).whenComplete(() async {
        await ref?.getDownloadURL().then((value) {
          a.add(value.toString());
          imgRef?.add({'url': value});
          i++;
        });
      });
    }
  }
}
