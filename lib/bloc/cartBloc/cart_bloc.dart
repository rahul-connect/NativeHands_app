import 'package:bloc/bloc.dart';
import '../../services/customer_service.dart';
import './cart_event.dart';
import 'cart_state.dart';


class CartBloc extends Bloc<CartEvent,CartState>{
  final CustomerService _customerService = CustomerService();
  
  @override
  CartState get initialState => CartInitial();

  @override
  Stream<CartState> mapEventToState(CartEvent event) async*{
     if(event is FetchCartItems){
        Stream cartItems = _customerService.fetchCartItems(event.userId).asBroadcastStream();
        yield ItemsFetchedSuccess(cartItems: cartItems);
     }else if(event is RemoveItem){
         _customerService.deleteCartItem(event.cartItemId, event.userId);
         yield ItemRemovedSucess();
          Stream cartItems = _customerService.fetchCartItems(event.userId).asBroadcastStream();
          yield ItemsFetchedSuccess(cartItems: cartItems);
     }else if(event is OrderNowPressed){
        yield OrderingState();
         await _customerService.orderNow(event.userId,event.totalAmount,event.orderId,event.paymentId,event.paymentMode);
         yield OrderNowSuccess();

     }
  }

}