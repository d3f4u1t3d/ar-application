package com.example.arapplicationservice.Repository;

import com.example.arapplicationservice.domain.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface RoomRepository extends JpaRepository<Room,Integer> {

    Optional<Room> findByRoomUniqueId(String uniqueRoomId);
}
