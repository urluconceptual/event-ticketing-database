create or replace procedure ex6 is 
    type rec is record (cod bilet.id_bilet%type, 
                        eveniment bilet.id_eveniment%type, 
                        loc bilet.id_loc%type, 
                        sala bilet.id_sala%type, 
                        locatie bilet.id_locatie%type, 
                        rezervare bilet.id_rezervare%type, 
                        pret bilet.pret%type, 
                        stare bilet.stare%type); 
    type tablou_indexat is table of rec index by pls_integer; 
    type tablou_imbricat is table of bilet.stare%type; 
    de_actualizat tablou_indexat; 
    date_vechi tablou_imbricat := tablou_imbricat(); 
    date_noi tablou_imbricat := tablou_imbricat(); 
    rez pls_integer := 0; 
    plat pls_integer := 0; 
    aux rezervare.stare%type; 
    exceptie exception;
begin 
    select stare bulk collect into date_vechi 
    from bilet; 
 
    delete 
    from bilet b 
    where (select data_eveniment from eveniment e where e.id_eveniment = b.id_eveniment)<sysdate and stare != 2 and stare != 3
    returning b.id_bilet, b.id_eveniment, b.id_loc, b.id_sala, b.id_locatie, b.id_rezervare, b.pret, b.stare bulk collect into de_actualizat; 

    if de_actualizat.count = 0 then
        raise exceptie;
    end if;
 
    for i in de_actualizat.first..de_actualizat.last loop 
        if de_actualizat(i).rezervare is null then 
            de_actualizat(i).stare := 2; 
        else 
            select r.stare into aux 
            from rezervare r 
            where r.id_rezervare = de_actualizat(i).rezervare; 
 
            if aux = 0 then 
                de_actualizat(i).stare := 2; 
            else 
                de_actualizat(i).stare := 3; 
            end if; 
        end if; 
         
        insert into bilet 
        values (de_actualizat(i).cod, de_actualizat(i).eveniment, de_actualizat(i).loc, de_actualizat(i).sala, de_actualizat(i).locatie, de_actualizat(i).rezervare, de_actualizat(i).pret, de_actualizat(i).stare); 
    end loop; 
 
    select stare bulk collect into date_noi 
    from bilet; 
 
    for i in date_vechi.first..date_vechi.last loop 
        if date_vechi(i) = 1 then 
            rez := rez + 1; 
            if date_noi(i) = 3 then 
                plat := plat + 1; 
            end if; 
        end if; 
    end loop; 
 
    dbms_output.put_line(round(plat/rez*100,2) || '% din biletele pentru rezervari trecute au fost platite.'); 

exception
    when exceptie then
        dbms_output.put_line('Nu exista date de actualizat.');
end ex6;
/

execute ex6;

create or replace procedure ex7 is
    v_spec spectacol.id_spectacol%type;
    v_nume spectacol.nume%type;
    v_rezervari pls_integer;
    v_ant pls_integer;
    v_indice pls_integer := 0;
    v_util utilizator.nume%type;
--cursor parametrizat
    cursor utilizatori(parametru spectacol.id_spectacol%type) is
                select unique nume
                from utilizator u
                join rezervare r on u.id_utilizator = r.id_utilizator
                where r.id_rezervare in (
                    select b.id_rezervare
                    from bilet b
                    join eveniment e on b.id_eveniment = e.id_eveniment
                    where e.id_spectacol = parametru);
    begin
        v_indice := 0;

--cursor implicit cu subcereri        
for spec in (select s.id_spectacol cod, s.nume nume, count(id_rezervare) rezervari
        from spectacol s
        left join eveniment e on s.id_spectacol = e.id_spectacol
        left join bilet b on e.id_eveniment = b.id_eveniment
        group by s.id_spectacol, s.nume
        order by rezervari desc)
        loop
            v_spec := spec.cod;
            v_nume := spec.nume;
            v_rezervari := spec.rezervari;
            
            if v_indice = 0 or v_ant != v_rezervari then
                v_indice := v_indice + 1;
                dbms_output.put_line('    ');
                dbms_output.put_line(v_indice || '--------------------');
            else
                dbms_output.put_line('---------------------');
            end if;
            dbms_output.put_line(v_nume || ' - ' || v_rezervari || ' rezervari:');
            open utilizatori(v_spec);
            loop
                fetch utilizatori into v_util;
                exit when utilizatori%notfound;
                dbms_output.put_line(v_util);
            end loop;
            close utilizatori;
            v_ant := v_rezervari;
        end loop;
end ex7;
/

execute ex7; 

create or replace function ex8(p_nume utilizator.nume%type)
return plata.suma%type
is
    rezultat plata.suma%type;
    verif_util number;
    no_util exception;
    too_many_util exception;
    begin
        select count(*) into verif_util
        from utilizator
        where upper(nume) = upper(p_nume);

        if verif_util = 0 then
            raise no_util;
        elsif verif_util > 1 then
            raise too_many_util;
        end if;

        select sum(suma) into rezultat
        from  utilizator u
        left join rezervare r on r.id_utilizator=u.id_utilizator
        left join plata p on p.id_rezervare=r.id_rezervare
        where upper(u.nume) = upper(p_nume) and r.stare = 1;

        return rezultat;
    exception
        when no_util then
            raise_application_error(-20000, 'Nu exista utilizatori cu acest nume!');
        when too_many_util then
            raise_application_error(-20001, 'Mai mult de un utilizator cu acest nume!');
end ex8;
/

declare
    rezultat plata.suma%type;
begin
    rezultat := ex8('Marian Cocos');
    dbms_output.put_line(rezultat);
exception 
    when others then
        dbms_output.put_line('Eroarea are codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
end;
/

declare
    rezultat plata.suma%type;
begin
    rezultat := ex8('nume inexistent');
    dbms_output.put_line(rezultat);
exception 
    when others then
        dbms_output.put_line('Eroarea are codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
end;
/

declare
    rezultat plata.suma%type;
begin
    insert into utilizator values (secv_utilizator.nextval, 'Marian Cocos', 'mk7i5u6yr5etr', 'maarian__@hotmail.com', '0706377531' );
    rezultat := ex8('Marian Cocos');
    dbms_output.put_line(rezultat);
exception 
    when others then
        dbms_output.put_line('Eroarea are codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
end;
/

create or replace procedure ex9(p_nume utilizator.nume%type)
is
    verif_nume number;
    nume_reducere reducere.nume%type;
    data_plata plata.data_plata%type;
    no_util exception;
    too_many_util exception;
    begin
        select count(*)
        into verif_nume
        from utilizator u
        where upper(u.nume)=upper(p_nume);

        if verif_nume = 0 then
            raise no_util;
        elsif verif_nume > 1 then
            raise too_many_util;
        end if;

        select r.nume "NUME REDUCERE", p.data_plata "ULTIMA UTILIZARE"
        into nume_reducere, data_plata
        from reducere r
        join implica i on i.id_reducere=r.id_reducere
        join plata p on i.id_plata=p.id_plata
        join rezervare rez on rez.id_rezervare=p.id_rezervare
        join utilizator u on rez.id_utilizator=u.id_utilizator
        where p.data_plata = (select max(p1.data_plata)
        from reducere r1
        join implica i1 on i1.id_reducere=r1.id_reducere
        join plata p1 on i1.id_plata=p1.id_plata
        where r1.id_reducere=r.id_reducere)
        and upper(u.nume)=upper(p_nume)
        order by months_between(sysdate, p.data_plata);

        dbms_output.put_line('REDUCERE: ' || nume_reducere);
        dbms_output.put_line('DATA: ' || data_plata);
    exception
        when no_data_found then
            raise_application_error(-20000, 'Utilizatorul nu a dispus de nicio reducere!');
        when too_many_rows then
            raise_application_error(-20001, 'Mai multe reduceri in ultima plata!');
        when no_util then
            raise_application_error(-20002, 'Nu exista utilizator cu acest nume!');
        when too_many_util then
            raise_application_error(-20003, 'Mai mult de un utilizator cu acest nume!');
end ex9;
/

execute ex9('Bancescu Alexandru');
execute ex9('utilizator inexistent');
execute ex9('Marian Cocos');
execute ex9('Birsan Constantin');
execute ex9('Lungu David');

create or replace trigger t10
    before insert on eveniment
declare
    ultima_data eveniment.data_eveniment%type;
begin
    select max(data_eveniment)
    into ultima_data
    from eveniment e;

    if ultima_data > sysdate then
        raise_application_error(-20000, 'Organizatorul nu poate avea evenimente noi momentan!');
    end if;
end t10;
/

INSERT INTO eveniment VALUES (41, 15, 8, 1, 5, to_date('2023-12-30', 'yyyy-mm-dd'), '17:30', '19:45');
INSERT INTO eveniment VALUES (42, 15, 8, 1, 5, to_date('2023-12-12', 'yyyy-mm-dd'), '17:30', '19:45');

create or replace trigger t11
    before update on bilet
    for each row
declare
    data_even eveniment.data_eveniment%type;
begin
    if :new.stare = 1 and :old.stare = 0 then
        select data_eveniment
        into data_even
        from eveniment
        where id_eveniment = :new.id_eveniment;
        
        if data_even < sysdate then
            raise_application_error(-20000, 'Nu puteti rezerva bilete la evenimente trecute!');
        end if;
    end if;
end t11;
/

update bilet
set stare = 1
where stare = 0;

create table actiuni (utilizator varchar(30), data_actiune date);

create or replace trigger t12
    before drop or alter on schema
declare
    eroare exception;
begin
    if sysevent = 'ALTER' then
        insert into actiuni
        values (user, sysdate);
    end if;
    
    if sysevent = 'DROP' then
        raise eroare;
    end if;
exception
    when eroare then
        raise_application_error(-20005, 'Nu puteti sterge tabele din baza de date!');
    when others then
        dbms_output.put_line ( DBMS_UTILITY.FORMAT_ERROR_STACK() );
end t12;
/

drop table eveniment;
alter table eveniment add testare number;

select * from eveniment;

select * from actiuni;

create or replace package pack13 as
    procedure ex6;
    procedure ex7;
    function ex8(p_nume utilizator.nume%type) return plata.suma%type;
    procedure ex9(p_nume utilizator.nume%type);
end pack13;
/

create or replace package body pack13 as

procedure ex6 is 
    type rec is record (cod bilet.id_bilet%type, 
                        eveniment bilet.id_eveniment%type, 
                        loc bilet.id_loc%type, 
                        sala bilet.id_sala%type, 
                        locatie bilet.id_locatie%type, 
                        rezervare bilet.id_rezervare%type, 
                        pret bilet.pret%type, 
                        stare bilet.stare%type); 
    type tablou_indexat is table of rec index by pls_integer; 
    type tablou_imbricat is table of bilet.stare%type; 
    de_actualizat tablou_indexat; 
    date_vechi tablou_imbricat := tablou_imbricat(); 
    date_noi tablou_imbricat := tablou_imbricat(); 
    rez pls_integer := 0; 
    plat pls_integer := 0; 
    aux rezervare.stare%type; 
    exceptie exception;
begin 
    select stare bulk collect into date_vechi 
    from bilet; 
 
    delete 
    from bilet b 
    where (select data_eveniment from eveniment e where e.id_eveniment = b.id_eveniment)<sysdate and stare != 2 and stare != 3
    returning b.id_bilet, b.id_eveniment, b.id_loc, b.id_sala, b.id_locatie, b.id_rezervare, b.pret, b.stare bulk collect into de_actualizat; 

    if de_actualizat.count = 0 then
        raise exceptie;
    end if;
 
    for i in de_actualizat.first..de_actualizat.last loop 
        if de_actualizat(i).rezervare is null then 
            de_actualizat(i).stare := 2; 
        else 
            select r.stare into aux 
            from rezervare r 
            where r.id_rezervare = de_actualizat(i).rezervare; 
 
            if aux = 0 then 
                de_actualizat(i).stare := 2; 
            else 
                de_actualizat(i).stare := 3; 
            end if; 
        end if; 
         
        insert into bilet 
        values (de_actualizat(i).cod, de_actualizat(i).eveniment, de_actualizat(i).loc, de_actualizat(i).sala, de_actualizat(i).locatie, de_actualizat(i).rezervare, de_actualizat(i).pret, de_actualizat(i).stare); 
    end loop; 
 
    select stare bulk collect into date_noi 
    from bilet; 
 
    for i in date_vechi.first..date_vechi.last loop 
        if date_vechi(i) = 1 then 
            rez := rez + 1; 
            if date_noi(i) = 3 then 
                plat := plat + 1; 
            end if; 
        end if; 
    end loop; 
 
    dbms_output.put_line(round(plat/rez*100,2) || '% din biletele pentru rezervari trecute au fost platite.'); 

exception
    when exceptie then
        dbms_output.put_line('Nu exista date de actualizat.');
end ex6;

procedure ex7 is
    v_spec spectacol.id_spectacol%type;
    v_nume spectacol.nume%type;
    v_rezervari pls_integer;
    v_ant pls_integer;
    v_indice pls_integer := 0;
    v_util utilizator.nume%type;
--cursor parametrizat
    cursor utilizatori(parametru spectacol.id_spectacol%type) is
                select unique nume
                from utilizator u
                join rezervare r on u.id_utilizator = r.id_utilizator
                where r.id_rezervare in (
                    select b.id_rezervare
                    from bilet b
                    join eveniment e on b.id_eveniment = e.id_eveniment
                    where e.id_spectacol = parametru);
    begin
        v_indice := 0;

--cursor implicit cu subcereri        
for spec in (select s.id_spectacol cod, s.nume nume, count(id_rezervare) rezervari
        from spectacol s
        left join eveniment e on s.id_spectacol = e.id_spectacol
        left join bilet b on e.id_eveniment = b.id_eveniment
        group by s.id_spectacol, s.nume
        order by rezervari desc)
        loop
            v_spec := spec.cod;
            v_nume := spec.nume;
            v_rezervari := spec.rezervari;
            
            if v_indice = 0 or v_ant != v_rezervari then
                v_indice := v_indice + 1;
                dbms_output.put_line('    ');
                dbms_output.put_line(v_indice || '--------------------');
            else
                dbms_output.put_line('---------------------');
            end if;
            dbms_output.put_line(v_nume || ' - ' || v_rezervari || ' rezervari:');
            open utilizatori(v_spec);
            loop
                fetch utilizatori into v_util;
                exit when utilizatori%notfound;
                dbms_output.put_line(v_util);
            end loop;
            close utilizatori;
            v_ant := v_rezervari;
        end loop;
end ex7;

function ex8(p_nume utilizator.nume%type)
return plata.suma%type
is
    rezultat plata.suma%type;
    verif_util number;
    no_util exception;
    too_many_util exception;
    begin
        select count(*) into verif_util
        from utilizator
        where upper(nume) = upper(p_nume);

        if verif_util = 0 then
            raise no_util;
        elsif verif_util > 1 then
            raise too_many_util;
        end if;

        select sum(suma) into rezultat
        from  utilizator u
        left join rezervare r on r.id_utilizator=u.id_utilizator
        left join plata p on p.id_rezervare=r.id_rezervare
        where upper(u.nume) = upper(p_nume) and r.stare = 1;

        return rezultat;
    exception
        when no_util then
            raise_application_error(-20000, 'Nu exista utilizatori cu acest nume!');
        when too_many_util then
            raise_application_error(-20001, 'Mai mult de un utilizator cu acest nume!');
end ex8;

procedure ex9(p_nume utilizator.nume%type)
is
    verif_nume number;
    nume_reducere reducere.nume%type;
    data_plata plata.data_plata%type;
    no_util exception;
    too_many_util exception;
    begin
        select count(*)
        into verif_nume
        from utilizator u
        where upper(u.nume)=upper(p_nume);

        if verif_nume = 0 then
            raise no_util;
        elsif verif_nume > 1 then
            raise too_many_util;
        end if;

        select r.nume "NUME REDUCERE", p.data_plata "ULTIMA UTILIZARE"
        into nume_reducere, data_plata
        from reducere r
        join implica i on i.id_reducere=r.id_reducere
        join plata p on i.id_plata=p.id_plata
        join rezervare rez on rez.id_rezervare=p.id_rezervare
        join utilizator u on rez.id_utilizator=u.id_utilizator
        where p.data_plata = (select max(p1.data_plata)
        from reducere r1
        join implica i1 on i1.id_reducere=r1.id_reducere
        join plata p1 on i1.id_plata=p1.id_plata
        where r1.id_reducere=r.id_reducere)
        and upper(u.nume)=upper(p_nume)
        order by months_between(sysdate, p.data_plata);

        dbms_output.put_line('REDUCERE: ' || nume_reducere);
        dbms_output.put_line('DATA: ' || data_plata);
    exception
        when no_data_found then
            raise_application_error(-20000, 'Utilizatorul nu a dispus de nicio reducere!');
        when too_many_rows then
            raise_application_error(-20001, 'Mai multe reduceri in ultima plata!');
        when no_util then
            raise_application_error(-20002, 'Nu exista utilizator cu acest nume!');
        when too_many_util then
            raise_application_error(-20003, 'Mai mult de un utilizator cu acest nume!');
end ex9;

end pack13;
/

create or replace package info_util as
    procedure init_spect;
    function activitate(id_util number) return varchar2;
    function status(id_util number) return varchar2;
    procedure gestiune_date;
    procedure util_inactiv(id_util number);
    procedure util_activ(id_util number);
end info_util;
/
create or replace package body info_util as
    type list_spec is varray(100) of spectacol.nume%type;
    type vect_list_spec is varray(100) of list_spec;
    spectacole vect_list_spec := vect_list_spec();
    type vect_nume is varray(1000) of utilizator.nume%type;
    nume_util vect_nume := vect_nume();

    procedure init_spect
    is
        v_nr number;
        exista_rez number;
    begin
        select count(*)
        into v_nr
        from utilizator;

        nume_util.extend(v_nr);
        spectacole.extend(v_nr);

        for i in 1..v_nr loop
            spectacole(i) := list_spec();

            select nume
            into nume_util(i)
            from utilizator
            where id_utilizator = i;

            select count(*)
            into exista_rez
            from rezervare
            where id_utilizator = i;

            if exista_rez != 0 then
                select s.nume bulk collect into spectacole(i)
                from rezervare r
                join bilet b on r.id_rezervare = b.id_rezervare
                join eveniment e on b.id_eveniment = e.id_eveniment
                join spectacol s on e.id_spectacol = s.id_spectacol
                where r.id_utilizator = i;
            end if;
        end loop;
    end init_spect;

    function activitate(id_util number) return varchar2
    is
        raspuns varchar2(20);
        nr_rez number;
    begin
        select count(*)
        into nr_rez
        from rezervare
        where id_utilizator = id_util;

        if nr_rez = 0 then
            raspuns := 'UTILIZATOR INACTIV';
        else
            raspuns := 'UTILIZATOR ACTIV';
        end if;

        return raspuns;
    end activitate;

    function status(id_util number) return varchar2
    is
        raspuns varchar2(20);
    begin
            select case when nvl(sum(p.suma),'0')=0 then 'UTILIZATOR NORMAL' else 'UTILIZATOR FIDEL' end
            into raspuns
            from  utilizator u
            left join rezervare r on r.id_utilizator=u.id_utilizator
            left join plata p on p.id_rezervare=r.id_rezervare
            where u.id_utilizator = id_util;

        return raspuns;
    end status;

    procedure util_activ(id_util number)
    is
    begin
        dbms_output.put_line(id_util||'--------------------');
        dbms_output.put_line(nume_util(id_util) || ' - ' || status(id_util));
        
        for i in spectacole(id_util).first..spectacole(id_util).last loop
            dbms_output.put_line('     '||spectacole(id_util)(i));
        end loop;

        dbms_output.put_line('----------------------');
    end util_activ;

    procedure util_inactiv(id_util number)
    is
    begin
        delete from utilizator
        where id_utilizator=id_util;

        dbms_output.put_line('----------------------');
        dbms_output.put_line('Utilizatorul inactiv '||id_util||' a fost sters din baza de date.');
        dbms_output.put_line('----------------------');
    end util_inactiv;
    
    procedure gestiune_date
    is
    begin
        init_spect();
        for i in spectacole.first..spectacole.last loop
            if activitate(i) = 'UTILIZATOR INACTIV' then
                util_inactiv(i);
            else
                util_activ(i);
            end if;
        end loop;
    end gestiune_date;
end info_util;
/

execute info_util.gestiune_date();