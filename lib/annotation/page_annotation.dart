import 'dart:core';

///
/// * @ProjectName: flutter_routekit
/// * @Author: qifanxin
/// * @CreateDate: 2022/7/19 11:47
/// * @Description: 文件说明
///
///
class PageAnnotation {
  final String name;

  final String? desc;

  final String path;

  const PageAnnotation({required this.name, required this.path, this.desc});
}
