import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';

class Urls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const String registration = '$_baseUrl/registration';
  static const String login = '$_baseUrl/login';
  static const String createNewTask = '$_baseUrl/createTask';
  static  String getNewTaskList = '$_baseUrl/listTaskByStatus/${TaskStatusType.New.name}';
  static const String getTaskCounter = '$_baseUrl/taskStatusCount';
  static  String getProgressTaskList = '$_baseUrl/listTaskByStatus/${TaskStatusType.Progress.name}';
  static  String getCompleateTaskList = '$_baseUrl/listTaskByStatus/${TaskStatusType.Compleate.name}';
  static  String getCancledTaskList = '$_baseUrl/listTaskByStatus/${TaskStatusType.Cancled.name}';
  static  String UpdateTask(String taskID, String status) =>
  '$_baseUrl/updateTaskStatus/$taskID/$status';
  static const String updateProfile = '$_baseUrl/profileUpdate';
  static const String Emailverification = '$_baseUrl/profileUpdate';

}

