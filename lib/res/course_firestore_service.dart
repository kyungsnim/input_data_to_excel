import 'package:input_data_to_excel/models/CourseModel.dart';
import 'package:firebase_helpers/firebase_helpers.dart';

DatabaseService<CourseModel> courseDBS = DatabaseService<CourseModel>("courses",
    fromDS: (id, data) => CourseModel.fromDS(id, data),
    toMap: (course) => course.toMap());
