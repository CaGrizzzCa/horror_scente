function get_string_massive( stringfull )
	local fbuf = {}
	local count = 0;
	while stringfull:find( "\n" ) do
		count = count + 1;
		local lbuf = stringfull:sub(1,stringfull:find("\n")-1)
		stringfull = stringfull:sub(stringfull:find("\n")+1)
		fbuf[ count ] = lbuf;

	end;

	return fbuf;
end;

writer = [[
Лекарство	Medicine
Круглая_ручка	Round handle
Стакан	Glass
Фигурка_рыбки	Fish figurine
Кочерга	Fire rake
Стакан_воды	Glass of water
Ручка_штопора	Corkscrew handle
Деревянная_лестница	Wooden ladder
Крюк	Hook
Ключ_от_калитки	Gate key
Кусок_пазла_6/6	Puzzle piece
Штопор	Corkscrew
Варежка	Mitten
Отвёртка	Screwdriver
Диск (ex.Эмблема_солнца)	Disk
Перстень	Signet ring
Зелёный_глаз_1,2	Green eye
Отвёртка	Screwdriver
Ключ_сундука	Chest key
Пропеллер	Propeller
Деревянный_самолётик	Wooden plane
Шестигранник	Hexagon
Пружинка	Spring
Кнопка_звонка	Buzzer button
Статуэтка_девушки	Girl figurine
Верёвка_с петлёй	Rope with hook
Охранный_бейдж	Security badge
Камень	Stone
Верёвка_с петлёй	Rope with loop
Лопатка	Shovel
Деревянный_конус	Wooden cone
Записи_статуй	Statue notes
Цифра_2	Number 2
Цифра_3	Number 3
Отвёртка	Screwdriver
Киянка	Mallet
Плоскогубцы	Pliers
Фонарь	Torch
Огниво	Flint
Пила	Saw
Веточка	Twig
Клык_волка	Wolf fang
Огненный_глаз	Fire eye
Пила	Saw
Бирка	Label
Стамеска	Chisel
Единорог	Unicorn
Жёлтая_смола	Yellow resin
Зелёная_смола	Green resin
Цепь_с_крюком	Chain with hook
Резиновые_сапоги	Rubber boots
Зажим	Clamp
Часть_калитки_1,2	Gate part
Заводной_ключик	Winding key
Гаечный_ключ	Wrench
Отвёртка	Screwdriver
Шуруп	Screw
Кусачки	Cutters
Амулет_след	Print amulet
Каменная_ящерица	Stone lizard
Ингредиенты_для_Знахарки	Ingredients for healer
Ручка_сито	Sieve handle
Нож	Knife
Ангелочек	Angel
Трубочка	Tube
Кусочки_сыра	Cheese slices
Удобрение	Fertilizer
Гвоздодёр	Nail puller
Трость	Cane
Монетки	Coins
Деревянный_ключ	Wooden key
Аптечный_символ	Pharmacy emblem
Иероглиф1	Hieroglyph
Иероглиф2	Hieroglyph
Иероглиф3	Hieroglyph
Застёжка_1,2	Clasp
Часть_руки	Hand part
Точильный_камень	Grinding stone
Амулет_волк	Wolf amulet
Амулет_олень	Deer amulet
Штопор	Corkscrew
Мешочек	Bag
Красная_рябина	Red rowan
Ядовитый_гриб	Poisonous mushroom
Фуксия	Fuschia
ИП Саквояж	Carpet bag
ИП Книга	Book
ИП Затупленная_пила	Blunt saw
ИП Меховая_сумка	Fur bag
ИП Кожаный_свёрток	Leather package
ИП Дудочник	Piper
ИП Банка	Can
ИП Рецепт	Recipe
ИП Контейнер	Container
Открывашка	Opener
]]

strings = [[
pop_inv_ringbuttonext	Кнопка_звонка assets\levels\levelext\rm_atworkshopext\zz_ladderext\inv_ringbuttonext	Кнопка_звонка
pop_inv_claspext2	Застёжка_2 assets\levels\levelext\rm_atworkshopext\zz_ladderext\inv_claspext2	Застёжка_2
pop_inv_corkscrewhandleext	Ручка_штопора assets\levels\levelext\rm_atworkshopext\zz_logsext\inv_corkscrewhandleext	Ручка_штопора
pop_inv_rockext	Камень assets\levels\levelext\rm_atworkshopext\zz_logsext\inv_rockext	Камень
pop_inv_digitalext3	Цифра_3 assets\levels\levelext\rm_atworkshopext\zz_logsext\inv_digitalext3	Цифра_3
pop_inv_springext	Пружинка assets\levels\levelext\rm_atworkshopext\zz_toforestext\inv_springext	Пружинка
pop_inv_planeext	Деревянный_самолётик assets\levels\levelext\rm_atworkshopext\zz_toforestext\inv_planeext	Деревянный_самолётик
pop_inv_girlext	Статуэтка_девушки assets\levels\levelext\rm_atworkshopext\zz_workshopdoorext\inv_girlext	Статуэтка_девушки
pop_inv_wicketkeyext	Ключ_от_калитки assets\levels\levelext\ho_commodehoext\inv_wicketkeyext	Ключ_от_калитки
pop_inv_rakeext	Кочерга assets\levels\levelext\rm_entrypointext\zz_aquariumext\inv_rakeext	Кочерга
pop_inv_glasswithwaterext	Стакан_воды assets\levels\levelext\rm_entrypointext\zz_aquariumext\inv_glasswithwaterext	Стакан_воды
pop_inv_puzzleext	Кусок_пазла_4/6 # NO OWNER #	Кусок_пазла_4/6
pop_inv_puzzleext_all	Кусок_пазла_4/6 # NO OWNER #	Кусок_пазла_4/6
pop_inv_glassext	Стакан assets\levels\levelext\rm_entrypointext\zz_commodeext\inv_glassext	Стакан
pop_inv_roundhandleext	Круглая_ручка assets\levels\levelext\rm_entrypointext\zz_fireplaceext\inv_roundhandleext	Круглая_ручка
pop_inv_corkscrewext	Штопор assets\levels\levelext\rm_entrypointext\zz_fireplaceext\inv_corkscrewext	Штопор
pop_inv_booksext	Книга assets\levels\levelext\rm_entrypointext\zz_secondfloorext\inv_booksext	Книга
pop_inv_spadeext	Лопатка assets\levels\levelext\rm_entrypointext\zz_secondfloorext\inv_spadeext	Лопатка
pop_inv_screwdriverext	Отвёртка assets\levels\levelext\rm_entrypointext\zz_wicketext\inv_screwdriverext	Отвёртка
pop_inv_fangext	Клык_волка assets\levels\levelext\mg_woodyext\inv_fangext	Клык_волка
pop_inv_grindstoneext	Точильный_камень assets\levels\levelext\rm_forestext\zz_dragonext\inv_grindstoneext	Точильный_камень
pop_inv_clipext	Зажим assets\levels\levelext\rm_forestext\zz_dragonext\inv_clipext	Зажим
pop_inv_traceext	Амулет_след assets\levels\levelext\rm_forestext\zz_dragonext\inv_traceext	Амулет_след
pop_inv_winderext	Заводной_ключик assets\levels\levelext\rm_forestext\zz_dragonext\inv_winderext	Заводной_ключик
pop_inv_bagext	Меховая_сумка assets\levels\levelext\rm_forestext\zz_flowerext\inv_bagext	Меховая_сумка
pop_inv_screwext	Шуруп assets\levels\levelext\rm_forestext\zz_flowerext\inv_screwext	Шуруп
pop_inv_greenresinext	Зелёная_смола assets\levels\levelext\rm_forestext\zz_flowerext\inv_greenresinext	Зелёная_смола
pop_inv_yellowresinext	Жёлтая_смола assets\levels\levelext\rm_forestext\zz_flowerext\inv_yellowresinext	Жёлтая_смола
pop_inv_twigext	Веточка assets\levels\levelext\rm_forestext\zz_tomargeext\inv_twigext	Веточка
pop_inv_handext	Часть_руки assets\levels\levelext\ho_inpantryext\inv_handext	Часть_руки
pop_inv_flintext	Огниво assets\levels\levelext\rm_inmillext\zz_cellingext\inv_flintext	Огниво
pop_inv_keyext	Ключ_сундука assets\levels\levelext\rm_inmillext\zz_cellingext\inv_keyext	Ключ_сундука
pop_inv_propellerext	Пропеллер assets\levels\levelext\rm_inmillext\zz_chestext\inv_propellerext	Пропеллер
pop_inv_greeneyeext2	Зелёный_глаз_2 assets\levels\levelext\rm_inmillext\zz_chestext\inv_greeneyeext2	Зелёный_глаз_2
pop_inv_hammerext	Киянка assets\levels\levelext\rm_inmillext\zz_lodgingsext\inv_hammerext	Киянка
pop_inv_bootsext	Резиновые_сапоги assets\levels\levelext\ho_vanhoext\inv_bootsext	Резиновые_сапоги
pop_inv_angelext	Ангелочек assets\levels\levelext\rm_margeext\zz_pontoonext\inv_angelext	Ангелочек
pop_inv_wicketext2	Часть_калитки_2 assets\levels\levelext\rm_margeext\zz_pontoonext\inv_wicketext2	Часть_калитки_2
pop_inv_packageext	Кожаный_свёрток assets\levels\levelext\rm_margeext\zz_swampext\inv_packageext	Кожаный_свёрток
pop_inv_tagext	Бирка assets\levels\levelext\rm_margeext\zz_tovillageext\inv_tagext	Бирка
pop_inv_wolfext	Амулет_волк assets\levels\levelext\rm_margeext\zz_tovillageext\inv_wolfext	Амулет_волк
pop_inv_chainext	Цепь_с_крюком assets\levels\levelext\rm_margeext\zz_vanext\inv_chainext	Цепь_с_крюком
pop_inv_fuchsiaext	Фуксия assets\levels\levelext\ho_pharmacyhoext\inv_fuchsiaext	Фуксия
pop_inv_canext	Банка assets\levels\levelext\mg_shopmgext\inv_canext	Банка
pop_inv_hieroglyphext1	Иероглиф1 assets\levels\levelext\rm_villageext\zz_boxsext\inv_hieroglyphext1	Иероглиф1
pop_inv_hieroglyphext2	Иероглиф2 assets\levels\levelext\rm_villageext\zz_boxsext\inv_hieroglyphext2	Иероглиф2
pop_inv_crowbarext	Гвоздодёр assets\levels\levelext\rm_villageext\zz_hatchext\inv_crowbarext	Гвоздодёр
pop_inv_symbolext	Аптечный_символ assets\levels\levelext\rm_villageext\zz_hatchext\inv_symbolext	Аптечный_символ
pop_inv_coinsext	Монетки assets\levels\levelext\rm_villageext\zz_hatchext\inv_coinsext	Монетки
pop_inv_knifeext	Нож assets\levels\levelext\rm_villageext\zz_hatchext\inv_knifeext	Нож
pop_inv_caneext	Трость assets\levels\levelext\rm_villageext\zz_pharmacyext\inv_caneext	Трость
pop_inv_piperext	ИП Дудочник assets\levels\levelext\rm_villageext\zz_shopext\inv_piperext	ИП Дудочник
pop_inv_woodladderext	Деревянная_лестница assets\levels\levelext\rm_watermillext\inv_woodladderext	Деревянная_лестница
pop_inv_hexahedronext	Шестигранник assets\levels\levelext\rm_watermillext\zz_treeext\inv_hexahedronext	Шестигранник
pop_inv_claspext1	Застёжка_1 assets\levels\levelext\rm_watermillext\zz_treeext\inv_claspext1	Застёжка_1
pop_inv_ropeext	Верёвка_с_петлёй assets\levels\levelext\rm_watermillext\zz_treeext\inv_ropeext	Верёвка_с_петлёй
pop_inv_fishext	Фигурка_рыбки assets\levels\levelext\rm_watermillext\zz_verandaext\inv_fishext	Фигурка_рыбки
pop_inv_hookext	Крюк assets\levels\levelext\rm_watermillext\zz_verandaext\inv_hookext	Крюк
pop_inv_cureext	Лекарство assets\levels\levelext\rm_witchhouseext\inv_cureext	Лекарство
pop_inv_recipeext	Рецепт assets\levels\levelext\rm_witchhouseext\inv_recipeext	Рецепт
pop_inv_wicketext1	Часть_калитки_1 assets\levels\levelext\rm_witchhouseext\zz_bellsext\inv_wicketext1	Часть_калитки_1
pop_inv_hieroglyphext3	Иероглиф3 assets\levels\levelext\rm_witchhouseext\zz_bellsext\inv_hieroglyphext3	Иероглиф3
pop_inv_deerext	Амулет_олень assets\levels\levelext\rm_witchhouseext\zz_bellsext\inv_deerext	Амулет_олень
pop_inv_sacext	Мешочек assets\levels\levelext\rm_witchhouseext\zz_lockerext\inv_sacext	Мешочек
pop_inv_handleext	Ручка_сито assets\levels\levelext\rm_witchhouseext\zz_lockerext\inv_handleext	Ручка_сито
pop_inv_wrenchext	Гаечный_ключ assets\levels\levelext\rm_witchhouseext\zz_lockerext\inv_wrenchext	Гаечный_ключ
pop_inv_rowanext	Красная_рябина assets\levels\levelext\rm_witchhouseext\zz_lockerext\inv_rowanext	Красная_рябина
pop_inv_flameeyeext	Огненный_глаз assets\levels\levelext\rm_witchhouseext\zz_tableext\inv_flameeyeext	Огненный_глаз
pop_inv_cheeseext	Кусочки_сыра assets\levels\levelext\rm_witchhouseext\zz_tableext\inv_cheeseext	Кусочки_сыра
pop_inv_fertilizerext	Удобрение assets\levels\levelext\rm_witchhouseext\zz_tableext\inv_fertilizerext	Удобрение
pop_inv_badgeext	Охранный_бейдж assets\levels\levelext\rm_workshopext\inv_badgeext	Охранный_бейдж
pop_inv_lizardext	Каменная_ящерица assets\levels\levelext\rm_workshopext\inv_lizardext	Каменная_ящерица
pop_inv_dullsawext	Тупая_пила assets\levels\levelext\rm_workshopext\zz_couchext\inv_dullsawext	Тупая_пила
pop_inv_mittenext	Варежка assets\levels\levelext\rm_workshopext\zz_couchext\inv_mittenext	Варежка
pop_inv_greeneyeext1	Зелёный_глаз_1 assets\levels\levelext\rm_workshopext\zz_couchext\inv_greeneyeext1	Зелёный_глаз_1
pop_inv_valiseext	Саквояж assets\levels\levelext\rm_workshopext\zz_headsext\inv_valiseext	Саквояж
pop_inv_sunext	Эмблема_солнца assets\levels\levelext\rm_workshopext\zz_headsext\inv_sunext	Эмблема_солнца
pop_inv_coneext	Деревянный_конус assets\levels\levelext\rm_workshopext\zz_headsext\inv_coneext	Деревянный_конус
pop_inv_ringext	Перстень assets\levels\levelext\rm_workshopext\zz_headsext\inv_ringext	Перстень
pop_inv_digitalext2	Цифра_2 assets\levels\levelext\rm_workshopext\zz_windowext\inv_digitalext2	Цифра_2
pop_inv_lampext	Фонарь assets\levels\levelext\rm_workshopext\zz_windowext\inv_lampext	Фонарь
pop_inv_nippersext	Кусачки assets\levels\levelext\inv_deploy\inv_complex_bagext\inv_nippersext	Кусачки
pop_inv_woodkeyext	Деревянный_ключ assets\levels\levelext\inv_deploy\inv_complex_bagext\inv_woodkeyext	Деревянный_ключ
pop_inv_unicornext	Единорог assets\levels\levelext\inv_deploy\inv_complex_bagext\inv_unicornext	Единорог
pop_inv_recordsext	Записи_статуй assets\levels\levelext\inv_deploy\inv_complex_booksext\inv_recordsext	Записи_статуй
pop_inv_fungusext	Ядовитый_гриб assets\levels\levelext\inv_deploy\inv_complex_canext\inv_fungusext	Ядовитый_гриб
pop_inv_sawext	Пила assets\levels\levelext\inv_deploy\inv_complex_dullsawext\inv_sawext	Пила
pop_inv_chiselext	Стамеска assets\levels\levelext\inv_deploy\inv_complex_packageext\inv_chiselext	Стамеска
pop_inv_tubeext	Трубочка assets\levels\levelext\inv_deploy\inv_complex_piperext\inv_tubeext	Трубочка
pop_inv_ingredientsext	Ингредиенты_для_Знахарки assets\levels\levelext\inv_deploy\inv_complex_recipeext\inv_ingredientsext	Ингредиенты_для_Знахарки
pop_inv_pliersext	Плоскогубцы assets\levels\levelext\inv_deploy\inv_complex_valiseext\inv_pliersext	Плоскогубцы
]]

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local wr = get_string_massive( writer )
local sr = get_string_massive( strings )

for i = 1, #wr do
	for j = i + 1, #wr do
		if wr[ i ] == wr[ j ] then
			print( wr[ i ], "!!!!!ПОВТОР в списке предметов писателя" )
		end
	end
end

local sr_out = {};
	for j = 1, #sr do
		local sbuf-- = sr[j]:sub(sr[j]:find("\t")+1)
		local s_id-- = sr[j]:sub(1,sr[j]:find("\t")-1)
		local s_val-- = sbuf--:sub(1,sbuf:find("\t")-1)
		local s_rus-- = sbuf--:sub(sbuf:find("\t")+1)

		if sr[j]:len() > 3 then
			if sr[j]:find("\t") then
				sbuf = sr[j]:sub(sr[j]:find("\t")+1)
				s_id = sr[j]:sub(1,sr[j]:find("\t")-1)
				if sbuf:find("\t") then
					s_val = sbuf:sub(1,sbuf:find("\t")-1)
					s_rus = sbuf:sub(sbuf:find("\t")+1):gsub("_"," ")
					--print(s_rus:upper())
				end
			end
		end


		table.insert( sr_out, { s_id, s_val, s_rus } );
	end;

function compareWordPrepare( word )
	word = trim( word:upper() ):gsub( "_", " " ):gsub( "^ИП", "" )
	word = trim( word )
	if word:find( "^-" ) then
		word = word:sub( 2 )
	end
	if word:find( "," ) then
		local pos = word:find( "," )
		word = word:sub( 1, pos - 1 )
		--print(word,"!!!!!!!!!!!!!!!!");
	end
	return word
end

function compareItemWords( word1, word2 )
	word1 = compareWordPrepare( word1 )
	word2 = compareWordPrepare( word2 )
	--print( word1, word2, word2:gsub( "%(%+%)", "" ), word2:gsub( "(%d%/%d)", ""  ), word2:gsub( "( %d)", "" ) )
	if ( word1 == word2 )
	or ( word1:gsub( "%(%+%)", "" ) == word2:gsub( "%(%+%)", "" )  )
	or ( word1:gsub( "(%d%/%d)", ""  ) == word2:gsub( "(%d%/%d)", ""  ) )
	or ( word1:gsub( "( %d)", "" ) == word2:gsub( "( %d)", "" ) )
	then
		return true
	else
		return false
	end
end

for i = 1, #wr do
	local wbuf = wr[i]:sub(wr[i]:find("\t")+1)
	local w_rus
	local w_val
	local tabs_count = 0
	if wbuf:find("\t") then
		--3 столбца
		w_rus = wbuf:sub(1,wbuf:find("\t")-1)
		w_val = wbuf:sub(wbuf:find("\t")+1)
		tabs_count = 2
	else
		--2 столбца
		w_rus = wr[i]:sub(1,wr[i]:find("\t")-1)
		w_val = wr[i]:sub(wr[i]:find("\t")+1)
		tabs_count = 1
	end

	for j = 1, #sr_out do
		--print(  sr_out[j][3]:upper(), trim( sr_out[j][3]:upper():gsub( "%(%+%)", "" ) ) );
		--print(  sr_out[j][3]:upper(), trim( sr_out[j][3]:upper():gsub( "(%d%/%d)", "" ) ) );
		if compareItemWords( w_rus, sr_out[j][3] ) then
			sr_out[j][2] = w_val

			if wr[i]:find( "pop_inv_" ) then
				wr[i] = wr[i].."; "..sr_out[j][1]
			else
				wr[i] = wr[i].."\t"..sr_out[j][1]
			end

			sr_out[j][3] = "||OK|| >> "..sr_out[j][3];

		end
	end;
end;

print("=============================== в стрингс Strings.xml");
for j = 1, #sr_out do
	print( sr_out[j][1], sr_out[j][2], sr_out[j][3] );
end;

print("=============================== в гугл док");

for j = 1, #wr do
	print( wr[j] );
end;
