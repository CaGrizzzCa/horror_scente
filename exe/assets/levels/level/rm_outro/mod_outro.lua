-- name=rm_outro
function public.Init()
  --------------------------------------------------------------------------------------------
  private.room_objname = "rm_outro";
  --------------------------------------------------------------------------------------------
  ObjSet("spr_outro_ok",{ 
    event_mdown =  function () Quit()           end,
    event_menter = function () private.ButtonMouseEnter( "ok" ); end,
    event_mleave = function () private.ButtonMouseLeave( "ok" ); end 
                    })
end

function public.Open()
  SoundEnv( 0 )
  SoundSfx( 0 )
  SoundTheme( "aud_maintheme_mus", true )
end;
--*********************************************************************************************************************
function public.PreOpen()
  int.InterfaceSetVisible(0);
  int.InterfaceSetInput(0);
  common_impl.SetButtonTextColor({"txt_outro_ok"}, 25, common_impl.ButtonTextOutlineColor())

  if IsSurveyEdition() then
    ObjSet( "spr_outro_survey_text", {visible = 1} );
    --ObjSet( "spr_outro_demo_text", {visible = 1} );
  elseif IsDemoEdition() then
    ObjSet( "spr_outro_demo_text", {visible = 1} );
  end

  if IsCollectorsEdition() then
    ObjSet( "spr_outro_logo_ce", {visible = 1} );
    ObjSet( "spr_outro_demo_text", {visible = 1} );
  else
    ObjSet( "spr_outro_logo_ce", {visible = 0} );
  end

end;

function private.ButtonMouseEnter ( but_name )
  SetCursor( CURSOR_HAND );
  local obj = "spr_outro_"..but_name.."_focus";
  local txt = "txt_outro_"..but_name;
  local alp = ObjGet( obj ).alp;
  ObjAnimate( obj, "alp", 0, 0, "", { 0, 0, alp, ( common_impl.animtime * ( 1 - alp ) ), 0, 1 } );
  --interface.PopupShow( 'str_menu_back')
  ObjSet( txt, {color_r = 1, color_g = 1, color_b = 1} );
end;

function private.ButtonMouseLeave ( but_name )
  SetCursor( CURSOR_DEFAULT );
  local obj = "spr_outro_"..but_name.."_focus";
  local txt = "txt_outro_"..but_name;
  local alp = ObjGet( obj ).alp;
  ObjAnimate( obj, "alp", 0, 0, "", { 0, 0, alp, ( common_impl.animtime * alp ), 0, 0 } );
  local r,g,b = common_impl.ButtonTextColorLeave()
  ObjSet( txt, {color_r = r, color_g = g, color_b = b} );
end;

--*********************************************************************************************************************
function public.Close()
end;
--*********************************************************************************************************************
function public.PreClose()
end