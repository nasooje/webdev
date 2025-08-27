package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.model.SafetyTrainingProgram;
import com.example.demo.model.SafetyTrainingApplication;
import com.example.demo.service.SafetyTrainingService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

import java.util.List;

@Controller
public class SafetyTrainingController {

    @Autowired
    private SafetyTrainingService safetyTrainingService;

    @GetMapping("/safety-training")
    public String safetyTrainingHome(Model model) {
        List<SafetyTrainingProgram> programs = safetyTrainingService.getActivePrograms();
        model.addAttribute("programs", programs);
        return "safety-training/list";
    }

    @GetMapping("/safety-training/{id}")
    public String safetyTrainingDetail(@PathVariable Long id, Model model, HttpSession session) {
        SafetyTrainingProgram program = safetyTrainingService.getProgramById(id);
        if (program == null) {
            return "redirect:/safety-training";
        }
        
        boolean hasApplied = false;
        User user = (User) session.getAttribute("user");
        if (user != null) {
            hasApplied = safetyTrainingService.hasUserApplied(id, user.getId());
        }
        
        model.addAttribute("program", program);
        model.addAttribute("hasApplied", hasApplied);
        return "safety-training/detail";
    }

    @PostMapping("/safety-training/{id}/apply")
    public String applyForSafetyTraining(@PathVariable Long id, 
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        
        boolean success = safetyTrainingService.applyForProgram(id, user.getId());
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage", "안전교육 신청이 완료되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "안전교육 신청에 실패했습니다. 이미 신청했거나 정원이 꽉 찼을 수 있습니다.");
        }
        
        return "redirect:/safety-training/" + id;
    }

    @PostMapping("/safety-training/{id}/cancel")
    public String cancelApplication(@PathVariable Long id, 
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        
        boolean success = safetyTrainingService.cancelApplication(id, user.getId());
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage", "안전교육 신청이 취소되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "안전교육 신청 취소에 실패했습니다.");
        }
        
        return "redirect:/safety-training/" + id;
    }

    @GetMapping("/safety-training/my-programs")
    public String mySafetyTrainings(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        List<SafetyTrainingApplication> applications = safetyTrainingService.getUserApplications(user.getId());
        model.addAttribute("applications", applications);
        return "safety-training/my-programs";
    }

    @GetMapping("/admin/safety-training")
    public String adminSafetyTrainingHome(Model model) {
        List<SafetyTrainingProgram> programs = safetyTrainingService.getAllPrograms();
        model.addAttribute("programs", programs);
        return "admin/safety-training/list";
    }

    @GetMapping("/admin/safety-training/create")
    public String createSafetyTrainingForm() {
        return "admin/safety-training/create";
    }

    @PostMapping("/admin/safety-training/create")
    public String createSafetyTraining(@RequestParam("title") String title,
                               @RequestParam("description") String description,
                               @RequestParam("location") String location,
                               @RequestParam("activityDate") String activityDate,
                               @RequestParam("startTime") String startTime,
                               @RequestParam("endTime") String endTime,
                               @RequestParam("maxParticipants") int maxParticipants,
                               RedirectAttributes redirectAttributes) {
        try {
            SafetyTrainingProgram program = safetyTrainingService.createProgramFromForm(
                title, description, location, activityDate, startTime, endTime, maxParticipants
            );
            
            if (program != null) {
                redirectAttributes.addFlashAttribute("successMessage", "안전교육 프로그램이 성공적으로 등록되었습니다.");
                return "redirect:/admin/safety-training";
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "안전교육 프로그램 등록에 실패했습니다.");
                return "redirect:/admin/safety-training/create";
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "안전교육 프로그램 등록 중 오류가 발생했습니다: " + e.getMessage());
            return "redirect:/admin/safety-training/create";
        }
    }

    @GetMapping("/admin/safety-training/{id}/edit")
    public String editSafetyTrainingForm(@PathVariable Long id, Model model) {
        SafetyTrainingProgram program = safetyTrainingService.getProgramById(id);
        if (program == null) {
            return "redirect:/admin/safety-training";
        }
        
        model.addAttribute("program", program);
        return "admin/safety-training/edit";
    }

    @PostMapping("/admin/safety-training/{id}/edit")
    public String editSafetyTraining(@PathVariable Long id,
                             @RequestParam("title") String title,
                             @RequestParam("description") String description,
                             @RequestParam("location") String location,
                             @RequestParam("activityDate") String activityDate,
                             @RequestParam("startTime") String startTime,
                             @RequestParam("endTime") String endTime,
                             @RequestParam("maxParticipants") int maxParticipants,
                             @RequestParam("status") String status,
                             RedirectAttributes redirectAttributes) {
        try {
            boolean success = safetyTrainingService.updateProgramFromForm(
                id, title, description, location, activityDate, startTime, endTime, maxParticipants, status
            );
            
            if (success) {
                redirectAttributes.addFlashAttribute("successMessage", "안전교육 프로그램이 성공적으로 수정되었습니다.");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "안전교육 프로그램 수정에 실패했습니다.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "안전교육 프로그램 수정 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        return "redirect:/admin/safety-training";
    }

    @PostMapping("/admin/safety-training/{id}/delete")
    public String deleteSafetyTraining(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        boolean success = safetyTrainingService.deleteProgram(id);
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage", "안전교육 프로그램이 성공적으로 삭제되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "안전교육 프로그램 삭제에 실패했습니다.");
        }
        
        return "redirect:/admin/safety-training";
    }

    @GetMapping("/admin/safety-training/{id}/applicants")
    public String viewApplicants(@PathVariable Long id, Model model) {
        SafetyTrainingProgram program = safetyTrainingService.getProgramById(id);
        if (program == null) {
            return "redirect:/admin/safety-training";
        }
        
        List<SafetyTrainingApplication> applicants = safetyTrainingService.getProgramApplicants(id);
        model.addAttribute("program", program);
        model.addAttribute("applicants", applicants);
        return "admin/safety-training/applicants";
    }
}