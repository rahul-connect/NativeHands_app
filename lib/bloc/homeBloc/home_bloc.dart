import 'package:bloc/bloc.dart';
import '../../services/customer_service.dart';
import './home_event.dart';
import './home_state.dart';


class HomeBloc extends Bloc<HomeEvent,HomeState>{

  final CustomerService _customerService = CustomerService();

  // HomeBloc({@required CustomerService customerService}):
  // assert(customerService != null),
  // _customerService = customerService;


  @override
  HomeState get initialState => HomeInitialState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async*{
    if(event is FetchCategoryEvent){
      var categories =  _customerService.fetchAllCategories();
      yield CategoryFetched(categories: categories);

    }else if(event is FetchCategoryProducts){
      Stream categoryProducts = _customerService.fetchCategoryProducts(categoryID: event.category);
      yield ProductsFetchedSuccess(categoryProducts);

    }
  }

}