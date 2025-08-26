package com.example.demo.service;

import java.util.List;
import java.util.UUID;

import com.example.demo.model.User;
import com.example.demo.dao.UserDao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@Service
public class UserService {

    private static final String PROFILE_IMAGE_DIR = "profile";

    @Autowired
    private UserDao userDao;

    public User registerUser(String username, String password) {
        User existUser = userDao.findByUsername(username);
        if (existUser != null) {
            return null;
        }

        User user = new User();
        UUID uuid4 = UUID.randomUUID();
        user.setUsername(username);
        user.setPassword(password);
        user.setUuid(uuid4.toString());
        return userDao.save(user);
    }

    public User loginUser(String username, String password) {
        User user = userDao.login(username, password);
        if (user != null) {
            return user;
        }
        return null;
    }

    public List<User> getAllUser() {
        List<User> userList = userDao.getAllUser();
        if (userList != null) {
            return userList;
        }
        return null;
    }
    
    public boolean updateUsername(String uuid, String newUsername) {
        User existUser = userDao.findByUsername(newUsername);
        if (existUser != null && !existUser.getUuid().equals(uuid)) {
            return false;
        }
        return userDao.updateUsername(uuid, newUsername);
    }
    
    public boolean updatePassword(String uuid, String newPassword) {
        return userDao.updatePassword(uuid, newPassword);
    }
    
    public boolean verifyCurrentPassword(String uuid, String currentPassword) {
        User user = userDao.findByUuid(uuid);
        return user != null && user.getPassword().equals(currentPassword);
    }
    
    public String saveProfileImage(String uuid, MultipartFile file) throws IOException {
        Path uploadPath = Paths.get(PROFILE_IMAGE_DIR);
        Files.createDirectories(uploadPath);
        
        String originalFilename = file.getOriginalFilename();
        String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String newFilename = uuid + fileExtension;
        
        Path filePath = uploadPath.resolve(newFilename);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        
        userDao.updateProfileImage(uuid, newFilename);
        
        return newFilename;
    }
    
    public User getUserByUuid(String uuid) {
        return userDao.findByUuid(uuid);
    }
}
