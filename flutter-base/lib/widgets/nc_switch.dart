import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ncflutter/common/nc_colors.dart';
import 'package:ncflutter/common/screens/unit_extension.dart';
import 'package:ncflutter/main.dart';

///
/// 牛客Switch widget
///
class NCSwitch extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;

  const NCSwitch({Key? key,required this.value, required this.onChanged}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NCSwitchState();
}

class NCSwitchState extends State<NCSwitch> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenInit(context);

    return GestureDetector(
      child: Container(
        width: 50.w,
        height: 28.w,
        child: Stack(
          children: <Widget>[
            Container(width: 50.w, height: 28.w, decoration: _getSwitchBgDecoration()),
            AnimatedPositioned(
              left: widget.value ? 22.0.w : 0.0.w,
              duration: Duration(milliseconds: 200),
              child: Container(
                decoration: ShapeDecoration(color: NCColor.whiteBg, shape: CircleBorder()),
                margin: EdgeInsets.all(2.w),
                width: 24.w,
                height: 24.w,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        widget.onChanged(!widget.value);
        setState(() {});
      },
    );
  }

  Decoration _getSwitchBgDecoration() {
    return widget.value
        ? ShapeDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF00DCC2), Color(0xFF00DC93)]),
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.all(Radius.circular(16.0.w))))
        : ShapeDecoration(
            color: NCColor.mainBgDeeper,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.all(Radius.circular(16.0.w))));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
