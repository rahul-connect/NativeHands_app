import 'package:flutter_bloc/flutter_bloc.dart';
import 'export_account_bloc.dart';
import '../../services/customer_service.dart';


class AccountBloc extends Bloc<AccountEvent,AccountState>{
  final CustomerService _customerService = CustomerService();

  @override
  AccountState get initialState => AccountInitial();

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async*{
    if(event is UpdateDetail){
      yield DetailUpdating();
    
       await _customerService.updateCustomerDetails(
         fullName: event.fullName,
         company: event.company,
         address: event.address,
         gstNo: event.gstNo,
         userId: event.userId,
         becomeSeller: event.becomeSeller
       );

       yield DetailUpdatedSuccess();
       yield AccountInitial();
    }
  }

}