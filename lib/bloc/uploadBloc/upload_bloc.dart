import 'package:bloc/bloc.dart';
import '../../services/seller_services.dart';
import '../../bloc/uploadBloc/upload_event.dart';
import '../../bloc/uploadBloc/upload_state.dart';



class UploadBloc extends Bloc<UploadEvent,UploadState>{

  SellerService _service = SellerService();

  @override
  UploadState get initialState => UploadInitial();

  @override
  Stream<UploadState> mapEventToState(UploadEvent event) async*{
 if(event is UploadButtonPressed){
      yield UploadingProduct();
      
        await _service.uploadToFireStorage(
         title: event.title,
         description: event.description,
         paths: event.paths,
         category:event.category,
         price:event.price,
         sellerId:event.sellerId,
       );

      
       yield UploadSuccess();
       yield UploadInitial();

     
    }
  }

}