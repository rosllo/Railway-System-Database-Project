create database RailwaySystemDB

use RailwaySystemDB

create table Train (
    Train_ID numeric not null,
    Train_Name varchar(32),
    Wagon_Number numeric not null,
    constraint PK_Train primary key (Train_ID)
)

create table Station (
    Station_ID numeric not null,
    Station_Name varchar(32),
    constraint PK_Station primary key (Station_ID)
)

create table Track (
    Track_ID numeric not null,
    Track_Name varchar(32),
    Track_Length numeric not null,
    constraint PK_Track primary key (Track_ID)
)

create table Booking (
    Ticket_ID numeric not null,
    Ticket_Time time(0) not null,
    Ticket_Date date,
    Seat_No numeric not null,
    From_Station varchar(32),
    To_Station varchar(32),
    constraint PK_Ticket primary key (Ticket_ID)
)

create table WorkSchedule (
    Schedule_ID numeric not null,
    Start_Time time(0) not null,
    End_Time time(0) not null,
    Break_time time(0)not null,
    constraint PK_Schedule primary key (Schedule_ID)
)

create table Passenger (
    Passenger_ID numeric not null,
    First_Name varchar(32),
    Last_Name varchar(32),
    constraint PK_Passenger primary key (Passenger_ID),
    Ticket_ID numeric foreign key references Booking(Ticket_ID),
    Train_ID numeric foreign key references Train(Train_ID),
)

create table TrainWorker (
    TWorker_ID numeric not null,
    First_Name varchar(32),
    Last_Name varchar(32),
    TWorker_Type varchar(32),
    check (TWorker_Type = 'Driver' or TWorker_Type = 'Ticket Inspector' or TWorker_Type = 'Utility Clerk' or TWorker_Type = 'Assistant Driver' or TWorker_Type = 'Waiter'),
    Train_ID numeric foreign key references Train(Train_ID),
    Schedule_ID numeric foreign key references WorkSchedule(Schedule_ID),
    constraint PK_TrainWorker primary key (TWorker_ID)
)

create table StationWorker (
    SWorker_ID numeric not null,
    First_Name varchar(32),
    Last_Name varchar(32),
    SWorker_Type varchar(32),
    check (SWorker_Type = 'Station Agent' or SWorker_Type = 'Station Master' or SWorker_Type = 'Utility Clerk' or SWorker_Type = 'Dispatcher' or SWorker_Type = 'Porter'),
    Station_ID numeric foreign key references Station(Station_ID),
    Schedule_ID numeric foreign key references WorkSchedule(Schedule_ID),
    constraint PK_StationWorker primary key (SWorker_ID)
)

insert into Train values (337, 'Duronot Express', 8);
insert into Train values (1124, 'Orient Express', 12);
insert into Train values (009, 'Bullet', 10);

insert into Station values (4532, 'Highland Rail Station');
insert into Station values (887, 'Quiet Field Station');
insert into Station values (1337, 'Sacred Woods Station');

insert into Track values (78323, 'Nightingale Route', 23);
insert into Track values (5652, 'Molten Bay Tracks', 153);
insert into Track Values (8771, 'Snow Crystal Route', 72);

insert into Booking values (5342, '13:00:00', '2022-02-12', 83, 'Highland Rail Station', 'Quiet Field Station');
insert into Booking values (3241, '07:15:00', '2022-01-23', 12, 'Sacred Woods Station', 'Highland Rail Station');
insert into Booking values (8892, '16:45:00', '2022-01-03', 46, 'Quiet Field Station', 'Sacred Woods Station');

insert into WorkSchedule values (1992, '09:00:00', '21:00:00', '13:00:00');
insert into WorkSchedule values (742, '06:00:00', '22:30:00', '11:30:00');

insert into Passenger values (4381, 'Harvir', 'Dupont', 5342, 337);
insert into Passenger values (23135, 'Lukas', 'Brookes', 3241, 1124);
insert into Passenger values (74324, 'Narona', 'Reese', 8892, 009);

insert into TrainWorker values (128, 'Shayla', 'Mcloughlin', 'Driver', 337, 1992);
insert into TrainWorker values (894, 'Kane', 'Tierney', 'Ticket Inspector', 009, 1992);
insert into TrainWorker values (4827, 'Floyd', 'Santos', 'Utility Clerk', 1124, 1992);

insert into StationWorker values(7782, 'Hamish', 'Barlow', 'Station Master', 4532, 742);
insert into StationWorker values(8295, 'Juniper', 'Leach', 'Station Agent', 4532, 742);
insert into StationWorker values(237, 'Natasha', 'Figueroa', 'Porter', 4532, 742);

-- Query to show the name and last name of the station worker in the highest job position 'Station Master'
select First_Name, Last_Name
from StationWorker
where SWorker_Type = 'Station Master'

-- Query to show all passengers on train with a wagon number higher than 11
select p.Passenger_ID, p.First_Name, p.Last_Name, p.Ticket_ID, t.Train_ID, t.Train_Name, t.Wagon_Number
from Passenger p, Train t
where p.Train_ID = t.Train_ID
and t.Wagon_Number > 11

-- Query to show all ticket ID's and their time where the to-station is 'Sacred Woods Station'
select Ticket_ID, Ticket_Time
from Booking
where To_Station = 'Sacred Woods Station'

-- Query to create a view which will show basic information about the station and all the workers in the station with a station ID of 4532
create view [SWL] as
select s.Station_ID, s.Station_Name, sw.SWorker_ID, sw.SWorker_Type, sw.First_Name, sw.Last_Name
from Station s, StationWorker sw
where s.Station_ID = 4532
-- select * from [SWL]

-- Query to show all the train worker ID's, names and surnames of those who work a shift that has a break before 4 PM
select distinct tw.TWorker_ID, tw.First_Name, tw.Last_Name
from TrainWorker tw, WorkSchedule ws
where ws.Break_time < '16:00:00'