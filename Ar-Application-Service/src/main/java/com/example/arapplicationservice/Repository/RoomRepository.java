package com.example.arapplicationservice.Repository;

import com.example.arapplicationservice.domain.Room;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoomRepository extends JpaRepository<Room,Integer> {
}
