package com.demo.facehealth.controller;

import com.alibaba.fastjson.JSONObject;
import com.demo.facehealth.model.User;
import com.demo.facehealth.service.JwtToken;
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
     * @param
     * @return
     */
    @PostMapping("/register")
    public Object add(@RequestParam  String name, @RequestParam String password) {
        User user = new User();
        user.setName(name);
        user.setPassword(password);
        System.out.println(user);
        if (userService.findByName(user.getName()) != null) {
            JSONObject jsonObject = new JSONObject();

            jsonObject.put("message", "用户名已被使用");
            return jsonObject;
        }
        return userService.add(user);
    }

    /**
     * 用户登录接口
     *
     * @param
     * @return
     */
    @PostMapping("/login")
    public Object login(@RequestParam  String name, @RequestParam String password) {
        User user = new User();
        user.setName(name);
        user.setPassword(password);
        User userInDataBase = userService.findByName(user.getName());
        System.out.println(user);
        JSONObject jsonObject = new JSONObject();
        if (userInDataBase == null) {
            jsonObject.put("result", "失败");
            jsonObject.put("message", "用户不存在");
        } else if (!userService.comparePassword(user, userInDataBase)) {
            jsonObject.put("result", "失败");
            jsonObject.put("message", "密码不正确");
        } else {
            User resultUser = userService.findByName(user.getName());
            jsonObject.put("result", "成功");
            String token = JwtToken.sign(resultUser);
            jsonObject.put("token", token);
        }
        return jsonObject;
    }


    @GetMapping("{id}")
    public Object findById(@PathVariable int id) {
        return userService.findById(id);
    }
}