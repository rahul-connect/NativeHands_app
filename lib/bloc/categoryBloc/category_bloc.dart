
import 'package:bloc/bloc.dart';
import '../../services/seller_services.dart';
import './category_event.dart';
import './category_state.dart';


class CategoryBloc extends Bloc<CategoryEvent,CategoryState>{
  SellerService _service = SellerService();

  @override
  CategoryState get initialState => CategoryInitial();

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if(event is AddCategory){
      yield AddingCategory();
      await _service.addCatgeory(event.title,event.userId);
      yield AddedSuccess();
      yield CategoryInitial();

    }
  }


}