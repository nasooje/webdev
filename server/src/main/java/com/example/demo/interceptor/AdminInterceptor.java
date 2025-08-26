package com.example.demo.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.model.User;

public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        User user = (User) request.getAttribute("user");

        if (!user.getUsername().equals("admin")) {
            response.sendRedirect("/user");
            return false;
        }

        return true;
    }
}
