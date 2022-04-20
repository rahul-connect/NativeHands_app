

import 'package:flutter/material.dart';

abstract class DashboardEvent{

}


class LoadAnalyticsEvent extends DashboardEvent{
  final String sellerId;
  LoadAnalyticsEvent({@required this.sellerId});
}