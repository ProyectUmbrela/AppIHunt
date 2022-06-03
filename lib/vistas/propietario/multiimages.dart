/*
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

 */

/*
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

  }
}
*/