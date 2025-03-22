// Optimized departments fetch with caching
import 'package:flutter/foundation.dart';
import 'package:frontend/Model/DeptOnline.dart';
import 'package:frontend/creds.dart';

Future<List<DepartmentOnline>> fetchDepartmentsOnline({
  required List<DepartmentOnline>? cachedDepartments,
}) async {
  if (cachedDepartments != null) {
    return cachedDepartments;
  }

  try {
    final depts = await comms.getRequests(
      endpoint: "online/departments",
      isServer: true,
    );

    if (depts["success"]) {
      List data = depts["rsp"]["data"]["departments"];
      cachedDepartments =
          data.map((dpt) => DepartmentOnline.fromJson(dpt)).toList();
      return cachedDepartments!;
    } else {
      debugPrint("Error fetching departments: ${depts["rsp"]}");
      return [];
    }
  } catch (e) {
    debugPrint("Exception fetching departments: $e");
    return [];
  }
}

Future<List<T>> fetchGlobal<T>({
  required Future<Map<String, dynamic>> Function(String endpoint)
      getRequests, // Function to fetch data
  required T Function(Map<String, dynamic> json)
      fromJson, // FromJson function for the specific type T
  required String endpoint, // Endpoint to fetch data from
}) async {
  try {
    final response = await getRequests(endpoint);

    if (response["success"]) {
      List data = response["rsp"]["data"];
      return data.map((item) => fromJson(item)).toList();
    } else {
      debugPrint("Error fetching data: ${response["rsp"]}");
      return [];
    }
  } catch (e) {
    debugPrint("Exception fetching data: $e");
    return [];
  }
}
