package com.demo.facehealth.mapper;

import com.demo.facehealth.model.Image;

public interface ImageMapper {
    void add(Image image);

    Image findOne(Image image);

    Image[] findUserImage(Integer ownerid);
}