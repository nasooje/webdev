package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.core.io.Resource;

import com.example.demo.model.User;
import com.example.demo.service.AdminService;
import com.example.demo.service.UserService;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {
    @Autowired
    private AdminService adminService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String fileExplore(HttpSession session, Model model) throws IOException {
        return "admin";
    }

    @GetMapping("/users")
    public String getAllUserList(Model model) throws IOException {
        List<User> userList = userService.getAllUser();

        model.addAttribute("userList", userList);
        return "admin-user";
    }

    @GetMapping("/view")
    public String view(
            @RequestParam(name = "search", required = false) String query,
            @RequestParam String path,
            Model model) throws IOException {

        Path basePath = Paths.get(path);

        if (Files.isDirectory(basePath)) {
            List<String> files;

            if (query != null && !query.isEmpty()) {
                String command = "find \"" + path + "\" -type f | grep \"" + query + "\"";
                ProcessBuilder pb = new ProcessBuilder("sh", "-c", command);
                pb.redirectErrorStream(true);

                Process process = pb.start();
                BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));

                files = new ArrayList<>();
                String line;
                while ((line = reader.readLine()) != null) {
                    String relativePath = line.replaceFirst("^" + path + "/?", "");
                    files.add(relativePath);
                }

                process.destroy();
            } else {
                files = adminService.getFileList(path);
            }

            model.addAttribute("files", files);
            model.addAttribute("path", path);
            return "admin-view";
        } else {
            return "redirect:/admin/viewFile?path=" + path;
        }
    }

    @GetMapping("/viewFile")
    public ResponseEntity<Resource> viewFile(
            @RequestParam String path, HttpSession session) {
        try {
            Path filePath = Paths.get(path).normalize();
            Resource resource = new UrlResource(filePath.toUri());

            if (!resource.exists() || !resource.isReadable()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }

            String contentType = Files.probeContentType(filePath);
            if (contentType == null) {
                contentType = "application/octet-stream";
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + resource.getFilename() + "\"")
                    .body(resource);

        } catch (MalformedURLException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

}