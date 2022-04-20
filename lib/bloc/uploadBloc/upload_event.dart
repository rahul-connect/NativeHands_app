

abstract class UploadEvent{


}




class UploadButtonPressed extends UploadEvent{
  final String title;
  final String description;
  final Map<String, String> paths;
  final String category;
  final int price;
  final String sellerId;


  UploadButtonPressed({this.title, this.description, this.paths,this.category,this.price,this.sellerId});
  
    
}



