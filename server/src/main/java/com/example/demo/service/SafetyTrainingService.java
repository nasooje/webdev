package com.example.demo.service;

import com.example.demo.dao.SafetyTrainingDao;
import com.example.demo.model.SafetyTrainingProgram;
import com.example.demo.model.SafetyTrainingApplication;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class SafetyTrainingService {

    @Autowired
    private SafetyTrainingDao safetyTrainingDao;

    public List<SafetyTrainingProgram> getAllPrograms() {
        return safetyTrainingDao.getAllPrograms();
    }

    public List<SafetyTrainingProgram> getActivePrograms() {
        return safetyTrainingDao.getActivePrograms();
    }

    public SafetyTrainingProgram getProgramById(Long id) {
        return safetyTrainingDao.getProgramById(id);
    }

    public SafetyTrainingProgram createProgram(SafetyTrainingProgram program) {
        return safetyTrainingDao.createProgram(program);
    }

    public SafetyTrainingProgram createProgramFromForm(String title, String description, String location,
                                                  String activityDate, String startTime, String endTime,
                                                  int maxParticipants) {
        SafetyTrainingProgram program = new SafetyTrainingProgram();
        program.setTitle(title);
        program.setDescription(description);
        program.setLocation(location);
        
        LocalDate date = LocalDate.parse(activityDate, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        program.setActivityDate(date);
        
        LocalTime start = LocalTime.parse(startTime, DateTimeFormatter.ofPattern("HH:mm"));
        LocalTime end = LocalTime.parse(endTime, DateTimeFormatter.ofPattern("HH:mm"));
        program.setStartTime(start);
        program.setEndTime(end);
        
        program.setMaxParticipants(maxParticipants);
        program.setCurrentParticipants(0);
        program.setStatus("모집중");
        
        return safetyTrainingDao.createProgram(program);
    }

    public boolean updateProgram(SafetyTrainingProgram program) {
        return safetyTrainingDao.updateProgram(program);
    }

    public boolean updateProgramFromForm(Long id, String title, String description, String location,
                                        String activityDate, String startTime, String endTime,
                                        int maxParticipants, String status) {
        SafetyTrainingProgram program = safetyTrainingDao.getProgramById(id);
        if (program == null) {
            return false;
        }
        
        program.setTitle(title);
        program.setDescription(description);
        program.setLocation(location);
        
        LocalDate date = LocalDate.parse(activityDate, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        program.setActivityDate(date);
        
        LocalTime start = LocalTime.parse(startTime, DateTimeFormatter.ofPattern("HH:mm"));
        LocalTime end = LocalTime.parse(endTime, DateTimeFormatter.ofPattern("HH:mm"));
        program.setStartTime(start);
        program.setEndTime(end);
        
        program.setMaxParticipants(maxParticipants);
        program.setStatus(status);
        
        return safetyTrainingDao.updateProgram(program);
    }

    public boolean deleteProgram(Long id) {
        return safetyTrainingDao.deleteProgram(id);
    }

    public boolean applyForProgram(Long programId, Long userId) {
        return safetyTrainingDao.applyForProgram(programId, userId);
    }

    public boolean cancelApplication(Long programId, Long userId) {
        return safetyTrainingDao.cancelApplication(programId, userId);
    }

    public List<SafetyTrainingApplication> getUserApplications(Long userId) {
        return safetyTrainingDao.getUserApplications(userId);
    }

    public List<SafetyTrainingApplication> getProgramApplicants(Long programId) {
        return safetyTrainingDao.getProgramApplicants(programId);
    }

    public boolean hasUserApplied(Long programId, Long userId) {
        return safetyTrainingDao.hasUserApplied(programId, userId);
    }
}