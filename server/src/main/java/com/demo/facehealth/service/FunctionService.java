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

    static String preprocessPath= "./preprocess.sh";
    static String healthPath = "./acromegaly_cls.sh";
    static String stylePath = "./age_progressor.sh";
    static String sameFacePath = "./recognition.sh";

    @Resource
    private ImageMapper imageMapper;

    /**
     * to execute a shell, for image processing
     *
     * @param imagePath
     * @param task 1: disease diagnosis ; 2: style change ; 3: same face search
     * @return -2 : fill to execute; otherwise : command line output
     */
    public String execShell(String imagePath, int task) {
        String shellPath = "";
        /*
        for (String param : params) {
            command.append(param).append(" ");
        }*/
        switch (task){
            case 1:
                shellPath = healthPath;break;
            case 2:
                shellPath = stylePath;break;
            case 3:
                shellPath = sameFacePath;break;

                default:
                    return "-1";//不存在此種處理方式
        }
        String parts[] = imagePath.split("/");
        String fileName = parts[parts.length-1];
        StringBuilder preprocessCommand = new StringBuilder(preprocessPath).append(" "+fileName);
        StringBuilder command = new StringBuilder(shellPath).append(" "+fileName);
        String result = "";
        System.out.println("command is :"+command);

        BufferedReader br = null;
        try {

            Process preprocess = Runtime.getRuntime().exec(preprocessCommand.toString());
            preprocess.waitFor();

            Process process = Runtime.getRuntime().exec(command.toString());
            process.waitFor();

            br = new BufferedReader(new InputStreamReader(process.getInputStream()));

            String line;
            while ((line = br.readLine()) != null) {
                result = result + line;
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return "-2";
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return result;
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


}

