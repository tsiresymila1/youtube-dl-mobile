part of 'loader_bloc.dart';

@immutable
sealed class LoaderState {}

final class LoaderStateStop extends LoaderState {}
final class LoaderStateLoading extends LoaderState {}
