package com.example.arapplicationservice.Service;

import com.example.arapplicationservice.domain.Filepath;
import com.example.arapplicationservice.dto.request.UploadFileNameRequest;
import com.example.arapplicationservice.Repository.FilepathRepository;
import com.example.arapplicationservice.Repository.RoomRepository;
import com.example.arapplicationservice.domain.Room;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
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
import java.util.Map;

@Service
public class FilesService {
    @Autowired
    RoomRepository roomRepository;

    @Autowired
    FilepathRepository filepathRepository;

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
    @Transactional
    public void uploadFileService(String jsonData, MultipartFile file) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        UploadFileNameRequest request = objectMapper.readValue(jsonData, UploadFileNameRequest.class);

        System.out.println("uploadJSON Details: "+ request.toString());

        Room room = roomRepository.findByRoomUniqueId(request.getRoomUniqueId())
                .orElseGet(() -> {
            Room newRoom = new Room();
            newRoom.setRoomUniqueId(request.getRoomUniqueId());
            return roomRepository.save(newRoom);
        });

        for(Map.Entry<String,String> fileNameItem : request.getFileNames().entrySet()){
            Filepath filepath = new Filepath();
            filepath.setMarkerFilePath(fileNameItem.getKey());
            filepath.setModelFilePath(fileNameItem.getValue());
            filepath.setRoomData(room);
            filepathRepository.save(filepath);
        }

        String filename=file.getOriginalFilename();
        Path filepath=Paths.get(fileUploadDir,filename);

        Files.copy(file.getInputStream(),filepath);

    }
}
