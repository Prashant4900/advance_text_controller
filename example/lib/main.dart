import 'package:advance_text_controller/advance_text_controller.dart';
import 'package:flutter/material.dart';

class ProductModel {
  final int id;
  final String name;

  ProductModel(this.id, this.name);

  @override
  String toString() {
    return "ProductModel(id: $id, name: $name)";
  }
}

final products = [
  ProductModel(1, "Name 1"),
  ProductModel(2, "Name 2"),
  ProductModel(3, "Name 3"),
  ProductModel(4, "Name 4"),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final stringController = TextEditingController();
  final integerController = IntegerEditingController();
  final doubleController = DoubleEditingController();
  final dateController = DateEditingController();
  final timeController = TimeEditingController();
  final multiValueController = MultiValueEditingController();
  final modelController = ModelEditingController<ProductModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advance Text Editing Controller"),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFieldWithLabel(
              controller: stringController,
              label: 'Name',
            ),
            SizedBox(height: 20),
            TextFieldWithLabel(
              controller: integerController,
              label: 'Age',
            ),
            SizedBox(height: 20),
            TextFieldWithLabel(
              controller: doubleController,
              label: 'Amount',
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                final result = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now(),
                );

                if (result == null) return;

                dateController.setDateTime(result);
              },
              child: TextFieldWithLabel(
                readOnly: true,
                controller: dateController,
                label: 'Date of birth',
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                final result = await showModalBottomSheet<int?>(
                  context: context,
                  showDragHandle: true,
                  useSafeArea: true,
                  builder: (context) {
                    return Column(
                      children: products
                          .map((e) => ListTile(
                                onTap: () => Navigator.pop(context, e.id),
                                title: Text(e.name),
                              ))
                          .toList(),
                    );
                  },
                );

                if (result == null) return;

                final model = products.firstWhere((e) => e.id == result);

                modelController.updateModel(model);

                modelController.text = model.name;
              },
              child: TextFieldWithLabel(
                controller: modelController,
                label: 'Products',
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                onPressed: () {
                  final name = stringController.text;
                  final age = integerController.numberValue;
                  final amount = doubleController.numberValue;
                  final dob = dateController.dateTime;
                  final model = modelController.model;

                  showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    useRootNavigator: true,
                    showDragHandle: true,
                    builder: (context) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Name: $name",
                                  style: TextStyle(fontSize: 16)),
                              Text("Data type: ${name.runtimeType}",
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Age: $age", style: TextStyle(fontSize: 16)),
                              Text("Data type: ${age.runtimeType}",
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Amount: $amount",
                                  style: TextStyle(fontSize: 16)),
                              Text("Data type: ${amount.runtimeType}",
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 20),
                          SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Date of birth: $dob",
                                  style: TextStyle(fontSize: 16)),
                              Text("Data type: ${dob.runtimeType}",
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Product: ${model}",
                                  style: TextStyle(fontSize: 16)),
                              Text("Data type: ${model.runtimeType}",
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWithLabel extends StatelessWidget {
  const TextFieldWithLabel({
    super.key,
    required this.controller,
    required this.label,
    this.readOnly = false,
  });

  final String label;
  final TextEditingController controller;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          readOnly: readOnly,
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter $label",
          ),
        ),
      ],
    );
  }
}
