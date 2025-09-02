package util;

public class SearchCondition {
	private String searchField = "";
	private String searchWord = "";
	private int page = 1;
	private int pageSize = 10;
	
	public SearchCondition(int page, int pageSize) {
		this("title", "", page, pageSize);
	}
	
	public int getOffset(int page) {
		return (page-1) *pageSize;
	}
	
	public String getQueryString(int page) {
		if(searchWord != null && !"".equals(searchWord)) {
			return "?page=" + page + "&searchField=" + searchField + "&searchWord=" + searchWord;
		}
		return "?page=" + page;
	}
	
	public String getQueryString() {
		return getQueryString(page);
	}
	
	public SearchCondition(String searchField, String searchWord, int page, int pageSize) {
		super();
		this.searchField = searchField;
		this.searchWord = searchWord;
		this.page = page;
		this.pageSize = pageSize;
	}
	
	public SearchCondition() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	public String toString() {
		return "SearchCondition [searchField=" + searchField + ", searchWord=" + searchWord + ", page=" + page
				+ ", pageSize=" + pageSize + "]";
	}

	public String getSearchField() {
		return searchField;
	}
	public void setSearchField(String searchField) {
		this.searchField = searchField;
	}
	public String getSearchWord() {
		return searchWord;
	}
	public void setSearchWord(String searchWord) {
		this.searchWord = searchWord;
	}
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	
}
