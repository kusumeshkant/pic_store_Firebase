import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:picstore/src/screens.dart';

class ListImages extends StatefulWidget {
  ListImages({Key? key}) : super(key: key);

  @override
  State<ListImages> createState() => _ListImagesState();
}

class _ListImagesState extends State<ListImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text("Uploaded Images"),
        // ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Home_screen()));
      },
      child: Icon(Icons.add),),
        body: SafeArea(
          child: Container(
              height: MediaQuery.of(context).size.height,
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
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("imageUrl")
                    .snapshots(),
                 builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return !snapshot.hasData
                      ? const Center(
                          child:  CircularProgressIndicator(),
                        )
                      : GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            childAspectRatio: .8,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                                margin: EdgeInsets.all(5),
                                child: Image.network(
                                    snapshot.data!.docs[index].get("url"),
                                   fit: BoxFit.cover,
                                )
                            );
                          });
                },
              )),
        ));
  }
}
