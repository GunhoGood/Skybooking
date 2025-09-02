package util;

public class PageHandler {
	private int totalCnt; // 총 게시물
	private int pageSize = 10; // 한 페이지당 몇개의 게시물을 보여줄지
	private int naviSize = 10; // 1~10
	private int totalPage; // 총 페이지수
	private int page; // 현재 페이지
	private int beginPage; // 시작 페이지
	private int endPage; // 끝 페이지
	private boolean showPrev; // 이전페이지를 보여줄 수 있는지 -> 1!= beginPage
	private boolean showNext; // 다음페이지를 보여줄 수 있는지 -> totalPage!= endPage
	
	
	
	public PageHandler(int totalCnt, int pageSize, int naviSize, int page) {
		this.page = page;
		System.out.println(totalCnt);
		this.totalCnt = totalCnt;
		this.pageSize = pageSize;
		this.naviSize = naviSize;
		
		totalPage = (int)Math.ceil(totalCnt/(double)pageSize);
		beginPage = (page-1)/naviSize*naviSize+1;
		endPage = Math.min(beginPage+naviSize-1, totalPage);
		showPrev = beginPage!=1;
		showNext = endPage!=totalPage;
	}
	
	public PageHandler(int totalCnt, int page) {
		this.page = page;
		this.totalCnt = totalCnt;
		
		totalPage = (int)Math.ceil(totalCnt/(double)pageSize);
		beginPage = (page-1)/naviSize*naviSize+1;
		endPage = Math.min(beginPage+naviSize-1, totalPage);
		showPrev = beginPage!=1;
		showNext = endPage!=totalPage;
	}
	
	
    @Override
	public String toString() {
		return "PageHandler [totalCnt=" + totalCnt + ", pageSize=" + pageSize + ", naviSize=" + naviSize
				+ ", totalPage=" + totalPage + ", page=" + page + ", beginPage=" + beginPage + ", endPage=" + endPage
				+ ", showPrev=" + showPrev + ", showNext=" + showNext + "]";
	}

	public void print() { 
        System.out.println("page="+ page);
        System.out.print(showPrev? "PREV " : "");

        for(int i=beginPage;i<=endPage;i++) {
            System.out.print(i+" ");
        }
        System.out.println(showNext? " NEXT" : "");
    }
    

    
    public String pagingStr(String reqUrl) {
        String pagingStr = "";
        // 단계 4 : '이전 페이지 블록 바로가기' 출력
        if (showPrev) {
            pagingStr += "<a href='" + reqUrl + "?page=" + (beginPage - 1)+"'>&lt;</a>";
        }
        // 단계 5 : 각 페이지 번호 출력
        for(int i= beginPage; i<=endPage; i++) {
        	if(i==page) pagingStr += "&nbsp;<a class='check' href='" + reqUrl + "?page=" + i+ "'>" + i + "</a>&nbsp;";
        	else pagingStr += "&nbsp;<a href='" + reqUrl + "?page=" + i+ "'>" + i + "</a>&nbsp;";
        }

        // 단계 6 : '다음 페이지 블록 바로가기' 출력
        if (showNext) {
            pagingStr += "<a href='" + reqUrl + "?page=" + (endPage+1)+"'>&gt;</a>";
        }
        return pagingStr;
    }

    
	public int getTotalCnt() {
		return totalCnt;
	}

	public void setTotalCnt(int totalCnt) {
		this.totalCnt = totalCnt;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
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

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
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

	public PageHandler() {
		super();
	}


}