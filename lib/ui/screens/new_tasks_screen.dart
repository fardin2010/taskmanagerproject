import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_count_summary_modal.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/network_caller/network_response.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/profile_summary_card.dart';
import 'package:task_manager/ui/widgets/summary_card.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';
import '../../data/utility/urls.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  bool getNewTaskinProgress = false;
  bool getTaskCounterinProgress = false;
  TaskListModel taskListModel = TaskListModel();
  TaskSummaryCountListModal taskCounterlistsummary =
      TaskSummaryCountListModal();

  Future<void> getNewTaskList() async {
    getNewTaskinProgress = true;

    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getNewTaskList);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }
    getNewTaskinProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getTaskCounter() async {
    getTaskCounterinProgress = true;

    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getTaskCounter);
    if (response.isSuccess) {
      taskCounterlistsummary =
          TaskSummaryCountListModal.fromJson(response.jsonResponse);
    }
    getTaskCounterinProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getNewTaskList();
    getTaskCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            SizedBox(
              height: 120,
              child: Visibility(
                replacement: Container(
                    alignment: Alignment.topLeft,
                    child: LinearProgressIndicator()),
                visible: getTaskCounterinProgress == false,
                child: RefreshIndicator(
                  onRefresh: getTaskCounter,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: taskCounterlistsummary.taskcountlist?.length,
                      itemBuilder: (context, index) {
                        TaskCounter taskcount =
                            taskCounterlistsummary.taskcountlist![index];
                        return FittedBox(
                          child: SummaryCard(
                            count: taskcount.sum.toString(),
                            title: taskcount.sId ?? "",
                          ),
                        );
                      }),
                ),
              ),
            ),
            Expanded(
              child: Visibility(
                replacement: Center(
                  child: CircularProgressIndicator(),
                ),
                visible: getNewTaskinProgress == false,
                child: RefreshIndicator(
                  onRefresh: getNewTaskList,
                  child: ListView.builder(
                    itemCount: taskListModel.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                        task: taskListModel.taskList![index],
                        onStatus: () {
                          getNewTaskList();
                        },
                        showProgress: (inpogress) {
                          getNewTaskinProgress = inpogress;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
