import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:reactive_router/annotation/page_annotation.dart';
import 'package:source_gen/source_gen.dart';

///
/// * @ProjectName: flutter_routekit
/// * @Author: qifanxin
/// * @CreateDate: 2022/7/19 13:39
/// * @Description: 文件说明
///

class PageGenerator extends GeneratorForAnnotation<PageAnnotation> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element.kind == ElementKind.CLASS) {
      var classElement = element as ClassElement;
      classElement.metadata.forEach((annotation) {
        var annotation = element as ElementAnnotation;
      });
    }
    return null;
  }
}
