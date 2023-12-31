package com.capsule.youkids.group.service;

import com.capsule.youkids.group.dto.request.RegistUserRequest;
import com.capsule.youkids.group.dto.request.UpdateGroupRequest;
import com.capsule.youkids.group.dto.response.GroupResponse;
import com.capsule.youkids.group.dto.response.UserResponse;
import com.capsule.youkids.group.dto.request.GroupUserRequest;
import java.util.List;
import java.util.UUID;

public interface GroupService {

    // 그룹에 사람 있는지 확인하기
    public boolean checkUserInGroup(RegistUserRequest registUserRequest) throws Exception;

    // 리더가 그룹에 사람 추가하기
    public void addUserInGroup(RegistUserRequest registUserRequest) throws Exception;

    // 리더가 그룹에서 사람 제거하기
    public void deleteUserFromGroup(GroupUserRequest groupUserRequest) throws Exception;

    // 유저가 속한 모든 그룹 불러오기
    public List<GroupResponse> getAllJoinedGroup(UUID id) throws Exception;

    // 그룹에 속한 모든 유저 불러오기
    public List<UserResponse> getAllJoinedUser(UUID groupId) throws Exception;

    // 유저가 자기가 속한 그룹 이름 바꾸기
    public void updateGroupName(UpdateGroupRequest updateGroupRequest) throws Exception;
}
