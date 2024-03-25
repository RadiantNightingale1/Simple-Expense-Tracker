import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseTrackerApp());
}


class Expense {
  String description;
  double amount;

  Expense(this.description, this.amount);
}

class ExpenseTrackerApp extends StatefulWidget {
  @override
  _ExpenseTrackerAppState createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  bool isDarkModeEnabled = false;

  void _toggleTheme(bool value) {
    setState(() {
      isDarkModeEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => ExpenseTrackerHomePage(),
        '/settings': (context) => SettingsPage(toggleTheme: _toggleTheme),
        '/about': (context) => AboutPage(),
      },
    );
  }
}

class ExpenseTrackerHomePage extends StatefulWidget {
  @override
  _ExpenseTrackerHomePageState createState() => _ExpenseTrackerHomePageState();
}

class _ExpenseTrackerHomePageState extends State<ExpenseTrackerHomePage> {
  List<Expense> expenses = [];
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? ExpenseHistoryPage(expenses: expenses)
          : AddExpensePage(
        onAddExpense: _addExpense,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Expense',
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }
}

class AddExpensePage extends StatelessWidget {
  final Function(Expense) onAddExpense;

  AddExpensePage({required this.onAddExpense});

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: dateController,
            decoration: InputDecoration(labelText: 'date'),
          ),
          TextField(
            controller: amountController,
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              _addExpense(context);
            },
            child: Text('Add Expense'),
          ),
        ],
      ),
    );
  }

  void _addExpense(BuildContext context) {
    String description = descriptionController.text.trim();
    double amount = double.tryParse(amountController.text) ?? 0.0;

    if (description.isNotEmpty && amount > 0) {
      Expense expense = Expense(description, amount);
      onAddExpense(expense);
      descriptionController.clear();
      amountController.clear();
    } else {
      // Handle invalid input
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid description and amount.'),
        ),
      );
    }
  }
}

class ExpenseHistoryPage extends StatelessWidget {
  final List<Expense> expenses;

  ExpenseHistoryPage({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(expenses[index].description),
          subtitle: Text('\$${expenses[index].amount.toStringAsFixed(2)}'),
        );
      },
    );
  }
}

class SettingsPage extends StatelessWidget {
  final Function(bool) toggleTheme;

  SettingsPage({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Dark Mode'),
                Spacer(),
                Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    toggleTheme(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'About',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'This is a simple expense tracker app built with Flutter.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

