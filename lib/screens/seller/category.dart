import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user.dart';
import './view_categories.dart';
import '../../bloc/categoryBloc/export_category_bloc.dart';
import 'alert_notification.dart';
import 'drawer.dart';

class CategoryScreen extends StatefulWidget {
  final User user;
  CategoryScreen({@required this.user});
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController _titleController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _titleController.dispose();
    _scaffoldKey.currentState.dispose();
    super.dispose();
  }

  @override
  void initState() { 
    newOrderNotification(context);
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    var categoryBloc = BlocProvider.of<CategoryBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: SellerDrawer(user: widget.user,),
      appBar: AppBar(
        title: Text("Categories"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Add a Category",
                style: TextStyle(fontSize: 25.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Title"),
              ),
              SizedBox(
                height: 20.0,
              ),
              BlocListener<CategoryBloc, CategoryState>(
                listener: (context, state) {
                  if (state is AddedSuccess) {
                    _titleController.text = '';
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Category Added Successfully !'),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                  if (state is CategoryInitial) {
                    return RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 60.0,vertical: 10.0),
                        child: Text("Submit",style: TextStyle(fontSize: 20.0),),
                        color: Colors.teal,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        onPressed: () {
                          if (_titleController.text.trim() != '') {
                            categoryBloc
                                .add(AddCategory(title: _titleController.text,userId: widget.user.userId));
                          }
                        });
                  } else if (state is AddingCategory) {
                    return CircularProgressIndicator();
                  }
                }),
              ),
              SizedBox(height: 30.0,),
              RaisedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AllCategories()));
              },child: Text("View all"),
               color: Colors.orange,
               textColor: Colors.white,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(20.0)
               ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
