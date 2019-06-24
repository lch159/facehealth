package com.demo.facehealth.controller;

import com.alibaba.fastjson.JSONObject;
import com.demo.facehealth.model.Image;
import com.demo.facehealth.model.User;
import com.demo.facehealth.service.FunctionService;
import com.demo.facehealth.service.JwtToken;
import com.demo.facehealth.service.UserService;
import com.fasterxml.jackson.databind.ser.std.StdArraySerializers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.Date;

@RestController
@RequestMapping("/function")
public class FunctionController {
    private FunctionService functionService;
    private UserService userService;
    static String ImageUploadDir = "/home/emilab1/face/images/upload/";
    static String ImagefinishedDir = "/home/emilab1/face/images/finished/";
    static int userIDLength = 8;
//    static String ImageUploadDir = "G:\\DesktopDir\\Projects\\image\\upload";
//    static String ImagefinishedDir = "G:\\DesktopDir\\Projects\\image\\finished";
    @Autowired
    public FunctionController(FunctionService functionService, UserService userService) {
        this.functionService = functionService;
        this.userService = userService;
    }


    /**
     * 上传图片
     *
     * @param file
     * @param info: task_age_gender(0 for null, 1 for male, 2 fro female)
     * @return image path
     */
    @RequestMapping(value = "/uploadImage", method = RequestMethod.POST)
    public Object uploadImage(@RequestParam MultipartFile file, @RequestParam String token,@RequestParam String info ) throws RuntimeException {
        JSONObject jsonObject = new JSONObject();
        User tokenUser = JwtToken.unsign(token);
        System.out.printf("token is %s",token);
        System.out.printf("user is :%s\n",tokenUser.toString());
        User user = userService.findByName(tokenUser.getName());
        if(user==null){
            jsonObject.put("result","失败");
            jsonObject.put("message","用户验证失败");
        }
        if (file.isEmpty()) {
            jsonObject.put("result","失败");
            jsonObject.put("message","文件上传失败");
            return jsonObject;
        }
        /** 根据信息构建文件名 */
        String LimitLengthUserID= String.valueOf(user.getId());
        for(int i=0;i<userIDLength-LimitLengthUserID.length();i++){
            LimitLengthUserID = "0"+LimitLengthUserID;
        }
        Date date = new Date();
        String timeStemp = String.valueOf(date.getTime());
        String[] inputInfo = info.split("_");
        String newFileName =
                inputInfo[0]+"_"
                + LimitLengthUserID + "_"
                + inputInfo[1] + "_"
                + inputInfo[2] + "_"
                + timeStemp;
        //获取文件后缀名
        String fileName = file.getOriginalFilename();
        String suffixName = fileName.substring(fileName.lastIndexOf("."));
        File dest = new File(ImageUploadDir + newFileName + suffixName);
        /*
        // 获取文件名
        String fileName = file.getOriginalFilename();
        // 获取文件的后缀名
        String suffixName = fileName.substring(fileName.lastIndexOf("."));
        // 生成时间戳
        Date d = new Date();
        float t = d.getTime();
        String uploadTime = Float.toString(t);

        // 文件上传后的路径
        // 解决中文问题，liunx下中文路径，图片显示问题
        // fileName = UUID.randomUUID() + suffixName;
        File dest = new File(ImageUploadDir + user.getName()+ "-" +uploadTime+ suffixName);
        */

        // 检测是否存在目录
        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }
        try {
            String path = dest.getPath();
            file.transferTo(dest);
            int imageID = functionService.insertImage(path,user);
            /** 构建处理成功后的图片路径 */
            //String handledImagePath = ImagefinishedDir + "F_" + newFileName;
            //int handledImageID = functionService.insertImage(handledImagePath,user);
            jsonObject.put("result","成功");
            jsonObject.put("imagePath",path);

            //jsonObject.put("handledImagePath",handledImagePath);
            jsonObject.put("imageID",imageID);
            //jsonObject.put("handledImageID",handledImageID);

            return jsonObject;
        } catch (IllegalStateException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        jsonObject.put("result","失败");
        jsonObject.put("message","存储失败");
        return jsonObject;
    }

    /**
     * 文件下载
     * @throws IOException
     * @return JSONObject
     */
    @RequestMapping(value="/downloadImage",method=RequestMethod.GET)
    public Object download(@RequestParam(value="downloadPath")String downloadPath,
                         @RequestParam int imageID,
                         @RequestParam String token,
                         HttpServletResponse response) throws IOException {
        //模拟文件，myfile.txt为需要下载的文件
        //String path = request.getSession().getServletContext().getRealPath("/")+"/pic/"+downloadpath;

        JSONObject jsonObject = new JSONObject();
        User tokenUser = JwtToken.unsign(token);
        System.out.printf("user is :%s\n",tokenUser);
        assert tokenUser != null;
        User user = userService.findByName(tokenUser.getName());
        if(user==null){
            jsonObject.put("result","失败");
            jsonObject.put("message","用户验证失败");
            return jsonObject;
        }

        Image image = functionService.findImage(imageID);
        System.out.println("image is " + image);
        if(image!= null && !image.getOwnerid().equals(user.getId())){
            jsonObject.put("result","失败");
            jsonObject.put("message","无权访问此图片");
            return jsonObject;
        }

        String[] dirs = downloadPath.split("/");//ImageUploadDir + downloadPath;
        String filename =dirs[dirs.length-1];
        System.out.println(filename);
        //获取输入流
        InputStream bis = new BufferedInputStream(new FileInputStream(new File(downloadPath)));
        //转码，免得文件名中文乱码
//        downloadPath = URLEncoder.encode(downloadPath,"UTF-8");
        //设置文件下载头
        response.addHeader("Content-Disposition", "attachment;filename=" + filename);
        //1.设置文件ContentType类型，这样设置，会自动判断下载文件类型
        response.setContentType("application/x-download");
        BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
        int len = 0;
        while((len = bis.read()) != -1){
            out.write(len);
            out.flush();
        }
        out.close();
        jsonObject.put("result","成功");
        return jsonObject;
    }


    /**
     * 根据图片id获取图片的路径
     *
     * @param imageid
     * @param token
     * @return
     */
    /*
    @RequestMapping(value="/getImagePath",method=RequestMethod.GET)
    public Object getImagePath(@RequestParam Integer imageid, @RequestParam String token){
        JSONObject jsonObject = new JSONObject();
        if(imageid==null){
            jsonObject.put("result","失败");
            jsonObject.put("message","id为空");
            return jsonObject;
        }
        Image image = functionService.findImage(imageid);
        int userid = userService.decodeToken(token);
        if(userid != image.getOwnerid()){
            jsonObject.put("result","失败");
            jsonObject.put("message","无权访问此图片");
            return jsonObject;
        }
        jsonObject.put("result","成功");
        jsonObject.put("path",image.getPath());
        return jsonObject;
    }*/

    /**
     * 获取用户的全部图片
     *
     * @param token
     * @return
     */
    @RequestMapping(value="/getUserImages",method=RequestMethod.POST)
    public Object getUserImagePath( @RequestParam String token){
        JSONObject jsonObject = new JSONObject();
        User tokenUser = JwtToken.unsign(token);
        System.out.printf("user is :%s\n",tokenUser.toString());
        User user = userService.findByName(tokenUser.getName());
        if(user==null){
            jsonObject.put("result","失败");
            jsonObject.put("message","用户验证失败");
            return jsonObject;
        }
        Image image[] = functionService.findUserImages(user);

        if(image.length==0){
            jsonObject.put("result","失败");
            jsonObject.put("message","用户图片库为空");
            return jsonObject;
        }
        String Ps[] = new String[image.length];
        //String paths = "[";
        String dou = "";
        int ids[] = new int[image.length];
        for (int i=0;i<image.length;i++){
            //paths += dou + "\"" + image[i].getPath() + "\"";
            Ps[i] = image[i].getPath();
            ids[i] = image[i].getImageid();
        }
        //paths += "]";
        jsonObject.put("result","成功");
        jsonObject.put("paths",Ps);
        jsonObject.put("imageIDs",ids);
        return jsonObject;
    }



    /**
     * 处理图片
     * @param imagePath
     * @return JSONObject
     */
    @RequestMapping(value = "/handle", method = RequestMethod.POST)
    public Object handleImage(@RequestParam String imagePath, //@RequestParam int imageID,
                              @RequestParam String token,
                              @RequestParam int task)  {
        JSONObject jsonObject = new JSONObject();

        User tokenUser = JwtToken.unsign(token);

        /*
        System.out.printf("user is :%s\n",tokenUser.toString());
        User user = userService.findByName(tokenUser.getName());
        if(user==null){
            jsonObject.put("result","失败");
            jsonObject.put("message","用户验证失败");
            return jsonObject;
        }

        Image image = functionService.findImage(imageID);
        if(image.getOwnerid()!=user.getId()){
            jsonObject.put("result","失败");
            jsonObject.put("message","无权访问此图片");
            return jsonObject;
        }
        */

        String  result = functionService.execShell(imagePath,task);
        System.out.println("the result of handling is : "+result);
        switch (result){
            case "-1":
                jsonObject.put("result", "失败");
                jsonObject.put("message","非法处理方式");
                break;
            case "-2":
                jsonObject.put("result", "失败");
                jsonObject.put("message","处理程序崩溃");
                break;
            default:
                jsonObject.put("result", "成功");
                jsonObject.put("handledImagePath",ImagefinishedDir+result);
                int handledImageID = functionService.insertImage(ImagefinishedDir+result,tokenUser);
                jsonObject.put("handledImageID", handledImageID);
        }
        return jsonObject;
    }
}