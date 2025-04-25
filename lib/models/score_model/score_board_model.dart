class ScoreBoardModel {
  bool? success;
  String? message;
  ScoreBoardModelData? data;

  ScoreBoardModel({this.success, this.message, this.data});

  ScoreBoardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new ScoreBoardModelData.fromJson(json['data'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ScoreBoardModelData {
  List<Today>? today;
  List<Weekly>? weekly;
  List<Monthly>? monthly;

  ScoreBoardModelData({this.today, this.weekly, this.monthly});

  ScoreBoardModelData.fromJson(Map<String, dynamic> json) {
    if (json['today'] != null) {
      today = <Today>[];
      json['today'].forEach((v) {
        today!.add(new Today.fromJson(v));
      });
    }
    if (json['weekly'] != null) {
      weekly = <Weekly>[];
      json['weekly'].forEach((v) {
        weekly!.add(new Weekly.fromJson(v));
      });
    }
    if (json['monthly'] != null) {
      monthly = <Monthly>[];
      json['monthly'].forEach((v) {
        monthly!.add(new Monthly.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.today != null) {
      data['today'] = this.today!.map((v) => v.toJson()).toList();
    }
    if (this.weekly != null) {
      data['weekly'] = this.weekly!.map((v) => v.toJson()).toList();
    }
    if (this.monthly != null) {
      data['monthly'] = this.monthly!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Today implements ScorePlayer {
  int? userId;
  String? name;
  String? image;
  String? totalPoints;

  Today({this.userId, this.name, this.image, this.totalPoints});

  Today.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    totalPoints = json['total_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['total_points'] = this.totalPoints;
    return data;
  }
}

class Weekly implements ScorePlayer {
  int? userId;
  String? name;
  String? image;
  String? totalPoints;

  Weekly({this.userId, this.name, this.image, this.totalPoints});

  Weekly.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    totalPoints = json['total_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['total_points'] = this.totalPoints;
    return data;
  }
}

class Monthly implements ScorePlayer {
  int? userId;
  String? name;
  String? image;
  String? totalPoints;

  Monthly({this.userId, this.name, this.image, this.totalPoints});

  Monthly.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    totalPoints = json['total_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['total_points'] = this.totalPoints;
    return data;
  }
}

/// Define a shared interface
abstract class ScorePlayer {
  int? get userId;
  String? get name;
  String? get image;
  String? get totalPoints;
}
