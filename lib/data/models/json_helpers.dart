part of '../models.dart';

List<String> stringList(Object? value) {
  return (value as List<Object?>).cast<String>();
}

DateTime dateTime(Object? value) {
  if (value is DateTime) return value;
  return DateTime.parse(value as String);
}
