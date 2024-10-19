class IdContainerProvider{
  List<String> idList = [];

  bool containId(String id){
    return idList.contains(id);
  }

  void addId(String id) {
    idList.add(id);
  }

  void removeId(String id) {
    idList.remove(id);
  }

  void resetList() {
    idList.clear();
  }
}