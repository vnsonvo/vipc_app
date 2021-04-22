import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/controller/signup/signup_controller.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends StateMVC {
  _AddUserState() : super(SignupController()) {
    _con = SignupController.con;
  }

  SignupController _con;

  List<String> types = ["Manager", "Advisor"];

  @override
  void initState() {
    _con.clean();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Center(
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(15),
            child: Form(
              key: _con.formKey,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Add User",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildEmployeeIdTextField(),
                  SizedBox(height: 15),
                  _buildEmailTextField(),
                  SizedBox(height: 15),
                  _buildUserFullNameTextField(),
                  SizedBox(height: 15),
                  _buildUserTypeDropdownList(),
                  SizedBox(height: 15),
                  (_con.isAdvisor)
                      ? _buildAssignUserDropdownList()
                      : SizedBox(),
                  _buildUserPasswordField(),
                  SizedBox(height: 15),
                  _buildUserConfirmPasswordField(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCancelBtn(),
                      _buildSaveBtn(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeIdTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Employee ID',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter employee ID.';
              }
              return null;
            },
            controller: _con.empIdController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              helperText: '',
              errorStyle: TextStyle(
                color: Colors.orange[400],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 11, 0, 7),
              hintText: "Enter Employee ID",
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty || !value.contains('@')) {
                return 'Please enter valid email address.';
              }
              return null;
            },
            controller: _con.emailController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              helperText: '',
              errorBorder: InputBorder.none,
              errorStyle: TextStyle(
                color: Colors.orange[400],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 11, 0, 7),
              hintText: "Enter Email",
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserFullNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Full Name',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter full name.';
              }
              return null;
            },
            controller: _con.fullNameController,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              helperText: '',
              errorStyle: TextStyle(
                color: Colors.orange[400],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 11, 0, 7),
              hintText: "Enter Full Name",
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserTypeDropdownList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Select User Type",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 63.0,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              helperText: '',
              errorStyle: TextStyle(
                color: Colors.orange[400],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            validator: (value) {
              if (value == null || value == 'Select') {
                return 'Please select an user type.';
              }
              return null;
            },
            hint: Container(
              child: Text(
                "Select",
                style: TextStyle(color: Colors.white),
              ),
            ),
            isExpanded: true,
            iconEnabledColor: Colors.white,
            value: _con.selectedType,
            onChanged: (String value) {
              if (value == 'Advisor') {
                setState(() {
                  _con.isAdvisor = true;
                  _con.selectedType = value;
                });
              } else {
                setState(() {
                  _con.isAdvisor = false;
                  _con.selectedType = value;
                });
              }
            },
            items: types.map((String useType) {
              return DropdownMenuItem(
                value: useType,
                child: Row(
                  children: <Widget>[
                    Text(
                      useType,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAssignUserDropdownList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Select Manager to assign",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 63.0,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              helperText: '',
              errorStyle: TextStyle(
                color: Colors.orange[400],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            validator: (value) {
              if (_con.managers.isEmpty) return null;
              if (value == null || value == 'Select') {
                return 'Please select a manager to assign.';
              }
              return null;
            },
            hint: Container(
              child: Text(
                "Select",
                style: TextStyle(color: Colors.white),
              ),
            ),
            isExpanded: true,
            iconEnabledColor: Colors.white,
            value: _con.selectedManager,
            onChanged: (String value) {
              setState(() {
                _con.selectedManager = value;
              });
              FocusScope.of(context).unfocus();
            },
            items: _con.managers.map((String selectedManager) {
              return DropdownMenuItem(
                value: selectedManager,
                child: Row(
                  children: <Widget>[
                    Text(
                      selectedManager,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildUserPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Enter Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          padding: EdgeInsets.fromLTRB(15.0, 8, 0, 7),
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            validator: (value) {
              if (value.isEmpty || value.length < 8) {
                return 'Please enter password with at least 8 characters long.';
              }
              return null;
            },
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              errorStyle: TextStyle(
                color: Colors.orange[400],
                height: 0.1,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              hintText: 'Enter Password',
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
              suffixIcon: IconButton(
                padding: const EdgeInsets.all(5),
                icon: Icon(
                  _con.passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _con.passwordVisible = !_con.passwordVisible;
                  });
                },
              ),
            ),
            obscureText: !_con.passwordVisible,
            controller: _con.userPwdController,
          ),
        ),
      ],
    );
  }

  Widget _buildUserConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          padding: EdgeInsets.fromLTRB(15.0, 8, 0, 7),
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            validator: (value) {
              if (value.isEmpty || value != _con.userPwdController.text) {
                return 'Please enter password identical with password above.';
              }
              return null;
            },
            decoration: InputDecoration(
              errorBorder: InputBorder.none,
              errorStyle: TextStyle(
                color: Colors.orange[400],
                height: 0.1,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              hintText: 'Enter Confirm Password',
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
              suffixIcon: IconButton(
                padding: const EdgeInsets.all(5),
                icon: Icon(
                  _con.passwordVisible2
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _con.passwordVisible2 = !_con.passwordVisible2;
                  });
                },
              ),
            ),
            obscureText: !_con.passwordVisible2,
            controller: _con.userPwdController2,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: const EdgeInsets.only(
            left: 60.0,
            top: 15.0,
            right: 60.0,
            bottom: 15.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Colors.amber[300],
        ),
        onPressed: () async {
          await _con.signupUser(context);
          if (_con.signUpSuccess)
            showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                title: new Text("VIPC Message"),
                content: new Text("Successfully added user!"),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
        },
        child: _con.isLoading
            ? SizedBox(
                height: 21,
                width: 36,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : Text(
                'Save',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildCancelBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: const EdgeInsets.only(
            left: 46.0,
            top: 15.0,
            right: 46.0,
            bottom: 15.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Colors.amber[300],
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
