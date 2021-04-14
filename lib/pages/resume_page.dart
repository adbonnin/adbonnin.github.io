import 'package:flutter/material.dart';
import 'package:resume/main.dart';
import 'package:resume/models/resume.dart';

class ResumePage extends StatelessWidget {
  ResumePage({
    Key? key,
    required this.resume,
  }) : super(key: key);

  final Resume resume;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppTheme.gunmetal,
        padding: EdgeInsets.only(top: 30),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (builder, constraints) {
              final header = Header(resume: resume);
              final maxWidth = 992.0;

              final content = Container(
                color: AppTheme.eerieBlack,
                child: Column(
                  children: [header],
                ),
              );

              final Widget container;
              if (constraints.maxWidth < maxWidth) {
                container = content;
              }
              else {
                container = Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: maxWidth,
                      child: content,
                    ),
                  ],
                );
              }

              return container;
            },
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  Header({
    Key? key,
    required this.resume,
  }) : super(key: key);

  final Resume resume;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "${resume.firstname} ${resume.lastname}",
            style: TextStyle(
              color: AppTheme.littleBoyBlue,
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 30),
          Text(
            resume.jobTitle,
            style: TextStyle(
              color: AppTheme.turquoise,
              fontSize: 45,
            ),
          ),
        ],
      ),
    );
  }
}
