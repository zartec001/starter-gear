-- =====================================================================
-- VENDEURS AD-HONORES  -  AzerothCore 3.3.5a
-- =====================================================================
-- A EXECUTER SUR LE SERVEUR CIBLE, APRES l'import des items 800000-800267.
--
--   800000  Armures de depart   (AD-HONORES)  -> items 800000-800197
--   800001  Armes de depart     (AD-HONORES)  -> items 800200-800237
--   800002  Hors-set de depart  (AD-HONORES)  -> items 800250-800267
--
-- Les items vendus sont selectionnes par plage depuis item_template :
-- les trous d'ID (800008-800009, 800160-800177, ...) sont ignores
-- automatiquement, pas de ligne morte dans npc_vendor.
-- =====================================================================


-- =====================================================================
-- 0. DISPLAY DES PNJ
-- =====================================================================

SET @MODEL_ARMURES := 25611;
SET @MODEL_ARMES   := 25611;
SET @MODEL_HORSSET := 25611;


-- =====================================================================
-- 1. NETTOYAGE (re-execution du script sans doublon)
-- =====================================================================
DELETE FROM `npc_vendor`             WHERE `entry`      BETWEEN 800000 AND 800002;
DELETE FROM `creature_template_model` WHERE `CreatureID` BETWEEN 800000 AND 800002;
DELETE FROM `creature_template_locale` WHERE `entry`     BETWEEN 800000 AND 800002;
DELETE FROM `creature_template`       WHERE `entry`      BETWEEN 800000 AND 800002;


-- =====================================================================
-- 2. CREATURE_TEMPLATE
-- =====================================================================
-- Colonnes et valeurs alignees sur le schema du serveur cible (55 colonnes,
-- AzerothCore recent : CreatureImmunitiesId, pas de colonne `scale`).
--
-- faction 35   = amical avec tout le monde
-- npcflag 4225 = dialogue (1) + vendeur (128) + reparateur (4096)
--                -> mettre 129 pour retirer la reparation
-- rank 3, type 0, unit_flags2 2048 : repris du modele fourni

INSERT INTO `creature_template`
(`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
 `KillCredit1`, `KillCredit2`, `name`, `subname`, `IconName`, `gossip_menu_id`,
 `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`,
 `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`, `detection_range`,
 `rank`, `dmgschool`, `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`,
 `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`,
 `dynamicflags`, `family`, `type`, `type_flags`, `lootid`, `pickpocketloot`,
 `skinloot`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`,
 `AIName`, `MovementType`, `HoverHeight`, `HealthModifier`, `ManaModifier`,
 `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
 `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `VerifiedBuild`)
VALUES
(800000, 0, 0, 0, 0, 0, 'Armures de départ', 'AD-HONORES', NULL, 0,
 80, 80, 0, 35, 4225, 1, 1.14286, 1, 1, 20,
 3, 0, 1, 0, 0, 1, 1, 1, 0, 2048,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 '', 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, '0', 12340),
(800001, 0, 0, 0, 0, 0, 'Armes de départ', 'AD-HONORES', NULL, 0,
 80, 80, 0, 35, 4225, 1, 1.14286, 1, 1, 20,
 3, 0, 1, 0, 0, 1, 1, 1, 0, 2048,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 '', 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, '0', 12340),
(800002, 0, 0, 0, 0, 0, 'Hors-set de départ', 'AD-HONORES', NULL, 0,
 80, 80, 0, 35, 4225, 1, 1.14286, 1, 1, 20,
 3, 0, 1, 0, 0, 1, 1, 1, 0, 2048,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 '', 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, '0', 12340);


-- =====================================================================
-- 3. MODELES
-- =====================================================================
-- Le schema cible est un AzerothCore recent (CreatureImmunitiesId, pas de
-- colonne `scale`) : les modeles vivent donc dans creature_template_model
-- et non dans creature_template.modelid1.

INSERT INTO `creature_template_model`
(`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`)
VALUES
(800000, 0, @MODEL_ARMURES, 1, 1),
(800001, 0, @MODEL_ARMES,   1, 1),
(800002, 0, @MODEL_HORSSET, 1, 1);


-- =====================================================================
-- 4. TRADUCTIONS (enUS + esES)
-- =====================================================================
-- Le `name` de creature_template est le FR (langue de base du serveur).
-- On ajoute enUS et esES ; frFR est genere ensuite depuis le nom de base.
-- esES sans accents, pour rester coherent avec les traductions d'items.
 
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`) VALUES
(800000, 'enUS', 'Starter Armor',              'AD-HONORES'),
(800001, 'enUS', 'Starter Weapons',            'AD-HONORES'),
(800002, 'enUS', 'Starter Off-Set Gear',       'AD-HONORES'),
(800000, 'esES', 'Armaduras Iniciales',        'AD-HONORES'),
(800001, 'esES', 'Armas Iniciales',            'AD-HONORES'),
(800002, 'esES', 'Equipo Inicial Sin Conjunto', 'AD-HONORES');
 
-- frFR aligne sur creature_template.name
INSERT INTO `creature_template_locale` (`entry`, `locale`, `Name`, `Title`)
SELECT `entry`, 'frFR', `name`, `subname`
FROM `creature_template`
WHERE `entry` BETWEEN 800000 AND 800002;
 


-- =====================================================================
-- 5. INVENTAIRES
-- =====================================================================
-- maxcount 0 = stock illimite | incrtime 0 | ExtendedCost 0 (achat en or)

-- 800000 : armures (800000-800197)
INSERT INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`)
SELECT 800000, 0, `entry`, 0, 0, 0
FROM `item_template`
WHERE `entry` BETWEEN 800000 AND 800197
ORDER BY `entry`;

-- 800001 : armes et reliques (800200-800237)
INSERT INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`)
SELECT 800001, 0, `entry`, 0, 0, 0
FROM `item_template`
WHERE `entry` BETWEEN 800200 AND 800237
ORDER BY `entry`;

-- 800002 : anneaux, colliers, capes, bijoux (800250-800267)
INSERT INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`)
SELECT 800002, 0, `entry`, 0, 0, 0
FROM `item_template`
WHERE `entry` BETWEEN 800250 AND 800267
ORDER BY `entry`;


-- =====================================================================
-- 6. VERIFICATIONS
-- =====================================================================

-- Les 3 PNJ existent et ont un modele ?
SELECT ct.`entry`, ct.`name`, ct.`subname`, ct.`npcflag`, m.`CreatureDisplayID`
FROM `creature_template` ct
LEFT JOIN `creature_template_model` m ON m.`CreatureID` = ct.`entry` AND m.`Idx` = 0
WHERE ct.`entry` BETWEEN 800000 AND 800002;

-- Nombre d'items par vendeur (attendu : 144 / 38 / 18)
SELECT `entry`, COUNT(*) AS nb_items FROM `npc_vendor`
WHERE `entry` BETWEEN 800000 AND 800002 GROUP BY `entry`;

-- Traductions (attendu : 2 lignes par PNJ, enUS + frFR)
SELECT `entry`, `locale`, `Name`, `Title` FROM `creature_template_locale`
WHERE `entry` BETWEEN 800000 AND 800002 ORDER BY `entry`, `locale`;

-- Items vendus mais absents de item_template (doit renvoyer 0 ligne)
SELECT v.`entry` AS vendeur, v.`item`
FROM `npc_vendor` v
LEFT JOIN `item_template` i ON i.`entry` = v.`item`
WHERE v.`entry` BETWEEN 800000 AND 800002 AND i.`entry` IS NULL;


-- =====================================================================
-- 7. EN JEU
-- =====================================================================
-- .reload creature_template
-- .reload npc_vendor
-- .reload locales_creature
--
-- Puis se placer a l'endroit voulu et faire apparaitre les PNJ :
--   .npc add 800000
--   .npc add 800001
--   .npc add 800002