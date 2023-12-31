package com.capsule.youkids.capsule.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;

@Getter
public class MemoryResponseDto {

    private long memoryId;
    private int month;
    private int day;
    private List<MemoryImageDto> memoryImageDtoList;

    @Builder
    public MemoryResponseDto(long memoryId, int month, int day, List<MemoryImageDto> memoryImageDtoList) {
        this.memoryId = memoryId;
        this.month = month;
        this.day = day;
        this.memoryImageDtoList = memoryImageDtoList;
    }

    public static class MemoryImageDto {

        String url;
        List<Long> childrenList;

        public MemoryImageDto(String url, List<Long> childrenList) {
            this.url = url;
            this.childrenList = childrenList;
        }

        public String getUrl() {
            return url;
        }

        public List<Long> getChildrenList() {
            return childrenList;
        }
    }
}
