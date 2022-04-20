import '../../services/seller_services.dart';

import './export_dashboard_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DashboardBloc extends Bloc<DashboardEvent,DashboardState>{
  SellerService _service = SellerService();

  
  @override
  DashboardState get initialState => DashboardInitial();

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async*{
    if(event is LoadAnalyticsEvent){
      
       int countPendingOrders = await _service.countPendingOrders(event.sellerId);
       int countApprovedOrders = await _service.countApprovedOrders(event.sellerId);
       int countDeliveredOrders = await _service.countDeliveredOrders(event.sellerId);
       int countTotalCustomers = await _service.countTotalCustomer();

       yield(AnalyticsLoaded(
         countPendingOrders: countPendingOrders,
         countApprovedOrders: countApprovedOrders,
         countDeliveredOrders: countDeliveredOrders,
         countTotalCustomers: countTotalCustomers
       ));
    }
  }

}