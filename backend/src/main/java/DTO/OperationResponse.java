package DTO;

import lombok.Data;

@Data
public class OperationResponse {
    private int code;
    private String message;

    public OperationResponse(int code, String message) {
        this.code = code;
        this.message = message;
    }
}
