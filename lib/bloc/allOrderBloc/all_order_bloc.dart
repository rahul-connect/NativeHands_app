import 'package:bloc/bloc.dart';
import '../../services/seller_services.dart';
import './all_order_event.dart';
import './all_order_state.dart';

class AllOrderBloc extends Bloc<AllOrderEvent,AllOrderState>{
   SellerService _service = SellerService();
   
  @override
  AllOrderState get initialState => AllOrderScreenInitial();

  @override
  Stream<AllOrderState> mapEventToState(AllOrderEvent event) async*{
    if(event is SellerLoadAllOrders){
       Stream allPendingOrders =  _service.fetchAllPendingOrders(sellerId: event.sellerId);
       Stream allApprovedOrders =  _service.fetchAllAcceptedOrders(sellerId: event.sellerId);
       Stream alldeliveredOrders =  _service.fetchAllDeliveredOrders(sellerId: event.sellerId);

      yield SellerAllOrdersFetched(allOrderPending: allPendingOrders,allOrderApproved: allApprovedOrders, allOrderDelivered:alldeliveredOrders);
    }
  }

}