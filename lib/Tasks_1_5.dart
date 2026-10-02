void main() {
  String name = "Bekzat";
  int age = 25;
  double gpa = 3.4;
  bool isStudent = false;

  print("name: $name");
  print("age: $age y.o.");
  print("gpa: $gpa");
  print("is Teacher: ${!isStudent}");

  String text1 = "Hello";
  String? text2 = null;

  print("text1: $text1");
  print("text2: $text2");

  int length1 = text1.length;
  int length2 = text2?.length ?? 0;

  print(length1);
  print(length2);

  String confirmedText = text2 ?? "default";
  print("confirmed $confirmedText length: ${confirmedText.length}");

  // TASK 1
  for (int i = 1; i <= 10; i++) {
    for (int j = 1; j <= 10; j++) {
      print("$i * $j = ${i * j}");
    }
  }

  print("Task 2");
  // TASK 2
  print(nextDay(5, 9, 2026));
  print(nextDay(28, 2, 2024));
  print(nextDay(28, 2, 2026));
  print(nextDay(29, 2, 2026));
  print(nextDay(28, 2, 2100));
  print(nextDay(31, 12, 2025));

  print("Task 3");
  // TASK 3
  String text = "flutter mobile development";
  print("Vowels: ${countVowels(text)}");

  print("Task 4");
  // TASK 4
  List<int> numbers = [14, 88, 3, 42, 99, 12, 67];
  List<int> numbers1 = [234, 34, 123, 44, 949, 112, 67];

  findMinMax(numbers);
  findMinMax(numbers1);

  print("Task 5");
  // TASK 5
  checkPrime(3);
  checkPrime(6);
}

String nextDay(int day, int month, int year) {
  if (month < 1 || month > 12) {
    return "Invalid date";
  }

  int days = getDaysInMonth(month, year);

  if (day < 1 || day > days) {
    return "Invalid date";
  }

  day++;

  if (day > days) {
    day = 1;
    month++;
  }

  if (month > 12) {
    month = 1;
    year++;
  }

  String d = day.toString().padLeft(2, "0");
  String m = month.toString().padLeft(2, "0");

  return "$d.$m.$year";
}

bool isLeapYear(int year) {
  return year % 400 == 0 || (year % 4 == 0 && year % 100 != 0);
}

int getDaysInMonth(int month, int year) {
  if (month == 2) {
    return isLeapYear(year) ? 29 : 28;
  }

  if (month == 4 || month == 6 || month == 9 || month == 11) {
    return 30;
  }

  return 31;
}

int countVowels(String text) {
  int count = 0;
  String vowels = "aeiou";

  for (int i = 0; i < text.length; i++) {
    if (vowels.contains(text[i].toLowerCase())) {
      count++;
    }
  }

  return count;
}

void findMinMax(List<int> numbers) {
  int min = numbers[0];
  int max = numbers[0];

  for (int number in numbers) {
    if (number < min) {
      min = number;
    }

    if (number > max) {
      max = number;
    }
  }

  print("Max: $max, Min: $min");
}

void checkPrime(int number) {
  bool prime = number >= 2;

  for (int i = 2; i < number; i++) {
    if (number % i == 0) {
      prime = false;
      break;
    }
  }

  if (prime) {
    print("$number -> prime number");
  } else {
    print("$number -> not prime number");
  }
}