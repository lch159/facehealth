package com.demo.facehealth.mapper;

import com.demo.facehealth.model.User;

public interface UserMapper {
    void add(User user);

    User findOne(User user);
}