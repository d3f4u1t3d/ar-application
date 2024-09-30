package com.example.arapplicationservice.Service;

import com.example.arapplicationservice.Mapper.UploadFiles;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Service
public class FilesService {
    @Value("${file.upload-dir}")
    private String fileUploadDir;

    public ResponseEntity<Resource> downloadFileService(String filename) {
        try{
//            Resource resource = new ClassPathResource("markerfiles/"+filename);
            Path filePath = Paths.get(fileUploadDir).resolve(filename);
            Resource resource = new UrlResource(filePath.toUri());
            if (!resource.exists()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"");
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(resource);

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    public void uploadFileService(String jsonData, MultipartFile file) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        UploadFiles uploadFiles = objectMapper.readValue(jsonData, UploadFiles.class);

        System.out.println("uploadJSON Details "+uploadFiles.getUniqueRoomId()+" "+
                uploadFiles.getMarkerFileName()+" "+uploadFiles.getModelFileName());

        String filename=file.getOriginalFilename();
        Path filepath=Paths.get(fileUploadDir,filename);

        Files.copy(file.getInputStream(),filepath);

    }
}
