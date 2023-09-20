package com.capsule.youkids.place.dto;

import com.capsule.youkids.place.entity.Place;
import com.capsule.youkids.place.entity.PlaceImage;
import com.capsule.youkids.place.entity.Review;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class PlaceInfoDto {

    private int placeId;
    private String name;
    private String address;
    private double latitude;
    private double longitude;
    private String phoneNumber;
    private String category;
    private String homepage;
    private String description;
    private int reviewSum;
    private int reviewNum;
    private boolean subwayFlag;
    private String subwayId;
    private Double subwayDistance;
    private List<String> images;

    @Builder
    public PlaceInfoDto(int placeId, String name, String address, double latitude, double longitude,
            String phoneNumber, String category, String homepage, String description, int reviewSum,
            int reviewNum, boolean subwayFlag, String subwayId, double subwayDistance,
            List<String> images) {
        this.placeId = placeId;
        this.name = name;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.phoneNumber = phoneNumber;
        this.category = category;
        this.homepage = homepage;
        this.description = description;
        this.reviewSum = reviewSum;
        this.reviewNum = reviewNum;
        this.subwayFlag = subwayFlag;
        this.subwayId = subwayId;
        this.subwayDistance = subwayDistance;
        this.images = images;
    }

    public PlaceInfoDto(Place place) {
        this.placeId = place.getPlaceId();
        this.name = place.getName();
        this.address = place.getAddress();
        this.latitude = place.getLatitude();
        this.longitude = place.getLongitude();
        this.phoneNumber = place.getPhoneNumber();
        this.category = place.getCategory();
        this.homepage = place.getHomepage();
        this.description = place.getDescription();
        this.reviewNum = place.getReviewNum();
        this.reviewSum = place.getReviewSum();
        this.subwayFlag = place.isSubwayFlag();
        this.subwayId = place.getSubwayId();
        this.subwayDistance = place.getSubwayDistance();
        this.images = place.getImages().stream().map((image)->{return image.getUrl();}).collect(
                Collectors.toList());
    }
}