import 'package:bloc/bloc.dart';
import './export_order_bloc.dart';
import '../../services/customer_service.dart';


class OrderBloc extends Bloc<OrderEvent,OrderState>{
  final CustomerService _customerService = CustomerService();


  @override
  OrderState get initialState => OrderScreenInitial();

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if(event is LoadAllOrders){
      Stream pendingOrders =  _customerService.fetchPendingOrders(userId: event.userId);
      Stream approvalOrders = _customerService.fetchAcceptedOrders(userId:event.userId);
      Stream deliveredOrders = _customerService.fetchDeliveredOrders(userId:event.userId);
      
      yield OrdersFetchedSuccess(orderPending: pendingOrders,approvalOrders:approvalOrders,deliveredOrders:deliveredOrders);
        
    }
      
  }

}