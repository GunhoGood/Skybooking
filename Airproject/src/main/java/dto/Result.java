package dto;

public class Result {
    public boolean success;
    public String title;
    public String message;
    public String foundId;

    public Result(boolean success, String title, String message, String foundId) {
        this.success = success;
        this.title = title;
        this.message = message;
        this.foundId = foundId;
    }

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getFoundId() {
		return foundId;
	}

	public void setFoundId(String foundId) {
		this.foundId = foundId;
	}
    
}