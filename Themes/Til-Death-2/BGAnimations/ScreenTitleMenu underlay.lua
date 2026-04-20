if IsSMOnlineLoggedIn() then
	CloseConnection()
end

local minanyms = {
	"welcome back cheater",
	"Unreadable Rain",
	"the logorrhea of yore",
	"Irate Platypusaurusean",
	"Pancreatic_MilkTrombone",
	"Fire_Elevator",
	"Starchy DarkButter",
	"Unememorabelia Bedelia",
	"Cheezits 'N Rice",
	"Scalding brain fart",
	"Luridescence",
	"Frothy Loin",
	"Ministry of Silly Steps",
	"\na haiku for man\ntried to prove that we're special\nturns out that we're not",
	"BinkleBompFOUR[emdash]",
	"an astounding lack of self awareness (Mina 1:78)",
	"the changelog that answers your question\nyou know the one you didn't read",
	"the profile names of yore",
	"mystic memer",
	"orange hands",
	"Sir Smauggy",
	"ScroogeMcdoot",
	"The King In The Hall Under The Mountain Amidst The Dragon's Lair",
	"Just Mash",
	"Just 5mash",
	"Player 1",
	"Minametra",
	"Noodlesim",
	"Default Profile",
	"Mina (backup)",
	"Mina",
	"orange hands (backup)",
	"Don Eon",
	"Tromwelskintherintherin",
	"StraitStrix",
	"UmbralChord",
	"NoSaucierMagic",
	"EgomaniaCircus",
	"stepmania bakery hero",
	"infinite swirling squid spacecraft",
	"Jack Can't Reacher",
	"the nightly builds of yore",
	"AVAST YE STEPMATEY",
	"ALPHA DINGOBABY",
	"TOWEL FOR A PHOENIX",
	"MAYBE ITS RASPBELLINE",
	"FREE MARKOV",
	"BARK ON MOONSTRING",
	"CARAMEL CANDELABRABELLUM",
	"PATENTED TOILET MYTHOS",
	"MOONAR LANDING - THE RETURWN",
	"ORANGE BLOSSOM SPECIAL",
	"SERENADE UNDER PORCUPINE",
	"SERRATED HAMBURGER",
	"INTERGALACTIC TURKEY",
	"TURTLE LOVE",
	"BICYCLE LAUGH",
	"GODLY PLATE OF THE WHALE",
	"PURPLE PARKING METERSTICK",
	"BROCCOLI MOISTURIZER",
	"SLIGHTLY ALTERED COMPILER FLAG",
	"PARTIALLY Q-TIP KIWI",
	"POTATO PAINTING COURTESY",
	"Ye olde names",
	"Shoeeater9000",
	"Thirdeye",
	"Otiose Velleity",
	"MoreLikeYourMomesis",
	"RofflesTheCat",
	"MinaEnnui",
	"FishnaciousGrace",
	"Forp",
	"Forp II",
	"Forp III The Unavenged",
	"Lady Mericicelourne Ciestrianna De'anstrasvazanne",
	"Caecita",
	"Tempestress",
	"unself",
	"DefinitelyNotMina",
	"KillerClown",
	"Quirky Colonel Kibbles",
	"2c",
	"FroggerNanny",
	"FroggyNanner",
	"Aeristacicianistriaza",
	"FroggerNanny The Unfrogged",
	"ScatPlayKatarina",
	"Ferric Chloride Matter",
	"Bananatiger",
	"Unapologetically Hostile Entity",
	"Perpetual Sarcasm Dispensary",
	"dehydrated mandelbrot pulsar",
	"desires a pink anime avatar",
	"theamishwillneverseethis.jpg",
	"Restore missing legacy Stepmania Team credits #1588",
	"gratuitous double negative usage",
	"MinaTallerThanBrandon",
	"confers monetary value to words",
	"notcool",
	"mina restepped as a pad file",
	"sapient typo conglomerate",
	"Real Stepmania Client",
	"Paraplebsis",
	"Qlwpdrt ~!- V~!@#B",
	"HypophoraticProcatalepsis",
	"WobblyChickenRepeat",
	"RoundTableTigerSwan",
	"SkeleTotemWalkRedux",
	"TinkleTotemJamboree",
	"LerpNurbs",
	"HerpingDerper",
	"MinaHatesYouYesYou",
	"ImaginaryStepmaniaClient",
	"ExtraLunarTangoFoxtrot",
	"Morbid Papaya Matrix",
	"note pink",
	"borp",
	"stringofcharactersyouwillonlyseeifitsindexisselectedbytheprngfunctionusedtochoosefromthetableitshousedin",
	"b&",
	"oxford semicolon",
	"more bugs added than fixed",
	"mr.takesallthecreditdoesnoneofthework",
	"Inappropriately placed political message that prompts angry responses on the internet",
	"phalangeography platform for moonlight vigil",
	"Only positive chirps",
	"queen it use duk amok",
	"place mine mode",
	"G-BR0LEH",
	"/L.-:]/",
	"Gumbo",
	"MinaWurtemBurglar",
	"MinaBurtemWurglar",
	"Irreverent irrelevance",
	"Solipsism is just existential masturbation",
	"So is simulation theory, only dumber",
	"5.3.0 Silver Alpha 4.5 – April 4, 2020",
	"logic riddle 4 u",
	"You must own all the rights or have the right to use ANY content you upload - quaver upload rules",
	"Astrasza",
	"Eacylisce",
	"farts mcpoopyface",
	"Laser beef can radio remix",
	"b151f00c59ed323e188bb676ac1e8cb0162ee59a",
	"borpndorf",
	"strings and beans",
	"really big toenails mcstabyouwithem",
	"slayers_jukeboxer",
	"the Feen",
	"Minanym",
	"table point hoarder",
	"yes and no",
	"unconjoined juxtaposition",
	"cancerous snake",
	"1:46 snufkin",
	"MinaMinaCloneClone",
	"Rainbow Accept",
	"for optimizzles",
	"poodle_in_a_porta_potty",
	"scoring justice warrior",
	"_ring.png",
	"cosmically infinite bullshit nova",
	"erudite napkin",
	"ban dripwarrior",
	"dripwarrior banned",
	"snorf AEPLUS bcborf",
	"ulbu, the great bazoinkazoink in the sky",
	"nice old calc",
}

math.random()

local t = Def.ActorFrame {}

--thing made by dashdash, what a surprise, unreadable rain now has actual rain
local rain = function(angle, intensity)
    local speed = 1 - math.min(intensity, 800) / 2500
    local t = Def.ActorFrame {}
    for i = 1, math.min(300, intensity) do
        t[#t+1] = Def.Quad {
            InitCommand = function(self)
                self:queuecommand("Regen")
            end,
            RegenCommand = function(self)
                local where = math.random(-math.abs(angle) * 20,SCREEN_WIDTH + math.abs(angle) * 20)
                self:sleep(math.random(intensity) / intensity):rotationz(90 + angle):zoomto(intensity / 4,0.6):xy(where,-500):diffuse(Saturation(getMainColor("highlight"), 0.2)):diffusealpha(0.5)
                self:linear(speed):xy(where - (angle * 30), SCREEN_HEIGHT + 500):queuecommand("Regen")
            end
        }
    end
    return t
end

t[#t+1] = rain(10, 300)

local frameX = THEME:GetMetric("ScreenTitleMenu", "ScrollerX") - 10
local frameY = THEME:GetMetric("ScreenTitleMenu", "ScrollerY")

t[#t + 1] =
	Def.Sprite{
		Texture=THEME:GetPathG("","BackgroundTitle/titlebg");
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom(0.4)
			self:scaletocover(0, 0, SCREEN_WIDTH, SCREEN_BOTTOM)
			self:diffusealpha(0.5)
		end
	}



	
local playingMusic = {}
local playingMusicCounter = 1
--Title text
t[#t + 1] = UIElements.TextToolTip(1, 1, "Common Large") .. {
	InitCommand=function(self)
		self:xy(capWideScale(get43size(410),180),frameY-120):zoom(0.65):align(0,1)
		self:diffusetopedge(Saturation(getMainColor("highlight"), 0.5))
		self:diffusebottomedge(Saturation(getMainColor("positive"), 0.8))
	end,
	OnCommand=function(self)
		self:settext(minanyms[math.random(#minanyms)])
	end,
	MouseOverCommand = function(self)
		self:diffusealpha(0.6)
	end,
	MouseOutCommand = function(self)
		self:diffusealpha(1)
	end,
	MouseDownCommand = function(self, params)
		if params.event == "DeviceButton_left mouse button" then
			local function startSong()
				local sngs = SONGMAN:GetAllSongs()
				if #sngs == 0 then ms.ok("No songs to play") return end

				local s = sngs[math.random(#sngs)]
				local p = s:GetMusicPath()
				local l = s:MusicLengthSeconds()
				local top = SCREENMAN:GetTopScreen()

				local thisSong = playingMusicCounter
				playingMusic[thisSong] = true

				SOUND:StopMusic()
				SOUND:PlayMusicPart(p, 0, l)
	
				ms.ok("NOW PLAYING: "..s:GetMainTitle() .. " | LENGTH: "..SecondsToMMSS(l))
	
				top:setTimeout(
					function()
						if not playingMusic[thisSong] then return end
						playingMusicCounter = playingMusicCounter + 1
						startSong()
					end,
					l
				)
	
			end
	
			SCREENMAN:GetTopScreen():setTimeout(function()
					playingMusic[playingMusicCounter] = false
					playingMusicCounter = playingMusicCounter + 1
					startSong()
				end,
			0.1)
		else
			SOUND:StopMusic()
			playingMusic = {}
			playingMusicCounter = playingMusicCounter + 1
			ms.ok("Stopped music")
		end
	end,
}

--Theme text
t[#t + 1] = LoadFont("Common Large") .. {
	InitCommand=function(self)
		self:xy(capWideScale(get43size(230),180),frameY-105):zoom(0.25):halign(0,1)
		self:diffusetopedge(Saturation(getMainColor("highlight"), 0.5))
		self:diffusebottomedge(Saturation(getMainColor("positive"), 0.8))
	end,
	OnCommand=function(self)
		self:settext(getThemeName())
	end
}

--Theme ver
t[#t + 1] = UIElements.TextToolTip(1, 1, "Common Large") .. {
	InitCommand=function(self)
		self:xy(SCREEN_LEFT + 1,SCREEN_BOTTOM - 23):zoom(0.25):halign(0)
		self:diffusetopedge(Saturation(getMainColor("highlight"), 0.5))
		self:diffusebottomedge(Saturation(getMainColor("positive"), 0.8))
	end,
	OnCommand=function(self)
		self:settext("Unredable Rain 1.8")
	end,
	MouseDownCommand = function(self, params)
		if params.event == "DeviceButton_left mouse button" then
		end
	end
}

--Etterna ver
t[#t + 1] = UIElements.TextToolTip(1, 1, "Common Large") .. {
	InitCommand=function(self)
		self:xy(SCREEN_LEFT,SCREEN_BOTTOM - 35):zoom(0.25):halign(0)
		self:diffusetopedge(Saturation(getMainColor("highlight"), 0.5))
		self:diffusebottomedge(Saturation(getMainColor("positive"), 0.8))
	end,
	OnCommand=function(self)
		self:settext(GAMESTATE:GetEtternaVersion())
	end,
	MouseDownCommand = function(self, params)
		if params.event == "DeviceButton_left mouse button" then
			DLMAN:ShowProjectReleases()
		end
	end
}


t[#t + 1] = UIElements.TextToolTip(1, 1, "Common Large") .. {
	Name = "geometrydash",
	InitCommand=function(self)
		self:xy(SCREEN_LEFT + 1,SCREEN_BOTTOM - 15):zoom(0.25):halign(0):valign(0)
		self:diffusetopedge(Saturation(getMainColor("highlight"), 0.5))
		self:diffusebottomedge(Saturation(getMainColor("positive"), 0.8))
	end,
	BeginCommand = function(self)
		self:settext("Check out more themes on Martzi's repo")
	end,
	MouseDownCommand = function(self, params)
		if params.event == "DeviceButton_left mouse button" then
			Arch.setClipboardText("https://sectofmysticwisdom.com/etternathemerepo") --prob doesn't work on linux 
			ms.ok("Link Copied Succesfully!")
		end
	end
}

--game update button
local gameneedsupdating = false
local buttons = {x = 20, y = 20, width = 142, height = 42, fontScale = 0.35, color = getMainColor("frames")}
t[#t + 1] = Def.ActorFrame {
	InitCommand = function(self)
		self:xy(buttons.x,buttons.y)
	end,
	UIElements.QuadButton(1, 1) .. {
		InitCommand = function(self)
			self:zoomto(buttons.width, buttons.height):halign(0):valign(0):diffuse(buttons.color):diffusealpha(0)
			local latest = tonumber((DLMAN:GetLastVersion():gsub("[.]", "", 1)))
			local current = tonumber((GAMESTATE:GetEtternaVersion():gsub("[.]", "", 1)))
			if latest and latest > current then
				gameneedsupdating = true
			end
		end,
		OnCommand = function(self)
			if gameneedsupdating then
				self:diffusealpha(0.3)
			end
		end,
		MouseDownCommand = function(self, params)
			if params.event == "DeviceButton_left mouse button" and gameneedsupdating then
				GAMESTATE:ApplyGameCommand("urlnoexit,https://github.com/etternagame/etterna/releases;text,GitHub") --lol
			end
		end
	},
	LoadFont("Common Large") .. {
		OnCommand = function(self)
			self:xy(1.7, 1):align(0,0):zoom(buttons.fontScale):diffuse(getMainColor("positive"))
			if gameneedsupdating then
				self:settext(THEME:GetString("ScreenTitleMenu", "UpdateAvailable"))
			else
				self:settext("")
			end
		end
	}
}

local function mysplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

local transformF = THEME:GetMetric("ScreenTitleMenu", "ScrollerTransform")
local scrollerX = THEME:GetMetric("ScreenTitleMenu", "ScrollerX")
local scrollerY = THEME:GetMetric("ScreenTitleMenu", "ScrollerY")
local scrollerChoices = THEME:GetMetric("ScreenTitleMenu", "ChoiceNames")
local _, count = string.gsub(scrollerChoices, "%,", "")
local choices = mysplit(scrollerChoices, ",")
local choiceCount = count + 1
local i

for i = 1, choiceCount do
	t[#t + 1] = UIElements.QuadButton(1, 1) .. {
		OnCommand = function(self)
			self:xy(scrollerX, scrollerY):zoomto(50, 16)
			transformF(self, 0, i, choiceCount)
			self:diffusealpha(0)
			self:addx(90)
			self:addy(-70)
		end,
		MouseDownCommand = function(self, params)
			if params.event == "DeviceButton_left mouse button" then
				SCREENMAN:GetTopScreen():playcommand("MadeChoicePlayer_1")
				SCREENMAN:GetTopScreen():playcommand("Choose")
				if choices[i] == "Multi" or choices[i] == "GameStart" then
					GAMESTATE:JoinPlayer()
				end
				GAMESTATE:ApplyGameCommand(THEME:GetMetric("ScreenTitleMenu", "Choice" .. choices[i]))
			end
		end
	}
end

return t
