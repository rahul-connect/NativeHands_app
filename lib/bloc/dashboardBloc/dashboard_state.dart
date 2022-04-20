

abstract class DashboardState{

}



class DashboardInitial extends DashboardState{

}


class AnalyticsLoaded extends DashboardState{
     final int countPendingOrders;
     final int countApprovedOrders;
     final int countDeliveredOrders;
     final int countTotalCustomers;

  AnalyticsLoaded({this.countPendingOrders, this.countApprovedOrders, this.countDeliveredOrders, this.countTotalCustomers});

}