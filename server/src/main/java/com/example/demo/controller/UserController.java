package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.model.User;
import com.example.demo.service.UserService;

import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
@RequestMapping("/user")
public class UserController {
    
    private static final String PROFILE_IMAGE_DIR = "profile";
    
    @Autowired
    private UserService userService;
    
    @GetMapping("")
    public String home(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("user", user);
        model.addAttribute("isAdmin", user.getUsername().equals("admin"));
        return "user";
    }
    
    @GetMapping("/edit-profile")
    public String editProfileForm(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("user", user);
        return "edit-profile";
    }
    
    @PostMapping("/edit-profile")
    public String updateProfile(
            @RequestParam(value = "username", required = false) String newUsername,
            @RequestParam(value = "currentPassword", required = false) String currentPassword,
            @RequestParam(value = "newPassword", required = false) String newPassword,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        User user = (User) session.getAttribute("user");
        boolean hasUpdates = false;
        StringBuilder successMessages = new StringBuilder();
        StringBuilder errorMessages = new StringBuilder();
        
        if (newUsername != null && !newUsername.trim().isEmpty() && !newUsername.equals(user.getUsername())) {
            if (userService.updateUsername(user.getUuid(), newUsername)) {
                user.setUsername(newUsername);
                session.setAttribute("user", user);
                successMessages.append("사용자명이 성공적으로 변경되었습니다! ");
                hasUpdates = true;
            } else {
                errorMessages.append("사용자명 변경 실패: 이미 사용 중인 사용자명입니다. ");
            }
        }
        
        if (currentPassword != null && !currentPassword.trim().isEmpty() && 
            newPassword != null && !newPassword.trim().isEmpty()) {
            if (userService.verifyCurrentPassword(user.getUuid(), currentPassword)) {
                if (userService.updatePassword(user.getUuid(), newPassword)) {
                    successMessages.append("비밀번호가 성공적으로 변경되었습니다! ");
                    hasUpdates = true;
                } else {
                    errorMessages.append("비밀번호 변경 실패: 데이터베이스 오류가 발생했습니다. ");
                }
            } else {
                errorMessages.append("비밀번호 변경 실패: 현재 비밀번호가 올바르지 않습니다. ");
            }
        }
        
        if (profileImage != null && !profileImage.isEmpty()) {
            try {
                String filename = userService.saveProfileImage(user.getUuid(), profileImage);
                user.setProfileImage(filename);
                session.setAttribute("user", user);
                successMessages.append("프로필 이미지가 성공적으로 업로드되었습니다! ");
                hasUpdates = true;
            } catch (IOException e) {
                errorMessages.append("이미지 업로드 실패: ").append(e.getMessage()).append(" ");
            }
        }
        
        if (successMessages.length() > 0) {
            redirectAttributes.addFlashAttribute("successMessage", successMessages.toString().trim());
        }
        if (errorMessages.length() > 0) {
            redirectAttributes.addFlashAttribute("errorMessage", errorMessages.toString().trim());
        }
        if (!hasUpdates && errorMessages.length() == 0) {
            redirectAttributes.addFlashAttribute("errorMessage", "변경할 내용이 없습니다.");
        }
        
        return "redirect:/user/edit-profile";
    }
    
    @PostMapping("/update-username")
    public String updateUsername(
            @RequestParam("username") String newUsername,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        User user = (User) session.getAttribute("user");
        if (userService.updateUsername(user.getUuid(), newUsername)) {
            user.setUsername(newUsername);
            session.setAttribute("user", user);
            redirectAttributes.addFlashAttribute("successMessage", "사용자명이 성공적으로 변경되었습니다!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "사용자명 변경 실패: 이미 사용 중인 사용자명입니다.");
        }
        
        return "redirect:/user/edit-profile";
    }
    
    @PostMapping("/update-password")
    public String updatePassword(
            @RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        User user = (User) session.getAttribute("user");
        
        if (!user.getPassword().equals(currentPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "현재 비밀번호가 일치하지 않습니다.");
            return "redirect:/user/edit-profile";
        }
        
        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
            return "redirect:/user/edit-profile";
        }
        
        if (userService.updatePassword(user.getUuid(), newPassword)) {
            user.setPassword(newPassword);
            session.setAttribute("user", user);
            redirectAttributes.addFlashAttribute("successMessage", "비밀번호가 성공적으로 변경되었습니다!");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "비밀번호 변경에 실패했습니다.");
        }
        
        return "redirect:/user/edit-profile";
    }
    
    @PostMapping("/upload-profile-image")
    public String uploadProfileImage(
            @RequestParam("profileImage") MultipartFile file,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        User user = (User) session.getAttribute("user");
        
        try {
            String filename = userService.saveProfileImage(user.getUuid(), file);
            user.setProfileImage(filename);
            session.setAttribute("user", user);
            redirectAttributes.addFlashAttribute("successMessage", "프로필 이미지가 성공적으로 업로드되었습니다!");
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "이미지 업로드 실패: " + e.getMessage());
        }
        
        return "redirect:/user/edit-profile";
    }
    
    @GetMapping("/profile-image")
    public ResponseEntity<Resource> getProfileImage(HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        if (user.getProfileImage() == null) {
            return ResponseEntity.notFound().build();
        }
        
        try {
            Path imagePath = Paths.get(PROFILE_IMAGE_DIR).resolve(user.getProfileImage());
            Resource resource = new UrlResource(imagePath.toUri());
            
            if (resource.exists() && resource.isReadable()) {
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + resource.getFilename() + "\"")
                        .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (MalformedURLException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}