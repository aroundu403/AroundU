package DTO;

import lombok.Data;

@Data
public class DataResponse {
    private int code;
    private String message;
    private Object data;

    public DataResponse(int code, String message, Object data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }
}


