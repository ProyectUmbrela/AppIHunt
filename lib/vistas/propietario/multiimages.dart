import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ihunt/vistas/bloc/product_bloc.dart';*/

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {


  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];


  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    print("Image List Length:" + imageFileList.length.toString());
    setState((){});
  }


  @override
  Widget build(BuildContext context) {

    //final productBloc = BlocProvider.of<ProductBloc>(context);

    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            selectImages();
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 5),
              itemCount: imageFileList.length,
              itemBuilder: (context, index) => Container(
                height: 100,
                width: 120,
                margin: EdgeInsets.only(left: 3.0, right: 3.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(imageFileList[index].path)),
                    fit: BoxFit.cover
                  ),
                ),
              ),
            )
            /*BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) => state.images != null?
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  itemCount: state.images.length,
                  itemBuilder: (_, index) => Container(
                    height: 100,
                    width:120,
                    margin: EdgeInsets.only(left: 3.0, right: 3.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(state.images[index].path)),
                            fit: BoxFit.cover
                        )
                    )
                    ,),

                  //itemBuilder: itemBuilder
                ): Icon(Icons.photo_camera,size: 80,
                  color: Colors.grey,)
            ),*/

          ),),),
    );

    /*return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 5,),
                Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(5),
                color: Color(0xff01A0C7),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    selectImages();
                  },
                  child: Text("Añadir imagenes",
                      textAlign: TextAlign.center,
                      //style: style.copyWith(color: Colors.white)),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      itemCount: imageFileList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(File(imageFileList[index].path), fit: BoxFit.cover,);
                      }),
                ),
              ),

              SizedBox(height: 5,),
            ],
          ),
        ));*/
  }


/*
  File singleImage;

  final singlePicker = ImagePicker();
  final multiPicker = ImagePicker();
  List<XFile> images = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                //key: formKey,
                child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('You Can Add Phoots Here'),
                        Row(
                          children: <Widget>[
                            Expanded(child: Container(
                              height: 100,
                            ))
                          ],
                        ),
                      ],
                    )
                ),
              ),
              Text('You Can Add Phoots Here'),
              SizedBox(
                height: 20,
              ),

              Expanded(
                child: InkWell(
                  onTap: () {
                    getMultiImages();
                  },
                  child: GridView.builder(
                      itemCount: images.isEmpty ? 1 : images.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.5))),
                          child: images.isEmpty
                              ? Icon(
                            CupertinoIcons.camera,
                            color: Colors.grey.withOpacity(0.5),
                          )
                              : Image.file(
                            File(images[index].path),
                            fit: BoxFit.cover,
                          ))),
                ),
              ),
              Text('You Can Add Phoots Here'),
              Row(
                children: <Widget>[
                  Expanded(child: Container(
                    height: 100,
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getSingleImage() async {
    final pickedImage =
    await singlePicker.getImage(source: (ImageSource.gallery));
    setState(() {
      if (pickedImage != null) {
        singleImage = File(pickedImage.path);
      } else {
        print('No Image Selected');
      }
    });
  }

  Future getMultiImages() async {
    final List<XFile> selectedImages = await multiPicker.pickMultiImage();
    setState(() {
      if (selectedImages.isNotEmpty) {
        images.addAll(selectedImages);
      } else {
        print('No Images Selected ');
      }
    });
  }*/
}