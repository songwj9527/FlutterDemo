class PageParams {
  // Page: 页面
  // PageSize: 每页条数
  // SortBy: 排序字段，可不传
  // SortOrder：asc or desc (default)

  int Page = 1;
  int PageSize = 15;
  String SortBy = "";
  String SortOrder = "desc";

  PageParams({this.Page: 1, this.PageSize: 15, this.SortBy: "", this.SortOrder: "desc"});
}