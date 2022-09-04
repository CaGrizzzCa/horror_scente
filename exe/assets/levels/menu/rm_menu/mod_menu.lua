-- name=rm_menu
--******************************************************************************************
function public.Init()
    --private.is_more_games_enabled = ( StringGet( "is_more_games_enabled" ) == "1" );
    
  --  ObjSet("menu_but_play", 
  --  {
  --    event_mdown = private.PlayDown,
  --    event_menter = function () private.ButtonMouseEnter('play'); end,
  --    event_mleave = function () private.ButtonMouseLeave('play'); end
  --  });
  --  ObjSet("menu_but_options", 
  --  {
  --    event_mdown = private.OptionsDown,
  --    event_menter = function () private.ButtonMouseEnter('options'); end,
  --    event_mleave = function () private.ButtonMouseLeave('options'); end
  --  });
  --  ObjSet("menu_but_credits", 
  --  {
  --    event_mdown = private.CreditsDown, input = false, visible = false,
  --    event_menter = function () private.ButtonMouseEnter('credits'); end,
  --    event_mleave = function () private.ButtonMouseLeave('credits'); end
  --  });
  --  ObjSet("menu_but_quit", 
  --  {
  --    event_mdown = private.QuitDown,
  --    event_menter = function () private.ButtonMouseEnter('quit'); end,
  --    event_mleave = function () private.ButtonMouseLeave('quit'); end
  --  });
  --  ObjSet("menu_but_extra", 
  --  {
  --    event_mdown = private.ExtraDown, 
  --    event_menter = function () private.ButtonMouseEnter('extra'); end,
  --    event_mleave = function () private.ButtonMouseLeave('extra'); end
  --  });
  --
  --  ObjSet("menu_but_strguide", 
  --  {
  --    event_mdown = private.StrguideDown, 
  --    event_menter = function () private.ButtonMouseEnter('strguide'); end,
  --    event_mleave = function () private.ButtonMouseLeave('strguide'); end
  --  });
  --  ObjSet("menu_but_change", 
  --  {
  --    event_mdown = private.ProfileDown,
  --    event_menter = function () private.ButtonMouseEnter('profile'); end,
  --    event_mleave = function () private.ButtonMouseLeave('profile'); end
  --  });
  --  ObjSet("menu_but_shop", 
  --  {
  --    event_mdown = private.ShopDown,
  --    event_menter = function () private.ButtonMouseEnter('shop'); end,
  --    event_mleave = function () private.ButtonMouseLeave('shop'); end
  --  });
  --
  --  ObjSet("menu_but_moregames", 
  --  {
  --    event_mdown = private.MoreGamesDown, 
  --    event_menter = function () private.ButtonMouseEnter('moregames'); end,
  --    event_mleave = function () private.ButtonMouseLeave('moregames'); end,
  --    visible = private.is_more_games_enabled,
  --    input = private.is_more_games_enabled 
  --  });
  --
  --  private.buttons_list = {
  --    {"txt_menu_but_play";30;-2;3;"assets/fonts/dejavuserif"};
  --  }
  --  private.buttons_list2 = {
  --  {"txt_menu_but_profile";30;-2,3;"assets/fonts/dejavuserif"};
  --  {"txt_menu_but_options";30;-2;3;"assets/fonts/dejavuserif"};
  --  {"txt_menu_but_quit";30;-2;3;"assets/fonts/dejavuserif"};
  --  {"txt_menu_but_strguide";30;-2;3;"assets/fonts/dejavuserif"};
  --  {"txt_menu_but_moregames";30;-2;3;"assets/fonts/dejavuserif"};
  --  {"txt_menu_but_extra";30;-2;3;"assets/fonts/dejavuserif"};
  --  }
  --  local r,g,b = common_impl.ButtonTextColorLeave("mainMenu");
  --  common_impl.SetButtonTextColor(private.buttons_list, nil, common_impl.ButtonTextOutlineColor("mainMenu"))
  --  common_impl.SetButtonTextColor(private.buttons_list, nil, nil, r,g,b,"text")
  --  for i,o in ipairs(private.buttons_list) do
  --    ObjSet( o[1], {pos_x = o[3], pos_y = o[4], res = o[5]} );
  --  end
  --
  --  local r,g,b = common_impl.ButtonTextColorLeave("mainMenu"); --common_impl.ButtonTextColorEnter();
  --  common_impl.SetButtonTextColor(private.buttons_list2, nil, common_impl.ButtonTextOutlineColor("mainMenu"))
  --  common_impl.SetButtonTextColor(private.buttons_list2, nil, nil, r,g,b,"text")
  --  for i,o in ipairs(private.buttons_list2) do
  --    ObjSet( o[1], {pos_x = o[3], pos_y = o[4], res = o[5]} );
  --  end
  
end;
--******************************************************************************************
function public.PreOpen()

  --  SoundEnv( "reserved/aud_menu_env" )
  SoundTheme( "music/aud_maintheme_mus", 1 )

end;
--******************************************************************************************
function public.Open()

    --if ng_global.progress then
    --  if ( (not ng_global.progress[ "std" ].common.gamestart ) and ( ng_global.progress[ "std" ].common.gamewin ) ) and  not (ng_global.bonusunlock) then
    --    if IsCollectorsEdition() then
    --      common.DialogWindowShow( "common", "complete_std",true );
    --    else 
    --      common.DialogWindowShow( "common", "complete_std_se",true );
    --    end
    --  
    --    ng_global.bonusunlock = true
    --    SaveProfiles();
    --  end;
    --end
end;

--******************************************************************************************
function public.SetProfileText ( name )
  
  local obj = "txt_menu_but_profile_change";
  local profile_name = "";
  if  ( name ~= "ng_noprofiles" )
  and ( name ~= "ng_error" )
  then
  profile_name = name;
  end;
  ObjSet( obj, { text = profile_name } );

end;
--******************************************************************************************
function private.PlayDown()
  SoundSfx( "reserved/aud_click_menu" )
  common.MenuPlay();
end;
--******************************************************************************************
function private.OptionsDown()
  SoundSfx( "reserved/aud_click_menu" )
  common.MenuOptions();
end;
--******************************************************************************************
function private.CreditsDown()
  SoundSfx( "reserved/aud_click_menu" )
  common.MenuCredits();
end;
--******************************************************************************************
function private.QuitDown()
  SoundSfx( "reserved/aud_click_menu" )
  common.MenuQuit();  
end;
--******************************************************************************************
function private.ExtraDown()
  SoundSfx( "reserved/aud_click_menu" )
  common.MenuExtra();
end;
--******************************************************************************************
function private.StrguideDown()
  --SoundSfx( "reserved/aud_click_menu" )

    if IsCollectorsEdition() then

      common_impl.ButtonGuide_Click();
      interface.StrategyGuideShow();

    else

      local guide_url = GetGuideUrl();
      OpenBrowser( guide_url );

    end;

end;
--******************************************************************************************
function private.ProfileDown()
  SoundSfx( "reserved/aud_click_menu" )
  common.MenuProfile();
end;
--******************************************************************************************
function private.ShopDown()
  SoundSfx( "reserved/aud_click_menu" )
  common.MenuShop();
end;
--*****************************************************************************************
function private.MoreGamesDown()
  SoundSfx( "reserved/aud_click_menu" )
  common.GotoRoom( "rm_moregames" );
end;
--******************************************************************************************
function private.ButtonMouseEnter ( but_name )
  SetCursor( CURSOR_HAND );
  local fx_active = 0
  local obj = "spr_menu_but_"..but_name.."_focus";
  local fx = "fx_menu_but_"..but_name
  local shadow = "spr_menu_but_"..but_name.."_shadow";
  local alp = ObjGet( obj ).alp;
  local alps = ObjGet( shadow ).alp;
  ObjSet( fx, {active = fx_active, visible = fx_active} );
  ObjAnimate( obj, "alp", 0, 0, "", { 0, 0, alp, ( common_impl.animtime * ( 1 - alp ) ), 0, 1 } );
  ObjAnimate( shadow, "alp", 0, 0, "", { 0, 0, alps, ( common_impl.animtime * alps ), 0, 0 } );

  --SoundSfx( "reserved/aud_guidance" )

  local obj_txt = "txt_menu_but_"..but_name
  local txt_param = ObjGet(obj_txt)
  ObjAnimate( obj_txt, 12, 0, 0, "", {0,0,txt_param.color_r,txt_param.color_g,txt_param.color_b, ( common_impl.animtime * alp ) ,0,common_impl.ButtonTextColorEnter()} );

  if but_name == "play" then
    --SoundEnv( "aud_candle_burn_env", 1 )
    --ObjAnimate( "pfx_menu_pm_candel", 8, 0, 0, "", {0,0,0, ( common_impl.animtime * alp ),0,1} );
  end
end;
--******************************************************************************************
function private.ButtonMouseLeave ( but_name )
  SetCursor( CURSOR_DEFAULT );
  local obj = "spr_menu_but_"..but_name.."_focus";
  local shadow = "spr_menu_but_"..but_name.."_shadow";
  local alp = ObjGet( obj ).alp;
  local alps = ObjGet( shadow ).alp;
  ObjAnimate( obj, "alp", 0, 0, "", { 0, 0, alp, ( common_impl.animtime * alp ), 0, 0 } );
  ObjAnimate( shadow, "alp", 0, 0, "", { 0, 0, alps, ( common_impl.animtime * ( 1 - alps ) ), 0, 1 } );

  local obj_txt = "txt_menu_but_"..but_name
  local txt_param = ObjGet(obj_txt)
  ObjAnimate( obj_txt, 12, 0, 0, "", {0,0,txt_param.color_r,txt_param.color_g,txt_param.color_b, ( common_impl.animtime * alp ) ,0,common_impl.ButtonTextColorLeave("mainMenu")} );

  if but_name == "play" then
    SoundEnv( "aud_candle_burn_env", 0 )
    ObjAnimate( "pfx_menu_pm_candel", 8, 0, 0, "", {0,0,1, ( common_impl.animtime * alp ),0,0} );
  end

end;
--******************************************************************************************
function public.ButtonSetPos()
  local offwidth = 0.5 * ( GetAppWidth() - 1024 );
  --ObjSet( "menu_objects_left",  { pos_x = ( 512 - offwidth ) } );
  --ObjSet( "menu_objects_right", { pos_x = ( 512 + offwidth ) } );
end;
--*****************************************************************************************
-------------------------------CLK-FUCTIONS-----------------------------------------------
------------------------------------------------------------------------------------------

--*****************************************************************************************
