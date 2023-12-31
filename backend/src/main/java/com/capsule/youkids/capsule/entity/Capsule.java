package com.capsule.youkids.capsule.entity;

import com.capsule.youkids.user.entity.User;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@NoArgsConstructor
public class Capsule {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int capsuleId;

    @Column
    private int year;

    @Column
    private String url;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @OneToMany(mappedBy = "capsule", fetch = FetchType.LAZY)
    private List<Memory> memories = new ArrayList<>();

    @Builder
    public Capsule(int year, String url, User user) {
        this.year = year;
        this.url = url;
        this.user = user;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
