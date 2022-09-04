-- name=common
--*********************************************************************************************************************
local arrEx = {
["GetCurrentRoom"]=true;
["SoundEnv"]=true;
["SoundEnvHide"]=true;
["SoundEnvInit"]=true;
["SoundHoTheme"]=true;
["SoundMgTheme"]=true;
["SoundSfx"]=true;
["SoundSfxGame"]=true;
["SoundSfxStop"]=true;
["SoundTheme"]=true;
["SoundVid"]=true;
["SoundVoice"]=true;
["SoundIsPlaying"]=true;
["SoundSfxTick"]=true;
["SoundSfxPause"]=true;
["botcontroller_impl"]=true;
["cheater"]=true;
["cmn"]=true;
["common_impl"]=true;
["ld_impl"]=true;
["int"]=true;
["interface"]=true;
["interface_impl"]=true;
["ld"]=true;
["menu"]=true;
["prg"]=true;
["rm_credits"]=true;
["rm_intro"]=true;
["rm_menu"]=true;
["rm_moregames"]=true;
["room"]=true;
["room_impl"]=true;
["subroom"]=true;
["subroom_impl"]=true;
["level"]=true;
["levelext"]=true;
["levelscr"]=true;
["levelsgm"]=true;
["levelexp"]=true;
["game"]=true;
["level_inv"]=true;
["levelext_inv"]=true;
["levelscr_inv"]=true;
["parent_inv"]=true;
["relations_inv"]=true;
["skip_trigger"]=true;
["botcontroller"]=true;

}
--*********************************************************************************************************************
function public.CheckRmMgZz( inp )
  local prefList = {"rm_","mg_","ho_","zz_","int_","inv_","__", "CURSOR_", "Command_", "Event_", "InterfaceWidget_" }
  for i,o in ipairs(prefList) do
    if inp:match("^"..o..".*") then
      --DbgTrace( inp.." is OK" );
      return true
    end
  end
  return false
end
--*********************************************************************************************************************
function public.Start( point, param )

  local on = true -- (true for meta _G table)
  if on and not __G_metaset then
    __G_metaset = true
    DbgTrace("!META!")
    setmetatable(_G,{__newindex =
      function(tval,ival,vval)
        if ival ~= nil then
          if arrEx[ival] or public.CheckRmMgZz( tostring(ival) ) then
            --object in list
          else
            DbgTrace( "Error: Use local: "..tostring(ival) );
          end
          rawset(tval,ival,vval)
        end
      end})

  end

  if point == nil and param == nil then
    private.InitEvents();
    private.SubscribeEvents();
  end;
  -- комната в которую будет грузиться игрок прошедший демо версию и продолжающий сейв на полной(последняя комната первого уровня)
  -- rjvyfnf d rjnjhe. ,entn uhepbnmcz buhjr ghjitlibq ltvj dthcb. b ghjljk;f.obq ctqd yf gjkyjq(gjcktlyzz rjvyfnf gthdjuj ehjdyz)
  private.rebirth_room = "rm_mattapartment"

  private.Init();

  point = point or "menu";
  local path = string.format( "assets/levels/%s/mod_%s", point, point );
  ModLoad( path );
  ld.LogTrace( point, param, path )
  _G[ point ].Start( param, param );

end;
--*********************************************************************************************************************
--*********************************************************************************************************************
function private.Init()
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  -- Инициализация хабов
  cmn = {};
  prg = {};
  --------------------------------------------------------------------
  --cmn.is_inmenunow = nil;
  --------------------------------------------------------------------
  cmn.progress_types = { "std" } --, "ext" , "scr" , "sgm", "exp"};
  cmn.gamemode_types = { "casual", "advanced", "hardcore", "custom" };
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  ModLoad( "assets/shared/mod_room" );
  room.Init();

  ModLoad( "assets/shared/mod_subroom" );
  subroom.Init();

  ModLoad( "assets/interface/mod_interface" );
  interface.Init();

  ModLoad( "assets/levels/common/mod_common_impl" );
  ModLoad( "assets/levels/common/mod_ld_impl" );
  common_impl.Init();
  ld_impl.Init();

  private.InitSubscribers();
  --------------------------------------------------------------------
  ObjCreate( "cmn_timers", "obj" );
  ObjAttach( "cmn_timers", "ng_level_internal" );
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  -- настройка вывода в лог
  if IsCheater() and IsEditor() then
    private.logtrace_enabled = { 1, 0, 1, 1, 1 };
  end;
  private.is_enabled_show_window = true;

  --------------------------------------------------------------------
  function cmn.GetScreenSize ()

    return private.screenSize;

  end;
  --------------------------------------------------------------------
  function cmn.GetGameFieldSize ()

    return private.gameFieldSize;

  end;
  --------------------------------------------------------------------
  function cmn.CorrectCoords ( params )

    local screen_size = cmn.GetScreenSize();
    local field_size  = cmn.GetGameFieldSize();

    local corr_k = { x = screen_size.w / field_size.w, y = screen_size.h / field_size.h };

    if not ( params ) then

      return nil;

    elseif ( #params == 0 ) then

      params.pos_x = params.pos_x * corr_k.x;
      params.pos_y = params.pos_y * corr_k.y;

      return params;

    else

      return { params[ 1 ] * corr_k.x, params[ 2 ] * corr_k.y };

    end;

  end;

  --------------------------------------------------------------------
  function cmn.CorrectCoordsTutorial ( pos )

    local screen_size = cmn.GetScreenSize();
    local field_size = cmn.GetGameFieldSize();
    local coords = { pos_x = pos[1], pos_y = pos[2] };

    local sc = { x = screen_size.w/field_size.w, y = screen_size.h/field_size.h };

    local scale = 1;

    if ( coords.pos_x < ( field_size.w / 2 ) ) then

      --scale = field_size.w / screen_size.w;
      scale = 1 - ( sc.x - 1 );

    else

      --scale = screen_size.w / field_size.w;
      scale = sc.x;

    end;
    --DbgTrace(" scale_x= "..scale);
    coords.pos_x = coords.pos_x * scale;


    if ( coords.pos_y < ( field_size.h / 2 ) ) then

      --scale = field_size.h / screen_size.h;
      scale = 1 - ( sc.y - 1 );

    else

      --scale = screen_size.h / field_size.h;
      --scale = 1 - ( sc.y - 1 );
      scale = sc.y;

    end;
    --DbgTrace(" scale_y= "..scale);
    coords.pos_y = coords.pos_y * scale;

    return { coords.pos_x, coords.pos_y };

  end;
  --------------------------------------------------------------------
  function cmn.GetInterfaceScale ()

    return  private.interfaceScale

  end;
  --------------------------------------------------------------------
  function cmn.CorrectInterfaceScale ( params )

    local screen_size = cmn.GetScreenSize();
    local field_size  = cmn.GetGameFieldSize();
    local scr_scales      = { x = screen_size.w/field_size.w, y = screen_size.h/field_size.h };
    local int_scale   = cmn.GetInterfaceScale();

    params.scale_x = ( params.scale_x/scr_scales.x )*int_scale;
    params.scale_y = ( params.scale_y/scr_scales.y )*int_scale;

    return params;

  end;

  --------------------------------------------------------------------
  --------------------------------------------------------------------
  function private.SetScreenSize ()

    DbgTrace("[SetScreenSize] "..tostring(GetPlatform()));
    private.screenSize = GetScreenSize();
    DbgTrace("[SetScreenSize] private.screenSize.w = "..tostring(private.screenSize.w));
    DbgTrace("[SetScreenSize] private.screenSize.h = "..tostring(private.screenSize.h));

    local interfaceSize = GetInterfaceSize();
    DbgTrace("[SetScreenSize] interfaceSize.w = "..tostring(interfaceSize.w));
    DbgTrace("[SetScreenSize] interfaceSize.h = "..tostring(interfaceSize.h));

  end;
  --------------------------------------------------------------------
  function private.SetInterfaceScale ()

    local screen_size = cmn.GetScreenSize();
    local field_size  = cmn.GetGameFieldSize();
    local scr_scales  = { x = screen_size.w / field_size.w, y = screen_size.h / field_size.h };

    local scale = scr_scales.x;

    if scr_scales.x > scr_scales.y then

      scale = scr_scales.y;

    end;

    private.interfaceScale = scale;

  end;
  --------------------------------------------------------------------
  function private.SetGameFieldSize ()

    local game_size = { w = 1024, h = 768 };

    private.gameFieldSize = game_size;

  end;
  --------------------------------------------------------------------
  private.SetGameFieldSize();
  private.SetScreenSize();
  private.SetInterfaceScale();

end;
--*********************************************************************************************************************
--***function *** Common *** () end************************************************************************************
--*********************************************************************************************************************
  --------------------------------------------------------------------
  -- возвращает имя объекта без префикса
  --------------------------------------------------------------------
  function public.GetObjectName( object )

    local underscore = string.find( object, "_" );
    local name = nil;

    if ( underscore ) then
      name = string.sub( object, ( underscore + 1 ) );
    end;

    return name;

  end;
  --------------------------------------------------------------------
  -- возвращает префикс объекта
  --------------------------------------------------------------------
  function public.GetObjectPrefix( object )

    local underscore = string.find( object, "_" );
    local prefix = nil;

    if ( underscore ) then
      prefix = string.sub( object, 1, ( underscore - 1 ) );
    end;

    return prefix;

  end;
  --------------------------------------------------------------------
  -- условная операция
  --------------------------------------------------------------------
  function public.ConditionChoose( condition, value1, value2 )
    if ( condition ) then
      return value1;
    else
      return value2;
    end;
  end;
  --------------------------------------------------------------------
  -- получение всех параметров объекта кроме имени
  --------------------------------------------------------------------
  function public.GetObjParamsForSet( object )
    local params = ObjGet( object );
    if params then
      params.name = nil;
    end;
    return params;
  end;
  --------------------------------------------------------------------
  function public.LogTrace(...)

    DbgTrace( public.ArgsToString(...) );

  end;

  function public.ArgsToString(...)
    local arg = {...}
    local s = "";

    -->>обработка "квадратного массива"
    local is_map = false
    local elements_count = 0
    if #arg == 1 and type( arg[1] ) == "table" then
      is_map = true
      s = "Вывод квадратного массива:\n"
      local map = arg[1]
      for j = 1, #map do
        if type( map[ j ] ) ~= "table" then
          is_map = false
          break
        else
          for i = 1, #map[ j ] do
            if type( map[ j ][ i ] ) == "table" then
              is_map = false
              break
            end
            s = s.. tostring( map[ j ][ i ] ).."; "
            elements_count = elements_count + 1
          end
          if not is_map then
            break
          end
          s = s.."\n";
        end
      end
    end
    if is_map and elements_count == ld.TableValuesCount( arg[1] ) then
      return s;
    else
      s = "";
    end
    --<<обработка "квадратного массива"

    for i = 1, #arg do

      if #arg > 1 then
        if type( arg[i] ) == "table" then
          --local a = b + c
          s = s.."\n"..tostring( arg[i] )..public.TableString( arg[i], "\t" ).."\n";
        else
          s = s..tostring( arg[i] ).."; ";
        end;
      else
        if type( arg[i] ) == "table" then
          s = s..public.TableString( arg[i], "\t" );
        else
          s = s..tostring( arg[i] );
        end
      end;
    end;

    --передали пустой параметр
    if #arg == 0 then 
      s = "nil"
    end

    return s;
  end

  function public.TableString( t, space )
    space = space or "";
    local s = space
    for k,v in pairs( t ) do
      --local s = space
      if type( v ) == "table" then
        s = s.."\n"..space.."\t"..tostring(k).." :: "..tostring(v);
        s = s..public.TableString( v, space.."\t" )
      else
        s = s.."\n\t"..space..tostring(k).." => "..tostring(v);
      end;
    end;
    return s;
  end;
  --------------------------------------------------------------------
  -- применение в зз
  --------------------------------------------------------------------

  function public.ApplyObj( objname, toobjname, check_inzz, parentobjname )

    if ( subroom_impl.IsAnim ) then return false end;

    if check_inzz and not public.IsInSubRoom() then
      return false;
    elseif not check_inzz and public.IsInSubRoom() then
      return false;
    elseif parentobjname ~= nil then
      return ApplyObj( objname, toobjname, parentobjname );
    else
      return ApplyObj( objname, toobjname );
    end;
  end;

--*********************************************************************************************************************
--***function *** Room - Subroom *** () end****************************************************************************
--*********************************************************************************************************************
  function public.GotoRoom( room_object, need_fade, dontsave )

    local room_current = GetCurrentRoom();

    if  ( not cmn.is_inmenunow )
    and ( not dontsave )
    then

      if not ( "zz" == public.GetObjectPrefix( room_current ) ) then

        private.previousroom = room_current;

      else

        private.previousroom = private.currentroom;

      end;

      private.currentroom = room_object;

      local prg = ng_global.currentprogress;

      ng_global.progress[ prg ].common.currentroom = room_object;

      public.CallRoomEventHandlers( room_object );

    end;

    interface.CheaterUpdateRoom( room_object );

    need_fade = need_fade or 1;

    public.SetMultiTouch(room_object);

    common_impl.GotoRoom( room_object, need_fade, dontsave );

    room.Switch( room_object, need_fade );

  end;
  --------------------------------------------------------------------
  function public.GetCurrentRoom()
--
--    if _G[ "int_cube" ] then
--      local rm = GetCurrentRoom()
--      if rm == "mg_casket" and not int_cube.InCube then
--        int_cube.InCube = true;
--      elseif rm ~= "mg_casket" and int_cube.InCube then
--        int_cube.InCube = false;
--      end
--      if int_cube.InCube then
--        return "mg_casket"
--      end
--    end

    return private.currentroom;

  end;
  --------------------------------------------------------------------
  function public.GetPrevRoom()

    return private.previousroom;

  end;
  --------------------------------------------------------------------
  function public.GotoStartRoom( room_name, forcibly )

    local room_name_saved = ng_global.progress[ ng_global.currentprogress ].common.currentroom or room_name;

    if forcibly == true then
      public.GotoRoom( room_name, 0 );
    else
      public.GotoRoom( room_name_saved, 0 );
    end

  end;
  --------------------------------------------------------------------
  function public.GotoSubRoom( zz_object, pos_beg, pos_end )

    pos_end = pos_end or { 512, 350 };

    local room_current = GetCurrentRoom();

    if ( "zz" == public.GetObjectPrefix( room_current ) ) then

      private.previous_zz = room_current;

    end;

    cmn.current_zz = zz_object;

    interface.CheaterUpdateSubroom( zz_object );

    local zz_params = ObjGet( zz_object );

    pos_beg = pos_beg or GetZoomCursorPos();

    pos_end = pos_end or { zz_params.pos_x, zz_params.pos_y };

    public.SetMultiTouch(zz_object);

    MsgSend( Command_Level_ResetZoomHO );

    common_impl.GotoSubRoom( zz_object, pos_beg, pos_end );

    subroom.Open( zz_object, { x = pos_beg[ 1 ], y = pos_beg[ 2 ] }, { x = pos_end[ 1 ], y = pos_end[ 2 ] } );

  end;
  --------------------------------------------------------------------
  function public.IsInSubRoom()

    return public.GetCurrentSubRoom() ~= nil;

  end;
  --------------------------------------------------------------------
  function public.CloseSubRoom()

    cmn.current_zz = nil;
    subroom.Close();

  end;
  --------------------------------------------------------------------
  function public.GetCurrentSubRoom()

    return cmn.current_zz;

  end;
  --------------------------------------------------------------------
  function public.GetPrevSubRoom()

    return private.previous_zz;

  end;

  --------------------------------------------------------------------

--*********************************************************************************************************************
--***function *** Cursor *** () end************************************************************************************
--*********************************************************************************************************************
  private.cursors_count = 0;
  --------------------------------------------------------------------
  function public.CursorLoad( cur_name, cur_path, cur_idx )

    _G[ cur_name ] = private.cursors_count;
    CursorLoad( cur_path, cur_idx );
    private.cursors_count = private.cursors_count + 1;

  end;
--*********************************************************************************************************************
--***function *** Cheater *** () end***********************************************************************************
--*********************************************************************************************************************
  private.cheater_key_f = {};
  --------------------------------------------------------------------
  function public.SetCheaterKeyF( key_id, level, prg_elem, startroom )

    private.cheater_key_f[ "F"..key_id ] = { level = level, prg_elem = prg_elem, startroom = startroom };

    -->> Bot BonusEnable
      if key_id == 4 and botcontroller then
        botcontroller.BonusEnabled( true )
      end
    --<< Bot BonusEnable

  end;
  --------------------------------------------------------------------
  function private.CheaterReset()

    if IsCheater() then

      if _G[ "cheater" ] then cheater.Destroy(); end
      ModLoad( "assets/shared/cheater/mod_cheater" );
      if _G[ "cheater" ] then cheater.Init(); end

    end;

  end;
--*********************************************************************************************************************
--***function *** Project *** () end***********************************************************************************
--*********************************************************************************************************************
  function public.ProjectSet()

    private.project = {};

    local project_name_id = "window_title";
    if ( IsCollectorsEdition() ) then
      project_name_id = project_name_id.."_ce";
    end;

    private.project.name = StringGet( project_name_id );
    private.project.version = ConfigGetProjectVersion();

    if not ( private.menu.is_fromgame ) then
      private.ProjectVersion();
    end;

    private.CheaterReset();

  end;
  --------------------------------------------------------------------
  function private.ProjectVersion()

    local projectname = private.project.name;
    local projectversion = private.project.version;
    local versiontype = "";

    if ( IsCollectorsEdition() ) then
      versiontype = versiontype.."COLLECTORS ";
    end;

    if ( IsDemoEdition() ) then
      versiontype = versiontype.."DEMO ";
    end;

    if ( IsSurveyEdition() ) then
      versiontype = versiontype.."SURVEY ";
    end;

    if ( IsCheater() ) then
      versiontype = versiontype.."CHEATER ";
    end;

    if ( not versiontype ) then
      versiontype = "NONE ";
    end;

    DbgTrace( "********************************************************************************************" );
    DbgTrace( string.format( "Project < %s > version: %s ( %s).", projectname, projectversion, versiontype ) );
    DbgTrace( "********************************************************************************************" );

  end;
--*********************************************************************************************************************
--***function *** Settings *** () end**********************************************************************************
--*********************************************************************************************************************
  function private.UpdateGameMode( gamemode )
    if ( gamemode == 3 ) and ( ng_global.gamemode == 3 and ng_global.gamemode_custom[ "sparkle_area" ] )then
      gamemode = 0;
    end;
    common_impl.UpdateGameMode( gamemode );
    MsgSend( Command_Interface_UpdateGameMode, { mode = gamemode } );

  end;
  -------------------------------------------------------------------------------------
  function public.GetGameMode()
    if ng_global.gamemode then return ng_global.gamemode else return 0; end;
  end;
  -------------------------------------------------------------------------------------
  function private.SaveInterfaceTimers()

    local room = common.GetCurrentSubRoom() or GetCurrentRoom();

    local prg_type = ng_global.currentprogress;
    local current_progress = ng_global.progress[ prg_type ];

    local room_type = public.GetObjectPrefix( room );
    if cmn.current_mg then

      local prg_name = "win_"..cmn.current_mg;

      if  ( current_progress[ prg_name ].start == 1 )
      and ( current_progress[ prg_name ].done == 0 )
      then

        current_progress[ prg_name ].skiptimer = interface.ButtonSkipGetTime();
        DbgTrace( "save skip for < "..prg_name.." > =  "..current_progress[ prg_name ].skiptimer );

      end;
--    elseif ( room_type == "mg" ) or ( room_type == "zz" ) then
--
--      local prg_name = "win_"..public.GetObjectName( room );
--
--      if  ( current_progress[ prg_name ].start == 1 )
--      and ( current_progress[ prg_name ].done == 0 )
--      then
--
--        current_progress[ prg_name ].skiptimer = interface.ButtonSkipGetTime();
--        DbgTrace( "save skip for < "..prg_name.." > =  "..current_progress[ prg_name ].skiptimer );
--
--      end;
--

    end;

    current_progress.common.hinttimer = interface.ButtonHintGetTime();
    DbgTrace( "Save HINT = "..current_progress.common.hinttimer );

    common_impl.SaveInterfaceTimers();

  end;
--*********************************************************************************************************************
--***function *** Sound *** () end*************************************************************************************
--*********************************************************************************************************************
  -- Проигрывание озвучки видео ( стримится ).
  function PlaySfxTrack( path, loop, fade )

    SndPlay( path, "sfx", loop or 0, 0, fade or 0 );

  end;
--*********************************************************************************************************************
--***function *** Check *** () end*************************************************************************************
--*********************************************************************************************************************
  -- функция проверки наличия аудиустройства
  function private.SoundDeviceCheck()

    public.LogTrace( "[ 2 ] Проверка аудиоустройства.: "..tostring( IsNoSoundDevice() ) );

    private.is_sounddevicechecked = true;

    if ( IsNoSoundDevice() and not private.menu.is_fromgame ) then

      private.is_enabled_show_window = false;
      public.DialogWindowShow( "common", "noaudio" );

    else

      private.ProfileSet( GetCurrentProfile() );

    end

  end;
  --------------------------------------------------------------------
  -- функция проверки на автоматическую смену фуллскрина
  function private.CheckForceFullScreen()

    public.LogTrace( "[ 2 ] Проверка на автоматическую смену фуллскрина." );

    if ( IsForceFullscreen() and not private.menu.is_fromgame ) then

      public.DialogWindowShow( "togglescreen", nil, false );

    else

      private.SoundDeviceCheck();

    end

  end;
  --------------------------------------------------------------------
  private.fps = {};
  private.fps.is_checkdone = false;
  private.fps.time = 1;
  --------------------------------------------------------------------
  -- функция проверки FPS
  function private.fps.Check( is_showagain )

    ObjSet( "tmr_common_fps", { playing = false } );
    ObjDelete( "tmr_common_fps" );

    local is_needtoshow = false;

    if ( ( is_showagain ) or ( not private.fps.is_checkdone ) )
      and ( not private.menu.is_fromgame ) then

      is_needtoshow = true;

    end;

    if  ( cmn.is_inmenunow )
    and ( GetPerformanceMode() == 0 )
    and ( GetFPS() < 25 )
    and ( is_needtoshow )
    then

      private.fps.is_checkdone = true;
      public.DialogWindowShow( "common", "fpscheck" );

    end;

  end;
--*********************************************************************************************************************
--****function *** Dialog *** () end***********************************************************************************
--*********************************************************************************************************************
  function public.DialogWindowShow( dlgname, trgparam, showfromcursor )

    local objname = "wnd_dialog_"..dlgname;
    local pos_beg = { 512, 384 };

    if ( showfromcursor ) then
      pos_beg = GetGameCursorPos();
    end;

    interface.WindowShow( "assets/levels/common/mod_common_impl",
                    "common_impl",
                    objname,
                    function () public.dialog[ dlgname ].Open( trgparam or "", pos_beg ); end );

  end;
  --------------------------------------------------------------------
  function public.DialogWindowHide( dlgname )

    local objname = "wnd_dialog_"..dlgname;
    interface.WindowHide( objname );

  end;
  --------------------------------------------------------------------
  -- инициализация функций окон
  public.dialog = {};
  --------------------------------------------------------------------
  function public.dialog.ButtonMouseDown( dialog_name, dialog_button, param )

    common_impl.DialogButtonMouseDown( dialog_name, dialog_button, param );
    public.dialog[ dialog_name ].ButtonMouseDown( dialog_button, param );

  end;
  --------------------------------------------------------------------
  function public.dialog.ButtonsSet( dialog_name, t_button_param, index )

    local t_button_name = { "left", "center", "right" };

    for i = 1, #t_button_name do

      local state = t_button_param[ index ][ i ];

      ObjSet( "dialog_"..dialog_name.."_button_"..t_button_name[ i ],
      {
        active  = state,
        visible = state,
        input   = state
      } );

    end;

  end;
--*********************************************************************************************************************
--***function *** - common: () end ************************************************************************************
--*********************************************************************************************************************
  --
  --[[
    МАССИВ СТАНДАРТНЫХ ДИАЛОГОВ
    Формат: ИМЯ_ДИАЛОГА = { left, center, right, trg_open };
    Параметры кнопок ( left, center, right ) - массив из двух элементов,
      первый элемент - текст кнопки, второй элемент - триггер на клик.
      ВАЖНО: триггер должен иметь название "trg_dialog_common_"..DOWNTRGNAME,
      причем в параметре указывается только DOWNTRGNAME.
    Триггер на открытие диалога ( trg_open ).
      ВАЖНО: триггер должен иметь название "trg_dialog_common_"..OPENTRGNAME.."_open",
      причем в параметре указывается только OPENTRGNAME.
  ]]
  --------------------------------------------------------------------
  public.dialog.common = {};
  --------------------------------------------------------------------
  public.dialog.common.buttons =
  {
    -- нет звукового устройства
    noaudio      = { left = nil, center = { text = "ok", func = "NoAudio" }, right = nil },
    -- профиль поврежден
    corrupt      = { left = nil, center = { text = "ok", func = "Corrupt" }, right = nil },
    -- выход из приложения
    quit         = { left = { text = "yes", func = "Quit" }, center = nil, right = { text = "no", func = "Close" } },
    -- конфирмация выхода из игры в меню
    optionsquit         = { left = { text = "yes", func = "OptionsQuit" }, center = nil, right = { text = "no", func = "Close" } },
    -- поле ввода имени профиля не заполнено
    emptyfield   = { left = nil, center = { text = "ok", func = "Close" }, right = nil },
    -- профиль уже существует
    existprofile = { left = nil, center = { text = "ok", func = "Close" }, right = nil },
    -- удаление профиля
    delprofile   = { left = { text = "yes", func = "DelProfile" }, center = nil, right = { text = "no", func = "Close" } },
    -- сброс прогресса игры
    reset        = { left = { text = "yes", func = "Reset" }, center = nil, right = { text = "no", func = "Close" } },
    -- диалог first playable
    thxplaying   = { left = nil, center = { text = "ok", func = "ThxPlaying" }, right = nil },
    -- проверка производительности
    fpscheck     = { left = { text = "yes", func = "PerfModeOff" }, center = nil, right = { text = "no", func = "Close" } },

    --сообщение о выигрыше
    complete_std = {left = nil, center = { text = "ok", func = "Close" }, right = nil },
    complete_std_se = {left = nil, center = { text = "ok", func = "Close" }, right = nil },

  };
  --------------------------------------------------------------------
  function public.dialog.common.Open ( dialog_type )

    public.dialog.common.current = dialog_type;

    ObjSet( "txt_dialog_common", { text = "str_dialog_common_"..dialog_type, visible = true } );

    local buttons = { "left", "center", "right" };

    for i = 1, 3, 1 do

      local button_name = "dialog_common_button_"..buttons[ i ];

      local button_params = public.dialog.common.buttons[ dialog_type ][ buttons[ i ] ];

      if ( button_params ) then

        ObjSet( "txt_"..button_name, { text = "str_common_"..button_params.text } );

        local func = function ()

          public.dialog.ButtonMouseDown( "common", buttons[ i ] );

        end;

        ObjSet( button_name,
        {
          event_mdown = func,
          visible = true,
          input = true
        } );

      else

        ObjSet( button_name, { event_mdown = "", visible = false, input = false  });

      end;

    end;

  end;
  --------------------------------------------------------------------
  function public.dialog.common.Close()

    public.DialogWindowHide( "common" );

  end;
  --------------------------------------------------------------------
  function public.dialog.common.ButtonMouseDown ( button )

    local func_string = public.dialog.common.buttons[ public.dialog.common.current ][ button ].func;

    public.dialog.common[ func_string ]();

  end;
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  function public.dialog.common.NoAudio()

    public.dialog.common.Close();

    private.is_enabled_show_window = true;
    private.ProfileSet( GetCurrentProfile() );

  end;
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  function public.dialog.common.Corrupt()

    public.dialog.common.Close();
    local profiles = GetProfileList();
    if ( #profiles == 0 ) then
      public.LogTrace( "[ - ] Закрытие диалога < corrupt >: нет профилей." );
      public.DialogWindowShow( "addprofile", "new" );
    else
      private.ProfileSet( GetCurrentProfile() );
    end;

  end;
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  function public.dialog.common.DelProfile()

    -- получаем список профилей
    local profiles = GetProfileList();

    -- получаем текущий
    local current = GetCurrentProfile();

    local is_current_selected = false;

    if ( profiles[ public.dialog.profile.current ] == current ) then

      is_current_selected = true;

    end;

    for i = 1, #profiles do
      public.LogTrace( "2 "..profiles[i] );
    end;
    -- удаляем выделенный профиль
    DeleteProfile( profiles[ public.dialog.profile.current ] );

    public.dialog.common.Close();

    -- обновляем после удаления
    local profiles = GetProfileList();
    -- проверяем профили: если нет, выводим создание нового
    if #profiles == 0 then

      public.dialog.addprofile.is_fromdialogprofile = true;
      public.DialogWindowShow( "addprofile", "new", true );

    else

      public.dialog.profile.current = 1;

      if ( not is_current_selected ) then

        for i = 1, #profiles, 1 do

          if ( profiles[ i ] == current ) then

            public.dialog.profile.current = i;
            break;

          end;

        end;

      end;

      private.ProfileSet( profiles[ public.dialog.profile.current ] );

    end;

    public.dialog.profile.Open();

  end;
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  function public.dialog.common.Reset()

    local prg = public.dialog.playchoice.resetprogress;
    local commonsave = ng_global.progress[ prg ].common;
    ng_global.currentprogress = prg
    private.ProgressReset( prg, commonsave );

    SaveProfiles();

    public.dialog.common.Close();
    public.DialogWindowShow( "gamemode", "newgame" );

  end;
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  function public.dialog.common.PerfModeOff()

    SetPerformanceMode( 1 );
    public.dialog.common.Close();

  end;
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  function public.dialog.common.ThxPlaying()

    public.dialog.common.Close();

  end;
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  function public.dialog.common.Quit()

    Quit();

  end;
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  function public.dialog.common.OptionsQuit()

    public.DialogWindowHide( "options" );
    private.ApplicationClose();
    SetCursor( CURSOR_DEFAULT );
    public.LevelSwitch( "menu", "game" );

  end;
--*********************************************************************************************************************
--***function *** - addprofile: () end*********************************************************************************
--*********************************************************************************************************************
  --------------------------------------------------------------------
  public.dialog.addprofile = {};
  public.dialog.addprofile.is_fromdialogprofile = false;
  --------------------------------------------------------------------
  function public.dialog.addprofile.Open( command )

    public.LogTrace( "addprofile command = "..command );

    local ted_name = "ted_dialog_addprofile";

    --было сделано для решения какого-то бага не помню какого, попробуем закомментировать
    --ObjAttach(ted_name,"spr_dialog_profile")
    --ObjAttach(ted_name,"spr_dialog_addprofile")

    ObjSet( ted_name, { text = "Player", visible = true } );

    local t_button_param = { new = { false, true, false }, add = { true, false, true } };
    public.dialog.ButtonsSet( "addprofile", t_button_param, command );

  end;
  --------------------------------------------------------------------
  function public.dialog.addprofile.Down()
    public.LogTrace( "[ - ] Создание профиля." );
    local profilename = private.ProfileNameTrim( ObjGet( "ted_dialog_addprofile" ).text );

    if ( profilename == "" ) then

      public.LogTrace( "[ - ] Создание профиля: пустое поле." );
      public.DialogWindowShow( "common", "emptyfield", true );

    else

      local profile_exist = false;

      local profilename_low = string.lower( profilename );

      local profile_list = GetProfileList();

      for p = 1, #profile_list do

        if ( string.lower( profile_list[ p ] ) == profilename_low ) then

          profile_exist = true;

          break;

        end;

      end;

      if ( profile_exist ) or ( AddProfile( profilename ) == 0 ) then


        public.LogTrace( "[ - ] Создание профиля: профиль уже существует." );
        public.DialogWindowShow( "common", "existprofile", true );

      else

        public.LogTrace( "[ - ] Создание профиля: профиль создан, установка профиля." );

        local profiles = GetProfileList();
        public.dialog.profile.current = #profiles;
        private.ProfileSet( profiles[ public.dialog.profile.current ], true );

        if ( public.dialog.addprofile.is_fromdialogprofile ) then
          public.dialog.addprofile.is_fromdialogprofile = false;
          public.dialog.profile.Open();
        end

        public.LogTrace( "[ - ] Создание профиля: закрытие окна." );
        public.dialog.addprofile.Close();

      end
    end

  end
  --------------------------------------------------------------------
  function public.dialog.addprofile.Close()

    public.DialogWindowHide( "addprofile" );

  end;
  --------------------------------------------------------------------
  function public.dialog.addprofile.ButtonMouseDown( button )

    if ( button == "left" ) or ( button == "center" ) then

      public.dialog.addprofile.Down();

    elseif ( button == "right" ) then

      public.dialog.addprofile.Close();

    end;

  end;
--*********************************************************************************************************************
--***function *** - profile: () end************************************************************************************
--*********************************************************************************************************************
  public.dialog.profile = {};
  public.dialog.profile.current = 1;
  public.dialog.profile.profiles_count = 6;
  --------------------------------------------------------------------
  function public.dialog.profile.Open()

    public.LogTrace( "[ - ] Открытие/обновление окна профилей." );
    local profiles = GetProfileList();
    local current_profile = GetCurrentProfile();
    for i = 1, public.dialog.profile.profiles_count, 1 do

      local profile_name = profiles[ i ] or "";
      local profile_input = false;

      if ( profile_name ~= "" ) then

        profile_input = true;

      end;

      ObjSet( "txt_dialog_profile_names_"..i, { text = profile_name, input = profile_input } );

      if ( profile_name == current_profile ) then

        public.dialog.profile.current = i;

      end;

    end;

    local text_object = "obj_dialog_profile_names_"..public.dialog.profile.current;

    local text_params = ObjGet( text_object );

    ObjSet( "spr_dialog_profile_names_focus",
    {
      pos_x = text_params.pos_x,
      pos_y = text_params.pos_y
    } );

    if #profiles > ( public.dialog.profile.profiles_count - 1 ) then

      ObjSet( "dialog_profile_button_center", { input = false, color_r = 0.5, color_g = 0.5, color_b = 0.5 } );

    else

      ObjSet( "dialog_profile_button_center", { input = true, color_r = 1, color_g = 1, color_b = 1 } );

    end;

  end;
  --------------------------------------------------------------------
  function public.dialog.profile.NameDown( place_number )

    local profile_name = "obj_dialog_profile_names_"..place_number;
    public.dialog.profile.current = place_number;

    ObjSet( "spr_dialog_profile_names_focus", {
        pos_x = ObjGet( profile_name ).pos_x,
        pos_y = ObjGet( profile_name ).pos_y });

  end;
  --------------------------------------------------------------------
  function public.dialog.profile.OkDown()

    public.DialogWindowHide( "profile" );

    local profiles = GetProfileList();
    private.ProfileSet( profiles[ public.dialog.profile.current ] );

  end;
  --------------------------------------------------------------------
  function public.dialog.profile.NewDown()

    public.LogTrace( "[ - ] Создание нового профиля из окна профиля." );

    public.dialog.addprofile.is_fromdialogprofile = true;
    public.DialogWindowShow( "addprofile", "add", true );

  end;
  --------------------------------------------------------------------
  function public.dialog.profile.DeleteDown()

    public.DialogWindowShow( "common", "delprofile", true );

  end;
  --------------------------------------------------------------------
  function public.dialog.profile.ButtonMouseDown( button, param )

    if ( button == "name" ) then

      public.dialog.profile.NameDown( param );

    elseif ( button == "left" ) then

      public.dialog.profile.OkDown();

    elseif ( button == "center" ) then

      public.dialog.profile.NewDown();

    elseif ( button == "right" ) then

      public.dialog.profile.DeleteDown();

    end;

  end;
--*********************************************************************************************************************
--***function *** - playchoice: () end*********************************************************************************
--*********************************************************************************************************************
  public.dialog.playchoice = {};
  public.dialog.playchoice.resetprogress = "";
  --------------------------------------------------------------------
  function public.dialog.playchoice.Open()

    if ( not ng_global.progress[ "std" ].common.gamewin ) or not IsCollectorsEdition() then


      ObjSet( "spr_dialog_playchoice_std", { pos_x = 0 } );
      ObjSet( "spr_dialog_playchoice_ext", { pos_x = 0, input = false, visible = false } );

    else


      ObjSet( "spr_dialog_playchoice_std", { pos_x = -200 } );
      ObjSet( "spr_dialog_playchoice_ext", { pos_x = 200, input = true, visible = true } );
    end;

    local prg = { "std", "ext", "scr" };

    for i = 1, #prg, 1 do

      local currentroom  = ng_global.progress[ prg[i] ].common.currentroom;
      local level = ng_global.progress[ prg[i] ].common.chapter;

      -->> After Demo >>--
      if currentroom == "rm_outro" then
        if not (IsDemoEdition() or IsSurveyEdition()) then
          currentroom = private.rebirth_room
        end
      end
      --<< After Demo <<--

      local playchoice_params =
      {
        text = "str_dialog_playchoice_continue",
        res  = "assets/levels/"..level.."/"..( currentroom or "" ).."/miniback"..ld.GetMinibackPostfixForRoom( currentroom, prg[i] ),
        input = true
      };

      if ( not ng_global.progress[ prg[i] ].common.gamestart ) then

        playchoice_params.text  = "str_dialog_playchoice_play";
        playchoice_params.res   = "assets/levels/common/playchoice/playchoice_"..prg[ i ].."_miniback";
        playchoice_params.input = false;

      end;

      ObjSet( "txt_dialog_playchoice_"..prg[ i ].."_button_play",  { text  = playchoice_params.text  } );
      ObjSet( "spr_dialog_playchoice_"..prg[ i ].."_button_reset", { input = playchoice_params.input } );
      ObjSet( "spr_dialog_playchoice_"..prg[ i ].."_miniback",     { res   = playchoice_params.res   } );

      -->>gray reset
      if not public.dialog.playchoice.txt_dialog_playchoice_color then
        public.dialog.playchoice.txt_dialog_playchoice_color = ObjGet( "txt_dialog_playchoice_"..prg[ i ].."_button_reset" )
      end;
      local clr = public.dialog.playchoice.txt_dialog_playchoice_color
      local gray_r = playchoice_params.input and clr.color_r or 0.4;
      local gray_g = playchoice_params.input and clr.color_g or 0.4;
      local gray_b = playchoice_params.input and clr.color_b or 0.4;
      ObjSet( "txt_dialog_playchoice_"..prg[ i ].."_button_reset", { color_r = gray_r; color_g = gray_g; color_b = gray_b; } );
      ObjSet( "spr_dialog_playchoice_"..prg[ i ].."_button_reset_off", { visible = not playchoice_params.input } )
      --<<gray reset
    end;

  end;
  --------------------------------------------------------------------
  function public.dialog.playchoice.Play( prg )

    public.DialogWindowHide( "playchoice" );
    
    local function func_end()
      ng_global.currentprogress = prg;

      if ( not ng_global.progress[ prg ].common.gamestart ) then
        ng_global.progress[ prg ].common.gamestart = true;
      end;

      SetCursor( CURSOR_DEFAULT );
      local level = ng_global.progress[ prg ].common.chapter;
      cmn.is_inmenunow = false;

        -->> After Demo >>--
        if ng_global.progress[ prg ].common.currentroom == "rm_outro" then
          if not (IsDemoEdition() or IsSurveyEdition()) then
            ng_global.progress[ prg ].common.currentroom = private.rebirth_room
          end
        end
        --<< After Demo <<--

      public.LevelSwitch( level );
    end
    func_end()

  end;
  --------------------------------------------------------------------
  function public.dialog.playchoice.Reset( prg )

    public.dialog.playchoice.resetprogress = prg;
    public.DialogWindowShow( "common", "reset", true );

  end;
  --------------------------------------------------------------------
  function public.dialog.playchoice.Close()

    public.DialogWindowHide( "playchoice" );

  end;
  --------------------------------------------------------------------
  function public.dialog.playchoice.ButtonMouseDown( button, param )

    if ( button == "center" ) then

      public.dialog.playchoice.Close();

    elseif ( button == "play" ) then

      if ( (not ng_global.progress[ param ].common.gamestart ) and ( ng_global.progress[ param ].common.gamewin ) ) then
        public.dialog.playchoice.Reset( param );
      else
        if ( (not ng_global.progress[ param ].common.gamestart ) and (not ng_global.progress[ param ].common.gamewin ) ) then
          ng_global.currentprogress = param
          public.DialogWindowShow( "gamemode", "newgame", true );
        else
          public.dialog.playchoice.Play( param );
        end
      end
    elseif ( button == "reset" ) then

      public.dialog.playchoice.Reset( param );

    end;

  end;
--*********************************************************************************************************************
--***function *** - gamemode: () end***********************************************************************************
--*********************************************************************************************************************
  public.dialog.gamemode = {};
  ng_global.gamemode = 1;
  --------------------------------------------------------------------
  function public.dialog.gamemode.Open( sender_name )

    local t_button_param = { newgame = { false, true, false }, options = { true, false, true } };
    public.dialog.ButtonsSet( "gamemode", t_button_param, sender_name );

    public.dialog.gamemode.CheckDown( cmn.gamemode_types[ ng_global.gamemode + 1 ] );

  end;
  --------------------------------------------------------------------
  function public.dialog.gamemode.Close( sender_name )

    public.DialogWindowHide( "gamemode" );

    if ( sender_name ~= "right" ) then

      for i = 1, #cmn.gamemode_types do

        local gamemode_type = cmn.gamemode_types[ i ];

        if ( ObjGet( "spr_dialog_gamemode_"..gamemode_type.."_check_light" ).alp == 1 ) then

          ng_global.gamemode = i - 1;
          private.UpdateGameMode( ng_global.gamemode );

          break;

        end;

      end;

    end;

    if ( sender_name == "left" ) then

      public.dialog.options.Open( "gamemode" );

    elseif ( sender_name == "center" ) then

      SetCursor( CURSOR_NULL );
      local function func_end()  
        local prg = ng_global.currentprogress;
        local level = ng_global.progress[ prg ].common.chapter;
        ng_global.progress[ prg ].common.gamestart = true;
        cmn.is_inmenunow = false;
        public.LevelSwitch( level );
      end
      if ObjGetRelations( "wnd_dialog_playchoice" ).parent == "int_window_hub" then
        public.DialogWindowHide( "playchoice" );
      end
      rm_menu.DynamicStart(func_end)

    end;

  end;
  --------------------------------------------------------------------
  function public.dialog.gamemode.ButtonMouseDown( button, param )

    if ( button == "check" ) then

      public.dialog.gamemode.CheckDown( param );


      if ( param == "custom" ) then

        public.DialogWindowShow( "gamemode_custom", "gamemode", true );

      end;

    else

      public.dialog.gamemode.Close( button );

    end;

  end;
  --------------------------------------------------------------------
  function public.dialog.gamemode.CheckDown( gamemode_name )

    for i = 1, #cmn.gamemode_types do

      local check_alp = 0;

      if ( cmn.gamemode_types[ i ] == gamemode_name ) then

        check_alp = 1;

      end;

      ObjSet( "spr_dialog_gamemode_"..cmn.gamemode_types[ i ].."_check_light", { alp = check_alp } );

    end;

  end;
--*********************************************************************************************************************
--***function *** - gamemode_custom: () end****************************************************************************
--*********************************************************************************************************************
  public.dialog.gamemode_custom = {}
  public.dialog.gamemode_custom.slider_width = 185;
  public.dialog.gamemode_custom.slider_startoffs = 15;--do not change
  public.dialog.gamemode_custom.slider_offx = 0;

  function public.dialog.gamemode_custom.Open( sender_name )

    local t_button_param = { gamemode = { false, true, false } };
    public.dialog.ButtonsSet( "gamemode_custom", t_button_param, "gamemode" );
    for item_name, value in pairs( ng_global.gamemode_custom ) do
      public.dialog.gamemode_custom.CheckDown( item_name, true );
    end;
    local slidertype = { "hint", "skip" };
    for i = 1, #slidertype do

      local new_x = ( ng_global.gamemode_custom[ slidertype[ i ].."_value" ] - public.dialog.gamemode_custom.slider_startoffs ) * public.dialog.gamemode_custom.slider_width / 75;
      ObjSet(     "dialog_gamemode_custom_"..slidertype[ i ].."_scroll_slider", { pos_x = new_x } );
      ObjSet( "spr_dialog_gamemode_custom_"..slidertype[ i ].."_scroll_slider", { pos_x = new_x } );

    end;

  end;
  --------------------------------------------------------------------
  function public.dialog.gamemode_custom.Close( sender_name )

    public.DialogWindowHide( "gamemode_custom" );
    private.UpdateGameMode( ng_global.gamemode );

  end;
  --------------------------------------------------------------------
  function public.dialog.gamemode_custom.ButtonMouseDown( button, param )

    if ( button == "check" ) then

      public.dialog.gamemode_custom.CheckDown( param );

    else

      public.dialog.gamemode_custom.Close( button );

    end;

  end;
  --------------------------------------------------------------------
  function public.dialog.gamemode_custom.CheckDown( custom_name, flag_save )

    if ( not flag_save ) then
      ng_global.gamemode_custom[ custom_name ] = not ng_global.gamemode_custom[ custom_name ];
    end;

    ObjSet( "spr_dialog_gamemode_custom_"..custom_name.."_check_light", { visible = ng_global.gamemode_custom[ custom_name ] } );

  end;
  --------------------------------------------------------------------
  function public.dialog.gamemode_custom.ScrollDown( scroll_name )

    -- позиция объекта относительно главного объекта
    local slider_objname = "dialog_gamemode_custom_"..scroll_name.."_scroll_slider";
    local obj_x = GetObjPosByObj( "spr_"..slider_objname )[ 1 ];

    local cur_x = GetGameCursorPos()[ 1 ];
    local off_x = cur_x - obj_x;

    local new_x = ObjGet( "spr_"..slider_objname ).pos_x + off_x;

    if ( new_x < 0 ) then new_x = 0; end;
    if ( new_x > public.dialog.gamemode_custom.slider_width ) then new_x = public.dialog.gamemode_custom.slider_width; end;

    ObjSet( slider_objname, { pos_x = new_x });

    public.dialog.gamemode_custom.ScrollSet( scroll_name, new_x );

  end;
  --------------------------------------------------------------------
  function public.dialog.gamemode_custom.ScrollDrag( scroll_name )

    SetCursor( CURSOR_HAND );

    local cur_pos = GetGameCursorPos();

    if ( not public.dialog.gamemode_custom.is_slider_startdrag ) then
      public.dialog.gamemode_custom.is_slider_startdrag = true;
      local obj_x = ObjGet( "dialog_gamemode_custom_"..scroll_name.."_scroll_slider" ).pos_x;
      public.dialog.gamemode_custom.slider_offx = cur_pos[ 1 ] - obj_x;
    end;

    local new_x = cur_pos[ 1 ] - public.dialog.gamemode_custom.slider_offx;

    if ( new_x < 0 ) then new_x = 0; end;
    if ( new_x > public.dialog.gamemode_custom.slider_width ) then new_x = public.dialog.gamemode_custom.slider_width; end;

    public.dialog.gamemode_custom.ScrollSet( scroll_name, new_x );

  end;
  --------------------------------------------------------------------
  function public.dialog.gamemode_custom.ScrollDrop( scroll_name )

    -- драг завершен
    public.dialog.gamemode_custom.is_slider_startdrag = false;

    local new_x = ObjGet( "spr_dialog_gamemode_custom_"..scroll_name.."_scroll_slider" ).pos_x;
    local new_y = ObjGet( "spr_dialog_gamemode_custom_"..scroll_name.."_scroll_slider" ).pos_y;

    -- возвращаем drag-объект в позиции слайдера
    ObjSet( "dialog_gamemode_custom_"..scroll_name.."_scroll_slider", { pos_x = new_x, pos_y = new_y });

    public.dialog.gamemode_custom.ScrollSet( scroll_name, new_x );

  end;
  --------------------------------------------------------------------
  function public.dialog.gamemode_custom.ScrollSet( scroll_name, new_x )

    ObjSet( "spr_dialog_gamemode_custom_"..scroll_name.."_scroll_slider", { pos_x = new_x } );

    ng_global.gamemode_custom[ scroll_name.."_value" ] = math.floor( 75*new_x / public.dialog.gamemode_custom.slider_width ) + public.dialog.gamemode_custom.slider_startoffs;

  end;

--*********************************************************************************************************************
--***function *** - options: () end************************************************************************************
--*********************************************************************************************************************
  public.dialog.options = {};
  public.dialog.options.slider_width = 185;
  public.dialog.options.slider_offx = 0;
  public.dialog.options.is_slider_startdrag = false;
  public.dialog.options.is_slider_startplay = { mus = false, voc = false, sfx = false, env = false };
  --------------------------------------------------------------------
  function public.dialog.options.Open( sender_name )

    public.LogTrace( "[ - ] Вызов окна опций из [ "..sender_name.." ]." );

    ObjSet( "txt_dialog_options_info", { text = GetEngineVersion().."/"..ConfigGetProjectVersion() } );

    --установка режима сложности
   -- ObjSet( "txt_dialog_options_button_gamemode_mode", { text = "str_dialog_"..cmn.gamemode_types[ ng_global.gamemode + 1 ] } );
    --убираем опцию widescreen для Мак, фиши часто выписывают этот баг, но QA Lead(Колян) сказал убрать
    --if GetPlatform()=="mac" then
    --  ObjSet( "dialog_options_widescreen", {input=0} );
    --  ObjSet( "spr_dialog_options_widescreen_check", {visible = 0} );
    --  ObjSet( "txt_dialog_options_widescreen", {visible = 0} );
    --  ObjSet( "spr_dialog_options_widescreen_tr", {visible = 1,alp=1} );
    --end
    -- если триггер вызван не из окна режима игры, устанавливаем все объекты
    if ( sender_name ~= "gamemode" ) then

      -- установка кнопок
      local t_button_param = { menu = { false, true, false }, game = { true, false, true } };
      public.dialog.ButtonsSet( "options", t_button_param, sender_name );
      ObjSet( "dialog_options_button_ ", {event_mdown = function() common.dialog.ButtonMouseDown( "options", "credits",sender_name ); end} );
      -- установка громкости
      local slidertype = { "sfx", "env", "mus", "voc", "gamma" };
      local new_x = 0;
      for i = 1, #slidertype, 1 do

        if ( i == #slidertype ) then
          new_x = ( GetGamma() - 0.5 ) * public.dialog.options.slider_width;
        else
          new_x = GetSoundVolume( public.GetSlideType( slidertype[ i ] ) ) * public.dialog.options.slider_width;
        end;
        local percent = math.ceil( ( new_x * 100 ) / public.dialog.options.slider_width );

        ObjSet(     "dialog_options_"..slidertype[ i ].."_scroll_slider", { pos_x = new_x } );
        ObjSet( "spr_dialog_options_"..slidertype[ i ].."_scroll_slider", { pos_x = new_x } );
        ObjSet( "txt_dialog_options_"..slidertype[ i ].."_percent", { text = percent.."%" } );

      end

      -- установка курсора и режима экрана
      local t_check_names = { "fullscreen", "widescreen", "cursor", "perfmode" };
      public.dialog.options.CheckSet( t_check_names );

      if ( sender_name == "game" ) then

        PauseLevel( 1 );
        ObjSet( "dialog_options_button_credits", {event_mdown = function() common.dialog.ButtonMouseDown( "options", "credits",sender_name ); end} );

      end;

    end

  end;
  --------------------------------------------------------------------
  function public.dialog.options.Close( sender_name )

    public.LogTrace( "[ - ] Закрытие окна опций: сохранение настроек." );

    SaveProfiles();
    SaveSettings();
    

    local platform = GetPlatform();
    if ( platform == "android" ) or ( platform == "ios" ) then
       if GetCurrentRoom() == "rm_menu" then
          iOS_ManageAds(1);
       end;
    end;
    public.SetMultiTouch(GetCurrentRoom());

    if ( sender_name == "left" ) then

      public.DialogWindowShow( "common", "optionsquit", true );

    elseif( sender_name == "right" ) then

      PauseLevel( 0 );
      public.DialogWindowHide( "options" );
    
    else
    
      public.DialogWindowHide( "options" );

    end;

  end;
  --------------------------------------------------------------------
  function public.dialog.options.ButtonMouseDown( button, param )
    ld.LogTrace( "public.dialog.options.ButtonMouseDown( button, param )", button, param )
    if ( button == "check" ) then

      public.dialog.options.CheckDown( param );

    elseif ( button == "gamemode" ) then

      public.dialog.options.GameMode();

    elseif ( button == "credits" ) then
      public.MenuCredits(param);
      public.dialog.ButtonMouseDown( "options", "right" );
    else

      public.dialog.options.Close( button );

    end;

  end;
  --------------------------------------------------------------------
  function public.dialog.options.CheckSet( t_check_names )

    local check_param =
    {
        fullscreen = public.ConditionChoose( GetFullScreen(), 1, 0 ),
        widescreen = public.ConditionChoose( GetWideScreen(), 1, 0 ),
        cursor     = public.ConditionChoose( GetSysCursor(), 0, 1 ),
        perfmode   = public.ConditionChoose( GetPerformanceMode() == 0, 1, 0 )
    };

    for i = 1, #t_check_names do
      ObjSet( "spr_dialog_options_"..t_check_names[ i ].."_check_light",
      {
        alp = check_param[ t_check_names[i] ]
      } );
    end;

  end;
  --------------------------------------------------------------------
  function public.dialog.options.CheckDown( scroll_name )

    local check_name = "spr_dialog_options_"..scroll_name.."_check_light";

    local func_get = { fullscreen = GetFullScreen, widescreen = GetWideScreen, cursor = GetSysCursor, perfmode = GetPerformanceMode };
    local func_set = { fullscreen = SetFullScreen, widescreen = SetWideScreen, cursor = SetSysCursor, perfmode = SetPerformanceMode };

    local new_value;
    local new_alp;

    public.dialog.togglescreen.is_changed[ scroll_name ] = true;

    if ( scroll_name == "perfmode" ) then

      new_value = public.ConditionChoose( func_get[ scroll_name ]() == 0, 1, 0 );

      func_set[ scroll_name ]( new_value );

      new_alp = func_get[ scroll_name ]();

      private.fps.Check( true );

    else

      new_value = not func_get[ scroll_name ]();

      func_set[ scroll_name ]( new_value );

      new_alp = public.ConditionChoose( func_get[ scroll_name ](), 1, 0 );

    end;

    if ( scroll_name == "cursor" ) or ( scroll_name == "perfmode" ) then

      new_alp = public.ConditionChoose( new_alp == 1, 0, 1 );

    end;

    public.dialog.togglescreen.is_changed[ scroll_name ] = false;

    ObjSet( check_name, { alp = new_alp } );

  end;
  --------------------------------------------------------------------
  function public.dialog.options.ScrollDown( scroll_name )

    -- позиция объекта относительно главного объекта
    local slider_objname = "dialog_options_"..scroll_name.."_scroll_slider";
    local obj_x = GetObjPosByObj( "spr_"..slider_objname )[ 1 ];

    local cur_x = GetGameCursorPos()[ 1 ];
    local off_x = cur_x - obj_x;

    local new_x = ObjGet( "spr_"..slider_objname ).pos_x + off_x;

    if ( new_x < 0 ) then new_x = 0; end;
    if ( new_x > public.dialog.options.slider_width ) then new_x = public.dialog.options.slider_width; end;

    ObjSet( slider_objname, { pos_x = new_x });

    public.dialog.options.ScrollSet( scroll_name, new_x );

  end;
  --------------------------------------------------------------------
  function public.dialog.options.ScrollDrag( scroll_name )

    SetCursor( CURSOR_HAND );

    local cur_pos = GetGameCursorPos();

    if ( not public.dialog.options.is_slider_startdrag ) then
      public.dialog.options.is_slider_startdrag = true;
      local obj_x = ObjGet( "dialog_options_"..scroll_name.."_scroll_slider" ).pos_x;
      public.dialog.options.slider_offx = cur_pos[ 1 ] - obj_x;
    end;

    local new_x = cur_pos[ 1 ] - public.dialog.options.slider_offx;

    if ( new_x < 0 ) then new_x = 0; end;
    if ( new_x > public.dialog.options.slider_width ) then new_x = public.dialog.options.slider_width; end;

    public.dialog.options.ScrollSet( scroll_name, new_x );
    public.dialog.options.ScrollPlaySound( scroll_name );

  end;
  --------------------------------------------------------------------
  function public.dialog.options.ScrollDrop( scroll_name )

    -- драг завершен
    public.dialog.options.is_slider_startdrag = false;

    local new_x = ObjGet( "spr_dialog_options_"..scroll_name.."_scroll_slider" ).pos_x;
    local new_y = ObjGet( "spr_dialog_options_"..scroll_name.."_scroll_slider" ).pos_y;

    -- возвращаем drag-объект в позиции слайдера
    ObjSet( "dialog_options_"..scroll_name.."_scroll_slider", { pos_x = new_x, pos_y = new_y });

    public.dialog.options.ScrollSet( scroll_name, new_x );
    public.dialog.options.ScrollStopSound( scroll_name );

  end;
  --------------------------------------------------------------------
  function public.dialog.options.ScrollSet( scroll_name, new_x )

    local percent = math.floor( ( new_x * 100 ) / public.dialog.options.slider_width );
    ObjSet( "txt_dialog_options_"..scroll_name.."_percent", { text = percent.."%" } );
    ObjSet( "spr_dialog_options_"..scroll_name.."_scroll_slider", { pos_x = new_x } );

    if ( scroll_name == "gamma" ) then
      SetGamma( ( new_x / public.dialog.options.slider_width ) + 0.5 );
    else
      SetSoundVolume( public.GetSlideType( scroll_name ), ( new_x / public.dialog.options.slider_width ) );
    end;

  end;
  --------------------------------------------------------------------
  function public.dialog.options.ScrollPlaySound( scroll_name )

    local path = "assets/audio/reserved/aud_temp_"..scroll_name;
    local trgafter = "*public.dialog.options.ScrollStopSound('"..scroll_name.."');";

    if ( not public.dialog.options.is_slider_startplay[ scroll_name ] and scroll_name ~= "gamma" ) then

      if ( scroll_name == "voc" ) then
        PlayVoice( path, 0, trgafter, 0 );

      elseif ( scroll_name == "sfx" ) then
        PlaySfx( path, 0, trgafter, 0 );

      elseif ( scroll_name == "mus" ) then --and not cmn.is_inmenunow then
        PlaySoundtrack( path, 0, trgafter, 0 );

      elseif ( scroll_name == "env" ) then
        PlayEnv( path, 0, trgafter, 0 );

      end
      public.dialog.options.is_slider_startplay[ scroll_name ] = true;

    end;

  end;
  --------------------------------------------------------------------
  function public.dialog.options.ScrollStopSound( scroll_name )

    public.dialog.options.is_slider_startplay[ scroll_name ] = false;
    local path = "assets/audio/reserved/aud_temp_"..scroll_name;
    SndStop( path );

  end;
  --------------------------------------------------------------------
  function public.dialog.options.GameMode()

    public.DialogWindowShow( "gamemode", "options", true );

  end;
  --------------------------------------------------------------------
  function public.GetSlideType( type )

    local types = {};

    types[ "mus" ]   = "soundtrack";
    types[ "env" ]   = "env";
    types[ "sfx" ]   = "sfx";
    types[ "voc" ]   = "voice";
    types[ "gamma" ] = "gamma";

    return types[ type ];

  end;
--*********************************************************************************************************************
--***function *** - togglescreen: () end*******************************************************************************
--*********************************************************************************************************************
  --------------------------------------------------------------------
  public.dialog.togglescreen = {};
  public.dialog.togglescreen.is_changed = {};
  --------------------------------------------------------------------
  function public.dialog.togglescreen.Close()

    public.DialogWindowHide( "togglescreen" );

    if ( cmn.is_inmenunow and not private.is_sounddevicechecked ) then

      cmn.SoundDeviceCheck();

    end

  end
  --------------------------------------------------------------------
  function public.dialog.togglescreen.Open( msg_type )

    local textid = "str_dialog_fullscreen";

    if ( msg_type == "wide" ) then

      textid = "str_dialog_widescreen";

    end;

    ObjSet( "txt_dialog_togglescreen", { text = textid } );

  end
  --------------------------------------------------------------------
  function public.dialog.togglescreen.ButtonMouseDown( button )

    if ( button == "center" ) then

      public.dialog.togglescreen.Close();

    end;

  end;
--*********************************************************************************************************************
--**function *** Level *** () end**************************************************************************************
--*********************************************************************************************************************
  function public.LevelSwitch( level, param )
    --ld.LogTrace( "LevelSwitch", level, param )
    local trig = "";

    if ( param ) then

      trig = string.format( "common.Start('%s','%s');", level, param );

    else

      trig = string.format( "common.Start('%s');", level );

    end;

    MsgSend(Command_Level_CanShowLoading, { visible = true });
    SwitchLevel( "assets/shared/mod_common", trig, 1 );

  end;
  --------------------------------------------------------------------
  -- функция загрузки и инициализации модулей уровня, инициализации и загрузки прогресса
  function public.LevelLoad( level, prg_type, start_room, key_f_id )

    -- Загрузка и инициализация модулей локаций.
    private.InitLevelModules( level );

    -- Загрузка прогресса. Сейв должен существовать.

    if not ( LoadCurrentProfile() ) then

      DbgTrace( "FATAL ERROR!!! Save doesn't exist!" );

    else

      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      -- В сейве на момент загрузки уровня существует таблица "ng_global.progress[ prg_type ].common".

      private.UpdateGameMode( ng_global.gamemode );

      ng_global.currentprogress = prg_type;

      ng_global.progress[ prg_type ].common.chapter = level;

      local current_progress = ng_global.progress[ prg_type ];

      interface.InventoryAutoHideLoad();

      interface.ButtonHintReload( current_progress.common.hinttimer );
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

      -- Переход по читу: отмечаем выполненным до указанного.
      if ( key_f_id ) then

        if ( ng_global.achievements ) then
          ng_global.achievements.data = { std = {}, ext = {} };
        end

        current_progress.common.currentroom = private.cheater_key_f[ "F"..key_f_id ].startroom;

        local done = 0;

        local breakpoint = private.cheater_key_f[ "F"..key_f_id ].prg_elem;

        if ( breakpoint ) then

          done = 1;

        end;

        for i = 1, #game.progress_names, 1 do

          local current_element_name = game.progress_names[ i ];

          --current_progress[ current_element_name ] = {};

          if ( current_element_name == breakpoint ) then

            done = 0;

          end;

          current_progress[ current_element_name ] = {};

          current_progress[ current_element_name ].done  = done;

          -->> для работы тасков
          if done == 1 then
            int_button_task.Update_FromSetEventDone ( current_element_name )
          end
          --<< для работы тасков

          current_progress[ current_element_name ].start = done;

        end;

      end;

      -- Проверяем на целостность, добавляем в очередь.
      for i = 1, #game.progress_names, 1 do

        local current_element_name = game.progress_names[ i ];

        if not ( current_progress[ current_element_name ] ) then

          current_progress[ current_element_name ] = {};
          current_progress[ current_element_name ].done  = 0;
          current_progress[ current_element_name ].start = 0;

        else

          if ( current_progress[ current_element_name ].done  == 1 )
          or ( current_progress[ current_element_name ].start == 1 )
          then

            public.AddSubscribersToQueue( current_element_name );

          end;

        end;

      end;

    end;

    prg.current = prg_type;

    private.LoadLevelModules( level );

    SetCursor( CURSOR_DEFAULT );
    room.SetAutosave( true );

    -->>Нужно для реализации функционала подписок на функционал енвов и статичных видосов
    ld_impl.SmartHint_Init();
    --<<Нужно для реализации функционала подписок на функционал енвов и статичных видосов

    -- IMPORTANT! README! При создании нового проекта, при создании secret room!
    -- Tolstov: если scr нужно грузиться прямо из rm_extra (нет rm_secretroom) то реализация №1
    --реализация №1 начало
    if prg_type == "scr" then
      local rm_name = start_room;
      local module = public.GetObjectName(  rm_name );
      local ext = rm_extra.rm2prg(rm_name);
      if rm_name:find("^mg_") then
        ModLoad("assets/levels/level"..ext.."/"..rm_name.."/mod_"..module );
        ObjAttach( rm_name, room.hub );
        _G[ rm_name ].Init();
        public.GotoRoom(rm_name,false,true)
      else
        ModLoad("assets/levels/level"..ext.."/"..rm_name.."/mod_"..module );
        ObjAttach( rm_name, room.hub );
        game.relations[ rm_name ] = {}
        _G[ rm_name ].Init();
        public.AddSubscribersToQueue("win_"..module)
        if cmn.IsEventDone("opn_"..module) then
          public.CallRoomEventHandlers( rm_name )
        end
        public.GotoRoom(rm_name,false,true)
      end
    else
    --реализация №1 конец
    -- Если реализация №1 не нужна, закомнетить его
      public.GotoStartRoom( start_room
      --, prg_type == "scr"  --для реализациия №2 разкоментировать это
      );
      end--реализация №1 конец условия
    
    
    private.CheaterReset();

  end;
  --------------------------------------------------------------------
  function private.InitLevelModules( level, modules )

    modules = modules or game.room_names;
    for i = 1, #modules do
      local module = modules[ i ];
      local mod_name = public.GetObjectName( module );
      ModLoad( string.format( "assets/levels/%s/%s/mod_%s", level, module, mod_name ) );
      ObjAttach( module, room.hub );
      if game and game.relations then
        game.relations[ module ] = {};
      end;
      --ld.LogTrace( "modules[ "..i.." ]"..modules[ i ] );
      _G[ module ].Init();

    end;

  end;
  --------------------------------------------------------------------
  function private.LoadLevelModules( level, modules )

    modules = modules or game.room_names;

    for i = 1, #modules do
      local module = modules[ i ];
      if _G[ module ].Load then
        _G[ module ].Load();
      end;
    end;

  end;
--*********************************************************************************************************************
--***function *** Menu *** () end**************************************************************************************
--*********************************************************************************************************************
  private.menu = {};
  --------------------------------------------------------------------
  function public.MenuLoad( is_fromgame, modules )

    private.load_corrupted_profile = not LoadCurrentProfile();
    private.menu.is_fromgame = is_fromgame;

    private.InitLevelModules( "menu", modules );

    SetCursor( CURSOR_DEFAULT );

    cmn.is_inmenunow = true;
    private.is_enabled_show_window = false;

    local startroom = "rm_intro";

    if ( is_fromgame ) and not ng_global.is_scr then

      startroom = "rm_menu";
    elseif ng_global.is_scr then

      startroom = "rm_extra";
      ng_global.is_scr = false;
      ld.LogTrace( "MenuLoad rm_extra" )
      
    else

      local menu_open_func = rm_menu.Open;

      local MenuCheckStart = function ()

        ObjAttach( "tmr_common_fps", "cmn_timers" );
        private.is_enabled_show_window = true;
        private.CheckForceFullScreen();

        rm_menu.Open = menu_open_func;
        _G[ "rm_menu" ].Open();

      end;

      rm_menu.Open = MenuCheckStart;

      if ( GetPlatform() == "android" ) then --or ( GetPlatform() == "ios" ) then
-- Test BigFist zastavka
        param = "obb";
      end

    end;

    --startroom = "rm_menu";
    public.GotoRoom( startroom, 0 );

  end;
  --------------------------------------------------------------------
  function public.MenuPlay()

    if ( ( not ng_global.progress[ "std" ].common.gamestart )and ( not ng_global.progress[ "std" ].common.gamewin ) ) then
      public.DialogWindowShow( "gamemode", "newgame", true );
    else
      public.DialogWindowShow( "playchoice", nil, true );
    end;

  end;
  --------------------------------------------------------------------
  function public.MenuOptions()
    public.DialogWindowShow( "options", "menu", true );
  end;
  --------------------------------------------------------------------
  function public.MenuQuit()
    public.DialogWindowShow( "common", "quit", true );
  end;
  --------------------------------------------------------------------
  function public.MenuCredits(sender)
    if sender == "menu" then

    elseif sender == "game" then
      if not (public.credits_loaded) then
      local module = "rm_credits";

      ModLoad("assets/levels/menu/rm_credits/mod_credits" );
      ObjAttach( module, room.hub );

      _G[ module ].Init();
      public.credits_loaded = true
      end
    else

    end


    public.GotoRoom( "rm_credits",0,true );

  end;
  --------------------------------------------------------------------
  function public.MenuExtra()
    public.GotoRoom( "rm_extra" );
  end;
  --------------------------------------------------------------------
  function public.MenuAchievements()
    public.GotoRoom( "rm_achievements" );
  end;
  --------------------------------------------------------------------
  function public.MenuProfile()
    public.DialogWindowShow( "profile", nil, true );
  end;
  --------------------------------------------------------------------
  function public.MenuShop()
    public.GotoRoom( "rm_shop" );
  end;
--*********************************************************************************************************************
--***function *** Profile *** () end***********************************************************************************
--*********************************************************************************************************************
  public.profile = {};
  public.profile.types = { "std", "ext" ,"scr", "sgm", "exp" };
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  -- функция инициализации глобальных переменных
  --------------------------------------------------------------------
  function private.ProfileInit()

    public.LogTrace( "[ - ] Инициализация глобальных переменных." );
    ng_global = {};

    ng_global.project = {};
    ng_global.project = private.project;

    ng_global.gamemode = 0;
    ng_global.gamemode_custom = {
      skip = true, hint = true, cursor = true,
      plus_inv = true, sparkle_area = true,
      tutorial = true, tasks = true,
      text = true,
      hint_value = 60, skip_value = 60
    };

    ng_global.inventory_autohide = false;
    ng_global.currentprogress = "std";
    ng_global.progress = {};

    for i = 1, #public.profile.types, 1 do
      private.ProgressReset( public.profile.types[ i ] );
    end;

    common_impl.ProfileInit();

  end;
  --------------------------------------------------------------------
  -- функция установки профиля
  function private.ProfileSet( newprofile, needcheck )

    public.LogTrace( "[ - ] Установка профиля: профиль установлен." );

    SetCurrentProfile( newprofile );

    rm_menu.SetProfileText( newprofile );
    private.ProfileInit();

    if needcheck then
      private.load_corrupted_profile = false;
    else
      private.ProfileCheck();      
    end;

    SaveProfiles();

  end;
  --------------------------------------------------------------------
  function private.ProfileNameTrim( profile_name )

    while ( " " == string.sub( profile_name, 1, 1 ) ) do

      profile_name = string.sub( profile_name, 2 );

    end;

    while ( " " == string.sub( profile_name, - 1 ) ) do

      profile_name = string.sub( profile_name, 1, - 2 );

    end;

    return profile_name;

  end;
  --------------------------------------------------------------------
  --------------------------------------------------------------------
  function private.ProgressReset( prg, save )

    local default = { gamewin = false };
    if ( save ) then default = save; end;

    ng_global.progress[ prg ] = {};
    ng_global.progress[ prg ].common = {};
    ng_global.progress[ prg ].common.gamestart = false;
    ng_global.progress[ prg ].common.gamewin = default.gamewin;
    ng_global.progress[ prg ].common.chapter = "level";
    ng_global.progress[ prg ].common.currentroom = nil;
    ng_global.progress[ prg ].common.hinttimer = 0;

    common_impl.ProgressReset( prg, save );

  end;
  --------------------------------------------------------------------
  -- функция проверки профилей
  function private.ProfileCheck()

    public.LogTrace( "[ - ] Проверка профилей." );
    local status = GetCurrentProfile();

    if ( status == "ng_error" ) then
      public.LogTrace( "[ - ] Проверка профилей: < profile_list > поврежден." );
      public.DialogWindowShow( "common", "corrupt" );

    elseif ( status ~= "ng_noprofiles" ) then
      public.LogTrace( "[ - ] Проверка профилей: существуют." );

      local profiles = GetProfileList();
      for i = 1, #profiles, 1 do
        if ( profiles[i] == GetCurrentProfile() ) then
          public.dialog.profile.current = i;
          break;
        end
      end

      public.LogTrace( "[ - ] Проверка профилей: текущий выделен." );

      if ( not LoadCurrentProfile()  ) then
        
        private.load_corrupted_profile = false
        public.LogTrace( "[ - ] Проверка профилей: текущий поврежден.1" );
        public.DialogWindowShow( "common", "corrupt" );

      elseif private.load_corrupted_profile then

        private.load_corrupted_profile = false
        public.LogTrace( "[ - ] Проверка профилей: текущий поврежден.2" );
        DeleteProfile(status)
        local clearedProfiles = GetProfileList();
        if clearedProfiles and clearedProfiles[1] then
          public.dialog.profile.current = 1
          private.ProfileSet( clearedProfiles[1] );
        end
        public.DialogWindowShow( "common", "corrupt" );

      else

        public.LogTrace( "[ - ] Проверка профилей: текущий загружен, установка режима игры." );
        private.UpdateGameMode( ng_global.gamemode );
        ObjSet( "tmr_common_fps", { time = private.fps.time, playing = true, endtrig = function () private.fps.Check(true); end } );

      end

    else

      public.LogTrace( "[ - ] Проверка профилей: нет профилей." );
      rm_menu.SetProfileText( "" );
      public.DialogWindowShow( "addprofile", "new" );

    end

  end;
--*********************************************************************************************************************
--***function *** Events *** () end************************************************************************************
--*********************************************************************************************************************
  function private.InitEvents()

    --Event_ButtonGuide_Click       = "Event_ButtonGuide_Click";
    --Event_ButtonHint_Click        = "Event_ButtonHint_Click";
    --Event_ButtonInfo_Click        = "Event_ButtonInfo_Click";
    --Event_ButtonReset_Click       = "Event_ButtonReset_Click";
    --Event_ButtonSkip_Click        = "Event_ButtonSkip_Click";
    --Event_ButtonLock_Click        = "Event_ButtonLock_Click";
    --Event_ButtonMap_Click         = "Event_ButtonMap_Click";
    --Event_ButtonMenu_Click        = "Event_ButtonMenu_Click";
    --Event_FrameSubroom_Click      = "Event_FrameSubroom_Click";
    --Event_Tutorial_Click          = "Event_Tutorial_Click";
    --Event_HoHint_NoObjects        = "Event_HoHint_NoObjects";
    --Event_DialogHo_Show           = "Event_DialogHo_Show";
    --Event_DialogHo_Hide           = "Event_DialogHo_Hide";
    --Event_PanelNotification_Click = "Event_PanelNotification_Click";

    --Command_Effect_ShowHoHint     = "Command_Effect_ShowHoHint"

  end;
  -----------------------------------------------------------------------------
  function private.SubscribeEvents()

    --MsgSubscribe( Event_ButtonGuide_Click, private.Handle_Event_ButtonGuide_Click );
    --MsgSubscribe( Event_ButtonHint_Click, private.Handle_Event_ButtonHint_Click );
    --MsgSubscribe( Event_ButtonInfo_Click, private.Handle_Event_ButtonInfo_Click );
    --MsgSubscribe( Event_ButtonReset_Click, private.Handle_Event_ButtonReset_Click );
    --MsgSubscribe( Event_ButtonSkip_Click, private.Handle_Event_ButtonSkip_Click );
    --MsgSubscribe( Event_ButtonLock_Click, private.Handle_Event_ButtonLock_Click );
    --MsgSubscribe( Event_ButtonMap_Click, private.Handle_Event_ButtonMap_Click );
    --MsgSubscribe( Event_ButtonMenu_Click, private.Handle_Event_ButtonMenu_Click );
    --MsgSubscribe( Event_FrameSubroom_Click, private.Handle_Event_FrameSubroom_Click );
    --MsgSubscribe( Event_Tutorial_Click, private.Handle_Event_Tutorial_Click );
    --MsgSubscribe( Event_HoHint_NoObjects, private.Handle_Event_HoHint_NoObjects );
    --MsgSubscribe( Event_DialogHo_Show, private.Handle_Event_DialogHo_Show );
    --MsgSubscribe( Event_DialogHo_Hide, private.Handle_Event_DialogHo_Hide );
    --MsgSubscribe( Event_PanelNotification_Click, private.Handle_Event_PanelNotification_Click );

    MsgSubscribe( Event_Level_CheatKeyPressed,        private.Handle_Event_Level_CheatKeyPressed );
    MsgSubscribe( Event_Application_ToggleFullScreen, private.Handle_Event_Application_ToggleFullScreen );
    MsgSubscribe( Event_Application_Closing,          private.Handle_Event_Application_Closing );

    MsgSubscribe( Event_GotoMainMenu,       private.Handle_Event_GotoMainMenu );
    MsgSubscribe( Event_FullHideWait,       private.Handle_Event_FullHideWait );
    MsgSubscribe( Event_FullBack,           private.Handle_Event_FullBack );

    MsgSubscribe( Event_Application_Unpaused,         private.Handle_Event_Application_Unpaused );

    MsgSubscribe( Event_notEngine_ScriptHub_Script_Error, private.Handle_Script_Error );



  end;
  -----------------------------------------------------------------------------
  function private.UnubscribeEvents()

    --MsgUnsubscribe( Event_ButtonGuide_Click, private.Handle_Event_ButtonGuide_Click );
    --MsgUnsubscribe( Event_ButtonHint_Click, private.Handle_Event_ButtonHint_Click );
    --MsgUnsubscribe( Event_ButtonInfo_Click, private.Handle_Event_ButtonInfo_Click );
    --MsgUnsubscribe( Event_ButtonReset_Click, private.Handle_Event_ButtonReset_Click );
    --MsgUnsubscribe( Event_ButtonSkip_Click, private.Handle_Event_ButtonSkip_Click );
    --MsgUnsubscribe( Event_ButtonLock_Click, private.Handle_Event_ButtonLock_Click );
    --MsgUnsubscribe( Event_ButtonMap_Click, private.Handle_Event_ButtonMap_Click );
    --MsgUnsubscribe( Event_ButtonMenu_Click, private.Handle_Event_ButtonMenu_Click );
    --MsgUnsubscribe( Event_FrameSubroom_Click, private.Handle_Event_FrameSubroom_Click );
    --MsgUnsubscribe( Event_Tutorial_Click, private.Handle_Event_Tutorial_Click );
    --MsgUnsubscribe( Event_HoHint_NoObjects, private.Handle_Event_HoHint_NoObjects );
    --MsgUnsubscribe( Event_DialogHo_Show, private.Handle_Event_DialogHo_Show );
    --MsgUnsubscribe( Event_DialogHo_Hide, private.Handle_Event_DialogHo_Hide );
    --MsgUnsubscribe( Event_PanelNotification_Click, private.Handle_Event_PanelNotification_Click );

    MsgUnsubscribe( Event_Level_CheatKeyPressed,        private.Handle_Event_Level_CheatKeyPressed );
    MsgUnsubscribe( Event_Application_ToggleFullScreen, private.Handle_Event_Application_ToggleFullScreen );
    MsgUnsubscribe( Event_Application_Closing,          private.Handle_Event_Application_Closing );

    MsgUnsubscribe( Event_GotoMainMenu,       private.Handle_Event_GotoMainMenu );
    MsgUnsubscribe( Event_FullHideWait,       private.Handle_Event_FullHideWait );
    MsgUnsubscribe( Event_FullBack,           private.Handle_Event_FullBack );

    MsgUnsubscribe( Event_Application_Unpaused,         private.Handle_Event_Application_Unpaused );

    MsgUnsubscribe( Event_notEngine_ScriptHub_Script_Error, private.Handle_Script_Error );

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Script_Error(msg, params)
  if (cmn.bError == 1) then
    return;
  end;
  cmn.bError = 1;
  if ld then
    ld.LogTrace( "Handle_Script_Error", msg, params )
  end
  cmn.bError = 0;
  end;
  -----------------------------------------------------------------------------
  function private.ApplicationClose()

    if ( not cmn.is_inmenunow ) then
      interface_impl.SaveAchievementsTimers()
      private.SaveInterfaceTimers();
      interface.InventoryAutoHideSave();

    end;

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_ButtonGuide_Click()

    common_impl.ButtonGuide_Click();
    interface.StrategyGuideShow();

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_ButtonHint_Click( msg, params )

    common_impl.ButtonHint_Click( params.hint_state );

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_ButtonInfo_Click()

    common_impl.ButtonInfo_Click();

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_ButtonLock_Click()

    local autohide = interface.InventoryAutoHideGet();
    interface.InventoryAutoHideSet( not autohide );

    common_impl.ButtonLock_Click();

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_ButtonMap_Click()

    common_impl.ButtonMap_Click();

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_ButtonMenu_Click()

    common_impl.ButtonMenu_Click();
    public.DialogWindowShow( "options", "game", true );

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_ButtonReset_Click()

    common_impl.ButtonReset_Click();

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_ButtonSkip_Click( msg, params )

    common_impl.ButtonSkip_Click( params.skip_ready );

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_FrameSubroom_Click()

    public.CloseSubRoom();
    common_impl.FrameSubroom_Click();
    interface.CheaterUpdateSubroom( "" );

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_Tutorial_Click( msg, params )

    common_impl.Tutorial_Click( params.button_id );

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_HoHint_NoObjects()

    common_impl.HoHint_NoObjects();

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_DialogHo_Show()

    --ld.LogTrace( "Handle_Event_DialogHo_Show" )

    common_impl.DialogHo_Show();

  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_DialogHo_Hide()

    common_impl.DialogHo_Hide();

  end;
  -----------------------------------------------------------------------------
--  function private.Handle_Event_PanelNotification_Click( msg, params )
--
--    common_impl.PanelNotification_Click( params.notification_type );
--
--  end;
  -----------------------------------------------------------------------------
  function private.Handle_Event_Level_CheatKeyPressed( msg, params )

    local keycode = params.key;

    local key_f_id = keycode - 111;

    if ( key_f_id > 0 ) and ( key_f_id < 13 ) then

      if ( private.cheater_key_f[ "F"..key_f_id ] ) then

        public.LevelSwitch( private.cheater_key_f[ "F"..key_f_id ].level, key_f_id );

      end;

    end;

    common_impl.CheaterKeyPress( keycode );

  end;
  --*********************************************************************************************************************
  function private.Handle_Event_Application_Closing()

    private.ApplicationClose();
    private.UnubscribeEvents();
    common_impl.Application_Closing();

  end;
  --*********************************************************************************************************************
  function private.Handle_Event_Application_ToggleFullScreen( msg, params )

    local togglefullscreen = params.togglefullscreen;
    local togglewidescreen = params.togglewidescreen;

    local size = GetAppSize();
    public.LogTrace( "[ ! ] Изменение режима экрана: ширина = "..GetAppWidth().."; GetAppSize = { "..size.w..", "..size.h.." }");

    if ( cmn.is_inmenunow ) then

      rm_menu.ButtonSetPos();

    end;

    if ( togglefullscreen == false ) and ( togglewidescreen == false ) and ( private.is_enabled_show_window ) then

      public.LogTrace( "[ ! ] Изменение режима экрана: невозможно." );

      local type = "full";

      if ( togglewidescreen == false and public.dialog.togglescreen.is_changed[ "widescreen" ] ) then

        type = "wide";

      end;

      public.DialogWindowShow( "togglescreen", type, false );

    else

      public.LogTrace( "[ ! ] Изменение режима экрана: установка опций." );

      local t_check_names = { "fullscreen", "widescreen" };
      public.dialog.options.CheckSet( t_check_names );

      if ( private.is_enabled_show_window ) then

        private.fps.Check( true );

      end;

    end;

  end;

  ---------------------------------------------------------------------------------------
  function private.Handle_Event_GotoMainMenu( msg, params )

    DbgTrace( "[common] Handle_Event_GotoMainMenu");

    private.SaveInterfaceTimers();

--    SaveProfiles();
--    SaveSettings();

--    common_impl.GotoMainMenu();

--    private.ApplicationClose();

    SetCursor( CURSOR_DEFAULT );
    public.LevelSwitch( "menu", "game" );

  end;
  --------------------------------------------------------------------------------------
  function private.Handle_Event_FullHideWait( msg, params )

    DbgTrace( "[common] Handle_Event_FullHideWait");
    common_impl.FullHideWait();

  end;
  --------------------------------------------------------------------------------------
  function private.Handle_Event_FullBack( msg, params )

    DbgTrace( "[common] Handle_Event_FullBack");
    common_impl.FullBack();

  end;

  --------------------------------------------------------------------------------------
  function private.Handle_Event_Application_Unpaused( msg, params )

    DbgTrace( "[common] Handle_Event_Application_Unpaused");
    common_impl.Application_Unpaused();

  end;

--*********************************************************************************************************************
--***function *** Subscribers *** () end*******************************************************************************
--*********************************************************************************************************************
  function private.InitSubscribers()

    -- таблица 1: подписчиков
    cmn.subscribers = {};
    -- таблица 2: динамическая очередь событий
    cmn.event_queue = {};

    cmn.AddSubscriber = public.AddSubscriber;
    cmn.ClearSubscribers = public.ClearSubscribers;
    cmn.CallEventHandler = public.CallEventHandler;

  end;
  -----------------------------------------------------------------------------------
  function public.AddSubscriber( event_name, func, room_name )

    local room_name = room_name or "instant";

    if ( not cmn.subscribers[ event_name ] ) then

      cmn.subscribers[ event_name ] = {};

    end;

    if ( cmn.subscribers[ event_name ] ) then

      table.insert( cmn.subscribers[ event_name ], { room = room_name, func = func } );

      if ( not func ) then

        --DbgTrace( "event "..event_name.." have nil subscr!!!" );

      end;

      --*DbgTrace( "Add subscriber FOR EVENT '"..event_name.."' ( room = "..tostring( room_name )..", func = "..tostring( func ).." )"  );

    end;

  end
-----------------------------------------------------------------------------------
  function public.ClearSubscribers( event_name )

    cmn.subscribers[ event_name ] = {};

  end
  -----------------------------------------------------------------------------------
  function public.CallRoomEventHandlers( room_name )

    --DbgTrace( "CallRoomEventHandlers: " );

    local id = 1;

    while ( id <= #cmn.event_queue ) do

      if ( cmn.event_queue[ id ].room == room_name ) or ( cmn.event_queue[ id ].room == "instant" ) then

        --DbgTrace( "  - - Call event handler ( "..cmn.event_queue[ id ].room.." ) : " );

        local event_handler_params = table.remove( cmn.event_queue, id );
        event_handler_params.func();

        -- если луа говорит, что зхдесь ошибка, значит, что прередан вместо функции в AddSubscriber nil

      else

        id = id + 1;

      end;

      --DbgTrace( "  - - id = "..id );

    end;

  end
  -----------------------------------------------------------------------------------
  function public.AddSubscribersToQueue( event_name )

    if ( cmn.subscribers[ event_name ] ) then

      --DbgTrace( "Add subscriber to QUEUE for event '"..event_name.."' "..#cmn.subscribers[ event_name ] );

      for id = 1, #cmn.subscribers[ event_name ] do

        table.insert( cmn.event_queue, cmn.subscribers[ event_name ][ id ] );

        --DbgTrace( "  - - !!!! "..event_name.."  "..tostring( cmn.event_queue[ #cmn.event_queue ].room ).." "..tostring( cmn.event_queue[ #cmn.event_queue ].func ) );

      end;

    end;

  end;
  -----------------------------------------------------------------------------------
  function public.CallEventHandler( event_name, current_room, prg )

    public.AddSubscribersToQueue( event_name );

    local current_room = current_room or GetCurrentRoom();
    public.CallRoomEventHandlers( current_room );

  end
--*********************************************************************************************************************

function public.SetMultiTouch(room_object)

    local platform = GetPlatform();

  --DbgTrace("[common] public.SetMultiTouch room_object = "..tostring(room_object).."; platform = "..tostring(platform));

    if ( platform == "android" ) or ( platform == "ios" ) then

    if (IsIpad() == true) then
        if ("ho" == public.GetObjectPrefix( room_object )) then
          DbgTrace("[common] public.SetMultiTouch::iOS_EnableMultiTouch(1) room_object = "..tostring(room_object));
          iOS_EnableMultiTouch(1);
        else
          DbgTrace("[common] public.SetMultiTouch::iOS_EnableMultiTouch(0) room_object = "..tostring(room_object));
          iOS_EnableMultiTouch(0);
        end;

    elseif (IsIphone() == true) then

      if ("zz" == public.GetObjectPrefix( room_object )) then
          DbgTrace("[common] public.SetMultiTouch::iOS_EnableMultiTouch(0) room_object = "..tostring(room_object));
          iOS_EnableMultiTouch(0);
        else
          DbgTrace("[common] public.SetMultiTouch::iOS_EnableMultiTouch(1) room_object = "..tostring(room_object));
          iOS_EnableMultiTouch(1);
        end;

    end;
    end;

  end;
--*********************************************************************************************************************


