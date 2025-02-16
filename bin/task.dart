import 'dart:io';

void main() {
  print("\n🎭 Welcome To Our Theater 🎭\n");

  // 5x5 Theater Seats (Initially all empty 'E')
  List<List<String>> seats = List.generate(5, (_) => List.filled(5, 'E'));

  // Map to store user booking details (seat_position -> user details)
  Map<String, Map<String, String>> bookings = {};

  while (true) {
    printMenu();
    int choice = getInput<int>(validator: numberValidator(1, 4));

    switch (choice) {
      case 1:
        bookSeat(seats, bookings);
        break;
      case 2:
        printSeats(seats);
        break;
      case 3:
        printUsers(bookings);
        break;
      case 4:
        print("\n👋 See You Back!\n");
        return;
      default:
        print("\n❌ Invalid choice! Please select a valid option.\n");
        break;
    }
  }
}

// Function to print menu
void printMenu() {
  print("\npress 1 to book new seat");
  print("press 2 to show the theater seats");
  print("press 3 to show users data");
  print("press 4 to exit");
}

// Function to print the theater seats
void printSeats(List<List<String>> seats) {
  print("\n🎭 Theater Seats:");
  for (var row in seats) {
    print(row.join(" "));
  }
}

// Function to book a seat
void bookSeat(List<List<String>> seats, Map<String, Map<String, String>> bookings) {
  int row = getInput<int>(validator: numberValidator(1, 5)) - 1;
  int col = getInput<int>(validator: numberValidator(1, 5)) - 1;

  // Check if seat is available
  if (seats[row][col] == 'B') {
    print("\n❌ Seat is already booked! Try another one.");
    return;
  }

  String name = getInput<String>(
    validator: (input) => input.isNotEmpty ? input : null,
  );

  String phone = getInput<String>(
    validator: (input) => RegExp(r'^\d+$').hasMatch(input) ? input : null,
  );

  // Book the seat
  seats[row][col] = 'B';
  bookings["${row + 1},${col + 1}"] = {"name": name, "phone": phone};

  print("\n✅ Seat booked successfully!");
}

// Function to print user booking details
void printUsers(Map<String, Map<String, String>> bookings) {
  if (bookings.isEmpty) {
    print("\n📜 No bookings yet.");
    return;
  }

  print("\n📜 Users Booking Details:");
  for (var entry in bookings.entries) {
    print("🎟 Seat ${entry.key}: ${entry.value['name']} - ${entry.value['phone']}");
  }
}

// 🛠 Generic input function that handles validation and parsing
T getInput<T>({
  required T? Function(String) validator,
}) {
  while (true) {
    String? input = stdin.readLineSync()?.trim();

    if (input == null || input.isEmpty) {
      print("\n❌ Input cannot be empty! Try again.\n");
      continue;
    }

    T? validatedValue = validator(input);
    if (validatedValue != null) return validatedValue;

    print("\n❌ Invalid input! Try again.\n");
  }
}

// 📌 Reusable validator for integers in a range
int? Function(String) numberValidator(int min, int max) {
  return (String input) {
    int? value = int.tryParse(input);
    if(value == null) 
    {
      return null;
    }
    else
    {
      if(value >= min && value <= max)
      {
        return value;
      }
      else 
      {
        return null;
      }
    }
  };
}
