package com.example.demo.service;

import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.*;
import java.util.List;
import java.util.ArrayList;

@Service
public class AdminService {
    public List<String> getFileList(String dir) throws IOException {
        Path basePath = Paths.get(dir);

        List<String> files = new ArrayList<>();
        if (Files.exists(basePath)) {
            Files.list(basePath).forEach(path -> {
                files.add(path.getFileName().toString());
            });

        }

        return files;
    }
}