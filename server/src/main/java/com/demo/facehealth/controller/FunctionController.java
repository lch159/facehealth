package com.demo.facehealth.controller;

import com.alibaba.fastjson.JSONObject;
import com.demo.facehealth.model.Image;
import com.demo.facehealth.model.User;
import com.demo.facehealth.service.FunctionService;
import com.demo.facehealth.service.JwtToken;
import com.demo.facehealth.service.UserService;
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
    static String ImageUploadDir = "/home/face_pro/images/";
    //static String ImageUploadDir = "G:\\DesktopDir\\Projects\\image\\";
    static String HandleShellPath = "";
    @Autowired
    public FunctionController(FunctionService functionService, UserService userService) {
        this.functionService = functionService;
        this.userService = userService;
    }


    /**
     * 上传图片
     * from //blog.csdn.net/j903829182/article/details/78406778
     * @param file
     * @return image path
     */
    @RequestMapping(value = "/uploadImage", method = RequestMethod.POST)
    public Object uploadImage(@RequestParam MultipartFile file, @RequestParam String token) throws RuntimeException {
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
        // 检测是否存在目录
        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }
        try {
            String path = dest.getPath();
            file.transferTo(dest);
            int imageID = functionService.insertImage(path,user);
            jsonObject.put("result","成功");
            jsonObject.put("downloadPath",path);
            jsonObject.put("imageID",imageID);
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
        User user = userService.findByName(tokenUser.getName());
        if(user==null){
            jsonObject.put("result","失败");
            jsonObject.put("message","用户验证失败");
            return jsonObject;
        }
        Image image = functionService.findImage(imageID);
        System.out.println("image is " + image);
        if(image!= null && image.getOwnerid()!=user.getId()){
            jsonObject.put("result","失败");
            jsonObject.put("message","无权访问此图片");
            return jsonObject;
        }

        String path = downloadPath;//ImageUploadDir + downloadPath;

        System.out.println(path);
        //获取输入流
        InputStream bis = new BufferedInputStream(new FileInputStream(new File(path)));
        //转码，免得文件名中文乱码
        downloadPath = URLEncoder.encode(downloadPath,"UTF-8");
        //设置文件下载头
        response.addHeader("Content-Disposition", "attachment;downloadPath=" + downloadPath);
        //1.设置文件ContentType类型，这样设置，会自动判断下载文件类型
        response.setContentType("multipart/form-data");
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
        String paths = "[";
        String dou = "";
        int ids[] = new int[image.length];
        for (int i=0;i<image.length;i++){
            paths += dou + "\"" + image[i].getPath() + "\"";
            Ps[i] = image[i].getPath();
            ids[i] = image[i].getImageid();
        }
        paths += "]";
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
    public Object handleImage(@RequestParam String imagePath,@RequestParam int imageID,
                              @RequestParam String token,@RequestParam int way)  {


        JSONObject jsonObject = new JSONObject();
        User tokenUser = JwtToken.unsign(token);
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

        if (functionService.execShell(HandleShellPath,imagePath)<=0)
            jsonObject.put("message", "处理失败");
        else
            jsonObject.put("result", "成功");
        return jsonObject;
    }

}