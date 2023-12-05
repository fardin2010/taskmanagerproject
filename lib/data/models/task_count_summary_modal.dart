class TaskSummaryCountListModal {
  String? status;
  List<TaskCounter>? taskcountlist;

  TaskSummaryCountListModal({this.status, this.taskcountlist});

  TaskSummaryCountListModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskcountlist = <TaskCounter>[];
      json['data'].forEach((v) {
        taskcountlist!.add(new TaskCounter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.taskcountlist != null) {
      data['data'] = this.taskcountlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskCounter {
  String? sId;
  int? sum;

  TaskCounter({this.sId, this.sum});

  TaskCounter.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['sum'] = sum;
    return data;
  }
}