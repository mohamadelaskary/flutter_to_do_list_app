import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list/Models/task.dart';
import 'package:to_do_list/Models/task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final Box<Task> taskBox;

  TaskCubit(this.taskBox):super(TaskInitial()){
    loadTasks();
  }
  void loadTasks(){
    emit(TasksLoaded(List.from(taskBox.values)));
    print("tasks num: ${taskBox.values.length}");
  }
  void addTask(Task task){
    taskBox.add(task);
    loadTasks();
  }
  void deleteTask(int index){
    taskBox.deleteAt(index);
    loadTasks();
  }

  void toogleTask (int index, bool isCompleted) {
    var task = taskBox.getAt(index);
  if (task != null) {
    final updatedTask = Task(
      taskDescription: task.taskDescription,
      isCompleted: isCompleted,
    );
    taskBox.putAt(index, updatedTask);
    loadTasks();
  }
  }
  void clearTasks(){
    taskBox.clear();
    loadTasks();
  }
}