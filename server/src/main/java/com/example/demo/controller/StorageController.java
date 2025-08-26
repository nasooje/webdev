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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.core.io.Resource;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.model.User;
import com.example.demo.service.StorageService;
import com.example.demo.service.UserService;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/storage")
public class StorageController {
    @Autowired
    private StorageService storageService;
    
    @Autowired
    private UserService userService;

    private static final String UPLOAD_DIR = "uploads";

    @GetMapping
    public String listFiles(
            @RequestAttribute(name = "user", required = false) User user, Model model) throws IOException {
        String userUUID = user.getUuid();

        Path userDir = Paths.get(UPLOAD_DIR, userUUID);

        List<String> files = new ArrayList<>();
        if (Files.exists(userDir)) {
            files = Files.list(userDir)
                    .filter(Files::isRegularFile)
                    .map(path -> path.getFileName().toString())
                    .collect(Collectors.toList());
        }

        model.addAttribute("files", files);
        model.addAttribute("isOwnGallery", true);
        return "storage";
    }

    @GetMapping("/upload")
    public String upload(HttpSession session, Model model) {
        return "upload";
    }

    @PostMapping("/upload")
    public String uploadFile(@RequestAttribute(name = "user", required = false) User user,
            @RequestParam("file") MultipartFile file, 
            @RequestParam(value = "description", required = false) String description,
            RedirectAttributes redirectAttributes) {

        try {
            String originalFilename = file.getOriginalFilename();
            String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
            
            String newFilename;
            if (description != null && !description.trim().isEmpty()) {
                newFilename = description.trim() + fileExtension;
                String filePath = storageService.saveFile(user.getUuid(), file, newFilename);
                redirectAttributes.addFlashAttribute("successMessage", "Image uploaded successfully!");
                redirectAttributes.addFlashAttribute("uploadedFile", newFilename);
            } else {
                String filePath = storageService.saveFile(user.getUuid(), file);
                redirectAttributes.addFlashAttribute("successMessage", "Image uploaded successfully!");
                redirectAttributes.addFlashAttribute("uploadedFile", file.getOriginalFilename());
            }
            
            return "redirect:/storage";
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Upload failed: " + e.getMessage());
            return "redirect:/storage/upload";
        }
    }

    @GetMapping("/view")
    public ResponseEntity<Resource> viewFile(
            @RequestParam String file, 
            @RequestParam(required = false) String ownerUuid,
            @RequestAttribute(name = "user", required = false) User user) {
        try {
            String fileOwnerUuid = (ownerUuid != null) ? ownerUuid : user.getUuid();
            
            Path filePath = Paths.get(UPLOAD_DIR, fileOwnerUuid).resolve(file).normalize();
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
    
    @GetMapping("/download")
    public ResponseEntity<Resource> downloadFile(
            @RequestParam String file, 
            @RequestParam(required = false) String ownerUuid,
            @RequestAttribute(name = "user", required = false) User user) {
        try {
            String fileOwnerUuid = (ownerUuid != null) ? ownerUuid : user.getUuid();
            
            Path filePath = Paths.get(UPLOAD_DIR, fileOwnerUuid).resolve(file).normalize();
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
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
                    .body(resource);

        } catch (MalformedURLException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    @GetMapping("/delete")
    public String deleteFile(
            @RequestAttribute(name = "user", required = false) User user,
            @RequestParam String file,
            RedirectAttributes redirectAttributes) {
        try {
            boolean deleted = storageService.deleteFile(user.getUuid(), file);
            if (deleted) {
                redirectAttributes.addFlashAttribute("successMessage", "File deleted successfully!");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Failed to delete file: File not found.");
            }
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to delete file: " + e.getMessage());
        }
        return "redirect:/storage";
    }
}