package dto;
import java.sql.Timestamp;
public class FaqDto {
    private int faqId;
    private String category;
    private String question;
    private String answer;
    private Timestamp createdDate;
    private Timestamp updatedDate;
    private boolean isActive;
    private int sortOrder;
    
    // 기본 생성자
    public FaqDto() {}
    
    // 생성자
    public FaqDto(String category, String question, String answer) {
        this.category = category;
        this.question = question;
        this.answer = answer;
        this.isActive = true;
    }
    
    // Getter와 Setter 메소드들
    public int getFaqId() {
        return faqId;
    }
    
    public void setFaqId(int faqId) {
        this.faqId = faqId;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public String getQuestion() {
        return question;
    }
    
    public void setQuestion(String question) {
        this.question = question;
    }
    
    public String getAnswer() {
        return answer;
    }
    
    public void setAnswer(String answer) {
        this.answer = answer;
    }
    
    public Timestamp getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
    
    public Timestamp getUpdatedDate() {
        return updatedDate;
    }
    
    public void setUpdatedDate(Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    public int getSortOrder() {
        return sortOrder;
    }
    
    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }
    
    // 카테고리 이름을 한글로 반환하는 메소드
    public String getCategoryDisplayName() {
        switch(category) {
            case "booking": return "예약/결제";
            case "account": return "계정/회원";
            case "service": return "서비스";
            case "refund": return "취소/환불";
            default: return category;
        }
    }
    
    // 답변 미리보기 (100자 제한)
    public String getAnswerPreview() {
        if (answer == null) return "";
        String preview = answer.replace("\n", " ");
        return preview.length() > 100 ? preview.substring(0, 100) + "..." : preview;
    }
}