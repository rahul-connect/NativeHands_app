import 'package:flutter/material.dart';
import '../../model/user.dart';


class ContactForm extends StatefulWidget {
  final User user;
  ContactForm({@required this.user});

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.orangeAccent,
        title: Text("Contact Us"),
        centerTitle: true,
      ),
      body:  SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(  
        key: _formKey,  
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,  
          children: <Widget>[  
            TextFormField(  
                decoration: const InputDecoration(  
                  icon: const Icon(Icons.person),  
                  hintText: 'Enter your name',  
                  labelText: 'Name',  
                ),  
                validator: (value) {  
       if (value.isEmpty) {  
             return '*field requred';  
       }  
       return null;  
},  
            ),  
            TextFormField(  
              keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(  
                  icon: const Icon(Icons.email),  
                  hintText: 'Enter an email address',  
                  labelText: 'Email ID',  
                ),  
                validator: (value) {  
       if (value.isEmpty) {  
             return '*field requred';  
       }  
       return null;  
},  
            ),  
             TextFormField(  
               keyboardType: TextInputType.number,
                decoration: const InputDecoration(  
                  icon: const Icon(Icons.phone),  
                  hintText: 'Enter a phone number',  
                  labelText: 'Phone',  
                ),  
                validator: (value) {  
       if (value.isEmpty) {  
             return '*field requred';  
       }  
       return null;  
},  
            ),  

            TextFormField(
              validator: (value) {  
       if (value.isEmpty) {  
             return '*field requred';  
       }  
       return null;  
},  
               keyboardType: TextInputType.multiline,
               
             
             maxLines: 8,
             minLines: 5,
             
              decoration: const InputDecoration(  
                  labelText: 'Tell us more',  
                ),  

            ),
          
            new Container(  
              width: double.infinity,
              margin: EdgeInsets.all(30),
                  child: new RaisedButton(  
                     padding: const EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: const Text('Submit'),  
                      onPressed: (){
                             if (_formKey.currentState.validate()) {  
                               
                
                  }  
                      },  
                  )),  
          ],  
        ),  
    ),
              ),
      ),

      
    );
  }
}