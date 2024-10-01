insert into room(room_key) values ('1234');
select * from room;

select * from file_path;
create table room(
                     id serial primary key,
                     room_key varchar(100) not null
);

create table file_path(
                          id serial primary key,
                          reference_room_key int not null,
                          marker_file_path varchar not null unique,
                          model_file_path varchar not null unique,
                          constraint fk_room_room_key foreign key(reference_room_key) references room(id)
);