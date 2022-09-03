-- name=int_panel_notification_impl
--******************************************************************************************
function public.Init()

  public.DELAY_TIME = 2.5;

  public.DIRECTION      =   - 1;
  public.POSITION       =   0;
  private.SHOW_POSITION =   215;
  private.HIDE_POSITION = - 215;

  private.SHOW_TIME            = 0.6;
  private.MOUSE_OVER_ANIM_TIME = 0.3;

  public.type_nfction = ""

  ObjSet( "btn_int_panel_notification_achievement_goto", {
    event_mdown = function () int_panel_notification.MouseDown(); end,
    event_menter = function () private.MouseEnter( "achievement" ); end,
    event_mleave = function () private.MouseLeave( "achievement" ); end
  } );

  ObjSet( "btn_int_panel_notification_coin_goto", {
    event_mdown = function () int_panel_notification.MouseDown(); end,
    event_menter = function () private.MouseEnter( "coin" ); end,
    event_mleave = function () private.MouseLeave( "coin" ); end
  } );

  --common_impl.SetButtonTextColor({"txt_int_panel_notification_achievement_goto","txt_int_tutorial_buttons_right"}, 20, common_impl.ButtonTextOutlineColor())
  common_impl.SetButtonTextColor({"txt_int_panel_notification_achievement_goto"}, 25, common_impl.ButtonTextOutlineColor())
end;
--******************************************************************************************
function public.SetExtended( notification_type, notification_params )

  -- Установка свойств объектов для текущего типа по заданным параметам.
  -- example
  --ObjSet( "btn_int_panel_notification_achievement_goto", {input = 0, visible = 0} );
  if notification_params.text  == "str_achievement_puzzle" then
    public.type_nfction = "puzzle"
    ObjSet( "txt_int_panel_notification_"..notification_type, notification_params );
    ObjSet( "txt_int_panel_notification_"..notification_type, {text = notification_params.text,param0 = notification_params.count - 12,param1 = #ng_global.achievements.puzzle - 12} );
    ObjSet( "spr_int_panel_notification_"..notification_type.."_icon", {res="assets/levels/menu/rm_achievements/preview/puzzle"} );
    if ng_global.currentprogress == "std" then
      cmn.SetEventDone( "tutorial_puzzle2" );
      --level.tutorial_puzzle.first();
    end
    --ld.StartTimer( "tmr_tutorial_puzzle", private.SHOW_TIME+0.1 , function()  end )
  elseif notification_params.text  == "str_achievement_morphing" then
    public.type_nfction = "morphing"
    ObjSet( "txt_int_panel_notification_"..notification_type, notification_params );
    ObjSet( "txt_int_panel_notification_"..notification_type, {text = notification_params.text,param0 = notification_params.count,param1 = #ng_global.achievements.miniature} );
    ObjSet( "spr_int_panel_notification_"..notification_type.."_icon", {res="assets/levels/menu/rm_achievements/preview/coll_"..notification_params.num} );
    if ng_global.currentprogress == "std" then
      --level.tutorial_coll.first();
    end
    --ld.StartTimer( "tmr_tutorial_morph", private.SHOW_TIME+0.1 , function()  end )
  elseif notification_params.text  == "str_achievement_morphtrash" then
    public.type_nfction = "achievement"
    ObjSet( "txt_int_panel_notification_"..notification_type, notification_params );
    ObjSet( "txt_int_panel_notification_"..notification_type, {text = notification_params.text,param0 = notification_params.count,param1 = #ng_global.achievements.morphtrash } );
    ObjSet( "spr_int_panel_notification_"..notification_type.."_icon", {res="assets/levels/menu/rm_achievements/preview/simple"} );
    --if notification_params.count ~= #ng_global.achievements.morphtrash then
      ObjSet( "btn_int_panel_notification_achievement_goto", {input = 0, visible = 0} );
    --end
    if ng_global.currentprogress == "std" then
      --level.tutorial_morph.first();    
    end
  else 
    if room.GetCurrent() == "rm_achievements" then
      ObjSet( "btn_int_panel_notification_achievement_goto", {input = 0, visible = 0} );
    end
    public.type_nfction = "achievement"
    local count = ""
    if notification_params.count then
      count = "_"..notification_params.count
    end
    --if ng_global.currentprogress == "sgm" then
    --  prg = "sgm";
    --end
    ObjSet( "txt_int_panel_notification_"..notification_type, notification_params );
    ObjSet( "txt_int_panel_notification_"..notification_type, {text = notification_params.text..count } );
    local prg = "std";
    local ach_name = string.gsub( notification_params.text, "str_achievement_","" );
    --ObjSet( "spr_int_panel_notification_"..notification_type.."_icon", {res="assets/interface/int_achievements/img_achiev/"..prg.."/"..ach_name..count} );
    ObjSet( "spr_int_panel_notification_"..notification_type.."_icon", {res="assets/levels/menu/rm_achievements/preview/"..ach_name..count} );
    --ld.LogTrace(ObjGet("txt_int_panel_notification_"..notification_type).text)
    if _G[ "level" ] and ng_global.currentprogress == "std" then
      level.tutorial_ach.first();
    end
    --ld.StartTimer( "tmr_tutorial_ach", private.SHOW_TIME+0.1 , function()  end )
  end
end;
--******************************************************************************************
function public.ShowAnim( event_id )

  --SoundSfx( "aud_small_window_show" )

  local objname = "int_panel_notification_impl_root";

  local hide_position = private.HIDE_POSITION;
  local show_position = private.SHOW_POSITION;

  ObjSet( objname, { pos_x = hide_position } );

  local trg = function () int_panel_notification.EventAnimEnd( event_id ); end;
  local tme = private.SHOW_TIME;

  ObjAnimate( objname, "pos_x", 0, 0, trg,
  {
    0.0, 2, hide_position,
    tme, 2, show_position
  } );

end;
--******************************************************************************************
function public.HideAnim( event_id )

  --SoundSfx( "aud_small_window_hide" )

  local objname = "int_panel_notification_impl_root";

  local hide_position = private.HIDE_POSITION;
  local show_position = private.SHOW_POSITION;

  local tme = private.SHOW_TIME;
  local trg = function () int_panel_notification.EventAnimEnd( event_id ); end;

  ObjAnimate( objname, "pos_x", 0, 0, trg,
  {
    0.0, 1, show_position,
    tme, 1, hide_position
  } );

end;
--******************************************************************************************
function private.MouseEnter( notification_type )

  local focus_name = "spr_int_panel_notification_"..notification_type.."_goto_focus";

  local cur_alp = ObjGet( focus_name ).alp;

  local tme = private.MOUSE_OVER_ANIM_TIME;

  local txt = "txt_int_panel_notification_achievement_goto"

  ObjSet( txt, {color_r = 1, color_g = 1, color_b = 1} );

  ObjAnimate( focus_name, "alp", 0, 0, "",
  {
    0.0,             3, cur_alp,
    tme*(1-cur_alp), 3, 1
  } );

  SetCursor( CURSOR_HAND );

end;
--******************************************************************************************
function private.MouseLeave( notification_type )

  local focus_name = "spr_int_panel_notification_"..notification_type.."_goto_focus";

  local cur_alp = ObjGet( focus_name ).alp;

  local tme = private.MOUSE_OVER_ANIM_TIME;

  local txt = "txt_int_panel_notification_achievement_goto"

  local r,g,b = common_impl.ButtonTextColorLeave()
  ObjSet( txt, {color_r = r, color_g = g, color_b = b} );

  ObjAnimate( focus_name, "alp", 0, 0, "",
  {
    0.0,         3, cur_alp,
    tme*cur_alp, 3, 0
  } );

  SetCursor( CURSOR_DEFAULT );

end;
--******************************************************************************************
function public.WideScreenUpdate()

  if ( not GetWideScreen() ) then

    --

  else

    --

  end;

end;
--******************************************************************************************
function public.PauseLevel( msg, param )
  if msg == "Command_Level_Pause" then
    ObjSet( "int_panel_notification", { active = 1 - param.pause } )
  end;
end