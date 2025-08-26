package com.example.demo.dao;

import com.example.demo.model.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class UserDao {

    @Value("${spring.datasource.url}")
    private String dbUrl;

    @Value("${spring.datasource.username}")
    private String dbUser;

    @Value("${spring.datasource.password}")
    private String dbPassword;

    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username='" + username + "'";

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getLong("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setUuid(rs.getString("uuid"));
                user.setProfileImage(rs.getString("profile_image"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username='" + username + "' and password='" + password + "'";

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getLong("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setUuid(rs.getString("uuid"));
                user.setProfileImage(rs.getString("profile_image"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public User save(User user) {
        String sql = "INSERT INTO users (username, password, uuid) VALUES ('" + user.getUsername() + "', '"
                + user.getPassword() + "', '" + user.getUuid() + "')";
        System.out.println("Executing SQL: " + sql);

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                Statement stmt = conn.createStatement()) {

            stmt.executeUpdate(sql);
            return user;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updateUsername(String uuid, String newUsername) {
        String sql = "UPDATE users SET username='" + newUsername + "' WHERE uuid='" + uuid + "'";
        System.out.println("Executing SQL: " + sql);

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                Statement stmt = conn.createStatement()) {

            int rowsAffected = stmt.executeUpdate(sql);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(String uuid, String newPassword) {
        String sql = "UPDATE users SET password='" + newPassword + "' WHERE uuid='" + uuid + "'";
        System.out.println("Executing SQL: " + sql);

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                Statement stmt = conn.createStatement()) {

            int rowsAffected = stmt.executeUpdate(sql);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateProfileImage(String uuid, String profileImage) {
        String sql = "UPDATE users SET profile_image='" + profileImage + "' WHERE uuid='" + uuid + "'";
        System.out.println("Executing SQL: " + sql);

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                Statement stmt = conn.createStatement()) {

            int rowsAffected = stmt.executeUpdate(sql);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User findByUuid(String uuid) {
        String sql = "SELECT * FROM users WHERE uuid='" + uuid + "'";

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getLong("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setUuid(rs.getString("uuid"));
                user.setProfileImage(rs.getString("profile_image"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<User> getAllUser() {
        String sql = "SELECT * FROM users";
        System.out.println("Executing SQL: " + sql);

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                Statement stmt = conn.createStatement()) {

            ResultSet rs = stmt.executeQuery(sql);

            List<User> userList = new ArrayList<>();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getLong("id"));
                user.setUsername(rs.getString("username"));
                user.setUuid(rs.getString("uuid"));
                user.setProfileImage(rs.getString("profile_image"));
                userList.add(user);
            }

            return userList;

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
