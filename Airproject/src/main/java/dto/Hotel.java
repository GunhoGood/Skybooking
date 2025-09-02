package dto;

import java.sql.Timestamp;
import java.text.NumberFormat;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

public class Hotel {
    private int id;
    private String name;
    private String location;
    private String region;
    private String description;
    private int price;
    private int starRating;
    private double rating;
    private String imageUrl;
    private String category;
    private String amenitiesStr;  // DB에 저장된 문자열 (쉼표로 구분)
    private Timestamp createDate;
    private int likeCount;
    
    // 기본 생성자
    public Hotel() {}
    
    // 모든 필드를 포함한 생성자
    public Hotel(int id, String name, String location, String region, String description, 
                 int price, int starRating, double rating, String imageUrl, String category, 
                 String amenitiesStr, Timestamp createDate, int likeCount) {
        this.id = id;
        this.name = name;
        this.location = location;
        this.region = region;
        this.description = description;
        this.price = price;
        this.starRating = starRating;
        this.rating = rating;
        this.imageUrl = imageUrl;
        this.category = category;
        this.amenitiesStr = amenitiesStr;
        this.createDate = createDate;
        this.likeCount = likeCount;
    }
    
    // Getter와 Setter 메서드들
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public String getRegion() {
        return region;
    }
    
    public void setRegion(String region) {
        this.region = region;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public int getPrice() {
        return price;
    }
    
    public void setPrice(int price) {
        this.price = price;
    }
    
    public int getStarRating() {
        return starRating;
    }
    
    public void setStarRating(int starRating) {
        this.starRating = starRating;
    }
    
    public double getRating() {
        return rating;
    }
    
    public void setRating(double rating) {
        this.rating = rating;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public String getAmenitiesStr() {
        return amenitiesStr;
    }
    
    public void setAmenitiesStr(String amenitiesStr) {
        this.amenitiesStr = amenitiesStr;
    }
    
    public Timestamp getCreateDate() {
        return createDate;
    }
    
    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }
    
    public int getLikeCount() {
        return likeCount;
    }
    
    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }
    
    // 편의 메서드들
    
    /**
     * 편의시설 문자열을 리스트로 반환
     */
    public List<String> getAmenities() {
        if (amenitiesStr == null || amenitiesStr.trim().isEmpty()) {
            return Arrays.asList();
        }
        return Arrays.asList(amenitiesStr.split(","));
    }
    
    /**
     * 가격을 포맷팅해서 반환 (쉼표 포함)
     */
    public String getFormattedPrice() {
        NumberFormat formatter = NumberFormat.getNumberInstance(Locale.KOREA);
        return formatter.format(price);
    }
    
    /**
     * 평점을 소수점 1자리로 포맷팅
     */
    public String getFormattedRating() {
        return String.format("%.1f", rating);
    }
    
    /**
     * 지역별 한글명 반환
     */
    public String getRegionDisplayName() {
        switch (region) {
            case "seoul": return "서울";
            case "busan": return "부산";
            case "jeju": return "제주";
            case "gyeonggi": return "경기";
            case "gangwon": return "강원";
            case "chungbuk": return "충북";
            case "chungnam": return "충남";
            case "jeonbuk": return "전북";
            case "jeonnam": return "전남";
            case "gyeongbuk": return "경북";
            case "gyeongnam": return "경남";
            default: return region;
        }
    }
    
    /**
     * 카테고리별 한글명 반환
     */
    public String getCategoryDisplayName() {
        switch (category) {
            case "luxury": return "럭셔리";
            case "business": return "비즈니스";
            case "resort": return "리조트";
            case "pension": return "펜션";
            case "motel": return "모텔";
            case "guesthouse": return "게스트하우스";
            default: return category;
        }
    }
    
    /**
     * 이미지 URL이 없을 경우 기본 이미지 반환
     */
    public String getSafeImageUrl() {
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=200&fit=crop";
        }
        return imageUrl;
    }
    
    @Override
    public String toString() {
        return "Hotel{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", location='" + location + '\'' +
                ", region='" + region + '\'' +
                ", price=" + price +
                ", starRating=" + starRating +
                ", rating=" + rating +
                ", category='" + category + '\'' +
                '}';
    }
}