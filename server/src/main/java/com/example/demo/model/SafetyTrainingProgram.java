package com.example.demo.model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class SafetyTrainingProgram {
    private Long id;
    private String title;
    private String description;
    private String location;
    private LocalDate activityDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private int maxParticipants;
    private int currentParticipants;
    private String status;
    private String createdAt;
    private String updatedAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public LocalDate getActivityDate() {
        return activityDate;
    }

    public void setActivityDate(LocalDate activityDate) {
        this.activityDate = activityDate;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public int getMaxParticipants() {
        return maxParticipants;
    }

    public void setMaxParticipants(int maxParticipants) {
        this.maxParticipants = maxParticipants;
    }

    public int getCurrentParticipants() {
        return currentParticipants;
    }

    public void setCurrentParticipants(int currentParticipants) {
        this.currentParticipants = currentParticipants;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getFormattedDate() {
        if (activityDate == null) return "";
        return activityDate.format(DateTimeFormatter.ofPattern("yyyy년 MM월 dd일"));
    }

    public String getActivityDateStr() {
        if (activityDate == null) return "";
        return activityDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    public String getStartTimeStr() {
        if (startTime == null) return "";
        return startTime.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    public String getEndTimeStr() {
        if (endTime == null) return "";
        return endTime.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    public String getTimeRange() {
        return getStartTimeStr() + " ~ " + getEndTimeStr();
    }

    public boolean isAvailable() {
        return "모집중".equals(status) && currentParticipants < maxParticipants;
    }

    public int getRemainingSpots() {
        return maxParticipants - currentParticipants;
    }
}