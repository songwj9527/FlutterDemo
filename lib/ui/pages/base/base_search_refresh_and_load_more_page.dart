import 'base_refresh_and_load_more_page.dart';
import 'base_search_refresh_and_load_more_list_view_state.dart';

abstract class BaseSearchRefreshAndLoadMorePage<T> extends BaseRefreshAndLoadMorePage<T> {
  // 搜索key
  String searchKey = "";
  // UI
  BaseSearchRefreshLoadMoreListViewState? state;
  bool enableToSearch = false;

  // 搜索key
  void search(String key);

  // 用户刷新页面
  void refresh();
}