-- name=rm_intro
--******************************************************************************************
-- для добавления нового лого достаточно добавить его название в массив private.logo
--******************************************************************************************
private.logos = 3
private.videos = 1
private.anim_time = 1
private.time_freeze = 3
--private.objs = {     false,           false }; --есть ли объект, который будет дополнительно цепляться к интро
--private.counter = 0;
--private.objLogo = "spr_intro_logo";
private.objBlack = "spr_intro_black";

function public.Init()

  room.Define( "rm_intro" )
  
  ObjSet(private.objBlack, { event_mdown = private.IntroLogoHide })
  
end;
--******************************************************************************************
function public.Open()

  private.counter = 1;
  private.IntroLogoShow();

end;

--******************************************************************************************
function private.IntroLogoShow()
  
  local back = "spr_intro_logo_back_"..private.counter
  if not ObjGet(back) then
    ObjCreate(back, "spr")
    ObjAttach(back, "rm_intro")
  end
  ObjSet(back, {
    res = "assets/levels/menu/rm_intro/logo_"..private.counter,
    input = false
  })
  ObjAnimate( back,8,0,0, private.IntroLogoActivate, {0,0,0, private.anim_time,0,1} )
  ObjAnimate( private.objBlack, 8,0,0, _, {0,0,1, 0.8,2,0} )
  ObjSet(private.objBlack, {input = false})

end;
--******************************************************************************************
function private.IntroLogoActivate()
  
  ObjSet(private.objBlack, {input = true})
  ObjAnimate( private.objBlack, 8,0,0, private.IntroLogoHide, { 0,0,0, private.time_freeze,2,0 } )
  SoundSfx("intro/aud_intro_logo_"..private.counter)
  
end;
--******************************************************************************************
function private.IntroLogoHide()
  
  ObjSet(private.objBlack, {input = false})
  local back = "spr_intro_logo_back_"..private.counter
  
  local func_next_step = function()
    ObjDetach(back)
    private.counter = private.counter + 1
    if private.counter>private.logos then
      private.IntroVideoPlay()
    else
      private.IntroLogoShow()
    end
  end
  
  ObjAnimate( back,8,0,0, func_next_step, {0,0,1, private.anim_time,0,0} )
  ObjAnimate( private.objBlack, 8,0,0, _, {0,0,0, 0.8,2,1} )
  
end;
--******************************************************************************************
function private.IntroVideoPlay()
  
  local count = private.counter-private.logos
  local video = "vid_intro_video_"..count
  
  local func_next_step = function()
    ObjAnimate(video,8,0,0, function() ObjDetach(video) end, {0,0,1, 0.4,0,0})
    interface.DialogVideoHide()
    private.counter = private.counter + 1
    count = private.counter - private.logos
    if count > private.videos then
      private.IntroVideoEnd()
    else
      private.IntroVideoPlay()
    end
  end
  
  interface.DialogVideoShow( video, 1, func_next_step, 0 )
  
  ObjAnimate( private.objBlack, 8,0,0, _, {0,0,1, 0.8,2,0} )
  ObjAttach(video, "rm_intro")
  VidPlay(video, func_next_step)
  SoundVid("intro/aud_intro_vid_"..count)
  
end;
--******************************************************************************************
function private.IntroVideoEnd()
  
  ObjAttach( "tmr_intro_videoend", "cmn_timers" );  
  local funcVideoEnd = function () 
    cmn.GotoRoom('rm_menu')
    SoundSfx( 0 )
    ObjDelete('tmr_intro_videoend'); 
  end; 
  ObjSet( "tmr_intro_videoend", 
  {
    endtrig = funcVideoEnd, 
    time = 0.6, 
    playing = true
  })

end;
--******************************************************************************************