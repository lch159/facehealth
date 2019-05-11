package com.demo.facehealth.service;


import com.demo.facehealth.mapper.ImageMapper;
import com.demo.facehealth.model.Image;
import com.demo.facehealth.model.User;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * https://blog.csdn.net/ji519974770/article/details/80962371
 */
@Service
public class FunctionService {

    @Resource
    private ImageMapper imageMapper;

    /**
     * to execute a shell, for image processing
     *
     * @param shellPath
     * @param params
     * @return -2 : fill to execute; otherwise : command line output
     */
    public int execShell(String shellPath, String... params) {
        StringBuilder command = new StringBuilder(shellPath).append(" ");
        for (String param : params) {
            command.append(param).append(" ");
        }

        BufferedReader br = null;
        StringBuilder sb = null;
        try {
            Process process = Runtime.getRuntime().exec(command.toString());
            process.waitFor();

            br = new BufferedReader(new InputStreamReader(process.getInputStream()));
            sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        } catch (Exception e) {
            return -2;
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return "".equals(sb.toString()) ? 0 : Integer.parseInt(sb.toString());
    }

    public int insertImage(String path, User user) {
        Image image = new Image();
        image.setOwnerid(user.getId());
        image.setPath(path);
        imageMapper.add(image);
        return image.getImageid();
    }

    public Image findImage(int imageid){
        Image image = new Image();
        image.setImageid(imageid);
        Image resuktImage = imageMapper.findOne(image);
        return resuktImage;
    }

    public Image[] findUserImages(User user){
        Image image[] = imageMapper.findUserImage(user.getId());
        return image;
    }

    public int decodeToken(String token){
        System.out.println("token is ");
        System.out.println(token);

        return 1;
    }

}

