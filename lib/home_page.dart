import 'package:flutter/material.dart';
import 'package:my_toast/extentions/gap.dart';
import 'toast/styles.dart';
import 'toast/provider.dart';
import 'toast/type.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ToastProvider toastProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      toastProvider = ToastProvider.of(context)!;
    });
    super.initState();
  }

  ToastStyle _selectedStyle = ToastStyle.style1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 219, 219),
      appBar: AppBar(title: const Text('My Toasts')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<ToastStyle>(
                  value: _selectedStyle,
                  onChanged: (ToastStyle? newValue) {
                    if (newValue != null) {
                      toastProvider.setStyle(newValue);
                      setState(() {
                        _selectedStyle = newValue;
                      });
                    }
                  },
                  items: ToastStyle.values.map((ToastStyle style) {
                    return DropdownMenuItem<ToastStyle>(
                      value: style,
                      child: Text(style.toString().split('.').last),
                    );
                  }).toList(),
                ),
                10.horisontalSpace,
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: errorPrimary),
              onPressed: () {
                toastProvider.showToast(NotificationType.error);
              },
              child: const Text(
                'Show Toast Error',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: successPrimary,
              ),
              onPressed: () {
                toastProvider.showToast(NotificationType.success);
              },
              child: const Text(
                'Show Toast Success',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: infoPrimary),
              onPressed: () {
                toastProvider.showToast(NotificationType.info);
              },
              child: const Text(
                'Show Toast Info',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: warningPrimary),
              onPressed: () {
                toastProvider.showToast(NotificationType.warning);
              },
              child: const Text(
                'Show Toast Warning',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
