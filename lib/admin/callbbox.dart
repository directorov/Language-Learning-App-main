import 'package:flutter/material.dart';

class CallBox extends StatefulWidget {
  final ColorScheme dync;

  const CallBox({required this.dync, super.key});

  @override
  State<CallBox> createState() => _CallBoxState();
}

class _CallBoxState extends State<CallBox> {
  @override
  Widget build(BuildContext context) {
    double kh = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: kh / 3,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello \nAbilash",
                  style: TextStyle(
                    color: widget.dync.surface,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Requested Students",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: widget.dync.inversePrimary,
            thickness: 2,
          ),
        ),
        SizedBox(
          height: kh / 3,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: widget.dync.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: widget.dync.inversePrimary,
                          radius: 20,
                          child: Text(
                            data[index][0], // Первая буква имени
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: ${data[index]}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.dync.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Email: ${data[index].toLowerCase()}@example.com",
                              style: TextStyle(
                                fontSize: 14,
                                color: widget.dync.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            // Логика для принятия запроса
                            debugPrint("Accepted ${data[index]}");
                          },
                          child: const Text("Accept"),
                        ),
                        TextButton(
                          onPressed: () {
                            // Логика для отклонения запроса
                            debugPrint("Declined ${data[index]}");
                          },
                          child: const Text("Decline"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

List<String> data = [
  "Tamizh",
  "Abilash",
  "John",
  "Doe",
  "Alice",
  "Bob",
  "Charlie",
  "Eve"
];
