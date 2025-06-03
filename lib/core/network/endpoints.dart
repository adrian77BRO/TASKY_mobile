const baseUrl = 'http://192.168.1.5:8080';

class ApiEndpoints {
  static const login = '$baseUrl/user/login';
  static const register = '$baseUrl/user/register';
  static const tasks = '$baseUrl/task';
  static String task(int id) => '$baseUrl/task/$id';
  static String searchTasks(String status) =>
      '$baseUrl/task/search?status=$status';
  static String completeTask(int id) => '$baseUrl/task/$id/complete';
}
