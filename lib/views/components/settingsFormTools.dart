import 'package:Prevent/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSettingsTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String emptyValidatorText;
  final TextEditingController controller;
  final Function onSavedFunc;
  final TextInputType keyboardType;
  final FocusNode focusNode;
  final IconData icon;
  final Function validator;
  final Function onChangedFunc;

  const CustomSettingsTextField(
      {Key key,
      this.labelText,
      this.hintText,
      this.emptyValidatorText,
      @required this.controller,
      this.onSavedFunc,
      this.keyboardType,
      this.focusNode,
      this.icon,
      this.validator,
      this.onChangedFunc});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          this.labelText,
          style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5.0),
        TextFormField(
          cursorColor: Colors.grey,
          style: TextStyle(color: themeProvider.mode == ThemeMode.light ? Colors.grey : Colors.grey[50]),
          keyboardType: this.keyboardType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15),
            hintText: this.hintText,
            hintStyle: TextStyle(
                //color: Colors.grey.withOpacity(0.95),
                fontWeight: FontWeight.w600),
            labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0),
            fillColor: Colors.grey.withOpacity(0.05),
            filled: true,
            prefixIcon: Icon(this.icon, color: Colors.grey.withOpacity(0.7)),
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 4),
                borderRadius: BorderRadius.circular(5)),
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.5), width: 4),
                borderRadius: BorderRadius.circular(5)),
          ),
          validator: this.validator,
          controller: controller,
          onChanged: this.onChangedFunc,
          onSaved: this.onSavedFunc,
          focusNode: this.focusNode,
        ),
      ],
    );
  }
}

class CustomTextAreaField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String emptyValidatorText;
  final TextEditingController controller;
  final Function onSavedFunc;
  final TextInputType keyboardType;
  final int minLines;
  final int maxLines;
  final IconData icon;
  final FocusNode focusNode;
  final Function validator;
  final Function onChangedFunc;

  const CustomTextAreaField(
      {Key key,
      this.labelText,
      this.hintText,
      this.emptyValidatorText,
      @required this.controller,
      this.onSavedFunc,
      this.keyboardType,
      this.icon,
      this.minLines,
      this.maxLines,
      this.focusNode,
      this.validator,
      this.onChangedFunc});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    return Theme(
      data: ThemeData(
        primaryColor: Color(0xff039BE5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            this.labelText,
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5.0),
          TextFormField(
            scrollPhysics: BouncingScrollPhysics(),
            minLines: this.minLines,
            maxLines: this.maxLines,
            cursorColor: Colors.grey,
            style: TextStyle(color: themeProvider.mode == ThemeMode.light ? Colors.grey : Colors.grey[50]),
            keyboardType: this.keyboardType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(15),
              hintText: this.hintText,
              hintStyle: TextStyle(
                  //color: Colors.grey.withOpacity(0.95),
                  fontWeight: FontWeight.w600),
              labelStyle:
                  TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0),
              fillColor: Colors.grey.withOpacity(0.07),
              filled: true,
              prefixIcon: Icon(this.icon, color: Colors.grey.withOpacity(0.7)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 4),
                  borderRadius: BorderRadius.circular(5)),
              enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.grey.withOpacity(0.5), width: 4),
                  borderRadius: BorderRadius.circular(5)),
            ),
            validator: this.validator,
            controller: controller,
            onChanged: this.onChangedFunc,
            onSaved: this.onSavedFunc,
            focusNode: this.focusNode,
          ),
        ],
      ),
    );
  }
}

class CustomSettingsButton extends StatelessWidget {
  final Function onPressed;
  final Color textColor;
  final String text;
  final Color color;

  const CustomSettingsButton(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(this.text,
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
