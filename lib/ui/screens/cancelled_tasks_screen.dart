import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/profile_summary_card.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';

import '../../data/models/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class CancelledTasksScreen extends StatefulWidget {
  const CancelledTasksScreen({super.key});

  @override
  State<CancelledTasksScreen> createState() => _CancelledTasksScreenState();
}

class _CancelledTasksScreenState extends State<CancelledTasksScreen> {
  bool getCancledTaskInProgress = false;
  TaskListModel taskListModel = TaskListModel();

  Future<void> getCancledTaskList() async {
    getCancledTaskInProgress = true;

    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getCancledTaskList);
    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }
    getCancledTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getCancledTaskList();
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
                visible: getCancledTaskInProgress == false,
                child: RefreshIndicator(
                  onRefresh: getCancledTaskList,
                  child: ListView.builder(
                    itemCount: taskListModel.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                        task: taskListModel.taskList![index],
                        onStatus: () {
                          getCancledTaskList();
                        },
                        showProgress: (inpogress) {
                          getCancledTaskInProgress = inpogress;
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
