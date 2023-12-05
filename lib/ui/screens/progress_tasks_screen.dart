import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/ui/widgets/profile_summary_card.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';

import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class ProgressTasksScreen extends StatefulWidget {
  const ProgressTasksScreen({super.key});

  @override
  State<ProgressTasksScreen> createState() => _ProgressTasksScreenState();
}

class _ProgressTasksScreenState extends State<ProgressTasksScreen> {
  bool getProgressTaskInProgress = false;
  TaskListModel taskListModel = TaskListModel();

  Future<void> getProgressTaskList() async {
    getProgressTaskInProgress = true;

    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getProgressTaskList);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }
    getProgressTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const ProfileSummaryCard(),
          Expanded(
            child: Visibility(
              replacement: Center(
                child: CircularProgressIndicator(),
              ),
              visible: getProgressTaskInProgress == false,
              child: RefreshIndicator(
                onRefresh: getProgressTaskList,
                child: ListView.builder(
                  itemCount: taskListModel.taskList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return TaskItemCard(
                      task: taskListModel.taskList![index],
                      onStatus: () {
                        getProgressTaskList();
                      },
                      showProgress: (inpogress) {
                        getProgressTaskInProgress = inpogress;
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
    ));
  }
}
