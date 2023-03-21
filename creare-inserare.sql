CREATE SEQUENCE secv_utilizator
START with 1
INCREMENT by 1
MINVALUE 0
MAXVALUE 1000
NOCYCLE;

CREATE TABLE SPECTACOL(
id_spectacol int primary key,
tip varchar2(20) not null,
nume varchar2(100) not null
);

CREATE TABLE FILM(
id_spectacol int primary key,
durata int,
limba varchar2(20),
data_lansarii date,
tara varchar2(20),
gen varchar2(20),
constraint fk_spectacolfilm foreign key (id_spectacol) references spectacol(id_spectacol)
);

CREATE TABLE TEATRU(
id_spectacol int primary key,
autor varchar2(50),
regizor varchar2(50),
scenograf varchar2(50),
constraint fk_spectacolteatru foreign key (id_spectacol) references spectacol(id_spectacol)
);

CREATE TABLE CONCERT(
id_spectacol int primary key,
artist varchar2(50),
invitati varchar2(100),
gen varchar2(50),
constraint fk_spectacolconcert foreign key (id_spectacol) references spectacol(id_spectacol)
);

CREATE TABLE ORGANIZATOR(
id_organizator int primary key,
nume varchar2(50) not null,
email varchar2(50) not null,
nr_telefon  varchar2(20) not null
);

CREATE TABLE ORAS(
id_oras int primary key,
nume varchar2(50) not null,
localitate varchar2(50) not null
);

CREATE TABLE LOCATIE(
id_locatie int primary key,
id_oras int not null,
nume varchar2(50) not null,
nr_sali int not null,
adresa varchar2(100) not null
);

CREATE TABLE SALA(
id_sala int not null,
id_locatie int not null,
nume varchar2(50) not null,
nr_locuri int,
primary key (id_sala, id_locatie),
constraint fk_locatiesala foreign key (id_locatie) references locatie(id_locatie)
);

CREATE TABLE EVENIMENT(
id_eveniment int primary key,
id_spectacol int not null,
id_locatie int not null,
id_sala int not null,
id_organizator int not null,
data_eveniment date not null,
ora_start varchar2(10) not null,
ora_stop varchar2(10) not null,
constraint fk_spectacoleveniment foreign key (id_spectacol) references spectacol(id_spectacol),
constraint fk_salaeveniment foreign key (id_sala, id_locatie) references sala(id_sala, id_locatie),
constraint fk_organizatoreveniment foreign key (id_organizator) references organizator(id_organizator)
);

CREATE TABLE LOC(
id_loc int not null,
id_sala int not null,
id_locatie int not null,
tip varchar2(50) not null,
primary key (id_loc, id_sala, id_locatie),
constraint fk_salaloc foreign key (id_sala, id_locatie) references sala(id_sala, id_locatie)
);


CREATE TABLE UTILIZATOR(
id_utilizator int primary key,
nume varchar2(50) not null,
parola varchar2(50) not null,
email varchar2(50) not null,
nr_telefon  varchar2(20) not null
);

CREATE TABLE REZERVARE(
id_rezervare int primary key,
id_utilizator int not null,
data_rezervare date not null,
nr_bilete int not null,
stare int not null,
constraint fk_utilizatorrezervare foreign key (id_utilizator) references utilizator(id_utilizator)
);

CREATE TABLE BILET(
id_bilet int,
id_eveniment int,
id_loc int not null,
id_sala int not null,
id_locatie int not null,
id_rezervare int,
pret int not null,
stare int not null,
primary key (id_bilet, id_eveniment),
constraint fk_locbilet foreign key (id_loc, id_sala, id_locatie) references loc(id_loc, id_sala, id_locatie),
constraint fk_evenimentbilet foreign key (id_eveniment) references eveniment(id_eveniment),
constraint fk_rezervarebilet foreign key (id_rezervare) references rezervare(id_rezervare)
);

CREATE TABLE PLATA(
id_plata int primary key,
suma int not null,
data_plata date not null,
id_rezervare int not null,
constraint fk_rezervareplata foreign key (id_rezervare) references rezervare(id_rezervare)
);


CREATE TABLE REDUCERE(
id_reducere int primary key,
nume varchar2(50) not null,
valoare int not null
);


CREATE TABLE IMPLICA(
id_plata int,
id_reducere int,
primary key (id_plata, id_reducere),
constraint fk_plataimplica foreign key (id_plata) references plata(id_plata),
constraint fk_reducereimplica foreign key (id_reducere) references reducere(id_reducere)
);

INSERT INTO spectacol VALUES (1, 'film', 'Omul cu umbra');
INSERT INTO spectacol VALUES (2, 'film', 'The Shawshank Redemption');
INSERT INTO spectacol VALUES (3, 'film', 'The Godfather');
INSERT INTO spectacol VALUES (4, 'film', 'The Dark Knight');
INSERT INTO spectacol VALUES (5, 'film', 'Pulp Fiction ');
INSERT INTO spectacol VALUES (6, 'film', 'Amelie');
INSERT INTO spectacol VALUES (7, 'film', 'Fight Club');
INSERT INTO spectacol VALUES (8, 'film', 'The Passion of Joan of Arc');
INSERT INTO spectacol VALUES (9, 'film', 'Forrest Gump');
INSERT INTO spectacol VALUES (10, 'film', 'La Vie en Rose');
INSERT INTO spectacol VALUES (11, 'film', 'Amintiri din Epoca de Aur');
INSERT INTO spectacol VALUES (12, 'film', 'Filantropica');
INSERT INTO spectacol VALUES (13, 'teatru', 'Long Days Journey Into Night');
INSERT INTO spectacol VALUES (14, 'teatru', 'Hamlet');
INSERT INTO spectacol VALUES (15, 'teatru', 'Whos Afraid of Virginia Woolf?');
INSERT INTO spectacol VALUES (16, 'teatru', 'Death of a Salesman ');
INSERT INTO spectacol VALUES (17, 'teatru', 'Oedipus Rex');
INSERT INTO spectacol VALUES (18, 'teatru', 'Angels in America');
INSERT INTO spectacol VALUES (19, 'teatru', 'The Glass Menagerie');
INSERT INTO spectacol VALUES (20, 'teatru', 'Look Back in Anger');
INSERT INTO spectacol VALUES (21, 'concert', 'Holograf @ Sala Polivalenta');
INSERT INTO spectacol VALUES (22, 'concert', 'Iron Maiden @ Romexpo');
INSERT INTO spectacol VALUES (23, 'concert', 'Simley @ Sala Polivalenta');
INSERT INTO spectacol VALUES (24, 'concert', 'Vita de Vie @ Filarmonica Timisoara');
INSERT INTO spectacol VALUES (25, 'concert', 'Hooverphonic @ Bucuresti');

INSERT INTO film VALUES (1, 136, 'Romana', to_date('1997-04-17', 'yyyy-mm-dd'),  'Romania', 'Documentar');
INSERT INTO film VALUES (2, 110, 'Engleza', to_date('2011-09-14', 'yyyy-mm-dd'),  'Marea Britanie', 'Thriller');
INSERT INTO film VALUES (3, 140, 'Engleza', to_date('1998-09-10', 'yyyy-mm-dd'),  'SUA', 'Thriller');
INSERT INTO film VALUES (4, 109, 'Engleza', to_date('2015-07-16', 'yyyy-mm-dd'),  'SUA', 'Actiune');
INSERT INTO film VALUES (5, 138, 'Engleza', to_date('1999-07-06', 'yyyy-mm-dd'),  'SUA', 'Actiune');
INSERT INTO film VALUES (6, 119, 'Franceza', to_date('2004-07-19', 'yyyy-mm-dd'),  'Franta', 'Drama');
INSERT INTO film VALUES (7, 131, 'Engleza', to_date('1998-09-20', 'yyyy-mm-dd'),  'SUA', 'Actiune');
INSERT INTO film VALUES (8, 125, 'Franceza', to_date('2020-05-04', 'yyyy-mm-dd'),  'Franta', 'Istoric');
INSERT INTO film VALUES (9, 139, 'Engleza', to_date('1999-08-08', 'yyyy-mm-dd'),  'SUA', 'Comedie');
INSERT INTO film VALUES (10, 108, 'Franceza', to_date('2019-10-16', 'yyyy-mm-dd'),  'Franta', 'Drama');
INSERT INTO film VALUES (11, 130, 'Romana', to_date('2014-08-19', 'yyyy-mm-dd'),  'Romania', 'Fictiune Istorica');
INSERT INTO film VALUES (12, 105, 'Romana', to_date('2020-04-19', 'yyyy-mm-dd'),  'Romania', 'Comedie');

INSERT INTO teatru VALUES (13, 'Eugene ONeill', 'Radu Afrim',  'Elena Fortu');
INSERT INTO teatru VALUES (14, 'William Shakespeare', 'Andrei Serban',  'Petrica Ionescu');
INSERT INTO teatru VALUES (15, 'Edward Albee', 'Victor Ioan Frunza',  'Livia Ante');
INSERT INTO teatru VALUES (16, 'Arthur Miller', 'Claudiu Goga',  'Elena Fortu');
INSERT INTO teatru VALUES (17, 'Sophocles', 'Andrei Serban',  'Lidia Luludis');
INSERT INTO teatru VALUES (18, 'Tony Kushner', 'Victor Ioan Frunza',  'Nelly Merola');
INSERT INTO teatru VALUES (19, 'Tennessee Williams', 'Claudiu Goga',  'Virgil Moise');
INSERT INTO teatru VALUES (20, 'John Osborne', 'Radu Afrim',  'Livia Ante');

INSERT INTO concert VALUES (21, 'Holograf', 'Stefan Banica Jr.',  'Pop Rock');
INSERT INTO concert VALUES (22, 'Iron Maiden', 'Car Seat Headrest',  'Hard Rock');
INSERT INTO concert VALUES (23, 'Smiley', 'Liviu Teodorescu',  'Pop');
INSERT INTO concert VALUES (24, 'Vita de Vie', 'Silviu Gherman',  'Rock Alternativ');
INSERT INTO concert VALUES (25, 'Hooverphonic', 'IRIS',  'Pop');

INSERT INTO organizator VALUES (1, 'Cornel Popescu', 'cornelpopescu@hotmail.com',  '0784819518');
INSERT INTO organizator VALUES (2, 'Ionel Teodor', 'ionel_tteo@yahoo.com',  '0725100212');
INSERT INTO organizator VALUES (3, 'Andrei Gilcea', 'gilcea_andrei31@gmail.com',  '0774333944');
INSERT INTO organizator VALUES (4, 'Rares Pauna', 'pauna_rar3@hotmail.com',  '0769834565');
INSERT INTO organizator VALUES (5, 'Cosmin Borcea', 'cosmin@borcea_events.com',  '0713528122');
INSERT INTO organizator VALUES (6, 'Alina Juga', 'juga_alina@gmail.com',  '0725516661');
INSERT INTO organizator VALUES (7, 'Valentin Chita', 'chita_valy93@yahoo.com',  '0719696162');
INSERT INTO organizator VALUES (8, 'Constantin Avram', 'constantin@avram.com',  '0777566245');
INSERT INTO organizator VALUES (9, 'Elena Avram', 'elena@avram.com',  '0763375245');
INSERT INTO organizator VALUES (10, 'Ana Ifrim', 'ifrim_ana_events@gmail.com',  '0771429381');

INSERT INTO oras VALUES (1, 'Bucuresti', 'Bucuresti');
INSERT INTO oras VALUES (2, 'Oradea', 'Bihor');
INSERT INTO oras VALUES (3, 'Arad', 'Banat');
INSERT INTO oras VALUES (4, 'Timisoara', 'Timis');
INSERT INTO oras VALUES (5, 'Craiova', 'Dolj');
INSERT INTO oras VALUES (6, 'Braila', 'Braila');
INSERT INTO oras VALUES (7, 'Satu Mare', 'Satu Mare');
INSERT INTO oras VALUES (8, 'Baia Mare', 'Maramures');
INSERT INTO oras VALUES (9, 'Botosani', 'Botosani');
INSERT INTO oras VALUES (10, 'Suceava', 'Suceava');

INSERT INTO locatie VALUES (1, 1, 'Great Bucharest Halls', 3, 'Str. Foisorului, 12-16');
INSERT INTO locatie VALUES (2, 2, 'Tuned@Arad', 2, 'Bd. Unirii 24');
INSERT INTO locatie VALUES (3, 3, 'Sera Cocorului', 4, 'Str. Cocorului 35');
INSERT INTO locatie VALUES (4, 4, 'Crystal Palace', 2, 'Bd. Iancu de Hendoara 120');
INSERT INTO locatie VALUES (5, 5, 'The Lions Hall', 4, 'Str. Luigi Cazzavillan 20');
INSERT INTO locatie VALUES (6, 6, 'Salile Mozaic', 3, 'Bd. Hristo Botev 93');
INSERT INTO locatie VALUES (7, 7, 'The Pitch - SM', 2, 'Str. Gramont 7');
INSERT INTO locatie VALUES (8, 8, 'The Pitch - BM', 1, 'Bd. Marasesti 76');
INSERT INTO locatie VALUES (9, 9, 'General Culture Hall Botosani', 1, 'Str. Izvorului 11');
INSERT INTO locatie VALUES (10, 10, 'Timeless Suceava', 2, 'Intrarea Humulesti 13');

INSERT INTO sala VALUES (1, 1, 'I. L. Caragiale', 17);
INSERT INTO sala VALUES (2, 1, 'Mihai Viteazu', 10);
INSERT INTO sala VALUES (3, 1, 'Ion Barbu', 12);
INSERT INTO sala VALUES (1, 2, 'Claudia Boghicevici', 6);
INSERT INTO sala VALUES (2, 2, 'Constantin Brancusi', 6);
INSERT INTO sala VALUES (1, 3, 'Henri Coanda', 16);
INSERT INTO sala VALUES (2, 3, 'Nicolae Iorga', 6);
INSERT INTO sala VALUES (3, 3, 'George Enescu', 8);
INSERT INTO sala VALUES (4, 3, 'Ion I.C. Bratianu', 9);
INSERT INTO sala VALUES (1, 4, 'Emil Cioran', 12);
INSERT INTO sala VALUES (2, 4, 'Petre tutea', 3);
INSERT INTO sala VALUES (1, 5, 'Nichita Stanescu', 4);
INSERT INTO sala VALUES (2, 5, 'Lucian Blaga', 3);
INSERT INTO sala VALUES (3, 5, 'Titu Maiorescu', 13);
INSERT INTO sala VALUES (4, 5, 'Nicolae Balcescu', 8);
INSERT INTO sala VALUES (1, 6, 'Marin Preda', 15);
INSERT INTO sala VALUES (2, 6, 'Grigore C. Moisil', 15);
INSERT INTO sala VALUES (3, 6, 'Anghel Saligny', 3);
INSERT INTO sala VALUES (1, 7, 'Sergiu Nicolaescu', 1);
INSERT INTO sala VALUES (2, 7, 'Ciprian Porumbescu', 11);
INSERT INTO sala VALUES (1, 8, 'Constantin Noica', 17);
INSERT INTO sala VALUES (1, 9, 'Maria Tanase', 6);
INSERT INTO sala VALUES (1, 10, 'Toma Caragiu', 14);
INSERT INTO sala VALUES (2, 10, 'Mihail Kogalniceanu', 1);

INSERT INTO loc VALUES (1, 1, 1, 'sala');
INSERT INTO loc VALUES (2, 1, 1, 'sala');
INSERT INTO loc VALUES (3, 1, 1, 'sala');
INSERT INTO loc VALUES (4, 1, 1, 'sala');
INSERT INTO loc VALUES (5, 1, 1, 'sala');
INSERT INTO loc VALUES (6, 1, 1, 'sala');
INSERT INTO loc VALUES (7, 1, 1, 'sala');
INSERT INTO loc VALUES (8, 1, 1, 'sala');
INSERT INTO loc VALUES (9, 1, 1, 'loja');
INSERT INTO loc VALUES (10, 1, 1, 'loja');
INSERT INTO loc VALUES (11, 1, 1, 'loja');
INSERT INTO loc VALUES (12, 1, 1, 'loja');
INSERT INTO loc VALUES (13, 1, 1, 'loja');
INSERT INTO loc VALUES (14, 1, 1, 'loja');
INSERT INTO loc VALUES (15, 1, 1, 'loja');
INSERT INTO loc VALUES (16, 1, 1, 'loja');
INSERT INTO loc VALUES (17, 1, 1, 'loja');
INSERT INTO loc VALUES (1, 2, 1, 'sala');
INSERT INTO loc VALUES (2, 2, 1, 'sala');
INSERT INTO loc VALUES (3, 2, 1, 'sala');
INSERT INTO loc VALUES (4, 2, 1, 'sala');
INSERT INTO loc VALUES (5, 2, 1, 'sala');
INSERT INTO loc VALUES (6, 2, 1, 'sala');
INSERT INTO loc VALUES (7, 2, 1, 'sala');
INSERT INTO loc VALUES (8, 2, 1, 'sala');
INSERT INTO loc VALUES (9, 2, 1, 'sala');
INSERT INTO loc VALUES (10, 2, 1, 'sala');
INSERT INTO loc VALUES (1, 3, 1, 'sala');
INSERT INTO loc VALUES (2, 3, 1, 'sala');
INSERT INTO loc VALUES (3, 3, 1, 'sala');
INSERT INTO loc VALUES (4, 3, 1, 'sala');
INSERT INTO loc VALUES (5, 3, 1, 'sala');
INSERT INTO loc VALUES (6, 3, 1, 'sala');
INSERT INTO loc VALUES (7, 3, 1, 'sala');
INSERT INTO loc VALUES (8, 3, 1, 'loja');
INSERT INTO loc VALUES (9, 3, 1, 'loja');
INSERT INTO loc VALUES (10, 3, 1, 'loja');
INSERT INTO loc VALUES (11, 3, 1, 'loja');
INSERT INTO loc VALUES (12, 3, 1, 'loja');
INSERT INTO loc VALUES (1, 1, 2, 'normal');
INSERT INTO loc VALUES (2, 1, 2, 'normal');
INSERT INTO loc VALUES (3, 1, 2, 'normal');
INSERT INTO loc VALUES (4, 1, 2, 'normal');
INSERT INTO loc VALUES (5, 1, 2, 'normal');
INSERT INTO loc VALUES (6, 1, 2, 'normal');
INSERT INTO loc VALUES (1, 2, 2, 'loja');
INSERT INTO loc VALUES (2, 2, 2, 'loja');
INSERT INTO loc VALUES (3, 2, 2, 'loja');
INSERT INTO loc VALUES (4, 2, 2, 'loja');
INSERT INTO loc VALUES (5, 2, 2, 'loja');
INSERT INTO loc VALUES (6, 2, 2, 'loja');
INSERT INTO loc VALUES (1, 1, 3, 'loja');
INSERT INTO loc VALUES (2, 1, 3, 'loja');
INSERT INTO loc VALUES (3, 1, 3, 'loja');
INSERT INTO loc VALUES (4, 1, 3, 'loja');
INSERT INTO loc VALUES (5, 1, 3, 'loja');
INSERT INTO loc VALUES (6, 1, 3, 'loja');
INSERT INTO loc VALUES (7, 1, 3, 'loja');
INSERT INTO loc VALUES (8, 1, 3, 'sala');
INSERT INTO loc VALUES (9, 1, 3, 'sala');
INSERT INTO loc VALUES (10, 1, 3, 'sala');
INSERT INTO loc VALUES (11, 1, 3, 'sala');
INSERT INTO loc VALUES (12, 1, 3, 'sala');
INSERT INTO loc VALUES (13, 1, 3, 'sala');
INSERT INTO loc VALUES (14, 1, 3, 'sala');
INSERT INTO loc VALUES (15, 1, 3, 'sala');
INSERT INTO loc VALUES (16, 1, 3, 'sala');
INSERT INTO loc VALUES (1, 2, 3, 'normal');
INSERT INTO loc VALUES (2, 2, 3, 'normal');
INSERT INTO loc VALUES (3, 2, 3, 'normal');
INSERT INTO loc VALUES (4, 2, 3, 'normal');
INSERT INTO loc VALUES (5, 2, 3, 'normal');
INSERT INTO loc VALUES (6, 2, 3, 'normal');
INSERT INTO loc VALUES (1, 3, 3, 'normal');
INSERT INTO loc VALUES (2, 3, 3, 'normal');
INSERT INTO loc VALUES (3, 3, 3, 'normal');
INSERT INTO loc VALUES (4, 3, 3, 'normal');
INSERT INTO loc VALUES (5, 3, 3, 'normal');
INSERT INTO loc VALUES (6, 3, 3, 'normal');
INSERT INTO loc VALUES (7, 3, 3, 'normal');
INSERT INTO loc VALUES (8, 3, 3, 'normal');
INSERT INTO loc VALUES (1, 4, 3, 'normal');
INSERT INTO loc VALUES (2, 4, 3, 'normal');
INSERT INTO loc VALUES (3, 4, 3, 'normal');
INSERT INTO loc VALUES (4, 4, 3, 'normal');
INSERT INTO loc VALUES (5, 4, 3, 'normal');
INSERT INTO loc VALUES (6, 4, 3, 'normal');
INSERT INTO loc VALUES (7, 4, 3, 'normal');
INSERT INTO loc VALUES (8, 4, 3, 'normal');
INSERT INTO loc VALUES (9, 4, 3, 'normal');
INSERT INTO loc VALUES (1, 1, 4, 'normal');
INSERT INTO loc VALUES (2, 1, 4, 'normal');
INSERT INTO loc VALUES (3, 1, 4, 'normal');
INSERT INTO loc VALUES (4, 1, 4, 'normal');
INSERT INTO loc VALUES (5, 1, 4, 'normal');
INSERT INTO loc VALUES (6, 1, 4, 'normal');
INSERT INTO loc VALUES (7, 1, 4, 'normal');
INSERT INTO loc VALUES (8, 1, 4, 'normal');
INSERT INTO loc VALUES (9, 1, 4, 'normal');
INSERT INTO loc VALUES (10, 1, 4, 'normal');
INSERT INTO loc VALUES (11, 1, 4, 'normal');
INSERT INTO loc VALUES (12, 1, 4, 'normal');
INSERT INTO loc VALUES (1, 2, 4, 'normal');
INSERT INTO loc VALUES (2, 2, 4, 'normal');
INSERT INTO loc VALUES (3, 2, 4, 'normal');
INSERT INTO loc VALUES (1, 1, 5, 'sala');
INSERT INTO loc VALUES (2, 1, 5, 'sala');
INSERT INTO loc VALUES (3, 1, 5, 'sala');
INSERT INTO loc VALUES (4, 1, 5, 'sala');
INSERT INTO loc VALUES (1, 2, 5, 'sala');
INSERT INTO loc VALUES (2, 2, 5, 'sala');
INSERT INTO loc VALUES (3, 2, 5, 'sala');
INSERT INTO loc VALUES (1, 3, 5, 'sala');
INSERT INTO loc VALUES (2, 3, 5, 'sala');
INSERT INTO loc VALUES (3, 3, 5, 'sala');
INSERT INTO loc VALUES (4, 3, 5, 'sala');
INSERT INTO loc VALUES (5, 3, 5, 'sala');
INSERT INTO loc VALUES (6, 3, 5, 'sala');
INSERT INTO loc VALUES (7, 3, 5, 'sala');
INSERT INTO loc VALUES (8, 3, 5, 'sala');
INSERT INTO loc VALUES (9, 3, 5, 'sala');
INSERT INTO loc VALUES (10, 3, 5, 'sala');
INSERT INTO loc VALUES (11, 3, 5, 'sala');
INSERT INTO loc VALUES (12, 3, 5, 'sala');
INSERT INTO loc VALUES (13, 3, 5, 'sala');
INSERT INTO loc VALUES (1, 4, 5, 'loja');
INSERT INTO loc VALUES (2, 4, 5, 'loja');
INSERT INTO loc VALUES (3, 4, 5, 'loja');
INSERT INTO loc VALUES (4, 4, 5, 'loja');
INSERT INTO loc VALUES (5, 4, 5, 'loja');
INSERT INTO loc VALUES (6, 4, 5, 'loja');
INSERT INTO loc VALUES (7, 4, 5, 'loja');
INSERT INTO loc VALUES (8, 4, 5, 'loja');
INSERT INTO loc VALUES (1, 1, 6, 'loja');
INSERT INTO loc VALUES (2, 1, 6, 'loja');
INSERT INTO loc VALUES (3, 1, 6, 'loja');
INSERT INTO loc VALUES (4, 1, 6, 'loja');
INSERT INTO loc VALUES (5, 1, 6, 'loja');
INSERT INTO loc VALUES (6, 1, 6, 'loja');
INSERT INTO loc VALUES (7, 1, 6, 'loja');
INSERT INTO loc VALUES (8, 1, 6, 'loja');
INSERT INTO loc VALUES (9, 1, 6, 'loja');
INSERT INTO loc VALUES (10, 1, 6, 'loja');
INSERT INTO loc VALUES (11, 1, 6, 'loja');
INSERT INTO loc VALUES (12, 1, 6, 'loja');
INSERT INTO loc VALUES (13, 1, 6, 'loja');
INSERT INTO loc VALUES (14, 1, 6, 'loja');
INSERT INTO loc VALUES (15, 1, 6, 'loja');
INSERT INTO loc VALUES (1, 2, 6, 'normal');
INSERT INTO loc VALUES (2, 2, 6, 'normal');
INSERT INTO loc VALUES (3, 2, 6, 'normal');
INSERT INTO loc VALUES (4, 2, 6, 'normal');
INSERT INTO loc VALUES (5, 2, 6, 'normal');
INSERT INTO loc VALUES (6, 2, 6, 'normal');
INSERT INTO loc VALUES (7, 2, 6, 'normal');
INSERT INTO loc VALUES (8, 2, 6, 'normal');
INSERT INTO loc VALUES (9, 2, 6, 'normal');
INSERT INTO loc VALUES (10, 2, 6, 'normal');
INSERT INTO loc VALUES (11, 2, 6, 'normal');
INSERT INTO loc VALUES (12, 2, 6, 'normal');
INSERT INTO loc VALUES (13, 2, 6, 'normal');
INSERT INTO loc VALUES (14, 2, 6, 'normal');
INSERT INTO loc VALUES (15, 2, 6, 'normal');
INSERT INTO loc VALUES (1, 3, 6, 'sala');
INSERT INTO loc VALUES (2, 3, 6, 'sala');
INSERT INTO loc VALUES (3, 3, 6, 'sala');
INSERT INTO loc VALUES (1, 1, 7, 'sala');
INSERT INTO loc VALUES (1, 2, 7, 'sala');
INSERT INTO loc VALUES (2, 2, 7, 'sala');
INSERT INTO loc VALUES (3, 2, 7, 'sala');
INSERT INTO loc VALUES (4, 2, 7, 'sala');
INSERT INTO loc VALUES (5, 2, 7, 'sala');
INSERT INTO loc VALUES (6, 2, 7, 'sala');
INSERT INTO loc VALUES (7, 2, 7, 'sala');
INSERT INTO loc VALUES (8, 2, 7, 'sala');
INSERT INTO loc VALUES (9, 2, 7, 'sala');
INSERT INTO loc VALUES (10, 2, 7, 'sala');
INSERT INTO loc VALUES (11, 2, 7, 'sala');
INSERT INTO loc VALUES (1, 1, 8, 'loja');
INSERT INTO loc VALUES (2, 1, 8, 'loja');
INSERT INTO loc VALUES (3, 1, 8, 'loja');
INSERT INTO loc VALUES (4, 1, 8, 'loja');
INSERT INTO loc VALUES (5, 1, 8, 'loja');
INSERT INTO loc VALUES (6, 1, 8, 'loja');
INSERT INTO loc VALUES (7, 1, 8, 'loja');
INSERT INTO loc VALUES (8, 1, 8, 'loja');
INSERT INTO loc VALUES (9, 1, 8, 'loja');
INSERT INTO loc VALUES (10, 1, 8, 'loja');
INSERT INTO loc VALUES (11, 1, 8, 'loja');
INSERT INTO loc VALUES (12, 1, 8, 'loja');
INSERT INTO loc VALUES (13, 1, 8, 'loja');
INSERT INTO loc VALUES (14, 1, 8, 'loja');
INSERT INTO loc VALUES (15, 1, 8, 'loja');
INSERT INTO loc VALUES (16, 1, 8, 'loja');
INSERT INTO loc VALUES (17, 1, 8, 'loja');
INSERT INTO loc VALUES (1, 1, 9, 'vip');
INSERT INTO loc VALUES (2, 1, 9, 'vip');
INSERT INTO loc VALUES (3, 1, 9, 'vip');
INSERT INTO loc VALUES (4, 1, 9, 'vip');
INSERT INTO loc VALUES (5, 1, 9, 'vip');
INSERT INTO loc VALUES (6, 1, 9, 'vip');
INSERT INTO loc VALUES (1, 1, 10, 'vip');
INSERT INTO loc VALUES (2, 1, 10, 'vip');
INSERT INTO loc VALUES (3, 1, 10, 'vip');
INSERT INTO loc VALUES (4, 1, 10, 'vip');
INSERT INTO loc VALUES (5, 1, 10, 'vip');
INSERT INTO loc VALUES (6, 1, 10, 'vip');
INSERT INTO loc VALUES (7, 1, 10, 'vip');
INSERT INTO loc VALUES (8, 1, 10, 'vip');
INSERT INTO loc VALUES (9, 1, 10, 'vip');
INSERT INTO loc VALUES (10, 1, 10, 'vip');

INSERT INTO eveniment VALUES (1, 9, 7, 1, 9, to_date('2022-12-23', 'yyyy-mm-dd'), '19:30', '21:00');
INSERT INTO eveniment VALUES (2, 5, 8, 1, 5, to_date('2022-07-01', 'yyyy-mm-dd'), '17:00', '19:30');
INSERT INTO eveniment VALUES (3, 7, 4, 2, 7, to_date('2022-08-06', 'yyyy-mm-dd'), '14:30', '17:30');
INSERT INTO eveniment VALUES (4, 25, 9, 1, 5, to_date('2022-08-13', 'yyyy-mm-dd'), '16:15', '19:00');
INSERT INTO eveniment VALUES (5, 7, 8, 1, 7, to_date('2022-10-28', 'yyyy-mm-dd'), '13:00', '15:00');
INSERT INTO eveniment VALUES (6, 10, 2, 2, 10, to_date('2022-07-03', 'yyyy-mm-dd'), '18:00', '20:30');
INSERT INTO eveniment VALUES (7, 10, 9, 1, 10, to_date('2022-08-24', 'yyyy-mm-dd'), '12:00', '16:00');
INSERT INTO eveniment VALUES (8, 12, 5, 1, 2, to_date('2022-06-29', 'yyyy-mm-dd'), '13:00', '15:00');
INSERT INTO eveniment VALUES (9, 20, 7, 2, 10, to_date('2022-10-04', 'yyyy-mm-dd'), '19:15', '21:15');
INSERT INTO eveniment VALUES (10, 21, 4, 2, 1, to_date('2022-08-11', 'yyyy-mm-dd'), '20:00', '22:30');
INSERT INTO eveniment VALUES (11, 14, 1, 3, 4, to_date('2022-10-24', 'yyyy-mm-dd'), '21:00', '23:00');
INSERT INTO eveniment VALUES (12, 15, 7, 2, 5, to_date('2022-10-25', 'yyyy-mm-dd'), '20:30', '23:30');
INSERT INTO eveniment VALUES (13, 15, 6, 2, 5, to_date('2022-10-16', 'yyyy-mm-dd'), '17:00', '20:00');
INSERT INTO eveniment VALUES (14, 1, 8, 1, 1, to_date('2022-09-21', 'yyyy-mm-dd'), '13:45', '16:00');
INSERT INTO eveniment VALUES (15, 19, 9, 1, 9, to_date('2022-10-24', 'yyyy-mm-dd'), '16:30', '18:30');
INSERT INTO eveniment VALUES (16, 2, 7, 2, 2, to_date('2022-12-04', 'yyyy-mm-dd'), '18:30', '21:00');
INSERT INTO eveniment VALUES (17, 20, 1, 1, 10, to_date('2022-06-19', 'yyyy-mm-dd'), '19:00', '21:30');
INSERT INTO eveniment VALUES (18, 15, 2, 2, 5, to_date('2022-09-15', 'yyyy-mm-dd'), '15:30', '17:00');
INSERT INTO eveniment VALUES (19, 22, 7, 1, 2, to_date('2022-09-27', 'yyyy-mm-dd'), '21:15', '23:30');
INSERT INTO eveniment VALUES (20, 12, 1, 3, 2, to_date('2022-08-13', 'yyyy-mm-dd'), '19:15', '22:45');
INSERT INTO eveniment VALUES (21, 5, 4, 2, 5, to_date('2022-06-10', 'yyyy-mm-dd'), '18:00', '20:15');
INSERT INTO eveniment VALUES (22, 1, 4, 1, 1, to_date('2022-08-10', 'yyyy-mm-dd'), '14:30', '16:00');
INSERT INTO eveniment VALUES (23, 21, 1, 2, 1, to_date('2022-12-22', 'yyyy-mm-dd'), '11:30', '13:30');
INSERT INTO eveniment VALUES (24, 16, 6, 3, 6, to_date('2022-08-21', 'yyyy-mm-dd'), '15:00', '17:30');
INSERT INTO eveniment VALUES (25, 12, 4, 2, 2, to_date('2022-11-24', 'yyyy-mm-dd'), '21:15', '23:30');
INSERT INTO eveniment VALUES (26, 6, 8, 1, 6, to_date('2022-07-02', 'yyyy-mm-dd'), '16:35', '19:45');
INSERT INTO eveniment VALUES (27, 13, 7, 2, 3, to_date('2022-08-30', 'yyyy-mm-dd'), '17:50', '20:15');
INSERT INTO eveniment VALUES (28, 6, 5, 2, 6, to_date('2022-11-04', 'yyyy-mm-dd'), '18:30', '21:00');
INSERT INTO eveniment VALUES (29, 4, 9, 1, 4, to_date('2022-11-02', 'yyyy-mm-dd'), '13:30', '15:45');
INSERT INTO eveniment VALUES (30, 8, 8, 1, 8, to_date('2022-11-25', 'yyyy-mm-dd'), '23:30', '02:00');
INSERT INTO eveniment VALUES (31, 5, 7, 1, 5, to_date('2022-08-13', 'yyyy-mm-dd'), '14:00', '16:00');
INSERT INTO eveniment VALUES (32, 20, 6, 1, 10, to_date('2022-06-23', 'yyyy-mm-dd'), '20:30', '22:15');
INSERT INTO eveniment VALUES (33, 14, 8, 1, 4, to_date('2022-06-24', 'yyyy-mm-dd'), '15:30', '17:30');
INSERT INTO eveniment VALUES (34, 23, 1, 2, 3, to_date('2022-09-19', 'yyyy-mm-dd'), '19:30', '22:00');
INSERT INTO eveniment VALUES (35, 16, 5, 4, 6, to_date('2022-12-12', 'yyyy-mm-dd'), '14:15', '16:30');
INSERT INTO eveniment VALUES (36, 1, 4, 2, 1, to_date('2022-07-22', 'yyyy-mm-dd'), '18:00', '20:15');
INSERT INTO eveniment VALUES (37, 14, 3, 4, 4, to_date('2022-08-22', 'yyyy-mm-dd'), '21:30', '00:00');
INSERT INTO eveniment VALUES (38, 8, 10, 2, 8, to_date('2022-08-20', 'yyyy-mm-dd'), '20:00', '22:30');
INSERT INTO eveniment VALUES (39, 14, 3, 3, 4, to_date('2022-10-31', 'yyyy-mm-dd'), '16:00', '18:15');
INSERT INTO eveniment VALUES (40, 15, 8, 1, 5, to_date('1899-12-30', 'yyyy-mm-dd'), '17:30', '19:45');

INSERT INTO utilizator VALUES (secv_utilizator.nextval, 'Lungu David', 'sfdsreds!2313', 'lungudavid@gmail.com', '0753296131' );
INSERT INTO utilizator VALUES (secv_utilizator.nextval, 'Birsan Constantin', 'wdsagreds3', 'birsanconstantin@hotmail.com', '0793884781' );
INSERT INTO utilizator VALUES (secv_utilizator.nextval, 'Bancescu Alexandru', '432r3trefds', 'bancescu_alex202@yahoo.com', '0729790379' );
INSERT INTO utilizator VALUES (secv_utilizator.nextval, 'Dinica Andrei', 'frggew4', 'andreidini_ca4392@hotmail.com', '0710448446' );
INSERT INTO utilizator VALUES (secv_utilizator.nextval, 'Surdu Robert', 'sadbhy5t', 'bob_ia@gmail.com', '0771271926' );
INSERT INTO utilizator VALUES (secv_utilizator.nextval, 'Marian Cocos', 'mk7i5u6yr5etr', 'maarian__@hotmail.com', '0706377531' );
INSERT INTO utilizator VALUES (secv_utilizator.nextval, 'Ungureanu Cristian', 'kie3jhr24', 'cristian_342_ed@gmail.com', '0702498499' );

INSERT INTO rezervare VALUES (1, 4, to_date('2022-07-01', 'yyyy-mm-dd'),  2, 1);
INSERT INTO rezervare VALUES (2, 6, to_date('2022-07-03', 'yyyy-mm-dd'),  5, 1);
INSERT INTO rezervare VALUES (3, 3, to_date('2022-08-06', 'yyyy-mm-dd'),  3, 1);
INSERT INTO rezervare VALUES (4, 2, to_date('2022-08-24', 'yyyy-mm-dd'),  1, 0);
INSERT INTO rezervare VALUES (5, 6, to_date('2022-10-25', 'yyyy-mm-dd'),  2, 0);
INSERT INTO rezervare VALUES (6, 6, to_date('2022-09-21', 'yyyy-mm-dd'),  3, 1);
INSERT INTO rezervare VALUES (7, 3, to_date('2022-06-10', 'yyyy-mm-dd'),  1, 0);
INSERT INTO rezervare VALUES (8, 2, to_date('2022-06-19', 'yyyy-mm-dd'),  2, 1);
INSERT INTO rezervare VALUES (9, 4, to_date('2022-09-27', 'yyyy-mm-dd'),  3, 0);
INSERT INTO rezervare VALUES (10, 2, to_date('2022-08-21', 'yyyy-mm-dd'),  1, 1);
INSERT INTO rezervare VALUES (11, 3, to_date('2022-08-24', 'yyyy-mm-dd'),  1, 1);

INSERT INTO reducere VALUES (1, 'Student', 50);
INSERT INTO reducere VALUES (2, 'Pensionar', 50);
INSERT INTO reducere VALUES (3, 'Angajat', 35);
INSERT INTO reducere VALUES (4, 'Donator sange', 40);
INSERT INTO reducere VALUES (5, 'Elev', 25);

INSERT INTO plata VALUES (1, 90, to_date('2022-07-01', 'yyyy-mm-dd'),  1);
INSERT INTO plata VALUES (2, 150, to_date('2022-07-03', 'yyyy-mm-dd'),  2);
INSERT INTO plata VALUES (3, 195, to_date('2022-08-06', 'yyyy-mm-dd'),  3);
INSERT INTO plata VALUES (4, 75, to_date('2022-09-21', 'yyyy-mm-dd'),  6);
INSERT INTO plata VALUES (5, 90, to_date('2022-06-19', 'yyyy-mm-dd'),  8);
INSERT INTO plata VALUES (6, 25, to_date('2022-08-21', 'yyyy-mm-dd'),  10);
INSERT INTO plata VALUES (7, 45, to_date('2022-08-24', 'yyyy-mm-dd'),  11);

INSERT INTO implica VALUES (1, 1);
INSERT INTO implica VALUES (1, 2);
INSERT INTO implica VALUES (2, 1);
INSERT INTO implica VALUES (2, 2);
INSERT INTO implica VALUES (2, 3);
INSERT INTO implica VALUES (2, 4);
INSERT INTO implica VALUES (3, 4);
INSERT INTO implica VALUES (6, 1);
INSERT INTO implica VALUES (6, 5);
INSERT INTO implica VALUES (6, 3);
INSERT INTO implica VALUES (7, 1);
INSERT INTO implica VALUES (7, 3);

INSERT INTO bilet VALUES (1, 1, 1, 1, 7, NULL, 35, 0);
INSERT INTO bilet VALUES (1, 2, 1, 1, 8, NULL, 30, 0);
INSERT INTO bilet VALUES (2, 2, 2, 1, 8, NULL, 30, 0);
INSERT INTO bilet VALUES (3, 2, 3, 1, 8, NULL, 30, 0);
INSERT INTO bilet VALUES (4, 2, 4, 1, 8, NULL, 30, 0);
INSERT INTO bilet VALUES (5, 2, 5, 1, 8, NULL, 30, 0);
INSERT INTO bilet VALUES (1, 3, 1, 2, 4, 1, 45, 1);
INSERT INTO bilet VALUES (2, 3, 2, 2, 4, 1, 45, 1);
INSERT INTO bilet VALUES (3, 3, 3, 2, 4, NULL, 45, 0);
INSERT INTO bilet VALUES (1, 4, 1, 1, 9, 3, 65, 1);
INSERT INTO bilet VALUES (2, 4, 2, 1, 9, 3, 65, 1);
INSERT INTO bilet VALUES (3, 4, 3, 1, 9, 3, 65, 1);
INSERT INTO bilet VALUES (4, 4, 4, 1, 9, NULL, 65, 0);
INSERT INTO bilet VALUES (5, 4, 5, 1, 9, NULL, 65, 0);
INSERT INTO bilet VALUES (1, 5, 1, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (2, 5, 2, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (3, 5, 3, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (4, 5, 4, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (5, 5, 5, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (1, 6, 1, 2, 2, NULL, 35, 0);
INSERT INTO bilet VALUES (2, 6, 2, 2, 2, NULL, 35, 0);
INSERT INTO bilet VALUES (3, 6, 3, 2, 2, NULL, 35, 0);
INSERT INTO bilet VALUES (4, 6, 4, 2, 2, NULL, 35, 0);
INSERT INTO bilet VALUES (5, 6, 5, 2, 2, NULL, 35, 0);
INSERT INTO bilet VALUES (1, 7, 1, 1, 9, 2, 30, 1);
INSERT INTO bilet VALUES (2, 7, 2, 1, 9, 2, 30, 1);
INSERT INTO bilet VALUES (3, 7, 3, 1, 9, 2, 30, 1);
INSERT INTO bilet VALUES (4, 7, 4, 1, 9, 2, 30, 1);
INSERT INTO bilet VALUES (5, 7, 5, 1, 9, 2, 30, 1);
INSERT INTO bilet VALUES (1, 8, 1, 1, 5, 4, 45, 1);
INSERT INTO bilet VALUES (2, 8, 2, 1, 5, NULL, 45, 0);
INSERT INTO bilet VALUES (3, 8, 3, 1, 5, 11, 45, 1);
INSERT INTO bilet VALUES (4, 8, 4, 1, 5, NULL, 45, 0);
INSERT INTO bilet VALUES (1, 9, 1, 2, 7, NULL, 65, 0);
INSERT INTO bilet VALUES (2, 9, 2, 2, 7, NULL, 65, 0);
INSERT INTO bilet VALUES (3, 9, 3, 2, 7, NULL, 65, 0);
INSERT INTO bilet VALUES (4, 9, 4, 2, 7, NULL, 65, 0);
INSERT INTO bilet VALUES (5, 9, 5, 2, 7, NULL, 65, 0);
INSERT INTO bilet VALUES (1, 10, 1, 2, 4, NULL, 25, 0);
INSERT INTO bilet VALUES (2, 10, 2, 2, 4, NULL, 25, 0);
INSERT INTO bilet VALUES (3, 10, 3, 2, 4, NULL, 25, 0);
INSERT INTO bilet VALUES (1, 11, 1, 3, 1, NULL, 35, 0);
INSERT INTO bilet VALUES (2, 11, 2, 3, 1, NULL, 35, 0);
INSERT INTO bilet VALUES (3, 11, 3, 3, 1, NULL, 35, 0);
INSERT INTO bilet VALUES (4, 11, 4, 3, 1, NULL, 35, 0);
INSERT INTO bilet VALUES (5, 11, 5, 3, 1, NULL, 35, 0);
INSERT INTO bilet VALUES (1, 12, 1, 2, 7, NULL, 30, 0);
INSERT INTO bilet VALUES (2, 12, 2, 2, 7, NULL, 30, 0);
INSERT INTO bilet VALUES (3, 12, 3, 2, 7, NULL, 30, 0);
INSERT INTO bilet VALUES (4, 12, 4, 2, 7, NULL, 30, 0);
INSERT INTO bilet VALUES (5, 12, 5, 2, 7, NULL, 30, 0);
INSERT INTO bilet VALUES (1, 13, 1, 2, 6, 5, 45, 1);
INSERT INTO bilet VALUES (2, 13, 2, 2, 6, 5, 45, 1);
INSERT INTO bilet VALUES (3, 13, 3, 2, 6, NULL, 45, 0);
INSERT INTO bilet VALUES (4, 13, 4, 2, 6, NULL, 45, 0);
INSERT INTO bilet VALUES (5, 13, 5, 2, 6, NULL, 45, 0);
INSERT INTO bilet VALUES (1, 14, 1, 1, 8, NULL, 65, 0);
INSERT INTO bilet VALUES (2, 14, 2, 1, 8, NULL, 65, 0);
INSERT INTO bilet VALUES (3, 14, 3, 1, 8, NULL, 65, 0);
INSERT INTO bilet VALUES (4, 14, 4, 1, 8, NULL, 65, 0);
INSERT INTO bilet VALUES (5, 14, 5, 1, 8, NULL, 65, 0);
INSERT INTO bilet VALUES (1, 15, 1, 1, 9, 6, 25, 1);
INSERT INTO bilet VALUES (2, 15, 2, 1, 9, 6, 25, 1);
INSERT INTO bilet VALUES (3, 15, 3, 1, 9, 6, 25, 1);
INSERT INTO bilet VALUES (4, 15, 4, 1, 9, NULL, 25, 0);
INSERT INTO bilet VALUES (5, 15, 5, 1, 9, NULL, 25, 0);
INSERT INTO bilet VALUES (1, 16, 1, 2, 7, NULL, 35, 0);
INSERT INTO bilet VALUES (2, 16, 2, 2, 7, NULL, 35, 0);
INSERT INTO bilet VALUES (3, 16, 3, 2, 7, NULL, 35, 0);
INSERT INTO bilet VALUES (4, 16, 4, 2, 7, NULL, 35, 0);
INSERT INTO bilet VALUES (5, 16, 5, 2, 7, NULL, 35, 0);
INSERT INTO bilet VALUES (1, 17, 1, 1, 1, NULL, 30, 0);
INSERT INTO bilet VALUES (2, 17, 2, 1, 1, NULL, 30, 0);
INSERT INTO bilet VALUES (3, 17, 3, 1, 1, NULL, 30, 0);
INSERT INTO bilet VALUES (4, 17, 4, 1, 1, NULL, 30, 0);
INSERT INTO bilet VALUES (5, 17, 5, 1, 1, NULL, 30, 0);
INSERT INTO bilet VALUES (1, 18, 1, 2, 2, NULL, 45, 0);
INSERT INTO bilet VALUES (2, 18, 2, 2, 2, 8, 45, 1);
INSERT INTO bilet VALUES (3, 18, 3, 2, 2, 8, 45, 1);
INSERT INTO bilet VALUES (4, 18, 4, 2, 2, NULL, 45, 0);
INSERT INTO bilet VALUES (5, 18, 5, 2, 2, NULL, 45, 0);
INSERT INTO bilet VALUES (1, 19, 1, 1, 7, NULL, 65, 0);
INSERT INTO bilet VALUES (1, 20, 1, 3, 1, NULL, 25, 0);
INSERT INTO bilet VALUES (2, 20, 2, 3, 1, NULL, 25, 0);
INSERT INTO bilet VALUES (3, 20, 3, 3, 1, 9, 25, 1);
INSERT INTO bilet VALUES (4, 20, 4, 3, 1, 9, 25, 1);
INSERT INTO bilet VALUES (5, 20, 5, 3, 1, 9, 25, 1);
INSERT INTO bilet VALUES (1, 21, 1, 2, 4, NULL, 35, 0);
INSERT INTO bilet VALUES (2, 21, 2, 2, 4, NULL, 35, 0);
INSERT INTO bilet VALUES (3, 21, 3, 2, 4, NULL, 35, 0);
INSERT INTO bilet VALUES (1, 22, 1, 1, 4, 7, 30, 1);
INSERT INTO bilet VALUES (2, 22, 2, 1, 4, NULL, 30, 0);
INSERT INTO bilet VALUES (3, 22, 3, 1, 4, NULL, 30, 0);
INSERT INTO bilet VALUES (4, 22, 4, 1, 4, NULL, 30, 0);
INSERT INTO bilet VALUES (5, 22, 5, 1, 4, NULL, 30, 0);
INSERT INTO bilet VALUES (1, 23, 1, 2, 1, NULL, 45, 0);
INSERT INTO bilet VALUES (2, 23, 2, 2, 1, NULL, 45, 0);
INSERT INTO bilet VALUES (3, 23, 3, 2, 1, NULL, 45, 0);
INSERT INTO bilet VALUES (4, 23, 4, 2, 1, NULL, 45, 0);
INSERT INTO bilet VALUES (5, 23, 5, 2, 1, NULL, 45, 0);
INSERT INTO bilet VALUES (1, 24, 1, 3, 6, NULL, 65, 0);
INSERT INTO bilet VALUES (2, 24, 2, 3, 6, NULL, 65, 0);
INSERT INTO bilet VALUES (3, 24, 3, 3, 6, NULL, 65, 0);
INSERT INTO bilet VALUES (1, 25, 1, 2, 4, 10, 25, 1);
INSERT INTO bilet VALUES (2, 25, 2, 2, 4, NULL, 25, 0);
INSERT INTO bilet VALUES (3, 25, 3, 2, 4, NULL, 25, 0);
INSERT INTO bilet VALUES (1, 26, 1, 1, 8, NULL, 35, 0);
INSERT INTO bilet VALUES (2, 26, 2, 1, 8, NULL, 35, 0);
INSERT INTO bilet VALUES (3, 26, 3, 1, 8, NULL, 35, 0);
INSERT INTO bilet VALUES (4, 26, 4, 1, 8, NULL, 35, 0);
INSERT INTO bilet VALUES (5, 26, 5, 1, 8, NULL, 35, 0);
INSERT INTO bilet VALUES (1, 27, 1, 2, 7, NULL, 30, 0);
INSERT INTO bilet VALUES (2, 27, 2, 2, 7, NULL, 30, 0);
INSERT INTO bilet VALUES (3, 27, 3, 2, 7, NULL, 30, 0);
INSERT INTO bilet VALUES (4, 27, 4, 2, 7, NULL, 30, 0);
INSERT INTO bilet VALUES (5, 27, 5, 2, 7, NULL, 30, 0);
INSERT INTO bilet VALUES (1, 28, 1, 2, 5, NULL, 45, 0);
INSERT INTO bilet VALUES (2, 28, 2, 2, 5, NULL, 45, 0);
INSERT INTO bilet VALUES (3, 28, 3, 2, 5, NULL, 45, 0);
INSERT INTO bilet VALUES (1, 29, 1, 1, 9, NULL, 65, 0);
INSERT INTO bilet VALUES (2, 29, 2, 1, 9, NULL, 65, 0);
INSERT INTO bilet VALUES (3, 29, 3, 1, 9, NULL, 65, 0);
INSERT INTO bilet VALUES (4, 29, 4, 1, 9, NULL, 65, 0);
INSERT INTO bilet VALUES (5, 29, 5, 1, 9, NULL, 65, 0);
INSERT INTO bilet VALUES (1, 30, 1, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (2, 30, 2, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (3, 30, 3, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (4, 30, 4, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (5, 30, 5, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (1, 31, 1, 1, 7, NULL, 35, 0);
INSERT INTO bilet VALUES (1, 32, 1, 1, 6, NULL, 30, 0);
INSERT INTO bilet VALUES (2, 32, 2, 1, 6, NULL, 30, 0);
INSERT INTO bilet VALUES (3, 32, 3, 1, 6, NULL, 30, 0);
INSERT INTO bilet VALUES (4, 32, 4, 1, 6, NULL, 30, 0);
INSERT INTO bilet VALUES (5, 32, 5, 1, 6, NULL, 30, 0);
INSERT INTO bilet VALUES (1, 33, 1, 1, 8, NULL, 45, 0);
INSERT INTO bilet VALUES (2, 33, 2, 1, 8, NULL, 45, 0);
INSERT INTO bilet VALUES (3, 33, 3, 1, 8, NULL, 45, 0);
INSERT INTO bilet VALUES (4, 33, 4, 1, 8, NULL, 45, 0);
INSERT INTO bilet VALUES (5, 33, 5, 1, 8, NULL, 45, 0);
INSERT INTO bilet VALUES (1, 34, 1, 2, 1, NULL, 65, 0);
INSERT INTO bilet VALUES (2, 34, 2, 2, 1, NULL, 65, 0);
INSERT INTO bilet VALUES (3, 34, 3, 2, 1, NULL, 65, 0);
INSERT INTO bilet VALUES (4, 34, 4, 2, 1, NULL, 65, 0);
INSERT INTO bilet VALUES (5, 34, 5, 2, 1, NULL, 65, 0);
INSERT INTO bilet VALUES (1, 35, 1, 4, 5, NULL, 25, 0);
INSERT INTO bilet VALUES (2, 35, 2, 4, 5, NULL, 25, 0);
INSERT INTO bilet VALUES (3, 35, 3, 4, 5, NULL, 25, 0);
INSERT INTO bilet VALUES (4, 35, 4, 4, 5, NULL, 25, 0);
INSERT INTO bilet VALUES (5, 35, 5, 4, 5, NULL, 25, 0);
INSERT INTO bilet VALUES (1, 36, 1, 2, 4, NULL, 35, 0);
INSERT INTO bilet VALUES (2, 36, 2, 2, 4, NULL, 35, 0);
INSERT INTO bilet VALUES (3, 36, 3, 2, 4, NULL, 35, 0);
INSERT INTO bilet VALUES (1, 37, 1, 4, 3, NULL, 30, 0);
INSERT INTO bilet VALUES (2, 37, 2, 4, 3, NULL, 30, 0);
INSERT INTO bilet VALUES (3, 37, 3, 4, 3, NULL, 30, 0);
INSERT INTO bilet VALUES (4, 37, 4, 4, 3, NULL, 30, 0);
INSERT INTO bilet VALUES (5, 37, 5, 4, 3, NULL, 30, 0);
INSERT INTO bilet VALUES (1, 39, 1, 3, 3, NULL, 65, 0);
INSERT INTO bilet VALUES (2, 39, 2, 3, 3, NULL, 65, 0);
INSERT INTO bilet VALUES (3, 39, 3, 3, 3, NULL, 65, 0);
INSERT INTO bilet VALUES (4, 39, 4, 3, 3, NULL, 65, 0);
INSERT INTO bilet VALUES (5, 39, 5, 3, 3, NULL, 65, 0);
INSERT INTO bilet VALUES (1, 40, 1, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (2, 40, 2, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (3, 40, 3, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (4, 40, 4, 1, 8, NULL, 25, 0);
INSERT INTO bilet VALUES (5, 40, 5, 1, 8, NULL, 25, 0);