-- name=rm_intro
--******************************************************************************************
-- для добавления нового лого достаточно добавить его название в массив private.logo
--******************************************************************************************
private.logo = { "bigfish", "elephantgames", "music" };
private.objs = {     false,           false,    true }; --есть ли объект, который будет дополнительно цепляться к интро
private.counter = 0;
private.objLogo = "spr_intro_logo";
private.objBlack = "spr_intro_black";
--******************************************************************************************
function private.TypesTest() 
  local arr = {
    "arial",
    "berkshireswash",
    "breeserif",
    "caesardressingregular",
    "caladea_regular",
    "cinzelbold",
    "cinzelregular",
    "deliusswashcaps",
    "leaguegothic",
    "linlibertine_abl",
    "linlibertine_dr",
    "milonga",
    "niconne",
    "pattaya_regular",
    "sunshiney",
    "times"
  }

  local root = "obj_intro_video_types_test"
  local phrase = "The quick brown fox jumps over the lazy dog"
  local phrase = "?¡¢£¥§©®¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝŸŒßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýÿœ „“"
  local phrase = [[Stekkjastaur Giljagaur Stúfur Þvörusleikir Pottasleikir Askasleikir 
  Hurðaskellir Skyrgámur Bjúgnakrækir Gluggagægir Gáttaþefur Ketkrókur Kertasníkir]]
  for i,o in ipairs(arr) do
    local obj = root.."_"..i
    ObjCreate(obj,"text")
    ObjSet( obj, {res = "assets/fonts/"..o, align = 0, fontsize = 20} );
    ObjSet( obj, {pos_x = 0, pos_y = 50+i*40} );
    ObjSet( obj, {text = o.."  "..phrase} );
    ObjAttach(obj,root)
    
  end
  ObjSet( root, {visible = 1} );
  ObjAttach(root,"rm_intro")
end;

function public.Init()

  room.Define( "rm_intro" );
  ObjSet(private.objLogo, {
    input = false,
    event_mdown = private.IntroLogoHide
  });
  private.UpdateLogoToNextRes();

  ObjSet( "anm_intro_music_txt", {for_the_best = "txt_intro_logo_music"} );
  --private.TypesTest() 
end;
--******************************************************************************************
function public.Open()

  private.counter = 1;
  private.IntroLogoShow();

end;
--******************************************************************************************
function private.UpdateLogoToNextRes()

  if private.objs[ private.counter ] then
    ObjDetach( "obj_intro_logo_"..private.logo[ private.counter ] )
  end

  private.counter = private.counter + 1;
  ObjSet(private.objLogo, {
    res = "assets/levels/menu/rm_intro/logo_"..private.logo[ private.counter ]
  });

  if private.objs[ private.counter ] then
    ObjAttach( "obj_intro_logo_"..private.logo[ private.counter ], "spr_intro_logo" )
  end

end;
--******************************************************************************************
function private.IntroLogoShow()

  --ObjAnimate( private.objLogo, "alp", 0, 0 ,private.IntroLogoActivate, { 0,0,0, 0.8,0,1 } );
  ObjAnimate( private.objBlack, "alp", 0, 0 ,private.IntroLogoActivate, { 0,0,1, 0.8,2,0 } );
  if ( private.counter == 3 ) then
    ObjAnimate( "vid_intro_play_with_sound", 7, 0, 0, function() 
      VidPlay("vid_intro_play_with_sound",_)
      SoundSfx( "reserved/aud_play_with_sound" ) ;
    end, {0,0,0, 0,0,0} );
    --ObjSet( "anm_intro_music_anm", {playing = 1} );
  end;

end;
--******************************************************************************************
function private.IntroLogoActivate()
  local time = 3 -- default time for screen
  if ( private.counter == 3 ) then
    --ObjAnimate( "vid_intro_play_with_sound", 7, 0, 0, function() 
    --  VidPlay("vid_intro_play_with_sound",_)
    --  SoundSfx( "reserved/aud_play_with_sound" ) ;
    --end, {0,0,0, 0,0,0} );
    --ObjSet( "anm_intro_music_anm", {playing = 1} );

    -- custom time for PWS Screen
    
    time = 12-0.8
  end;
  
  ObjSet( private.objLogo, { input = true } );
  --ObjStopAnimate( private.objLogo, "alp" );
  ObjStopAnimate( private.objBlack, "alp" );
  --ObjAnimate( private.objLogo, "alp", 0, 0, private.IntroLogoHide, { 0,0,1, 3,0,1 } );
  ObjAnimate( private.objBlack, "alp", 0, 0 ,private.IntroLogoHide, { 0,0,0, time,0,0 } );

end;
--******************************************************************************************
function private.IntroLogoHide()
  
  local trg = function () 
    private.UpdateLogoToNextRes();
    private.IntroLogoShow(); 
  end;
  if private.counter == #private.logo then
    trg = private.IntroVideoPlay;
    VidPause("vid_intro_play_with_sound",1)
    ObjSet( "vid_intro_play_with_sound", {active = 0} );
    SoundSfxStop("reserved/aud_play_with_sound",0.3)
  end;
  ObjSet( private.objLogo, { input = false } );
  --ObjStopAnimate( private.objLogo, "alp" );
  ObjStopAnimate( private.objBlack, "alp" );
  --ObjAnimate( private.objLogo, "alp",0 ,0, trg, { 0,0,1, 0.8,0,0 } );
  ObjAnimate( private.objBlack, "alp",0 ,0, trg, { 0,0,0, 0.8,2,1 } );

end;
--******************************************************************************************
function private.IntroVideoPlay()
  interface.DialogVideoShow( "obj_intro_video", 1, private.IntroVideoEnd );
  
  
  ObjAnimate( "vid_intro_video", 7, 0, 0, function()
    ObjDelete("vid_intro_play_with_sound")
    VidPlay( "vid_intro_video",function() 
      ObjAnimate( "vid_intro_video", 12, 0, 0, function() end, {0,0,1,1,1, 1,0,1,1,1} ); 
      ld.StartTimer( 0.3, function()  
        SoundSfx( "reserved/aud_see_game_logo" )
        ld.AnimPlay( "anm_intro_logo", "anim_logo_lage", function() 
          private.IntroVideoEnd(); 
        end )  
      end )
    end);
    SoundVid( "aud_vid_preintro1" )
    --SoundVoice( "aud_vid_intro1_entrypoint_voc" )
    --local t_logo = {0, 24.5, 25, 30, 30.5}
    --ObjAnimate( "anm_intro_logo", 8, 0, 0, "", {t_logo[1],0,0, t_logo[2],0,0, t_logo[3],0,1, t_logo[4],0,1, t_logo[5],0,0} );

    --ld.StartTimer( 19, function() ld.AnimPlay( "anm_intro_logo", "anim_logo_lage", "" ) end )
  end, {0,0,0, 0,0,0} );

  --local t_logo = {0, 21, 21.5, 25, 25.5}

 
  if ( IsCollectorsEdition()) then
    ObjSet( "spr_intro_logo_ce", {alp = 1} );
  end

  ld_impl.VideoSubtitleVocStart( {
    --{ "str_preintro_1", aud_voc_false,  2.58,  13.51 };
    --{ "str_preintro_2", aud_voc_false,  22.06, 30.63 };
    --{ "str_preintro_3", aud_voc_false,  43.0, 48.0 };
    --{ "srt_preintro_4", aud_voc_false, 13.0, 15.2 };
    --{ "srt_preintro_5", aud_voc_false, 16.0, 19.1 };
    --{ "srt_preintro_6", aud_voc_false, 19.5, 22.7 };
  } )
  

end;
--******************************************************************************************
function private.IntroVideoEnd()
  SoundVoice(0);
  ObjStopAnimate("vid_intro_video",8);              --ld.LogTrace( "======================way1" );
  interface.DialogVideoHide();                      --ld.LogTrace( "======================way2" );
  ObjAttach( "tmr_intro_videoend", "cmn_timers" );  
  local funcVideoEnd = function () 
    cmn.GotoRoom('rm_menu');                        --ld.LogTrace( "======================way3" );
    SoundSfx( 0 )
    ObjDelete('tmr_intro_videoend'); 
  end; 
  ObjSet( "tmr_intro_videoend", 
  { 
    endtrig = funcVideoEnd, 
    time = 0.6, 
    playing = true
  } );

end;
--******************************************************************************************