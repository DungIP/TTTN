create database web_acc_game
go
use web_acc_game
go
create table role_account(
	id int NOT NULL PRIMARY KEY, 
	name nvarchar(32) NOT NULL,
);
go
create table account(
	id int NOT NULL IDENTITY(369521,1) PRIMARY KEY,
	user_name nvarchar(32) NOT NULL,
	email nvarchar(32) NOT NULL UNIQUE,
 	password nvarchar(32) NOT NULL,
	role_account int NOT NULL DEFAULT 2 FOREIGN KEY REFERENCES role_account(id),
	account_balance money NOT NULL DEFAULT 0,
);
go

create table payment_method(
	id int NOT NULL PRIMARY KEY, 
	name nvarchar(32) NOT NULL,
);
go

create table deposit_history(
	id int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	account_id int NOT NULL FOREIGN KEY REFERENCES account(id),
	transaction_value money NOT NULL,
	payment_method int NOT NULL FOREIGN KEY REFERENCES payment_method(id),

	transaction_time datetime NULL DEFAULT GETDATE(),
);
go

create table account_game(
	id int NOT NULL IDENTITY(482903,1) PRIMARY KEY,
	image nvarchar(500) NULL,
	price money NOT NULL,
	sever nvarchar(10) NOT NULL,
	adventure_rank int NOT NULL,
	characters int NULL,
	weapons int NULL,
	describe nvarchar(500) NOT NULL,
	item_json nvarchar(500) NULL,

	account_name nvarchar(32) NOT NULL,
	password nvarchar(32) NOT NULL,

	sold int NULL DEFAULT 0
);
go
create table item(
	id int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	name nvarchar(64) NOT NULL,
	type_item nvarchar(32) NOT NULL,
);
go
SELECT COUNT(id) AS count FROM purchase_history WHERE account_id = 1;
 
create table purchase_history(
	id int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	account_id int NOT NULL FOREIGN KEY REFERENCES account(id),
	account_game_id int NOT NULL FOREIGN KEY REFERENCES account_game(id) UNIQUE,
	saleprice money NOT NULL,
	transaction_time datetime NULL DEFAULT GETDATE(),
);
go

CREATE TRIGGER tr_increase_account_balance
ON deposit_history
AFTER INSERT
AS
BEGIN
    -- Update the account_balance in the account table
    UPDATE account
    SET account_balance = account_balance + i.transaction_value
    FROM account
    INNER JOIN inserted i ON account.id = i.account_id;
END;


-- Tạo TRIGGER khi purchase_history được insert
go 
create trigger trg_purchase_history_insert
on purchase_history
after insert
as
begin
    -- Cập nhật trường sold trong bảng account_game
    update ag
    set ag.sold = 1
    from account_game ag
    inner join inserted i on ag.id = i.account_game_id;

    -- Cập nhật trường account_balance trong bảng account
    update a
    set a.account_balance = a.account_balance - i.saleprice
    from account a
    inner join inserted i on a.id = i.account_id;
end;
go
CREATE FUNCTION CheckJsonValueExists
(
    @json NVARCHAR(MAX),
    @valueToCheck NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @count INT = (
        SELECT COUNT(*)
        FROM OPENJSON(@json)
        WHERE value = @valueToCheck
    );

    DECLARE @hasValue BIT = CASE WHEN @count > 0 THEN 1 ELSE 0 END;

    RETURN @hasValue;
END;
go
CREATE FUNCTION CheckJsonValuesExistInItemJson
(
    @itemJson NVARCHAR(500),
    @valuesToCheck NVARCHAR(500)
)
RETURNS BIT
AS
BEGIN
    DECLARE @hasAllValues BIT = 1;

    -- Chuyển đổi chuỗi giá trị thành bảng tạm
    DECLARE @valuesTable TABLE (Value NVARCHAR(50));

    INSERT INTO @valuesTable (Value)
    SELECT value
    FROM OPENJSON(@valuesToCheck);

    -- Kiểm tra từng giá trị trong bảng tạm
    DECLARE @valueToCheck NVARCHAR(50);

    DECLARE valueCursor CURSOR FOR
    SELECT Value FROM @valuesTable;

    OPEN valueCursor;

    FETCH NEXT FROM valueCursor INTO @valueToCheck;

    WHILE @@FETCH_STATUS = 0 AND @hasAllValues = 1
    BEGIN
        IF dbo.CheckJsonValueExists(@itemJson, @valueToCheck) = 0
        BEGIN
            SET @hasAllValues = 0;
            BREAK;
        END

        FETCH NEXT FROM valueCursor INTO @valueToCheck;
    END

    CLOSE valueCursor;
    DEALLOCATE valueCursor;

    RETURN @hasAllValues;
END;
go
INSERT INTO item (name, type_item)
VALUES
('albedo', 'Characters'),
('alhaitham', 'Characters'),
('aloy', 'Characters'),
('amber', 'Characters'),
('arataki_itto', 'Characters'),
('barbara', 'Characters'),
('beidou', 'Characters'),
('bennett', 'Characters'),
('candace', 'Characters'),
('chongyun', 'Characters'),
('collei', 'Characters'),
('cyno', 'Characters'),
('dehya', 'Characters'),
('diluc', 'Characters'),
('diona', 'Characters'),
('dori', 'Characters'),
('eula', 'Characters'),
('faruzan', 'Characters'),
('fischl', 'Characters'),
('ganyu', 'Characters'),
('gorou', 'Characters'),
('hu_tao', 'Characters'),
('jean', 'Characters'),
('kaedehara_kazuha', 'Characters'),
('kaeya', 'Characters'),
('kamisato_ayaka', 'Characters'),
('kamisato_ayato', 'Characters'),
('keqing', 'Characters'),
('klee', 'Characters'),
('kujou_sara', 'Characters'),
('kuki_shinobu', 'Characters'),
('layla', 'Characters'),
('lisa', 'Characters'),
('mika', 'Characters'),
('mona', 'Characters'),
('nahida', 'Characters'),
('nilou', 'Characters'),
('ningguang', 'Characters'),
('noelle', 'Characters'),
('qiqi', 'Characters'),
('raiden_shogun', 'Characters'),
('razor', 'Characters'),
('rosaria', 'Characters'),
('sangonomiya_kokomi', 'Characters'),
('sayu', 'Characters'),
('shenhe', 'Characters'),
('shikanoin_heizou', 'Characters'),
('sucrose', 'Characters'),
('tartaglia', 'Characters'),
('thoma', 'Characters'),
('tighnari', 'Characters'),
('venti', 'Characters'),
('wanderer', 'Characters'),
('xiangling', 'Characters'),
('xiao', 'Characters'),
('xingqiu', 'Characters'),
('xinyan', 'Characters'),
('yae_miko', 'Characters'),
('yanfei', 'Characters'),
('yaoyao', 'Characters'),
('yelan', 'Characters'),
('yoimiya', 'Characters'),
('yun_jin', 'Characters'),
('zhongli', 'Characters');
INSERT INTO item (name, type_item)
VALUES
('akuoumaru', 'Weapons'),
('alley_hunter', 'Weapons'),
('amenoma_kageuchi', 'Weapons'),
('amos_bow', 'Weapons'),
('apprentices_notes', 'Weapons'),
('aqua_simulacra', 'Weapons'),
('aquila_favonia', 'Weapons'),
('a_thousand_floating_dreams', 'Weapons'),
('beacon_of_the_reed_sea', 'Weapons'),
('beginners_protector', 'Weapons'),
('blackcliff_agate', 'Weapons'),
('blackcliff_longsword', 'Weapons'),
('blackcliff_pole', 'Weapons'),
('blackcliff_slasher', 'Weapons'),
('blackcliff_warbow', 'Weapons'),
('black_tassel', 'Weapons'),
('bloodtainted_greatsword', 'Weapons'),
('calamity_queller', 'Weapons'),
('cinnabar_spindle', 'Weapons'),
('compound_bow', 'Weapons'),
('cool_steel', 'Weapons'),
('crescent_pike', 'Weapons'),
('dark_iron_sword', 'Weapons'),
('deathmatch', 'Weapons'),
('debate_club', 'Weapons'),
('dodoco_tales', 'Weapons'),
('dragonspine_spear', 'Weapons'),
('dragons_bane', 'Weapons'),
('dull_blade', 'Weapons'),
('elegy_for_the_end', 'Weapons'),
('emerald_orb', 'Weapons'),
('end_of_the_line', 'Weapons'),
('engulfing_lightning', 'Weapons'),
('everlasting_moonglow', 'Weapons'),
('eye_of_perception', 'Weapons'),
('fading_twilight', 'Weapons'),
('favonius_codex', 'Weapons'),
('favonius_greatsword', 'Weapons'),
('favonius_lance', 'Weapons'),
('favonius_sword', 'Weapons'),
('favonius_warbow', 'Weapons'),
('ferrous_shadow', 'Weapons'),
('festering_desire', 'Weapons'),
('fillet_blade', 'Weapons'),
('forest_regalia', 'Weapons'),
('freedom-sworn', 'Weapons'),
('frostbearer', 'Weapons'),
('fruit_of_fulfillment', 'Weapons'),
('hakushin_ring', 'Weapons'),
('halberd', 'Weapons'),
('hamayumi', 'Weapons'),
('haran_geppaku_futsu', 'Weapons'),
('harbinger_of_dawn', 'Weapons'),
('hunters_bow', 'Weapons'),
('hunters_path', 'Weapons'),
('iron_point', 'Weapons'),
('iron_sting', 'Weapons'),
('kagotsurube_isshin', 'Weapons'),
('kaguras_verity', 'Weapons'),
('katsuragikiri_nagamasa', 'Weapons'),
('key_of_khaj-nisut', 'Weapons'),
('kings_squire', 'Weapons'),
('kitain_cross_spear', 'Weapons'),
('light_of_foliar_incision', 'Weapons'),
('lions_roar', 'Weapons'),
('lithic_blade', 'Weapons'),
('lithic_spear', 'Weapons'),
('lost_prayer_to_the_sacred_winds', 'Weapons'),
('luxurious_sea-lord', 'Weapons'),
('magic_guide', 'Weapons'),
('mailed_flower', 'Weapons'),
('makhaira_aquamarine', 'Weapons'),
('mappa_mare', 'Weapons'),
('memory_of_dust', 'Weapons'),
('messenger', 'Weapons'),
('missive_windspear', 'Weapons'),
('mistsplitter_reforged', 'Weapons'),
('mitternachts_waltz', 'Weapons'),
('moonpiercer', 'Weapons'),
('mouuns_moon', 'Weapons'),
('oathsworn_eye', 'Weapons'),
('old_mercs_pal', 'Weapons'),
('otherworldly_story', 'Weapons'),
('pocket_grimoire', 'Weapons'),
('polar_star', 'Weapons'),
('predator', 'Weapons'),
('primordial_jade_cutter', 'Weapons'),
('primordial_jade_winged-spear', 'Weapons'),
('prototype_amber', 'Weapons'),
('prototype_archaic', 'Weapons'),
('prototype_crescent', 'Weapons'),
('prototype_rancour', 'Weapons'),
('prototype_starglitter', 'Weapons'),
('rainslasher', 'Weapons'),
('raven_bow', 'Weapons'),
('recurve_bow', 'Weapons'),
('redhorn_stonethresher', 'Weapons'),
('royal_bow', 'Weapons'),
('royal_greatsword', 'Weapons'),
('royal_grimoire', 'Weapons'),
('royal_longsword', 'Weapons'),
('royal_spear', 'Weapons'),
('rust', 'Weapons'),
('sacrificial_bow', 'Weapons'),
('sacrificial_fragments', 'Weapons'),
('sacrificial_greatsword', 'Weapons'),
('sacrificial_sword', 'Weapons'),
('sapwood_blade', 'Weapons'),
('seasoned_hunters_bow', 'Weapons'),
('serpent_spine', 'Weapons'),
('sharpshooters_oath', 'Weapons'),
('silver_sword', 'Weapons'),
('skyrider_greatsword', 'Weapons'),
('skyrider_sword', 'Weapons'),
('skyward_atlas', 'Weapons'),
('skyward_blade', 'Weapons'),
('skyward_harp', 'Weapons'),
('skyward_pride', 'Weapons'),
('skyward_spine', 'Weapons'),
('slingshot', 'Weapons'),
('snow-tombed_starsilver', 'Weapons'),
('solar_pearl', 'Weapons'),
('song_of_broken_pines', 'Weapons'),
('staff_of_homa', 'Weapons'),
('staff_of_the_scarlet_sands', 'Weapons'),
('summit_shaper', 'Weapons'),
('sword_of_descension', 'Weapons'),
('the_alley_flash', 'Weapons'),
('the_bell', 'Weapons'),
('the_black_sword', 'Weapons'),
('the_catch', 'Weapons'),
('the_flute', 'Weapons'),
('the_stringless', 'Weapons'),
('the_unforged', 'Weapons'),
('the_viridescent_hunt', 'Weapons'),
('the_widsith', 'Weapons'),
('thrilling_tales_of_dragon_slayers', 'Weapons'),
('thundering_pulse', 'Weapons'),
('toukabou_shigure', 'Weapons'),
('travelers_handy_sword', 'Weapons'),
('tulaytullahs_remembrance', 'Weapons'),
('twin_nephrite', 'Weapons'),
('vortex_vanquisher', 'Weapons'),
('wandering_evenstar', 'Weapons'),
('waster_greatsword', 'Weapons'),
('wavebreakers_fin', 'Weapons'),
('whiteblind', 'Weapons'),
('white_iron_greatsword', 'Weapons'),
('white_tassel', 'Weapons'),
('windblume_ode', 'Weapons'),
('wine_and_song', 'Weapons'),
('wolfs_gravestone', 'Weapons'),
('xiphos_moonlight', 'Weapons');
INSERT INTO account_game (image, price, sever, adventure_rank, characters, weapons, describe, item_json, account_name, password, sold)
VALUES 
('https://shopgenshin24h.com/genshin/acc/see-details-acc-vip/255220', 10000.00, 'Asia', 11, 15, 10, 'Description 1', '[1,2,5]', 'account1', 'password1', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 20000.00, 'Asia', 12, 16, 11, 'Description 2', '[1,3,6]', 'account2', 'password2', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 30000.00, 'Asia', 13, 17, 12, 'Description 3', '[2,4,6]', 'account3', 'password3', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 40000.00, 'Asia', 14, 18, 13, 'Description 4', '[3,5,7]', 'account4', 'password4', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 50000.00, 'Asia', 15, 19, 14, 'Description 5', '[4,6,8]', 'account5', 'password5', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 60000.00, 'Asia', 16, 20, 15, 'Description 6', '[5,7,9]', 'account6', 'password6', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 70000.00, 'Asia', 17, 21, 16, 'Description 7', '[6,8,10]', 'account7', 'password7', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 80000.00, 'Asia', 18, 22, 17, 'Description 8', '[7,9,11]', 'account8', 'password8', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 90000.00, 'Asia', 19, 23, 18, 'Description 9', '[8,10,12]', 'account9', 'password9', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 100000.00, 'Asia', 20, 24, 19, 'Description 10', '[9,11,13]', 'account10', 'password10', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 110000.00, 'Asia', 21, 25, 20, 'Description 11', '[10,12,14]', 'account11', 'password11', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 120000.00, 'Asia', 22, 26, 21, 'Description 12', '[11,13,15]', 'account12', 'password12', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 130000.00, 'Asia', 23, 27, 22, 'Description 13', '[12,14,16]', 'account13', 'password13', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 140000.00, 'Asia', 24, 28, 23, 'Description 14', '[13,15,17]', 'account14', 'password14', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 150000.00, 'Asia', 25, 29, 24, 'Description 15', '[14,16,18]', 'account15', 'password15', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 160000.00, 'Asia', 26, 30, 25, 'Description 16', '[15,17,19]', 'account16', 'password16', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 170000.00, 'Asia', 27, 31, 26, 'Description 17', '[16,18,20]', 'account17', 'password17', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 180000.00, 'Asia', 28, 32, 27, 'Description 18', '[17,19,21]', 'account18', 'password18', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 190000.00, 'Asia', 29, 33, 28, 'Description 19', '[18,20,22]', 'account19', 'password19', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 200000.00, 'Asia', 30, 34, 29, 'Description 20', '[19,21,23]', 'account20', 'password20', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 210000.00, 'Asia', 31, 35, 30, 'Description 21', '[20,22,24]', 'account21', 'password21', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 220000.00, 'Asia', 32, 36, 31, 'Description 22', '[21,23,25]', 'account22', 'password22', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 230000.00, 'Asia', 33, 37, 32, 'Description 23', '[22,24,26]', 'account23', 'password23', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 240000.00, 'Asia', 34, 38, 33, 'Description 24', '[23,25,27]', 'account24', 'password24', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 250000.00, 'Asia', 35, 39, 34, 'Description 25', '[24,26,28]', 'account25', 'password25', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 260000.00, 'Asia', 36, 40, 35, 'Description 26', '[25,27,29]', 'account26', 'password26', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 270000.00, 'Asia', 37, 41, 36, 'Description 27', '[26,28,30]', 'account27', 'password27', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 280000.00, 'Asia', 38, 42, 37, 'Description 28', '[27,29,31]', 'account28', 'password28', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 290000.00, 'Asia', 39, 43, 38, 'Description 29', '[28,30,32]', 'account29', 'password29', 0),
('https://shopgenshin24h.com/files/13/images/genshin-acc-vip/B0648606-9415-4D00-B7A0-9DD6AB5877B3-To.webp', 300000.00, 'Asia', 40, 44, 39, 'Description 30', '[29,31,33]', 'account30', 'password30', 0);
UPDATE account_game
SET describe = '( BUILD + TRANG BỊ NGON) [ NHẤN VÀO ẢNH ĐỂ XEM FULL HÌNH ẢNH RÕ HƠN ] • ACC SIÊU XỊN VIP ĐÁNG ĐỂ MUA • GIẢM GIÁ CỰC SỐC SIÊU RẺ CÒN CHỜ GÌ MÀ KHÔNG MUA NGAY! • NHÂN VẬT 5 SAO VÀ VŨ KHÍ SIÊU ĐẸP'
UPDATE account_game 
SET image = 'https://kashi.com.vn/wp-content/uploads/2022/07/Acc-Genshin-Impact-mien-phi_5.jpg'