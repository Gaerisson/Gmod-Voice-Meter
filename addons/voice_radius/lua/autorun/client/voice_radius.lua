surface.CreateFont( "ConText", {
    font = "Arial",
    extended = false,
    size = 16,
    weight = 700,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
} )

local show_voice_radius = CreateClientConVar( "show_voice_radius", 1, true, false )

local function DrawVoicePanel()
    if LocalPlayer():IsTyping() then return end
	
    if show_voice_radius:GetInt() == 1 then
        local possphere = {} -- ents.FindInSphere( LocalPlayer():GetPos(), 2904 )
        local lvl = ""
        local lvlcol = Color(0,0,0)

		table.Merge(possphere,LLSpTable)
        for k,v in pairs( player.GetHumans() ) do
			
            local pos = LocalPlayer():GetPos():Distance( v:GetPos() )

			-- if(GetConVar("sv_alltalk"):GetInt()!=0)then
				if pos < 2904 and v ~= LocalPlayer() then
					possphere[ #possphere + 1 ] = v
				end
			-- else
				-- possphere[ #possphere + 1 ] = v
			-- end
        end
        
		table.sort( possphere, function( a, b ) return LocalPlayer():GetPos():Distance( a:GetPos() ) > LocalPlayer():GetPos():Distance( b:GetPos() ) end )
		
        for k,v in pairs( possphere ) do
            k = k*2
            local pmeter = math.Round(LocalPlayer():GetPos():Distance(v:GetPos()) * 1.905 / 100,0)
			
			if(v:IsMuted())then
				voicest="X"
				voice_col=Color(255,55,0)
			elseif(v:IsSpeaking())then
				voicest="‹)"
				voice_col=Color(0,125,255)
			else
				voicest="‹|"
				voice_col=Color(230,230,230)
			end
			
			
            if(pmeter>50)then
                lvl="■□□□"
                lvlcol=Color(215,35,35)
            elseif(pmeter>=30 and pmeter<=50)then
                lvl="■■□□"
                lvlcol=Color(215,105,35)
            elseif(pmeter>=20 and pmeter<=30)then
                lvl="■■■□"
                lvlcol=Color(215,190,35)
            elseif(pmeter<20)then
                lvl="■■■■"
                lvlcol=Color(35,215,65)
            end

            if(v:GetFriendStatus()=="friend")then
                draw.SimpleText( v:GetName().." ["..pmeter.."m]", "ConText" , ScrW()-60, ScrH()/2+(k*9), Color( 127, 255, 127 ), TEXT_ALIGN_RIGHT )
            else
                draw.SimpleText( v:GetName().." ["..pmeter.."m]", "ConText" , ScrW()-60, ScrH()/2+(k*9), team.GetColor(v:Team()) , TEXT_ALIGN_RIGHT )
            end
            draw.SimpleText( "["..lvl.." ]", "ConText" , ScrW()-15, ScrH()/2+(k*9), lvlcol , TEXT_ALIGN_RIGHT )
            draw.SimpleText( voicest, "ConText" , ScrW()-4, ScrH()/2+(k*9), voice_col , TEXT_ALIGN_RIGHT )
        end
    end
end

hook.Remove("HUDPaint", "DrawVoicePanel")
hook.Add("HUDPaint", "DrawVoicePanel", DrawVoicePanel)
