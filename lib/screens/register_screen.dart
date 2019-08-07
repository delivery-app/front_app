import 'package:flutter/material.dart';
import 'package:delivery_app/screens/login_screen.dart';
import 'package:delivery_app/screens/user_home_screen.dart';
import 'package:http/http.dart' as http;
import '../helpers/http.dart' as http_helper;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  var prefs;
  var _isIos;
  var _isLoading = false;
  var _email;
  var _password;
  var _id;
  var _name;
  var _phone;
  var _birthday;
  int _gender;
  var _errorMessage;
  var _formKey = GlobalKey<FormState>();
  String dropdownValue = 'User';
  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        body: Stack(
      children: <Widget>[
        _showBody(),
        _showCircularProgress(),
      ],
    ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/burger.png'),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Name',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
        onSaved: (value) => _name = value,
      ),
    );
  }

  Widget _showIdInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Id',
            icon: new Icon(
              Icons.perm_identity,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Id can\'t be empty' : null,
        onSaved: (value) => _id = value,
      ),
    );
  }

  Widget _showAditionalInput() {
    var birthday = Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: DateTimePickerFormField(
          inputType: InputType.date,
          format: DateFormat("yyyy-MM-dd"),
          editable: false,
          decoration: InputDecoration(
              icon: Icon(Icons.date_range),
              labelText: 'DateTime',
              hasFloatingPlaceholder: false),
          onSaved: (value) => _birthday = value.toString()),
    );

    var gender = new Row(
      children: <Widget>[
        new Icon(
          Icons.wc,
          color: Colors.grey,
        ),
        new Radio(
          value: 1,
          groupValue: _gender,
          onChanged: (int value) => setState(() => _gender = value),
        ),
        new Text(
          'Masculino',
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
        new Radio(
          value: 0,
          groupValue: _gender,
          onChanged: (int value) => setState(() => _gender = value),
        ),
        new Text(
          'Femenino',
          style: new TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
    if (dropdownValue == 'User') {
      return new Column(
        children: <Widget>[birthday, gender],
      );
    } else {
      return new Column(
        children: <Widget>[birthday],
      );
    }
  }

  Widget _showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Phone number',
            icon: new Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'Phone number can\'t be empty' : null,
        onSaved: (value) => _phone = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: new MaterialButton(
            elevation: 5.0,
            minWidth: 200.0,
            height: 42.0,
            color: Colors.green,
            child: new Text('Sign up',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit));
  }

  Widget _showSecondButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
        child: new MaterialButton(
            elevation: 5.0,
            minWidth: 200.0,
            height: 42.0,
            color: Colors.blue,
            child: new Text('Sign in',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _goToLogin));
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _selectType() {
    return new Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
        child: new InputDecorator(
            decoration: const InputDecoration(
              labelText: 'User Type',
            ),
            child: new DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['User', 'Deliverer']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList())));
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _selectType(),
              _showIdInput(),
              _showNameInput(),
              _showPhoneInput(),
              _showEmailInput(),
              _showPasswordInput(),
              _showAditionalInput(),
              _showPrimaryButton(),
              _showSecondButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    try {
      _formKey.currentState.save();

      Map<String, String> headers = {"Content-type": "application/json"};
      var real_gender;
      if (_gender == 1)
        real_gender = 'Masculino';
      else
        real_gender = 'Femenino';
      String json_data = '{"email": "' +
          _email +
          '", "password":"' +
          _password +
          '", "id_document":"' +
          _id +
          '","name": "' +
          _name +
          '","phone": "' +
          _phone +
          '","birthday":"' +
          _birthday +
          '", "gender":"' +
          real_gender +
          '"}';
      print(json_data);
      var response = http.post(
          Uri.http(http_helper.main_url, '/register/finalusr_register'),
          headers: headers,
          body: json_data);
      response.then((http.Response response) {
        print('RESPONSE: ${response.statusCode}');
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode >= 400) {
          setState(() {
            _errorMessage = "";
            _isLoading = false;
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Sign-up error"),
                content: new Text("Opps. Your user already exists :'c"),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          print('error');
          return;
        }
        Map mapRes = jsonDecode(response.body);
        print(mapRes['token']);
        _saveToken(jsonEncode(mapRes['token']));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserHome()),
        );
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        if (_isIos) {
          _errorMessage = e.details;
        } else
          _errorMessage = e.message;
      });
    }
  }

  _saveToken(token) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('jwt', token);
  }

  _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
