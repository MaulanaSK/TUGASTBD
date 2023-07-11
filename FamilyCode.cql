// Membuat node untuk keluarga
CREATE (KAKEK:KELUARGA{Name:"Taswin"})
CREATE (NENEK:KELUARGA{Name:"Sukemi"})
CREATE (PAMAN:KELUARGA{Name:"Buadi"})
CREATE (TANTE:KELUARGA{Name:"Sujinah"})
CREATE (AYAH:KELUARGA{Name:"Kasim"})
CREATE (IBU:KELUARGA{Name:"Ami"})
CREATE (ANAK:KELUARGA{Name:"Alivia"})
CREATE (ANAK1:KELUARGA{Name:"Maulana"})
CREATE (ANAKPAMAN:KELUARGA{Name:"Nisa"})
CREATE (ANAKPAMAN1:KELUARGA{Name:"Habibur"})
CREATE (ANAKPAMAN2:KELUARGA{Name:"Nita"})
//Membuat relasi node
CREATE (KAKEK)-[:SUAMI]->(NENEK)-[:ISTRI]->(KAKEK)
CREATE (KAKEK)-[:AYAH]->(AYAH),(KAKEK)-[:AYAH]->(TANTE)
CREATE (NENEK)-[:IBU]->(AYAH),(NENEK)-[:IBU]->(TANTE)
CREATE (AYAH)-[:SUAMI]->(IBU)-[:ISTRI]->(AYAH)-[:SAUDARA]->(TANTE)
CREATE (PAMAN)-[:SUAMI]->(TANTE)-[:ISTRI]->(PAMAN)
CREATE (AYAH)-[:AYAH]->(ANAK),(AYAH)-[:AYAH]->(ANAK1)-[:SAUDARA]->(ANAK)
CREATE (IBU)-[:IBU]->(ANAK),(IBU)-[:IBU]->(ANAK1)
CREATE (PAMAN)-[:AYAH]->(ANAKPAMAN),(PAMAN)-[:AYAH]->(ANAKPAMAN1),(PAMAN)-[:AYAH]->(ANAKPAMAN2)
CREATE (TANTE)-[:IBU]->(ANAKPAMAN),(TANTE)-[:IBU]->(ANAKPAMAN1),(TANTE)-[:IBU]->(ANAKPAMAN2)
CREATE (ANAKPAMAN)-[:SAUDARA]->(ANAKPAMAN1)<-[:SAUDARA]-(ANAKPAMAN2)

// Siapa sajakah nama-nama semua anggota keluarga besar (trah) anda?
MATCH (n) RETURN n.Name as keluarga

// Siapakah nama ayah anda?
MATCH (:KELUARGA{Name:"Maulana"})<-[:AYAH]-(a)
RETURN a.Name as Nama_ayah

// Siapakah nama ibu anda?
MATCH (:KELUARGA{Name:"Maulana"})<-[:IBU]-(a)
RETURN a.Name as Nama_ibu

// Siapakah nama Nenek Anda?
MATCH (:KELUARGA{Name:"Maulana"})<-[:AYAH]-()<-[:IBU]-(n)
RETURN n.Name as Nama_nenek

// Siapakah nama anak-anak dari kakek anda?
MATCH (:KELUARGA{Name:"Maulana"})<-[:AYAH]-()<-[:AYAH]-(n)
MATCH (n)-[:AYAH]->(x)
RETURN x.Name AS Nama_anak_kakek

// Siapa sajakah nama menantu dari kakek anda?
MATCH (:KELUARGA{Name:"Maulana"})<-[:AYAH]-()<-[:AYAH]-(n)
MATCH (n)-[:AYAH]->()-[r]->(x)
WHERE type(r) IN ['ISTRI','SUAMI']
RETURN x.Name AS Menantu_kakek

// Siapa nama saudara dari ayah/ibu anda (paman atau tante anda) ?
MATCH (:KELUARGA{Name:"Maulana"})<-[:AYAH]-()-[:SAUDARA]->(n)
RETURN n.Name AS Saudara_ayah

// Siapa sajakah nama Paman dan Tante anda?
MATCH (:KELUARGA{Name:"Maulana"})<-[:AYAH]-()-[:SAUDARA]->(n)
RETURN n.Name AS pamandanbibi
UNION
MATCH (:KELUARGA{Name:"Maulana"})<-[:AYAH]-()-[:SAUDARA]->(n)
MATCH (n)-[r]->(x)
WHERE type(r) IN ['ISTRI','SUAMI']
RETURN x.Name AS pamandanbibi

// Siapakah nama-nama sepupu anda?
MATCH (:KELUARGA{Name:"Maulana"})<-[:AYAH]-()-[:SAUDARA]->(n)
MATCH (n)-[r]->(x)
WHERE type(r) IN ['AYAH','IBU']
RETURN x.Name AS Nama_sepupu

// Siapakah nama-nama cucu kakek anda (anda termasuk di dalamnya) ?
MATCH (:KELUARGA{Name:"Maulana"})<-[:AYAH]-()<-[:AYAH]-(kakek)
MATCH (kakek)-[:AYAH]->()-[r]->(n)
WHERE type(r) IN ['AYAH','IBU']
RETURN n.Name AS cucu_kakek


