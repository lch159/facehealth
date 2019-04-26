package com.demo.facehealth.controller;

import com.alibaba.fastjson.JSONObject;
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
    static String ImageUploadDir = "";
    static String HandleShellPath = "";
    @Autowired
    public FunctionController(FunctionService functionService) {
        this.functionService = functionService;
    }




    /**
     * 上传图片
     * //blog.csdn.net/j903829182/article/details/78406778
     * @param file
     * @return image path
     */
    @RequestMapping(value = "/uploadImage", method = RequestMethod.POST)
    public Object uploadImage(@RequestParam(value = "file") MultipartFile file) throws RuntimeException {
        JSONObject jsonObject = new JSONObject();
        if (file.isEmpty()) {
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
        File dest = new File(filePath + fileName);
        // 检测是否存在目录
        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }
        try {
            String path = dest.getPath()+dest.getName();
            file.transferTo(dest);
            jsonObject.put("result","成功");
            jsonObject.put("downloadpath",path);
            return jsonObject;
        } catch (IllegalStateException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
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
        String path = ImageUploadDir + filename;

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