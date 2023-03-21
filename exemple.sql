--1.	Să se afișeze numele utilizatorului care a plasat comanda cu cel mai mare număr de reduceri.
select u1.nume
from  utilizator u1
join rezervare r1 on u1.id_utilizator=r1.id_utilizator
where (select (count(u.id_utilizator))
from utilizator u
join rezervare r on u.id_utilizator=r.id_utilizator
join plata p on p.id_rezervare=r.id_rezervare
join implica i on i.id_plata=p.id_plata
where r1.id_rezervare=r.id_rezervare
group by r.id_rezervare) =
(select max(count(u.id_utilizator))
from utilizator u
join rezervare r on u.id_utilizator=r.id_utilizator
join plata p on p.id_rezervare=r.id_rezervare
join implica i on i.id_plata=p.id_plata
group by r.id_rezervare);

--2. Afișați id-ul, statusul(rezervat/disponibil) și data spectacolului tuturor biletelor puse la dispoziție pentru spectacole care conțin litera ”o” și au loc în Baia Mare, în ordine cronologică a evenimentelor. (ordonări, 2 funcții pe șiruri de caractere, DECODE, subcereri nesincronizate în care intervin cel puțin 3 tabele)
select id_bilet, decode(b.stare, 0, 'rezervat', 1, 'disponibil') "STATUS", e.data_eveniment
from bilet b
join eveniment e on b.id_eveniment=e.id_eveniment
join spectacol s on e.id_spectacol=s.id_spectacol
where lower(s.nume) like '%o%' and e.id_eveniment in (
select e1.id_eveniment
from eveniment e1
join locatie l on e1.id_locatie=l.id_locatie
join oras o on o.id_oras=l.id_locatie
where upper(o.nume)='BAIA MARE'
)
order by e.data_eveniment;

--3. Afisati în ordine crescătoare a sumelor, numele fiecărui utilizator și suma cheltuită pe bilete la spectacole, împreună cu mesajul ”Utilizator fidel” în cazul în care a efectuat cel puțin o plată, sau ”Utilizator obișnuit” în cazul în care nu a efectuat nicio plată.
select  u.nume, nvl(sum(p.suma),'0'), case when nvl(sum(p.suma),'0')=0 then 'Utilizator normal' else 'Utilizator fidel' end "TIP UTILIZATOR"
from  utilizator u
left join rezervare r on r.id_utilizator=u.id_utilizator
left join plata p on p.id_rezervare=r.id_rezervare
group by u.nume;

--4. Afișați reducerile care au fost folosite vreodată, de la cele mai recent folosite la cele mai departe în timp folosite.
select r.id_reducere, max(p.data_plata) "ULTIMA UTILIZARE"
from reducere r
join implica i on i.id_reducere=r.id_reducere
join plata p on i.id_plata=p.id_plata
group by r.id_reducere
order by months_between(sysdate, max(p.data_plata));

--5. Afișați suma cheltuită în medie de un utilizator pe platforma.
with suma_plata
as
(
select  nvl(sum(p.suma),'0') suma_totala
from  utilizator u
left join rezervare r on r.id_utilizator=u.id_utilizator
left join plata p on p.id_rezervare=r.id_rezervare
group by u.nume
)
select
round(avg(suma_totala),2) "MEDIE SUMA CHELTUITA"
from suma_plata;

--Toate biletele de la evenimente ce au loc dupa data de 20 august 2022 s-au vândut:
update bilet
set stare=1
where id_eveniment in (select id_eveniment from eveniment where data_eveniment>to_date('2022-08-20', 'yyyy-mm-dd'));

--Utilizatorii care nu au plasat nicio rezervare sunt eliminati din baza de date:
delete from utilizator
where id_utilizator in (select  u.id_utilizator
from  utilizator u
left join rezervare r on r.id_utilizator=u.id_utilizator
where nvl(r.id_rezervare, '0')=0);

--Toți utilizatorii înregistrați după al 3-lea utilizator și-au uitat parola, vor să o reseteze:
update utilizator
set parola='parola1234'
where id_utilizator>3;
