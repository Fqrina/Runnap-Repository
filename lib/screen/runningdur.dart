import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class runningdur extends StatelessWidget {
  const runningdur({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Running info'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orangeAccent, width: 2),
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: Text(
                                    "Air Quality scale:",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 43),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: Text(
                                    "Good: run anytime",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: Text(
                                    "Fair: Under 3 hour",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: Text(
                                    "Moderate: Under 1 hour",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: Text(
                                    "Poor: Under 30 minutes",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: Text(
                                    "Very Poor: Dont run",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 8),
              // Expanded(
              //   child: Container(
              //     color: Colors.blues,
              //     child: Text("test"),
              //   ),
              // ),
              // Expanded(
              //   child: Container(
              //     child: Text("test"),
              //   ),
              // ),
              // Expanded(
              //   child: Container(
              //     child: Text("test"),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
    //bisa make ini buat new, atau bisa juga buat sidebar buat info ajah
  }
}
