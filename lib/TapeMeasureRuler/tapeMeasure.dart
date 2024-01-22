import 'package:flutter/material.dart';

class TapeMeasureCustomWidget extends StatefulWidget {
  final double min;
  final double max;
  final double step;
  final  double value;
  final String unit;
  final void Function(double value) onChanged;
  const TapeMeasureCustomWidget({super.key, required this.min, required this.max, required this.step, required this.value, required this.unit, required this.onChanged});

  @override
  State<TapeMeasureCustomWidget> createState() => _TapeMeasureCustomWidgetState();
}

class _TapeMeasureCustomWidgetState extends State<TapeMeasureCustomWidget> {
  double  value=0.0;
  @override
  void initState() {
    // TODO: implement initState
    value=widget.value;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (val){

value =value -val.delta.dx;
if(value < widget.min)
  {
    value=widget.min;
  }
if(value  > widget.max)
  {
    value=widget.max;
  }


widget.onChanged(value);
setState(() {

});
      },
      child: CustomPaint(
        painter: TapePainter(widget.min,widget.max, widget.step,value ,widget.unit),
        child: Container(),

      ),
    );
  }
}

class TapePainter  extends CustomPainter {
  double min;
  double max;
  double step;
  double value;
  String unit;

  TapePainter(this.min, this.max, this.step, this.value, this.unit);

  final Paint bgPainter = Paint()
    ..color = const Color(0xFFBDCB74)
    ..style = PaintingStyle.fill;

  final Paint borderPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;
  final Paint indicatorPaint = Paint()
    ..color = Colors.red // Customize marker color
    ..style = PaintingStyle.stroke
  ..strokeWidth=2.0;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final bgRect = Offset.zero & size;

    ///main green container
    canvas.drawRect(bgRect, bgPainter);

    ///main black  stroke rectangle

    canvas.drawRect(bgRect, borderPaint);
    final innerRect = bgRect.deflate(5);
    canvas.drawRect(innerRect, borderPaint);

    ///marker
    ///
// Draw custom marker at the current value
///for making rect inner inside
    canvas.clipRect(innerRect);
drawMarkers(canvas, innerRect);
drawValue(canvas,innerRect);
drawIndicator(canvas,innerRect);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  void drawMarkers(Canvas canvas, Rect innerRect) {
    double? range = max - min;
double  smallHeight=10;
    double  mediumHeight=15;
    double  largeHeight=20;

    double stepSize = innerRect.width / range!;
double  offsetToIndicator=innerRect.width/2- (value-min)*stepSize;

    for (double i = min!; i <= max!; i += step) {
      double x = innerRect.left + (i - min!) * stepSize+offsetToIndicator;
if(i%10==0)
  {
    canvas.drawLine(
        Offset(x, innerRect.top), Offset(x, innerRect.top+largeHeight), borderPaint);

    TextSpan span = TextSpan(

        style: const TextStyle(color: Colors.black, fontSize: 10),
        text: '$i'); //


    TextPainter tp = TextPainter(text: span,

        textAlign: TextAlign.center,

        textDirection: TextDirection.ltr);

    tp.layout();

    tp.paint(canvas, Offset(x - tp.width / 2, innerRect.top + largeHeight));

  }
else if(i%5==0)
  {
    canvas.drawLine(
        Offset(x, innerRect.top), Offset(x, innerRect.top+mediumHeight), borderPaint);
  }
else
  {
    canvas.drawLine(
        Offset(x, innerRect.top), Offset(x, innerRect.top+smallHeight), borderPaint);
  }

    }
  }

  void drawValue(Canvas canvas, Rect innerRect) {
    final c=innerRect.bottomCenter;

    TextSpan span = TextSpan(

        style: const TextStyle(color: Color(0xff30D33FF), fontSize: 16),
        text: '${value.toInt()} $unit');

    TextPainter tp = TextPainter(text: span,

        textAlign: TextAlign.center,

        textDirection: TextDirection.ltr);

    tp.layout();

    tp.paint(canvas, Offset(c.dx - tp.width / 2,c.dy-tp.height));

  }

  void drawIndicator(Canvas canvas, Rect innerRect) {
    final c1= innerRect.topCenter;
    final c2= innerRect.center;
    
    canvas.drawLine(c1, c2, indicatorPaint);
    
  }
}
