-- name=common_impl
--*********************************************************************************************************************
--*********************************************************************************************************************

function public.Init()  
  DbgTrace( "common_impl.Init()" )
  ----------------------------------------------------------------------------------
  private.LoadStandardCursors();
  ----------------------------------------------------------------------------------
  common.SetCheaterKeyF( 1, "level" );-- Level 1 start point

  if IsEditor() then --fast test cheats
    common.SetCheaterKeyF( 6, "level", "opn_mattapartment", "rm_mattapartment" ); --Саша
    common.SetCheaterKeyF( 7, "level", "use_oldbell", "rm_kiosk2" ); --Антон 
    common.SetCheaterKeyF( 8, "level", "win_kioskdoor2", "rm_townpark2" ); --Марат

  end

  local function getReadyLevel()
    local s = ConfigGetProjectVersion()
    local num1 = tonumber(string.match(s,"^(%d)."))
    local num2 = tonumber(string.match(s,"^%d.(%d)"))
    if num1 >= 1 then
      return 100
    else
      return num2+1
    end
  end
  
  if not (IsDemoEdition() or IsSurveyEdition()) or IsCheater() then

    if IsEditor() or getReadyLevel() >= 2 then
      common.SetCheaterKeyF( 2, "level", "opn_townsquare2", "rm_townsquare2" );-- level 2 start point  
    end

    if IsEditor() or getReadyLevel() >= 3 then
      common.SetCheaterKeyF( 3, "level", "opn_nearofficeafter", "rm_nearofficeafter" );-- level 3 start point  
    end

    if IsCollectorsEdition() then

      if IsEditor() or getReadyLevel() >= 4 then
        common.SetCheaterKeyF( 4, "levelext", "opn_entrypointext", "rm_entrypointext" ); 
      end

      if IsEditor() or getReadyLevel() >= 5 then
        --common.SetCheaterKeyF( 5, "levelscr", "opn_secretroomscr", "rm_secretroomscr" );--ТОЛЬКО ЕСЛИ ЕСТЬ SECRETROOMSCR
      end

    end
  end

  if IsEditor() then
    ObjSet( "txt_dialog_options_info", {visible = 1} );
  end

  if true then  -- temp for version (true for off credits)
    ObjSet( "spr_dialog_options_button_credits", {res = "assets/levels/common/btn_na"} );
    ObjSet( "dialog_options_button_credits", {input = 0} );
    ObjSet( "txt_dialog_options_button_credits", {color_r = 0.5,color_g = 0.5,color_b = 0.5} );
  end

  public.subscribers_included = true;
  public.start_providence = false;
  private.timers = {};
  ng_global.investigation = 1;
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  public.animtime = 0.3;
  -------------------note-----------------------------------------------------------
  private.note_scale = {};
  private.note_scale.pos_x = 0;
  private.note_scale.pos_y = 0;

  -------------------buttons_text_color-----------------------------------------------------------
  private.buttons_text_color = {
    mainMenu = {leave={1,1,1}, outline={0,0,0,0,0.5}};
  }
  function public.ButtonTextColorEnter(param)
    if not param or not private.buttons_text_color[param] then
      return 1,1,1 -- цвет текста для всех кнопок при наведении
    else
      return private.buttons_text_color[param].enter[1],private.buttons_text_color[param].enter[2],private.buttons_text_color[param].enter[3]
    end
  end
  function public.ButtonTextColorLeave(param)
    if not param or not private.buttons_text_color[param]then
      return 1,0.921,0.843 -- цвет текста для всех кнопок при уведении
    else
      return private.buttons_text_color[param].leave[1],private.buttons_text_color[param].leave[2],private.buttons_text_color[param].leave[3]
    end
  end

  function public.ButtonTextOutlineColor(param)
    if param and private.buttons_text_color[param] and private.buttons_text_color[param].outline then
      return  table.unpack( private.buttons_text_color[param].outline)
    else
      return 2,0,0,0,0.7 -- размер и цвет и альфа оутлайна текста для всех кнопок при уведении
    end
  end

  private.buttons_list = {
  "txt_dialog_addprofile_button_left";
  "txt_dialog_addprofile_button_center";
  "txt_dialog_addprofile_button_right";

  "txt_dialog_common_button_left";
  "txt_dialog_common_button_center";
  "txt_dialog_common_button_right";

  "txt_dialog_togglescreen_button_center";

  "txt_dialog_profile_button_left";
  "txt_dialog_profile_button_center";
  "txt_dialog_profile_button_right";

  {"txt_dialog_playchoice_std_button_play", 17};
  {"txt_dialog_playchoice_std_button_reset", 17};
  {"txt_dialog_playchoice_ext_button_play", 17};
  {"txt_dialog_playchoice_ext_button_reset", 17};
  "txt_dialog_playchoice_button_center";

  {"txt_dialog_gamemode_button_custom",20};
  "txt_dialog_gamemode_button_left";
  "txt_dialog_gamemode_button_center";
  "txt_dialog_gamemode_button_right";

  {"txt_dialog_options_button_gamemode",17};
  {"txt_dialog_options_button_credits",17};
  "txt_dialog_options_button_left";
  "txt_dialog_options_button_center";
  "txt_dialog_options_button_right";

  "txt_dialog_gamemode_custom_button_center";


  }
  local buttons_fontsize = 25
  local buttons_font = "assets/fonts/dejavuserif"
  function public.SetButtonTextColorParams(list, params)
    for i,o in ipairs(list) do
      ObjSet(o, params)
    end
  end

  function public.SetButtonTextColor(list, fs, os,_r,_g,_b, colorApply)
    local r,g,b = public.ButtonTextColorLeave()
    if colorApply == "text" or colorApply == "font" then
       r,g,b = _r,_g,_b;
    end

    local errcount = 0
    local oldfs = fs
    for i,o in ipairs(list) do
      if type(o) == "table" then
        fs = o[2]
        o = o[1]
      else
        fs = oldfs
      end 
      if ObjGet(o) then

        if fs then
          ObjSet( o, {fontsize = fs, res = buttons_font} );
        else
          --ld.LogTrace( "Error: SetButtonTextColor No10" );
        end

        if r then
          if colorApply == "font" then
            ObjSet( o, {fontcolor_r = r, fontcolor_g = g, fontcolor_b = b} );
            ObjSet( o, {color_r = 1, color_g = 1, color_b = 1} );
          else
            ObjSet( o, {color_r = r, color_g = g, color_b = b} );
          end
        else
          --ld.LogTrace( "Error: SetButtonTextColor No20" );
        end

        if os then
          ObjSet( o, {display_outline = true, outline_size = os} );
          if not (colorApply == "text") then
            ObjSet( o, {outline_color_r = _r, outline_color_g = _g, outline_color_b = _b} );
            if ( type(colorApply) == "number" ) then
              ObjSet( o, {outline_alpha = colorApply} );
            end;
          end
        else
          --ld.LogTrace( "Error: SetButtonTextColor No30" );
        end

      else
        errcount = errcount + 1
      end
    end
    if errcount > 0 then
      ld.LogTrace( "Error: SetButtonTextColor missing "..errcount.." object(s) in list" );
    end
  end

  -------------------plus-----------------------------------------------------------
  private.plus_param = {};
  private.plus_param.pos_x = 40;
  private.plus_param.pos_y = -43;
  private.plus_param.scale_x = 0.95--1.05;
  private.plus_param.scale_y = 0.95--1.05;

 -------------------hint-----------------------------------------------------------
  public.hint = {}
  public.show_hint = {};
  public.save_autohide = 1;
  ----------------------------------------------------------------------------------
  public.for_hint ={};
  public.for_hint.res = "assets/interface/resources/fx/hint/fx_hint01";
  public.for_hint.res_center = "assets/interface/resources/fx/hint/fx_hint_ring"; -- ресурс на дополнительный эффект хинта
  public.for_hint.res_inv = "assets/interface/resources/fx/hint/fx_hint_inventory"; -- ресурс для хинта на инвентарь
  public.for_hint.big_R = 500;
  public.for_hint.big_R_zz = 500;
  public.for_hint.small_R = 40;
  public.for_hint.partsys_count = 6; -- количество систем частиц
  public.for_hint.time_fly = 1.0;    -- время, за которое частицы долетят до цели
  public.for_hint.time_fly_zz = 0.8; -- время для зум-зоны
  public.for_hint.time_circle = 3.0; -- время на один сдвиг по кругу
  public.for_hint.circle_cnt = 0.5;     -- количество сдвигов частиц по кругу
  public.for_hint.tme_show = 0.4;
  public.for_hint.tme_hide = 0.4;
  public.for_hint.tme_circle_fx = 1.0 --время показа центральной частицы
  public.for_hint.sinus_offset = 70 --амплитуда синусоиды
  public.for_hint.sinus_points_cnt = 50 --количество точек синусоиды
  public.for_hint.sinus_points_extrems = 2; --количество экстремумов синусоиды
  public.for_hint.play_sfx=true; --звук хинта в сложном объекте
  public.for_hint.target = {}
  public.dialog_pos = {};
  ----------------------------------------------------------------------------------

  cmn.SetEventDone   = public.SetEventDone;
  cmn.IsEventDone    = public.IsEventDone;
  cmn.SetEventStart  = public.SetEventStart;
  cmn.IsEventStart   = public.IsEventStart;
  cmn.HoTaskFind     = public.HoTaskFind;
  cmn.HoItemFind     = public.HoItemFind;
  cmn.MiniGameHide   = public.MiniGameHide;
  cmn.MiniGameShow   = public.MiniGameShow;
  cmn.SetMarkedTask  = public.SetMarkedTask;
  cmn.UnmarkTask     = public.UnmarkTask;
  cmn.IsUnmarkedTask = public.IsUnmarkedTask;
  cmn.IsFoundTask    = public.IsFoundTask;
  cmn.InitHo         = public.InitHo;
  cmn.GotoRoom       = common.GotoRoom;
  cmn.GotoSubRoom    = common.GotoSubRoom;


  cmn.IsSubscribersIncluded = common_impl.IsSubscribersIncluded;
  cmn.AddSubscribersToQueue = common.AddSubscribersToQueue;
  cmn.ExecuteQueue          = common.CallRoomEventHandlers;

  ld = {}
  ld.Lock                   = public.Lock;
  ld.LockRm                 = public.LockRm
  ld.LockTask               = public.LockTask
  ld.LockCustom             = public.LockCustom

  ld.LogTrace               = common.LogTrace;
  ld.ShowBbt                = public.ShowBbt;
  ld.ShowBbtIfExist         = public.ShowBbtIfExist;
  ld.ShowBbtOpn             = public.ShowBbtOpn;
  ld.ShowBbtAfter           = public.ShowBbtAfter;

  public.ZRMeventRun = ld_impl.ZRMeventRun;
  public.ZzCompleteCheck = ld_impl.ZzCompleteCheck;
  public.Gate_MDown      = ld_impl.Gate_MDown;
  public.Gate_MEnter      = ld_impl.Gate_MEnter;
  public.Gate_MLeave      = ld_impl.Gate_MLeave;
  --public.ShowBbt      = ld_impl.ShowBbt;
  public.UseItem      = ld_impl.UseItem;
  public.ProcessMultiUseAll = ld_impl.ProcessMultiUseAll;
  public.FlashbackInit     = ld_impl.FlashbackInit;
  public.FlashbackShow     = ld_impl.FlashbackShow;
  public.FlashbackHide     = ld_impl.FlashbackHide;
  
  int = {}
  int.DialogVideoShow       = interface.DialogVideoShow;
  int.DialogVideoHide       = interface.DialogVideoHide;
  int.InterfaceSetVisible   = interface.InterfaceSetVisible;
  int.InterfaceSetInput     = interface.InterfaceSetInput;

  private.audio = {};
  private.audio["sfx"] = {};
  private.audio["env"] = {};
  private.audio["mus"] = {};
  private.audio["voc"] = {};

  ----------------------------------------------------------------------------------

  private.volume_fade = false;
  private.dialog_voice = 0;
  private.dialog_soundtrack = 0;
  private.dialog_env = 0;

  ----------------------------------------------------------------------------------
  private.print = {};

  public.SetButtonTextColor(private.buttons_list, buttons_fontsize, public.ButtonTextOutlineColor())
end;
--*********************************************************************************************************************
--***function *** CURSOR *** () end************************************************************************************
--*********************************************************************************************************************
function private.LoadStandardCursors()

  --[[
  case 0:  pWinCursor = NULL; break;
  case 1:  pWinCursor = IDC_APPSTARTING; break;
  case 2:  pWinCursor = IDC_ARROW; break;
  case 3:  pWinCursor = IDC_CROSS; break;
  case 4:  pWinCursor = IDC_HAND; break;
  case 5:  pWinCursor = IDC_HELP; break;
  case 6:  pWinCursor = IDC_IBEAM; break;
  case 7:  pWinCursor = IDC_ICON; break;
  case 8:  pWinCursor = IDC_NO; break;
  case 9:  pWinCursor = IDC_SIZE; break;
  case 10: pWinCursor = IDC_SIZEALL; break;
  case 11: pWinCursor = IDC_SIZENESW; break;
  case 12: pWinCursor = IDC_SIZENS; break;
  case 13: pWinCursor = IDC_SIZEWE; break;
  case 14: pWinCursor = IDC_UPARROW; break;
  case 15: pWinCursor = IDC_WAIT; break;
  ]]

  common.CursorLoad( "CURSOR_NULL",    "",                            0  );
  common.CursorLoad( "CURSOR_DEFAULT", "assets/interface/cursors/cursor",       2  );
  common.CursorLoad( "CURSOR_LOUPE",   "assets/interface/cursors/cursor_loupe", 10 );
  common.CursorLoad( "CURSOR_GET",     "assets/interface/cursors/cursor_get",   4  );
  common.CursorLoad( "CURSOR_HAND",    "assets/interface/cursors/cursor_hand",  4  );
  common.CursorLoad( "CURSOR_USE",     "assets/interface/cursors/cursor_use",   4  );
  common.CursorLoad( "CURSOR_DOWN",    "assets/interface/cursors/cursor_down",  10 );
  common.CursorLoad( "CURSOR_UP",      "assets/interface/cursors/cursor_up",    10 );
  common.CursorLoad( "CURSOR_LEFT",    "assets/interface/cursors/cursor_left",  10 );
  common.CursorLoad( "CURSOR_RIGHT",   "assets/interface/cursors/cursor_right", 10 );
  common.CursorLoad( "CURSOR_LOCK",    "assets/interface/cursors/cursor_lock",  8 );

  common.CursorLoad( "CURSOR_TALK",    "assets/interface/cursors/cursor_talk",  4  );




  common.CursorLoad( "CURSOR_HELPER1","assets/interface/cursors/cursor_helper1_use",  4 );
  common.CursorLoad( "CURSOR_HELPER1_DRAG","assets/interface/cursors/cursor_helper1_drag_static",  2 );
  common.CursorLoad( "CURSOR_HELPER1_HOWER","assets/interface/cursors/cursor_helper1_drag_hover",  4 );

  common.CursorLoad( "CURSOR_HELPER2","assets/interface/cursors/cursor_helper2_use",  4 );
  common.CursorLoad( "CURSOR_HELPER2_DRAG","assets/interface/cursors/cursor_helper2_drag_static",  2 );
  common.CursorLoad( "CURSOR_HELPER2_HOWER","assets/interface/cursors/cursor_helper2_drag_hover",  4 );

end;

function private.choise_hide_y_pos()
  return (-530)
  -- -530 - это сдвиг grd_int_dialog_character_choise для скрытия диалогов
end

function private.choise_offset_widescreen()
  return (171 - 0.5*(GetAppWidth() - 1024))
end


function public.IsSubscribersIncluded ()

  return public.subscribers_included;

end;
--*********************************************************************************************************************
--***function *** HINT *** () end************************************************************************************
--*********************************************************************************************************************
  function private.CreateSinglePartySys( i, target_name, hint_pos_beg, hint_pos_end, tme, obj_name )

    local hint_name  = "pfx_hint_"..target_name.."_"..i;
    local obj_hint_name  = obj_name or "obj_hint_"..target_name;
    local index_anim_array = {};
    index_anim_array["x"] = {};
    index_anim_array["y"] = {};

    if ObjGet( hint_name ) then

      public.DeleteHintFx()

    end;

    ObjCreate( hint_name, "partsys" );

    ObjSet( hint_name,
    {
      res = public.for_hint.res;
      pos_x = hint_pos_beg[i][ "x" ], pos_y = hint_pos_beg[i][ "y" ], alp = 1
    } );
    if not( public.for_hint.target[1] == 0 ) then

      public.for_hint.target[1] = obj_hint_name;

    else

      public.for_hint.target[2] = obj_hint_name;

    end;

    ObjAttach( hint_name, obj_hint_name );
    ObjAnimate( hint_name, "pos_xy",0,0, function() 
      PartSysStop( hint_name, 0 )
      ld.StartTimer( 1.5, function() ObjDelete( hint_name ); end )
    end, {   0,0,hint_pos_beg[i][ "x" ],hint_pos_beg[i][ "y" ],
           tme,2,hint_pos_end[i][ "x" ],hint_pos_end[i][ "y" ] } );

  end;
  --*********************************************************************************************************************
  function public.CreateCenterPartSys( target_name, attach_name )

    local hint_name  = "pfx_hint_"..target_name.."_center";

    if ObjGet( hint_name ) then

      public.DeleteHintFx()

    end;

    ObjCreate( hint_name, "partsys" );

    ObjSet( hint_name,
    {
      res = public.for_hint.res_center,
      pos_x = 0, pos_y = 0,
      scale_x = 1.6, scale_y = 1.6
    } );

    ObjAttach( hint_name, attach_name );

  end;
  --*********************************************************************************************************************
  function private.GetCircleCoord( number, radius, ang_shift )

    local ang = 360 / number;
    local R  = radius or 70;
    local ang_num = ang_shift or 0;
    local pos = {};

    for i=1,number,1 do

      local cur_ang = math.rad(ang * ( i + ang_num ));

      pos[ i ] = {}
      pos[ i ][ "x" ] = math.cos( cur_ang ) * R ;--math.ceil(
      pos[ i ][ "y" ] = math.sin( cur_ang ) * R ;

    end;

    return pos;

  end;
  --*********************************************************************************************************************
  function private.CreateHintObj( target_name, room )
    ld.LogTrace("target_name = "..target_name.."   room = "..room );
    local obj_hint_name  = "obj_hint_"..target_name;
    local pos = GetObjPosByObj(target_name, room);

    if target_name:find( "^gfx_" ) then
      local parent = ObjGetRelations( target_name ).parent
      if parent and parent~= "" and ObjGet( parent ) .anim_tag ~= "" then
        local anm = ObjGetRelations( parent ).parent
        if anm and anm~= "" and ObjGet( anm ) .anim_funcs then
          local o = ObjGet( target_name )
          pos = GetObjPosByObj(parent, room);
          pos[ 1 ] = pos[ 1 ] + o.pos_x
          pos[ 2 ] = pos[ 2 ] + o.pos_y
        end
      end
    end
    if cheater then   
    cheater.target_name = target_name;
    cheater.hint_target = true;
    end
    local hint_pos_beg = {};
    local hint_pos_end = {};
    local partsys_R = public.for_hint.big_R;
    local tme = public.for_hint.time_fly;
    local timer_name = "tmr_"..target_name;

    if common.GetObjectPrefix( room ) == "zz" and target_name ~= subroom.GetSubRoomExitButton() then

      partsys_R = public.for_hint.big_R_zz;
      tme = public.for_hint.time_fly_zz;

    end;

    hint_pos_beg = private.GetCircleCoord( public.for_hint.partsys_count, partsys_R, -1 );

    hint_pos_end = private.GetCircleCoord( public.for_hint.partsys_count, public.for_hint.small_R );

    public.show_hint[ room ] = target_name;

    ObjCreate( obj_hint_name, "obj" );

    ObjSet( obj_hint_name,
    {
      pos_x = pos[1], pos_y = pos[2], pos_z = 1000,
      active = 1, visible = 1, input = 0, alp = 0
    } );

    for i=1,public.for_hint.partsys_count,1 do

      private.CreateSinglePartySys( i, target_name, hint_pos_beg, hint_pos_end, tme );

    end;

    if target_name == "obj_int_frame_subroom_button" then

      -->> OVERLAY -->>
      local p = GetObjPosByObj( target_name, "int_frame_subroom_impl" );
      ObjSet( obj_hint_name,
      {
        pos_x = p[ 1 ];
        pos_y = p[ 2 ];
        pos_z = 20;
      } );

      ObjAttach( obj_hint_name, "int_frame_subroom_impl" );
      --<< OVERLAY --<<

    else

     ObjAttach( obj_hint_name, room );

    end;

    local alp_tme = tme + public.for_hint.time_circle*public.for_hint.circle_cnt;

    ObjAnimate(obj_hint_name, "alp",0,0, "common_impl.HintShowAnimEnd( '"..target_name.."','"..room.."');",
      {
      0.0,0,0,
      public.for_hint.tme_show,0,1,
      alp_tme,0,1,
      (alp_tme + public.for_hint.tme_hide),0,0
      });

    ObjCreate( timer_name, "timer" );
    ObjAttach( timer_name, obj_hint_name );

    ObjSet( timer_name,
    {
      endtrig = "common_impl.CreateCenterPartSys( '"..target_name.."','"..obj_hint_name.."');",
      time    = public.for_hint.time_fly,
      playing = 1
    } );

    ObjAnimate( obj_hint_name, "ang",0,0, "", {0,0,0,
                          tme,0,-6.28*public.for_hint.circle_cnt});

  end;
  --*********************************************************************************************************************
  function public.DeleteHintFx()

    for i = 1,#public.for_hint.target do

      ObjDelete( public.for_hint.target[i] );

      if ( common.GetObjectPrefix( GetCurrentRoom() ) == "ho" ) and ( GetCurrentRoom() ~= currentroom ) then

        local target = string.sub( public.for_hint.target[i], 24,string.len( public.for_hint.target[i] ));
        interface.effects.ho_hint[target] = nil;

      else

        local target = string.sub( public.for_hint.target[i], 10,string.len( public.for_hint.target[i] ));
        public.show_hint[ target ] = nil;

        if string.find( public.for_hint.target[i], "inv_" ) then
          ObjDelete( "tmr_inv_"..target );
        else
          ObjDelete( "tmr_"..target );
        end;

      end;

    end;
    public.show_hint= {}
    public.for_hint.target = {}

  end;

  function public.DeleteZzHintFx( zz )
    --очиститель для хинтовых частиц, которые не успели доиграться, вызывать перед PreOpen zz
    local childs = ObjGetRelations( zz ).childs
    for i = 1, #childs do
      if childs[ i ]:find( "^obj_hint_" ) then
        --ld.LogTrace( "DeleteZzHintFx", zz, childs[ i ] )
        ObjDelete( childs[ i ] )
      end
    end
  end;
  --*********************************************************************************************************************
  function private.CreateInvHintPartSys( target_name, room )

    local obj_hint_name  = "obj_hint_"..target_name;
    local hint_name  = "pfx_hint_"..target_name;
    local timer_inv_name = "tmr_inv_"..target_name;

    interface.InventoryOpen();

    if ObjGet( hint_name ) then

      public.DeleteHintFx()

    end;
    if not( public.for_hint.target[1] == 0 ) then

      public.for_hint.target[1] = obj_hint_name;

    else

      public.for_hint.target[2] = obj_hint_name;

    end;

    interface.InventoryShowObject( target_name );

    ObjCreate( obj_hint_name, "obj" );

    ObjSet( obj_hint_name,
    {
      pos_x = 0, pos_y = 0, pos_z = 1000
    } );

    ObjAttach( obj_hint_name, target_name );

    ObjCreate( hint_name, "partsys" );

    ObjSet( hint_name,
    {
      res = public.for_hint.res_inv,
      pos_x = 0, pos_y = 0,
      scale_x = 1.6, scale_y = 1.6
    } );

    ObjAttach( hint_name, obj_hint_name );

    ObjCreate( timer_inv_name, "timer" );
    ObjAttach( timer_inv_name, InterfaceWidget_Top_Name );


    ObjAnimate( obj_hint_name, "alp",0 ,0 , "", { 0,0,1,  2.5,0,1,  2.8,0,0 }  );

    ObjSet( timer_inv_name,
    {
      endtrig = "common_impl.HintHideInventoryEnd( '"..target_name.."');common_impl.HintShowAnimEnd( '"..target_name.."','"..room.."');",
      time    = 2.8,
      playing = 1
    } );


    if public.for_hint.play_sfx==true then
      --PlaySfx( "assets/audio/aud_hint", 0, 0 );
    end;

  end;
  --*********************************************************************************************************************
  function public.HintShowAnm( target_name, deploy )
    private.HintShowAnim( target_name, deploy )
  end
  --*********************************************************************************************************************
  function private.HintShowAnim( target_name, deploy )

    local room = GetCurrentRoom();
    local sub_room = common.GetCurrentSubRoom();

    if deploy then

      room = "int_complex_inv_impl";

    elseif target_name == "obj_int_cube_button" then

      room = "obj_int_cube_button"
      target_name = "inv_casket"

    elseif ObjGet( room ).input == false and sub_room and ObjGet( sub_room ).input == true then
      
      if subroom.IsSubRoomOwned() then
        room =  sub_room--"subroom"
      else
        room = "int_frame_subroom_impl" --common.GetCurrentSubRoom();
      end
   
    end;

    --common.LogTrace( common.logtrace_message, "[ H ] Hint object < "..target_name.." >." );

    if ( not public.show_hint[ target_name ] ) then

      if ObjGet( target_name ) then

        if not private.HintShowAnim_sfx_now then
          --SoundSfx( "reserved/aud_hint_circle" )
          SoundSfx( "reserved/aud_hint" )
          private.HintShowAnim_sfx_now = true
          ld.StartTimer( 0, function() private.HintShowAnim_sfx_now = false end )
        end

        public.show_hint[ target_name ] = 1;

        if target_name == "obj_int_cube_button" or target_name == "obj_helper_cursor_drag" or string.match(target_name, "^inv_") then

          private.CreateInvHintPartSys( target_name, room );

        else

          private.CreateHintObj( target_name, room );

        end;

      end;

    else

      --common.LogTrace( ld.logtrace_message, "[ H ] No object < "..target_name.." >!" );

    end;

  end;
  --*********************************************************************************************************************
  function public.HintShowAnimEnd( target_name, room )

    local obj_hint_name  = "obj_hint_"..target_name;

    ObjDelete( obj_hint_name );

    public.show_hint[ target_name ] = nil;
    public.show_hint[ room ] = nil;

  end;
  --*********************************************************************************************************************
  function public.HintHideInventoryEnd( target_name )

    local inv_timer_name = "tmr_inv_"..target_name;

    ObjDelete( inv_timer_name );

    if string.find(target_name, "inv") and public.save_autohide == 1 and ng_global.progress[ ng_global.currentprogress ].common.buttonlock ~= 1 then

      --interface.InventoryAutoHideSet( 1 );
      public.save_autohide = 0;

    end;

    public.for_hint.play_sfx=true;

  end;
  --*********************************************************************************************************************
  function private.CheckHintType( hint, deploy)

    ld_impl.NoteHide();

    if hint.type == "use" then

      if hint.inv_obj ~= "obj_helper_cursor_drag" then
        -- показать инвентарь
        if interface.InventoryAutoHideGet() == 1 then

          public.save_autohide = 1;
          interface.InventoryAutoHideSet( 0 );

        else

          public.save_autohide = 0;

        end;
      end

      public.for_hint.play_sfx = false;
      private.HintShowAnim( hint.inv_obj );
      private.HintShowAnim( hint.use_place, deploy);

    elseif hint.type == "get" then
      -- показать на подбираемый предмет
      local obj = hint.get_obj:gsub( "^"..ld.StringDivide( hint.get_obj )[ 1 ], "gfx" )
      if ObjGet( obj ) then
        --центрирование по частичке хелпа
        private.HintShowAnim( obj, deploy );
      else
        private.HintShowAnim( hint.get_obj, deploy );
      end

    elseif hint.type == "click" then

      --показать на место клика

      private.HintShowAnim( hint.use_place, deploy);

    elseif hint.type == "win" then

    -- показать на место клика

      private.HintShowAnim( hint.use_place, deploy);

    end;

    interface.ButtonHintReload( 1 );
    int_button_hint_impl.StartAnimReloadBegin();



  end;
--*********************************************************************************************************************
function private.CheckRoomState( hint, currentroom )
  --ld_impl.NoteHide()
  if ObjGet(currentroom).input == false and hint.zz == common.GetCurrentSubRoom() then
    --DbgTrace("show_action_subroom");
    if interface.GetCurrentComplexInv() ~= "" then
      private.HintShowAnim("btn_int_complex_inv_impl_close",1)
    else
      if hint.customhint then
        hint.customhint()
        interface.ButtonHintReload( 1 );
        int_button_hint_impl.StartAnimReloadBegin();
      else
        private.CheckHintType( hint );
      end
    end
    --PlaySfx( "assets/audio/aud_hint", 0, 0 );

  elseif ObjGet(currentroom).input == false and hint.zz ~= common.GetCurrentSubRoom()  then

    if interface.GetCurrentComplexInv() ~= "" then
      private.HintShowAnim("btn_int_complex_inv_impl_close",1)
    else
      private.HintShowAnim( subroom.GetSubRoomExitButton() );
    end
    --PlaySfx( "assets/audio/aud_hint", 0, 0 );

  elseif hint.zz == "int_button_providence" and public.start_providence == false then
    if interface.GetCurrentComplexInv() ~= "" then
      private.HintShowAnim("btn_int_complex_inv_impl_close",1)
    else
      private.HintShowAnim(hint.zz_gate);
    end
  elseif hint.zz == "int_button_providence" and public.start_providence == true then

    private.CheckHintType( hint );
    --PlaySfx( "assets/audio/aud_hint", 0, 0 );

  else

    --DbgTrace("show_gate_subroom");
    if ( public.start_providence == true ) then

      private.HintShowAnim( "int_button_providence" );
      --PlaySfx( "assets/audio/aud_hint", 0, 0 );

    else
      if interface.GetCurrentComplexInv() ~= "" then
        --PlaySfx( "assets/audio/aud_hint", 0, 0 );
        private.HintShowAnim("btn_int_complex_inv_impl_close",1)
      else
        private.HintShowAnim(hint.zz_gate);
        --PlaySfx( "assets/audio/aud_hint", 0, 0 );
      end
    end;

  end;

end;
--*********************************************************************************************************************
function common.HintAdditionalFunc( room_current )

  if public.show_hint[ room_current ] then

    local hint_name  = "pfx_hint_"..public.show_hint[ room_current ];

    ObjDelete( hint_name );

    public.show_hint[ public.show_hint[ room_current ] ] = nil;
    public.show_hint[ room_current ] = nil;

  end;

  if interface.effects.ho_hint[room_current] then

    for key, value in pairs( interface.effects.ho_hint ) do

    local obj_hint_name  = "obj_int_effects_ho_hint_"..key;

    ObjDelete( obj_hint_name );
    interface.effects.ho_hint[ key ] = nil;
    interface.effects.ho_hint[room_current] = nil;

    end;

  end;

end;
--*********************************************************************************************************************
--***function *** DIALOG *** () end************************************************************************************
--*********************************************************************************************************************
  function public.DialogButtonMouseDown( dialog_name, dialog_button, param )

    --DbgTrace( "[ EXAMPLE ] Проигран звук клика для диалога < "..dialog_name.." > по кнопке < "..dialog_button.." >." );
    if (dialog_button == "credits") then
    else
      SoundSfx( "reserved/aud_click_menu" )
    end

  end;
  --------------------------------------------------------------------
  function public.DialogButtonMouseEnter( dialog_name, but_side )

    --PlaySfx( "assets/audio/aud_guidance", 0, "", 0.0 )

    SetCursor( CURSOR_HAND );
    local but_name = "spr_dialog_"..dialog_name.."_button_"..but_side.."_focus";
    local but_alp = ObjGet( but_name ).alp;
    ObjAnimate( but_name, "alp", 0, 0, "", { 0, 0, but_alp, ( public.animtime * ( 1 - but_alp ) ), 0, 1 } );

    local obj_txt = "txt_dialog_"..dialog_name.."_button_"..but_side;

    local txt_param = ObjGet(obj_txt)
    if txt_param then
      ObjAnimate( obj_txt, 12, 0, 0, "", {0,0,txt_param.color_r,txt_param.color_g,txt_param.color_b, ( common_impl.animtime * but_alp ) ,0,public.ButtonTextColorEnter()} );
    end


  end;
  --------------------------------------------------------------------
  function public.DialogButtonMouseLeave( dialog_name, but_side )

    SetCursor( CURSOR_DEFAULT );
    local but_name = "spr_dialog_"..dialog_name.."_button_"..but_side.."_focus";
    local but_alp = ObjGet( but_name ).alp;
    ObjAnimate( but_name, "alp", 0, 0, "", { 0, 0, but_alp, ( public.animtime * but_alp ), 0, 0 } );

    local obj_txt = "txt_dialog_"..dialog_name.."_button_"..but_side;
    local txt_param = ObjGet(obj_txt)
    if txt_param then
      ObjAnimate( obj_txt, 12, 0, 0, "", {0,0,txt_param.color_r,txt_param.color_g,txt_param.color_b, ( common_impl.animtime * but_alp ) ,0,public.ButtonTextColorLeave()} );
    end

  end;
  --------------------------------------------------------------------
  function public.DialogCheckMouseEnter( sender_name )

    SetCursor( CURSOR_HAND );

    local but_name = "spr_dialog_"..sender_name.."_check_focus";
    local but_alp = ObjGet( but_name ).alp;
    ObjAnimate( but_name, "alp", 0, 0, "", { 0, 0, but_alp, ( public.animtime * ( 1 - but_alp ) ), 0, 1 } );

  end;
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  function public.DialogCheckMouseLeave( sender_name )

    SetCursor( CURSOR_DEFAULT );
    local but_name = "spr_dialog_"..sender_name.."_check_focus";
    local but_alp = ObjGet( but_name ).alp;
    ObjAnimate( but_name, "alp", 0, 0, "", { 0, 0, but_alp, ( public.animtime * but_alp ), 0, 0 } );

  end;
  --------------------------------------------------------------------
  function public.DialogOptionsScrollMouseEnter( sender_name, scroll_name )

    SetCursor( CURSOR_HAND );
    local but_name = "spr_dialog_"..sender_name.."_"..scroll_name.."_scroll_slider_focus";
    local but_alp = ObjGet( but_name ).alp;
    ObjAnimate( but_name, "alp", 0, 0, "", { 0, 0, but_alp, ( public.animtime * ( 1 - but_alp ) ), 0, 1 } );

    --local txt_name = "txt_dialog_options_"..scroll_name.."_percent";
    --local txt_name2 = "txt_dialog_options_"..scroll_name.."_header";
    --local txt_name3 = "txt_dialog_options_"..scroll_name;
    --ObjSet( txt_name, { fontcolor_r = 1, fontcolor_g = 1, fontcolor_b = 1 } );
    --ObjSet( txt_name2, { fontcolor_r = 1, fontcolor_g = 1, fontcolor_b = 1 } );
    --ObjSet( txt_name3, { fontcolor_r = 1, fontcolor_g = 1, fontcolor_b = 1 } );

  end;
  --------------------------------------------------------------------

  function public.DialogOptionsScrollMouseLeave( sender_name, scroll_name )

    SetCursor( CURSOR_DEFAULT );
    local but_name = "spr_dialog_"..sender_name.."_"..scroll_name.."_scroll_slider_focus";
    local but_alp = ObjGet( but_name ).alp;
    ObjAnimate( but_name, "alp", 0, 0, "", { 0, 0, but_alp, ( public.animtime * but_alp ), 0, 0 } );


  --  local txt_name = "txt_dialog_options_"..scroll_name.."_percent";
  --  local txt_name2 = "txt_dialog_options_"..scroll_name.."_header";
  --  local txt_name3 = "txt_dialog_options_"..scroll_name;
  --  ObjSet( txt_name, { fontcolor_r = 0.678, fontcolor_g = 0.572, fontcolor_b = 0.729 } );
  --  ObjSet( txt_name2, { fontcolor_r = 0.678, fontcolor_g = 0.572, fontcolor_b = 0.729 } );
  --  ObjSet( txt_name3, { fontcolor_r = 0.678, fontcolor_g = 0.572, fontcolor_b = 0.729 } );
  --
  end;
  ----------------------------------------------------------------------------
  function public.DialogProfileMouseEnter(number)

    --local alp = ObjGet( name ).alp;
    local max_alp = 0.5

    SetCursor( CURSOR_HAND );
    local but_name = "spr_dialog_profile_names_"..number.."_focus";
    local but_alp = ObjGet( but_name ).alp;
    ObjAnimate( but_name, "alp", 0, 0, "", { 0, 0, but_alp, ( public.animtime * ( max_alp - but_alp ) ), 0, max_alp } );


  end;
  ---------------------------------------------------------------------------------
  ----------------------------------------------------------------------------
  function public.DialogProfileMouseLeave(number)
    SetCursor( CURSOR_DEFAULT );
    local but_name = "spr_dialog_profile_names_"..number.."_focus";
    local but_alp = ObjGet( but_name ).alp;
    ObjAnimate( but_name, "alp", 0, 0, "", { 0, 0, but_alp, ( public.animtime * but_alp ), 0, 0 } );



  end;
---------------------------------------------------------------------------------
--*********************************************************************************************************************
--***function *** DIALOG CHARACTER *** () end**************************************************************************
--*********************************************************************************************************************
    function public.ChoiceClk( number_choice )
    --ld.LogTrace( "ChoiceClk"..number_choice );
    public.StopAllVoc();

    local name = tostring( private.object_current );
    local current_room = common.GetObjectName( GetCurrentRoom() );

    if public.frases[ number_choice ] then

      public.answer_text = "str_"..current_room.."_"..name.."_answer_"..public.frases[ number_choice ];

    end;

  --  if name == "mother_1" and current_room == "square" and public.frases[ number_choice ] == 2 then
  --
  --    public.continue_answer_count = private.dialog_count_txt + 2;
  --    public.continue_answer = true;
  --
  --  end;

    local func_after = function()

      public.LockRm(0);

      for i = 1, #public.frases do

       ObjSet( "spr_int_dialog_character_choise_"..i, { alp = 0, input = false } );

      end;

      ObjSet( "grd_int_dialog_character_choise", { input = false } );
      ObjSet( "obj_int_dialog_character_input", { event_mdown = function() int_dialog_character.ContinueClick( false ) end; } );

      table.remove( public.frases, number_choice );

      if #public.frases == 0 then public.continue_visible = true; 
      else public.continue_visible = false; 
      end;
      if common_impl.continue_visible then ObjSet( "txt_int_dialog_character_continue", { text = 'str_int_dialog_character_continue' } ); 
      else ObjSet( "txt_int_dialog_character_continue", { text = 'str_int_dialog_character_choise_question' } ); 
      end;
      --ld.LogTrace( "int_dialog_character.ContinueClick" );
      int_dialog_character.ContinueClick( true );

    end;

    public.LockRm(1);

     ObjAnimate( "grd_int_dialog_character_choise", "pos_x", 0, 0, func_after,
    {
      0, 3, 0 + private.choise_offset_widescreen(),
      1, 3, private.choise_hide_y_pos() + private.choise_offset_widescreen()
    } );

  end;
  --******************************************************************************************
  function public.SwitchDialogFrase( )

    local current_room = GetCurrentRoom();
    local count_txt = private.dialog_count_txt;
    local dlg_name = private.object_current;

    _G[current_room].SwitchFrase( dlg_name, count_txt );

  end;
  --******************************************************************************************
  function public.ShowDialogQuestions( number_choice )


    name_object = tostring( private.object_current );
    number_choice = tonumber( number_choice );
    local current_room = common.GetObjectName( GetCurrentRoom() );

    local text_height = 0;

    ObjSet( "obj_int_dialog_character_input", { event_mdown = "" } );

    if #public.frases == 0 then public.continue_visible = true; 
    else public.continue_visible = false; 
    end;
    if common_impl.continue_visible then ObjSet( "txt_int_dialog_character_continue", { text = 'str_int_dialog_character_continue' } ); 
    else ObjSet( "txt_int_dialog_character_continue", { text = 'str_int_dialog_character_choise_question' } ); 
    end;

    local endtrig = "";

    for i = 1, number_choice do
      local font_size = 22
      ObjSet( "txt_int_dialog_character_choise_"..i, { fontsize = font_size } );

      ObjSet( "txt_int_dialog_character_choise_"..i, { text = "str_"..current_room.."_"..name_object.."_question_"..public.frases[i] } );

      local h_max = 48
      local h1 = font_size * 2 + 10
      local h2 = font_size * 4 + 10

      local o = ObjGet( "txt_int_dialog_character_choise_"..i )
      if o.draw_height > h2 then
        ObjSet( o.name , { fontsize = 15 } )
        o = ObjGet( "txt_int_dialog_character_choise_"..i )
      elseif o.draw_height > h1 then
        ObjSet( o.name , { fontsize = 20 } )
        o = ObjGet( "txt_int_dialog_character_choise_"..i )
      else
        ObjSet( o.name , { fontsize = 22 } )
      end;

      endtrig = function() public.ChoiceClk( i ) end;

      ObjSet( "spr_int_dialog_character_choise_"..i, { event_mdown = endtrig, alp = 1, input = true } );

      text_height = text_height + ObjGet( "txt_int_dialog_character_choise_"..i ).draw_height;

    end;

    local dialog_w = 550;
    local dialog_h = text_height + 150;
    local grid_corner_w = int_dialog_character_impl.GRID_CORNER_W;
    local grid_corner_h = int_dialog_character_impl.GRID_CORNER_H;
    local grid_mid_w = int_dialog_character_impl.GRID_MID_W;
    local grid_mid_h = int_dialog_character_impl.GRID_MID_H;

    interface.FrameGridSet( "int_dialog_character_choise",
    {
      grid_w   = dialog_w,
      grid_h   = dialog_h,
      corner_w = grid_corner_w,
      corner_h = grid_corner_h,
      mid_w    = grid_mid_w,
      mid_h    = grid_mid_h
    } );

    if number_choice == 3 then

      ObjSet( "spr_int_dialog_character_choise_1", { pos_y = -96 } );
      ObjSet( "spr_int_dialog_character_choise_2", { pos_y = 0 } );
      ObjSet( "spr_int_dialog_character_choise_3", { pos_y = 96 } );

    elseif number_choice == 2 then

      ObjSet( "spr_int_dialog_character_choise_1", { pos_y = -48 } );
      ObjSet( "spr_int_dialog_character_choise_2", { pos_y = 48 } );

    else

      ObjSet( "spr_int_dialog_character_choise_1", { pos_y = 0 } );

    end;

    public.LockRm(1);

    local func_after = function()

      public.LockRm(0);

      ObjSet( "grd_int_dialog_character_choise", { input = true } );

    end;

    ObjSet( "grd_int_dialog_character_choise", { input = false } );

    ObjAnimate( "grd_int_dialog_character_choise", "pos_x", 0, 0, func_after,
    {
      0, 3, private.choise_hide_y_pos() + private.choise_offset_widescreen(),
      1, 3, private.choise_hide_y_pos() + private.choise_offset_widescreen(),
      2, 3, 0 + private.choise_offset_widescreen()
    } );


  end;
  --******************************************************************************************
  function public.ChangeCharactersCheck( object_name, current_room )

    if object_name == "mother_1" and current_room == "square" and private.dialog_count_txt == 7 then
       public.ChangeCharacters( object_name, "mother", "sheriff" );
    elseif object_name == "mother_1" and current_room == "square" and private.dialog_count_txt == 8 then
       public.ChangeCharacters( object_name, "sheriff", "mother" );
    end;

  end;
  --******************************************************************************************
  function public.ChangeCharacters( object_name, current_character, new_character )

      local current_room = common.GetObjectName( GetCurrentRoom() );

      if current_character then

        ObjAnimate( "obj_"..current_room.."_"..object_name.."_"..current_character, "scale_xy", 0, 0, "", { 0,0,1.05,1.05, 0.3,0,1,1 } );
        ObjSet( "obj_"..current_room.."_"..object_name.."_"..current_character, { pos_z = 1 } );

      end;

      local relations = ObjGetRelations( "obj_"..current_room.."_"..object_name.."_characters" );

      for i = 1, #relations.childs do

        ObjSet( relations.childs[i], { color_r = 0.4,color_g = 0.4, color_b = 0.4 } );

      end;

      ObjSet( "obj_"..current_room.."_"..object_name.."_"..new_character, { pos_z = 10, color_r = 1, color_g = 1, color_b = 1 } );
      ObjAnimate( "obj_"..current_room.."_"..object_name.."_"..new_character, "scale_xy", 0, 0, "", { 0,0,1,1, 0.3,0,1.05,1.05 } );

  end;
  --******************************************************************************************
  --передается название липсинга
  function public.Start( object_name, max_number, click_func, skip_func, func_after_frase, end_trigger, voc_list, voc_rules, dlg_root_anim, interface_visible_rool )
    --ld.LogTrace( "public.Show "..1 );
    --ld.LogTrace( object_name, max_number, click_func, skip_func, func_after_frase, end_trigger, voc_list, voc_rules, dlg_root_anim, interface_visible_rool )
    private.DialogCharacterInterfaceVisibleRoot = interface_visible_rool
    private.DialogCharacterDlgRootAnim = dlg_root_anim
    if private.DialogCharacterDlgRootAnim == nil then
      private.DialogCharacterDlgRootAnim = true
    end
    --ld.LogTrace( "private.DialogCharacterDlgRootAnim", private.DialogCharacterDlgRootAnim )
    int_blackbartext.Hide()
    if ng_global.currentprogress ~= "scr" then
      interface.DialogTaskHide ("force")
    end

    if private.DialogCharacterInterfaceVisibleRoot then
      ld.SetWidgetsVisible( private.DialogCharacterInterfaceVisibleRoot, false )
    else
      public.InterfaceSetVisible( false );
    end

    --public.StopAllMus();
    --SoundTheme( 0 )
    private.VolumeFadingOn()

    local current_room = common.GetObjectName( GetCurrentRoom() );

    -->> auto voice generating -->>
    if not voc_list or #voc_list == 0 then
      local anm = "anm_"..current_room.."_"..object_name
      local anm_o = ObjGet( anm )
      voc_list = {}
      for i = 1, max_number - 1 do
        voc_list[ i ] = "aud_"..current_room.."_"..object_name.."_"..i.."_voc";
        -->> auto lipsink generating -->>
        local vid = voc_list[ i ]:gsub( "^aud", "vid" )
        local vid_name = "vid_"..current_room.."_"..vid
        local o = ObjGet( vid_name )
        if not o and anm_o then
          local res = anm_o.res
          local index = res:match( '^.*()/' )
          res = res:sub( 1, index )
          res = res..vid
          if ne.file.IsExist( res..".ogg" ) then
            ObjCreate( vid_name, "video" )
            ObjSet( vid_name, { res = res } )
          end
        end
        --<< auto lipsink generating --<<
      end
    end
    --<< auto voice generating --<<

    private.DialogCharacterVoice = voc_list or {}

    public.LockRm(1);


    local trg_after = function()

      public.LockRm(0);

    end;

    private.DialogCharacterVoice = voc_list or {}
      -->> для диалогов с более 1 персонажа >>
      private.DialogCharacterVoiceRules = voc_rules or {}
      local rules = {}
      for i = 1,#private.DialogCharacterVoiceRules do
        if not rules[ private.DialogCharacterVoiceRules[i] ] then
          rules[ private.DialogCharacterVoiceRules[i] ] = true;
        end;
      end;
      for k,v in pairs(rules) do
        local o = ObjGet( "spr_"..current_room.."_"..object_name.."_voc_"..k )
        if o then
          ObjAttach( o.name, "dlg_"..current_room.."_"..object_name.."_lipsing_root_"..k )
        end
      end
      --<< для диалогов с более 1 персонажа <<

    public.continue_visible = false; 
    
    if private.DialogCharacterDlgRootAnim then
      local dlg_root = "dlg_"..current_room.."_"..object_name
      ObjAttach(dlg_root, GetCurrentRoom())
      ObjAnimate(dlg_root, "alp", 0, 0, trg_after, { 0,0,0, 0.3,0,1 } );
    else
      ld.StartTimer( 0.3, trg_after )
    end

    if public.dialog_character_loc then

     ObjAnimate( public.dialog_character_loc, "alp", 0, 0, "", { 0,0,1, 0.3,0,0 } );

    end;


  --   if object_name == "mother_1" and current_room == "square" then
  --
  --    public.continue_visible = true;
  --    public.ChangeCharacters( object_name, false, "mother" );
  --
  --   end;

    ObjSet( "obj_int_dialog_character_input", { input = true, event_mdown = function() int_dialog_character.ContinueClick( false ) end; } );

    ObjStopAnimate( "grd_int_dialog_character_choise", "pos_x" );

    ObjSet( "grd_int_dialog_character_choise", { pos_x = private.choise_hide_y_pos() + private.choise_offset_widescreen() } );

    interface.DialogCharacterShow( object_name, max_number, click_func, skip_func, func_after_frase, false, end_trigger );
  --ld.LogTrace( "public.Show "..10 );
  end;
  --******************************************************************************************
  function public.Show( object_name, max_number, click_func, skip_func, func_after_frase, answer, end_trigger )

    --public.StopAllVoc();
    private.DialogCharacterVoice = private.DialogCharacterVoice or {}
    if not func_after_frase then
      func_after_frase = false;
    end;

    if not end_trigger then
      end_trigger = false;
    end;

    public.func_after_frase = func_after_frase;
    public.end_trigger = end_trigger;
    public.max_number = max_number;
    private.object_current = object_name;

    if not private.dialog_count_txt then
      private.dialog_count_txt = 0;
    end;

    local current_room = common.GetObjectName( GetCurrentRoom() );

    private.dialog_count_txt = private.dialog_count_txt + 1;
  --
  --  --if ObjGet( "obj_int_lock_room" ).input then
  --    ld.LogTrace( "CATCH >>> common_impl.Show obj_int_lock_room >> "..tostring( ObjGet( "obj_int_lock_room" ).input ).." > "..private.dialog_count_txt )
  --    --return;
  ----  else
  ----
  ----  end;

    public.ChangeCharactersCheck( private.object_current, current_room );


    if private.DialogCharacterInterfaceVisibleRoot then
      object_name = ld.StringDivide( object_name )[ 1 ]
    end


    if not answer and public.continue_answer ~= true then
      public.answer_text = "str_"..current_room.."_"..private.object_current.."_"..private.dialog_count_txt;
    end;

    if public.continue_answer == true and public.continue_answer_count == private.dialog_count_txt then
      public.answer_text = "str_"..current_room.."_"..private.object_current.."_answer_2_2";
      public.continue_answer = false;
      public.continue_visible = false;

    elseif public.continue_answer == true then
      public.continue_visible = true;
    end;
    public.continue_visible = true;

    --local voc_name = string.sub( public.answer_text, 5, string.len( public.answer_text )  );
    --voc_name = common.GetObjectName( voc_name );
  -- ЗВУК -- SOUND  -- ЗВУК -- SOUND  -- ЗВУК -- SOUND  -- ЗВУК -- SOUND  -- ЗВУК -- SOUND  -- ЗВУК -- SOUND  -- ЗВУК -- SOUND  -- ЗВУК -- SOUND
    --common_impl.PlayAudio( "voc", "common/audio/aud_"..voc_name.."_voc", 0, "", 0 );
    
    --LipSink + Voice
    local GetLipSinkRoot = function( n ) 
      if private.DialogCharacterVoiceRules[ n ] then
        return "dlg_"..current_room.."_"..object_name.."_lipsing_root_"..private.DialogCharacterVoiceRules[ n ]
      else
        return "dlg_"..current_room.."_"..object_name.."_lipsing_root"
        --if private.DialogCharacterInterfaceVisibleRoot then
        --  local object_name_short = ld.StringDivide( object_name )[ 1 ]
        --  return "dlg_"..current_room.."_"..object_name_short.."_lipsing_root"
        --else
        --  return "dlg_"..current_room.."_"..object_name.."_lipsing_root"  
        --end;
      
      end
      
    end
    if  private.DialogCharacterVoice[ private.dialog_count_txt - 1 ] 
    and private.DialogCharacterVoice[ private.dialog_count_txt ] 
    and private.DialogCharacterVoice[ private.dialog_count_txt - 1 ] == private.DialogCharacterVoice[ private.dialog_count_txt ] 
    then
      --совпадающий войс, персанаж просто договаривает
    else
      if private.DialogCharacterVoice[ private.dialog_count_txt - 1 ] and private.DialogCharacterVoice[ private.dialog_count_txt - 1 ]:len() > 0 then
        local name_vid = "vid_"..current_room.."_"..private.DialogCharacterVoice[ private.dialog_count_txt - 1 ]:gsub("^aud_","vid_")
        --ld.LogTrace( name_vid );
        local o = ObjGet( name_vid )
        
        if o then
          SoundVoice( 0 )
          ObjAnimate( o.name, 8,0,0, function() ObjDetach( o.name ) end, { 0,0,o.alp, 0.3,1,private.dialog_count_txt >= max_number and 1 or 0 } )
          if private.DialogCharacterVoiceRules[private.dialog_count_txt - 1] then
            local o = ObjGet( "spr_"..current_room.."_"..object_name.."_voc_"..private.DialogCharacterVoiceRules[private.dialog_count_txt - 1] )
            if o then
              if ObjGet( GetLipSinkRoot( private.dialog_count_txt - 1 ) ) then
                ObjAttach( o.name, GetLipSinkRoot( private.dialog_count_txt - 1 ) )
              else
                ObjAttach( o.name, "dlg_"..current_room.."_"..object_name )
              end
              --ObjAnimate( o.name, 8,0,0, _, { 0,0,o.alp, 0.3,2,private.dialog_count_txt >= max_number and 1 or 0 } )
              ObjAnimate( o.name, 8,0,0, _, { 0,0,o.alp, 0.275,2,1 } )
            end
          else
            if private.dialog_count_txt < max_number then
              ObjDetach( o.name )
            end
          end;
        end;
      end;
      if private.DialogCharacterVoice[ private.dialog_count_txt ] and private.DialogCharacterVoice[ private.dialog_count_txt ]:len() > 0 then
        local name_vid = "vid_"..current_room.."_"..private.DialogCharacterVoice[ private.dialog_count_txt ]:gsub("^aud_","vid_") 
        
        local o = ObjGet( name_vid )

        if not o then
          -->> TODO >> Auto create lipsing
        end

        if o then
          --ld.LogTrace( name_vid );
        -- ld.LogTrace( GetLipSinkRoot( private.dialog_count_txt) );
          if ObjGet( GetLipSinkRoot( private.dialog_count_txt ) ) then
            ObjAttach( o.name, GetLipSinkRoot( private.dialog_count_txt ) )
            
          else
           -- ld.LogTrace( "dlg_"..current_room.."_"..object_name );
            ObjAttach( o.name, "dlg_"..current_room.."_"..object_name )
          end
          if private.dialog_count_txt == 1 then
            ObjSet( o.name, { alp = 1 } )
            ObjSet( "spr_"..current_room.."_"..object_name.."_lipsing", { alp = 0 } )
          else
            if  private.DialogCharacterVoiceRules[private.dialog_count_txt - 1]
            and private.DialogCharacterVoiceRules[private.dialog_count_txt - 1]
            ~=  private.DialogCharacterVoiceRules[private.dialog_count_txt]
            then
              ObjSet( o.name, { alp = 0 } )
              o.alp = 0;
            end
            ObjAnimate( o.name, 8,0,0, function()
              --ld.Anim.Light( "spr_"..current_room.."_"..object_name.."_lipsing", false )
            end, { 0,0,o.alp, 0.275,2,1 } )
          end

          ObjAnimate( o.name, 7,0,0, function() VidPlay( o.name, _ ); SoundVoice( private.DialogCharacterVoice[ private.dialog_count_txt ] ) end, { 0,0,0, 0,0,0 } )
          if private.DialogCharacterVoiceRules[private.dialog_count_txt] then
           
            local o = ObjGet( "spr_"..current_room.."_"..object_name.."_voc_"..private.DialogCharacterVoiceRules[private.dialog_count_txt] )
            if o then
              --ld.LogTrace( o.name );
              ObjAnimate( o.name, 8,0,0, function() ObjDetach( o.name ) end, { 0,0,o.alp, 0.3,1,0 } )
            end
          end;
        else
          --убираем рут липсинка при отсутствии видоса липсинка, чтобы не отрезало бошки
          if ObjGet( GetLipSinkRoot( private.dialog_count_txt ) ) then
            ld.LogTrace( "WARNING: Missing Lipsink >> dlg_"..current_room.."_"..object_name.." >> ".."vid_"..current_room.."_"..private.DialogCharacterVoice[ private.dialog_count_txt ]:gsub("^aud_","vid_") )
            ObjSet( GetLipSinkRoot( private.dialog_count_txt ), { animtag = "" } )
            ObjAttach( GetLipSinkRoot( private.dialog_count_txt ), "dlg_"..current_room.."_"..object_name )
          end
          SoundVoice( private.DialogCharacterVoice[ private.dialog_count_txt ] )
        end;
      elseif #private.DialogCharacterVoice == 0 then
        --убираем рут липсинка при отсутствии войсов, чтобы не отрезало бошки
        if ObjGet( GetLipSinkRoot( private.dialog_count_txt ) ) then
          ObjSet( GetLipSinkRoot( private.dialog_count_txt ), { animtag = "" } )
          ObjAttach( GetLipSinkRoot( private.dialog_count_txt ), "dlg_"..current_room.."_"..object_name )
        end
      end;
    end

    if private.dialog_count_txt >= max_number then
    else
      int_dialog_character.Show( private.object_current, click_func, skip_func );
    end

    --ld.LogTrace( "try SwitchPhrase:"..tostring( func_after_frase ) );
    if func_after_frase then
      public.SwitchDialogFrase();
    end;

    if private.dialog_count_txt >= max_number then
      public.DialogCharacterHide();
    end;

  end;
  --******************************************************************************************
  function public.DialogCharacterHide()

    --public.StopAllVoc();
    SoundVoice( 0 )
    private.VolumeFadingOff()
    ld_impl.SoundBackTheme( true );

    local current_room = common.GetObjectName( GetCurrentRoom() );

    local room = GetCurrentRoom();

    if public.end_trigger and room and _G[ room ][public.end_trigger] then

      _G[ room ][public.end_trigger]();

    end;

    interface.DialogCharacterHide();

    ObjSet( "obj_int_dialog_character_input", { input = false } );

    public.LockRm(1);

    local dlg_root = "dlg_"..current_room.."_"..private.object_current

      local func_event_done = function()
        --ld.LogTrace( "func_event_done" )
        --cmn.SetEventDone( "dlg_"..current_room.."_"..private.object_current );
        --cmn.CallEventHandler( "dlg_"..current_room.."_"..private.object_current );
        if private.DialogCharacterDlgRootAnim then
          ObjDetach(dlg_root)
        end

        public.LockRm(0);

        public.func_after_frase = false;
        public.max_number = nil;
        private.dialog_count_txt = nil;
        public.answer_text = nil;
        
        for i,o in pairs(ObjGetRelations( "pnt_int_dialog_character_choise_mid" ).childs) do
          ObjSet( o, { alp = 0, input = false } );
        end

        if private.DialogCharacterInterfaceVisibleRoot then
          ObjSet( "spr_"..current_room.."_"..( ld.StringDivide( private.object_current )[ 1 ] ).."_lipsing", { alp = 1 } )
        end
        for i = 1, #private.DialogCharacterVoice do
          local o = ObjGet( "vid_"..current_room.."_"..private.DialogCharacterVoice[ i ]:gsub("^aud_","vid_") )
          if o then
            if private.DialogCharacterInterfaceVisibleRoot then
              ld.Anim.Light( o.name, false, function() ObjDetach( o.name ) end )
            else
              ObjDetach( o.name ) 
            end
          end;
        end;


        private.DialogCharacterVoice = {};

      end;
      
      if private.DialogCharacterDlgRootAnim then
        --ObjSet( dlg_root, { bake = 1 } )
        ObjAnimate( dlg_root, "alp", 0, 0, func_event_done, { 0,0,1, 0.3,0,0 } );
      else
        if private.DialogCharacterInterfaceVisibleRoot then
          local obj = "spr_"..current_room.."_"..( ld.StringDivide( private.object_current )[ 1 ] ).."_lipsing"
          if ObjGet(obj) then
            ld.Anim.Light( obj , true, 1, 0.3 )
          end
        end
        ld.StartTimer( 0.3, func_event_done )
      end

      if public.dialog_character_loc then
        ObjAnimate( public.dialog_character_loc, "alp", 0, 0, "", { 0,0,0, 0.3,0,1 } );
        public.dialog_character_loc = false;
      end;

      if private.DialogCharacterInterfaceVisibleRoot then
        ld.SetWidgetsVisible( private.DialogCharacterInterfaceVisibleRoot, true )
      else
        public.InterfaceSetVisible( true );
      end


  end;
  --******************************************************************************************
  function public.ContinueClick( answer )

    public.Show( private.object_current, public.max_number, nil, nil, public.func_after_frase, answer, public.end_trigger );

  end;
  --******************************************************************************************
  function public.SkipClick()

   public.DialogCharacterHide();

  end;

--*********************************************************************************************************************
--***function *** PROFILE *** () end***********************************************************************************
--*********************************************************************************************************************
function public.ProgressReset( prg, save )
  local counters = { }
  if ( ng_global.achievements ) then

    counters = {
        "ho_without_hint",   --без хинта хо
        "mg_without_skip",   --без скипа мг
        "ho_less_3min"   --подряд хо меньше чем 3 мин
    }

    ng_global.achievements.data = { std = {}, ext = {}, scr = {} };
    ng_global.achievements.done = {}
  end
  --ng_global.currentprogress = prg
 -- DbgTrace("ProgressReset "..prg)
  if ( prg == "std" ) then

--ld.LogTrace( counters );
    for _,i in pairs(counters) do
      --ld.LogTrace( o );
      ng_global.achievements.data[i] = {}
      ng_global.achievements.data[i].counter = ng_global.achievements["counter_ext"][ i ]
      ng_global.achievements["counter_std"][ i ] = 0
      ng_global.achievements["counter_std"][ i.."_rooms" ] = {}
    end

    ng_global.progress[ prg ].common.chapter = "level";

  elseif( prg == "ext" ) then
--ld.LogTrace( counters );
    for _,i in pairs(counters) do
      --ld.LogTrace( o );
      ng_global.achievements.data[i] = {}
      ng_global.achievements.data[i].counter = ng_global.achievements["counter_std"][ i ]
      ng_global.achievements["counter_ext"][ i ] = 0
      ng_global.achievements["counter_ext"][ i.."_rooms" ] = {}
    end

    ng_global.progress[ prg ].common.chapter = "levelext";

  elseif( prg == "scr" ) then

    ng_global.progress[ prg ].common.chapter = "levelscr";

  elseif( prg == "sgm" ) then

      ng_global.progress[ prg ].common.chapter = "levelsgm"; 
 
  elseif( prg == "exp" ) then   --!EXP

    ng_global.progress[ prg ].common.chapter = "levelexp"; 
      
  end;

  if ng_global.minibackpostfix then
    ng_global.minibackpostfix[ prg ] = {}
  end
  ng_global.investigation = 1;
  ng_global["task_current_"..prg] = nil
  ng_global.memory_order = nil
end;
--*********************************************************************************************************************
function public.ProfileInit()

  ng_global.bonusunlock = false;
  ng_global.extraunlock = false; 


  ng_global.achievements = 
  { 
    counter = 
    {
      ho_without_hint = 0,   --без хинта хо
      mg_without_skip = 0,   --без скипа мг
      ho_less_3min    = 0,   --подряд хо меньше чем 3 мин
      
    },
    counter_std = 
    {
      ho_without_hint = 0,   --без хинта хо
      mg_without_skip = 0,   --без скипа мг
      ho_less_3min    = 0,   --подряд хо меньше чем 3 мин
      ho_without_hint_rooms = {},
      mg_without_skip_rooms = {},
      ho_less_3min_rooms = {}      
    },
    counter_ext = 
    {
      ho_without_hint = 0,   --без хинта хо
      mg_without_skip = 0,   --без скипа мг
      ho_less_3min    = 0,   --подряд хо меньше чем 3 мин
      ho_without_hint_rooms = {},
      mg_without_skip_rooms = {},
      ho_less_3min_rooms = {}      
    },
    flag = 
    { 
      --ho_less_3min_3      = false,
      --ho_less_3min_5      = false,
      --ho_less_3min_7      = false,
      --ho_without_hint_3   = false,
      --ho_without_hint_5   = false,
      --ho_without_hint_7   = false,
      ho_complete_task_3  = false,
      ho_complete_task_5  = false,
      ho_complete_task_10 = false,


      ho_less_1min        = false,
      ho_more_10min       = false,
      mg_less_1min        = false,
      ho_without_hint_all = false,
      mg_without_skip_all = false,

      --morph_all           = false,
      coll_all           = false,
      puzz_all           = false,
      
      --sgm_wingame        = false,
      scr_complete_simple = false,
      scr_complete_less6 = false,
      scr_complete_less12 = false,
      scr_complete_nohint = false,
      --achiev_moonwalk     = false,--
      --achiev_fixdevice    = false,--
      --achiev_coffee       = false,--
      --achiev_duel         = false,--
      --achiev_returnstar   = false,--
      --achiev_fatherfrost  = false,--
      --achiev_months       = false,--

    },
    data = {},
    miniature = {false,false,false,false,false,
                 false,false,false,false,false,

                 false,false
                 },--12

    morphtrash = {false,false,false,false,false,
                  false,false,false,false,false,

                  false,false,false,false,false,
                  false,false,false,false,false,

                  false,false,false,false,false,
                  false
                 }--26
    
  };
  ng_global.achievements.done = {}
ng_global.achievements.puzzle= {

false,false,false,false,false,false,false,false,false,false,false,false,
true,true,true,true,true,true,true,true,true,true,true,true

                                }

ng_global.achievements.puzzle_done= {

false,false,false,false,false,false,false,false,false,false,false,false,
true,true,true,true,true,true,true,true,true,true,true,true

                                }


    ng_global.achievements.puzzle_screen = {false, true}
    ng_global.achievements.done_puzzle_screen = {false, true}



    ng_global.achievements.show_miniature=  {--[[false,false,false,false,false,false,
                                             false,false,false,false,false,false,false,false]]}
end;
--*********************************************************************************************************************
--***function *** ROOM - SUBROOM *** () end****************************************************************************
--*********************************************************************************************************************
function public.GotoRoom( room_object, need_fade, dontsave )

    public.DeleteHintFx()

    local prg = ng_global.currentprogress;
    local prefix_obj = common.GetObjectPrefix( room_object );

    if prefix_obj == "rm" and (room_object ~= "rm_menu" and room_object ~= "rm_intro") and (not cmn.is_inmenunow) then
      ng_global.progress[ prg ].common.currentmaproom = room_object
      --int_map_impl.VisitMapRoom ( ld.StringDivide(room_object)[2]  )
    end

    if room_object == "rm_credits" then
      rm_credits.SaveGameWinState()
    end

end;
--------------------------------------------------------------------
function public.GotoSubRoom( zz_object, pos_beg, pos_end )

    local room_current = GetCurrentRoom();

    public.DeleteHintFx()
    ObjDelete( "obj_hint_obj_int_frame_subroom_button" );

    if ( "zz" == common.GetObjectPrefix( room_current ) ) then

      common.previouszz = room_current;

    end;

    common.currentzz = zz_object;

    interface.CheaterUpdateSubroom( zz_object );

    local zz_params = ObjGet( zz_object );


    pos_beg = pos_beg or GetGameCursorPos();

    --pos_end={512,350}
    pos_end = pos_end or {512,350}--pos_end or { zz_params.pos_x, zz_params.pos_y };

    subroom.Open( zz_object, { x = pos_beg[ 1 ], y = pos_beg[ 2 ] }, { x = pos_end[ 1 ], y = pos_end[ 2 ] } );

end;
--*********************************************************************************************************************
--***function *** SETTINGS *** () end**********************************************************************************
--*********************************************************************************************************************
function public.UpdateGameMode( gamemode )
  --local current_room = GetCurrentRoom();
  --if ( current_room == "" or current_room == nil ) then
  --  current_room = ng_global.progress[ ng_global.currentprogress ].common.currentroom or "rm_pier";
  --end;
  --
  --if ( common.GetObjectPrefix( current_room ) == "rm" ) then
  --  cmn.CallEventHandler( "update_game_mode_"..common.GetObjectName( current_room ) );
  --end;
  ------------------------------------------------------------------------------------
  local visible = true;

  if (ng_global.gamemode == 2) or ( ( ng_global.gamemode == 3 ) and ( not ng_global.gamemode_custom[ "plus_inv" ] ) ) then
    visible = false;
  end;
  --local current_prg = (ng_global.currentprogress == "std" and "") or ng_global.currentprogress
  local current_prg = ""

  local parent = "obj_inventory"..current_prg.."_complex_hub";
  if ( not ObjGet( parent ) ) then
    return;
  end;
  local relations = ObjGetRelations( parent );
  local table_multiset = {};

  for i = 1, #relations.childs do

    local obj = "spr_"..common.GetObjectName( common.GetObjectName( relations.childs[ i ] ) ).."_plus";

    table.insert( table_multiset, { obj, { visible = visible } } );
    table.insert( table_multiset, { obj,   private.plus_param  } );
    --table.insert( table_multiset, { obj.."_light", { visible = visible } } );

  end;

  if #table_multiset ~= 0 then
    ObjMultiSet( table_multiset );
  end

  parent_inv = "obj_int_inventory";
  if ( not ObjGet( parent_inv ) ) then
    return;
  end;
  relations_inv = ObjGetRelations( parent_inv );
  local table_multiset_inv = {};

  for i = 1, #relations_inv.childs do
    local obj = "spr_"..common.GetObjectName(common.GetObjectName( common.GetObjectName( relations_inv.childs[ i ] ) )).."_plus";

    table.insert( table_multiset_inv, { obj, { visible = visible } } );
    table.insert( table_multiset_inv, { obj,   private.plus_param  } );
    --table.insert( table_multiset_inv, { obj.."_light", { visible = visible } } );

  end;

  if #table_multiset_inv ~= 0 then
    ObjMultiSet( table_multiset_inv );  
  end


end;
--------------------------------------------------------------------
function public.SaveInterfaceTimers()
  --horrible past
  --if prg.current == "scr" then
  --  if int_panelscr then
  --    ng_global.progress[ "scr" ].common.time = int_panelscr.GetTime()  
  --  end
  --  local prg_type = ng_global.currentprogress;
  --  local current_progress = ng_global.progress[ prg_type ];
  --  current_progress.common.hinttimer = interface.ButtonHintGetTime();
  --end
  --great future
  if prg.current == "sgm" then
    ng_global.progress[ "sgm" ].common.time = int_panelsgm.GetTime()  
  end
end;
--*********************************************************************************************************************
--***function *** MINIGAME *** () end**********************************************************************************
--*********************************************************************************************************************
  function public.MiniGameShow( minigame_name, skip_multiplier )
    public.mg_showed = true
    if not common.GetCurrentSubRoom() and ( common.GetObjectPrefix(GetCurrentRoom()) == "mg" ) and ng_global.currentprogress ~= "scr" then
      interface_impl.StartMgAchievements(minigame_name)
    end
    if ( skip_multiplier ) then

      if ( common.GetGameMode() == 0 ) then

        skip_multiplier = 3.333333;

      elseif ( common.GetGameMode() > 0 ) then

        skip_multiplier = 3.5;

      end;

    end;
    cmn.current_mg = minigame_name
    minigame_name = minigame_name or common.GetObjectName( GetCurrentRoom() );

    interface.WidgetSetInput( InterfaceWidget_Inventory, false );
    interface.WidgetSetVisible( InterfaceWidget_Inventory, false, true );  

    -->>автохайд инвенторя в МГ, чтобы нельзя было открыть деплой с мг, когда активна МГ
    --if GetCurrentRoom():find("^mg_") and int_complex_inv.GetCurrentName() == "" then
      -->>уменьшаем переход назад в активной мг
      local hint_rm = ld_impl.smart_hint_connections[ "mg_"..minigame_name ] or common_impl.hint[ "win_"..minigame_name ].room
      
      if hint_rm then
        local gate = ObjGet( "grm_"..minigame_name.."_"..common.GetObjectName( hint_rm ) )
        if gate then
          private.MiniGameShow_gate_half = {
            name = gate.name;
            inputrect_y = gate.inputrect_y;
            hint_rm = hint_rm;
          }
          ObjSet( gate.name, { 
            inputrect_y = gate.inputrect_y + gate.inputrect_h / 2;
          } )
        end
      end;
      
      --<<уменьшаем переход назад в активной мг
      
    --end;  
    --<<  

    local result = false;

    local event_name = "win_"..minigame_name;

    if ( not cmn.IsEventStart( event_name ) ) then

      cmn.SetEventStart( event_name );
      private.SetSkipTimer( minigame_name, 1 );

      result = true;

    end;

    if GetCurrentRoom():find("^mg_") then
      SoundSfx( "reserved/aud_mgenter_sfx" )
    else
      SoundSfx( "reserved/aud_mmg_enter" )
    end

    --для не проигр

    if not int_button_info.ShowForGame then

      interface.ButtonHintHide();

      interface.ButtonInfoShow( minigame_name );
      interface.ButtonResetShow();
      interface.ButtonSkipShow();

    else
      int_button_info.ShowForGame = minigame_name;
    end;

      int_button_info.ShowForGame = minigame_name;

    interface.ButtonSkipReload( private.GetSkipTimer( minigame_name ), skip_multiplier or 1 );

    return result;

  end;
  -------------------------------------------------------------------------------------
  function public.MiniGameHide( minigame_name, win_sound )

    if cmn.current_mg then
      public.mg_showed = false
      local result = false;
      if minigame_name == true or minigame_name == nil then
        win_sound = true;
        minigame_name = nil;
      end;
      minigame_name = minigame_name or common.GetObjectName( GetCurrentRoom() );
      cmn.current_mg = nil
      -->> автохайд инвенторя в МГ, чтобы нельзя было открыть деплой с мг, когда активна МГ
      --if ( not int_complex_inv or   int_complex_inv.GetCurrentName() == "" )then
        interface.WidgetSetInput( InterfaceWidget_Inventory, true );
        interface.WidgetSetVisible( InterfaceWidget_Inventory, true, true ); 
        -->> возврат уменьшения перехода назад в активной мг
        if private.MiniGameShow_gate_half then
          local gate = ObjGet( private.MiniGameShow_gate_half.name )
          if gate then
            ObjSet( gate.name, { 
              inputrect_y = private.MiniGameShow_gate_half.inputrect_y;
            } )
            private.MiniGameShow_gate_half = false
          end
        end;
        --<< возврат уменьшения перехода назад в активной мг
   
      --end;
      --<< автохайд инвенторя в МГ, чтобы нельзя было открыть деплой с мг, когда активна МГ

      local event_name = "win_"..minigame_name;

      if  (     cmn.IsEventStart( event_name ) )
      and ( not cmn.IsEventDone( event_name )  )
      then

        private.SetSkipTimer( minigame_name, interface.ButtonSkipGetTime() );
        --DbgTrace( "save skip for &lt; "..prg_name.." &gt; =  "..current_progress[ prg_name ].skiptimer );

        interface.ButtonInfoHide();
        interface.ButtonResetHide();
        interface.ButtonSkipHide();

        if prg.current ~= "scr" then
          interface.ButtonHintShow();
        end

        if win_sound and (win_sound~="mute_win" and win_sound~="mute") then
          if common.GetCurrentSubRoom() or interface.GetCurrentComplexInv() ~= "" then
            SoundSfx( "reserved/aud_mmg_win" );     
          else
            SoundSfx( "reserved/aud_mg_win" );
          end;
        end;

        result = true;

      end;

      if ( result ) and (prg.current == "std" or prg.current == "ext") then

        if not common.GetCurrentSubRoom() and interface.GetCurrentComplexInv()=="" and ng_global.currentprogress ~= "scr" then
          interface_impl.SaveAchievementsTimers( "mg_"..minigame_name );
        end

      end;

      return result;

    end;

  end;
  --------------------------------------------------------------------------------------
  function private.GetSkipTimer( minigame_name )

    local prg = prg.current;
    local event_name = "win_"..minigame_name;
    return ng_global.progress[ prg ][ event_name ].skiptimer;

  end;
  --------------------------------------------------------------------------------------
  function private.SetSkipTimer( minigame_name, time_relative )

    local prg = prg.current;
    local event_name = "win_"..minigame_name;
    ng_global.progress[ prg ][ event_name ].skiptimer = time_relative;

  end;
  --------------------------------------------------------------------------------------
  function public.UpdateInfoText()
    interface.ButtonInfoUpdate()
  end
--*********************************************************************************************************************
--***function *** HO *** () end****************************************************************************************
--*********************************************************************************************************************
  function public.ProcessHoStart( ho_name , delete_mode, so_func)

    private.is_ProcessHoStart = private.is_ProcessHoStart or {}
    if private.is_ProcessHoStart[ho_name] then return else private.is_ProcessHoStart[ho_name]=true end
    
    local ho_found = ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].found;
    
    if delete_mode then
      if type(delete_mode)=="number" then
        if delete_mode==0 then
          delete_mode="delete_objects"
        end;
        if delete_mode==1 then
          delete_mode="disable_objects"
        end;
        if delete_mode== -1 then
          delete_mode="no_delete_objects"
        end;
      end;
    end;
    
    delete_mode=delete_mode or "delete_objects"
    if delete_mode~= "no_delete_objects" then

      for i = 1, #ho_found, 1 do
        
        local obj;
        if ( ho_found[ i ][ "task" ] ) then
          obj = ho_found[ i ][ "object" ]
        end;

        if ( ho_found[ i ][ "item" ] ) then
          obj = ho_found[ i ][ "item" ]
        end;

        if obj then
          if delete_mode=="disable_objects" then
            ObjSet( obj, {visible=0,active=0,input=0,alp=0} );
          else
            ObjDelete( obj );
          end;
          ObjSet( obj.."_sh", {visible=0,active=0,input=0,alp=0,scale_x=0,scale_y=0,res=""} );
        end;
        
      end;
      
    end
    if so_func then
      for i = 1, #ho_found, 1 do
        if ( ho_found[ i ][ "task" ] ) then
          if type(so_func) == "function" then
            so_func( ho_found[ i ][ "task" ], ho_found[ i ][ "object" ] )
          end
        end
        if ( ho_found[ i ][ "item" ] ) then
          if type(so_func) == "function" then
            local task = ld.StringDivide(ho_found[ i ][ "item" ])[3]
            so_func( task )
          end
        end
      end
    end;
    
    local ho_group = ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].group;
    for i = 1, #ho_group, 1 do
      local tbl_name = ho_group[i];
      local all_funcs = _G["ho_"..ho_name]; 
      if all_funcs == nil then--for miniho
        all_funcs = _G[ public.hint["win_"..ho_name ].room ];
      end
      local tbl = all_funcs[tbl_name]
      if tbl then
        tbl.func_end();
      end;
    end;
    
    
  end;
  -----------------------------------------------------------------------------------
  function public.HoItemFind( sender,silhouette, no_anim)

    local ho_name          = common.GetObjectName( GetCurrentRoom() );
    if _G[GetCurrentRoom()].mini_ho then ho_name = _G[GetCurrentRoom()].mini_ho end
    if interface.GetCurrentComplexInv() ~= "" then 
      if ng_global.currentprogress == "std" and  _G["level_inv"].mini_ho then 
        ho_name = _G["level_inv"].mini_ho 
      elseif ng_global.currentprogress == "ext" and _G["levelext_inv"].mini_ho  then
        ho_name = _G["levelext_inv"].mini_ho 
      end
    end     
    local item_name        = sender;
    local task             = ld.StringDivide(sender)[3];
    local item_object_name = "obj_"..common.GetObjectName( item_name );
    local item_spr_name    = "spr_"..common.GetObjectName( item_name );
  if not silhouette then
    if ( ApplyObj( item_name, item_object_name ) ) then

      ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].start = 1;

      if (prg.current == "std" or prg.current == "ext") 
      and (IsCollectorsEdition()  or IsSurveyEdition())
      and not _G[GetCurrentRoom()].mini_ho then
        interface_impl.CountTaskHoAchievement();
      end

      if _G[ GetCurrentRoom() ].ItemFound and interface.GetCurrentComplexInv() == "" then
        if _G[GetCurrentRoom()].mini_ho then 
          _G[ GetCurrentRoom() ].ItemFound( item_name )
        else
          _G[ "ho_"..ho_name ].ItemFound( item_name );
        end
      elseif interface.GetCurrentComplexInv() ~= "" then
        local mod_inv = "level_inv"
        if ng_global.currentprogress == "ext" then mod_inv="levelext_inv" end
        if _G[ mod_inv ].ItemFound and _G[mod_inv].mini_ho then
          _G[ mod_inv ].ItemFound( item_name ) 
        end
      end   
      
    end;
  else 
      ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].start = 1;

      local item_found = { task = task, item = item_name, object = item_spr_name };

      table.insert( ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].found, item_found );

    interface.ItemPanelItemRemove( silhouette );
    ObjSet( item_spr_name, { input = false } );
      if _G[ GetCurrentRoom() ].ItemFound and interface.GetCurrentComplexInv() == "" then
        if _G[GetCurrentRoom()].mini_ho then 
          _G[ GetCurrentRoom() ].ItemFound( item_name )
        else
          _G[ "ho_"..ho_name ].ItemFound( item_name );
        end
      elseif interface.GetCurrentComplexInv() ~= "" then
        local mod_inv = "level_inv"
        if ng_global.currentprogress == "ext" then mod_inv="levelext_inv" end
        if _G[ mod_inv ].ItemFound and _G[mod_inv].mini_ho then
          _G[ mod_inv ].ItemFound( item_name ) 
        end
      end 
    
    if not no_anim then
      ld.FxAnmObj(item_name)
    end
    
      if (prg.current == "std" or prg.current == "ext") 
      and (IsCollectorsEdition()  or IsSurveyEdition())
      and not _G[GetCurrentRoom()].mini_ho then
        interface_impl.CountTaskHoAchievement();
      end
  end

  end;
  -----------------------------------------------------------------------------------
  function public.HoTaskFind( sender, task, no_anim, pos_z )
    private.anti_double_click_check = private.anti_double_click_check or {}
    if private.anti_double_click_check[sender] then return end;
    if sender then
      private.anti_double_click_check[sender]=true;
    end;
    
    local ho_name          = common.GetObjectName( GetCurrentRoom() );
    local task_name        = task or ld.StringDivide(sender)[3];
    local task_object_name = sender;
  
    ObjSet( task_object_name, {pos_z = pos_z or 1} );
    if common.GetObjectPrefix( GetCurrentRoom()) == "rm" and _G["rm_"..ho_name].mini_ho then 
      ho_name = _G["rm_"..ho_name].mini_ho 
    elseif interface.GetCurrentComplexInv() ~= "" then 
      if ng_global.currentprogress == "std" and  _G["level_inv"].mini_ho then 
        ho_name = _G["level_inv"].mini_ho 
      elseif ng_global.currentprogress == "ext" and _G["levelext_inv"].mini_ho  then
        ho_name = _G["levelext_inv"].mini_ho 
      end
    end    
    ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].start = 1;
    
    local task_found = { task = task_name, object = task_object_name };
    table.insert( ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].found, task_found );
    
    interface.TaskPanelTaskComplete( ho_name, task_name, task_object_name, no_anim );
    if (prg.current == "std" or prg.current == "ext")
      and (IsCollectorsEdition()  or IsSurveyEdition()) 
      and not _G[GetCurrentRoom()].mini_ho then
      interface_impl.CountTaskHoAchievement();
    end
    if _G[ GetCurrentRoom() ].ItemFound and interface.GetCurrentComplexInv() == "" then
      if _G[GetCurrentRoom()].mini_ho then 
        _G[ GetCurrentRoom() ].ItemFound( task )
      else
        _G[ "ho_"..ho_name ].ItemFound( task );
      end
    elseif interface.GetCurrentComplexInv() ~= "" then
      local mod_inv = "level_inv"
      if ng_global.currentprogress == "ext" then mod_inv="levelext_inv" end
      if _G[ mod_inv ].ItemFound and _G[mod_inv].mini_ho then
        _G[ mod_inv ].ItemFound( task ) 
      end
    end 
  end;
  --------------------------------------------------------------------
  function public.SetMarkedTask( ho_name, task )

    local prg = prg.current;

    local event_win_ho = "win_"..ho_name;

    ng_global.progress[ prg ][ event_win_ho ].unmark[ task ] = {};
    ng_global.progress[ prg ][ event_win_ho ].unmark[ task ].done = 0;

  end
  --------------------------------------------------------------------------------------
  function public.UnmarkTask( ho_name, task )

    local prg = prg.current;

    local event_win_ho = "win_"..ho_name;

    ng_global.progress[ prg ][ event_win_ho ].unmark[ task ].done = 1;
    ng_global.progress[ prg ][ event_win_ho ].start = 1;
    if ObjGet("int_taskpanel").input then 
      interface.TaskPanelTaskUnmark( ho_name, task );
    end
  end
  --------------------------------------------------------------------------------------
  function public.IsUnmarkedTask( ho_name, task )

    local prg = prg.current;

    local event_win_ho = "win_"..ho_name;

    if (ng_global.progress[ prg ][ event_win_ho ].unmark and ng_global.progress[ prg ][ event_win_ho ].unmark[ task ]) and --initialised and exist 
      ( ng_global.progress[ prg ][ event_win_ho ].unmark[ task ].done == 1 ) then

      return true;

    else

      return false;

    end;

  end
  --------------------------------------------------------------------------------------
  function public.IsFoundTask( ho_name, task )

    local prg = prg.current;

    local event_win_ho = "win_"..ho_name;

    if ng_global.progress[ prg ][ event_win_ho ].found then
      for i,o in ipairs(ng_global.progress[ prg ][ event_win_ho ].found) do
        if o.task == task then
          return true
        end
      end  
    end
    
    return false;

  end
  --------------------------------------------------------------------------------------
  function public.InitHo( ho_name , force)

    local prg = prg.current;
    local event_win_ho = "win_"..ho_name;
    local start = ng_global.progress[ prg ][ event_win_ho ].start
    if force or start==0 or not start then
      ng_global.progress[ prg ][ event_win_ho ].start = 1;
      ng_global.progress[ prg ][ event_win_ho ].unmark = {};
      ng_global.progress[ prg ][ event_win_ho ].found = {};
      ng_global.progress[ prg ][ event_win_ho ].group = {};
      return true
    end
  end
--*********************************************************************************************************************
--***function *** PROGRESS *** () end**********************************************************************************
--*********************************************************************************************************************
  function public.SetEventDone( event_name )

    ng_global.progress[ prg.current ][ event_name ].done = 1;

    cmn.AddSubscriber( event_name, interface.CheckInvPlus );
    cmn.AddSubscriber( event_name.."_end", interface.CheckInvPlus );

    cmn.AddSubscriber( event_name, _G[ "int_cube" ] and int_cube.Load or function()  end );
    cmn.AddSubscriber( event_name.."_end", _G[ "int_cube" ] and int_cube.Load or function()  end );

    int_button_task.Update_FromSetEventDone ( event_name )

    -->>
    ld_impl.SoundBackTheme( true )
    --<<
    if IsCheater() then
      if _G[ "cheater" ] then
        if not cheater.IsLdCheater() then
          ld.LogTrace( "SetEventDone", event_name );
        else
          cheater.AddInGameDoneOrder( event_name )
        end
      end
    end

  end;
  --------------------------------------------------------------------------------------
  function public.IsEventDone( event_name )
    if ng_global.progress[ prg.current ][ event_name ] then
      return ng_global.progress[ prg.current ][ event_name ].done == 1;
    else
      ld.LogTrace("ERROR! You try to check unexist progress "..event_name.." in "..prg.current)
    end

  end;
  --------------------------------------------------------------------------------------
  function public.SetEventStart( event_name )

    ng_global.progress[ prg.current ][ event_name ].start = 1;

  end;
  --------------------------------------------------------------------------------------
  function public.IsEventStart( event_name )

    return ng_global.progress[ prg.current ][ event_name ].start > 0;

  end;
--*********************************************************************************************************************
--***function *** EVENTS *** () end************************************************************************************
--*********************************************************************************************************************
  function public.CheaterKeyPress( keycode )
    --ld.LogTrace( "CheaterKeyPress", keycode )
    if keycode == 192 then
      ld.LogTrace( GetGameCursorPos() )
    elseif keycode == 85 then 
      if ng_global.progress[ "std" ].common.gamewin then
        ng_global.progress[ "ext" ].common.gamewin   = true;
      else
        ng_global.progress[ "std" ].common.gamewin   = true;
      end 
      --ng_global.progress[ "ext" ].common.gamestart = true;
      --ld.LogTrace( ng_global.progress[ "std" ].common.gamewin, ng_global.progress[ "ext" ].common.gamewin )
    elseif keycode == 73 then 
      ng_global.progress[ "std" ].common.gamewin   = true; 
      ng_global.progress[ "ext" ].common.gamewin   = true; 
      --ng_global.progress[ "scr" ].common.gamestart = true;
    elseif keycode == 116 then
      if IsCollectorsEdition() then
        rm_extra.PlaySg()
        -- TERRIBLE PAST
        --local prg_to_clean =
        --{
        --  "opn_masterscr" 
        --  ,"opn_entrypointscr"
        --  ,"opn_xmasstatuescr",     
        --    "win_xmasstatuescr"
        --  ,"use_scapulascr"
        --  ,"opn_entertainmentscr",  
        --    "win_entertainmentscr"
        --  ,"use_keyscr"
        --  ,"opn_holidayscr",        
        --    "win_holidayscr"
        --}
        --for n=1,#prg_to_clean do
        --  ng_global.progress["scr"][prg_to_clean[n] ]={}
        --  ng_global.progress["scr"][prg_to_clean[n] ].done=0
        --  ng_global.progress["scr"][prg_to_clean[n] ].start=0
        --end
        --ng_global.progress[ "scr" ].common.cur_room = "rm_entrypointscr";
        ----ng_global.progress[ "scr" ].common.besttime=-1
        --if not ng_global.progress[ "scr" ].common.besttime then
        --  ng_global.progress[ "scr" ].common.besttime=-1
        --end
        --rm_extra.PlaySecretgame()
      end
    elseif false then --keycode == 117 then
      --rm_extra.PlaySg()
    end;
  end;
  --------------------------------------------------------------------------------------
  function public.Application_Closing()
    if (IsSurveyEdition() and not IsEditor()) then

     -- local survey_url = "http://bigfishgames.survey1-mystery-trackers-nightsville-horror.sgizmo.com/s3/";
      local url = GetUrl();
      OpenBrowser( url );

    end;
  end;
  --------------------------------------------------------------------------------------
  function public.PanelNotification_Click( notification_type )

   -- DbgTrace( "Notification Panel Clicked. Notification type: "..notification_type );
    if notification_type == "achievement" then


        if not (public.achievement_loaded) then
          local module = "rm_achievements";

          ModLoad("assets/levels/menu/rm_achievements/mod_achievements" );
          ObjAttach( module, room.hub );

          _G[ module ].Init();
          public.achievement_loaded = true
        end
        if common.GetCurrentSubRoom() then 
          ld.CloseSubRoom()
        end
        interface.ComplexInvHide()
        common.GotoRoom( "rm_achievements",0,true );
    elseif notification_type == "puzzle" then

        if not (public.screensaver_loaded) then
          local module = "rm_screensaver";

          ModLoad("assets/levels/menu/rm_screensaver/mod_screensaver" );
          ObjAttach( module, room.hub );

          _G[ module ].Init();
          public.screensaver_loaded = true
        end
        if common.GetCurrentSubRoom() then 
          ld.CloseSubRoom()
        end
        interface.ComplexInvHide()
        common.GotoRoom( "rm_screensaver",0,true );
    elseif notification_type == "morphing" then

        if not (public.collectibles_loaded) then
          local module = "rm_collectibles";

          ModLoad("assets/levels/menu/rm_collectibles/mod_collectibles" );
          ObjAttach( module, room.hub );

          _G[ module ].Init();
          public.collectibles_loaded = true
        end
        if common.GetCurrentSubRoom() then 
          ld.CloseSubRoom()
        end
        interface.ComplexInvHide()
        common.GotoRoom( "rm_collectibles",0,true );
    elseif notification_type == "simplemorphing" then
        
    end
  end;
  --------------------------------------------------------------------------------------
  function public.ButtonGuide_Click()

  end;
  --------------------------------------------------------------------------------------
  function public.ButtonHint_Click( hint_state )

    if private.ButtonHint_Click_executing or subroom_impl.IsAnim then
      return
    else
      private.ButtonHint_Click_executing = true
      ld.StartTimer( 1, function() private.ButtonHint_Click_executing = false end )
    end

    local type = ng_global.currentprogress;

    if ( ng_global.gamemode < 2 ) or ( ng_global.gamemode == 3 and ng_global.gamemode_custom[ "hint" ] )then

      if ( hint_state ) then

        local is_ho_hint = false;

        local currentroom = GetCurrentRoom();

        if ng_global.currentprogress == "sgm" and common.GetObjectPrefix( currentroom ) ~= "ho" then
          rm_mastersgm.FailedWithoutHint()
        end
        
        if ( ( common.GetObjectPrefix( currentroom ) == "ho") and ( ng_global.progress[ type ][ "win_"..common.GetObjectName( currentroom ) ].use_object == nil ) )
        
          --or _G[GetCurrentRoom()].mini_ho
        
          then
          
          --if not _G[GetCurrentRoom()].mini_ho then
            --ld_impl.NoteHide()

            interface_impl.TaskHoWithoutHintFailed();
            if ng_global.currentprogress == "std" or ng_global.currentprogress == "ext" then
              interface_impl.CountHintHoAchievement()
            end
            
            if _G[GetCurrentRoom()].clk_hint then

              _G[GetCurrentRoom()].clk_hint()
              
            elseif ( GetCurrentRoom() == currentroom ) then
              ld_impl.NoteHide()
              interface.TaskPanelHoHintShow();
              interface.ItemPanelHoHintShow();
            
            end;
            
          --else
            
             
            
          --end
          
          interface.ButtonHintReload( 1 );
          int_button_hint_impl.StartAnimReloadBegin();
          
          --PlaySfx( "assets/audio/aud_hint", 0, 0 );
  --      elseif currentroom == "rm_room" and cmn.IsEventStart( "win_room" ) and not cmn.IsEventDone( "win_room" ) then
  --        interface_impl.TaskHoWithoutHintFailed();
  --        if ng_global.currentprogress == "std"   then
  --          interface_impl.CountHintHoAchievement()
  --        end
  --        if ( GetCurrentRoom() == currentroom ) then
  --
  --          interface.TaskPanelHoHintShow();
  --
  --        end;
  --
  --        int_button_hint_impl.StartAnimReloadBegin();
  --        interface.ButtonHintReload( 1 );
  --
  --        PlaySfx( "assets/audio/aud_teleport", 0, 0 );      
  --
        else

            local prg_smart = ld_impl.SmartHint_GetNearestPrg()
            --if prg_smart == "win_casket" then
            --  prg_smart = false
            --end
            if not prg_smart and ng_global.currentprogress == "sgm" then
              prg_smart = ld_impl.SmartHint_GetNearestPrg_Full( rm_mastersgm.GetCurrentRoom() )
            end
            ld.LogTrace( "prg_smart", prg_smart )

            local show_teleport = function( prg_name, room )
              if ( not public.show_hint.dialog ) then

                public.show_hint.dialog = prg_name;
                --показать диалог со ссылкой
                common_impl.HideComplexItem();
                if not subroom.close_anim then
                    ld.CloseSubRoom()
                end
                interface.DialogHintShow( room );
                --PlaySfx( "assets/audio/aud_open_teleport", 0, 0 );

              end;
            end

            local hint;

            for i = 1, #game.progress_names, 1 do

              local prg_name = prg_smart or game.progress_names[ i ];
              hint = public.hint[ prg_name ]

              -->> для показа хинтом перехода в локацию, в которой ещё не были -->>
              local room_parent, grm
              if ( not hint )
              and prg_name:find( "^opn" )
              and ( not cmn.IsEventDone( prg_name ) ) 
              then
                room_parent = ld_impl.SmartHint_GetRoomParent( prg_name:gsub( "^opn", "rm" ) )
                if room_parent then 
                  grm = ObjGet( "grm"..( room_parent:gsub( "^rm", "" ) )..( prg_name:gsub( "^opn", "" ) ) )
                end
              end
              if room_parent and grm and grm.input then
                hint = { 
                  type = "click";
                  room = room_parent;
                  use_place = grm.name;
                }
              end
              --<< для показа хинтом перехода в локацию, в которой ещё не были --<<

              if  ( not cmn.IsEventDone( prg_name ) ) and ( hint ) then

                --реализация хинта для локации, отличная от стандартной
                common.LogTrace( common.LogTrace_message, "[ H ] Hint show for < "..prg_name.." >." );

                -->> для показа хинтом перехода в IsZoomable локацию -->>
                if  hint.room 
                and ld.Room.Current() ~= hint.room
                and ld.Room.IsZoomable( hint.room )
                and ld.Room.GateAwailable( hint.room )
                then
                  hint = { 
                    type = "click";
                    room = ld.Room.Parent( hint.room );
                    use_place = ld.Room.ParentGate( hint.room );
                  }
                end
                --<< для показа хинтом перехода в IsZoomable локацию --<<

                -->> для показа хинтом перехода в вложенную. ЗЗ -->>
                if  hint.zz
                and ld.SubRoom.IsOwned( hint.zz )
                and ld.Room.Current() == hint.room
                and ld.SubRoom.IsZz( hint.zz )
                and ld.SubRoom.Current() ~= hint.zz
                then
                  if ld.SubRoom.Current() == nil then
                    hint = { 
                      type = "click";
                      room = hint.room;
                      --zz = ld.SubRoom.Owner( hint.zz );
                      use_place = ld.SubRoom.OwnerGate( hint.zz );
                    }
                  else
                    hint = { 
                      type = "click";
                      room = hint.room;
                      zz = ld.SubRoom.Owner( hint.zz );
                      zz_gate = ld.SubRoom.OwnerGate( hint.zz );
                      use_place = hint.zz_gate;
                    }
                  end
                end
                --<< для показа хинтом перехода в вложенную ЗЗ --<<

                --if common.GetCurrentRoom() == hint.room or common.GetCurrentRoom() == hint.zz then

                if ( ng_global.currentprogress ~= "sgm" 
                      and (common.GetCurrentRoom() == hint.room or common.GetCurrentRoom() == hint.zz))
                  or (ng_global.currentprogress == "sgm" 
                      and rm_mastersgm.GetCurrentRoom() == hint.room )
                then

                    if hint.zz then

                      if hint.zz == "mg_casket" and GetCurrentRoom() ~= hint.zz then

                        private.HintShowAnim( "obj_int_cube_button" );

                      elseif hint.zz == currentroom then

                        --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                        if hint.customhint then
                          interface.ButtonHintReload( 1 );
                          hint.customhint()
                          int_button_hint_impl.StartAnimReloadBegin();
                        else
                          private.CheckHintType( hint );
                          --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                        end

                      else

                        private.CheckRoomState( hint, currentroom )

                      end

                    else

                        if currentroom == hint.room and ObjGet( currentroom ).input == true then

                          if ld_impl.NoteOpened then
                              private.HintShowAnim( ld_impl.NoteOpened, interface.GetCurrentComplexInv() ~= "" );
                              --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                          elseif interface.GetCurrentComplexInv() ~= "" then
                            --DbgTrace("show_close_complex_inv");
                            --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                            private.HintShowAnim("btn_int_complex_inv_impl_close",1)
                          else
                            if hint.customhint then
                              interface.ButtonHintReload( 1 );
                              hint.customhint()
                              int_button_hint_impl.StartAnimReloadBegin();
                            else
                              private.CheckHintType( hint );
                              --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                            end
                          end
                        else

                          if interface.GetCurrentComplexInv() ~= "" then
                            --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                            private.HintShowAnim("btn_int_complex_inv_impl_close",1)
                          else
                            --DbgTrace("show_close_subroom");
                            --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                            private.HintShowAnim("obj_int_frame_subroom_button");
                          end
                        end;

                    end;

                    --interface.DeployInvHide();

                   ---------------для активных инв предметов
                elseif hint.room == "inv_complex_inv" then

                    if hint.zz == interface.GetCurrentComplexInv() then

                        if ld_impl.NoteOpened then
                          if hint.customhint then
                            interface.ButtonHintReload( 1 );
                            hint.customhint()
                          else
                            private.HintShowAnim( ld_impl.NoteOpened, interface.GetCurrentComplexInv() ~= "" );
                            --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                          end

                        elseif interface.GetCurrentComplexInv() == "" then

                           int_inventory_impl.ShowAnim("show")
                           --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                           interface.InventoryItemAdd( hint.zz_gate );
                           private.HintShowAnim( hint.zz_gate );

                        else

                           --private.CheckHintType(prg_name, true);
                           --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                            if hint.customhint then
                              interface.ButtonHintReload( 1 );
                              hint.customhint()
                              --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                            elseif ld_impl.NoteOpened then
                              private.HintShowAnim( ld_impl.NoteOpened, interface.GetCurrentComplexInv() ~= "" );
                              --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                            else
                              private.CheckHintType( hint , 1 );
                              --PlaySfx( "assets/audio/aud_hint", 0, 0 );
                            end
                        end;

                    else

                      --interface.DeployInvHide();
                      int_inventory_impl.ShowAnim("show")
                      interface.InventoryItemAdd( hint.zz_gate );
                      private.HintShowAnim( hint.zz_gate );

                    end;

                   ---------------для шкатулки
                --elseif hint.zz == "mg_casket" then

                      --private.HintShowAnim( "inv_casket",1 );

                else

                  if ( not public.show_hint.dialog ) then

                    public.show_hint.dialog = prg_name;
                    --показать диалог со ссылкой
                    common_impl.HideComplexItem();
                    if not subroom.close_anim then
                        ld.CloseSubRoom()
                    end
                    interface.DialogHintShow( hint.room );
                    --PlaySfx( "assets/audio/aud_open_teleport", 0, 0 );

                  end;

                end;

                break;

             end;

           end;

        end;

      else

        DbgTrace( "Hint is not ready now." );
        interface.DialogShow( "str_dialog_hnt_not_ready", 512, 384 );
        --PlaySfx( "sfx", "common/audio/aud_hint_txt_sfx", 0 );

      end;

    else

      interface.DialogShow( "str_dialog_hnt_hardcore", 512, 384 );

    end;

  end;
  --------------------------------------------------------------------------------------
  function public.ButtonInfoHint_Click()

    if ( ng_global.gamemode < 2 ) or ( ng_global.gamemode == 3 and ng_global.gamemode_custom[ "hint" ] )then
      --PlaySfx( "assets/audio/aud_hint", 0, 0 );
      public.ButtonInfoHintFunc();
    else
      interface.DialogShow( "str_dialog_hnt_hardcore", 512, 384 );
    end

  end;

  --------------------------------------------------------------------------------------
  function public.ButtonInfo_Click()

    interface.DialogShow( public.GetInfoText() );

    SoundSfx( "reserved/aud_click_menu" )

  end;
  --------------------------------------------------------------------------------------
  function public.ButtonInfoLong_Click()

    interface.DialogShow( public.GetInfoLongText() );

    SoundSfx( "reserved/aud_click_menu" )

  end;
--------------------------------------------------------------------------------------
  function public.GetInfoLongText()
    local textId = ""
    local mg_room = public.GetCurrentPlace()
    local mg_name = int_button_info.ShowForGame or common.GetObjectName( mg_room );
    if ng_global.currentprogress == "scr" and mg_name:find( "scr$" ) then
      mg_name = mg_name:gsub( "scr$", "" );
    end
    if _G[ mg_room ] and _G[ mg_room ].GetInfoLongId and _G[ mg_room ].GetInfoLongId() then
      textId = _G[ mg_room ].GetInfoLongId()
    else
      textId = "ifo_"..mg_name.."_long";
    end
    if textId == StringGet(textId) then
      return false
    else
      return textId
    end
  end
--------------------------------------------------------------------------------------
  function public.GetInfoText()
    local textId = ""
    local mg_room = public.GetCurrentPlace()
    
    if ng_global.currentprogress == "scr" then
      mg_room = ng_global.MOD_MASTERSCR_GOTO_ROOM
    end
    local mg_name = int_button_info.ShowForGame or common.GetObjectName( mg_room );

    if _G[ mg_room ] and _G[ mg_room ].GetInfoId and _G[ mg_room ].GetInfoId() then
      textId = _G[ mg_room ].GetInfoId()
    else
      textId = "ifo_"..mg_name;
    end
    return textId
  end
  --------------------------------------------------------------------------------------
  function public.ButtonLock_Click()

  end;
  --------------------------------------------------------------------------------------
  function public.ButtonMap_Click()

    if ng_global.currentprogress=="std" then
      cmn.SetEventDone( "tutorial_map1" );
    end
    interface.MapShow();
    if not subroom.close_anim then
       ld.CloseSubRoom();--закрытие зз при открытие карты
    end

  end
  --------------------------------------------------------------------------------------
  function public.ButtonMenu_Click()

  end;
  --------------------------------------------------------------------------------------
  function public.ButtonReset_Click()
    --PlaySfx( "assets/audio/aud_mgreset", 0, 0 );
    local mg_name = GetCurrentRoom();

    if _G["int_complex_inv"] and ( int_complex_inv.IsOnScreen() ) then

      mg_name = "level_inv"

    end;
    _G[ mg_name ].Reset();

    SoundSfx( "reserved/aud_reset" )

  end;
  --------------------------------------------------------------------------------------
  function public.ButtonSkip_Click( skip_ready )

    if ( ng_global.gamemode < 2 ) or ( ng_global.gamemode == 3 and ng_global.gamemode_custom[ "skip" ] )then

      if ( skip_ready ) then

        local mg_name = GetCurrentRoom();
        --local mg_name = "mg_"..common.GetObjectName( GetCurrentRoom() );
          if ( _G[ "int_complex_inv" ] and int_complex_inv.IsOnScreen() ) then
             mg_name = "level_inv"
          end;
        SoundSfx( "reserved/aud_skip" )
        _G[ mg_name ].Skip();

        interface.ButtonSkipReload( 1 );
        if not common.GetCurrentSubRoom() and interface.GetCurrentComplexInv()=="" then
          interface_impl.CountSkipMgAchievement()
        end
      else

        DbgTrace( "Skip is not ready now." );
        interface.DialogShow( "str_dialog_skip_not_ready", 512, 384 );

      end;

    else

      interface.DialogShow( "str_skip_hardcore", 512, 384 );

    end;

  end;
  --------------------------------------------------------------------------------------
  function public.FrameSubroom_Click()

  end;
  --------------------------------------------------------------------------------------
  function public.Tutorial_Click( button_id )
    local type = ng_global.currentprogress;
      local param = ""
      if ng_global.currentprogress=="sgm" then
        param = "sgm"
      end
      if ng_global.currentprogress=="scr" then
        param = "scr"
      end
      if ng_global.currentprogress=="ext" then
        param = "ext"
      end
      local tutorial_name = _G["level"..param].tutorial_current;
      --ld.LogTrace( "Tutorial_Click", tutorial_name );
      if ( string.find( button_id, "yes" ) or  string.find( button_id, "empty" ) ) then
        
          _G["level"..param][tutorial_name].click()
          
      elseif ( string.find( button_id, "no" ) ) then

        if _G["level"..param][tutorial_name].click_no then   --если есть для текущего туториал функция для кнопки "no"
          _G["level"..param][tutorial_name].click_no()
        else
          interface.TutorialHide();
          _G["level"..param].TutorialDisable();
        end
      elseif ( string.find( button_id, "skip" ) ) then 
          interface.TutorialHide();
          _G["level"..param].TutorialSpecialDisable();
      else

        DbgTrace("impossible "..button_id);

      end;


  end;
  --------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------------
  function public.HoHint_NoObjects()
    local ho_name = GetCurrentRoom()
    if _G[ho_name].CustomHint then
      _G[ho_name].CustomHint()
    end
    --ld.LogTrace( " == common_impl.HoHint_NoObjects() == " );
  end;
  --------------------------------------------------------------------------------------
  public.DialogHo_Show_Custom = nil;
  function public.DialogHo_Show()
    cmn.CallEventHandler( "DialogHo_Show_Event" );
    cmn.ClearSubscribers( "DialogHo_Show_Event" )
    ld.LogTrace( "common_impl.DialogHo_Show() call" );
    if public.DialogHo_Show_Custom then
      ld.LogTrace( "common_impl.DialogHo_Show_Custom() call" );
      if ng_global.currentprogress=="scr" then
        rm_extra.go_back(false,true);
        return;
      end;
      
      public.DialogHo_Show_Custom();
      public.DialogHo_Show_Custom=nil;
      return;
    end
    if _G[GetCurrentRoom()].DialogHo_Show_Custom  then
      ld.LogTrace( "room.DialogHo_Show_Custom() call" );
      if ng_global.currentprogress=="scr" then
        rm_extra.go_back(false,true);
        return;
      end;
      
      _G[GetCurrentRoom()].DialogHo_Show_Custom();
      return;
    end
 
    private.miniho_inv = false
    local ho_name = common.GetObjectName( GetCurrentRoom() );
    if _G[GetCurrentRoom()].mini_ho then ho_name = _G[GetCurrentRoom()].mini_ho end
    if interface.GetCurrentComplexInv() ~= "" then 
      if ng_global.currentprogress == "std" and  _G["level_inv"].mini_ho then 
        ho_name = _G["level_inv"].mini_ho 
        private.miniho_inv = _G["level_inv"].mini_ho 
      elseif ng_global.currentprogress == "ext" and _G["levelext_inv"].mini_ho  then
        ho_name = _G["levelext_inv"].mini_ho 
        private.miniho_inv = _G["levelext_inv"].mini_ho 
      end
    end 
    if ld.TableContains(game.room_names, "ho_"..ho_name) or _G[GetCurrentRoom()].mini_ho or
      ( ng_global.currentprogress =="scr" and ld.StringDivide(GetCurrentRoom())[1]=="ho" ) or 
      (interface.GetCurrentComplexInv() ~= "" and private.miniho_inv) then
      
      
    --if ng_global.currentprogress~="scr" then
      interface.TaskPanelHide();
      interface.ItemPanelHide();
    --else 
    --  --rm_secretroom.CheckTmr(GetCurrentRoom())
    --  if common.GetObjectPrefix(GetCurrentRoom()) == "mg"  then
    --      cmn.MiniGameHide( ho_name, true );
    --  end
    --end

    if private.miniho_inv then
      interface.DialogHoShow(private.miniho_inv);
    else
      interface.DialogHoShow();
    end
    ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].done = 1;
    if (ng_global.currentprogress=="std" or ng_global.currentprogress=="ext")  and not _G[GetCurrentRoom()].mini_ho and not private.miniho_inv then
      ng_global.progress[ ng_global.currentprogress ].common.currentroom = game.relations[ GetCurrentRoom() ].exitroom;        
      interface_impl.StopHoAchievements();
    end
        
        



    end
    
  end;
  --------------------------------------------------------------------------------------
  public.DialogHo_Hide_Custom = nil;
  function public.DialogHo_Hide()
    cmn.CallEventHandler( "DialogHo_Hide_Event" );
    cmn.ClearSubscribers( "DialogHo_Hide_Event" )
    local ho_name = common.GetObjectName( GetCurrentRoom() );
    if _G[GetCurrentRoom()].mini_ho then ho_name = _G[GetCurrentRoom()].mini_ho end
      if private.miniho_inv then ho_name = private.miniho_inv end
    cmn.AddSubscriber( "win_"..ho_name, interface.CheckInvPlus );
    cmn.AddSubscriber( "win_"..ho_name.."_end", interface.CheckInvPlus );

    if  _G[GetCurrentRoom()].mini_ho or (interface.GetCurrentComplexInv() ~= "" and private.miniho_inv) then 
      if private.miniho_inv then
        private.miniho_inv = false 
        if ng_global.currentprogress == "std" and  _G["level_inv"].mini_ho then 
          _G["level_inv"]["win_"..ho_name]()
        elseif ng_global.currentprogress == "ext" and _G["levelext_inv"].mini_ho  then
          _G["levelext_inv"]["win_"..ho_name]()
        end        
      else
        _G[GetCurrentRoom()]["win_"..ho_name]()
      end
      return
    end 
    
    if public.DialogHo_Hide_Custom then
      public.DialogHo_Hide_Custom();
      public.DialogHo_Hide_Custom=nil;
      return;
    end
    if _G[GetCurrentRoom()].DialogHo_Hide_Custom  then
      _G[GetCurrentRoom()].DialogHo_Hide_Custom();
      return;
    end
    
    
    
    if ng_global.currentprogress=="std" or ng_global.currentprogress == "ext" then
      cmn.CallEventHandler( "win_"..ho_name, GetCurrentRoom() );
      common.GotoRoom( game.relations[ GetCurrentRoom() ].exitroom );
      interface_impl.ShowHoAchievements();
    else
      --GREAT FUTURE
      --if _G[ "rm_secretroomscr" ] then 
      --  rm_secretroomscr.ResetHOGame() 
      --end
      --TERRIBLE PAST:
      rm_extra.go_back(false,true);
    end

    
  end;
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--*********************************************************************************************************************
--***function *** GATES *** () end ************************************************************************************
--*********************************************************************************************************************
  function public.GotoRm( rm_name, need_fade )

    local rm_object_name = "rm_"..rm_name;

    need_fade = need_fade or 1;

    public.DeleteHintFx()

    common.GotoRoom( rm_object_name, need_fade );

  end;
  --------------------------------------------------------------------
  function public.GotoHo( ho_name, need_fade )

    local ho_object_name = "ho_"..ho_name;

    need_fade = need_fade or 1;

    public.DeleteHintFx()

    common.GotoRoom( ho_object_name, need_fade );

  end;
  --------------------------------------------------------------------
  function public.GotoMg( mg_name, need_fade )

    local mg_object_name = "mg_"..mg_name;

    need_fade = need_fade or 1;

    public.DeleteHintFx()

    common.GotoRoom( mg_object_name, need_fade );

  end;
  --------------------------------------------------------------------
  function public.GotoZz( zz_name, pos_beg )

    local zz_object_name = "zz_"..zz_name;

    public.DeleteHintFx()
    ObjDelete( "obj_hint_obj_int_frame_subroom_button" );

    common.GotoSubRoom( zz_object_name, pos_beg );

  end;
  --------------------------------------------------------------------
  function public.GateMouseEnter( type_cursor, text_obj )

    if type_cursor then
      SetCursor(type_cursor);
    else
      SetCursor(CURSOR_DEFAULT);
    end;

    public.PopupShow( text_obj );

  end;
  --------------------------------------------------------------------
  function public.GateMouseLeave()

    SetCursor(CURSOR_DEFAULT);

    public.PopupHide();

  end;
--*********************************************************************************************************************
--***function *** POPUP *** () end ************************************************************************************
--*********************************************************************************************************************
  function public.PopupShow( popup_text )

    local popup_text_id = "pop_"..popup_text;
    interface.PopupShow( popup_text_id );

  end;
  --*********************************************************************************************************************
  function public.PopupHide()

    interface.PopupHide();

  end;
--*********************************************************************************************************************
--*********************************************************************************************************************
--***function *** LOCK *** () end ************************************************************************************
--*********************************************************************************************************************
-- заблокировать(1), разблокировать(0)w
-- возвращает тру, если блокировка вызывается для "разблокированного" лока (защита от двойного прокликивания - при возвращении фалсе - код выполнять не нужно)
  private.LockStateNow = false;
  function public.Lock( state )
    --ld.LogTrace( "Lock state = "..state );
    local answer = true;
    -- разблокировать
    if state == 0 then
      interface.LockHide();
      private.LockStateNow = false;
    -- заблокировать
    elseif state == 1 then
      interface.LockShow();
    
      if private.LockStateNow then
        answer = false;
      end;
      private.LockStateNow = true;
    end;
    --cheater
    local val = type( state ) == "number" and state or ( state and 1 or 0 )
    ObjSet( "spr_cheater_current_lock", {color_r = val, color_g = 1 - val} );
    
    return answer;
  end;
  -------------для комнат при переходе
  -- заблокировать(1), разблокировать(0)
  function public.LockRm( state )
    --ld.LogTrace( "Lock state = "..state );
    -- разблокировать
    if state == 0 then
      interface.LockHideRm();
    -- заблокировать
    elseif state == 1 then
      interface.LockShowRm();
    end;
    ObjSet( "spr_cheater_current_rmlock", {color_r = state, color_g = 1 - state} );
  end;
  function public.LockTask( state )
    if state == 0 then
      interface.LockHideTask();
    elseif state == 1 then
      interface.LockShowTask();
    end;
  end;
  function public.LockCustom( name, state )
    if state == 0 then
      interface.LockHideCustom( name );
    elseif state == 1 then
      interface.LockShowCustom( name );
    end;
    ObjSet( "spr_cheater_current_rmlock", {color_r = state, color_g = 1 - state} );
  end;
--*********************************************************************************************************************
function public.NoteScale( event, source_name )

  local small_pic = source_name;
  local big_pic   = "spr_"..common.GetObjectName( small_pic ).."_big";

  local pos_array  = {};

  pos_array.start  = {};
  pos_array.finish = {};

  pos_array.finish.pos_x = 0;
  pos_array.finish.pos_y = 0;

  local room = GetCurrentRoom();
  if ( ObjGet(room).input == false ) then

    local subroom = common.GetCurrentSubRoom();

    pos_array.start.pos_x = ObjGet( small_pic ).pos_x;
    pos_array.start.pos_y = ObjGet( small_pic ).pos_y;

    local trg_after = function()

      local small_pic = source_name;
      local big_pic   = "spr_"..common.GetObjectName( small_pic ).."_big";

      public.Lock( 0 );
      local obj = common.GetObjectName( GetCurrentRoom());
      if not private[obj] then
        private[obj] = {};
        private[obj].note = "close";
      end;
      if event == "open" then
        private[obj].note = "open";
        ObjSet( big_pic, { input = 1 } );
      else
        private[obj].note = "close";
        ObjSet( big_pic, { input = 0, alp = 0 } );
      end;

    end;

    if event == "open" then

      public.Lock( 1 );

      private.note_scale.pos_x = pos_array.start.pos_x;
      private.note_scale.pos_y = pos_array.start.pos_y;

      ObjAnimate( small_pic, "alp", 0, 0, "",
      {
      0.0, 0, 1,
      0.3, 0, 0
      } );

      ObjAnimate( small_pic.."_shadow", "alp", 0, 0, "",
      {
      0.0, 0, 1,
      0.3, 0, 0
      } );

      ObjSet( big_pic, { alp = 1, input = 1,inputrect_init = 1,inputrect_x = -1000,inputrect_y = -1000,inputrect_w = 2000, inputrect_h = 2000  } );
      ObjAnimate( big_pic, "pos_xy", 0, 0, "",
      {
      0.0, 3, pos_array.start.pos_x, pos_array.start.pos_y,
      0.3, 3, pos_array.finish.pos_x, pos_array.finish.pos_y
      } );

      ObjAnimate( big_pic, "scale_xy", 0, 0, trg_after,
      {
      0.0, 3, 0, 0,
      0.3, 3, 1, 1
      } );

    else

      public.Lock( 1 );

      ObjAnimate( small_pic, "alp", 0, 0, "",
      {
      0.0, 0, 0,
      0.3, 0, 1
      } );

      ObjAnimate( small_pic.."_shadow", "alp", 0, 0, "",
      {
      0.0, 0, 0,
      0.3, 0, 1
      } );

      ObjAnimate( big_pic, "pos_xy", 0, 0, "",
      {
      0.0, 3, pos_array.finish.pos_x, pos_array.finish.pos_y,
      0.3, 3, private.note_scale.pos_x, private.note_scale.pos_y
      } );

      ObjAnimate( big_pic, "scale_xy", 0, 0, trg_after,
      {
      0.0, 3, 1, 1,
      0.3, 3, 0, 0
      } );

    end;

end;

end;
--*********************************************************************************************************************
function public.StartProvidence()

     public.TutorialShow( "tutorial_page_13" );

   if cmn.IsEventDone( "get_prv_tablet" ) and not cmn.IsEventDone( "use_fork_providence_invitem_1" ) then

     public.TutorialShow( "tutorial_page_17" );

   end;

   ObjSet( "obj_int_button_providence", { event_mdown = "*common_impl.StopProvidence();" } );

   local current_room = common.GetObjectName( GetCurrentRoom() );

   private.providence_item_number = 4;
   private.providence_inv_number = 0;
   private.providence_enable = true;

   complete_providence = 0;

   public.start_providence = true;

   ObjSet( "obj_"..current_room.."_gates", { input = false, active = false, visible = false } );
   ObjSet( "obj_"..current_room.."_use", { input = false, active = false, visible = false } );

   --проверку на зз

     if current_room == "fork" then

        private.providence_item_number = 3;
        private.providence_inv_number = 1;

     elseif current_room == "livingroom" then

        private.providence_item_number = 5;
        private.providence_inv_number = 1;

     elseif current_room == "abandoneddistrict" or current_room == "office" then

        private.providence_item_number = 2;
        private.providence_inv_number = 2;

     else

        private.providence_enable = false;

     end;

    if private.providence_enable then

      for i = 1, private.providence_item_number do

         if not cmn.IsEventDone( "clk_"..current_room.."_providence_"..i ) then

          -- ObjSet( "spr_"..current_room.."providence_item_light_"..i, { visible = true, active = true } );
           ObjSet( "obj_"..current_room.."_providence_item_"..i, { visible = true, active = true, input = true } );

         else

            complete_providence = complete_providence + 1;

         end;

      end;

      for j = 1, private.providence_inv_number do

         if not cmn.IsEventDone( "use_"..current_room.."_providence_invitem_"..j ) then

          -- ObjSet( "spr_"..current_room.."providence_item_light_"..i, { visible = true, active = true } );
           ObjSet( "obj_"..current_room.."_use_providence_invitem_"..j, { visible = true, active = true, input = true } );

         else

            complete_providence = complete_providence + 1;

         end;

      end;


      if complete_providence == private.providence_item_number + private.providence_inv_number then

        -- вызов функции старта видоса

      end;

    end;

end;
--*********************************************************************************************************************
function public.StopProvidence()

   public.start_providence = false;

   ObjSet( "obj_int_button_providence", { event_mdown = "*common_impl.StartProvidence();" } );

   local current_room = common.GetObjectName( GetCurrentRoom() );

   ObjSet( "obj_"..current_room.."_gates", { input = true, active = true, visible = true } );
   ObjSet( "obj_"..current_room.."_use", { input = true, active = true, visible = true } );

   if private.providence_enable then

     for i = 1, private.providence_item_number do

        -- ObjSet( "spr_"..current_room.."providence_item_light_"..i, { visible = false, active = false } );
         ObjSet( "obj_"..current_room.."_providence_item_"..i, { visible = false, active = false, input = false } );

      end;


      for j = 1, private.providence_inv_number do

        -- ObjSet( "spr_"..current_room.."providence_item_light_"..i, { visible = false, active = false } );
         ObjSet( "obj_"..current_room.."_use_providence_invitem_"..j, { visible = false, active = false, input = false } );

      end;

    end;

  if cmn.IsEventDone( "clk_fork_providence_1" ) and cmn.IsEventDone( "clk_fork_providence_2" ) and cmn.IsEventDone( "clk_fork_providence_3" )  and not cmn.IsEventDone( "use_fork_providence_invitem_1" )  then

    common_impl.TutorialShow( "tutorial_page_15" );

  end;

end;
--*********************************************************************************************************************
function public.ShowBbt( bbt_text, bbt_cnt, bbt_rnd, voice_vid_changer, voice_func_end )

  if string.find( bbt_text, "^bbt_" ) then
    bbt_text = string.sub(bbt_text,5,string.len(bbt_text))
  end
  
  if StringGet( "bbt_"..bbt_text ) == "bbt_"..bbt_text then
    ld.LogTrace( "WARNING: not TEXT <bbt_"..bbt_text.."> in string" );
  end  
  
  if not (ng_global.gamemode == 3) or (ng_global.gamemode == 3 and ng_global.gamemode_custom["text"] ) or ( bbt_cnt and type( bbt_cnt ) == "string" ) then

    if _G[ "cheater" ] then
      if cheater.InsertFastExecuter then
        local prg = bbt_text:gsub("^need_","use_");
        ld.LogTrace( "cheater.InsertFastExecuterFunc", prg )
        if ng_global.progress[ ng_global.currentprogress ][ prg ] then
          cheater.InsertFastExecuterFunc( prg )
        else
          ld.LogTrace( "ERROR: cheater.InsertFastExecuterFunc prg not finded -> "..prg )
          cheater.InsertFastExecuter = false
        end;
      else
        if cheater.BbtPrg and bbt_text:find( "^need_" ) then
          local prg = bbt_text:gsub("^need_","use_");
          if ng_global.progress[ ng_global.currentprogress ][ prg ] then
            cheater.BbtPrg( prg )
          end
        end
      end
    end;

    local txtout = "bbt_"..bbt_text;
    if string.find( bbt_text, "^str_" ) then      
      txtout = bbt_text;
    end

    local cnt = 1;
    local rnd = false;

    local postfix = "";
    local prg = ng_global.currentprogress;

--    if prg == "ext" then
--
--      postfix = "_ce";
--
--    elseif prg == "scr" then
--
--      postfix = "_sc";
--
--    end;


    -- если нет массива
    if not ng_global.bbt then
      ng_global.bbt = {};
    end;
    -- получаем количество
    if bbt_cnt and type( bbt_cnt ) == "number" then
      cnt = tonumber(bbt_cnt);
    end;
    if bbt_rnd and type( bbt_cnt ) == "number" then
      rnd = true;
    end;
    -- если много
    if cnt > 1 then
      -- если еще нет записи в массиве
      if not ng_global.bbt[txtout] then
        ng_global.bbt[txtout] = 1;
      end;
      -- без рандома
      if not rnd then
        interface.BBTShow(txtout.."_"..ng_global.bbt[txtout]..postfix);
        -- увеличиваем/сбрасываем счетчик
        if ng_global.bbt[txtout] == cnt then
          ng_global.bbt[txtout] = 1;
        else
          ng_global.bbt[txtout] = ng_global.bbt[txtout] + 1;
        end;
      -- рандом
      else
        local new_bbt = ng_global.bbt[txtout];
        --DbgTrace("old "..new_bbt);
        while (new_bbt == ng_global.bbt[txtout]) do
          new_bbt = math.random(1,cnt);
          --DbgTrace("new "..new_bbt);
        end;
        ng_global.bbt[txtout] = new_bbt;
        --DbgTrace("fin "..ng_global.bbt[txtout]);
        interface.BBTShow(txtout.."_"..ng_global.bbt[txtout]..postfix);
      end;
    else
      -- >>>> показ спрайта на блэкбаре + липсинк >>>>
      if type( bbt_cnt ) == "string" then
        int_blackbartext_impl.HideLipSink()
        public.bbt_character = bbt_cnt;                    --имя спрайта картики в блэкбаре
        public.bbt_voice = bbt_rnd;                        --aud_voc - войс, если есть видос vid_zrm_aud_voc - будет показан по альфе
        public.bbt_voice_vid_changer = voice_vid_changer;  --если есть, будет скрыт по альфе
        public.bbt_voice_func_end = voice_func_end;        --функция будет вызвана в int_blackbartext_impl.HideLipSink()
      end
      -- <<<< показ спрайта на блэкбаре + липсинк <<<<
      interface.BBTShow(txtout..postfix);
    end;

  end;

end;
--*********************************************************************************************************************
--*****************************************************************************************************************
  --показывает ббт при наличии такового в strings
  function public.ShowBbtIfExist( bbt )
    local bbt_id = "bbt_"..bbt
    if StringGet( bbt_id ) ~= bbt_id then
      ld.ShowBbt( bbt )
      return true
    else
      return false
    end;
  end
--*********************************************************************************************************************
  --показывает ббт на открытие при наличии такового в strings
  function public.ShowBbtOpn( room )
    local div = ld.StringDivide( room )
    local rm = div[ 2 ] or div[ 1 ]
    return public.ShowBbtIfExist( "opn_"..rm )
  end
--*********************************************************************************************************************
  --показывает ббт после прогресса при наличии такового в strings
  function public.ShowBbtAfter( prg )
    return public.ShowBbtIfExist( "after_"..prg )
  end
--*****************************************************************************************************************
--*********************************************************************************************************************
function public.WrongApply()

  local txtout = "wrongapply";
  local cnt = 4;

  if not ng_global.wrongapply then
    ng_global.wrongapply = {};
  end;

  local new_wrongapply = ng_global.wrongapply[txtout];

  while (new_wrongapply == ng_global.wrongapply[txtout]) do
    new_wrongapply = math.random(1,cnt);
  end;

  ng_global.wrongapply[txtout] = new_wrongapply;
  ld.ShowBbt(txtout.."_"..ng_global.wrongapply[txtout])
  --interface.BBTShow(txtout.."_"..ng_global.wrongapply[txtout]);

end;
--*********************************************************************************************************************
function public.DelayedCall( delay, caller )

  local timer;

  repeat

    timer = "tmr_delayedcall_timer_"..math.random( 10000 );

  until not private.timers[ timer ];

  private.timers[ timer ] = caller;

  --if not next( ObjGet( timer ) ) then

    ObjCreate( timer, "timer" );

  --end;

  ObjAttach( timer, "cmn_timers" );

  local trg_after = function ()

    private.DelayedCallTimer( timer );

  end;

  ObjSet( timer, { endtrig = trg_after, time = delay, playing = 1 } );

  return timer;

end;
--*********************************************************************************************************************
function private.DeleteTimer( timer_id )

  if private.timers[ timer_id ] then

    ObjSet( timer_id, { playing = 0 } );
    private.timers[ timer_id ] = {};
    ObjDelete( timer_id );

    return true;

  else

    return false;

  end;

end;
--*********************************************************************************************************************
function private.DelayedCallTimer( timer )

  local timer = timer;
  local callback = private.timers[ timer ];
  private.DeleteTimer( timer );
  callback();

end;
--*********************************************************************************************************************
function public.GetDcn( spr_dcn, dcn_name )

  local id;

  for i = 1,#int_diary.DCN_ARRAY[ng_global[ "investigation" ] ] do

    if dcn_name == int_diary.DCN_ARRAY[ ng_global[ "investigation" ] ][i] then

        id = i;

    end;

  end;

  local obj_in = string.format( "obj_int_%s_dcn_%i_in", "investigation_button", id );

  local pos = GetObjPosByObj( spr_dcn, obj_in );
  pos = pos or { 0, 0};
  posx = pos[ 1 ];
  posy = pos[ 2 ];
  local event = "get_"..dcn_name;

  int_diary.SetPage( dcn_name );

  ObjAttach( spr_dcn, obj_in );
  ObjSet( spr_dcn, { input = false, pos_x = posx, pos_y = posy  } );

  local end_trig = function ()

      public.Lock(0);
      cmn.SetEventDone( event );
      cmn.CallEventHandler( event );

      if ( common.GetObjectPrefix(GetCurrentRoom()) == "mg" ) then
          common.GotoRoom( common.GetPrevRoom() );
      end;

      if not int_diary.CheckInvestigation() then

        public.DelayedCall( 3, function () int_investigation_button.HidePanel(); end );

      end;

      int_investigation_button.AddDcnAnim( dcn_name );
      ObjDetach( spr_dcn );

  end;

  ObjSet( spr_dcn.."_shadow", { alp = 0 });
  ObjAnimate( spr_dcn, "alp", 0, 0, end_trig, { 0, 0, 1, 1.3, 0, 1, 1.8, 0, 0.0 } );
  ObjAnimate( spr_dcn, "pos_x",0,0,"",{ 0.0, 0, posx, 1.8, 0, 0 } );
  ObjAnimate( spr_dcn, "pos_y",0,0,"",{ 0.0, 3, posy, 1.8, 3, 0 } );
  ObjAnimate( spr_dcn, "scale_xy",0,0,"",{ 0.0, 3, 1, 1, 1.5, 3, 0.5, 0.5 } );

  if ( event == "get_evidence_1_2" and not cmn.IsEventDone( event )) then

    int_investigation_button.Show();

  else

    public.DelayedCall( 1, function () int_investigation_button.AnimPanel(true); end );

  end

  ObjCreate( "fx_diary_"..dcn_name, "partsys" );
  ObjSet( "fx_diary_"..dcn_name, {
      res = "assets/interface/resources/diary/anims/p_clue",
      alp = 1, visible = true, input = false,
      pos_x = posx, pos_y = posy
  });
  ObjAttach( "fx_diary_"..dcn_name, "obj_int_button_hint_button_diary" );
  ObjAnimate( "fx_diary_"..dcn_name, "pos_xy",0,0, "",
  {
    0.0, 0, posx, posy,
    1.3, 0, 0, 0
  });

  local trg_fx = function()

    ObjDelete( "fx_diary_"..dcn_name );
    int_diary.AnimButton();

  end;

  ObjAnimate( "fx_diary_"..dcn_name, "alp", 0, 0, trg_fx,
  {
    0.0, 3, 1,
    1.3, 3, 1,
    1.8, 3, 0
  });

  public.ShowBbt( dcn_name );

end;
--*********************************************************************************************************************
-- hide subroom
function public.HideCurrentInterface()

  public.InterfaceSetVisible( false );
  local room = GetCurrentRoom();

  if ( common.IsInSubRoom() ) then

    room = common.GetCurrentSubRoom();

  end;

  local trg_after = function()

    ObjSet( room, { active = false } );

  end;

  if common.GetObjectPrefix( room ) == "zz" then

    ObjSet( room, { input = false } );
    ObjSet( "int_frame_subroom", { input = false } );
    ObjSet( "subroom", { input = false } );
    ObjAnimate( "int_frame_subroom", "alp", 0, 0, "", { 0,0,1,  0.3,0,0 } );
    ObjAnimate( "subroom", "alp", 0, 0, "", { 0,0,1,  0.3,0,0 } );
    ObjAnimate( room, "alp", 0, 0, trg_after, { 0,0,1,  0.3,0,0 } );

  else

    ObjSet( room, { input = false } );

  end;

end;
--*********************************************************************************************************************
-- show subroom
function public.ShowCurrentInterface( dcn )

  public.Lock(1);
  public.InterfaceSetVisible( true );
  local room = GetCurrentRoom();

  if common.GetObjectPrefix( room ) == "mg" then

    ObjSet( room, { input = true, active = true } );
    public.GetDcn( "spr_"..common.GetObjectName( room ).."_"..dcn, dcn );

  elseif common.GetObjectPrefix( room ) == "rm" then

    if ( common.IsInSubRoom() ) then

        room = common.GetCurrentSubRoom();

        local trg = function()

          public.GetDcn( "spr_"..common.GetObjectName( room ).."_"..dcn, dcn );

        end;

        ObjSet( room, { input = true, active = true } );
        ObjSet( "int_frame_subroom", {  input = true } );
        ObjSet( "subroom", { input = true } );
        ObjAnimate( "int_frame_subroom", "alp", 0, 0, "", { 0,0,0,  0.3,0,1 } );
        ObjAnimate( "subroom", "alp", 0, 0, "", { 0,0,0,  0.3,0,1 } );
        ObjAnimate( room, "alp", 0, 0, trg, { 0,0,0,  0.3,0,1 } );

    else

        ObjSet( room, { input = true, active = true } );
        public.GetDcn( "spr_"..common.GetObjectName( room ).."_"..dcn, dcn );

    end;

  end;

end;
--*********************************************************************************************************************
-- show/hide interface
function public.InterfaceSetVisible( key )

  local int_widget =
  {
    "int_inventory",
    "int_button_hint",
   -- "int_taskpanel",
    "int_button_map",
    "int_button_menu",
    "int_button_guide",
    "int_button_diary",
    "int_helper"
  }
  if ( key == false ) then

    for i = 1, #int_widget do
      local o = ObjGet( int_widget[ i ] )
      if o then
        ObjSet( o.name, { input = 0 });
        ObjAnimate( o.name, "alp", 0, 0, "", { 0,0,o.alp,  0.3,0,0 } );
      end
    end;

    --ObjSet( "subroom", { input = 0 });

  else

    for i = 1, #int_widget do

      local o = ObjGet( int_widget[ i ] )
      if o then
        ObjSet( o.name, { input = 1, visible = 1 });
        ObjAnimate( o.name, "alp", 0, 0, "", { 0,0,o.alp,  0.3,0,1 } );
      end

    end;

    --ObjSet( "subroom", { input = 1 });

  end;

end;
--*********************************************************************************************************************
--*********************************************************************************************************************
function public.PlayAudio(type,path,loop,trig,fade)

  if not loop then loop = 0; end;
  if not trig then trig = ""; end;
  if not fade then fade = 0; end;

  local needtoplay = true;
  if (type ~= "sfx") and (loop == 1) and (#private.audio[type] > 0) then
    for i = 1, #private.audio[type], 1 do
      if private.audio[type][i] == path then
        needtoplay = false;
      end;
    end;
  end;
  if needtoplay then
    if type == "sfx" then
      PlaySfx("assets/"..path,loop,fade);
    elseif type == "env" then
      PlayEnv("assets/"..path,loop,fade);
      private.audio["env"][ #private.audio["env"] + 1 ] = path;
    elseif type == "mus" then
      public.StopAllMus();
      PlaySoundtrack("assets/"..path,loop,fade);
      private.audio["mus"][ #private.audio["mus"] + 1 ] = path;
    elseif type == "voc" then
      PlayVoice("assets/"..path,loop,fade);
      private.audio["voc"][ #private.audio["voc"] + 1 ] = path;
    end;
  end;

end;
--*********************************************************************************************************************
function private.VolumeFadingOff()

    private.volume_fade = false;

    SetSoundVolume("voice",private.dialog_voice);
    SetSoundVolume("soundtrack",private.dialog_soundtrack);
    SetSoundVolume("env",private.dialog_env);

end;
function private.VolumeFadingOn()

  private.dialog_soundtrack = GetSoundVolume( "soundtrack" );
  private.dialog_voice = GetSoundVolume( "voice" );
  private.dialog_env = GetSoundVolume( "env" );

  if private.dialog_soundtrack > 0.15 and private.dialog_voice > 0.15 then

    private.volume_fade = true;

    local dialog_voice = private.dialog_voice;
    local dialog_soundtrack = private.dialog_soundtrack;
    local dialog_env = private.dialog_env;

    if (private.dialog_voice - private.dialog_soundtrack) < 0.3 then

      dialog_voice = 0.7;
      dialog_soundtrack = 0.2;

      if (private.dialog_voice - private.dialog_env) < 0.3 then

        dialog_env = 0.6;
--DbgTrace( "private.dialog_env0.3" );
      end;

    elseif (private.dialog_voice - private.dialog_soundtrack) < 0.9 then

      dialog_voice = 0.8;
      dialog_soundtrack = 0.3;

      if (private.dialog_voice - private.dialog_env) < 0.9 then

        dialog_env = 0.6;
--DbgTrace( "private.dialog_env0.5" );
      end;

    end;

    SetSoundVolume( "voice", dialog_voice );
    SetSoundVolume( "soundtrack", dialog_soundtrack );
    SetSoundVolume( "env", dialog_env );

  end;

end;
--*********************************************************************************************************************
--------------------------------------------------------------------------------------
--*********************************************************************************************************************
--***function *** SOUND OLD *** () end ************************************************************************************
--*********************************************************************************************************************
  --функция проигрывания енвайромента
  function public.EnvPlay(paths,trig,fade)
    if not trig then trig = ""; end;
    if not fade then fade = 0; end;

    local loop = 1;
    local needtoplay = true;
    local shift = 0;


    for i = 1, #private.audio["env"] do
      local needtostop = true;
      for j = 1, #paths do
        if private.audio["env"][i] == paths[j] then
          needtostop = false;
        end;
      end;
      if needtostop then
        SndStop("assets/"..private.audio["env"][i],0.5);
        private.audio["env"][i] = nil;
        shift = shift + 1;
      else
        private.audio["env"][i-shift] = private.audio["env"][i];
        if shift ~= 0 then
          private.audio["env"][i] = nil;
        end;
      end;
    end;

    for j = 1, #paths, 1 do
      needtoplay = true;
      for i = 1, #private.audio["env"], 1 do
        if private.audio["env"][i] == paths[j] then
          needtoplay = false;
        end;
      end;

      if needtoplay then
        PlayEnv("assets/"..paths[j],loop,fade);
        private.audio["env"][ #private.audio["env"] + 1 ] = paths[j];
      end;
    end;

  end;

  --------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------
  function public.StopAllEnv(path)
    for i = 1, #private.audio["env"], 1 do
      if ( private.audio["env"][i] ~= nil ) and ( private.audio["env"][i] ~= path ) then
        SndStop("assets/"..private.audio["env"][i],0.5);
        private.audio["env"][i] = nil;
      end;
    end;
  end;
  --------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------
  function public.StopAllMus(path)
    for i = 1, #private.audio["mus"], 1 do
      if ( private.audio["mus"][i] ~= nil ) and ( private.audio["mus"][i] ~= path ) then
        SndStop("assets/"..private.audio["mus"][i],0.5);
        private.audio["mus"][i] = nil;
      end;
    end;
  end;
  --------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------
  function public.StopAllVoc(path)
    for i = 1, #private.audio["voc"], 1 do
      if ( private.audio["voc"][i] ~= nil ) and ( private.audio["voc"][i] ~= path ) then
        SndStop("assets/"..private.audio["voc"][i],0.5);
        private.audio["voc"][i] = nil;
      end;
    end;
  end;
  --------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------
  function public.StopAudio(type,path,fade)
    if not fade then fade = 0; end;
    local shift = 0;
    for i = 1, #private.audio[type], 1 do
      if private.audio[type][i] == path then
        private.audio[type][i] = nil;
        shift = shift + 1;
      else
        private.audio["env"][i-shift] = private.audio["env"][i];
        if shift ~= 0 then
          private.audio["env"][i] = nil;
        end;
      end;
    end;
    SndStop("assets/"..path,fade);
  end;
  --------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------
  function public.StopSound(path,fade)
    local type = tostring(string.sub(path, -3));
    if not fade then fade = 0; end;
    for i = 1, #private.audio[type], 1 do
      if private.audio[type][i] == path then
        private.audio[type][i] = nil;
      end;
    end;
    SndStop("assets/"..path,fade);
  end;
  --------------------------------------------------------------------------------------


--*********************************************************************************************************************
--***function *** Complex Inv *** () end*******************************************************************************
--*********************************************************************************************************************
  function public.ShowComplexItem( inv_name )

    if interface.GetCurrentComplexInv() == "" then

      local objname = "inv_complex_"..inv_name;
      common.CallRoomEventHandlers( objname );
      interface.ComplexInvShow( objname );
      public.DeleteHintFx()

      interface.CheaterUpdateSubroom( objname );

    else

      public.HideComplexItem();

    end;

  end;
  --*********************************************************************************************************************
  function public.HideComplexItem()

    interface.ComplexInvHide();

  end;

  --*********************************************************************************************************************
  function public.InventoryComplexItemAdd( inv_objname, scene_objname, func )

    interface.InventoryItemAdd( inv_objname, scene_objname, func );
    ObjSet( inv_objname, { drag = false } );

  end;

--*********************************************************************************************************************
--*********************************************************************************************************************
-- function *** CHEBOKSARY REST*** () end
--*********************************************************************************************************************
--*********************************************************************************************************************
  function public.GetCurrentPlace()
    local place = interface.GetCurrentComplexInv()
    if place == "" then
      place = common.GetCurrentSubRoom() or common.GetCurrentRoom()
    end
    return place;
  end
  
  
  -->>  проверка состояния плюсика для деплойных инв предметов >>
  function interface.ArrInvPlus()  --иницилизация
    private.arr_invplus = {}
    for i,o in ipairs(game.progress_names) do -- перебор таблицы прогресса
      local obj = common_impl.hint[o]   
      if obj and obj.room == "inv_complex_inv" and not cmn.IsEventDone(o) then
        if not private.arr_invplus[common.GetObjectName(obj.zz_gate)]  then private.arr_invplus[common.GetObjectName(obj.zz_gate)] = {} end
        table.insert(private.arr_invplus[common.GetObjectName(obj.zz_gate)],o)      
      end
    end
    interface.CheckInvPlus()
  end
    function interface.CheckInvPlusOnOff( item, OnOff )
      if OnOff then
        ObjSet( "fx_"..item.."_plus", { active = 1 } )
        if not ObjGet( "fx_"..item.."_plus" ).playing then
          PartSysRestart( "fx_"..item.."_plus" )
        end
        ObjSet( "spr_"..item.."_plus", { res = "assets/interface/resources/int_complex_inv/plus" } )
      else
        PartSysStop("fx_"..item.."_plus",0)
        ObjSet( "spr_"..item.."_plus", { res = "assets/interface/resources/int_complex_inv/plus_na" } )
      end
    end
    function interface.CheckInvPlus_IsInvItemUsable( use_place )
      local item = ld.StringDivide( use_place )[ 3 ]
      if item == "helper" or item == "helperext" then
        return ObjGet( "obj_helper_cursor_drag" ).visible
      else
        return ld.TableContains( ObjGetRelations("obj_int_inventory").childs,"hub_int_inventory_"..item ) and ObjGet( "inv_"..item ).drag and ObjGet( "inv_"..item ).event_mdown == nil
      end
    end
    function interface.CheckInvPlus()  --проверка
      --local t = os.clock()
      local inv_complex_arr = {}
      local inv_complex_arr_not_active = {}  
      local prg = ng_global.currentprogress
      local obj, o
      if not (private.arr_invplus) then return end
      for k,v in pairs(private.arr_invplus) do
        if ld.TableContains( ObjGetRelations("obj_int_inventory").childs,"hub_int_inventory_"..k) then
          for i,o in ipairs(v) do -- перебор таблицы прогресса (game.progress_names)
            obj = common_impl.hint[o]
            if obj and not cmn.IsEventDone(o) and obj.room == "inv_complex_inv" then  -- если объект хинтовый и прогресс не завершен и относится к комплекс объекту
              if obj.type == "get" then
                o = obj.get_obj and ObjGet( obj.get_obj ) or {}
              else
                o = obj.use_place and ObjGet( obj.use_place ) or {}
              end
              if obj.type == "get" and o.input then 
                inv_complex_arr[obj.zz_gate] = true 
              elseif obj.type == "use" 
              and o.input 
              --and ld_impl.SmartHint_IsInvItemUsable( "inv_"..ld.StringDivide( obj.use_place )[ 3 ] )
              and interface.CheckInvPlus_IsInvItemUsable( obj.use_place )
              then 
                inv_complex_arr[obj.zz_gate] = true 
              elseif (obj.type == "click" or obj.type == "win") 
              and o.input then 
                inv_complex_arr[obj.zz_gate] = true 
              elseif not inv_complex_arr[obj.zz_gate] then
                inv_complex_arr_not_active[obj.zz_gate] = true 
              end
            end    
          end
        end
      end
      --ld.LogTrace( "execution CheckInvPlus", os.clock() - t )
      for k,v in pairs(inv_complex_arr) do
        if v then
          inv_complex_arr[k] = false
          inv_complex_arr_not_active[k] = false
          interface.CheckInvPlusOnOff( ld.StringDivide(k)[2], true )
        end
      end
      for k,v in pairs(inv_complex_arr_not_active) do
        if v then
          inv_complex_arr_not_active[k] = false
          interface.CheckInvPlusOnOff( ld.StringDivide(k)[2], false )
        end
      end
      --for i = 1,#inv_complex_arr_not_active do
      --  --ObjSet( "spr_"..ld.StringDivide(inv_complex_arr_not_active[i])[2].."_plus", {color_r=0.3,color_g=0.3,color_b=0.3} );
      --  PartSysStop("fx_"..ld.StringDivide(inv_complex_arr_not_active[i])[2].."_plus",0)
      --end
      --for j = 1,#inv_complex_arr do
      --  --ObjSet( "spr_"..ld.StringDivide(inv_complex_arr[j])[2].."_plus", {color_r=1,color_g=1,color_b=1} );
      --  local fx = "fx_"..ld.StringDivide(inv_complex_arr[j])[2].."_plus"
      --  ObjSet( fx, { active = 1 } )
      --  PartSysRestart(fx)
      --end
    end

  --<<  проверка состояния плюсика для деплойных инв предметов <<

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--**************************************************************************************************************
--***function *** Text *** () end*******************************************************************************
--**************************************************************************************************************
  function public.PrintText ( obj, text_id, time, func_end )
    for i,o in ipairs(private.print) do
      if o.obj == obj then
        table.remove(private.print,i)
      end  
    end
    if ObjGet("tmr_"..obj) then 
     ObjDelete("tmr_"..obj)
    end

    table.insert( private.print, { time = time or 3, text_id = text_id, obj = obj, func_end = func_end } );
    ObjCreate( "tmr_"..obj, "timer" );
    ObjSet( "tmr_"..obj, { input = false } );
    ObjAttach( "tmr_"..obj, obj );
    private.ShowLetter( 1, private.print[ #private.print ] );

  end;
  ---------------------------------------------------------
  function private.ShowLetter ( number, print )

    number = tonumber( number );
    local text = StringGet( print.text_id );
    local length = string.len( text );

    if ( number <= length ) then

      local time = print.time / length;
      local text_sub = string.sub( text, 1, number );
      ObjSet( print.obj, { text = text_sub; disprawtext = true; input = false; } );
      ObjSet( "tmr_"..print.obj, {
        time = time,
        --endtrig = function() PlaySfx( "assets/audio/aud_task_"..math.random(1,6), 0, "", 0.0 ) private.ShowLetter( number + 1, print ); end,
        endtrig = function() private.ShowLetter( number + 1, print ); end,
        playing = 1 } );

    else

      public.ShowText( print.obj )

    end;

  end;
  ---------------------------------------------------------
  function public.ShowText ( obj )

    local print = nil;
    for i = 1, #private.print do

      if ( obj == private.print[ i ].obj ) then

        print = private.print[ i ];
        table.remove( private.print, i );
        break;

      end;

    end;

    if ( print ) then

      ObjDelete( "tmr_"..obj );
      if ( print.func_end ) then
        print.func_end();
      end;
      ObjSet( obj, { text = print.text_id, disprawtext = false } );

    end;

  end;
  --*********************************************************************************************************************


