void main() {
  double balance = 50000.0;

  checkBalance(
    name: "Bekzat",
    balance: balance,
  );

  balance = deposit(
    currentBalance: balance,
    amount: 10000.0,
  );

  balance = withdraw(
    name: "Bekzat",
    currentBalance: balance,
    amount: 15000.0,
    pinCode: 1234,
  );

  checkBalance(
    name: "Bekzat",
    balance: balance,
  );
}

// 1. checkBalance
void checkBalance({
  required String name,
  required double balance,
}) =>
    print("$name, your current available balance is: $balance ₸");

// 2. deposit
double deposit({
  required double currentBalance,
  double? amount,
}) {
  double depositAmount = amount ?? 0.0;

  if (depositAmount < 0) {
    print("Error: Deposit amount cannot be negative.");
    return currentBalance;
  }

  double updatedBalance = currentBalance + depositAmount;

  print("Deposit successful!");
  print("Deposited: $depositAmount ₸");
  print("Updated balance: $updatedBalance ₸");

  return updatedBalance;
}

// 3. withdraw
double withdraw({
  required String name,
  required double currentBalance,
  double? amount,
  int? pinCode,
}) {
  int enteredPin = pinCode ?? 0000;

  if (enteredPin != 1234) {
    print("Error: Incorrect PIN. Transaction declined.");
    return currentBalance;
  }

  double withdrawAmount = amount ?? 0.0;

  if (withdrawAmount < 0) {
    print("Error: Withdrawal amount cannot be negative.");
    return currentBalance;
  }

  if (withdrawAmount > currentBalance) {
    print("Error: Insufficient funds.");
    print("Transaction declined.");
    return currentBalance;
  }

  double updatedBalance = currentBalance - withdrawAmount;

  print("Withdrawal successful!");
  print("Customer: $name");
  print("Withdrawn: $withdrawAmount ₸");
  print("Remaining balance: $updatedBalance ₸");

  return updatedBalance;
}