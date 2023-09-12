package com.capsule.youkids.user.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.capsule.youkids.user.entity.User;

public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByEmail(String email);

    Optional<User> findByProviderId(String providerId);

    Optional<User> findByUserId(UUID userId);

}
