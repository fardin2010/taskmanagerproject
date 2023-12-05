import 'package:flutter/material.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';

import '../../data/models/task_list_model.dart';
import '../../data/utility/urls.dart';

enum TaskStatusType {
  New,
  Progress,
  Compleate,
  Cancled,
}


class TaskItemCard extends StatefulWidget {
  const TaskItemCard({
    super.key, required this.task, required this.onStatus, required this.showProgress,
  });

  final Task task;
  final VoidCallback onStatus;
  final Function(bool) showProgress;

  @override
  State<TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> {

  Future<void> updateTAskStatus(String status)async{
    widget.showProgress(true);
      final response = await NetworkCaller().getRequest(Urls.UpdateTask(widget.task.sId ?? "", status));
      if(response.isSuccess){
        widget.onStatus();
      }
    widget.showProgress(false);
  }
  // Future<void> DeleateTaskStatus(String status)async{
  //   widget.showProgress(true);
  //   final response = await NetworkCaller().getRequest(Urls.UpdateTask(widget.task.sId ?? "", status));
  //   if(response.isSuccess){
  //     widget.onStatus();
  //   }
  //   widget.showProgress(false);
  // }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title ?? "",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
             Text(widget.task.description ?? ""),
             Text("Date :${widget.task.createdDate ?? ""} "),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Chip(
                  label: Text(
                    widget.task.status ?? "",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                ),
                Wrap(
                  children: [
                    // IconButton(
                    //     onPressed: () {
                    //
                    //     },
                    //     icon: const Icon(Icons.delete_forever_outlined)),
                    IconButton(onPressed: () {
                      showsUpdateStatusModal();
                    }, icon: const Icon(Icons.edit)),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  void showsUpdateStatusModal(){
    List<ListTile> item = TaskStatusType.values.map((e) => ListTile(
      title: Text("${e.name}"),
      onTap: (){
        updateTAskStatus(e.name);
        Navigator.pop(context);
      },

    )).toList();

    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Update Status"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: item,
        ),
        actions: [
          ButtonBar(
            children: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancle")),
            ],
          ),
        ],
      );
    });
  }
}


