import 'package:resume/models/contact.dart';
import 'package:resume/models/education.dart';
import 'package:resume/models/experience.dart';
import 'package:resume/models/expertise.dart';
import 'package:resume/models/interest.dart';
import 'package:resume/models/skill.dart';

class Resume {
  Resume({
    required this.firstname,
    required this.lastname,
    required this.jobTitle,
    this.contacts = const [],
    this.skills = const [],
    this.experience = const [],
    this.education = const [],
    this.expertises = const [],
    this.interests = const [],
  });

  final String firstname;
  final String lastname;
  final String jobTitle;
  final List<Contact> contacts;

  final List<Skill> skills;
  final List<Experience> experience;
  final List<Education> education;
  final List<Expertise> expertises;
  final List<Interest> interests;
}
