package com.capsule.youkids.global.common.constant;

import lombok.Getter;

@Getter
public enum Code {

    /**
     * 성공 코드
     */
    SUCCESS(true, 1000, "요청에 성공하였습니다."),

    /**
     * 에러 코드
     */
    // 코스 에러 (1001 ~ 1010)
    COURSE_NOT_FOUND(false, 1001, "코스를 찾을 수 없습니다."),
    COURSE_LIST_NOT_FOUND(false, 1002, "생성된 코스가 없습니다."),
    COURSE_PLACE_ITEM_NOT_FOUND(false, 1003, "코스의 정보를 찾을 수 없습니다."),
    COURSE_COUNT_FULL(false, 1004, "더 이상 코스를 생성할 수 없습니다."),
    COURSE_AUTH_FAIL(false, 1005, "수정 및 삭제를 할 권한이 없습니다."),

    // 유저 에러 (1011 ~ 1020)
    USER_NOT_FOUND(false, 1011, "존재하지 않는 유저입니다."),

    // 장소 에러 (1021 ~ 1030)
    PLACE_NOT_FOUND(false, 1021, "해당 장소를 찾을 수 없습니다."),
    PLACE_BOOKMARK_FAILED(false, 1022, "Bookmark 삽입 또는 삭제 실패."),
    PLACE_BOOKMARK_MONGO_FAILED(false, 1023, "Bookmark Mongo 저장 실패"),
    PLACE_BOOKMARK_NOT_FOUND(false, 1023, "찜한 장소가 없습니다."),
    PLACE_BOOKMARK_FULL(false, 1024, "찜 리스트가 최대치입니다."),
    S3_SAVE_ERROR(false, 1025, "S3 저장 실패"),
    PLACE_REVIEW_NOT_FOUND(false, 1026, "해당 리뷰를 찾을 수 없습니다."),
    PLACE_REVIEW_DELETE_FAILED(false, 1027, "리뷰 삭제 실패"),
    PLACE_REVIEW_IMAGE_DELETE_FAILED(false, 1028, "리뷰 이미지 삭제 실패"),
    PlACE_DIFFERENT_USER(false, 1029, "리뷰 작성자가 아닙니다.");

    // (1031 ~ 1040)


    private final boolean isSuccess;
    private final int code;
    private final String message;

    Code(boolean isSuccess, int code, String message) {
        this.isSuccess = isSuccess;
        this.code = code;
        this.message = message;
    }
}