import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId:0)
class Task extends HiveObject{
  @HiveField(0)
  String taskDescription ="";
  @HiveField(1)
  bool   isCompleted = false;
  Task({this.taskDescription = "",this.isCompleted = false});
}