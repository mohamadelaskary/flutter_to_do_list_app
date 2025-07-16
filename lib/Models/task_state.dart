import 'package:equatable/equatable.dart';
import 'package:to_do_list/Models/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override List<Object> get props => [];
}

class TaskInitial extends TaskState{}

class TasksLoaded extends TaskState{
  final List<Task> tasksList;
  const TasksLoaded(this.tasksList);
  @override
  List<Object> get props => [tasksList];
}