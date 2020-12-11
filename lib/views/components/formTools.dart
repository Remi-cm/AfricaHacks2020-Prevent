import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String emptyValidatorText;
  final TextEditingController controller;
  final Function onSavedFunc;
  final TextInputType keyboardType;
  final IconData icon;
  final Function validator;
  final Function onChangedFunc;

  const CustomTextField(
      {Key key,
      this.hintText,
      this.emptyValidatorText,
      @required this.controller,
      this.onSavedFunc,
      this.keyboardType,
      this.icon,
      this.validator,
      this.onChangedFunc});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Color(0xff039BE5),
      ),
      child: TextFormField(
        cursorColor: Colors.grey,
        style: TextStyle(color: Colors.grey),
        keyboardType: this.keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          hintText: this.hintText,
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.95),
              fontWeight: FontWeight.w600),
          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0),
          fillColor: Colors.grey.withOpacity(0.1),
          filled: true,
          prefixIcon: Icon(this.icon, color: Colors.grey.withOpacity(0.7)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(50)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(50)),
        ),
        validator: this.validator,
        controller: controller,
        onChanged: this.onChangedFunc,
        onSaved: this.onSavedFunc,
      ),
    );
  }
}

class CustomPasswordTextField extends StatefulWidget {
  final String hintText;
  final String emptyValidatorText;
  final TextEditingController controller;
  final Function onSavedFunc;
  final TextInputType keyboardType;
  final IconData icon;
  final Function validator;
  final Function onChangedFunc;

  const CustomPasswordTextField(
      {Key key,
      this.hintText,
      this.emptyValidatorText,
      @required this.controller,
      this.onSavedFunc,
      this.keyboardType,
      this.icon,
      this.validator,
      this.onChangedFunc});

  @override
  _CustomPasswordTextFieldState createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Color(0xff039BE5),
      ),
      child: TextFormField(
        cursorColor: Colors.grey,
        obscureText: passwordVisible,
        style: TextStyle(color: Colors.grey),
        keyboardType: this.widget.keyboardType,
        decoration: InputDecoration(
          hintText: this.widget.hintText,
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.95),
              fontWeight: FontWeight.w600),
          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0),
          fillColor: Colors.grey.withOpacity(0.1),
          filled: true,
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Icon(this.widget.icon, color: Colors.grey.withOpacity(0.7)),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).textSelectionColor),
              borderRadius: BorderRadius.circular(50)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(50)),
          suffixIcon: IconButton(
            enableFeedback: false,
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey.withOpacity(0.7),
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
        ),
        validator: this.widget.validator,
        controller: widget.controller,
        onChanged: this.widget.onChangedFunc,
        onSaved: this.widget.onSavedFunc,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final Color textColor;
  final String text;
  final Color color;

  const CustomButton(
      {@required this.onPressed,
      @required this.text,
      @required this.textColor,
      @required this.color});
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width,
      child: FlatButton(
        onPressed: this.onPressed,
        textColor: this.textColor,
        color: this.color,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(this.text,
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class CustomPriceTextField extends StatelessWidget {
  final String hintText;
  final String emptyValidatorText;
  final TextEditingController controller;
  final Function onSavedFunc;
  final TextInputType keyboardType;
  final IconData icon;
  final Function validator;
  final Function onChangedFunc;

  const CustomPriceTextField(
      {Key key,
      this.hintText,
      this.emptyValidatorText,
      @required this.controller,
      this.onSavedFunc,
      this.keyboardType,
      this.icon,
      this.validator,
      this.onChangedFunc});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Color(0xff039BE5),
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        cursorColor: Colors.grey,
        style: TextStyle(color: Colors.grey),
        keyboardType: this.keyboardType,
        autocorrect: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          hintText: this.hintText,
          hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.95),
              fontWeight: FontWeight.w600),
          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0),
          fillColor: Colors.grey.withOpacity(0.1),
          filled: true,
          prefixIcon: Icon(this.icon, color: Colors.grey.withOpacity(0.7)),
          suffix: Text("XAF"),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(50)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(50)),
        ),
        validator: this.validator,
        controller: controller,
        onChanged: this.onChangedFunc,
        onSaved: this.onSavedFunc,
      ),
    );
  }
}