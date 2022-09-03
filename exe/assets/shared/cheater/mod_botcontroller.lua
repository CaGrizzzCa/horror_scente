-- name=botcontroller
function public.BotInit()

  --ld.LogTrace( _G )

  private.HINT_ROOT = common_impl.hint      --массив хинта

  ng_global.bot = ng_global.bot or {}
  --будет ли бот пропускать прогрессы без хинта
  private.NO_HINT_SKIP = private.BotGetConfigParam( "no_hint_skip", "bool", true );   

  --время ожидания после действия ( на данный момент не желательно ставить значение < 1.5 )
  private.BOT_STEP_WAIT = private.BotGetConfigParam( "step_wait", "number", 1.4 );

  --настройка ожидания бота, после выключения лока
  private.BOT_ATER_LOCK_WAIT_TAIM = private.BotGetConfigParam( "lock_wait_time", "number", 0.4 );              

  --количество кликов подряд по объекту, после чего будут выполнены Fake клики
  private.BOT_CLICKS_BEFORE_FAKE = private.BotGetConfigParam( "clicks_before_fake", "number", 4 );

  --количество Fake кликов подряд по объекту, после чего будет пропущен прогрес ( вызов функции прогресса )
  private.BOT_CLICKS_BEFORE_STOP = private.BotGetConfigParam( "clicks_before_stop", "number", 6 );

  --количество проверок на заблокированность игры
  private.BOT_GAME_LOCK_CHECK_MAX = private.BotGetConfigParam( "game_lock_check_max", "number", 200 );

  --количество выполнения BotStep(), когда prg_next не изменяется, для определения "залипания" бота
  private.BOT_GAME_PRG_REPIATS_COUNT = private.BotGetConfigParam( "game_prg_repiats_count", "number", 100 );

  --количество кликов по зоне применения, до применения предмета
  private.BOT_USE_PLACE_CLICKS = private.BotGetConfigParam( "use_place_clicks", "number", 1 );

  --разрешить скипать пргоресс который не удалось завершить
  private.BOT_ALLOW_SKIP = private.BotGetConfigParam( "allow_skip", "bool", false );

  --количество шагов бота между скриншотами, при значении <= 0 выключено 
  private.BOT_SCREENSHOT_STEPS_WAIT = private.BotGetConfigParam( "screenshot_steps_wait", "number", 0 );

  --жмём на хинт по возможности, переход в локации будет осуществлен телепортом хинта
  private.BOT_HINT_ON_STEP = private.BotGetConfigParam( "hint_on_step", "bool", true );

  --время по истечении которого бот сделает скриншот после нажатия на кнопку хинт, при <0 выкл
  private.BOT_HINT_SCREENSHOT_TIME = private.BotGetConfigParam( "hint_screenshot_time", "number", -1 );

  --количество "троганий" объектов в сцене с включеным интпутом и наличием функции в event_mdown
  private.BOT_ALL_OBJS_TOUCH = private.BotGetConfigParam( "all_objs_touch", "number", 1 );

  --настройка скорости бота
  private.BOT_SPEED = private.BotGetConfigParam( "speed", "number", 5 );

  --настройка автостарта бот, с запуском указанного уровня, если <= 0 бот не запускается автоматически
  private.BOT_START = private.BotGetConfigParam( "start", "number", 0 );

  --настройка автостопа бота, при достижении МГ
  private.BOT_STOP_ON_MG = private.BotGetConfigParam( "stop_on_mg", "bool", false );

  --настройка форсквит бота после действия(кроме хо), количиство форсквитов на 1 прогресс
  private.BOT_FORCE_QUIT = private.BotGetConfigParam( "force_quit", "number", 0 );

  --настройка открытия и закрытия карты ботом перед каждым действием
  private.BOT_MAP_OPEN = private.BotGetConfigParam( "map_open", "number", 0 );

  --настройка авто перехода в бонус, при удачном завершении прогресса в основном часе
  private.BOT_AUTO_BONUS = private.BotGetConfigParam( "auto_bonus", "bool", false );

  --ld.LogTrace( "BotInit", private.BOT_SPEED, private.BOT_START )
  --ld.LogTrace( "BotInit", ng.GetConfigInfo("bot.speed"), ng.GetConfigInfo("bot.start"), ng.GetConfigInfo("bot.xxx") )
  
  --ересь для нормального старта/остановки бота
  private.BotStartNow = false
  private.BotStepNow = false
  private.BotStepNowEnded = true


  if not ld then
  --function ld() end
    --------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------
    ld = {}
      function ld.StringDivide(string, div)
        div = "_" or div
        local table = {}
        local id = 1
        local il = 1
        for i = 1, string.len(string) do
          if string.sub(string,i,i) == div then
            table[id] = string.sub(string,il,i-1)
            il = i+1
            id = id + 1
          end
          if i == string.len(string) then
            table[id] = string.sub(string,il,i)
            il = i+1
            id = id + 1
          end
        end
        return table
      end
      --------------------------------------------------------------------------------------
      --------------------------------------------------------------------------------------
      function ld.StartTimer( timer_name, time, endtrig )  --- 2 (time, endtrig) or 3 ( timer_name, time, endtrig )
        if type(timer_name) == "number" then
          time,endtrig = timer_name,time
          repeat
            timer_name = "tmr_global_temp_timer_"..math.random(1,100000)
          until not ObjGet(timer_name)
        end
        time = tonumber( time )
        ObjCreate( timer_name, "timer" )
        ObjAttach( timer_name, "cmn_timers" )
        --public.CopyObj("tmr_common_timer", timer_name, "timer", "cmn_timers")
        --ld.LogTrace( timer_name );
        ObjSet( timer_name, { time = time, endtrig =  function () ObjDelete(timer_name); endtrig() end , playing = 1 } );
      end
      --------------------------------------------------------------------------------------
      --------------------------------------------------------------------------------------
      function ld.LogTrace(...)
        local arg = {...}
        local s = "";
        for i = 1, #arg do

          if #arg > 1 then
            if type( arg[i] ) == "table" then
              --local a = b + c
              s = s.."\n"..tostring( arg[i] )..ld.TableString( arg[i], "\t" ).."\n";
            else
              s = s..tostring( arg[i] ).."; ";
            end;
          else
            if type( arg[i] ) == "table" then
              s = s..ld.TableString( arg[i], "\t" );
            else
              s = s..tostring( arg[i] );
            end
          end;
        end;

        DbgTrace( s );

      end;

      function ld.TableString( t, space )
        space = space or "";
        local s = space
        for k,v in pairs( t ) do
          --local s = space
          if type( v ) == "table" then
            s = s.."\n"..space.."\t"..tostring(k).." :: "..tostring(v);
            s = s..ld.TableString( v, space.."\t" )
          else
            s = s.."\n\t"..space..tostring(k).." => "..tostring(v);
          end;
        end;
        return s;
      end;
     --------------------------------------------------------------------------------------
      function ld.TableContains(test, val, keyReturn)
        local matched = false
        local keyValue = 0
        if #test>0 then
          for key in pairs(test) do --pairs is used, as opposed to ipairs, because ipairs stops at any nil value
            if type(test[key])=="table" then
              for k,v in pairs(test[key]) do
                if val==v then
                  matched=true
                  keyValue = key
                end
              end
            else
              if val==test[key] then
                matched=true
                keyValue = key
              end
            end
          end
        else
          for key in pairs(test) do
            if type(test[key])=="table" then
              for k,v in pairs(test[key]) do
                if val==v then
                  matched=true
                  keyValue = key
                end
              end
            else
              if val==test[key] then
                matched=true
                keyValue = key
              end
            end
          end
        end
        if keyReturn then
          return keyValue
        else
          return matched
        end
      end
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        function ld.TableSum(table)
          local sum = 0
          local check
          for i,o in pairs(table) do
            sum = sum + tonumber( o )
            check = true
          end
          return sum or check
        end
        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        function ld.TableCopy(t)
          local t2 = {};
          if type(t) == "table" then
            for k,v in pairs(t) do
              if type(v) == "table" then
                  t2[k] = ld.TableCopy(v);
              else
                  t2[k] = v;
              end
            end
          else
            t2=t
          end
          return t2;
        end
    --------------------------------------------------------------------------------------
  end

  ModLoad("assets/shared/cheater/mod_botcontroller_impl" );
  if botcontroller_impl then
    botcontroller_impl.Init()
  end

  --автозапуск бота
  private.BotTryForceStart()

end

function public.BonusEnabled( bool )
  private.bonus_enabled = bool
end

function private.AddLog( log )
  if private.BotAddedLogs then
    local upper = log:upper()
    if upper:find( "ERROR" ) and not ld.Table.Contains( private.BotAddedLogs.errors, log ) then
      table.insert( private.BotAddedLogs.errors, log )
    end
    if upper:find( "WARNING" ) and not ld.Table.Contains( private.BotAddedLogs.warnings, log ) then
      table.insert( private.BotAddedLogs.warnings, log )
    end
  end
end

function private.BotGetConfigParam( param_name, param_type, default )
  param_type = param_type or "number"
  param_name = "bot."..param_name
  local param = ng.GetConfigInfo( param_name )
  if param == "" then
    return default
  else
    if param_type == "number" then
      return tonumber( param )
    elseif param_type == "string" then
      return tostring( param )
    elseif param_type == "bool" then
      return param == "true"
    end
  end
end

function private.BotExceptionHandler( param )
  --обработка исключений в одном месте, для упрощённого обновления бота
  if param.caller == "BotTryGoTo" then

    if param.value == "mg_casket" and common.GetCurrentRoom() ~=  param.value then
      int_cube.MouseDown()
      return true
    end

  end

  --ничего не делали, возвращаем управвление боту
  return false;
end
function private.BotLog( string )
  ld.LogTrace( "BotLog: "..string )
  --DbgTrace( "BotLog: "..string )
end
function private.BotStepLog( string )
  --ld.LogTrace( "BotLog: "..string )
  --DbgTrace( "BotStepLog: "..string )
end
--контролим авто запуск
function private.BotTryForceStart()
  ObjAnimate( "ng_cheat_highlight", 7,0,0, function() 
    if not common.GetCurrentRoom() then
      if private.BOT_FORCE_QUIT > 0 and ng_global.bot.force_quit and ng_global.bot.force_quit.level then
        common.LevelSwitch( ng_global.bot.force_quit.level );
        ObjAnimate( "ng_cheat_highlight", 7,0,0, private.BotStart, { 0,0,0, 0.5,0,0 } );
      elseif private.BOT_START > 0 then
        ne.dbg.FireInputEvent( 0, 0, 0, 111 + private.BOT_START )
      end
    elseif ( private.BOT_FORCE_QUIT > 0 and ng_global.bot.force_quit ) or private.BOT_START > 0 then
      private.BotStart()
    end;
  end, { 0,0,0, 0.5,0,0 } )

end
function private.BotStart()

  ld.LogTrace = function(...)
    private.AddLog( common.ArgsToString(...) )
    common.LogTrace( ... )
  end

  if private.BotStartNow or private.BotStepNow then return end
  --private.BotLog( "BotStart" )

  if interface and interface.InventoryAutoHideSet then
    interface.InventoryAutoHideSet( false );
  end


  if level and level.TutorialDisable and game.tutorial_progress then
    level.TutorialDisable()
  end



  private.BotMakeGateConnections()
  private.BotClickLoggerChain = {}
  private.BotStepChain_log = {}
  private.BotInvObjShowed = false
  private.BotIsGameLocked_count = 0;
  private.BotTryUsePlaceClickNow = 0;
  private.BotStep_obj_in_transporter_steps = 0
  private.BotTryMakeScreenshot_stepCounter = 0

  private.BotTryTouch_touched = {}

  private.BotTryObjUse_activator = {}

  private.BotTryHint_lastPlace = false;
  private.BotTryHint_lastPrgName = false;

  private.BotNoHintSkips = {}

  private.BotClickCounterAll = {}

  private.BotTryMapOpen_params = {}

  private.BotAddedLogs = { errors = {}; warnings = {}; }

  private.BotStartNow = true
  ne.SetTestMode( 1, private.BOT_SPEED )
  ld.LogTrace( "BotStart", ne.GetTestMode(), common.GetCurrentRoom() )

  private.BotDisableObjDoNotDrop( true )

  private.BotStep()
end
--нужно чтобы не ломались инвентарные предметы
function private.BotDisableObjDoNotDrop( bool )
  if not private.BotDisableObjDoNotDrop_cache then
    private.BotDisableObjDoNotDrop_cache = {
      ObjDoNotDrop;
      int_inventory.InvSetDropable;
      ld.InvSetDropable;
      ObjStartDrag;
    }
  end
  if bool then
    ObjDoNotDrop = function()  end;
    int_inventory.InvSetDropable = function()  end;
    ld.InvSetDropable = function()  end;
    ObjStartDrag = function()  end;
  else
    ObjDoNotDrop = private.BotDisableObjDoNotDrop_cache[ 1 ];
    int_inventory.InvSetDropable = private.BotDisableObjDoNotDrop_cache[ 2 ];
    ld.InvSetDropable = private.BotDisableObjDoNotDrop_cache[ 3 ];
    ObjStartDrag = private.BotDisableObjDoNotDrop_cache[ 4 ];
  end
end
function public.BotTryStartStop()
      if private.BotStartNow and private.BotStepNow and ( not private.BotStepNowEnded ) then
        private.BotStartNow = false
        private.BotStepNow = false
      end
        
      if private.BotStartNow then
        private.BotStop();
        return
      else
        private.BotStart();
        return
      end
end

function private.BotStop()
  ld.LogTrace = common.LogTrace
  private.BotLog( "BotStop" )
  ng_global.bot = {}
  ObjDelete( "tmr_cheater_bot_step_wait_lock" )
  private.BotStartNow = false
  private.BotStepNow = false
  private.BotMakeScreenshot()
  private.BotDisableObjDoNotDrop( false )
  ne.SetTestMode( 0 )
  if private.BOT_START > 0 then
    ne.dbg.Quit()
  else
    ld.LogTrace( "\n\nBotAddedLogs", private.BotAddedLogs )
    private.BotAddedLogs = nil
  end
end
--основная фя бота
function private.BotStep()
  if not private.BotStartNow then
    private.BotStepNow = false
    private.BotLog( "BotStep: ERROR: Лишний запуск бота?" )
    return
  end


  private.BotStepNowEnded = false
  private.BotStepNow = true;

  if common.GetCurrentRoom() == "rm_outro" or common.GetCurrentRoom() == "rm_credits"
  or GetCurrentRoom() == "rm_outro" or GetCurrentRoom() == "rm_credits"
  then

    if private.bonus_enabled and private.BOT_AUTO_BONUS and ng_global.currentprogress == "std" then
      private.BotLog( "BotStep: основной час закончился, переходим в бонус, последний удачный шаг выполнен для прогресса '"..tostring( private.Bot_prg_previous ).."'" )
      private.BotStepNow = false
      ne.dbg.FireInputEvent( 0, 0, 0, 111 + 4 )
    else
      private.BotLog( "BotStep: игра кончилась, последний удачный шаг выполнен для прогресса '"..tostring( private.Bot_prg_previous ).."'" )
      private.BotStop()
    end

    return
  end

  local gameLockedNow, gameLockChecks = private.BotIsGameLocked()

  if not gameLockedNow then
    private.BotStepLog( "\n\nBotStep: новый шаг; предыдущий прогресс >> "..( private.Bot_prg_previous or "FIRST_STEP" ).."\n" )
  end

  if gameLockedNow then
    if gameLockChecks > private.BOT_GAME_LOCK_CHECK_MAX then
      if private.ExecuteLockHandler( private.Bot_prg_previous ) then
        private.BotStepWait()
      else
        private.BotLog( "BotStep: Игра заблокированна (BOT_GAME_LOCK_CHECK_MAX), последний выполненный прогресс "..private.Bot_prg_previous )
        private.BotStop()
        return
      end
    else
      private.BotStepLog( "Lock Now "..( private.Bot_prg_previous or "FIRST_STEP" ) )
      --private.BotStepWait()
      private.BotStepWaitLock()
    end
  elseif private.BotTryMapClose() then
    private.BotStepLog( "BotStep: ждём закрытия карты ботом" )
    private.BotStepWait()
  elseif ObjGet( "int_tutorial_impl" ).input and ObjGet( "int_tutorial" ).input then
  --tutorial skipper
    --private.BotTryObjClick("obj_int_tutorial_buttons_right")
    ObjGet("obj_int_tutorial_buttons_right").event_mdown()
    private.BotLog( "BotStep: int_tutorial_impl calling event_mdown" )
    private.BotStepWait()
  elseif private.ExecuteForceHandler( private.BotGetNextProgresName() ) then
    private.BotLog( "BotStep: ожидание ExecuteForceHandler для прогресса "..private.BotGetNextProgresName() )
    private.BotStepWait()
  elseif private.BotTryHint() then
    private.BotStepWait()
  elseif private.BotIsStepChainLocked( private.BotGetNextProgresName() ) then
    local gametStepChainLocked, gametStepChainLockeds = private.BotIsStepChainLocked( private.BotGetNextProgresName() )
    private.BotLog( "BotStep: бот залип на прогрессе (BOT_GAME_PRG_REPIATS_COUNT), последний выполненный прогресс "..private.Bot_prg_previous )
    private.BotStepSkip( private.BotGetNextProgresName() )
  elseif private.BotStep_obj_in_transporter_steps < 3 and private.BotIsAnyObjDraging() then
    -->> может возникнуть при ObjDoNotDrop и ObjStartDrag
    private.BotStep_obj_in_transporter_steps = private.BotStep_obj_in_transporter_steps + 1
    if private.BotStep_obj_in_transporter_steps >= 3 then
        private.BotLog( "BotTryObjClick >> ng_interface_transporter >> в руках бота предмет? предидущий прогресс >> '"..( private.Bot_prg_previous or "FALSE" ).."'" );
        private.BotMouseMove( { 9999; 9999; } )
        private.BotMouseUp( { 9999; 9999; } )
    end
    private.BotStepWait()
  else
    private.BotStep_obj_in_transporter_steps = 0
    local prg_next = private.BotGetNextProgresName();

    if prg_next then
      --private.BotLog( "BotStep >> "..prg_next.." >> "..(common.GetCurrentRoom() or "Room nil").." >> "..(common.GetCurrentSubRoom() or "zz nil" ) );

      local hnt = private.HINT_ROOT[ prg_next ]

      if private.BotTryHoDialogClick( prg_next ) then
        --ho win window clicker
        private.BotStepLog("бот пытается кликнуть по диалогу хо");
        private.BotStepWait()
      elseif private.BotTryMapOpen( prg_next ) then
        private.BotStepLog("бот пытается открыть/закрыть карту");
        private.BotStepWait()
      elseif hnt then
        if hnt.subzz then
          private.BotMakeSubZzGateConnections( hnt.zz, hnt.subzz )
        end
        local zz_to_go = hnt.zz 
        if hnt.zz_gate and not hnt.zz then
          local from_div = ld.StringDivide( hnt.room ) -- xx_yy
          local to_div = ld.StringDivide( hnt.zz_gate )-- gzz_yy_aa
          local yy = hnt.room:gsub( "^"..from_div[ 1 ].."_", "" )
          local zz = to_div[ 1 ]:gsub( "^g", "" )
          local aa = hnt.zz_gate:gsub( "^g"..zz.."_"..yy.."_", "" )
          zz_to_go = zz.."_"..aa
          private.BotLog( "BotStep: zz_to_go Remake "..prg_next.." >> "..zz_to_go )
        end
        if private.BotTryGoTo( hnt.subzz or zz_to_go or hnt.room ) then
          private.BotStepLog("ждем когда бот перейдет в нужное место");
          private.BotStepWait()
        elseif private.BotStopOnMg( prg_next ) then

        else
          if private.ExecuteActionHandler( prg_next ) then
            private.BotStepLog("если добавлен хендлер для прогресса, управление передаётся ему");
            private.BotStepWait()
          elseif private.BotTryTouch() then
            private.BotStepLog("трогатель объектов");
            private.BotStepWait(1.5)--параметр можно увеличить, если появятся баги с подбором предмета
          elseif hnt.type == "get" then
            if private.BotTryObjClick( hnt.get_obj ) then
              private.BotStepLog("бот пытается подобрать предмет, ждём");
              if private.BotTryForceQuit( prg_next )  then
                private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
              else
                private.BotStepWait()
              end
            else
              private.BotStepLog("бот не смог подобрать предмет");
              private.BotLog( "BotStep: не удалось подобрать предмет для прогресса "..prg_next )
              private.BotStepSkip( prg_next )
            end
          elseif hnt.type == "use" then
            if private.BotInvObjShow( hnt.inv_obj ) then
              if private.BotTryUsePlaceClick( hnt.use_place ) then
                private.BotStepLog("бот кликает по зоне применения, ждём");
                private.BotStepWait()
              --elseif private.BotTryObjUse( hnt.inv_obj, hnt.use_place, private.BotStepWait ) then
              elseif private.BotTryObjUse( hnt.inv_obj, hnt.use_place, function()
                  --пытаемся сломать игру форсквитом
                  if private.BotTryForceQuit( prg_next )  then
                    private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                  else
                    private.BotStepWait()
                  end
                end ) 
              then
                 private.BotStepLog("бот пытается применить предмет, ждём");
              else
                private.BotLog( "BotStep: не удалось применить предмет для прогресса "..prg_next )
                private.BotStepSkip( prg_next )
              end
            else
              private.BotStepLog("ждём показа предмета в инвентаре");
              private.BotStepWait()
            end
          elseif hnt.type == "click" then
            if prg_next:find( "^win_" ) then
              if private.BotTrySkipMg() then
                private.BotStepLog("бот скипает mmg, ждём");
                if private.BotTryForceQuit( prg_next ) then
                  private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                else
                  private.BotStepWait( 2 )
                end
              elseif hnt.room[ prg_next ] then
                private.BotStepLog("бот пытается вызвать функцию завершения ммг без интерфейса");
                hnt.room[ prg_next ]()
                if private.BotTryForceQuit( prg_next ) then
                  private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                else
                  private.BotStepWait( 2 )
                end
              elseif level_inv[ prg_next ] then
                private.BotStepLog("бот пытается вызвать функцию завершения ммг без интерфейса");
                level_inv[ prg_next ]()
                if private.BotTryForceQuit( prg_next ) then
                  private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                else
                  private.BotStepWait( 2 )
                end
              else
                if hnt.use_place and private.BotTryObjClick( hnt.use_place ) then
                  private.BotStepLog("бот пытается кликнуть по зоне ммг, возможно она открывает зум ммг");
                  if private.BotTryForceQuit( prg_next ) then
                    private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                  else
                    private.BotStepWait( 2 )
                  end
                elseif ObjGet( "int_button_skip" ).input then
                  ne.dbg.FireInputEvent( 0, 0, 0, 83 )
                  if private.BotTryObjClick( "obj_int_button_skip_impl" ) then
                    private.BotStepLog("бот пытается кликнуть по скипу");
                    if private.BotTryForceQuit( prg_next ) then
                      private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                    else
                      private.BotStepWait( 2 )
                    end
                  else
                    private.BotLog( "BotStep: не удалось скипнуть ммг "..prg_next )
                    private.BotStepSkip( prg_next )
                  end
                else
                  private.BotLog( "BotStep: не удалось открыть/скипнуть ммг "..prg_next )
                  private.BotStepSkip( prg_next )
                end
              end
            else
              if private.BotTryObjClick( hnt.use_place ) then
                private.BotStepLog("бот пытается кликнуть по зоне клика, ждём");
                --private.BotLog( "BotStep: бот пытается кликнуть по зоне клика, ждём "..hnt.use_place )
                if private.BotTryForceQuit( prg_next ) then
                  private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                else
                  private.BotStepWait()
                end
              else
                private.BotLog( "BotStep: не удалось кликнуть по зоне клика для прогресса "..prg_next )
                private.BotStepSkip( prg_next )
              end
            end
          elseif hnt.type == "win" then
            --ld.LogTrace(hnt)
            if not hnt.zz and not hnt.zz_gate then
              --HH13
              private.BotLog( "BotStep: Mg in RM ? "..prg_next )
              if private.BotTrySkipMg() then
                private.BotStepLog("бот скипает MG, ждём");
                if private.BotTryForceQuit( prg_next ) then
                  private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                else
                  private.BotStepWait( 2 )
                end
              elseif private.BotTrySkipMg( true ) then
                private.BotStepLog("бот скипает MG, ждём");
                if private.BotTryForceQuit( prg_next ) then
                  private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                else
                  private.BotStepWait( 2 )
                end
              else
                private.BotLog( "BotStep: не удалось cкипнуть мг0 "..prg_next )
                private.BotStepSkip( prg_next )
              end
            elseif ( hnt.zz and hnt.zz:find( "^ho_" ) ) or ( hnt.zz_gate and hnt.zz_gate:find( "^gho_" ) ) then
              private.BotStepLog("бот скипает HO, ждём");
              
              --ne.dbg.FireInputEvent( 0,0,0, 32 ); --not used because double click appearing
              common_impl.DialogHo_Show()
              private.BotLock( 1 )
              ld.StartTimer( 2, function() 
                private.BotLock( 0 )
                private.BotMouseClick( { 512, 384 } )
                private.BotStepWait( 2 )
              end )
              
            elseif ( hnt.zz and hnt.zz:find( "^mg_" ) ) or ( hnt.zz_gate and hnt.zz_gate:find( "^gmg_" ) ) then
              if private.BotTrySkipMg( not hnt.zz ) then
                private.BotStepLog("бот скипает MG, ждём");
                if private.BotTryForceQuit( prg_next ) then
                  private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                else
                  private.BotStepWait( 2 )
                end
              else
                private.BotLog( "BotStep: не удалось cкипнуть мг1 "..prg_next )
                private.BotStepSkip( prg_next )
              end
            elseif ObjGet( "int_button_skip" ).input then
              ne.dbg.FireInputEvent( 0, 0, 0, 83 )
              if private.BotTryObjClick( "obj_int_button_skip_impl" ) then
                private.BotStepLog("бот пытается кликнуть по скипу");
                if private.BotTryForceQuit( prg_next ) then
                  private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                else
                  private.BotStepWait( 2 )
                end
              else
                private.BotLog( "BotStep: не удалось скипнуть ммг "..prg_next )
                private.BotStepSkip( prg_next )
              end
            elseif _G[ld.Room.Current()].mini_ho or (interface.GetCurrentComplexInv() ~= "" and level_inv.mini_ho) then
              private.BotStepLog("бот скипает HO, ждём");
              ne.dbg.FireInputEvent( 0,0,0, 32 );
              private.BotLock( 1 )
              ld.StartTimer( 2, function() 
                private.BotLock( 0 )
                private.BotMouseClick( { 512, 384 } )
                private.BotStepWait( 2 )
              end )                
            elseif _G[ common.GetCurrentSubRoom() ].Skip then
              if private.BotMmgSkiping == prg_next then
                private.BotLog( "BotStep: не удалось cкипнуть vмг "..prg_next )
                private.BotStepSkip( prg_next )
              else
                private.BotMmgSkiping = prg_next
                _G[  common.GetCurrentSubRoom() ].Skip()
              end
            else
              private.BotLog( "BotStep: неправильный тип хинта для ммг? "..prg_next )
              interface.DialogShow( "BotStep: неправильный тип хинта для ммг? "..prg_next );
              private.BotStop()
            end
          end
          private.BotTryMakeScreenshot()
        end
      elseif prg_next:find( "^opn_" ) then
        local go_to_room = prg_next:gsub( "^opn_", "rm_" )
        if not ObjGet( go_to_room ) then
          go_to_room = prg_next:gsub( "^opn_", "ho_" )
        end
        if private.BotTryGoTo( go_to_room ) then
          private.BotStepLog("ждем когда бот перейдет в нужное место");
          private.BotStep_BotTryGoTo_last = false
          private.BotStepWait()
        elseif private.BotStep_BotTryGoTo_last ~= go_to_room then
          private.BotStepLog("ждем на всякий случай");
          private.BotStep_BotTryGoTo_last = go_to_room
          private.BotStepWait()
        else
          private.BotLog( "BotStep: не удается пройти в "..go_to_room.." ("..prg_next..")" )
          private.BotStepSkip( prg_next )
        end
      else
        private.BotLog( "BotStep: не найден хинт для "..prg_next )
        if private.NO_HINT_SKIP and not private.BotNoHintSkips[ prg_next ] then
          private.BotNoHintSkips[ prg_next ] = true
          private.BotStepWait()
        else
          private.BotStepSkip( prg_next )
        end
      end
      private.Bot_prg_previous = prg_next;
    else
      ld.LogTrace( private.BOT_AUTO_BONUS, ng_global.currentprogress )
      if private.bonus_enabled and private.BOT_AUTO_BONUS and ng_global.currentprogress == "std" then
        private.BotLog( "BotStep: прогресс для следующего шага не найден, переходим в бонус, последний удачный шаг выполнен для прогресса '"..tostring( private.Bot_prg_previous ).."'" )
        private.BotStepNow = false
        ne.dbg.FireInputEvent( 0, 0, 0, 111 + 4 )
      else
        private.BotLog( "прогресс для следующего шага не найден, последний удачный шаг выполнен для прогресса '"..tostring( private.Bot_prg_previous ).."'" )
        private.BotStop()
      end
    end
  end
  private.BotStepNowEnded = true
end

function private.BotStopOnMg( prg )
  if private.BOT_STOP_ON_MG then 
    if prg:find( "^win" ) and not GetCurrentRoom():find( "^ho" ) then
      private.BotLog("Бот остановлен для ручного прохождения МГ");
      private.BotStop()
      interface.DialogShow("Бот остановлен для ручного прохождения МГ")
      private.BotStepNowEnded = true
      return true
    end
  end
end

function private.BotBrootForce()
  
end

function private.BotStepSkip( prg_skip )
  --здесь нужно отлавливать прогресс который,
  --который проходится нестандартно
  if private.ExecuteStackHandler( prg_skip ) then
    --функция хендлер тестеров, если хендлер знает что нужно делать
    --должна возвращать TRUE, бот будет ждать....
    private.BotStepWait()
  elseif private.BOT_ALLOW_SKIP then
    cmn.SetEventDone( prg_skip );
    cmn.CallEventHandler( prg_skip );
    private.BotLog( "BotStepSkip: програмное выполнение прогресса "..prg_skip )
    private.BotStepWait()
  else
    if _G[GetCurrentRoom()].DialogHo_Show_Custom  then
      _G[GetCurrentRoom()].DialogHo_Show_Custom();
      private.BotLog( "BotStepSkip: програмное выполнение DialogHo_Show_Custom();" )
      private.BotStepWait()
    else
      private.BotLog( "BotStepSkip: бот не смог выполнить '"..prg_skip.."' и был остановлен" )
      private.BotStop()
    end
  end

end
--
function private.BotStepWait( waits_count )
  waits_count = waits_count or 1
  ld.StartTimer( private.BOT_STEP_WAIT * waits_count, private.BotStep )
end
--
function private.BotStepWaitLock()
  if private.BotIsGameLocked( true ) then
    ld.StartTimer( 0, private.BotStepWaitLock )
    if not ObjGet( "tmr_cheater_bot_step_wait_lock" ) then
      local wait_t = private.BOT_STEP_WAIT * private.BOT_GAME_LOCK_CHECK_MAX
      ld.StartTimer( "tmr_cheater_bot_step_wait_lock", wait_t, function() 
        private.BotIsGameLockedBreak()
      end )
    end
  else  
    ObjDelete( "tmr_cheater_bot_step_wait_lock" )
    ld.StartTimer( private.BOT_ATER_LOCK_WAIT_TAIM, private.BotStep )
  end
end
--
function private.BotLock( state )
  private.BotLockNow = stste
  --ld.LockCustom( "bot_lock_now", state )
end
--function get() end
  --zrm - 
  --нужно переделать/доделать, возможно отсутствие гейтов
  function private.BotGetConnectedZRM( zrm, room_step, checked, count )
    room_step = room_step or common.GetCurrentRoom()
    checked = checked or {}
    count = count or 0
    if zrm == room_step then
      return room_step
    else

      private.BotMakeZzGateConnections( zrm )
      private.BotMakeZzGateConnections( room_step )

      --ld.LogTrace( private.BotGateConnection )

      local connect = private.BotGateConnection[ room_step ]

      --ld.LogTrace( count, zrm, room_step, connect )

      for i = 1, #connect.childs do
        if not checked[ connect.childs[ i ] ] then
          checked[ connect.childs[ i ] ] = true
          if connect.childs[ i ] == zrm then
            --ld.LogTrace( "checked 1 "..count.." "..room_step )
            --table.insert( answer, room_step )
            return room_step
          else
            local child = private.BotGetConnectedZRM( zrm, connect.childs[ i ], checked, count + 1 )
            if child then
              --ld.LogTrace( "checked 2 "..count.." "..room_step )

              return child
            end
          end
        end
      end
      if connect.parent and not checked[ connect.parent ] then
        --ld.LogTrace( private.BotGateConnection )
        checked[ connect.parent ] = true
        if connect.parent == zrm then
          --ld.LogTrace( "checked 3 "..count.." "..room_step )
          --table.insert( answer, room_step )
          return room_step
        else
          local child = private.BotGetConnectedZRM( zrm, connect.parent, checked, count + 1 )
          if child then
            --ld.LogTrace( "checked 4 "..count.." "..room_step )

            return child
          end
        end
      end


    end
    --if ObjGet( private.BotMakeGate( room_step, zrm ) ) then
    --  return zrm;
    --end
    return false
  end
  --возвращает следующий прогресс
  function private.BotGetNextProgresName()

    local prg_next;

    if ld_impl.SmartHint_GetNearestPrg then
      prg_next = ld_impl.SmartHint_GetNearestPrg()
    end

    if not prg_next then
      local progress = private.GetGlobalProgress();
      local progress_names = private.GetProgressNames();
      for i = 1, #progress_names, 1 do
        if ( progress[ progress_names[ i ] ].done == 0 ) then
          if private.BotNoHintSkips[ progress_names[ i ] ] then
            ld.LogTrace("BotNoHintSkips",progress_names[ i ])
          else
            prg_next = progress_names[ i ];
            break;
          end
        end;
      end;
    end

    return prg_next;

  end
  --
  --нужно переделать, косвенное значение
  function private.BotGetRealDragingObj( obj )
    while ObjGetRelations( obj ).parent do
      if ObjGetRelations( obj ).parent == "ng_interface_transporter" then
        return obj
      else
        obj = ObjGetRelations( obj ).parent
      end
    end
    return false
  end
  --
  function private.BotGetCurrentPlace()
    local place = interface.GetCurrentComplexInv()
    if place == "" then
      place = common.GetCurrentSubRoom() or common.GetCurrentRoom()
    end
    if place == "" then
      place = common.GetCurrentSubRoom() or common.GetCurrentRoom()
    end
    return place;
  end
  --
--function get_end() end
--function is() end
  function private.BotIsInPrgPlace( prg )
    
    local hnt = private.HINT_ROOT[ prg ]
    if not hnt then return false end

    local zrm = hnt.zz and hnt.zz or hnt.room
    return zrm == private.BotGetCurrentPlace()

  end
  --
  function private.BotIsObjInPrg( obj )
    --проверяет, принадлежит ли объект к какому то ни было прогрессу
    for k, v in pairs( private.HINT_ROOT ) do
      if obj == v.get_obj or obj == v.use_place then
        --ld.LogTrace( "BotIsObjInPrg", obj, true )
        return true
      end
    end
        --ld.LogTrace( "BotIsObjInPrg", obj, false )
    return false
  end
  function private.BotIsAnyObjDraging()
    return #ObjGetRelations( "ng_interface_transporter" ).childs > 0
  end
  --
  function private.BotIsObjDragNow( obj, parent )
    parent = parent or "ng_interface_transporter"
    local childs = ObjGetRelations( parent ).childs
    for i = 1, #childs do
      --ld.LogTrace( obj, parent, childs[ i ] )
      if childs[ i ] == obj or private.BotIsObjDragNow( obj, childs[ i ] ) then
        --ld.LogTrace( "YES!!!" )
        return true
      end
    end
    return false
  end
  --
  function private.BotIsParentRoom( now_room, check_room )
    local connect = private.BotGateConnection[ now_room ]
    return connect and connect.parent == check_room
  end
  --
  function private.BotIsRoomChild( room1, room2 )
    local progress_names = private.GetProgressNames();
    local prg1 = "opn_"..ld.StringDivide( room1 )[ 2 ]
    local prg2 = "opn_"..ld.StringDivide( room2 )[ 2 ]
    for i = 1, #progress_names, 1 do
      if progress_names[ i ] == prg1 then
        --ld.LogTrace( room1.." parent for "..room2 )
        return true
      elseif progress_names[ i ] == prg2 then
        --ld.LogTrace( room1.." child for "..room2 )
        return false
      end;
    end;
    return false;
  end
  --
  --проверка на заблокированность + обработка диалогов
  function private.BotIsGameLocked( not_counted )
    private.screen_lock_objects = {
      "obj_int_lock";--CHEB
      "obj_int_lock_room";--CHEB
      "obj_int_lock_Custom_use";--CHEB OLD CUSTOM
    }
    local bool = false;
    if int_lock and int_lock.IsAnyCustomNow and int_lock.IsAnyCustomNow() then
      bool = true
    elseif private.BotLockNow then
      bool = true
    else
      local o
      for i = 1, #private.screen_lock_objects do
        o = ObjGet( private.screen_lock_objects[ i ] )
        if o and o.input then
          bool = true;
          break
        end
      end
    end

    --int_dialog_vide
    if not bool then
      if ObjGet( "int_dialog_video" ) and ObjGet( "int_dialog_video" ).input then
        bool = true
        if ObjGet( "obj_int_dialog_video_skip" ) and ObjGet( "obj_int_dialog_video_skip" ).input then
          int_dialog_video.SkipClick()
        end
      end
    end

    --int_dialog_story
    if not bool then
      if ObjGet( "int_dialog_story" ) and ObjGet( "int_dialog_story" ).input then
        bool = true
        if ObjGet( "obj_int_dialog_story_skip" ) and ObjGet( "obj_int_dialog_story_skip" ).input then
          int_dialog_story.SkipClick()
        elseif ObjGet( "obj_int_dialog_story_continue" ) and ObjGet( "obj_int_dialog_story_continue" ).input then
          int_dialog_story.ContinueClick()
        end
      end
    end

    --int_dialog_character
    if not bool then
      if ObjGet( "int_dialog_character" ) and ObjGet( "int_dialog_character" ).input then
        bool = true
        if private.BotIsGameLocked_count < private.BOT_GAME_PRG_REPIATS_COUNT / 2 then
          private.BotMouseClick( { 512; 384 } )
        else
        --if ObjGet( "obj_int_dialog_character_skip" ) and ObjGet( "obj_int_dialog_character_skip" ).input then
          int_dialog_character.SkipClick()
        --elseif ObjGet( "obj_int_dialog_character_continue" ) and ObjGet( "obj_int_dialog_character_continue" ).input then
        --  int_dialog_character.ContinueClick()
        --end
        end
      end
    end

    if bool then
      if not_counted then

      else
        private.BotIsGameLocked_count = private.BotIsGameLocked_count + 1
      end
    else
      private.BotIsGameLocked_count = 0
    end
    return bool, private.BotIsGameLocked_count
  end
  function private.BotIsGameLockedBreak()
    private.BotIsGameLocked_count = private.BOT_GAME_LOCK_CHECK_MAX
  end
  --
  --проверка на затуп бота на пргрессе
  function private.BotIsStepChainLocked( prg )
    if not prg then
      return false, 0
    end
    table.insert( private.BotStepChain_log, prg )
    local count = 0
    for i = #private.BotStepChain_log, 1, -1 do
      if count > private.BOT_GAME_PRG_REPIATS_COUNT then
        return true, count
      elseif private.BotStepChain_log[ i ] == prg then
        count = count + 1
      else
        return false, count
      end
    end;
    return false, count
  end
--
--function try() end
--
  function private.BotTrySkipSystem()
    --попытка скипнуть/кликнуть/подождать любые системные/програмные/диалоговые вещи

    if gameprivate.BotIsGameLocked( true ) then
      private.BotStepLog( "BotTrySkipSystem >> BotTryMapClose" )
      return true 
    elseif private.BotTryMapClose() then
      private.BotStepLog( "BotTrySkipSystem >> BotTryMapClose" )
      return true 
    elseif ObjGet( "int_tutorial_impl" ).input and ObjGet( "int_tutorial" ).input then
      ObjGet( "obj_int_tutorial_buttons_right" ).event_mdown()
      private.BotLog( "BotStep: int_tutorial_impl calling event_mdown" )
      return true 
    elseif private.BotTryHint() then
      return true 
    elseif private.BotIsStepChainLocked( private.BotGetNextProgresName() ) then
      local gametStepChainLocked, gametStepChainLockeds = private.BotIsStepChainLocked( private.BotGetNextProgresName() )
      private.BotLog( "BotStep: бот залип на прогрессе (BOT_GAME_PRG_REPIATS_COUNT), последний выполненный прогресс "..private.Bot_prg_previous )
      private.BotStepSkip( private.BotGetNextProgresName() )
    elseif private.BotStep_obj_in_transporter_steps < 3 and private.BotIsAnyObjDraging() then
      -->> может возникнуть при ObjDoNotDrop и ObjStartDrag
      private.BotStep_obj_in_transporter_steps = private.BotStep_obj_in_transporter_steps + 1
      if private.BotStep_obj_in_transporter_steps >= 3 then
          private.BotLog( "BotTryObjClick >> ng_interface_transporter >> в руках бота предмет? предидущий прогресс >> '"..( private.Bot_prg_previous or "FALSE" ).."'" );
          private.BotMouseMove( { 9999; 9999; } )
          private.BotMouseUp( { 9999; 9999; } )
      end
      private.BotStepWait()
    else
      private.BotStep_obj_in_transporter_steps = 0
      local prg_next = private.BotGetNextProgresName();

      if prg_next then
        --private.BotLog( "BotStep >> "..prg_next.." >> "..(common.GetCurrentRoom() or "Room nil").." >> "..(common.GetCurrentSubRoom() or "zz nil" ) );

        local hnt = private.HINT_ROOT[ prg_next ]

        if private.BotTryHoDialogClick( prg_next ) then
          --ho win window clicker
          private.BotStepLog("бот пытается кликнуть по диалогу хо");
          private.BotStepWait()
        elseif private.BotTryMapOpen( prg_next ) then
          private.BotStepLog("бот пытается открыть/закрыть карту");
          private.BotStepWait()
        elseif hnt then
          if hnt.subzz then
            private.BotMakeSubZzGateConnections( hnt.zz, hnt.subzz )
          end
          local zz_to_go = hnt.zz 
          if hnt.zz_gate and not hnt.zz then
            local from_div = ld.StringDivide( hnt.room ) -- xx_yy
            local to_div = ld.StringDivide( hnt.zz_gate )-- gzz_yy_aa
            local yy = hnt.room:gsub( "^"..from_div[ 1 ].."_", "" )
            local zz = to_div[ 1 ]:gsub( "^g", "" )
            local aa = hnt.zz_gate:gsub( "^g"..zz.."_"..yy.."_", "" )
            zz_to_go = zz.."_"..aa
            private.BotLog( "BotStep: zz_to_go Remake "..prg_next.." >> "..zz_to_go )
          end
          if private.BotTryGoTo( hnt.subzz or zz_to_go or hnt.room ) then
            private.BotStepLog("ждем когда бот перейдет в нужное место");
            private.BotStepWait()
          elseif private.BotStopOnMg( prg_next ) then

          else
            if private.ExecuteActionHandler( prg_next ) then
              private.BotStepLog("если добавлен хендлер для прогресса, управление передаётся ему");
              private.BotStepWait()
            elseif private.BotTryTouch() then
              private.BotStepLog("трогатель объектов");
              private.BotStepWait(1.5)--параметр можно увеличить, если появятся баги с подбором предмета
            elseif hnt.type == "get" then
              if private.BotTryObjClick( hnt.get_obj ) then
                private.BotStepLog("бот пытается подобрать предмет, ждём");
                if private.BotTryForceQuit( prg_next )  then
                  private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                else
                  private.BotStepWait()
                end
              else
                private.BotStepLog("бот не смог подобрать предмет");
                private.BotLog( "BotStep: не удалось подобрать предмет для прогресса "..prg_next )
                private.BotStepSkip( prg_next )
              end
            elseif hnt.type == "use" then
              if private.BotInvObjShow( hnt.inv_obj ) then
                if private.BotTryUsePlaceClick( hnt.use_place ) then
                  private.BotStepLog("бот кликает по зоне применения, ждём");
                  private.BotStepWait()
                --elseif private.BotTryObjUse( hnt.inv_obj, hnt.use_place, private.BotStepWait ) then
                elseif private.BotTryObjUse( hnt.inv_obj, hnt.use_place, function()
                    --пытаемся сломать игру форсквитом
                    if private.BotTryForceQuit( prg_next )  then
                      private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                    else
                      private.BotStepWait()
                    end
                  end ) 
                then
                   private.BotStepLog("бот пытается применить предмет, ждём");
                else
                  private.BotLog( "BotStep: не удалось применить предмет для прогресса "..prg_next )
                  private.BotStepSkip( prg_next )
                end
              else
                private.BotStepLog("ждём показа предмета в инвентаре");
                private.BotStepWait()
              end
            elseif hnt.type == "click" then
              if prg_next:find( "^win_" ) then
                if private.BotTrySkipMg() then
                  private.BotStepLog("бот скипает mmg, ждём");
                  if private.BotTryForceQuit( prg_next ) then
                    private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                  else
                    private.BotStepWait( 2 )
                  end
                elseif hnt.room[ prg_next ] then
                  private.BotStepLog("бот пытается вызвать функцию завершения ммг без интерфейса");
                  hnt.room[ prg_next ]()
                  if private.BotTryForceQuit( prg_next ) then
                    private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                  else
                    private.BotStepWait( 2 )
                  end
                elseif level_inv[ prg_next ] then
                  private.BotStepLog("бот пытается вызвать функцию завершения ммг без интерфейса");
                  level_inv[ prg_next ]()
                  if private.BotTryForceQuit( prg_next ) then
                    private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                  else
                    private.BotStepWait( 2 )
                  end
                else
                  if hnt.use_place and private.BotTryObjClick( hnt.use_place ) then
                    private.BotStepLog("бот пытается кликнуть по зоне ммг, возможно она открывает зум ммг");
                    if private.BotTryForceQuit( prg_next ) then
                      private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                    else
                      private.BotStepWait( 2 )
                    end
                  elseif ObjGet( "int_button_skip" ).input then
                    ne.dbg.FireInputEvent( 0, 0, 0, 83 )
                    if private.BotTryObjClick( "obj_int_button_skip_impl" ) then
                      private.BotStepLog("бот пытается кликнуть по скипу");
                      if private.BotTryForceQuit( prg_next ) then
                        private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                      else
                        private.BotStepWait( 2 )
                      end
                    else
                      private.BotLog( "BotStep: не удалось скипнуть ммг "..prg_next )
                      private.BotStepSkip( prg_next )
                    end
                  else
                    private.BotLog( "BotStep: не удалось открыть/скипнуть ммг "..prg_next )
                    private.BotStepSkip( prg_next )
                  end
                end
              else
                if private.BotTryObjClick( hnt.use_place ) then
                  private.BotStepLog("бот пытается кликнуть по зоне клика, ждём");
                  --private.BotLog( "BotStep: бот пытается кликнуть по зоне клика, ждём "..hnt.use_place )
                  if private.BotTryForceQuit( prg_next ) then
                    private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                  else
                    private.BotStepWait()
                  end
                else
                  private.BotLog( "BotStep: не удалось кликнуть по зоне клика для прогресса "..prg_next )
                  private.BotStepSkip( prg_next )
                end
              end
            elseif hnt.type == "win" then
              --ld.LogTrace(hnt)
              if not hnt.zz and not hnt.zz_gate then
                --HH13
                private.BotLog( "BotStep: Mg in RM ? "..prg_next )
                if private.BotTrySkipMg() then
                  private.BotStepLog("бот скипает MG, ждём");
                  if private.BotTryForceQuit( prg_next ) then
                    private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                  else
                    private.BotStepWait( 2 )
                  end
                elseif private.BotTrySkipMg( true ) then
                  private.BotStepLog("бот скипает MG, ждём");
                  if private.BotTryForceQuit( prg_next ) then
                    private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                  else
                    private.BotStepWait( 2 )
                  end
                else
                  private.BotLog( "BotStep: не удалось cкипнуть мг0 "..prg_next )
                  private.BotStepSkip( prg_next )
                end
              elseif ( hnt.zz and hnt.zz:find( "^ho_" ) ) or ( hnt.zz_gate and hnt.zz_gate:find( "^gho_" ) ) then
                private.BotStepLog("бот скипает HO, ждём");
                ne.dbg.FireInputEvent( 0,0,0, 32 );
                private.BotLock( 1 )
                ld.StartTimer( 2, function() 
                  private.BotLock( 0 )
                  private.BotMouseClick( { 512, 384 } )
                  private.BotStepWait( 2 )
                end )
              elseif ( hnt.zz and hnt.zz:find( "^mg_" ) ) or ( hnt.zz_gate and hnt.zz_gate:find( "^gmg_" ) ) then
                if private.BotTrySkipMg( not hnt.zz ) then
                  private.BotStepLog("бот скипает MG, ждём");
                  if private.BotTryForceQuit( prg_next ) then
                    private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                  else
                    private.BotStepWait( 2 )
                  end
                else
                  private.BotLog( "BotStep: не удалось cкипнуть мг1 "..prg_next )
                  private.BotStepSkip( prg_next )
                end
              elseif ObjGet( "int_button_skip" ).input then
                ne.dbg.FireInputEvent( 0, 0, 0, 83 )
                if private.BotTryObjClick( "obj_int_button_skip_impl" ) then
                  private.BotStepLog("бот пытается кликнуть по скипу");
                  if private.BotTryForceQuit( prg_next ) then
                    private.BotStepLog( "бот выполняет ForceQuit на прогрессе "..prg_next )
                  else
                    private.BotStepWait( 2 )
                  end
                else
                  private.BotLog( "BotStep: не удалось скипнуть ммг "..prg_next )
                  private.BotStepSkip( prg_next )
                end
              elseif _G[ GetCurrentSubRoom() ].Skip then
                if private.BotMmgSkiping == prg_next then
                  private.BotLog( "BotStep: не удалось cкипнуть vмг "..prg_next )
                  private.BotStepSkip( prg_next )
                else
                  private.BotMmgSkiping = prg_next
                  _G[ GetCurrentSubRoom() ].Skip()
                end
              else
                private.BotLog( "BotStep: неправильный тип хинта для ммг? "..prg_next )
                interface.DialogShow( "BotStep: неправильный тип хинта для ммг? "..prg_next );
                private.BotStop()
              end
            end
            private.BotTryMakeScreenshot()
          end
        elseif prg_next:find( "^opn_" ) then
          local go_to_room = prg_next:gsub( "^opn_", "rm_" )
          if not ObjGet( go_to_room ) then
            go_to_room = prg_next:gsub( "^opn_", "ho_" )
          end
          if private.BotTryGoTo( go_to_room ) then
            private.BotStepLog("ждем когда бот перейдет в нужное место");
            private.BotStep_BotTryGoTo_last = false
            private.BotStepWait()
          elseif private.BotStep_BotTryGoTo_last ~= go_to_room then
            private.BotStepLog("ждем на всякий случай");
            private.BotStep_BotTryGoTo_last = go_to_room
            private.BotStepWait()
          else
            private.BotLog( "BotStep: не удается пройти в "..go_to_room.." ("..prg_next..")" )
            private.BotStepSkip( prg_next )
          end
        else
          private.BotLog( "BotStep: не найден хинт для "..prg_next )
          if private.NO_HINT_SKIP and not private.BotNoHintSkips[ prg_next ] then
            private.BotNoHintSkips[ prg_next ] = true
            private.BotStepWait()
          else
            private.BotStepSkip( prg_next )
          end
        end
        private.Bot_prg_previous = prg_next;
      else
        ld.LogTrace( private.BOT_AUTO_BONUS, ng_global.currentprogress )
        if private.bonus_enabled and private.BOT_AUTO_BONUS and ng_global.currentprogress == "std" then
          private.BotLog( "BotStep: прогресс для следующего шага не найден, переходим в бонус, последний удачный шаг выполнен для прогресса '"..tostring( private.Bot_prg_previous ).."'" )
          private.BotStepNow = false
          ne.dbg.FireInputEvent( 0, 0, 0, 111 + 4 )
        else
          private.BotLog( "прогресс для следующего шага не найден, последний удачный шаг выполнен для прогресса '"..tostring( private.Bot_prg_previous ).."'" )
          private.BotStop()
        end
      end
    end
    return false
  end
  --
  function private.BotTryMapOpen( prg )
    --режим не активирован
    if private.BOT_MAP_OPEN <= 0 then
      return false
    end
    --local zrm = common.GetCurrentRoom()
    local zrm =private.BotGetCurrentPlace()
    if not private.BotTryMapOpen_params[ prg ] then
      private.BotTryMapOpen_params[ prg ] = {}
    end
    if not private.BotTryMapOpen_params[ prg ][ zrm ] then
      private.BotTryMapOpen_params[ prg ][ zrm ] = {
        count = 0;
      }
    end
    
    local params = private.BotTryMapOpen_params[ prg ][ zrm ]

    if private.BotTryMapClose() then
      return true
    else
    --открываем карту
      if params.count >= private.BOT_MAP_OPEN then
        private.BotStepLog( "BotTryMapOpen >> карта уже открывалась необходимое количество раз >> prg = "..prg.."; zrm = "..zrm..";" )
        return false
      end
      if private.BotTryObjClick( "obj_int_button_map", false, "бот пытался кликнуть по кнопке карты" ) then
        private.BotStepLog( "BotTryMapOpen >> кликнули по кнопке карты >> prg = "..prg.."; zrm = "..zrm..";" )
        params.count = params.count + 1
        return true
      else
        private.BotStepLog( "не удалось кликнуть по кнопке карты, завершаем попытки >> prg = "..prg.."; zrm = "..zrm..";" )
        params.count = private.BOT_MAP_OPEN
        return false
      end

    end
    
    return false
  end
  --
  function private.BotTryMapClose()
    if ObjGetRelations( "int_map_impl" ).parent == "int_map" then
      if private.BotTryObjClick( "obj_map_btn_close", false, "бот пытался кликнуть по кнопке закрытия карты" ) then
        private.BotStepLog( "BotTryMapClose >> карта была открыта, закрываем её" )
        return true
      else
        private.BotStepLog( "BotTryMapOpen >> бот не смог закыть карту", prg, zrm )
        --params.opened = false
        return false
      end
    end
    return false
  end
  --
  function private.BotTryForceQuit( prg )
    if private.BOT_FORCE_QUIT <= 0 then
      return false
    end
    ng_global.bot.force_quit = ng_global.bot.force_quit or {}
    --ld.LogTrace( "BotTryForceQuit", prg, ng_global.bot.force_quit )
    if ng_global.bot.force_quit.prg ~= prg or ng_global.bot.force_quit.count < private.BOT_FORCE_QUIT then
      if ng_global.bot.force_quit.prg ~= prg then
        ng_global.bot.force_quit.count = 0
      end
      local level = ng_global.progress[ ng_global.currentprogress ].common.chapter;
      ng_global.bot.force_quit = {
        prg = prg;
        count = ng_global.bot.force_quit.count + 1;
        level = level;
      }
      PauseLevel( 1 );
      common.LevelSwitch( "menu", "game" );
      return true
    end
    return false
  end
  --
  function private.BotTryHoDialogClick( prg_next )
    local obj_int = ObjGet( "int_dialog_ho" )
    local obj_impl = ObjGet( "obj_int_dialog_ho_impl_root" ) or ObjGet( "obj_int_dialog_ho_root" )
    if obj_int and obj_int. input and obj_impl and obj_impl.input then
      --if private.BotClickCounter( "BotTryHoDialogClick", false ) >= 1 then
      --  private.BotLog( "BotStep: не удалось кликнуть по диалогу хо "..prg_next )
      --  return false
      --else
      if private.BotTryObjClick( obj_impl.name ) then
        private.BotClickCounter( "BotTryHoDialogClick", false )
        private.BotLog( "BotStep: бот пытается кликнуть по диалогу хо "..prg_next )
        return true
      else
        private.BotLog( "BotStep: не удалось кликнуть по диалогу хо "..prg_next )
        return false
      end
    else
      return false
    end
  end
  --
  function private.BotTryUsePlaceClick( use_place )
    if private.BotTryUsePlaceClickNow >= private.BOT_USE_PLACE_CLICKS then
      private.BotTryUsePlaceClickNow = 0
      return false
    elseif private.BotTryObjClick( use_place ) then
      private.BotTryUsePlaceClickNow = private.BotTryUsePlaceClickNow + 1
      return true
    else
      private.BotTryUsePlaceClickNow = 0
      return false
    end
  end
  --
  function private.BotTryTouch()
    --ld.LogTrace( "  BUG SEARCHING ================>  way1" );
    if private.BOT_ALL_OBJS_TOUCH <= 0 then
      --ld.LogTrace( "  BUG SEARCHING ================>  way2" );
      return false
    end
    --ld.LogTrace( "  BUG SEARCHING ================>  way3" );
    local list = private.BotToucherGetObjs()
    for i = 1, #list do
      if not private.BotTryTouch_touched[ list[ i ] ] then
        private.BotTryTouch_touched[ list[ i ] ] = 0;
        --ld.LogTrace( "  BUG SEARCHING ================>  way4" );
      end
      --ld.LogTrace( "  BUG SEARCHING ================>  way5" );
      if private.BotTryTouch_touched[ list[ i ] ] < private.BOT_ALL_OBJS_TOUCH then
        --ld.LogTrace( "BotTryTouch >> BotTryObjClick >>", list[ i ] )
        --ld.LogTrace( "  BUG SEARCHING ================>  way6" );
        if private.BotTryObjClick( list[ i ], false, "BotTryTouch Error: >> "..list[ i ] ) then
          --ld.LogTrace( "  BUG SEARCHING ================>  way7" );
          private.BotTryTouch_touched[ list[ i ] ] = private.BotTryTouch_touched[ list[ i ] ] + 1
          return true;
        end
      end
    end
    --ld.LogTrace( "BotTryTouch", list )
    return false
  end
  --
  function private.BotTryObjClick( obj_name, fake, error_message )
    --ld.LogTrace( "BotTryObjClick", obj_name, fake, error_message )
    local o = ObjGet( obj_name )
    if o and o.input then
      local clickLog = private.BotClickLogger( obj_name )
      if clickLog >= private.BOT_CLICKS_BEFORE_STOP then
        return false
      elseif clickLog == private.BOT_CLICKS_BEFORE_FAKE - 1 then
        --если цетр объекта перегорожен или прозрачный, возможно gfx этого объекта указывает в кликабелльное место ( для подбираемых предметов должно быть реализовано )
        local div = ld.StringDivide( obj_name )
        local gfx = obj_name:gsub( "^"..div[ 1 ], "gfx" )
        if ObjGet( gfx ) then
          obj_name = gfx
          o = ObjGet( obj_name )
        end
      elseif clickLog == private.BOT_CLICKS_BEFORE_FAKE then
        --пытаемся найти место клика и кликнуть
        private.BotTryObjClick_FindClickablePoint( obj_name )
      elseif clickLog >= private.BOT_CLICKS_BEFORE_FAKE then
        private.BotLog( "BotTryObjClick: prg_current >> '"..private.BotGetNextProgresName().."'; object >> '"..obj_name.."' - стандартный клик не удался (BOT_CLICKS_BEFORE_FAKE), возможно кликаем в прозрачку или объект перекрыт, пытаемся дёрнуть события объекта"  )
        if error_message then
          private.BotLog( error_message )
        end
        fake = true
      end
      if fake then
        local oo = ObjGet( obj_name )
        if oo and oo.event_menter then oo.event_menter( { sender = obj_name } ) end
        if oo and oo.event_mdown  then oo.event_mdown( { sender = obj_name } )  end
        if oo and oo.event_mup    then oo.event_mup( { sender = obj_name } )    end
        if oo and oo.event_mleave then oo.event_mleave( { sender = obj_name } ) end
      else
        local p = GetObjPosByObj( obj_name )
        if o.inputrect_init then
          local inputrect = {}
          local dx = o.inputrect_x + o.inputrect_w * 0.5
          local dy = o.inputrect_y + o.inputrect_h * 0.5
          inputrect[ 1 ] = p[ 1 ] + dx
          inputrect[ 2 ] = p[ 2 ] - dy
          local obj_ang = GetObjAngByObj( obj_name )
          if ld and ld.Math and ld.Math.AngGip then
            local ang, gip = ld.Math.AngGip( 0, 0, dx, dy )
            inputrect[ 1 ] = p[ 1 ] + gip * math.cos( ang + obj_ang )
            inputrect[ 2 ] = p[ 2 ] - gip * math.sin( ang + obj_ang ) 
          end
          if obj_ang == 0
          and  p[ 1 ] > ( inputrect[ 1 ] - o.inputrect_w * 0.5 ) and p[ 1 ] < ( inputrect[ 1 ] + o.inputrect_w * 0.5 )
          and p[ 2 ] > ( inputrect[ 2 ] - o.inputrect_h * 0.5 ) and p[ 2 ] < ( inputrect[ 2 ] + o.inputrect_w * 0.5 )
          then

          else
            p = inputrect
          end
        end
        -->> TODO добавить рандомный разброс в пределах inputrect или drawrect
        private.BotMouseMove( p )
        private.BotMouseClick( p )
        --ld.LogTrace( "BotTryObjClick", obj_name, p, GetGameCursorPos() )
      end
      return true
    else
      private.BotLog( 
        "BotTryObjClick: '"..obj_name.."' - объект не существует или Input выключен"
        .."\n\n\t WARNING: возможно забыли включить ld.Lock в сложном действии \n"
      )
      return false
    end
  end
  --
  function private.BotTryObjClick_FindClickablePoint( obj_name )
    --ld.LogTrace( "BotTryObjClick_FindClickablePoint", obj_name )
    local click_obj = ObjGet( obj_name )
    local p = GetObjPosByObj( obj_name )
    
    local func_cache = {}

    local mdown_events_all_colled = 0
    local mdown_events_obj_colled = 0
    local mdown_events_other_colled = 0
    local events_pos = {}
    local event_pos
    local function mdown_event_caller( obj )
      mdown_events_all_colled = mdown_events_all_colled + 1
      if obj == obj_name then
        mdown_events_obj_colled = mdown_events_obj_colled + 1
        if not event_pos then
          event_pos = events_pos[ mdown_events_all_colled ]
          --ld.LogTrace( "mdown_event_caller", mdown_events_all_colled, mdown_events_obj_colled, mdown_events_other_colled, event_pos, #events_pos )
        end
      else
        mdown_events_other_colled = mdown_events_other_colled + 1
      end
    end

    local p_o,ch;
    local function set_all_input_objs( obj )
      obj = obj or "ng_application"
      p_o = ObjGet( obj )
      --ld.LogTrace( parent )
      if p_o.input then
        func_cache[ obj ] = { 
          event_mdown = p_o.event_mdown or ""; 
          event_mup = p_o.event_mup or "";
          event_menter = p_o.event_menter or "";
          event_mleave = p_o.event_mleave or "";
         }
        ObjSet( obj, { 
          event_mdown = function() mdown_event_caller( obj ) end;
          event_mup = "";
          event_menter = "";
          event_mleave = "";
        } )
        ch = ObjGetRelations( obj ).childs
        for i, child in ipairs( ch ) do
          set_all_input_objs( child )
        end
      end
    end

    local function restor_all_input_objs()
      for k, v in pairs( func_cache ) do
        ObjSet( k, v )
      end
    end


    local rect
    if click_obj.inputrect_init then
      rect = { 
        x1 = p[ 1 ] + click_obj.inputrect_x;
        y1 = p[ 2 ] + click_obj.inputrect_y;
        x2 = p[ 1 ] + click_obj.inputrect_x + click_obj.inputrect_w;
        y2 = p[ 2 ] + click_obj.inputrect_y + click_obj.inputrect_h;
      };
    else
      rect = { 
        x1 = p[ 1 ] - click_obj.draw_width / 2;
        y1 = p[ 2 ] - click_obj.draw_height / 2;
        x2 = p[ 1 ] + click_obj.draw_width;
        y2 = p[ 2 ] + click_obj.draw_height;
      };
    end
    rect.x = ( rect.x1 + rect.x2 ) / 2
    rect.y = ( rect.y1 + rect.y2 ) / 2
    rect.w = rect.x2 - rect.x1
    rect.h = rect.y2 - rect.y1

    local cache_obj = "bot_cache_obj"
    local cache_pos
    local step_x = math.ceil( rect.w / 10 )
    local step_y = math.ceil( rect.h / 10 )
    local step_xx = math.ceil( step_x / 2 )
    local step_yy = math.ceil( step_y / 2 )
    local count = 0
    local function fake_click( x, y )
       count = count + 1
       ObjAttach( cache_obj, obj_name )
       ObjSet( cache_obj, { pos_x = x; pos_y = y; } )
       --ld.LogTrace( rect.x + x * xx, rect.y + y * yy  )
       cache_pos = GetObjPosByObj( cache_obj );
       table.insert( events_pos, { cache_pos[ 1 ]; cache_pos[ 2 ] } )
       --ld.LogTrace( cache_pos  )
       private.BotMouseMove( cache_pos )
       private.BotMouseClick( cache_pos )
    end
    local function fake_clicker()
      ObjCreate( cache_obj, "obj" )
      ObjSet( cache_obj, { input = 0 } )
      for y = -rect.h / step_y, rect.h / step_y, step_y do
        fake_click( 0, y )
      end
      for x = -rect.w / step_x, rect.w / step_x, step_x do
        fake_click( x, 0 )
      end
      for y = 1, rect.h / step_y do
        for x = 1, rect.w / step_x do
          for xx = -step_xx, step_xx, step_x do
            for yy = -step_yy, step_yy, step_y do
              fake_click( x * xx, y * yy )
            end
          end
        end
      end
    --ld.LogTrace( "fake_clicker", count, rect )
    end
    set_all_input_objs()
    fake_clicker()
    restor_all_input_objs()
    ObjDelete( cache_obj )

    --private.BotStop()

    ld.StartTimer( 0, function() 
      if event_pos then
        ld.LogTrace( "BOT WARNING: Clickable point finded >> \nПроверено точек >> "..mdown_events_all_colled.." из "..( rect.w * rect.h ).."\nВсего найдено кликабельных точек объекта >> "..mdown_events_obj_colled.." ( "..string.format( "%g", 100 * mdown_events_obj_colled /mdown_events_all_colled ).." percents )" )
        ld.LogTrace(  event_pos, rect )
        private.BotMouseMove( cache_pos )
        private.BotMouseClick( event_pos )
      end
    end )

  end
  --
  function private.TryObjDragDrop( obj_drag, obj_place, func_end )

    local obj_pos = GetObjPosByObj( obj_drag )
    local drag_pos = GetObjPosByObj( obj_place )

    private.BotMouseDown( obj_pos );
    private.BotMouseMove( drag_pos );

    ld.StartTimer( 0.65, function() 

        local o = ObjGet( obj_drag )
        local buf_func = o.event_dragdrop or function( ne_params ) end
        ObjSet( obj_drag, { event_dragdrop = function( ne_params ) 
          ObjSet( obj_drag, { event_dragdrop = buf_func; } )
          local relative_pos = GetObjPosByObj( obj_place, ObjGetRelations( obj_drag ).parent )
          ObjSet( obj_drag, { pos_x = relative_pos[ 1 ]; pos_y = relative_pos[ 2 ]; } )
          ld.StartTimer(0.1, function()  
            buf_func( ne_params )
            ObjSet( obj_drag, { pos_x = o.pos_x; pos_y = o.pos_y; } )
          end)
        end } )

        if o.realdrag then
          private.BotMouseUp( drag_pos )
        else
          private.BotMouseDown( drag_pos )
        end

        if func_end then
          func_end()
        end

    end )

  end
  --
  function private.BotTryObjUse( obj_drag, obj_place, func_end )
    local od = ObjGet( obj_drag )
    local op = ObjGet( obj_place )
    if od and od.input and od.drag then
      if op then
        if private.BotClickLogger( obj_drag ) >= private.BOT_CLICKS_BEFORE_STOP then
          return false
        end

        private.TryObjDragDrop( obj_drag, obj_place, func_end )

        return true
      else
        private.BotLog( "BotTryObjUse: '"..obj_place.."' - места применения не существует" )
        return false
      end
    else
      if od and not od.input then
        if private.BotTryObjUse_activator[ obj_drag ] and private.BotTryObjUse_activator[ obj_drag ] > 2 then
          private.BotLog( "BotTryObjUse: '"..obj_drag.."' - у объекта для драга выключен Input, включаем програмно" )
          ObjSet( obj_drag, { input = 1 } )
        else
          private.BotTryObjUse_activator[ obj_drag ] = private.BotTryObjUse_activator[ obj_drag ] or 0
          private.BotTryObjUse_activator[ obj_drag ] = private.BotTryObjUse_activator[ obj_drag ] + 1
        end
        return true
      elseif od and not od.drag then
        if private.BotTryObjUse_activator[ obj_drag ] and private.BotTryObjUse_activator[ obj_drag ] > 2 then
          private.BotLog( "BotTryObjUse: '"..obj_drag.."' - у объекта для драга выключен Drag, включаем програмно" )
          ObjSet( obj_drag, { drag = 1 } )
        else
          private.BotTryObjUse_activator[ obj_drag ] = private.BotTryObjUse_activator[ obj_drag ] or 0
          private.BotTryObjUse_activator[ obj_drag ] = private.BotTryObjUse_activator[ obj_drag ] + 1
        end
        return true
      else
        private.BotLog( "BotTryObjUse: '"..obj_drag.."' - объкт для драга не существует или Input/Drag выключен" )
      end
      return false
    end

  end
  --
  function private.BotTryGoTo( zrm )
    --ld.LogTrace( "private.BotTryGoTo", zrm, interface.GetCurrentComplexInv(), interface.GetCurrentInv(), common.GetCurrentSubRoom() )
    --ld.LogTrace( "private.BotTryGoTo zrm", zrm )
    --ld.LogTrace( "private.BotTryGoTo interface.GetCurrentComplexInv", interface.GetCurrentComplexInv() )
    --ld.LogTrace( "private.BotTryGoTo interface.GetCurrentInv", interface.GetCurrentInv() )
    --ld.LogTrace( "private.BotTryGoTo common.GetCurrentSubRoom", common.GetCurrentSubRoom() )
    --ld.LogTrace( "private.BotTryGoTo common.GetCurrentRoom", common.GetCurrentRoom() )

    -->>ОБРАБОТКА ИСКЛЮЧЕНИЙ
    if private.BotExceptionHandler( { caller = "BotTryGoTo"; value = zrm } ) then
      return true
    end
    --<<ОБРАБОТКА ИСКЛЮЧЕНИЙ

    local deploy = interface.GetCurrentComplexInv()
    if deploy == "" and interface.GetCurrentInv then
      deploy = interface.GetCurrentInv()
    end


    if deploy ~= "" and deploy ~= zrm then
      private.BotInvComplexClose()
    elseif common.GetCurrentSubRoom() then


      if zrm == common.GetCurrentSubRoom() then
        return false
      elseif private.BotGateConnection[ common.GetCurrentSubRoom() ] and ld.TableContains( private.BotGateConnection[ common.GetCurrentSubRoom() ].childs, zrm ) then
        local buf_gate = private.BotMakeGate( common.GetCurrentSubRoom(), zrm )
        ld.LogTrace( "SubZZ", buf_gate )
        private.BotTryObjClick( buf_gate )
      elseif common.GetCurrentSubRoom():find( "^inv_" ) then
        private.BotInvComplexClose()
      elseif common.GetCurrentSubRoom():find( "^deploy_" ) then
        private.BotInvComplexClose()
      else
        private.BotZzClose()
      end
    elseif common.GetCurrentRoom() == zrm then
      return false
    elseif deploy == zrm then
      return false
    elseif zrm:find( "^inv_" ) then
      local inv_obj = zrm:gsub( "_complex_", "_" )
      if private.BotInvObjShow( inv_obj ) then
        private.BotTryObjClick( inv_obj )
      end
    elseif zrm:find( "^deploy_" ) then
      local inv_obj = zrm:gsub( "^deploy_", "" )
      --ld.LogTrace( "^deploy_", inv_obj )
      if private.BotInvObjShow( inv_obj ) then
        private.BotTryObjClick( inv_obj )
      end
    else
      local now_room = common.GetCurrentSubRoom() or common.GetCurrentRoom()
      local buf_zrm = private.BotGetConnectedZRM( now_room, zrm )
      --ld.LogTrace( now_room, buf_zrm )
      local buf_gate = private.BotMakeGate( now_room, buf_zrm )
      --ld.LogTrace( buf_gate )
      --ld.LogTrace( GetObjPosByObj( buf_gate ) )
      local fake_click = private.BotIsParentRoom( now_room, buf_zrm )
      private.BotTryObjClick( buf_gate, fake_click )
    end
    --ld.LogTrace( "private.BotTryGoTo", true, zrm, interface.GetCurrentComplexInv(), interface.GetCurrentInv(), common.GetCurrentSubRoom() )
    return true
  end
  --
  function private.BotTrySkipMg( force )
    local skip = false
    --ld.LogTrace( "private.BotTrySkipMg", common.GetCurrentRoom(), _G[ common.GetCurrentRoom() ].Skip, cmn.current_mg, force )
    if cmn.current_mg or force then
      if int_complex_inv and int_complex_inv.GetCurrentName() ~= "" then
        level_inv.Skip();
        skip = true
      elseif _G[ common.GetCurrentRoom() ].Skip then
        _G[ common.GetCurrentRoom() ].Skip();
        skip = true
      end;
    end
    return skip
  end
  --
  function private.BotTryMakeScreenshot()
    if private.BOT_SCREENSHOT_STEPS_WAIT > 0 then
      private.BotTryMakeScreenshot_stepCounter = private.BotTryMakeScreenshot_stepCounter + 1
      if private.BOT_SCREENSHOT_STEPS_WAIT == private.BotTryMakeScreenshot_stepCounter then
        private.BotMakeScreenshot()
        private.BotTryMakeScreenshot_stepCounter = 0
        return true;
      end
    end
    return false;
  end
  --
  function private.BotTryHint( prg_now )
    if private.BOT_HINT_ON_STEP then
      local place_now = private.BotGetCurrentPlace()
      --local prg_now = private.BotGetNextProgresName() -- private.BotTryHint_lastPrgName
      if not ObjGet( "int_button_hint" ).input then
        return false
      elseif ObjGet( "int_dialog_hint" ).input then
        private.BotTryObjClick( "obj_int_dialog_hint_teleport" )
        return true;
      elseif place_now == private.BotTryHint_lastPlace and prg_now == private.BotTryHint_lastPrgName then
        --private.BotTryHint_lastPlace = false
        --private.BotTryHint_lastPrgName = false
        return false
      else
        common_impl.DeleteHintFx()

        local show_hint_count = ld.TableCount( common_impl.show_hint );

        int_button_hint.Reload(0);
        int_button_hint.MouseDown();

        if private.BotIsInPrgPlace( prg_now ) then
          if ( ld.TableCount( common_impl.show_hint ) - show_hint_count ) 
              >= ( prg_now:find( "^use" ) and 2 or 1  )
          then
            --good
          else
            --good
            ld.LogTrace( "\n\n ERROR: " + prg_now + " >> HINT OBJ NOT FOUND \n\n"  )
          end
        end

        private.BotTryHint_lastPlace = place_now
        private.BotTryHint_lastPrgName = prg_now
        if private.BOT_HINT_SCREENSHOT_TIME == 0 then
          private.BotMakeScreenshot()
        elseif private.BOT_HINT_SCREENSHOT_TIME > 0 then
          ld.StartTimer( private.BOT_HINT_SCREENSHOT_TIME, function() private.BotMakeScreenshot() end )
        end
        return true;
      end
    else
      return false;
    end
  end
--
function private.BotMakeScreenshot()
  MsgSend( Event_Level_CheaterSaveScreenshot );
end
--
function private.BotMakeGate( from_zrm, to_zrm )
  local from_div = ld.StringDivide( from_zrm )
  local to_div = ld.StringDivide( to_zrm )
  local from = from_zrm:gsub( "^"..from_div[ 1 ].."_", "" )
  local to = to_zrm:gsub( "^"..to_div[ 1 ].."_", "" )
  return "g"..to_div[ 1 ].."_"..from.."_"..to
end
--
function private.BotMakeZzGateConnections( zrm )
  local connect = private.BotGateConnection
  if not connect[ zrm ] and zrm:find( "^zz" ) then
    for i = 1, #game.room_names do
      if game.room_names[ i ]:find( "^rm" ) and ObjGet( private.BotMakeGate( game.room_names[ i ], zrm ) ) then
        connect[ zrm ] = { childs = {}, parent = game.room_names[ i ] }
        table.insert( connect[ game.room_names[ i ] ].childs, 1, zrm )
        return;
      end
    end
    --CH7 deepSubRoom
    if ld.SubRoom then
      local owner = ld.SubRoom.Owner( zrm )
      private.BotMakeZzGateConnections( owner )
      if ObjGet( private.BotMakeGate( owner, zrm ) ) then
        connect[ zrm ] = { childs = {}, parent = owner, parent_deep = ld.SubRoom.Parent( owner ) }
        table.insert( connect[ owner ].childs, 1, zrm )
        return;
      end
    end
  end
end
--
function private.BotMakeSubZzGateConnections( zz, subzz )
  local connect = private.BotGateConnection
  if not connect[ zz ] then
    private.BotMakeZzGateConnections( zz )
  end
  if not connect[ subzz ] then
    if ObjGet( private.BotMakeGate( zz, subzz ) ) then
        connect[ subzz ] = { childs = {}, parent = zz }
        table.insert( connect[ zz ].childs, 1, subzz )
        return;
    else
      private.BotLog( "BotMakeSubZzGateConnections: '"..BotGateConnection.."' - subzz gate not exist" )
    end
  end
end
--
function private.BotMakeGateConnections()
  private.BotGateConnection = {}
  local connect = private.BotGateConnection
  local div
  --connections with rm
  for j = 1, #game.room_names do
    div = ld.StringDivide( game.room_names[ j ] )
    if div[ 1 ] == "rm" then
      connect[ game.room_names[ j ] ] = connect[ game.room_names[ j ] ] or { childs = {}, parent = false }
      for i = 1, #game.room_names do
        if i ~= j then
          local buf_gate = private.BotMakeGate( game.room_names[ j ], game.room_names[ i ] )
          if ObjGet( buf_gate ) and private.BotIsRoomChild(  game.room_names[ j ], game.room_names[ i ] ) then
            table.insert( connect[ game.room_names[ j ] ].childs, game.room_names[ i ] )
            connect[ game.room_names[ i ] ] = connect[ game.room_names[ i ] ] or { childs = {}, parent = false }
            connect[ game.room_names[ i ] ].parent = game.room_names[ j ]
          end
          local buf_gate = private.BotMakeGate( game.room_names[ i ], game.room_names[ j ] )
          if ObjGet( buf_gate ) and private.BotIsRoomChild(  game.room_names[ i ], game.room_names[ j ] )  then
            connect[ game.room_names[ j ] ].parent = game.room_names[ i ]
          end
        end
      end
    end
  end
  --connections with ho
  for j = 1, #game.room_names do
    div = ld.StringDivide( game.room_names[ j ] )
    if div[ 1 ] == "ho" and not connect[ game.room_names[ j ] ] then
      for i = 1, #game.room_names do
        if i ~= j then
          local buf_gate = private.BotMakeGate( game.room_names[ i ], game.room_names[ j ] )
          if ObjGet( buf_gate ) then
            table.insert( connect[ game.room_names[ i ] ].childs, game.room_names[ j ] )
            connect[ game.room_names[ j ] ] = connect[ game.room_names[ j ] ] or { childs = {}, parent = false }
            connect[ game.room_names[ j ] ].parent = game.room_names[ i ]
          end
        end
      end
    end
  end
  --ld.LogTrace( private.BotGateConnection )
end
--
function private.BotInvObjShow( inv_obj )
  local item = ld.StringDivide( inv_obj )[ 2 ]
  if private.BotIsObjDragNow( inv_obj ) then
    return true
  elseif not ld.TableContains( ObjGetRelations("obj_int_inventory").childs,"hub_int_inventory_"..item ) then
    return true
  elseif private.BotInvObjShowed == inv_obj then
    return true
  else
    private.BotInvObjShowed = inv_obj
    interface.InventoryItemAdd( inv_obj );
  end
  return false
end
--
function private.BotInvComplexClose( bool )
  private.BotTryObjClick( "btn_int_complex_inv_impl_close" )
end
--
function private.BotZzClose()
  --private.BotMouseClick( { 0, 0 } )
  if common.GetCurrentSubRoom() and subroom and subroom.GetSubRoomExitButton() and ObjGet( subroom.GetSubRoomExitButton() ) then
    --ld.LogTrace( "private.BotZzClose()", "obj_int_frame_subroom_button_"..common.GetCurrentSubRoom() )
    private.BotTryObjClick( subroom.GetSubRoomExitButton() )
  else
    --ld.LogTrace( "private.BotZzClose()", "obj_int_frame_subroom_button" )
    private.BotTryObjClick( "obj_int_frame_subroom_button" )
  end
end
--
function private.BotClickLogger( obj_name )
  local count = 0
  for i = #private.BotClickLoggerChain, 1, -1 do
    if private.BotClickLoggerChain[ i ] == obj_name then
      count = count + 1;
    else
      break
    end
  end
  table.insert( private.BotClickLoggerChain, obj_name )
  return count;
end
--
function private.BotClickCounter( obj_name, bool_reset )
  private.BotClickCounterAll = private.BotClickCounterAll or {}
  private.BotClickCounterAll[ obj_name ] = private.BotClickCounterAll[ obj_name ] or 0
  if bool_reset == true then 
    private.BotClickCounterAll[ obj_name ] = 0;
  elseif bool_reset == nil then 
    private.BotClickCounterAll[ obj_name ] = private.BotClickCounterAll[ obj_name ] + 1
  end
  return private.BotClickCounterAll[ obj_name ];
end
--//для режима прощупывания всего живого на экране
function private.BotToucherGetObjs( root, list )
  --возвращает список объектов
  root = root or private.BotGetCurrentPlace()
  list = list or {}
  local o
  for i, v in ipairs( ObjGetRelations( root ).childs ) do
    o = ObjGet( v )

    if o.input
    and not ( v:find( "^gzz" ) or v:find( "^grm" ) or v:find( "^gho" ) or v:find( "^gmg" ) )
    and not ( subroom and subroom.GetSubRoomExitButton and v == subroom.GetSubRoomExitButton() )
    then
      --  ld.LogTrace( "BotGetCurrentPlace Wrong", v )
      --  ld.LogTrace( v:find( "^(grm)|^(gzz)|^(gho)|^(gmg)" ) )
      --end
      --if ( v:find( "^(grm)|^(gzz)|^(gho)|^(gmg)" ) ) then
      --  ld.LogTrace( 11111111111 )
      --else
      --  ld.LogTrace( 22222222222 )
      --end
      
      if o.event_mdown and ( not private.BotIsObjInPrg( v ) ) then
        table.insert( list, v )
      end
      private.BotToucherGetObjs( v, list)
    end
  end
  return list
end
--
function private.BotMouseClick( p )
  private.BotMouseDown( p )
  private.BotMouseUp( p )
end
--
function private.BotMouseMove( p )
  ne.dbg.FireInputEvent( p[ 1 ], p[ 2 ], 5 )
end
--
function private.BotMouseLeave( p )
  ne.dbg.FireInputEvent( p[ 1 ], p[ 2 ], 6 )
end
--
function private.BotMouseUp( p )
  ne.dbg.FireInputEvent( p[ 1 ], p[ 2 ], 4 )
end
--
function private.BotMouseDown( p )
  ne.dbg.FireInputEvent( p[ 1 ], p[ 2 ], 3 )
end
--
--function ***BOTCONTROLLER***() end

  private.StackHandler_events = {};
  function public.AddStackHandler( prg_name, func )
    private.StackHandler_events[ prg_name ] = func;
  end
  function private.ExecuteStackHandler( prg_name )
    if private.StackHandler_events[ prg_name ] then
      return private.StackHandler_events[ prg_name ]()
    else
      return false
    end
  end

  private.ForceHandler_events = {};
  function public.AddForceHandler( prg_name, func )
    private.ForceHandler_events[ prg_name ] = func;
  end    
  function private.ExecuteForceHandler( prg_name )
    if private.ForceHandler_events[ prg_name ] then
      return private.ForceHandler_events[ prg_name ]()
    else
      return false
    end
  end

  private.ActionHandler_events = {};
  function public.AddActionHandler( prg_name, func )
    private.ActionHandler_events[ prg_name ] = func;
  end    
  private.ExecuteActionHandler_clicker = {}
  function private.ExecuteActionHandler( prg_name )
    if private.BotGetConfigParam( "clicker."..prg_name, "string" ) then
      if not private.ExecuteActionHandler_clicker[ prg_name ] then
        private.ExecuteActionHandler_clicker[ prg_name ] = private.BotGetConfigParam( "clicker."..prg_name, "string" )
        private.BotLog( "ExecuteActionHandler from config >> "..prg_name )
        private.BotLog( private.ExecuteActionHandler_clicker[ prg_name ] )
      end
      return true
    elseif private.ActionHandler_events[ prg_name ] then
      return private.ActionHandler_events[ prg_name ]()
    else
      return false
    end
  end

  private.LockHandler_events = {};
  function public.AddLockHandler( prg_name, func )
    private.LockHandler_events[ prg_name ] = func;
  end    
  function private.ExecuteLockHandler( prg_name )
    if private.LockHandler_events[ prg_name ] then
      return private.LockHandler_events[ prg_name ]()
    else
      return false
    end
  end

  function public.BotRestartCurrentLevel()
    local prg = ng_global.currentprogress;
    local level = ng_global.progress[ prg ].common.chapter;
    private.BotStop()
    common.LevelSwitch( level );
  end

  function public.BotStop()
    private.BotStop()
  end

  function public.BotMouseDown( p )
    private.BotMouseDown( p )
  end

  function public.BotMouseUp( p )
    private.BotMouseUp( p )
  end

  function public.BotMouseClick( p )
    private.BotMouseClick( p )
  end

  function public.BotMouseMove( p )
    private.BotMouseMove( p )
  end

  function public.BotMouseLeave( p )
    private.BotMouseLeave( p )
  end

  function public.BotMouseDragDrop( pTake, pDrop )
    private.BotMouseDown( pTake );
    private.BotMouseMove( pDrop );

    ld.StartTimer( 0.65, function() 

      if #ObjGetRelations( "ng_interface_transporter" ).childs == 1 then
        local obj_drag = ObjGetRelations( "ng_interface_transporter" ).childs[ 1 ]
        local isInvItem = false
        if obj_drag:find( "^itm_int_inventory_" ) then
          obj_drag = ObjGetRelations( obj_drag ).childs[ 1 ]
          isInvItem = true
        end
        local o = ObjGet( obj_drag )
        local buf_func = o.event_dragdrop or function( ne_params ) end
        ObjSet( obj_drag, { event_dragdrop = function( ne_params ) 
          ObjSet( obj_drag, { event_dragdrop = buf_func; } )
          ObjSet( obj_drag, { pos_x = pDrop[ 1 ]; pos_y = pDrop[ 2 ]; } )
          buf_func( ne_params )
          ObjSet( obj_drag, { pos_x = o.pos_x; pos_y = o.pos_y; } )
        end } )
        if o.realdrag then
          private.BotMouseUp( pDrop )
        else
          private.BotMouseDown( pDrop )
        end
      else
        return
      end

    end )
  end

--******************************************************************************************
--function  *** PROGRESS *** () end;
--******************************************************************************************
  function private.GetProgressNames()

    return game.progress_names;

  end;
  --******************************************************************************************
  function private.GetCurrentProgress()

    return ng_global.currentprogress;

  end;
  --******************************************************************************************
  function private.GetGlobalProgress()

    local prg = private.GetCurrentProgress();
    return ng_global.progress[ prg ];

  end;