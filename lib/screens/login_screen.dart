import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import '../database/mysql.dart';
import 'home.dart';
import 'login_page.dart';


List<User> users = [];

class LoginScreen extends StatelessWidget {
  var emailContoller = TextEditingController();
  var passController = TextEditingController();

  late String email;
  late String password;

  late int flag = 0;




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 190.0
              ),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,

                ),
              ),
              SizedBox(
                height: 40.0
              ),
              TextFormField(
                controller: emailContoller,
                keyboardType: TextInputType.emailAddress, //Adds @ to the keyboard
                  onFieldSubmitted: (String value)
                  {
                    email = value;
                  },
                decoration: InputDecoration(
                  labelText: 'Email Adress',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.email,
                  ),


                )
              ),
              SizedBox(
                  height: 15.0
              ),
              TextFormField(
                controller: passController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,//Adds @ to the keyboard
                  onFieldSubmitted: (String value)
                  {
                      password = value;
                  },
                  onChanged: (String value)
                  {
                    print(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                    suffixIcon: Icon(
                      Icons.remove_red_eye
                    )


                  )
              ),
              SizedBox(
                  height: 20.0
              ),
              Container(
                width: double.infinity,
                child: MaterialButton(
                    onPressed: ()
                  {
                      for(var u in users){
                        if( u.password == passController.text && u.email == emailContoller.text){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)
                              {
                                flag = 1;
                                return MyHomePage(title: 'Carpooling Application',);

                              }
                              ));
                        }
                      }
                      if(flag == 0){
                        print("wrong password");
                      }

                    //Event upon login
                  },
                    color: Colors.deepPurpleAccent,
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.white
                    )
                  )
                ),
              ),
              SizedBox(
                  height: 11.0
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account ?',

                  ),
                  TextButton(
                      onPressed: ()
                      {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)
                        {

                          return Loginpage();

                        }
                        ));
                      },
                      child: Text(
                        'Register Now!'
                      )),
                  SizedBox(
                      height: 20.0
                  ),


                ],
              ),

            ],
          ),
        ),
      )
    );
  }

  // When notification icon is clicked
  void onNotication(){
    print('notfication clicked');
  }
  void onSearch(){
    print('Search clicked');
  }
}


