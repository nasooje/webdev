package com.example.demo.config;

import com.example.demo.interceptor.AdminInterceptor;
import com.example.demo.interceptor.SessionInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new SessionInterceptor())
                .addPathPatterns("/user/**", "/storage/**", "/admin/**");

        registry.addInterceptor(new AdminInterceptor())
                .addPathPatterns("/admin/**");
    }
}