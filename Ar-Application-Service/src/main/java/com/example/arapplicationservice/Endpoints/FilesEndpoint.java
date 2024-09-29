package com.example.arapplicationservice.Endpoints;

import com.example.arapplicationservice.Service.FilesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FilesEndpoint {

    @Autowired
    private FilesService filesService;

    @PostMapping("/{id}")
    public ResponseEntity<Resource> saveFile(@PathVariable String id){

        return null;
    }
    @GetMapping("/files/{filename}")
    public ResponseEntity<Resource> serveFile(@PathVariable String filename) {
        return filesService.downloadFileService(filename);
    }
}