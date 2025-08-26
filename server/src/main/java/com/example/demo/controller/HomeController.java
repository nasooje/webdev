package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.demo.model.User;

@Controller
public class HomeController {
    @GetMapping("/")
    public String home(@RequestAttribute(name = "user", required = false) User user, Model model) {
        model.addAttribute("user", user);
        return "index";
    }
    
    @GetMapping("/guide")
    public String guide(@RequestAttribute(name = "user", required = false) User user, Model model) {
        model.addAttribute("user", user);
        return "guide";
    }
    
    @GetMapping("/faq")
    public String info(@RequestAttribute(name = "user", required = false) User user, Model model) {
        model.addAttribute("user", user);
        return "faq";
    }
    
    @GetMapping("/greeting")
    public String greeting(@RequestAttribute(name = "user", required = false) User user, Model model) {
        model.addAttribute("user", user);
        return "greeting";
    }
}