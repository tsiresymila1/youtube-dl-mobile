part of 'loader_bloc.dart';

@immutable
sealed class LoaderEvent {}
final class LoaderEventLoading extends LoaderEvent {}
final class LoaderEventStop extends LoaderEvent{}
