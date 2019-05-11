package com.demo.facehealth.model;


public class Image {
    private Integer imageid;
    private Integer ownerid;
    private String path;

    @Override
    public String toString() {
        return "Image{" +
                "imageid=" + imageid +
                ", ownerid=" + ownerid +
                ", path='" + path + '\'' +
                '}';
    }

    public Integer getImageid() {
        return imageid;
    }

    public void setImageid(Integer imageid) {
        this.imageid = imageid;
    }

    public Integer getOwnerid() {
        return ownerid;
    }

    public void setOwnerid(Integer ownerid) {
        this.ownerid = ownerid;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }
}