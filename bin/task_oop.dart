import 'dart:io';

void main() {
  Theater theater = Theater(rows: 5, cols: 5);
  print("\n🎭 Welcome To Our Theater 🎭\n");

  while (true) {
    theater.printOptions();
    int choice = getInput<int>(validator: numberValidator(1, 4));
    switch (choice) {
      case 1:
        theater.bookSeat();
        break;
      case 2:
        theater.printSeats();
        break;
      case 3:
        theater.printUsers();
        break;
      case 4:
        print("\n👋 See You Back!\n");
        exit(0);
      default:
        print("\n❌ Invalid choice! Please select a valid option.\n");
    }
  }
}

// 🎭 Theater Class (Manages Seats & Bookings)
class Theater {
  final int rows;
  final int cols;
  late List<List<Seat>> seats;
  final List<Booking> bookings = [];

  Theater({required this.rows, required this.cols}) {
    // Initialize the seats
    seats = List.generate(rows, (row) => 
      List.generate(cols, (col) => Seat(row: row + 1, col: col + 1))
    );
  }

  // 🔹 Prints menu options
  void printOptions() {
    print("\n📌 Theater Menu:");
    print("1️⃣ Book a seat");
    print("2️⃣ Show the theater seats");
    print("3️⃣ Show booked users");
    print("4️⃣ Exit");
  }

  // 🔹 Print theater seating arrangement
  void printSeats() {
    print("\n🎭 Theater Seats:");
    for (var row in seats) {
      String res = '';
      for (var seat in row) {
        res += "${seat.value} ";
      }
      print(res);
    }
  }

  // 🔹 Handle seat booking
  void bookSeat() {
    int row = getInput<int>(validator: numberValidator(1, rows)) - 1;
    int col = getInput<int>(validator: numberValidator(1, cols)) - 1;

    Seat seat = seats[row][col];

    if (seat.isBooked) {
      print("\n❌ Seat is already booked! Try another one.");
      return;
    }

    String name = getInput<String>(
      validator: (input) => input.isNotEmpty ? input : null,
    );

    String phone = getInput<String>(
      validator: (input) => input.isNotEmpty ? input : null,
    );

    User user = User(name: name, phone: phone);
    Booking booking = Booking(user: user, seat: seat);
    
    seat.book();
    bookings.add(booking);

    print("\n✅ Seat booked successfully!");
  }

  // 🔹 Display all user bookings
  void printUsers() {
    if (bookings.isEmpty) {
      print("\n📜 No bookings yet.");
      return;
    }

    print("\n📜 Users Booking Details:");
    for (var booking in bookings) {
      print(booking);
    }
  }
}

// 🛑 Seat Class (Represents a single seat)
class Seat {
  final int row;
  final int col;
  String value;

  Seat({required this.row, required this.col, this.value = 'E'});

  bool get isBooked => value == 'B';

  void book() {
    value = 'B';
  }

  @override
  String toString() => "Row $row, Seat $col";
}

// 🧑‍💼 User Class (Stores user details)
class User {
  final String name;
  final String phone;

  User({required this.name, required this.phone});

  @override
  String toString() => "$name - $phone";
}

// 🎟 Booking Class (Encapsulates user & seat together)
class Booking {
  final User user;
  final Seat seat;

  Booking({required this.user, required this.seat});

  @override
  String toString() => "🎟 $seat: $user";
}

// 📌 InputHandler Class (Handles all input operations)

T getInput<T>({required T? Function(String) validator}) {
  while (true) {
    stdout.write("=> ");
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

int? Function(String) numberValidator(int min, int max) {
  return (String input) {
    int? value = int.tryParse(input);
    return (value != null && value >= min && value <= max) ? value : null;
  };
}

