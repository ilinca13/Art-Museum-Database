CREATE TABLE Vizitator (
CNP VARCHAR2(13) PRIMARY KEY,
Nume VARCHAR2(30) NOT NULL,
Prenume VARCHAR2(30) NOT NULL,
Email VARCHAR2(50) UNIQUE,
Telefon VARCHAR2(15)
);

ALTER TABLE Vizitator
ADD CONSTRAINT CK_Vizitator_CNP_Format
CHECK (SUBSTR(CNP, 1, 1) IN ('1', '2', '5', '6'));

ALTER TABLE Vizitator
ADD CONSTRAINT CK_Vizitator_CNP_Length
CHECK (LENGTH(CNP) = 13);


CREATE TABLE Metoda_Plata (
Metoda_ID INT PRIMARY KEY,
Tip_Plata VARCHAR2(30) NOT NULL,
Data_Adaugare DATE NOT NULL
);


CREATE TABLE Bilet (
Ticket_ID INT PRIMARY KEY,
CNP VARCHAR2(13) NOT NULL,
Metoda_ID INT NOT NULL,
Pret NUMBER(10,2),
Tip_Reducere VARCHAR2(20) DEFAULT 'pret_intreg'
);

ALTER TABLE Bilet
ADD CONSTRAINT FK_Bilet_Vizitator
FOREIGN KEY (CNP)
REFERENCES Vizitator(CNP) ON DELETE CASCADE;

ALTER TABLE Bilet
ADD CONSTRAINT FK_Bilet_Metoda_Plata
FOREIGN KEY (Metoda_ID)
REFERENCES Metoda_Plata(Metoda_ID) ON DELETE CASCADE;

ALTER TABLE Bilet
ADD CONSTRAINT CK_Bilet_Tip_Reducere
CHECK (Tip_Reducere IN ('copil', 'elev', 'student', 'pensionar', 'asistat_social', 'pret_intreg'));


CREATE TABLE Angajat (
Angajat_ID INT PRIMARY KEY,
Nume VARCHAR2(30) NOT NULL,
Prenume VARCHAR2(30) NOT NULL,
Email VARCHAR2(50) UNIQUE,
Telefon VARCHAR2(15),
Salariu NUMBER(10,2) NOT NULL,
Tip_Contract VARCHAR2(50),
Data_Angajare DATE NOT NULL
);


CREATE TABLE Curator (
Angajat_ID INT NOT NULL,
Specializare_Curent_Artistic VARCHAR2(100),
Tip_Studii_Superioare VARCHAR2(200),
Ani_Experienta INT DEFAULT 0
);

ALTER TABLE Curator
ADD CONSTRAINT FK_Curator_Angajat
FOREIGN KEY (Angajat_ID)
REFERENCES Angajat(Angajat_ID) ON DELETE CASCADE;
ALTER TABLE Curator
ADD CONSTRAINT PK_Curator
PRIMARY KEY (Angajat_ID);


CREATE TABLE Ghid (
Angajat_ID INT NOT NULL,
Atestari_Nivel_Limba VARCHAR2(200),
Certificari_Nivel_Formare VARCHAR2(200),
Disponibilitate VARCHAR2(200)
);

ALTER TABLE Ghid
ADD CONSTRAINT FK_Ghid_Angajat
FOREIGN KEY (Angajat_ID)
REFERENCES Angajat(Angajat_ID) ON DELETE CASCADE;
ALTER TABLE Ghid
ADD CONSTRAINT PK_Ghid
PRIMARY KEY (Angajat_ID);


CREATE TABLE Colectionar (
Colectionar_ID INT PRIMARY KEY,
Nume VARCHAR2(30) NOT NULL,
Prenume VARCHAR2(30),
Email VARCHAR2(50) UNIQUE,
Telefon VARCHAR2(15),
Tara VARCHAR2(30),
Oras VARCHAR2(30),
Categorie_Colectionar VARCHAR2(30),
Tip_Colaborare VARCHAR2(30),
Data_Inregistrare DATE NOT NULL
);

ALTER TABLE Colectionar
ADD CONSTRAINT CK_Colectionar_Categorie
CHECK (Categorie_Colectionar IN ('persoana_fizica', 'institutie', 'galerie', 'licitatie'));

ALTER TABLE Colectionar
ADD CONSTRAINT CK_Colectionar_Colaborare
CHECK (Tip_Colaborare IN ('donatie', 'imprumut', 'vanzare'));


CREATE TABLE Colectie (
Colectie_ID INT PRIMARY KEY,
Colectionar_ID INT NOT NULL,
Nume VARCHAR2(100),
Valoare_Estimata NUMBER(12,2),
Data_Start_Disponibilitate DATE NOT NULL,
Data_End_Disponibilitate DATE
);

ALTER TABLE Colectie
ADD CONSTRAINT FK_Colectie_Colectionar
FOREIGN KEY (Colectionar_ID)
REFERENCES Colectionar(Colectionar_ID) ON DELETE CASCADE;

ALTER TABLE Colectie
ADD CONSTRAINT CK_Colectie_Perioada_Disponibilitate
CHECK (Data_End_Disponibilitate IS NULL OR Data_End_Disponibilitate >= Data_Start_Disponibilitate);


CREATE TABLE Curent_Artistic (
Curent_ID INT PRIMARY KEY,
Nume VARCHAR2(30) NOT NULL,
Perioada_Start NUMBER(4) NOT NULL,
Perioada_End NUMBER(4),
Zona_Geografica VARCHAR2(100),
Caracteristici VARCHAR2(200),
Curent_Predecesor VARCHAR2(30)
);

ALTER TABLE Curent_Artistic
ADD CONSTRAINT CK_Curent_Perioada
CHECK (Perioada_End IS NULL OR Perioada_End >= Perioada_Start);


CREATE TABLE Artist (
Artist_ID INT PRIMARY KEY,
Nume VARCHAR2(30) NOT NULL,
Prenume VARCHAR2(30) NOT NULL,
Data_Nasterii DATE NOT NULL,
Data_Deces DATE,
Nationalitate VARCHAR2(30),
Biografie VARCHAR2(300)
);

ALTER TABLE Artist
ADD CONSTRAINT CK_Artist_Perioada_Viata
CHECK (Data_Deces IS NULL OR Data_Deces >= Data_Nasterii);


CREATE TABLE Opera (
Opera_ID INT PRIMARY KEY,
Colectie_ID INT NOT NULL,
Nume VARCHAR2(30) NOT NULL,
An_Creatie NUMBER(4),
Dimensiuni VARCHAR2(30),
Tehnica VARCHAR2(50)
);

ALTER TABLE Opera
ADD CONSTRAINT FK_Opera_Colectie
FOREIGN KEY (Colectie_ID)
REFERENCES Colectie(Colectie_ID) ON DELETE CASCADE;


CREATE TABLE Sala (
Sala_ID INT PRIMARY KEY,
etaj INT NOT NULL,
Capacitate_persoane INT,
Capacitate_Opere INT,
Regim_Functionare VARCHAR2(20) DEFAULT 'Functionala'
);

ALTER TABLE Sala
ADD CONSTRAINT CK_Sala_Regim_Functionare
CHECK (Regim_Functionare IN ('Functionala', 'Renovare', 'Amenajare', 'Rezervata'));


CREATE TABLE Expozitie (
Expozitie_ID INT PRIMARY KEY,
Curator_ID INT NOT NULL,
Nume VARCHAR2(50) NOT NULL,
Data_Inceput DATE NOT NULL,
Data_Final DATE,
Tip VARCHAR2(30) DEFAULT 'Temporara'
);


ALTER TABLE Expozitie
ADD CONSTRAINT FK_Expozitie_Curator
FOREIGN KEY (Curator_ID)
REFERENCES Curator(Angajat_ID);

ALTER TABLE Expozitie
ADD CONSTRAINT CK_Expozitie_Tip
CHECK (Tip IN ('Temporara', 'Permanenta'));

ALTER TABLE Expozitie
ADD CONSTRAINT CK_Expozitie_Perioada
CHECK (Data_Final IS NULL OR Data_Final >= Data_Inceput);


CREATE TABLE Tur_Special (
Tur_ID INT PRIMARY KEY,
Nume VARCHAR2(50) NOT NULL,
Durata_Minute INT,
Limba VARCHAR2(30) DEFAULT 'romana',
Maxim_Participanti INT,
Tip_Tur VARCHAR2(30) DEFAULT 'general');

ALTER TABLE Tur_Special
ADD CONSTRAINT CK_Tip_Tur
CHECK (Tip_Tur IN ('general', 'tematic', 'interactiv', 'arhitectural', 'copii'));


CREATE TABLE Programare_Tur (
Tur_ID INT NOT NULL,
Ghid_ID INT NOT NULL,
Data_Tur DATE NOT NULL,
Numar_Participanti INT,
Observatii VARCHAR2(200),
CONSTRAINT PK_Programare_Tur PRIMARY KEY (Ghid_ID, Tur_ID, Data_Tur),
CONSTRAINT FK_Programare_Tur_Ghid FOREIGN KEY (Ghid_ID) REFERENCES Ghid(Angajat_ID) ON DELETE CASCADE,
CONSTRAINT FK_Programare_Tur_Special FOREIGN KEY (Tur_ID) REFERENCES Tur_Special(Tur_ID) ON DELETE CASCADE
);


CREATE TABLE Alocare_Sala_Tur (
Tur_ID INT NOT NULL,
Sala_ID INT NOT NULL,
Ordine_In_Tur INT,
Minute_In_Sala INT,
CONSTRAINT PK_Alocare_Sala_Tur PRIMARY KEY (Tur_ID, Sala_ID),
CONSTRAINT FK_Alocare_Tur FOREIGN KEY (Tur_ID) REFERENCES Tur_Special(Tur_ID) ON DELETE CASCADE,
CONSTRAINT FK_Alocare_Sala FOREIGN KEY (Sala_ID) REFERENCES Sala(Sala_ID) ON DELETE CASCADE
);


CREATE TABLE Alocare_Sala_Expozitie (
Sala_ID INT NOT NULL,
Expozitie_ID INT NOT NULL,
Ordine_In_Expozitie INT,
Observatii_Modificari_Necesare VARCHAR2(50),
CONSTRAINT PK_Alocare_Sala_Exp PRIMARY KEY (Expozitie_ID, Sala_ID),
CONSTRAINT FK_Alocare_Sala_E FOREIGN KEY (Sala_ID) REFERENCES Sala(Sala_ID) ON DELETE CASCADE,
CONSTRAINT FK_Alocare_Exp FOREIGN KEY (Expozitie_ID) REFERENCES Expozitie(Expozitie_ID) ON DELETE CASCADE);


CREATE TABLE Detalii_Bilet (
Expozitie_ID INT NOT NULL,
Ticket_ID INT NOT NULL,
Perioada_Valabilitate VARCHAR2(50),
Tip_Acces VARCHAR2(50) DEFAULT 'full' CHECK (Tip_Acces IN ('full', 'restrictionat', 'partial_cu_posibilitate_de_upgrade')),
CONSTRAINT PK_Detalii_Bilet PRIMARY KEY (Expozitie_ID, Ticket_ID),
CONSTRAINT FK_Detalii_Exp FOREIGN KEY (Expozitie_ID) REFERENCES Expozitie(Expozitie_ID) ON DELETE CASCADE,
CONSTRAINT FK_Detalii_B FOREIGN KEY (Ticket_ID) REFERENCES Bilet(Ticket_ID) ON DELETE CASCADE
);


CREATE TABLE Alocare_Opera_Expozitie (
Expozitie_ID INT NOT NULL,
Opera_ID INT NOT NULL,
Ordine_In_Expozitie INT,
Conditii_Conservare_Perioada_Expunere VARCHAR2(50),
Tip_Expunere VARCHAR2(50) DEFAULT 'original' CHECK (Tip_Expunere IN ('original', 'reproducere', 'model_3D')),
CONSTRAINT PK_Alocare_Opera_Exp PRIMARY KEY (Expozitie_ID, Opera_ID),
CONSTRAINT FK_Alocare_Opera FOREIGN KEY (Opera_ID) REFERENCES Opera(Opera_ID) ON DELETE CASCADE,
CONSTRAINT FK_Exp_Op FOREIGN KEY (Expozitie_ID) REFERENCES Expozitie(Expozitie_ID) ON DELETE CASCADE
);


CREATE TABLE CONTRIBUTIE_ARTIST (
Opera_ID INT NOT NULL,
Artist_ID INT NOT NULL,
Rol VARCHAR2(50),
Perioada_contributie VARCHAR2(50),
CONSTRAINT PK_Contributie_Artist PRIMARY KEY (Artist_ID, Opera_ID),
CONSTRAINT FK_Contributie_Opera FOREIGN KEY (Opera_ID) REFERENCES Opera(Opera_ID) ON DELETE CASCADE,
CONSTRAINT FK_Contributie_Art FOREIGN KEY (Artist_ID) REFERENCES Artist(Artist_ID) ON DELETE CASCADE
);


CREATE TABLE Implicare_Curent (
Artist_ID INT NOT NULL,
Curent_ID INT NOT NULL,
Grad_Implicare VARCHAR2(50),
Perioada_Inceput NUMBER(4),
Perioada_Final NUMBER(4),
Creatii_Principale VARCHAR2(50),
CONSTRAINT PK_Implicare_Artist PRIMARY KEY (Artist_ID, Curent_ID),
CONSTRAINT FK_Implicare_Art FOREIGN KEY (Artist_ID) REFERENCES Artist(Artist_ID) ON DELETE CASCADE,
CONSTRAINT FK_Contributie_Curent FOREIGN KEY (Curent_ID) REFERENCES Curent_Artistic(Curent_ID) ON DELETE CASCADE
);


INSERT INTO Vizitator (CNP, Nume, Prenume, Email, Telefon)
VALUES ('1991201456677','Dragomir','Sebastian','sebastian.dragomir@gmail.com','0765339821');
INSERT INTO Vizitator (CNP, Nume, Prenume, Email, Telefon)
VALUES ('1520508123456','Marinescu','Doina','doina.marinescu@yahoo.com','0729881123');
INSERT INTO Vizitator (CNP, Nume, Prenume, Email, Telefon)
VALUES ('5030919457788','Stan','Rares','rares.stan@cti.ro','0734009988');
INSERT INTO Vizitator (CNP, Nume, Prenume, Email, Telefon)
VALUES ('6100322456678','Popa','Ilinca','ilinca.popa@gmail.com','0752113890');
INSERT INTO Vizitator (CNP, Nume, Prenume, Email, Telefon)
VALUES ('2980508221199','Ionescu','Alexandra','alexandra.ionescu@yahoo.com','0733558922');
INSERT INTO Vizitator (CNP, Nume, Prenume, Email, Telefon)
VALUES ('5160615223345','Matei','Cezar','matei.cezar@gmail.ro','0741002001');
INSERT INTO Vizitator (CNP, Nume, Prenume, Email, Telefon)
VALUES ('1960101223344','Popescu','Mihai','mihai.popescu@gmail.ro','0722110001');


INSERT INTO Metoda_Plata (Metoda_ID, Tip_Plata, Data_Adaugare)
VALUES (4,'voucher',DATE '2023-04-20');
INSERT INTO Metoda_Plata (Metoda_ID, Tip_Plata, Data_Adaugare)
VALUES (3,'online',DATE '2025-03-01');
INSERT INTO Metoda_Plata (Metoda_ID, Tip_Plata, Data_Adaugare)
VALUES (2,'card',DATE '2025-02-15');
INSERT INTO Metoda_Plata (Metoda_ID, Tip_Plata, Data_Adaugare)
VALUES (1,'numerar',DATE '2025-01-10');


INSERT INTO Bilet (Ticket_ID, CNP, Metoda_ID, Pret, Tip_Reducere)
VALUES (212,'1991201456677',4,10.00,'asistat_social');
INSERT INTO Bilet (Ticket_ID, CNP, Metoda_ID, Pret, Tip_Reducere)
VALUES (211,'1520508123456',3,22.00,'pensionar');
INSERT INTO Bilet (Ticket_ID, CNP, Metoda_ID, Pret, Tip_Reducere)
VALUES (210,'1520508123456',1,20.00,'pensionar');
INSERT INTO Bilet (Ticket_ID, CNP, Metoda_ID, Pret, Tip_Reducere)
VALUES (209,'5030919457788',2,22.00,'student');
INSERT INTO Bilet (Ticket_ID, CNP, Metoda_ID, Pret, Tip_Reducere)
VALUES (208,'5030919457788',3,45.00,'student');
INSERT INTO Bilet (Ticket_ID, CNP, Metoda_ID, Pret, Tip_Reducere)
VALUES (207,'5030919457788',2,25.00,'student');
INSERT INTO Bilet (Ticket_ID, CNP, Metoda_ID, Pret, Tip_Reducere)
VALUES (206,'6100322456678',1,18.00,'elev');
INSERT INTO Bilet (Ticket_ID, CNP, Metoda_ID, Pret, Tip_Reducere)
VALUES (205,'5160615223345',4,10.00,'copil');
INSERT INTO Bilet (Ticket_ID, CNP, Metoda_ID, Pret, Tip_Reducere)
VALUES (204,'5160615223345',2,15.00,'copil');
INSERT INTO Bilet (Ticket_ID, CNP, Metoda_ID, Pret, Tip_Reducere)
VALUES (203,'2980508221199',3,60.00,'pret_intreg');
INSERT INTO Bilet (Ticket_ID, CNP, Metoda_ID, Pret, Tip_Reducere)
VALUES (202,'2980508221199',1,45.00,'pret_intreg');
INSERT INTO Bilet (Ticket_ID, CNP, Metoda_ID, Pret, Tip_Reducere)
VALUES (201,'1960101223344',2,45.00,'pret_intreg');


INSERT INTO Angajat (Angajat_ID, Nume, Prenume, Email, Telefon, Salariu, Tip_Contract, Data_Angajare)
VALUES (1, 'Morar', 'Adriana', 'adriana.morar@muzeu.ro', '0722001122', 12200, 'full-time', DATE '2020-02-01');
INSERT INTO Angajat (Angajat_ID, Nume, Prenume, Email, Telefon, Salariu, Tip_Contract, Data_Angajare)
VALUES (2, 'Stan', 'Vlad', 'vlad.stan@muzeu.ro', '0733112233', 6300, 'part-time', DATE '2021-04-10');
INSERT INTO Angajat (Angajat_ID, Nume, Prenume, Email, Telefon, Salariu, Tip_Contract, Data_Angajare)
VALUES (3, 'Patrascu', 'Anca', 'anca.patrascu@muzeu.ro', '0744556677', 10100, 'full-time', DATE '2019-09-15');  
INSERT INTO Angajat (Angajat_ID, Nume, Prenume, Email, Telefon, Salariu, Tip_Contract, Data_Angajare)
VALUES (4, 'Ilie', 'Radu', 'radu.ilie@muzeu.ro', '0733778899', 6200, 'full-time', DATE '2022-01-05');
INSERT INTO Angajat (Angajat_ID, Nume, Prenume, Email, Telefon, Salariu, Tip_Contract, Data_Angajare)
VALUES (5, 'Teodorescu', 'Bianca', 'bianca.teodorescu@muzeu.ro', '0755998822', 5000, 'part-time', DATE '2023-03-22');
INSERT INTO Angajat (Angajat_ID, Nume, Prenume, Email, Telefon, Salariu, Tip_Contract, Data_Angajare)
VALUES (6, 'Mihalache', 'Tudor', 'tudor.mihalache@muzeu.ro', '0767114499', 11500, 'full-time', DATE '2020-11-30');
INSERT INTO Angajat (Angajat_ID, Nume, Prenume, Email, Telefon, Salariu, Tip_Contract, Data_Angajare)
VALUES (7, 'Enache', 'Sorina', 'sorina.enache@muzeu.ro', '0722334455', 6700, 'full-time', DATE '2021-07-15');
INSERT INTO Angajat (Angajat_ID, Nume, Prenume, Email, Telefon, Salariu, Tip_Contract, Data_Angajare)
VALUES (8, 'Barbu', 'Cristian', 'cristian.barbu@muzeu.ro', '0733445566', 5900, 'part-time', DATE '2022-05-10');


INSERT INTO Curator (Angajat_ID, Specializare_Curent_Artistic, Tip_Studii_Superioare, Ani_Experienta)
VALUES (1, 'Arta_Medievala', 'Doctorat – Universitatea de Arte București', 8);
INSERT INTO Curator (Angajat_ID, Specializare_Curent_Artistic, Tip_Studii_Superioare, Ani_Experienta)
VALUES (3, 'Modernism, Realism', 'Licență – Universitatea de Arte București', 5);
INSERT INTO Curator (Angajat_ID, Specializare_Curent_Artistic, Tip_Studii_Superioare, Ani_Experienta)
VALUES (6, 'Arta Contemporana', 'Master – Universitatea de Arte București', 6);


INSERT INTO Ghid (Angajat_ID, Atestari_Nivel_Limba, Certificari_Nivel_Formare, Disponibilitate)
VALUES (2, 'EN-B2, FR-B1', 'Turism Cultural', 'luni-vineri');
INSERT INTO Ghid (Angajat_ID, Atestari_Nivel_Limba, Certificari_Nivel_Formare, Disponibilitate)
VALUES (4, 'EN-C1, IT-B1', 'Pedagogie Muzeala', 'weekend');
INSERT INTO Ghid (Angajat_ID, Atestari_Nivel_Limba, Certificari_Nivel_Formare, Disponibilitate)
VALUES (5, 'DE-B2, EN-B2', 'Interpretare Patrimoniu', 'luni-joi');
INSERT INTO Ghid (Angajat_ID, Atestari_Nivel_Limba, Certificari_Nivel_Formare, Disponibilitate)
VALUES (7, 'FR-B2, EN-B2', 'Ghidaj Cultural', 'luni-sâmbătă după-amiaza');
INSERT INTO Ghid (Angajat_ID, Atestari_Nivel_Limba, Certificari_Nivel_Formare, Disponibilitate)
VALUES (8, 'EN-C1', 'Tur ghidat copii', 'weekend');


INSERT INTO Colectionar (Colectionar_ID, Nume, Prenume, Email, Telefon, Tara, Oras, Categorie_Colectionar, Tip_Colaborare, Data_Inregistrare)
VALUES (101, 'Popescu', 'Ion', 'ion.popescu@gmail.ro', '0722112233', 'Romania', 'Bucuresti', 'persoana_fizica', 'donatie', DATE '2022-01-15');
INSERT INTO Colectionar (Colectionar_ID, Nume, Prenume, Email, Telefon, Tara, Oras, Categorie_Colectionar, Tip_Colaborare, Data_Inregistrare)
VALUES (102, 'Muzeul National', NULL, 'contact@muzeulnational.ro', '021334455', 'Romania', 'Bucuresti', 'institutie', 'imprumut', DATE '2021-06-10');
INSERT INTO Colectionar (Colectionar_ID, Nume, Prenume, Email, Telefon, Tara, Oras, Categorie_Colectionar, Tip_Colaborare, Data_Inregistrare)
VALUES (103, 'ArtGallery', NULL, 'info@artgallery.ro', '0744556677', 'Romania', 'Cluj-Napoca', 'galerie', 'vanzare', DATE '2023-02-20');
INSERT INTO Colectionar (Colectionar_ID, Nume, Prenume, Email, Telefon, Tara, Oras, Categorie_Colectionar, Tip_Colaborare, Data_Inregistrare)
VALUES (104, 'Ionescu', 'Maria', 'maria.ionescu@yahoo.com', '0733445566', 'Romania', 'Timisoara', 'persoana_fizica', 'imprumut', DATE '2023-07-05');
INSERT INTO Colectionar (Colectionar_ID, Nume, Prenume, Email, Telefon, Tara, Oras, Categorie_Colectionar, Tip_Colaborare, Data_Inregistrare)
VALUES (105, 'Casa Licitatii Art', NULL, 'contact@casaart.ro', '0722334455', 'Romania', 'Bucuresti', 'licitatie', 'vanzare', DATE '2022-11-12');
INSERT INTO Colectionar (Colectionar_ID, Nume, Prenume, Email, Telefon, Tara, Oras, Categorie_Colectionar, Tip_Colaborare, Data_Inregistrare)
VALUES (106, 'Galeria Moderna', NULL, 'galeria@moderna.ro', '0744778899', 'Romania', 'Cluj-Napoca', 'galerie', 'donatie', DATE '2023-03-18');
INSERT INTO Colectionar (Colectionar_ID, Nume, Prenume, Email, Telefon, Tara, Oras, Categorie_Colectionar, Tip_Colaborare, Data_Inregistrare)
VALUES (107, 'Georgescu', 'Andrei', 'andrei.georgescu@mail.ro', '0755667788', 'Romania', 'Iasi', 'persoana_fizica', 'vanzare', DATE '2023-05-25');
INSERT INTO Colectionar (Colectionar_ID, Nume, Prenume, Email, Telefon, Tara, Oras, Categorie_Colectionar, Tip_Colaborare, Data_Inregistrare)
VALUES (108, 'MNAR', NULL, 'contact@iac.ro', '021998877', 'Romania', 'Bucuresti', 'institutie', 'donatie', DATE '2022-09-30');


INSERT INTO Colectie (Colectie_ID, Colectionar_ID, Nume, Valoare_Estimata, Data_Start_Disponibilitate, Data_End_Disponibilitate)
VALUES (201, 101, 'Picturi Românești Secol XIX', 50000, DATE '2025-01-01', NULL);
INSERT INTO Colectie (Colectie_ID, Colectionar_ID, Nume, Valoare_Estimata, Data_Start_Disponibilitate, Data_End_Disponibilitate)
VALUES (202, 102, 'Sculpturi Clasice', 120000, DATE '2024-03-01', DATE '2025-08-01');
INSERT INTO Colectie (Colectie_ID, Colectionar_ID, Nume, Valoare_Estimata, Data_Start_Disponibilitate, Data_End_Disponibilitate)
VALUES (203, 103, 'Artă Contemporană Internațională', 200000, DATE '2023-05-01', NULL);
INSERT INTO Colectie (Colectie_ID, Colectionar_ID, Nume, Valoare_Estimata, Data_Start_Disponibilitate, Data_End_Disponibilitate)
VALUES (204, 104, 'Colecție Miniaturi', 15000, DATE '2024-06-01', DATE '2025-12-31');
INSERT INTO Colectie (Colectie_ID, Colectionar_ID, Nume, Valoare_Estimata, Data_Start_Disponibilitate, Data_End_Disponibilitate)
VALUES (205, 105, 'Picturi Rare – Licitație', 75000, DATE '2023-04-01', NULL);
INSERT INTO Colectie (Colectie_ID, Colectionar_ID, Nume, Valoare_Estimata, Data_Start_Disponibilitate, Data_End_Disponibilitate)
VALUES (206, 106, 'Artă Modernă Românească', 95000, DATE '2023-02-15', NULL);
INSERT INTO Colectie (Colectie_ID, Colectionar_ID, Nume, Valoare_Estimata, Data_Start_Disponibilitate, Data_End_Disponibilitate)
VALUES (207, 107, 'Colecție de Ceramică', 18000, DATE '2023-03-10', NULL);
INSERT INTO Colectie (Colectie_ID, Colectionar_ID, Nume, Valoare_Estimata, Data_Start_Disponibilitate, Data_End_Disponibilitate)
VALUES (208, 102, 'Artă Medievală', 110000, DATE '2024-05-01', DATE '2024-09-01');
INSERT INTO Colectie (Colectie_ID, Colectionar_ID, Nume, Valoare_Estimata, Data_Start_Disponibilitate, Data_End_Disponibilitate)
VALUES (209, 108, 'Artă Contemporană Europeană', 130000, DATE '2023-06-01', NULL);
INSERT INTO Colectie (Colectie_ID, Colectionar_ID, Nume, Valoare_Estimata, Data_Start_Disponibilitate, Data_End_Disponibilitate)
VALUES (210, 106, 'Sculptură Modernă', 85000, DATE '2023-07-01', NULL);


INSERT INTO Curent_Artistic (Curent_ID, Nume, Perioada_Start, Perioada_End, Zona_Geografica, Caracteristici, Curent_Predecesor)
VALUES (301, 'Modernism', 1890, 1940, 'Europa, România', 'Experimentarea formelor și a culorilor, accent pe expresie individuală', 'Realism');
INSERT INTO Curent_Artistic (Curent_ID, Nume, Perioada_Start, Perioada_End, Zona_Geografica, Caracteristici, Curent_Predecesor)
VALUES (302, 'Avangarda', 1910, 1930, 'Europa, România', 'Ruptură cu tradiția, abordări experimentale, forme abstracte', 'Modernism');
INSERT INTO Curent_Artistic (Curent_ID, Nume, Perioada_Start, Perioada_End, Zona_Geografica, Caracteristici, Curent_Predecesor)
VALUES (303, 'Impresionism', 1860, 1890, 'Franța, Europa', 'Redarea efectelor luminii și a mișcării, culori vii', 'Romantism');
INSERT INTO Curent_Artistic (Curent_ID, Nume, Perioada_Start, Perioada_End, Zona_Geografica, Caracteristici, Curent_Predecesor)
VALUES (304, 'Baroc', 1600, 1750, 'Europa', 'Opulență, dramatism, detalii ornamentale bogate', 'Renastere');
INSERT INTO Curent_Artistic (Curent_ID, Nume, Perioada_Start, Perioada_End, Zona_Geografica, Caracteristici, Curent_Predecesor)
VALUES (305, 'Renaștere', 1400, 1600, 'Italia, Europa', 'Reînnoirea culturii clasice, perspective realiste, armonie', NULL);
INSERT INTO Curent_Artistic (Curent_ID, Nume, Perioada_Start, Perioada_End, Zona_Geografica, Caracteristici, Curent_Predecesor)
VALUES (306, 'Artă Contemporană', 1950, NULL, 'Global', 'Experiment, multimedia, conceptualism', 'Avangarda');
INSERT INTO Curent_Artistic (Curent_ID, Nume, Perioada_Start, Perioada_End, Zona_Geografica, Caracteristici, Curent_Predecesor)
VALUES (307, 'Artă Medievală', 500, 1500, 'Europa, România', 'Religie și simbolism, manuscrise, fresce, sculptură religioasă', NULL);


INSERT INTO Artist (Artist_ID, Nume, Prenume, Data_Nasterii, Data_Deces, Nationalitate, Biografie)
VALUES (401, 'Grigorescu', 'Nicolae', DATE '1838-05-15', DATE '1907-07-21', 'Română', 'Pictor modernist român, cunoscut pentru peisaje și portrete.');
INSERT INTO Artist (Artist_ID, Nume, Prenume, Data_Nasterii, Data_Deces, Nationalitate, Biografie)
VALUES (402, 'Tonitza', 'Nicolae', DATE '1886-02-13', DATE '1940-05-27', 'Română', 'Artist român avangardist, culori expresive și forme abstracte.');
INSERT INTO Artist (Artist_ID, Nume, Prenume, Data_Nasterii, Data_Deces, Nationalitate, Biografie)
VALUES (403, 'Luchian', 'Ştefan', DATE '1868-02-01', DATE '1916-06-28', 'Română', 'Pictor impresionist român, cunoscut pentru naturi moarte și peisaje.');
INSERT INTO Artist (Artist_ID, Nume, Prenume, Data_Nasterii, Data_Deces, Nationalitate, Biografie)
VALUES (404, 'Păunescu', 'Ion', DATE '1950-03-12', NULL, 'Română', 'Artist contemporan român, implicat și în avangardă, multimedia și instalații.');
INSERT INTO Artist (Artist_ID, Nume, Prenume, Data_Nasterii, Data_Deces, Nationalitate, Biografie)
VALUES (405, 'de la Fresco', 'Giovanni', DATE '1600-01-01', DATE '1670-12-31', 'Italiană', 'Pictor baroc, opere religioase și decorative pentru palate.');

INSERT INTO Artist (Artist_ID, Nume, Prenume, Data_Nasterii, Data_Deces, Nationalitate, Biografie)
VALUES (406, 'Bruegel', 'Pieter', DATE '1525-03-30', DATE '1569-08-09', 'Olandeză', 'Maestru renascentist, cunoscut pentru peisaje și portrete.');
INSERT INTO Artist (Artist_ID, Nume, Prenume, Data_Nasterii, Data_Deces, Nationalitate, Biografie)
VALUES (407, 'Giotto', 'di Bondone', DATE '1267-01-01', DATE '1337-01-08', 'Italiană', 'Pictor medieval italian, specializat în fresce religioase.');
INSERT INTO Artist (Artist_ID, Nume, Prenume, Data_Nasterii, Data_Deces, Nationalitate, Biografie)
VALUES (408, 'Masaccio', 'Tommaso', DATE '1401-12-21', DATE '1428-09-21', 'Italiană', 'Artist de tranziție între stilul medieval și Renaștere, perspective și compoziții religioase.');
INSERT INTO Artist (Artist_ID, Nume, Prenume, Data_Nasterii, Data_Deces, Nationalitate, Biografie)
VALUES (409, 'Bernea', 'Horia', DATE '1938-07-14', DATE '2000-04-05', 'Română', 'Artist contemporan român, cunoscut pentru pictură și artă sacră, colaborări cu alți artiști români.');


INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (501, 201, 'Peisaj de toamnă', 1895, '60x80 cm', 'Ulei pe pânză');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (502, 206, 'Portret cu pălărie', 1932, '55x70 cm', 'Ulei pe pânză');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (503, 206, 'Natura moarta cu fructe', 1905, '40x60 cm', 'Ulei pe pânză');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (504, 204, 'Instalatie urbana', 2010, 'Variaza', 'Multimedia');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (505, 205, 'Triptych de sărbătoare', 1890, '120x200 cm', 'Ulei pe pânză');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (506, 209, 'Abstract cromatic', 1985, '100x100 cm', 'Acrilic');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (507, 207, 'Peisaj de primavara', 1910, '70x90 cm', 'Ulei pe pânză');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (508, 207, 'Vas modular', 2015, '30x30x40 cm', 'Ceramică pictată');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (509, 203, 'Instalatie multimedia sacra', 1995, 'Variaza', 'Multimedia și video');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (510, 205, 'Peisaj rural', 1560, '80x120 cm', 'Ulei pe pânză');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (511, 208, 'Trinitate', 1427, '600x300 cm', 'Frescă');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (512, 202, 'Altar baroc', 1635, '250x120x300 cm', 'Sculptură în marmură');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (513, 208, 'Frescă Biserica Santa Croce', 1315, '500x700 cm', 'Frescă');
INSERT INTO Opera (Opera_ID, Colectie_ID, Nume, An_Creatie, Dimensiuni, Tehnica)
VALUES (514, 210, 'Coloane suspendate', 2018, '200x200x300 cm', 'Sculptură metal și lemn');


INSERT INTO Sala (Sala_ID, etaj, Capacitate_persoane, Capacitate_Opere, Regim_Functionare)
VALUES (101, 0, 30, 25, 'Functionala');
INSERT INTO Sala (Sala_ID, etaj, Capacitate_persoane, Capacitate_Opere, Regim_Functionare)
VALUES (102, 0, 35, 30, 'Functionala');
INSERT INTO Sala (Sala_ID, etaj, Capacitate_persoane, Capacitate_Opere, Regim_Functionare)
VALUES (103, 0, 40, 35, 'Functionala');
INSERT INTO Sala (Sala_ID, etaj, Capacitate_persoane, Capacitate_Opere, Regim_Functionare)
VALUES (104, 0, 25, 20, 'Rezervata');
INSERT INTO Sala (Sala_ID, etaj, Capacitate_persoane, Capacitate_Opere, Regim_Functionare)
VALUES (105, 0, 20, 15, 'Amenajare');
INSERT INTO Sala (Sala_ID, etaj, Capacitate_persoane, Capacitate_Opere, Regim_Functionare)
VALUES (106, 0, 50, 40, 'Functionala');
INSERT INTO Sala (Sala_ID, etaj, Capacitate_persoane, Capacitate_Opere, Regim_Functionare)
VALUES (107, 0, 18, 12, 'Renovare');
INSERT INTO Sala (Sala_ID, etaj, Capacitate_persoane, Capacitate_Opere, Regim_Functionare)
VALUES (110, 1, 45, 35, 'Functionala');
INSERT INTO Sala (Sala_ID, etaj, Capacitate_persoane, Capacitate_Opere, Regim_Functionare)
VALUES (111, 1, 30, 22, 'Functionala');
INSERT INTO Sala (Sala_ID, etaj, Capacitate_persoane, Capacitate_Opere, Regim_Functionare)
VALUES (112, 1, 28, 18, 'Rezervata');
INSERT INTO Sala (Sala_ID, etaj, Capacitate_persoane, Capacitate_Opere, Regim_Functionare)
VALUES (120, 2, 35, 28, 'Functionala');
INSERT INTO Sala (Sala_ID, etaj, Capacitate_persoane, Capacitate_Opere, Regim_Functionare)
VALUES (121, 2, 22, 16, 'Functionala');


INSERT INTO Expozitie (Expozitie_ID, Curator_ID, Nume, Data_Inceput, Data_Final, Tip)
VALUES (901, 6,'Dialoguri ale contemporaneității', DATE '2025-01-10', NULL,'Permanenta');
INSERT INTO Expozitie (Expozitie_ID, Curator_ID, Nume, Data_Inceput, Data_Final, Tip)
VALUES (902, 1, 'Lumina Evului Mediu și Renașterii', DATE '2024-05-10', DATE '2024-08-25', 'Temporara');
INSERT INTO Expozitie (Expozitie_ID, Curator_ID, Nume, Data_Inceput, Data_Final, Tip)
VALUES (903, 3, 'Modernism românesc și sculptură de atelier',DATE '2023-07-10', DATE '2023-10-20', 'Temporara');
INSERT INTO Expozitie (Expozitie_ID, Curator_ID, Nume, Data_Inceput, Data_Final, Tip)
VALUES (904, 3, 'Ceramică și miniaturi – formă și memorie', DATE '2024-06-10', DATE '2025-12-20', 'Temporara');
INSERT INTO Expozitie (Expozitie_ID, Curator_ID, Nume, Data_Inceput, Data_Final, Tip)
VALUES (905, 6, 'Arta Contemporană – Experimente vizuale', DATE '2023-06-10', DATE '2023-11-20', 'Temporara');
INSERT INTO Expozitie (Expozitie_ID, Curator_ID, Nume, Data_Inceput, Data_Final, Tip)
VALUES (906, 1, 'Ecouri ale sculpturii clasice', DATE '2024-03-10', DATE '2025-07-20', 'Temporara');
INSERT INTO Expozitie (Expozitie_ID, Curator_ID, Nume, Data_Inceput, Data_Final, Tip)
VALUES (907, 3, 'Avangardism – Ruptură și inovație', DATE '2023-04-10', DATE '2023-06-20', 'Temporara');
INSERT INTO Expozitie (Expozitie_ID, Curator_ID, Nume, Data_Inceput, Data_Final, Tip)
VALUES (908, 6, 'Picturi rare – Licitație și patrimoniu', DATE '2023-04-10', DATE '2024-01-20', 'Temporara');


INSERT INTO Tur_Special (Tur_ID, Nume, Durata_Minute, Limba, Maxim_Participanti, Tip_Tur)
VALUES (701, 'Introducere în colecțiile muzeului',60, 'romana', 20, 'general');
INSERT INTO Tur_Special (Tur_ID, Nume, Durata_Minute, Limba, Maxim_Participanti, Tip_Tur)
VALUES (702, 'Arhitectura muzeului și spațiile expoziționale',50, 'romana', 25, 'arhitectural');
INSERT INTO Tur_Special (Tur_ID, Nume, Durata_Minute, Limba, Maxim_Participanti, Tip_Tur)
VALUES (703, 'Atelier de interpretare modernistă',120, 'romana', 12, 'interactiv');
INSERT INTO Tur_Special (Tur_ID, Nume, Durata_Minute, Limba, Maxim_Participanti, Tip_Tur)
VALUES (704, 'Lumea miniaturilor și a formelor din ceramică',35, 'romana', 10, 'copii');
INSERT INTO Tur_Special (Tur_ID, Nume, Durata_Minute, Limba, Maxim_Participanti, Tip_Tur)
VALUES (705, 'Experimente vizuale în arta contemporană',50, 'romana', 15, 'tematic');


INSERT INTO Programare_Tur (Tur_ID, Ghid_ID, Data_Tur, Numar_Participanti, Observatii)
VALUES (704, 8, DATE '2025-03-09', 8, 'Copii de la Școala Primara Nr. 120');
INSERT INTO Programare_Tur (Tur_ID, Ghid_ID, Data_Tur, Numar_Participanti, Observatii)
VALUES (704, 8, DATE '2025-10-12', 6, 'Copii de la Grădinița Micul Prinț');
INSERT INTO Programare_Tur (Tur_ID, Ghid_ID, Data_Tur, Numar_Participanti, Observatii)
VALUES (703, 4, DATE '2023-07-27', 12, 'Tur cu studenți de la arhitectură');
INSERT INTO Programare_Tur (Tur_ID, Ghid_ID, Data_Tur, Numar_Participanti, Observatii)
VALUES (703, 4, DATE '2023-08-19', 10, 'Tur cu studenți de la UNARTE');
INSERT INTO Programare_Tur (Tur_ID, Ghid_ID, Data_Tur, Numar_Participanti, Observatii)
VALUES (702, 2, DATE '2025-11-04', 10, 'Participare redusă - vizite delegați');
INSERT INTO Programare_Tur (Tur_ID, Ghid_ID, Data_Tur, Numar_Participanti, Observatii)
VALUES (701, 2, DATE '2025-02-17', 20, 'Grup organizat – liceu arte plastice');
INSERT INTO Programare_Tur (Tur_ID, Ghid_ID, Data_Tur, Numar_Participanti, Observatii)
VALUES (705, 2, DATE '2023-09-16', 14, 'Atelier creativ inclus la finalul turului');
INSERT INTO Programare_Tur (Tur_ID, Ghid_ID, Data_Tur, Numar_Participanti, Observatii)
VALUES (701, 5, DATE '2025-04-12', 20, 'Participare maximă');
INSERT INTO Programare_Tur (Tur_ID, Ghid_ID, Data_Tur, Numar_Participanti, Observatii)
VALUES (702, 5, DATE '2025-04-09', 11, 'Public interesat de istoria clădirii');
INSERT INTO Programare_Tur (Tur_ID, Ghid_ID, Data_Tur, Numar_Participanti, Observatii)
VALUES (701, 7, DATE '2025-06-30', 24, 'Tur efectuat cu grup turiști vârstnici');


INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (701, 101, 2, 12);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (701, 102, 3, 7);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (701, 103, 4, 5);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (701, 104, 5, 5);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (701, 105, 6, 5);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (701, 106, 7, 5);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (701, 107, 8, 5);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (702, 101, 2, 10);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (702, 102, 3, 10);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (702, 103, 4, 10);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (702, 104, 5, 12);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (702, 110, 6, 12);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (702, 111, 7, 12);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (702, 112, 8, 12);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (703, 110, 1, 15);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (703, 111, 2, 15);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (703, 112, 3, 15);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (704, 120, 1, 20);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (704, 121, 2, 20);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (705, 120, 1, 18);
INSERT INTO Alocare_Sala_Tur (Tur_ID, Sala_ID, Ordine_In_Tur, Minute_In_Sala) 
VALUES (705, 121, 2, 18);


INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (101, 901, 1, 'Aranjare standard');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (102, 901, 2, 'Aranjare standard');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (103, 901, 3, 'Aranjare standard');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (104, 901, 4, 'Aranjare standard');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (110, 902, 1, 'Lumina adecvata');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (111, 902, 2, 'Lumina adecvata');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (112, 902, 3, 'Lumina adecvata');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (110, 903, 1, 'Secțiune interactivă');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (111, 903, 2, 'Secțiune interactivă');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (112, 903, 3, 'Secțiune interactivă');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (120, 904, 1, 'Expoziție multimedia');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (121, 904, 2, 'Expoziție multimedia');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (120, 905, 1, 'Expunere originală');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (121, 905, 2, 'Expunere originală');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (105, 906, 1, 'Sculpturi clasice');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (106, 906, 2, 'Sculpturi clasice');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (107, 906, 3, 'Sculpturi clasice');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (110, 907, 1, 'Avangardism');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (111, 907, 2, 'Avangardism');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (101, 908, 1, 'Picturi secol XIX');
INSERT INTO Alocare_Sala_Expozitie (Sala_ID, Expozitie_ID, Ordine_In_Expozitie, Observatii_Modificari_Necesare)
VALUES (102, 908, 2, 'Picturi secol XIX');




INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (908, 201, '10-04-2023 ~ 20-01-2024', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (908, 202, '10-04-2023 ~ 20-01-2024', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (905, 203, '10-06-2023 ~ 20-11-2023', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (904, 204, '10-06-2024 ~ 20-12-2025', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (906, 204, '10-03-2024 ~ 20-07-2025', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (904, 205, '10-06-2024 ~ 20-12-2025', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (905, 206, '10-06-2023 ~ 20-11-2023', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (903, 207, '10-07-2023 ~ 20-10-2023', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (907, 207, '10-04-2023 ~ 20-06-2023', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (905, 208, '10-06-2023 ~ 20-11-2023', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (908, 208, '10-04-2023 ~ 20-01-2024', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (905, 209, '10-06-2023 ~ 20-11-2023', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (903, 209, '10-07-2023 ~ 20-10-2023', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (901, 210, '10-01-2025 ~ NULL', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (901, 211, '10-01-2025 ~ NULL', 'full');
INSERT INTO Detalii_Bilet (Expozitie_ID, Ticket_ID, Perioada_Valabilitate, Tip_Acces)
VALUES (908, 212, '10-04-2023 ~ 20-01-2024', 'full');


INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere)
VALUES (901, 501, 1, 'temperatura 20°C, umiditate 50%', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere) 
VALUES (901, 509, 2, 'vitrină protejată UV', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere) 
VALUES (901, 506, 3, 'iluminare slabă, fără contact', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere) 
VALUES (901, 505, 4, 'monitorizare microclimat', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere)
VALUES (901, 510, 5, 'condiții standard expoziție', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere) 
VALUES (902, 511, 1, 'condiții standard săli climatizate', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere)
VALUES (902, 513, 2, 'expunere pe suport special', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere)
VALUES (903, 502, 1, 'iluminare difuză, fără blitz', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere)
VALUES (903, 503, 2, 'umiditate controlată 45–55%', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere) 
VALUES (903, 514, 3, 'condiții muzeale standard', 'reproducere');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere)
VALUES (904, 507, 1, 'vitrină închisă ermetic', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere) 
VALUES (904, 508, 2, 'protecție UV și vibrații reduse', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere) 
VALUES (904, 504, 3, 'condiții speciale materiale fragile', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere)
VALUES (905, 509, 1, 'condiții standard depozit–expoziție', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere) 
VALUES (905, 506, 2, 'iluminare slabă și aer filtrat', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere) 
VALUES (906, 512, 1, 'microclimat stabil', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere) 
VALUES (907, 502, 1, 'condiții standard galerie', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere)
VALUES (907, 506, 2, 'iluminare redusă', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere) 
VALUES (908, 505, 1, 'condiții standard expoziție', 'original');
INSERT INTO Alocare_Opera_Expozitie (Expozitie_ID, Opera_ID, Ordine_In_Expozitie, Conditii_Conservare_Perioada_Expunere, Tip_Expunere) 
VALUES (908, 510, 2, 'vitrină protejată UV', 'original');


INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (501, 401, 'autor', 'creație originală 1895');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (502, 402, 'autor', 'creație 1932');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (503, 403, 'autor', 'creație 1905');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (504, 404, 'autor', 'proiect contemporan 2010');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (505, 401, 'co-autor', 'secțiune compozițională 1890');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (505, 402, 'co-autor', 'intervenție cromatică 1890');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (506, 404, 'autor', 'serie abstractă 1985');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (507, 403, 'autor', 'creație 1910');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (508, 404, 'autor', 'atelier ceramic 2015');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (509, 404, 'autor principal', 'instalație multimedia 1995');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (509, 409, 'co-autor conceptual', 'componentă sacră 1995');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (510, 406, 'autor', 'atelier renascentist 1560');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (511, 408, 'autor', 'decor bisericesc 1427');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (512, 405, 'autor', 'execuție barocă 1635');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (513, 407, 'autor', 'ciclu de fresce 1315');
INSERT INTO Contributie_Artist (Opera_ID, Artist_ID, Rol, Perioada_Contributie)
VALUES (514, 404, 'autor', 'instalație monumentală 2018');


INSERT INTO Implicare_Curent (Artist_ID, Curent_ID, Grad_Implicare, Perioada_Inceput, Perioada_Final, Creatii_Principale)
VALUES (401, 301, 'principal', 1890, 1907, 'peisaje și portrete');
INSERT INTO Implicare_Curent (Artist_ID, Curent_ID, Grad_Implicare, Perioada_Inceput, Perioada_Final, Creatii_Principale)
VALUES (402, 302, 'principal', 1915, 1930, 'portrete expresioniste');
INSERT INTO Implicare_Curent (Artist_ID, Curent_ID, Grad_Implicare, Perioada_Inceput, Perioada_Final, Creatii_Principale)
VALUES (403, 303, 'principal', 1890, 1916, 'naturi moarte și flori');
INSERT INTO Implicare_Curent (Artist_ID, Curent_ID, Grad_Implicare, Perioada_Inceput, Perioada_Final, Creatii_Principale)
VALUES (404, 302, 'secundar', 1975, 1985, 'experimente grafice');
INSERT INTO Implicare_Curent (Artist_ID, Curent_ID, Grad_Implicare, Perioada_Inceput, Perioada_Final, Creatii_Principale)
VALUES (404, 306, 'principal', 1985, NULL, 'instalații multimedia');
INSERT INTO Implicare_Curent (Artist_ID, Curent_ID, Grad_Implicare, Perioada_Inceput, Perioada_Final, Creatii_Principale)
VALUES (405, 304, 'principal', 1620, 1670, 'fresce religioase');
INSERT INTO Implicare_Curent (Artist_ID, Curent_ID, Grad_Implicare, Perioada_Inceput, Perioada_Final, Creatii_Principale)
VALUES (406, 305, 'principal', 1550, 1569, 'peisaje și scene rurale');
INSERT INTO Implicare_Curent (Artist_ID, Curent_ID, Grad_Implicare, Perioada_Inceput, Perioada_Final, Creatii_Principale)
VALUES (407, 307, 'principal', 1290, 1337, 'fresce religioase');
INSERT INTO Implicare_Curent (Artist_ID, Curent_ID, Grad_Implicare, Perioada_Inceput, Perioada_Final, Creatii_Principale)
VALUES (408, 307, 'secundar', 1415, 1420, 'tematică religioasă');
INSERT INTO Implicare_Curent (Artist_ID, Curent_ID, Grad_Implicare, Perioada_Inceput, Perioada_Final, Creatii_Principale)
VALUES (408, 305, 'principal', 1420, 1428, 'perspectivă și compoziție');
INSERT INTO Implicare_Curent (Artist_ID, Curent_ID, Grad_Implicare, Perioada_Inceput, Perioada_Final, Creatii_Principale)
VALUES (409, 306, 'principal', 1970, 2000, 'artă sacră și pictură abstractă');

CREATE OR REPLACE VIEW Viz_Opere_Expozitie AS
SELECT
e.Nume AS Nume_Expozitie,
e.Data_Inceput,
e.Data_Final,
c.Nume AS Nume_Colectie,
co.Nume || ' ' || co.Prenume AS Nume_Colectionar,
o.Nume AS Nume_Opera,
a.Nume || ' ' || a.Prenume AS Nume_Artist,
a.Nationalitate,
COUNT(o.Opera_ID) OVER (PARTITION BY e.Expozitie_ID) AS Nr_Opere_Expozitie
FROM Expozitie e
JOIN Alocare_Opera_Expozitie aoe ON e.Expozitie_ID = aoe.Expozitie_ID
JOIN Opera o ON aoe.Opera_ID = o.Opera_ID
JOIN Colectie c ON o.Colectie_ID = c.Colectie_ID
JOIN Colectionar co ON c.Colectionar_ID = co.Colectionar_ID
JOIN Contributie_Artist ca ON o.Opera_ID = ca.Opera_ID
JOIN Artist a ON ca.Artist_ID = a.Artist_ID
WHERE e.Tip = 'Temporara' AND e.Data_Inceput > TO_DATE('2023-01-01','YYYY-MM-DD')
ORDER BY e.Data_Inceput, c.Nume, o.Nume;

CREATE OR REPLACE VIEW Viz_Bilete_Plata AS
SELECT
b.Ticket_ID,
b.CNP,
b.Metoda_ID,
b.Pret,
b.Tip_Reducere,
mp.Tip_Plata,
mp.Data_Adaugare
FROM Bilet b
JOIN Metoda_Plata mp ON b.Metoda_ID = mp.Metoda_ID;


ALTER TABLE Programare_Tur DROP CONSTRAINT FK_Programare_Tur_Ghid;
ALTER TABLE Programare_Tur DROP CONSTRAINT FK_Programare_Tur_Special;

ALTER TABLE Alocare_Sala_Tur DROP CONSTRAINT FK_Alocare_Tur;
ALTER TABLE Alocare_Sala_Tur DROP CONSTRAINT FK_Alocare_Sala;

ALTER TABLE Alocare_Sala_Expozitie DROP CONSTRAINT FK_Alocare_Sala_E;
ALTER TABLE Alocare_Sala_Expozitie DROP CONSTRAINT FK_Alocare_Exp;

ALTER TABLE Detalii_Bilet DROP CONSTRAINT FK_Detalii_Exp;
ALTER TABLE Detalii_Bilet DROP CONSTRAINT FK_Detalii_B;

ALTER TABLE Alocare_Opera_Expozitie DROP CONSTRAINT FK_Alocare_Opera;
ALTER TABLE Alocare_Opera_Expozitie DROP CONSTRAINT FK_Exp_Op;

ALTER TABLE Contributie_Artist DROP CONSTRAINT FK_Contributie_Opera;
ALTER TABLE Contributie_Artist DROP CONSTRAINT FK_Contributie_Art;

ALTER TABLE Implicare_Curent DROP CONSTRAINT FK_Implicare_Art;
ALTER TABLE Implicare_Curent DROP CONSTRAINT FK_Contributie_Curent;

DROP TABLE Implicare_Curent CASCADE CONSTRAINTS;
DROP TABLE Contributie_Artist CASCADE CONSTRAINTS;
DROP TABLE Alocare_Opera_Expozitie CASCADE CONSTRAINTS;
DROP TABLE Detalii_Bilet CASCADE CONSTRAINTS;
DROP TABLE Alocare_Sala_Expozitie CASCADE CONSTRAINTS;
DROP TABLE Alocare_Sala_Tur CASCADE CONSTRAINTS;
DROP TABLE Programare_Tur CASCADE CONSTRAINTS;

DROP TABLE Tur_Special CASCADE CONSTRAINTS;
DROP TABLE Expozitie CASCADE CONSTRAINTS;
DROP TABLE Sala CASCADE CONSTRAINTS;
DROP TABLE Opera CASCADE CONSTRAINTS;
DROP TABLE Colectie CASCADE CONSTRAINTS;
DROP TABLE Colectionar CASCADE CONSTRAINTS;
DROP TABLE Artist CASCADE CONSTRAINTS;
DROP TABLE Curent_Artistic CASCADE CONSTRAINTS;
DROP TABLE Ghid CASCADE CONSTRAINTS;
DROP TABLE Curator CASCADE CONSTRAINTS;
DROP TABLE Angajat CASCADE CONSTRAINTS;
DROP TABLE Bilet CASCADE CONSTRAINTS;
DROP TABLE Metoda_Plata CASCADE CONSTRAINTS;
DROP TABLE Vizitator CASCADE CONSTRAINTS;

