package com.capsule.youkids.user.dto.RequestDto;

import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ModifyMyInfoRequestDto {

    private String email;

    private String nickname;

    private UUID partnerId;

    private boolean isPartner;

}