package util;

public class PageHandler2 {
	private SearchCondition sc;
//	private int pageSize = 10; // 한 페이지당 몇개의 게시물을 보여줄지
//	private int page; // 현재 페이지
	
	private int totalCnt; // 총 게시물
	private int naviSize = 10; // 1~10
	private int totalPage; // 총 페이지수
	private int beginPage; // 시작 페이지
	private int endPage; // 끝 페이지
	private boolean showPrev; // 이전페이지를 보여줄 수 있는지 -> 1!= beginPage
	private boolean showNext; // 다음페이지를 보여줄 수 있는지 -> totalPage!= endPage
	
	public PageHandler2(SearchCondition sc, int totalCnt) {
		super();
		this.sc = sc;
		this.totalCnt = totalCnt;
		doPagine(sc, totalCnt);
	}
	
	public PageHandler2(int totalCnt, int page, int pageSize) {
		this(new SearchCondition(page, pageSize), totalCnt);
	}
	
	public PageHandler2(int totalCnt, int page) {
		this(new SearchCondition(page, 10), totalCnt);
	}
	
	public void doPagine(SearchCondition sc, int totalCnt) {
		totalPage = (int)Math.ceil(totalCnt/(double)sc.getPageSize());
		beginPage = (sc.getPage()-1)/naviSize*naviSize+1;
		endPage = Math.min(beginPage+naviSize-1, totalPage);
		showPrev = beginPage!=1;
		showNext = endPage!=totalPage;
	}
	
	public SearchCondition getSc() {
		return sc;
	}
	public void setSc(SearchCondition sc) {
		this.sc = sc;
	}
	public int getTotalCnt() {
		return totalCnt;
	}
	public void setTotalCnt(int totalCnt) {
		this.totalCnt = totalCnt;
	}
	public int getNaviSize() {
		return naviSize;
	}
	public void setNaviSize(int naviSize) {
		this.naviSize = naviSize;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getBeginPage() {
		return beginPage;
	}
	public void setBeginPage(int beginPage) {
		this.beginPage = beginPage;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
	public boolean isShowPrev() {
		return showPrev;
	}
	public void setShowPrev(boolean showPrev) {
		this.showPrev = showPrev;
	}
	public boolean isShowNext() {
		return showNext;
	}
	public void setShowNext(boolean showNext) {
		this.showNext = showNext;
	}
	@Override
	public String toString() {
		return "PageHandler2 [sc=" + sc + ", totalCnt=" + totalCnt + ", naviSize=" + naviSize + ", totalPage="
				+ totalPage + ", beginPage=" + beginPage + ", endPage=" + endPage + ", showPrev=" + showPrev
				+ ", showNext=" + showNext + "]";
	}	
}