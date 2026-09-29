void main() {
  // TASK 1
  // Multiplication table 1-10

  for (int digit = 1; digit <= 10; digit++) {
    print("MULTIPLICATION TABLE for digit $digit");

    for (int i = 1; i <= 10; i++) {
      print("$digit * $i = ${digit * i}");
    }
    print("");
  }

  // TASK 2
  // Next day

  int day = 28;
  int month = 2;
  int year = 2026;

  bool isLeapYear =
      year % 400 == 0 || (year % 4 == 0 && year % 100 != 0);
ч
  int daysInMonth;

  if (month == 2) {
    daysInMonth = isLeapYear ? 29 : 28;
  } else if (month == 4 ||
      month == 6 ||
      month == 9 ||
      month == 11) {
    daysInMonth = 30;
  } else {
    daysInMonth = 31;
  }
  if (day < 1 || day > daysInMonth) {
    print("Invalid date");
  } else {
    day++;
    if (day > daysInMonth) {
      day = 1;
      month++;

      if (month > 12) {
        month = 1;
        year++;
      }
    }

    print(
      "${day.toString().padLeft(2, '0')}."
          "${month.toString().padLeft(2, '0')}.$year",
    );
  }

  // TASK 3
  // Vowel Counter

  String text = "flutter mobile development";
  int vowelCount = 0;

  for (int i = 0; i < text.length; i++) {
    String letter = text[i].toLowerCase();

    if ("aeiou".contains(letter)) {
      vowelCount++;
    }
  }

  print("Vowels: $vowelCount");

  // TASK 4
  // Manual min & max finder

  List<int> numbers = [14, 88, 3, 42, 99, 12, 67];
  List<int> numbers1 = [234, 34, 123, 44, 949, 112, 67];

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

  print("numbers -> max: $max, min: $min");

  int min1 = numbers1[0];
  int max1 = numbers1[0];

  for (int number in numbers1) {
    if (number < min1) {
      min1 = number;
    }

    if (number > max1) {
      max1 = number;
    }
  }

  print("numbers1 -> max: $max1, min: $min1");

  // TASK 5
  // Prime Number Checker

  int number = 6;
  bool isPrime = true;

  if (number < 2) {
    isPrime = false;
  } else {
    for (int i = 2; i < number; i++) {
      if (number % i == 0) {
        isPrime = false;
        break;
      }
    }
  }

  if (isPrime) {
    print("$number -> prime number");
  } else {
    print("$number -> not prime number");
  }
}