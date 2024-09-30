package com.example.arapplicationservice.Endpoints;

import com.example.arapplicationservice.Service.FilesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
public class FilesEndpoint {

    @Autowired
    private FilesService filesService;

    @PostMapping("/upload")
    public String saveFile(@RequestParam("jsonData") String jsonData, @RequestParam("file") MultipartFile file) throws IOException {
        filesService.uploadFileService(jsonData,file);
        return "uploaded";
    }
    @GetMapping("/files/{filename}")
    public ResponseEntity<Resource> serveFile(@PathVariable String filename) {
        return filesService.downloadFileService(filename);
    }
}