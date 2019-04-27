package com.demo.facehealth.service;


import org.springframework.stereotype.Service;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * https://blog.csdn.net/ji519974770/article/details/80962371
 */
@Service
public class FunctionService {

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



}

