import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_list/Models/task.dart';
import 'package:to_do_list/Models/taskCubit.dart';
import 'package:to_do_list/Models/task_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter()); // تسجيل المحول لنموذج TodoItem
  await Hive.openBox<Task>('todoBox');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Todo list"),),
        body:BlocProvider(
          create: (_)=>TaskCubit(Hive.box<Task>('todoBox')),
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child:TasksScreen()
            )
      )
      ),
    );
  }
}

class TasksScreen extends StatelessWidget {
  TasksScreen({super.key});
  final TextEditingController _controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Center(
          child:Column(
            children: [
              Row(
                children:[
                  Expanded(child:TextField(
                controller: _controller,
                decoration: InputDecoration(
                  label: Text("Task")
                ),
              )),
              ElevatedButton(onPressed: (){
                String taskDesc = _controller.text;
                Task task = Task(taskDescription: taskDesc);
                context.read<TaskCubit>().addTask(task);
              }, child: Text("Add task"))
              ]),BlocBuilder<TaskCubit, TaskState>(
                  builder: (cubitContext, state) {
                    if(state is TasksLoaded){
                      var tasksList = state.tasksList;
                      return Expanded(child: ListView.builder(
                      itemCount: tasksList.length,
                      itemBuilder: (context, index) => taskItem(tasksList[index],context,index),
                      ));
                    }
                    return CircularProgressIndicator();
  })
            ],
          ),
        );
  }
}
Widget taskItem(Task task,BuildContext context,int index){
    GlobalKey textStyleKey = GlobalKey();
    return Card(
      child: ListTile(
        leading: Checkbox(value: task.isCompleted, onChanged: (isChecked){
          context.read<TaskCubit>().toogleTask(index, isChecked!);
        }),
        title:Text(task.taskDescription,key: textStyleKey,
        style: task.isCompleted?completedTaskStyle():notCompletedTaskStyle(),),
        trailing: IconButton(onPressed: ()=>context.read<TaskCubit>().deleteTask(index), icon: Icon(Icons.delete_forever)),
      )
    );
  }

  TextStyle notCompletedTaskStyle(){
    return TextStyle(
      color: Colors.black,
      decoration: TextDecoration.none
    );
  }
  TextStyle completedTaskStyle(){
    return TextStyle(
      color: Colors.grey,
      decoration: TextDecoration.lineThrough
    );
  }