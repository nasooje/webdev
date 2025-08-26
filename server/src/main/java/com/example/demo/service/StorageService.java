package com.example.demo.service;

import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.*;
import org.springframework.web.multipart.MultipartFile;

@Service
public class StorageService {
    private static final String UPLOAD_DIR = "uploads";

    public String saveFile(String uuid, MultipartFile file) throws IOException {
        Path uploadPath = Paths.get(UPLOAD_DIR, uuid);
        Files.createDirectories(uploadPath);

        Path filePath = uploadPath.resolve(file.getOriginalFilename());
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return filePath.toString();
    }
    
    public String saveFile(String uuid, MultipartFile file, String customFilename) throws IOException {
        Path uploadPath = Paths.get(UPLOAD_DIR, uuid);
        Files.createDirectories(uploadPath);

        Path filePath = uploadPath.resolve(customFilename);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return filePath.toString();
    }
    
    public boolean deleteFile(String uuid, String fileName) throws IOException {
        Path filePath = Paths.get(UPLOAD_DIR, uuid).resolve(fileName).normalize();
        return Files.deleteIfExists(filePath);
    }
}