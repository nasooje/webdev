package com.example.demo.dao;

import com.example.demo.model.SafetyTrainingProgram;
import com.example.demo.model.SafetyTrainingApplication;
import com.example.demo.model.User;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Repository
public class SafetyTrainingDao {
    
    @Value("${spring.datasource.url}")
    private String dbUrl;

    @Value("${spring.datasource.username}")
    private String dbUser;

    @Value("${spring.datasource.password}")
    private String dbPassword;

    public List<SafetyTrainingProgram> getAllPrograms() {
        String sql = "SELECT * FROM safety_training_programs ORDER BY activity_date ASC";
        List<SafetyTrainingProgram> programs = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                SafetyTrainingProgram program = mapResultSetToProgram(rs);
                programs.add(program);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return programs;
    }

    public List<SafetyTrainingProgram> getActivePrograms() {
        String sql = "SELECT * FROM safety_training_programs WHERE status = '모집중' ORDER BY activity_date ASC";
        List<SafetyTrainingProgram> programs = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                SafetyTrainingProgram program = mapResultSetToProgram(rs);
                programs.add(program);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return programs;
    }

    public SafetyTrainingProgram getProgramById(Long id) {
        String sql = "SELECT * FROM safety_training_programs WHERE id = " + id;

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return mapResultSetToProgram(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public SafetyTrainingProgram createProgram(SafetyTrainingProgram program) {
        String sql = "INSERT INTO safety_training_programs (title, description, location, activity_date, " +
                "start_time, end_time, max_participants, current_participants, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, program.getTitle());
            pstmt.setString(2, program.getDescription());
            pstmt.setString(3, program.getLocation());
            pstmt.setDate(4, Date.valueOf(program.getActivityDate()));
            pstmt.setTime(5, Time.valueOf(program.getStartTime()));
            pstmt.setTime(6, Time.valueOf(program.getEndTime()));
            pstmt.setInt(7, program.getMaxParticipants());
            pstmt.setInt(8, program.getCurrentParticipants());
            pstmt.setString(9, program.getStatus());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("안전교육 프로그램 등록 실패");
            }

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    program.setId(generatedKeys.getLong(1));
                    return program;
                } else {
                    throw new SQLException("안전교육 프로그램 ID 가져오기 실패");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateProgram(SafetyTrainingProgram program) {
        String sql = "UPDATE safety_training_programs SET title = ?, description = ?, location = ?, " +
                "activity_date = ?, start_time = ?, end_time = ?, max_participants = ?, status = ? " +
                "WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, program.getTitle());
            pstmt.setString(2, program.getDescription());
            pstmt.setString(3, program.getLocation());
            pstmt.setDate(4, Date.valueOf(program.getActivityDate()));
            pstmt.setTime(5, Time.valueOf(program.getStartTime()));
            pstmt.setTime(6, Time.valueOf(program.getEndTime()));
            pstmt.setInt(7, program.getMaxParticipants());
            pstmt.setString(8, program.getStatus());
            pstmt.setLong(9, program.getId());

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProgram(Long id) {
        String deleteSql = "DELETE FROM safety_training_applications WHERE program_id = " + id;
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(deleteSql);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String sql = "DELETE FROM safety_training_programs WHERE id = " + id;
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             Statement stmt = conn.createStatement()) {
            int affectedRows = stmt.executeUpdate(sql);
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean applyForProgram(Long programId, Long userId) {
        String checkSql = "SELECT current_participants, max_participants FROM safety_training_programs WHERE id = ? AND status = '모집중'";
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
            
            pstmt.setLong(1, programId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int currentParticipants = rs.getInt("current_participants");
                int maxParticipants = rs.getInt("max_participants");
                
                if (currentParticipants >= maxParticipants) {
                    return false; 
                }
            } else {
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String checkDuplicateSql = "SELECT id FROM safety_training_applications WHERE program_id = ? AND user_id = ? AND status != '취소'";
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(checkDuplicateSql)) {
            
            pstmt.setLong(1, programId);
            pstmt.setLong(2, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return false; 
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String insertSql = "INSERT INTO safety_training_applications (program_id, user_id, status) VALUES (?, ?, '신청')";
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
            
            pstmt.setLong(1, programId);
            pstmt.setLong(2, userId);
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                String updateSql = "UPDATE safety_training_programs SET current_participants = current_participants + 1 WHERE id = ?";
                try (PreparedStatement updatePstmt = conn.prepareStatement(updateSql)) {
                    updatePstmt.setLong(1, programId);
                    updatePstmt.executeUpdate();
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean cancelApplication(Long programId, Long userId) {
        String updateSql = "UPDATE safety_training_applications SET status = '취소' WHERE program_id = ? AND user_id = ? AND status = '신청'";
        
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
            
            pstmt.setLong(1, programId);
            pstmt.setLong(2, userId);
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                String updateParticipantsSql = "UPDATE safety_training_programs SET current_participants = current_participants - 1 WHERE id = ? AND current_participants > 0";
                try (PreparedStatement updatePstmt = conn.prepareStatement(updateParticipantsSql)) {
                    updatePstmt.setLong(1, programId);
                    updatePstmt.executeUpdate();
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public List<SafetyTrainingApplication> getUserApplications(Long userId) {
        String sql = "SELECT sa.*, sp.title as program_title, sp.activity_date, sp.start_time, sp.end_time " +
                    "FROM safety_training_applications sa " +
                    "JOIN safety_training_programs sp ON sa.program_id = sp.id " +
                    "WHERE sa.user_id = ? " +
                    "ORDER BY sa.applied_at DESC";
        
        List<SafetyTrainingApplication> applications = new ArrayList<>();
        
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                SafetyTrainingApplication application = mapResultSetToApplication(rs);
                applications.add(application);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return applications;
    }

    public List<SafetyTrainingApplication> getProgramApplicants(Long programId) {
        String sql = "SELECT sa.*, u.username as user_name, sp.title as program_title, sp.activity_date, sp.start_time, sp.end_time " +
                    "FROM safety_training_applications sa " +
                    "JOIN users u ON sa.user_id = u.id " +
                    "JOIN safety_training_programs sp ON sa.program_id = sp.id " +
                    "WHERE sa.program_id = ? " +
                    "ORDER BY sa.applied_at DESC";
        
        List<SafetyTrainingApplication> applications = new ArrayList<>();
        
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, programId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                SafetyTrainingApplication application = mapResultSetToApplication(rs);
                applications.add(application);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return applications;
    }

    public boolean hasUserApplied(Long programId, Long userId) {
        String sql = "SELECT id FROM safety_training_applications WHERE program_id = ? AND user_id = ? AND status != '취소'";
        
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setLong(1, programId);
            pstmt.setLong(2, userId);
            ResultSet rs = pstmt.executeQuery();
            
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    private SafetyTrainingProgram mapResultSetToProgram(ResultSet rs) throws SQLException {
        SafetyTrainingProgram program = new SafetyTrainingProgram();
        program.setId(rs.getLong("id"));
        program.setTitle(rs.getString("title"));
        program.setDescription(rs.getString("description"));
        program.setLocation(rs.getString("location"));
        program.setActivityDate(rs.getDate("activity_date").toLocalDate());
        program.setStartTime(rs.getTime("start_time").toLocalTime());
        program.setEndTime(rs.getTime("end_time").toLocalTime());
        program.setMaxParticipants(rs.getInt("max_participants"));
        program.setCurrentParticipants(rs.getInt("current_participants"));
        program.setStatus(rs.getString("status"));
        program.setCreatedAt(rs.getString("created_at"));
        program.setUpdatedAt(rs.getString("updated_at"));
        return program;
    }

    private SafetyTrainingApplication mapResultSetToApplication(ResultSet rs) throws SQLException {
        SafetyTrainingApplication application = new SafetyTrainingApplication();
        application.setId(rs.getLong("id"));
        application.setProgramId(rs.getLong("program_id"));
        application.setUserId(rs.getLong("user_id"));
        application.setStatus(rs.getString("status"));
        application.setAppliedAt(rs.getString("applied_at"));
        
        try {
            application.setProgramTitle(rs.getString("program_title"));
            Date activityDate = rs.getDate("activity_date");
            if (activityDate != null) {
                application.setActivityDate(activityDate.toString());
            }
            Time startTime = rs.getTime("start_time");
            Time endTime = rs.getTime("end_time");
            if (startTime != null && endTime != null) {
                application.setTimeRange(startTime.toLocalTime().toString() + " ~ " + endTime.toLocalTime().toString());
            }
        } catch (SQLException e) {
        }
        
        try {
            application.setUserName(rs.getString("user_name"));
        } catch (SQLException e) {
        }
        
        return application;
    }
}