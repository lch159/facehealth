package com.demo.facehealth.controller;

import com.alibaba.fastjson.JSONObject;
import com.demo.facehealth.model.User;
import com.demo.facehealth.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user")
public class UserController {
    private UserService userService;


    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }


    /**
     * 用户注册接口
     *
     * @param user
     * @return
     */
    @PostMapping("/register")
    public Object add(User user) {
        if (userService.findByName(user.getName()) != null) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("error", "用户名已被使用");
            return jsonObject;
        }
        return userService.add(user);
    }

    /**
     * 用户登录接口
     *
     * @param user
     * @return
     */
    @PostMapping("/login")
    public Object login(User user) {
        User userInDataBase = userService.findByName(user.getName());
        JSONObject jsonObject = new JSONObject();
        if (userInDataBase == null) {
            jsonObject.put("message", "用户不存在");
        } else if (!userService.comparePassword(user, userInDataBase)) {
            jsonObject.put("message", "密码不正确");
        } else {
            String token = userService.getToken(userInDataBase);
            jsonObject.put("token", token);
            jsonObject.put("user", userInDataBase);
        }
        return jsonObject;
    }


    @GetMapping("{id}")
    public Object findById(@PathVariable int id) {
        return userService.findById(id);
    }
}