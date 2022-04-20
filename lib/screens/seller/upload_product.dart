import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../model/user.dart';
import '../../bloc/uploadBloc/export_upload_bloc.dart';
import 'drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:string_validator/string_validator.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';


class UploadProduct extends StatefulWidget {
  final User user;
  UploadProduct({@required this.user});
  @override
  _UploadProductState createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DropdownMenuItem> allCategories = [];
  String sellerId='';

  String selectedCategory="";
  Map<String, String> _paths = {};
  List<String> imageUrl = [];

  String title;
  String description;
  int price;

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';


  @override
  void initState() {
    fetchCategories();
    super.initState();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
       // enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#008080",
          actionBarTitle: "Select product image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );

      resultList.forEach((element)async{ 
    
         final filePath = await FlutterAbsolutePath.getAbsolutePath(element.identifier);
        
           File imageFile = File(filePath); 
           testCompressFile(imageFile,element.name);

      
      });
      
      

       setState(() {
      images = resultList;
      _error = error;
    });
   
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }



  Future<void> fetchCategories() async{
    sellerId = (await firebaseAuth.currentUser()).uid;

    var categories = await Firestore.instance.collection('category').getDocuments();
     for (var category in categories.documents) {

      allCategories.add(DropdownMenuItem(value: category.documentID, child: Text(category['title'])));
   }

   if(allCategories.length > 0){
      setState(() {
      selectedCategory = allCategories[0].value;
  });
   }
  }


      //  compress file
  Future<void> testCompressFile(File file,fileName) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 60,
    );


    Uint8List image = Uint8List.fromList(result);
  
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final filePath = File(path+'/'+fileName);
    File compressedImagePath = await filePath.writeAsBytes(image, flush: true, mode: FileMode.write);
     
    _paths.putIfAbsent(fileName, () => compressedImagePath.path);
    setState(() {
      
    });

  }

  @override
  Widget build(BuildContext context) {
    var uploadBloc = BlocProvider.of<UploadBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: SellerDrawer(user: widget.user,),
      appBar: AppBar(
        title: Text("Upload Product"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _paths.isNotEmpty
                      ? Text("${images.length.toString()} Images selected")
                      : Text("Select product images"),
                  _paths.isEmpty
                      ? RaisedButton(
                          onPressed: () {
                            loadAssets();
                          },
                          child: Text("Upload Images"))
                      : RaisedButton(
                          onPressed: () {
                            setState(() {
                              _paths.clear();
                              images.clear();
                            });
                          },
                          child: Text("Remove"),
                        ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Product Title",
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      title = value;
                    },
                  ),
                        SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      
                        children: <Widget>[
                          Text(
                            'Category :  ',
                            style: TextStyle(fontSize: 18,color: Colors.grey),
                          ),
                                 allCategories.isEmpty? CircularProgressIndicator(): DropdownButton(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                value: selectedCategory,
                                items: allCategories,
                                onChanged: (selectedValue) {
                                  setState(() {
                                    selectedCategory = selectedValue;
                                  });
                                }),

                        ],
                      ),
                  TextFormField(
                    onSaved: (value) {
                      description = value;
                    },
               
                    decoration: InputDecoration(labelText: "Description"),
                    keyboardType: TextInputType.multiline,
                    minLines: 3, 
                    maxLines: 10, 
                  ),
                     TextFormField(
                       keyboardType: TextInputType.number,
                    onSaved: (value) {
                      price = int.parse(value);
                      
                    },
                       validator: (value) {
                      if (value.isEmpty) {
                        return "Field is required";
                      }else if(!isNumeric(value)){
                        return "Enter a numeric value";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Price",
                      hintText: 'eg-80'
                    ),
        
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  BlocListener<UploadBloc,UploadState>(
                    listener: (context,state){
                      if(state is UploadSuccess){
                        _formKey.currentState.reset();
                        
                              _paths.clear();
                              images.clear();
                            
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Product Uploaded Successfully"),duration: Duration(seconds: 2),));
                         
                         Timer(Duration(seconds: 2), (){
                              Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider<UploadBloc>(create: (context)=>UploadBloc(),child: UploadProduct(user:widget.user)),
                              ),
                            );
                         });
                               
                      }
                    },
                                      child: BlocBuilder<UploadBloc,UploadState>(builder: (context,state){
                      if(state is UploadInitial){
                        return Container(
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate() && _paths.isNotEmpty) {
                            _formKey.currentState.save();
                     
                            uploadBloc.add(UploadButtonPressed(
                              title: title,
                              description: description,
                              paths: _paths,
                              category:selectedCategory,
                              price: price,
                              sellerId:sellerId,
                            ));
                          }else{
                            print("No Image Selected");
                          }
                        },
                        child: Text(
                          "UPLOAD",
                          style: TextStyle(fontSize: 20),
                        ),
                        color: Colors.green,
                        textColor: Colors.white,
                      ),
                    );
                      }else if(state is UploadingProduct){
                        return CircularProgressIndicator();
                      }
                    }),
                  ),
               
                  SizedBox(
                    height: 20.0,
                  ),
                  images.length>0
                      ? Wrap(
                          direction: Axis.horizontal,
                          children: images.map((image) {
                            return AssetThumb(
          asset: image,
          width: 120,
          height: 120,
        );
                          }).toList(),
                        )
                      : SizedBox.shrink(),
                ],
              )),
        ),
      ),
    );
  }
}
