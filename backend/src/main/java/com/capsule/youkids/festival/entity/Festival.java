package com.capsule.youkids.festival.entity;

import java.time.LocalDate;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Index;

@Getter
@Entity
@Table(name = "festival_child")
@NoArgsConstructor
public class Festival {

    @Id
    @Column(name = "festival_child_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long festivalChildId;

    @Column
    private String eachId;

    @Column
    private String name;

    @Column
    private LocalDate startDate;

    @Column
    private LocalDate endDate;

    @Index(name = "idx_festival_state")
    @Column
    private String state;

    @Column
    private String category;

    @Column
    private String openRun;

    @Column
    private String poster;

    @Column
    private String placeName;

    @Column
    private String placeFacilId;

    @Column
    private String runTime;

    @Column
    private String age;

    @Column
    private String enterprise;

    @Column
    private String price;

    @Column
    private String story;

    @Column
    private String whenTime;

    @Column
    private String member;

    @Builder
    public Festival(Long festivalChildId, String eachId, String name, LocalDate startDate, LocalDate endDate,
            String state, String category, String openRun, String poster, String placeName,
            String placeFacilId, String runTime, String age, String enterprise, String price,
            String story, String whenTime, String member) {
        this.festivalChildId = festivalChildId;
        this.eachId = eachId;
        this.name = name;
        this.startDate = startDate;
        this.endDate = endDate;
        this.state = state;
        this.category = category;
        this.openRun = openRun;
        this.poster = poster;
        this.placeName = placeName;
        this.placeFacilId = placeFacilId;
        this.runTime = runTime;
        this.age = age;
        this.enterprise = enterprise;
        this.price = price;
        this.story = story;
        this.whenTime = whenTime;
        this.member = member;
    }
}
