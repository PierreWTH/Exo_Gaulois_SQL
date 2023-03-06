-- Requete 1

SELECT nom_lieu
FROM lieu
WHERE nom_lieu LIKE "%um";

-- Requete 2

SELECT nom_lieu, COUNT(p.id_lieu) AS nbHabitants
FROM personnage p
INNER JOIN lieu l ON p.id_lieu = l.id_lieu
GROUP BY l.id_lieu
ORDER BY nbHabitants DESC

-- Requete 3

SELECT nom_personnage, nom_specialite, adresse_personnage, nom_lieu
FROM personnage
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
INNER JOIN specialite ON specialite.id_specialite = personnage.id_specialite

ORDER BY(nom_lieu)
ORDER BY(nom_personnage);

-- Requete 4

SELECT nom_specialite, COUNT(nom_personnage)
from specialite
INNER JOIN personnage on specialite.id_specialite = personnage.id_specialite
GROUP BY nom_specialite
ORDER BY COUNT(nom_personnage)DESC;

-- Requete 5

SELECT nom_potion, SUM(cout_ingredient * qte) AS cout
FROM composer
INNER JOIN potion ON composer.id_potion = potion.id_potion
INNER JOIN ingredient ON composer.id_ingredient = ingredient.id_ingredient
GROUP BY nom_potion
ORDER BY cout DESC;

-- Requete 6

SELECT nom_potion, SUM(cout_ingredient * qte) AS cout
FROM composer
INNER JOIN potion ON composer.id_potion = potion.id_potion
INNER JOIN ingredient ON composer.id_ingredient = ingredient.id_ingredient
GROUP BY nom_potion
ORDER BY cout DESC;

-- Requete 7 !!! SOMME DE LA QUANTITE DES INGREDIENTS

SELECT nom_ingredient, qte, cout_ingredient
FROM composer 
INNER JOIN ingredient ON composer.id_ingredient = ingredient.id_ingredient
WHERE composer.id_potion = 3;

-- Requete 8

SELECT nom_personnage, SUM(qte) as total
FROM prendre_casque pc
INNER JOIN bataille b ON pc.id_bataille = b.id_bataille
INNER JOIN personnage p ON pc.id_personnage = p.id_personnage
AND b.nom_bataille = "Bataille du village gaulois"
GROUP BY nom_personnage
HAVING total >= ALL(
    SELECT SUM(qte) AS total
    FROM prendre_casque
    WHERE id_bataille = 1
    GROUP BY id_personnage)

-- Requete 9 !!! PRENDRE EN COMPTE QUANTITE DE POTION BUE ET DIFFERENTES POTIONS

SELECT nom_personnage, dose_boire
FROM boire
INNER JOIN personnage ON boire.id_personnage = personnage.id_personnage
ORDER BY dose_boire DESC;

-- Requete 10

SELECT nom_bataille, SUM(qte) as total
FROM prendre_casque
INNER JOIN bataille ON prendre_casque.id_bataille = bataille.id_bataille
GROUP BY nom_bataille
HAVING total >= ALL(
    SELECT SUM(qte) as total  
    FROM prendre_casque 
    GROUP BY id_bataille);

-- Requete 11

SELECT id_type_casque, COUNT(*) as nb_casque, SUM(cout_casque) as cout_total
FROM casque
GROUP BY id_type_casque
ORDER BY nb_casque DESC;

-- Requete 12

SELECT nom_potion
FROM composer 
INNER JOIN potion ON composer.id_potion = potion.id_potion
INNER JOIN ingredient ON composer.id_ingredient = ingredient.id_ingredient
WHERE ingredient.id_ingredient = 24;

-- Requete 13

SELECT lieu.nom_lieu, COUNT(personnage.id_lieu) as nb_habitant
FROM personnage
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
GROUP BY lieu.nom_lieu
HAVING COUNT(personnage.id_lieu) =
    (SELECT MAX(nb_habitant) 
    FROM (SELECT COUNT(personnage.id_lieu) as nb_habitant
          FROM personnage
          WHERE personnage.id_lieu <> 1
          GROUP BY personnage.id_lieu)
          as max_habitant);

-- Requete 14

SELECT nom_personnage
FROM personnage
LEFT JOIN boire ON personnage.id_personnage = boire.id_personnage
WHERE boire.id_personnage IS NULL;

-- Requete 15

SELECT nom_personnage
FROM autoriser_boire
INNER JOIN personnage ON autoriser_boire.id_personnage = personnage.id_personnage
WHERE id_potion <> 1;

-- Requete A

INSERT INTO personnage(nom_personnage, adresse_personnage, image_personnage, id_lieu, id_specialite)
	VALUES ('Champdeblix', 'Ferme Hantassion', 'indisponible.jpg', 
	(SELECT l.id_lieu FROM lieu l WHERE l.nom_lieu = 'Rotomagus'), 
	(SELECT s.id_specialite FROM specialite s WHERE s.nom_specialite = 'Agriculteur' )
	)

-- Requete B 

INSERT INTO autoriser_boire (id_potion, id_personnage) 
VALUES (
	(SELECT p.id_potion FROM potion p WHERE p.nom_potion = 'Magique'),
	(SELECT pe.id_personnage from personnage pe WHERE pe.nom_personnage = 'Bonemine')
)

-- Requete C

DELETE c FROM casque c

LEFT JOIN prendre_casque p ON c.id_casque = p.id_casque
INNER JOIN type_casque t ON c.id_type_casque = t.id_type_casque

WHERE p.id_casque IS NULL AND t.nom_type_casque = 'Grec'

-- Requete D

UPDATE personnage 
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
SET adresse_personnage = 'En prison', nom_lieu = 'Condates' WHERE nom_personnage = 'Zérozérosix'

-- Requete E

DELETE c FROM composer c

INNER JOIN potion p ON c.id_potion = p.id_potion
INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient

WHERE p.nom_potion = 'Soupe' AND i.nom_ingredient = 'Persil'

-- Requete F

UPDATE prendre_casque pc

INNER JOIN bataille b ON pc.id_bataille = b.id_bataille
INNER JOIN casque c ON pc.id_casque = c.id_casque
INNER JOIN personnage p ON pc.id_personnage = p.id_personnage

SET pc.id_casque = 
(SELECT id_casque FROM casque WHERE nom_casque = 'Ostrogoths'),
pc.qte = 42 
WHERE id_bataille = (SELECT id_bataille FROM bataille WHERE nom_bataille = 'Attaque de la banque postale')
AND id_personnage = (SELECT id_personnage FROM personnage WHERE nom_personnage = 'Obélix')




