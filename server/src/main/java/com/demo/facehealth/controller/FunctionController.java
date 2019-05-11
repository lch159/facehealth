package com.demo.facehealth.controller;

import com.alibaba.fastjson.JSONObject;
import com.demo.facehealth.model.Image;
import com.demo.facehealth.model.User;
import com.demo.facehealth.service.FunctionService;
import com.demo.facehealth.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;

@RestController
@RequestMapping("/function")
public class FunctionController {
    private FunctionService functionService;
    private UserService userService;

    static String ImageUploadDir = "G:\\DesktopDir\\Projects\\image\\";
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
        int userid = functionService.decodeToken(token);
        System.out.printf("userid is :%d\n",userid);
        User user = userService.findById(1);
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

        // 文件上传后的路径
        String filePath = ImageUploadDir;
        // 解决中文问题，liunx下中文路径，图片显示问题
        // fileName = UUID.randomUUID() + suffixName;
        File dest = new File(filePath + user.getName()+ "-" + fileName);
        // 检测是否存在目录
        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }
        try {
            String path = dest.getPath();
            file.transferTo(dest);
            functionService.insertImage(path,user);
            jsonObject.put("result","成功");
            jsonObject.put("downloadpath",path);
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
    @RequestMapping(value="/download",method=RequestMethod.GET)
    public void download(@RequestParam(value="filename")String filename,
                         HttpServletRequest request,
                         HttpServletResponse response) throws IOException {
        //模拟文件，myfile.txt为需要下载的文件
        //String path = request.getSession().getServletContext().getRealPath("/")+"/pic/"+filename;
        String path = filename;//ImageUploadDir + filename;

        System.out.println(path);
        //获取输入流
        InputStream bis = new BufferedInputStream(new FileInputStream(new File(path)));
        //转码，免得文件名中文乱码
        filename = URLEncoder.encode(filename,"UTF-8");
        //设置文件下载头
        response.addHeader("Content-Disposition", "attachment;filename=" + filename);
        //1.设置文件ContentType类型，这样设置，会自动判断下载文件类型
        response.setContentType("multipart/form-data");
        BufferedOutputStream out = new BufferedOutputStream(response.getOutputStream());
        int len = 0;
        while((len = bis.read()) != -1){
            out.write(len);
            out.flush();
        }
        out.close();
    }


    /**
     * 根据图片id获取图片的路径
     *
     * @param imageid
     * @param token
     * @return
     */
    @RequestMapping(value="/getImagePath",method=RequestMethod.GET)
    public Object getImagePath(@RequestParam Integer imageid, @RequestParam String token){
        JSONObject jsonObject = new JSONObject();
        if(imageid==null){
            jsonObject.put("result","失败");
            jsonObject.put("message","id为空");
            return jsonObject;
        }
        Image image = functionService.findImage(imageid);
        int userid = functionService.decodeToken(token);
        if(userid != image.getOwnerid()){
            jsonObject.put("result","失败");
            jsonObject.put("message","无权访问此图片");
            return jsonObject;
        }
        jsonObject.put("result","成功");
        jsonObject.put("path",image.getPath());
        return jsonObject;
    }

    /**
     * 获取用户的全部图片
     *
     * @param token
     * @return
     */
    @RequestMapping(value="/getUserImagePath",method=RequestMethod.GET)
    public Object getUserImagePath( @RequestParam String token){
        JSONObject jsonObject = new JSONObject();
        int userid = functionService.decodeToken(token);
        User user = new User();
        user.setId(userid);
        Image image[] = functionService.findUserImages(user);

        if(image.length==0){
            jsonObject.put("result","失败");
            jsonObject.put("message","用户图片库为空");
            return jsonObject;
        }
        String paths = "[";
        String dou = "";
        for (int i=0;i<paths.length();i++){
            paths += dou + "\"" + image[i].getPath() + "\"";
        }
        paths += "]";
        jsonObject.put("result","成功");
        jsonObject.put("paths",paths);
        return jsonObject;
    }



    /**
     * 处理图片
     * @param imagePath
     * @return JSONObject
     */
    @RequestMapping(value = "/handle", method = RequestMethod.POST)
    public Object handleImage(@RequestParam String imagePath)  {
        JSONObject jsonObject = new JSONObject();
        if (functionService.execShell(HandleShellPath,imagePath)<=0)
            jsonObject.put("message", "处理失败");
        else
            jsonObject.put("message", "成功");
        return jsonObject;
    }

}