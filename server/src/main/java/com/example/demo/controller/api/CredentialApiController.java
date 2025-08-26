package com.example.demo.controller.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/credential")
@Tag(name = "Credential API", description = "Return Credential")
public class CredentialApiController {

    @GetMapping("/mysql/root")
    @Operation(summary = "MySQL 계정정보 반환")
    public Map<String, String> getMySQLUser() {
        Map<String, String> credentials = new HashMap<>();
        credentials.put("username", "root");
        credentials.put("password", "root");

        return credentials;
    }

    @GetMapping("/mysql/connect")
    @Operation(summary = "MySQL 접속정보 반환")
    public Map<String, String> getDatabaseConnectUrl() {
        Map<String, String> credentials = new HashMap<>();
        credentials.put("driver-class", "com.mysql.cj.jdbc.Driver");
        credentials.put("url",
                "jdbc:mysql://db:3306/mydb?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Seoul&allowPublicKeyRetrieval=true&useSSL=false");

        return credentials;
    }

}
