package com.demo.facehealth.service;


import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.demo.facehealth.mapper.UserMapper;
import com.demo.facehealth.model.User;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Objects;



@Service
public class UserService {

    private static String signKey = "SustechFacePro";

    @Resource
    private UserMapper userMapper;

    public User add(User user) {
        String passwordHash = passwordToHash(user.getPassword());
        user.setPassword(passwordHash);
        userMapper.add(user);
        return findById(user.getId());
    }

    public User findById(int id) {
        User user = new User();
        user.setId(id);
        return userMapper.findOne(user);
    }

    public User findByName(String name) {
        User param = new User();
        param.setName(name);
        return userMapper.findOne(param);
    }

    public boolean comparePassword(User user, User userInDataBase) {
        return Objects.equals(passwordToHash(user.getPassword()), userInDataBase.getPassword()); // 数据库中的 password 已经是 hash，不用转换
    }

    private String passwordToHash(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            digest.update(password.getBytes());
            byte[] src = digest.digest();
            StringBuilder stringBuilder = new StringBuilder();
            // 字节数组转16进制字符串
            for (byte aSrc : src) {
                String s = Integer.toHexString(aSrc & 0xFF);
                if (s.length() < 2) {
                    stringBuilder.append('0');
                }
                stringBuilder.append(s);
            }
            return stringBuilder.toString();
        } catch (NoSuchAlgorithmException ignore) {
        }
        return null;
    }
/*
    public String getToken(User user) {
        String token = "";
        try {
            token = JWT.create()
                    .withAudience(user.getId().toString())          // 将 user id 保存到 token 里面
                    .sign(Algorithm.HMAC256(signKey));              // 以 signKey 作为 token 的密钥
        } catch (UnsupportedEncodingException ignore) {
        }
        return token;
    }

    public int decodeToken(String token){
        //TODO finish this function
        System.out.println("token is ");
        System.out.println(token);

        return 1;
    }
*/
}
