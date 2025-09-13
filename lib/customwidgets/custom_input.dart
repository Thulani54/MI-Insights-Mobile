import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_insights/constants/Constants.dart';

class CustomInput extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  CustomInput(
      {required this.hintText,
      required this.onChanged,
      required this.onSubmitted,
      required this.focusNode,
      required this.textInputAction,
      required this.isPasswordField,
      this.controller});

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = widget.isPasswordField;

    return Container(
        decoration: MediaQuery.of(context).size.width < 500
            ? BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36)),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.75),
                ),
              )
            : MediaQuery.of(context).size.width < 1100 &&
                    MediaQuery.of(context).size.width < 1100
                ? BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.35),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                    color: Color(0xffFFFFFF),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                    color: Color(0xffFFFFFF),
                  ),
        padding: EdgeInsets.only(
            left: 2,
            right: 2,
            top: _isPasswordField == true ? 2 : 0,
            bottom: _isPasswordField == true ? 10 : 0),
        width: MediaQuery.of(context).size.width,
        height: 45,
        child: TextField(
          obscureText: (_isPasswordField == true && _isPasswordHidden == true)
              ? true
              : false,
          onChanged: widget.onChanged,
          controller: widget.controller,
          focusNode: widget.focusNode,
          textCapitalization: TextCapitalization.sentences,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: GoogleFonts.nunito(
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
              ),
            ),
            contentPadding: EdgeInsets.only(left: 16, top: 0.0, bottom: 5),
            suffixIcon: _isPasswordField == true
                ? IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Constants.ctaColorLight,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                        print("_isPasswordHidden ${_isPasswordHidden}");
                      });
                    },
                  )
                : null,
          ),
          style: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 13.5,
                color: Colors.black,
                letterSpacing: 0,
                fontWeight: FontWeight.w500),
          ),
        ));
  }
}

class CustomInputTransparent extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;
  final bool? integersOnly;
  CustomInputTransparent(
      {required this.hintText,
      required this.onChanged,
      required this.onSubmitted,
      required this.focusNode,
      required this.textInputAction,
      required this.isPasswordField,
      this.controller,
      this.prefix,
      this.suffix,
      this.maxLines,
      this.integersOnly});

  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField;
    return Container(
      padding: EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 0),
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: TextField(
        obscureText: _isPasswordField,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        controller: controller,
        maxLines: maxLines,
        textInputAction: textInputAction,
/*        validator: (val) {
            return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(val!)
                ? null
                : "Please Enter Correct Email";
          },*/
        inputFormatters: integersOnly == true
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ]
            : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          prefixIcon: prefix,
          suffixIcon: suffix,
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          hintStyle: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 13.5,
                color: Colors.grey,
                letterSpacing: 0,
                fontWeight: FontWeight.w500),
          ),
          contentPadding: EdgeInsets.only(left: 16, top: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)),
            borderRadius: BorderRadius.circular(36),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffED7D32)),
            borderRadius: BorderRadius.circular(360),
          ),
        ),
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13.5),
      ),
    );
  }
}

class CustomInputLine extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  CustomInputLine(
      {required this.hintText,
      required this.onChanged,
      required this.onSubmitted,
      required this.focusNode,
      required this.textInputAction,
      required this.isPasswordField,
      this.controller});

  @override
  State<CustomInputLine> createState() => _CustomInputLineState();
}

class _CustomInputLineState extends State<CustomInputLine> {
  bool _isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = widget.isPasswordField;

    return Container(
        decoration: MediaQuery.of(context).size.width < 500
            ? BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36)),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.55),
                ),
              )
            : MediaQuery.of(context).size.width < 1100 &&
                    MediaQuery.of(context).size.width < 1100
                ? BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36)),
                    color: Color(0xffFFFFFF),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                    color: Color(0xffFFFFFF),
                  ),
        padding: EdgeInsets.only(left: 2, right: 2, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        height: 45,
        child: TextField(
          obscureText: (_isPasswordField == true && _isPasswordHidden == true)
              ? true
              : false,
          onChanged: widget.onChanged,
          controller: widget.controller,
          focusNode: widget.focusNode,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white), // Set initial border color
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Constants
                      .ctaColorLight), // Set border color when selected
            ),
            hintText: widget.hintText,
            hintStyle: GoogleFonts.nunito(
              textStyle: TextStyle(
                fontSize: 15,
                color: Colors.white70,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
              ),
            ),
            contentPadding: EdgeInsets.only(left: 16.0, top: 6.0),
            suffixIcon: _isPasswordField == true
                ? IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Color(0xffED7D32),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                        print("_isPasswordHidden ${_isPasswordHidden}");
                      });
                    },
                  )
                : null,
          ),
          style: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 13.5,
                color: Colors.white,
                letterSpacing: 0,
                fontWeight: FontWeight.w500),
          ),
        ));
  }
}

class CustomInputSquare extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final bool? integersOnly;
  CustomInputSquare(
      {required this.hintText,
      required this.onChanged,
      required this.onSubmitted,
      required this.focusNode,
      required this.textInputAction,
      required this.isPasswordField,
      this.controller,
      this.integersOnly});

  @override
  State<CustomInputSquare> createState() => _CustomInputSquareState();
}

class _CustomInputSquareState extends State<CustomInputSquare> {
  bool _isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = widget.isPasswordField;

    return Container(
        decoration: MediaQuery.of(context).size.width < 500
            ? BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.75),
                ),
              )
            : MediaQuery.of(context).size.width < 1100 &&
                    MediaQuery.of(context).size.width < 1100
                ? BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.35),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                    color: Color(0xffFFFFFF),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                    color: Color(0xffFFFFFF),
                  ),
        padding: EdgeInsets.only(
            left: 2,
            right: 2,
            top: _isPasswordField == true ? 2 : 0,
            bottom: _isPasswordField == true ? 10 : 0),
        width: MediaQuery.of(context).size.width,
        height: 45,
        child: TextField(
          obscureText: (_isPasswordField == true && _isPasswordHidden == true)
              ? true
              : false,
          onChanged: widget.onChanged,
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType:
              widget.integersOnly == false ? null : TextInputType.number,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: GoogleFonts.nunito(
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
              ),
            ),
            contentPadding: EdgeInsets.only(left: 16.0, bottom: 9.0),
            suffixIcon: _isPasswordField == true
                ? IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Constants.ctaColorLight,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                        print("_isPasswordHidden ${_isPasswordHidden}");
                      });
                    },
                  )
                : null,
          ),
          style: GoogleFonts.inter(
            textStyle: TextStyle(
                fontSize: 13.5,
                color: Colors.black,
                letterSpacing: 0,
                fontWeight: FontWeight.w500),
          ),
        ));
  }
}

class CustomInputTransparent4 extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final Widget? prefix;
  Widget? suffix;
  final int? maxLines;
  final bool? integersOnly;
  final String? labelText;
  final bool? isEditable;

  CustomInputTransparent4({
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
    required this.focusNode,
    required this.textInputAction,
    required this.isPasswordField,
    this.controller,
    this.prefix,
    this.maxLines,
    this.suffix,
    this.integersOnly,
    this.labelText,
    this.isEditable,
  });

  @override
  _CustomInputTransparent4State createState() =>
      _CustomInputTransparent4State();
}

class CustomInputTransparentID2 extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final Function(bool) onIsSAIDChanged;
  final FocusNode focusNode;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool isPasswordField;

  CustomInputTransparentID2({
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
    required this.onIsSAIDChanged,
    required this.focusNode,
    this.controller,
    required this.textInputAction,
    required this.isPasswordField,
  });

  @override
  _CustomInputTransparentID2State createState() =>
      _CustomInputTransparentID2State();
}

class _CustomInputTransparentID2State extends State<CustomInputTransparentID2> {
  bool isSAID = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.55)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                textInputAction: widget.textInputAction,
                obscureText: widget.isPasswordField,
                inputFormatters: isSAID
                    ? [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(13),
                      ]
                    : null,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 4),
                  border: InputBorder.none,
                  hintText: isSAID ? "ID Number" : "Passport Number",
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'YuGothic',
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'YuGothic',
                ),
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              setState(() {
                isSAID = !isSAID;
                widget.onIsSAIDChanged(isSAID);
              });
            },
            child: Container(
              height: 46,
              width: 74,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                color:
                    isSAID ? Constants.ftaColorLight : Constants.ctaColorLight,
              ),
              child: Center(
                child: Text(
                  isSAID ? "SA ID" : "Passport",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomInputTransparent3 extends StatefulWidget {
  final bool? allow_editing;
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final Widget? prefix;
  Widget? suffix;
  final int? maxLines;
  final int? maxInputs; // ✅ New optional parameter for maximum input length
  final bool? integersOnly;
  final bool? isName; // ✅ New property for name validation

  CustomInputTransparent3({
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
    required this.focusNode,
    required this.textInputAction,
    required this.isPasswordField,
    this.controller,
    this.prefix,
    this.maxLines,
    this.maxInputs, // ✅ Added to constructor
    this.suffix,
    this.integersOnly,
    this.allow_editing,
    this.isName = false, // ✅ Default to false
  });

  @override
  _CustomInputTransparent3State createState() =>
      _CustomInputTransparent3State();
}

class _CustomInputTransparent3State extends State<CustomInputTransparent3> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 0),
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: TextField(
        obscureText: widget.isPasswordField && !_isPasswordVisible,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        enabled: widget.allow_editing,
        onSubmitted: widget.onSubmitted,
        controller: widget.controller,
        maxLines: 1,
        maxLength: widget.maxInputs, // ✅ Added maxInputs implementation
        textInputAction: widget.textInputAction,

        // ✅ Apply input validation
        inputFormatters: widget.isName == true
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]")),
              ]
            : widget.integersOnly == true
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9]*')),
                  ]
                : null,

        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          counterText: widget.maxInputs != null
              ? null
              : "", // ✅ Hide counter if maxInputs is null, show if not null
          prefixIcon: widget.prefix,
          suffixIcon: widget.suffix != null
              ? widget.suffix
              : widget.isPasswordField
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
          filled: true,
          fillColor: Colors.transparent,
          hintStyle: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              letterSpacing: 0,
              fontWeight: FontWeight.w300,
              fontFamily: 'YuGothic',
            ),
          ),
          contentPadding: EdgeInsets.only(left: 16, top: 16),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.35)),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.55)),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffED7D32)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          fontFamily: 'YuGothic',
        ),
      ),
    );
  }
}

class _CustomInputTransparent4State extends State<CustomInputTransparent4> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 0),
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: TextField(
        enabled: widget.isEditable ?? true,
        obscureText: widget.isPasswordField && !_isPasswordVisible,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        controller: widget.controller,
        maxLines: 1,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.integersOnly == true
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ]
            : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          labelText: widget.labelText,
          prefixIcon: widget.prefix,
          suffixIcon: widget.suffix != null
              ? widget.suffix
              : widget.isPasswordField
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
          filled: true,
          fillColor: Colors.transparent,
          hintStyle: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: 13,
              color: Colors.black38,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
              fontFamily: 'YuGothic',
            ),
          ),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
          ),
          contentPadding: EdgeInsets.only(left: 16, top: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.55)),
            borderRadius: BorderRadius.circular(36),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.55)),
            borderRadius: BorderRadius.circular(36),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffED7D32)),
            borderRadius: BorderRadius.circular(36),
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          fontFamily: 'YuGothic',
        ),
      ),
    );
  }
}

class CustomInput2 extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final Widget? prefix;
  final Widget? suffix;

  CustomInput2(
      {super.key,
      required this.hintText,
      required this.onChanged,
      required this.onSubmitted,
      required this.focusNode,
      required this.textInputAction,
      required this.isPasswordField,
      this.controller,
      this.prefix,
      this.suffix});

  @override
  Widget build(BuildContext context) {
    //bool isPasswordField = isPasswordField1;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4)),
      ),
      padding: const EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 8),
      width: MediaQuery.of(context).size.width,
      height: 64,
      child: TextField(
        obscureText: isPasswordField,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        controller: controller,
        textInputAction: textInputAction,
/*        validator: (val) {
            return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(val!)
                ? null
                : "Please Enter Correct Email";
          },*/
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          prefixIcon: prefix,
          suffixIcon: suffix,
          hintStyle: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 12.5,
              color: Colors.grey,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
              fontFamily: 'YuGothic',
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.55)),
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Constants.ctaColorLight),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
            fontSize: 13.5),
      ),
    );
  }
}

class CustomInputTransparent1 extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;
  final bool? integersOnly;
  final bool? isEditable;

  CustomInputTransparent1({
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
    required this.focusNode,
    required this.textInputAction,
    required this.isPasswordField,
    this.controller,
    this.prefix,
    this.suffix,
    this.maxLines,
    this.integersOnly,
    this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField;
    return Container(
      padding: EdgeInsets.only(left: 2, right: 2, top: 8, bottom: 0),
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: TextField(
        obscureText: _isPasswordField,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        controller: controller,
        maxLines: 1,
        enabled: isEditable ?? true,
        textInputAction: textInputAction,
/*        validator: (val) {
            return RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(val!)
                ? null
                : "Please Enter Correct Email";
          },*/
        inputFormatters: integersOnly == true
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ]
            : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          prefixIcon: prefix,
          suffixIcon: suffix,
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          hintStyle: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: 13.5,
              color: Colors.grey,
              letterSpacing: 0,
              fontWeight: FontWeight.w300,
              fontFamily: 'YuGothic',
            ),
          ),
          contentPadding: EdgeInsets.only(left: 16, top: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(360),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.05)),
            borderRadius: BorderRadius.circular(360),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffED7D32)),
            borderRadius: BorderRadius.circular(360),
          ),
        ),
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'YuGothic',
            fontSize: 13.5),
      ),
    );
  }
}
