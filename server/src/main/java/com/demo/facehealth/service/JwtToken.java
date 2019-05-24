package com.demo.facehealth.service;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTCreator;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.demo.facehealth.model.User;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * JwtToken 
 */
public class JwtToken {

    //密钥  
    private static final String SECRET = "secret";

    //jackson  
    private static ObjectMapper mapper = new ObjectMapper();

    /**
     * header数据 
     * @return
     */
    private static Map<String, Object> createHead() {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("typ", "JWT");
        map.put("alg", "HS256");
        return map;
    }

    /**
     * 生成token 
     *
     * @param obj    对象数据
     * @return
     */
    public static String sign(User obj) {
        String result = "";
        JWTCreator.Builder builder = JWT.create();
        try {
            builder.withHeader(createHead())//header
                    .withSubject(mapper.writeValueAsString(obj));  //payload
            result = builder.sign(Algorithm.HMAC256(SECRET));

        }catch (Exception e){
            System.out.println(e.getMessage());
        }

        return result;
    }

    /**
     * 解密 
     * @param token   token字符串 

     * @return
     */
    public static User unsign(String token)  {
        try {
            JWTVerifier verifier = JWT.require(Algorithm.HMAC256(SECRET)).build();
            DecodedJWT jwt = verifier.verify(token);
            String subject = jwt.getSubject();
            return mapper.readValue(subject, User.class);
        }catch (Exception e){
            System.out.println(e.getMessage());
        }
        return null;
    }

}