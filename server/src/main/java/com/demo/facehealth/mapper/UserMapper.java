package com.demo.facehealth.mapper;

import com.demo.facehealth.model.User;
import org.springframework.beans.factory.annotation.Qualifier;

//@Qualifier("UserMapper")
public interface UserMapper {
    void add(User user);

    User findOne(User user);
}