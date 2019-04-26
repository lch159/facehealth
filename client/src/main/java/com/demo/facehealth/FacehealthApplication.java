package com.demo.facehealth;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.demo.facehealth.mapper")
public class FacehealthApplication {

    public static void main(String[] args) {
        SpringApplication.run(FacehealthApplication.class, args);
    }

}
