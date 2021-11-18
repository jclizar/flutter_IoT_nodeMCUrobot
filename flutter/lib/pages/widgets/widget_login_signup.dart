import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

// image to svg: https://www.online-convert.com/pt/resultado#j=1d127c31-ec23-4098-90c8-717f27843df5
// how to import svg: https://pub.dev/documentation/flutter_svg/latest/

class ModelLoginSignup extends StatelessWidget {
  ///ATRIBUTOS
  ///Os atributos serão utilizados para receber dados
  ///no momento da criação do widget
  /// obrigatórios
  final Color logoColor;
  final Color backgroundColor;
  final String logoSVGPath = 'lib/images/logo.svg';
  final Widget form;

  ///CONSTRUTOR
  const ModelLoginSignup(this.logoColor, this.backgroundColor, this.form,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.backgroundColor,
      width: 100.w,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8.h),
                child: SvgPicture.asset(
                  this.logoSVGPath,
                  color: this.logoColor,
                  semanticsLabel: 'logo',
                  width: 68.w,
                ),
              ),
            ],
          ),
          Row(
            children: [
              this.form,
            ],
          ),
        ],
      ),
    );
  }
}
