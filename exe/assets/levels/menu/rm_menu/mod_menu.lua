-- name=rm_menu
--******************************************************************************************
function public.Init()
  
  private.time_add = 0.5
    
  --  ObjSet("menu_but_play", 
  --  {
  --    event_mdown = private.PlayDown,
  --    event_menter = function () private.ButtonMouseEnter('play'); end,
  --    event_mleave = function () private.ButtonMouseLeave('play'); end
  --  });
    ObjSet("spr_menu_but_options", 
    {
      event_mdown = private.OptionsDown,
      event_menter = function () private.ButtonMouseEnter('options'); end,
      event_mleave = function () private.ButtonMouseLeave('options'); end
    })
  --  ObjSet("menu_but_quit", 
  --  {
  --    event_mdown = private.QuitDown,
  --    event_menter = function () private.ButtonMouseEnter('quit'); end,
  --    event_mleave = function () private.ButtonMouseLeave('quit'); end
  --  })
  --  ObjSet("menu_but_change", 
  --  {
  --    event_mdown = private.ProfileDown,
  --    event_menter = function () private.ButtonMouseEnter('profile'); end,
  --    event_mleave = function () private.ButtonMouseLeave('profile'); end
  --  })
  
end;
--******************************************************************************************
function public.PreOpen()
  --  SoundEnv( "reserved/aud_menu_env" )
  SoundTheme( "music/aud_maintheme_mus", 1 )
end;
--******************************************************************************************
function public.Open()
  
end;
--******************************************************************************************
function public.SetProfileText ( name )
  --local obj = "txt_menu_but_profile_change";
  --local profile_name = "";
  --if  ( name ~= "ng_noprofiles" )
  --and ( name ~= "ng_error" )
  --then
  --profile_name = name;
  --end;
  --ObjSet( obj, { text = profile_name } )
end;
--******************************************************************************************
function private.PlayDown()
  --SoundSfx( "reserved/aud_click_menu" )
  --common.MenuPlay();
end;
--******************************************************************************************
function private.OptionsDown()
  SoundSfx( "interface/aud_click_menu" )
  common.MenuOptions()
end;
--******************************************************************************************
function private.QuitDown()
  SoundSfx( "interface/aud_click_menu" )
  common.MenuQuit(); 
end;
--******************************************************************************************
function private.ProfileDown()
  --SoundSfx( "interface/aud_click_menu" )
  --common.MenuProfile();
end;
--******************************************************************************************
function private.ButtonMouseEnter ( but_name )
  SetCursor( CURSOR_HAND )
  local a_time = private.time_add
  local button_add = "spr_menu_but_"..but_name
  ld.Anim.Set(button_add, {alp = 1}, a_time)
end;
--******************************************************************************************
function private.ButtonMouseLeave ( but_name )
  SetCursor( CURSOR_DEFAULT )
  local a_time = private.time_add
  local button_add = "spr_menu_but_"..but_name.."_add"
  ld.Anim.Set(button_add, {alp = 0}, a_time)
end;
