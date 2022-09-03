-- name=cheater
--******************************************************************************************
function public.Init()
  --------------------------------------------------------------------
  private.HINT_ROOT = common_impl.hint      --массив хинта

  ObjSet( "cheater", { pos_z = 13, visible = false, active = false, input = false } );
  ObjAttach( "cheater", "ne_origin" );

  private.InitButtons();
  private.InitReviewMode();
  private.InitKeyboard();

  public.DIRECTION = -1;
  public.is_progress_executing_now = false;
  private.is_ipad = false;
  private.is_show_done = false;
  private.currentroom = GetCurrentRoom();
  private.column = { room = 0, progress = 0, last = nil, done_amount = 0 };

  private.LINE_MAX_COUNT = 35;
  private.COLUMN_MAX_COUNT = 5;
  private.RECORD_WIDTH = 160;

  private.HeightChange();
  private.ControlButtons( { mode = 1, skip = 1, sound = 1 } );

  private.ButDown();
  public.UpdateRoom( private.currentroom );

  MsgSubscribe( Event_AltF1, private.HandleAltF1 );
  MsgSubscribe( Command_Interface_UpdateTextures, private.WideScreenUpdate );
  MsgSubscribe( Event_Cheater_KeyPressed, private.HotKey );
  private.onScreen = false;

  --if ld.IsLdCheater() then
  --  private.HandleAltF1()
  --end
  private.CheboxaryInit()
  private.BotInit()


  private.track_objs = {
    "txt_int_button_menu"
  }
--  private.track_objs = {
--  "txt_menu_but_profile";
--  "txt_menu_but_options";
--  "txt_menu_but_quit";
--  "txt_menu_but_strguide";
--  "txt_menu_but_moregames";
--  "txt_menu_but_play";
--  "txt_menu_but_extra";
--}

  private.trackFactor = 1 -- шаг движения  1 по дефолту

  private.track_objs = {}
  for i = 1, 8 do
    table.insert(private.track_objs, "spr_expeditionexp_room_back_"..i)
  end
  --private.track_objs = ObjGetRelations( "obj_int_dialog_task_tagfortext" ).childs
  
  --private.track_objs = {"int_tutorial_impl","spr_int_tutorial_arrow_1","spr_int_tutorial_arrow_2"}  public.tutorial_arrow_stoped = true

  --private.track_objs = {"spr_screensaver_puzzle1", "spr_screensaver_puzzle2", "spr_screensaver_puzzle3", "spr_screensaver_puzzle4", "spr_screensaver_puzzle5", "spr_screensaver_puzzle6", "spr_screensaver_puzzle7", "spr_screensaver_puzzle8", "spr_screensaver_puzzle9", "spr_screensaver_puzzle10", "spr_screensaver_puzzle11", "spr_screensaver_puzzle12"}
  --private.track_objs = {"spr_screensaver_puzzle13", "spr_screensaver_puzzle14", "spr_screensaver_puzzle15", "spr_screensaver_puzzle16", "spr_screensaver_puzzle17", "spr_screensaver_puzzle18", "spr_screensaver_puzzle19", "spr_screensaver_puzzle20", "spr_screensaver_puzzle21", "spr_screensaver_puzzle22", "spr_screensaver_puzzle23", "spr_screensaver_puzzle24"}
  --private.track_objs = {"spr_screensaver_puzzle25", "spr_screensaver_puzzle26", "spr_screensaver_puzzle27", "spr_screensaver_puzzle28", "spr_screensaver_puzzle29", "spr_screensaver_puzzle30", "spr_screensaver_puzzle31", "spr_screensaver_puzzle32", "spr_screensaver_puzzle33", "spr_screensaver_puzzle34", "spr_screensaver_puzzle35", "spr_screensaver_puzzle36"}
  --private.track_objs = {"spr_screensaver_puzzle37", "spr_screensaver_puzzle38", "spr_screensaver_puzzle39", "spr_screensaver_puzzle40", "spr_screensaver_puzzle41", "spr_screensaver_puzzle42", "spr_screensaver_puzzle43", "spr_screensaver_puzzle44", "spr_screensaver_puzzle45", "spr_screensaver_puzzle46", "spr_screensaver_puzzle47", "spr_screensaver_puzzle48"}

end;
--******************************************************************************************
function public.Destroy()

  ObjDelete( "hub_cheater_default" );
  ObjDelete( "cheater" );
  ObjDelete( "txt_cheater_review_field" );
  MsgUnsubscribe( Event_AltF1, private.HandleAltF1 );
  MsgUnsubscribe( Command_Interface_UpdateTextures, private.WideScreenUpdate );
  MsgUnsubscribe( Event_Cheater_KeyPressed, private.HotKey );
    
end;
--******************************************************************************************
function public.IsLdCheater()
  if not IsEditor() then
    return false
  end
  if not private.editor_super_cheater_obj then
    private.editor_super_cheater_obj = ObjGet( "editor_super_cheater" )
    private.editor_super_cheater_obj = private.editor_super_cheater_obj or { draw_width = 0 }
  end
  return private.editor_super_cheater_obj.draw_width == 120
end
--******************************************************************************************
function public.IsSoundCheater()
  if not private.editor_super_cheater_obj then
    private.editor_super_cheater_obj = ObjGet( "editor_super_cheater" )
    private.editor_super_cheater_obj = private.editor_super_cheater_obj or { draw_width = 0 }
  end
  return private.editor_super_cheater_obj.draw_width == 126 and IsEditor()
end
--******************************************************************************************
function private.HotKey( msg, params )
  local key_code = params.key;
  if private.keycodes_logging_off then
  else
    ld.LogTrace( "CheaterKeyPress "..key_code);
  end

  if not ( private.reviewmode_enabled ) then
    
    if ( key_code == 81 ) then --Q ProgressExecute NEXT

        if cmn.is_inmenunow  then return end;
        local progress = private.GetGlobalProgress();
        local progress_names = private.GetProgressNames()
        for i = 1, #progress_names do
          if not string.find(progress_names[i],"^tutorial_") and progress[progress_names[i] ].done == 0 then
            private.ProgressExecute( i, i )
            break;
          end;
        end;

    elseif ( key_code == 192 ) then -->> ~ make screenShoot
      
      private.SmartScreenShot()

    elseif ( key_code == 66 ) then --B

      if ObjGet("cheater_execute_list").visible then
        return
      end
      if cmn.is_inmenunow  then return end;
      private.BotTryStartStop();

      if public.IsSoundCheater() then
        local progress = private.GetGlobalProgress();
        local progress_names = private.GetProgressNames()
        for i = 1, #progress_names do
          if not string.find(progress_names[i],"^tutorial_") and progress[progress_names[i] ].done == 0 then
            private.ProgressExecute( i, i )
            break;
          end;
        end;
      end

    elseif ( key_code == 83 ) then --S

      if not private.SkipVideoNow then

        if private.GetGlobalProgress()[ "opn_entrypoint" ] and not ld.CheckRequirements( {"opn_entrypoint"} ) and public.IsLdCheater() then
          cmn.SetEventDone( "opn_entrypoint" )
          cmn.CallEventHandler( "opn_entrypoint" )
          level.TutorialDisable()
          --rm_entrypoint.dlg_entrypoint_amadey1_end()
        end
        private.SkipVideo();
        private.SkipVideoNow = true
        ld.StartTimer( 1.5, function() private.SkipVideoNow = false end )
      end

    elseif ( key_code == 87 ) and IsEditor() then --W skip intro
      
      if GetCurrentRoom() == "rm_intro" then
        
        int.DialogVideoHide();
        cmn.GotoRoom('rm_menu',0); 

      end

    elseif public.IsLdCheater() then

      if private.CheboxaryFuncs then
        if key_code == 18 then
          private.LdCheaterAlt = not private.LdCheaterAlt
        elseif private.LdCheaterAlt then
          local func_num = key_code - 48
          if private.CheboxaryFuncs[ func_num ] then
            private[ private.CheboxaryFuncs[ func_num ][ 1 ] ]();
          end
          private.LdCheaterAlt = false
        end
      end
      
      if( key_code == 32 ) then --PROBEL MG SKIP

        if cmn.current_mg then
          if int_complex_inv and int_complex_inv.GetCurrentName() ~= "" then
            level_inv.Skip();
          elseif _G[ GetCurrentRoom() ].Skip then
            _G[ GetCurrentRoom() ].Skip(); ld.LogTrace( "cheater: PROBEL MG SKIP - public.Skip()" );
          end;
        end
        
        if _G[ GetCurrentRoom() ].skip_func then
          _G[ GetCurrentRoom() ].skip_func(); ld.LogTrace( "cheater: PROBEL MG SKIP - public.skip_func()" );
        end
        
      elseif ( key_code == 77 ) and not cmn.is_inmenunow then --M
        if ObjGet("cheater_execute_list").visible then
          return
        end
        private.SetFastTravelGrid()

      elseif ( key_code == 73 ) and not cmn.is_inmenunow then --I inventory
        if ObjGet("cheater_execute_list").visible then
          return
        end
        private.SetInventoryGrid()

      elseif( key_code == 33 ) then --PAGE UP return progres
       
        if not game then return end;
        local progress = private.GetGlobalProgress();
        local progress_names = private.GetProgressNames()
        local returned = false
        if private.InGameDoneOrder and #private.InGameDoneOrder > 0 then
          for i = #private.InGameDoneOrder, 1, -1 do
            if string.find( private.InGameDoneOrder[i],"^tutorial_" ) or progress[ private.InGameDoneOrder[i] ].done == 0 then
              table.remove( private.InGameDoneOrder, i )
            else
              progress[ private.InGameDoneOrder[i] ].done = 0
              progress[ private.InGameDoneOrder[i] ].start = 0
              ld.LogTrace( "set progress "..private.InGameDoneOrder[i].." done = 0" )
              returned = true
              break;
            end;
          end
        end
        if not returned then

          for i = #progress_names, 1, -1 do
            if not string.find(progress_names[i],"^tutorial_") and progress[progress_names[i] ].done == 1 then
              progress[progress_names[i] ].done = 0
              progress[progress_names[i] ].start = 0
              ld.LogTrace( "set progress "..progress_names[i].." done = 0" )
              break;
            end;
          end;
        end

      elseif( key_code == 34 ) then --PAGE DOWN execute next progres
       
        if not game then return end;
        local progress = private.GetGlobalProgress();
        local progress_names = private.GetProgressNames()
        for i = 1, #progress_names do
          if not string.find(progress_names[i],"^tutorial_") and progress[progress_names[i] ].done == 0 then
            private.ProgressExecute( i, i )
            break;
          end;
        end;

      elseif( key_code == 46 ) then --DEL execute to first progres in current room
       
        if not game then return end;
        local progress = private.GetGlobalProgress();
        local progress_names = private.GetProgressNames()

        if public.InsertFastExecuter then
          public.InsertFastExecuter = false;
          --ОТМЕНА прогресса, до первого необходимого для текущей локации
          for i = 1, #progress_names - 1 do
            local hint_next = private.HINT_ROOT[ progress_names[ i + 1 ] ]
            if not string.find(progress_names[ i ],"^tutorial_") 
            and progress[ progress_names[ i + 1 ] ]
            and progress[ progress_names[ i + 1 ] ].done == 1 
            and private.HINT_ROOT[ progress_names[ i + 1 ] ]
            then
              if ( hint_next.zz and common.GetCurrentSubRoom()
                    and hint_next.zz == common.GetCurrentSubRoom() )
                or ( hint_next.zz and interface.GetCurrentComplexInv() ~= ""
                    and hint_next.zz == interface.GetCurrentComplexInv() )
                or ( not common.GetCurrentSubRoom() and interface.GetCurrentComplexInv() == "" 
                    and ( hint_next.room == common.GetCurrentRoom() or hint_next.zz == common.GetCurrentRoom() ) )              then
                local progress = private.GetGlobalProgress();
                local progress_names = private.GetProgressNames();
                for i = 1, i do
                  if ( progress[ progress_names[ i ] ].done == 0 ) then
                    progress[ progress_names[ i ] ].done = 1;
                    progress[ progress_names[ i ] ].start = 1;
                    --progress[ progress_names[ i ] ].state = nil;
                  end;
                end;
                for i = i+1, #progress_names do
                  if ( progress[ progress_names[ i ] ].done == 1 ) then
                    progress[ progress_names[ i ] ].done = 0;
                    progress[ progress_names[ i ] ].start = 0;
                    progress[ progress_names[ i ] ].state = nil;
                  end;
                end;

              if private.GetCurrentProgress() == "std" then
                common.LevelSwitch( "level" );
              elseif private.GetCurrentProgress() == "ext" then
                common.LevelSwitch( "levelext" );
              end
                break;
              end;
            end
          end;
--private.ProgressExecute( firstevent_number, lastevent_number )
        else
          --ВЫПОЛНЕ прогресса, до первого необходимого для текущей локации
          for i = 1, #progress_names - 1 do
            if not string.find(progress_names[ i ],"^tutorial_") 
            and progress[ progress_names[ i + 1 ] ]
            and progress[ progress_names[ i + 1 ] ].done == 0 
            and private.HINT_ROOT[ progress_names[ i + 1 ] ]
            then
              --ld.LogTrace( "STEP", i, progress_names[ i ], progress_names[ i + 1 ], common.GetCurrentSubRoom(), interface.GetCurrentComplexInv() )
              if ( private.HINT_ROOT[progress_names[ i + 1 ] ].zz and common.GetCurrentSubRoom()
                    and private.HINT_ROOT[progress_names[ i + 1 ] ].zz == common.GetCurrentSubRoom() )
                or ( private.HINT_ROOT[progress_names[ i + 1 ] ].zz and interface.GetCurrentComplexInv() ~= ""
                    and private.HINT_ROOT[progress_names[ i + 1 ] ].zz == interface.GetCurrentComplexInv() )
                or ( not common.GetCurrentSubRoom() and interface.GetCurrentComplexInv() == "" and private.HINT_ROOT[progress_names[ i + 1 ] ].room == common.GetCurrentRoom() )
              then
              --ld.LogTrace( "ACTION", i, progress_names[ i ], progress_names[ i + 1 ] )
                for ii = 1, i do
                  if not string.find(progress_names[ ii ],"^tutorial_") and progress[progress_names[ ii ] ].done == 0 then
                    private.ProgressExecute( ii, ii )
                  end;
                end;
                break;
              end;
            end
          end;
          common_impl.ButtonHint_Click( true ) 
        end

      elseif( key_code == 144 ) then --NumLock > SlowMotion
   
        private.SlowMotion = private.SlowMotion or 1
        local spd = { 1, 0.2 }
        private.SlowMotion = private.SlowMotion % #spd
        private.SlowMotion = private.SlowMotion + 1

        if private.SlowMotion == 1 then
          ne.SetTestMode( 0 )
          ld.LogTrace( "SlowMotion disabled", ne.GetTestMode() )
        else
          ne.SetTestMode( 1, spd[ private.SlowMotion ] )
          ld.LogTrace( "SlowMotion speed >> "..spd[ private.SlowMotion ], ne.GetTestMode() )
        end

      elseif( key_code == 35 ) then --END restart to room

        common.LevelSwitch( "level" );

      elseif( key_code == 36 ) and public.IsLdCheater() then --HOME restart to room

        common.LevelSwitch( "levelext" );

      elseif( key_code == 145 ) then --SCROLL LOCK interface visible
        ld.LogTrace( private.cheater_hotkey_interface_visibility )
        private.cheater_hotkey_interface_visibility = private.cheater_hotkey_interface_visibility or 1;
        if private.cheater_hotkey_interface_visibility == 1 then
          private.cheater_hotkey_interface_visibility = 0
          interface.InterfaceSetVisible(false,1)
          ObjSet( "int_pause", { visible = 0 } )
        else
          --ld.LogTrace( 1 )
          private.cheater_hotkey_interface_visibility = 1
          interface.InterfaceSetVisible(true,0)
          ObjSet( "int_pause", { visible = 1 } )
        end;

      elseif( key_code == 0 ) then --INSERT fast progres execute
      
        if public.InsertFastExecuter then public.InsertFastExecuter = false
        else public.InsertFastExecuter = true end;
        
      elseif( key_code == 67 ) then --c
        private.keycodes_logging_off = not private.keycodes_logging_off
        ld.LogTrace( (private.keycodes_logging_off and "keycodes_logging_off") or "keycodes_logging_on" );
      elseif( key_code == 16 ) then --Shift
        private.track_shift_on = not private.track_shift_on
        ld.LogTrace( (private.track_shift_on and "track_shift_on") or "track_shift_off" );
      elseif( key_code == 90 ) and true then --z

        private.track_select = private.track_select or 0
        private.track_select = private.track_select%#private.track_objs + 1
        private.track_select_name = private.track_objs[private.track_select]
        private.track_selected = function() 
          return (ObjGet(private.track_select_name))
        end
        private.track_change = function(param, step)
          if private.track_select_name and private.track_selected() then
            ObjSet( private.track_select_name, { [param] = private.track_selected()[param] + step * (private.track_shift_on and 10 or 1) } );  
          end
        end
        if private.track_selected() then
          ld.LogTrace( ">>",private.track_select_name.." @ "..ObjGetRelations( private.track_select_name ).parent, " pos_x = "..private.track_selected().pos_x, "pos_y = "..private.track_selected().pos_y, "ang = "..string.format("%.2f", private.track_selected().ang) );
        else
          ld.LogTrace( "Error: no such object <"..private.track_select_name.."> press Z again" );
        end
      elseif( key_code == 88 ) and IsEditor() and private.track_select_name and private.track_selected() then --x
         ld.LogTrace( "||",private.track_select_name.." @ "..ObjGetRelations( private.track_select_name ).parent, " pos_x = "..private.track_selected().pos_x, "pos_y = "..private.track_selected().pos_y, "ang = "..string.format("%.2f", private.track_selected().ang) );

      elseif( key_code == 105 ) and private.track_change then --9 num
        private.track_change("ang",-0.01)
      elseif( key_code == 99 ) and private.track_change then --3 num
        private.track_change("ang", 0.01)
      elseif( key_code == 104 ) and private.track_change then --up num
        private.track_change("pos_y",-1*private.trackFactor)
      elseif( key_code == 98 ) and private.track_change then --down num
        private.track_change("pos_y", 1*private.trackFactor)
      elseif( key_code == 100 ) and private.track_change then --left num
        private.track_change("pos_x",-1*private.trackFactor)
      elseif( key_code == 102 ) and private.track_change then --right num
        private.track_change("pos_x", 1*private.trackFactor)
      --] ]
      end;
    end
  end;

  -- Review: PauseBreak
  if ( key_code == 19 ) or ( key_code == 123 ) then

    private.ReviewMode();

  -- Review: Up
  elseif ( key_code == 107 ) or ( key_code == 187 ) then

    private.ReviewMarkUp();

  -- Review: Down
  elseif ( key_code == 109 ) or ( key_code == 189 ) then

    private.ReviewMarkDown();

  end;

end;
--******************************************************************************************
--function *** COMMANDS ***() end;
--******************************************************************************************
  function public.Step()

    private.ProgressStep();

  end;
  --******************************************************************************************
  function public.UpdateRoom( room_name )

    private.currentroom = room_name or private.currentroom;
    ObjSet( "txt_cheater_current_room", { text = private.currentroom } ); 
    ObjSet( "txt_cheater_current_subroom", { text = "" } ); 

  end;
  --******************************************************************************************
  function public.StartUpdateSubroom( subroom_name )

    ObjSet( "tmr_cheater_subroom", 
    { 
      playing = true, 
      time = 0.625, 
      endtrig = function () private.UpdateSubroom( subroom_name ); end; 
    } );

  end;
  --******************************************************************************************
  function private.UpdateSubroom( subroom_name )

    ObjSet( "txt_cheater_current_subroom", { text = subroom_name } ); 

  end;
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
  --******************************************************************************************
  function public.InsertFastExecuterFunc( prg )
    local firstevent_number = 0
    local lastevent_number = 0
    local progress = private.GetGlobalProgress();
    local progress_names = private.GetProgressNames()
    for i = 1,#progress_names do
      if  progress[progress_names[i] ].done == 0 then
        firstevent_number = i;
        break;
      end;
    end;
    for i = 1,#progress_names do
      if progress_names[i] == prg then
        lastevent_number = i-1;
        break;
      end;
    end;
    cheater.InsertFastExecuter = false;
    private.ProgressExecute( firstevent_number, lastevent_number )
  end;
  --******************************************************************************************
  function private.ProgressExecute( firstevent_number, lastevent_number )
--a=b+c
    local progress = private.GetGlobalProgress();
    local progress_names = private.GetProgressNames();

    local execute_selected_progress = cheater.InsertFastExecuter
    if execute_selected_progress then
      firstevent_number = lastevent_number
    end

    public.is_progress_executing_now = true;

    --ld.LogTrace( firstevent_number, lastevent_number )

    if ( firstevent_number ) and ( firstevent_number <= (lastevent_number) ) then

      for i = firstevent_number, #progress_names do

        if ( progress[ progress_names[ i ] ].done == 0 ) then

          --progress[ progress_names[ i ] ].done = 1;
          cmn.SetEventDone( progress_names[ i ] )

          if ( cmn.IsSubscribersIncluded and cmn.IsSubscribersIncluded() ) then

            cmn.AddSubscribersToQueue( progress_names[ i ] );

          else 

            if ( progress[ progress_names[ i ] ].func ) then
              progress[ progress_names[ i ] ].func();
            else
              DbgTrace( "Event "..progress_names[ i ].." doesnt have func." );
            end;

          end;

        end;

        if ( i == lastevent_number ) then
          break;
        end;

      end;
    
    elseif ( firstevent_number and lastevent_number ) and ( firstevent_number > (lastevent_number+1) ) then
      --отмена прогресса
      for i = firstevent_number, lastevent_number+1, -1 do

        if ( progress[ progress_names[ i ] ].done == 1 ) then

          progress[ progress_names[ i ] ].done = 0;
          progress[ progress_names[ i ] ].start = 0;
          progress[ progress_names[ i ] ].state = nil;

          ld.LogTrace( 1, progress_names[ i ], progress[ progress_names[ i ] ] )

        else

          ld.LogTrace( 2, progress_names[ i ], progress[ progress_names[ i ] ] )

        end;
      end;

      if private.GetCurrentProgress() == "std" then
        common.LevelSwitch( "level" );
      elseif private.GetCurrentProgress() == "ext" then
        common.LevelSwitch( "levelext" );
      end

    end;

    if ( private.currentroom == "" ) then

      private.currentroom = GetCurrentRoom();

    end;

    if ( cmn.IsSubscribersIncluded and cmn.IsSubscribersIncluded() ) then

      cmn.ExecuteQueue( private.currentroom );

    end;

    public.is_progress_executing_now = false;

    if execute_selected_progress then
      private.ButtonDown( "progress" )
      cheater.InsertFastExecuter = execute_selected_progress
    end

  end;
  --******************************************************************************************
  function private.ProgressFind( is_need_get_number )

    local progress = private.GetGlobalProgress();
    local progress_names = private.GetProgressNames();
    local progressname = nil;

    for i = 1, #progress_names, 1 do

      if ( progress[ progress_names[ i ] ].done == 0 ) then

        if ( is_need_get_number ) then
          progressname = i;
        else
          progressname = progress_names[ i ];
        end;
        break;

      end;

    end;

    if ( progressname == nil ) then

      if ( is_need_get_number ) then
        progressname = #progress_names;
      else 
        progressname = progress_names[ #progress_names ];
      end;

    end;
    
    return progressname;

  end;
  --******************************************************************************************
  function private.ProgressStep()

    public.is_progress_executing_now = true;

    local progress = private.GetGlobalProgress();
    local progress_names = private.GetProgressNames();

    for i = 1, #progress_names, 1 do
      if ( progress[ progress_names[ i ] ].done == 0 ) then

        --progress[ progress_names[ i ] ].done = 1;
        cmn.SetEventDone( progress_names[ i ] )

        if ( cmn.IsSubscribersIncluded() ) then

          cmn.AddSubscribersToQueue( progress_names[ i ] );

        else

          if ( progress[ progress_names[ i ] ].func ) then
            progress[ progress_names[ i ] ].func();
          else
            DbgTrace( "Event "..progress_names[ i ].." doesnt have func." );
          end;

        end;

        break;

      end;

    end;

    if ( private.currentroom == "" ) then

      private.currentroom = GetCurrentRoom();

    end;

    if ( cmn.IsSubscribersIncluded() ) then

      cmn.ExecuteQueue( private.currentroom );

    end;

    public.is_progress_executing_now = false;

  end
  --******************************************************************************************
  function private.ShowProgress( p_column_shift )

    cheater.InsertFastExecuter = false

    if ( not p_column_shift ) then

      private.column.progress = 0;
      private.SetArrow( "left", "progress", false );
      ObjSet( "cheater_progress_names", { pos_x = 0 } );
      private.DetachColumn( "progress" );

    end;

    local column_amount = p_column_shift or 0;
    local column_counter = column_amount;
    local progress_names = private.GetProgressNames();
    local progress = private.GetGlobalProgress();

    private.column.done_amount = 0
    for i,o in ipairs(progress_names) do
      if progress[ o ].done == 1 and ( not private.is_show_done ) then
        private.column.done_amount = private.column.done_amount + 1
      end
    end
    local progress_done_amount = 0;
    local progress_idstart = column_amount * private.LINE_MAX_COUNT + 1;

    if ( not private.is_show_done ) and ( column_amount > 0 ) then
      progress_done_amount = private.column.done_amount;
      progress_idstart = progress_idstart + progress_done_amount;
    end;

    local progress_colour = { 
                        if_done_true  = {
                          def = { color_g = 1.00-0.50, color_b = 1.00-0.50 },
                          dlg = { color_g = 0.80-0.50, color_b = 0.80-0.50 },
                          opn = { color_g = 0.60-0.50, color_b = 0.60-0.50 },
                          get = { color_g = 0.80-0.50, color_b = 1.00-0.50 },
                          use = { color_g = 0.80-0.50, color_b = 0.60-0.50 },
                          win = { color_g = 1.00-0.50, color_b = 0.60-0.50 },
                          clk = { color_g = 0.60-0.50, color_b = 1.00-0.50 }                      },
                        if_done_false = {
                          def = { color_g = 1.00, color_b = 1.00 },
                          dlg = { color_g = 0.80, color_b = 0.80 },
                          opn = { color_g = 0.60, color_b = 0.60 },
                          get = { color_g = 0.80, color_b = 1.00 },
                          use = { color_g = 0.80, color_b = 0.60 },
                          win = { color_g = 1.00, color_b = 0.60 },
                          clk = { color_g = 0.60, color_b = 1.00 }
                        } };
    local color = {   use_ = { 1,0.80,0.80};
                      get_ = { 0.80,1,0.80};
                      --opn_ = { 0.85,0.55,0};
                      opn_ = { 0,0,0};
                      win_ = { 0.9,0.30,0.9};
                      mmg_ = { 1,0.65,0.65};
                      dlg_ = { 0,0.8,0.8};
                  }
    local counter_missevent = 0;
    local arrow_param = false;
    local index_obj = 0;
    local last = 0;

    for index_prg = progress_idstart, #progress_names do

      local event = progress_names[ index_prg ];
      --DbgTrace( "event="..event );
      index_obj = index_prg - counter_missevent;
      local is_done = false;
      --- --- --- --- --- column
      if ( ( index_obj - progress_done_amount ) > ( column_counter * private.LINE_MAX_COUNT ) ) then

        local column_counter_abs = private.COLUMN_MAX_COUNT + column_amount;
        if ( column_counter >= column_counter_abs ) then

          last = index_obj;
          arrow_param = true;
          break;

        end;

        column_counter = column_counter + 1;
        local column_params = 
        {
           counter = column_counter,
           amount  = column_amount,
           type    = 'progress'
        };
        private.CreateColumn( column_params );

      end;
      --- --- --- --- --- done?
      if ( progress[ event ].done == 1 ) then

        is_done = true;
        if ( not private.is_show_done ) then
          counter_missevent = counter_missevent + 1;
        end;

      end;
      --- --- --- --- --- if need - create-attach
      if ( not is_done ) or ( private.is_show_done ) then

        local event_done    = "if_done_"..tostring( is_done );
        local event_prefix  = common.GetObjectPrefix( event );
        if ( progress_colour[ "if_done_"..tostring( is_done ) ][ event_prefix ] == nil ) then
          event_prefix = 'def';
        end;

        local clr = color[ string.sub( event, 1, 4 ) ] or { 1,1,1 }
        
        local index_obj_param = index_obj - progress_done_amount;
        local prg_params = 
        {
            obj_num      = index_obj_param
           ,type         = "progress"
           ,column       = column_counter
           ,text         = event
           ,text_r       = event:find("^opn_") and 1 or 0
           ,text_g       = event:find("^opn_") and 1 or 0
           ,text_b       = event:find("^opn_") and 1 or 0
           ,event_mdown  = function () private.ProgressExecute( private.ProgressFind( true ), index_prg ); private.ButtonDown( "progress" ) end
           ,event_menter = function () private.ProgressMouseOver( index_obj_param, 0 ); end
           ,event_mleave = function () private.ProgressMouseOver( index_obj_param, 1 ); end
           --,color_b      = progress_colour[ event_done ][ event_prefix ].color_b
           --,color_g      = progress_colour[ event_done ][ event_prefix ].color_g
           ,color_r      = is_done and clr[1] > 0.4 and clr[1] - 0.4 or clr[1]
           ,color_g      = is_done and clr[2] > 0.4 and clr[2] - 0.4 or clr[2]
           ,color_b      = is_done and clr[3] > 0.4 and clr[3] - 0.4 or clr[3]
        };
        private.CreateRecord( prg_params );

      end;
      --- --- --- --- ---
    end;

    -- amount done
    if ( counter_missevent ~= 0 ) then
      private.column.done_amount = counter_missevent;
    end;

    -- detach done
    if ( not private.is_show_done ) and ( private.column.done_amount ~= 0 ) and ( last == 0 )  then
      
      local i = ( #progress_names - private.column.done_amount + 1 );

      while ( i <= #progress_names ) do    
        ObjDetach( "spr_cheater_progress_"..i );
        ObjDetach( "txt_cheater_progress_"..i );
        i = i + 1;
      end;
    end;


    private.column.last = last;
    private.SetArrow( "right", "progress", arrow_param );
    
  end
  --******************************************************************************************
  function private.ProgressCheckDown()

    local check_text = { if_true = "hide done", if_false = "show done" }
    private.is_show_done = not private.is_show_done;
    ObjSet( "txt_cheater_progress_check", { text = check_text[ "if_"..tostring( private.is_show_done ) ] } );
    private.ShowProgress();

  end;
  --******************************************************************************************
  function private.ProgressMouseOver( name_number, color_value )

    local cur = {};
    cur[ '0' ] = CURSOR_HAND;
    cur[ '1' ] = CURSOR_DEFAULT;
    SetCursor( cur[ tostring( color_value ) ] );

    local objname = "spr_cheater_progress_";
    local record_first = private.LINE_MAX_COUNT * private.column.progress + 1;
    
    for i = record_first, name_number do
      --ObjSet( objname..i, { color_r = color_value } );
      local o = ObjGet( objname..i )
      if color_value == 0 then
        ObjSet( objname..i, { color_r = o.color_r > 0.2 and o.color_r - 0.2,
                              color_g = o.color_g > 0.2 and o.color_g - 0.2,
                              color_b = o.color_b > 0.2 and o.color_b - 0.2, } );
      elseif color_value == 1 then
        ObjSet( objname..i, { color_r = o.color_r > 0.2 and o.color_r + 0.2,
                              color_g = o.color_g > 0.2 and o.color_g + 0.2,
                              color_b = o.color_b > 0.2 and o.color_b + 0.2, } );
      end;
    end;

    ObjSet( 'spr_cheater_progress_arrow_left', { color_r = color_value } );


end;
--******************************************************************************************
--function  *** CONSOLE *** () end;
--******************************************************************************************
  function private.ShowConsole()
    ld.LogTrace( "ShowConsole" )
  end
  --******************************************************************************************
  function private.ConsoleClearDown()

    ObjSet( "ted_cheater_execute", { text = "" } );
    ld.LogTrace( "ConsoleClearDown" )
  end
  --******************************************************************************************
  function private.ConsoleDown()
    ld.LogTrace( "ConsoleDown" )
    --TrgSet( "trg_cheater_code", { code = ObjGet( "ted_cheater_execute" ).text } );
    --TrgExecute( "trg_cheater_code" );
    common.LogTrace( "Code executed: "..ObjGet( "ted_cheater_execute" ).text );

  end;
--******************************************************************************************
--function  *** KEYBOARD *** () end;
--******************************************************************************************
  function private.InitKeyboard()

    local keys_in_row = { 11, 9, 9, 4 };
    for i = 1, 4 do
      for j = 1, #keys_in_row do
        ObjSet( "spr_cheater_console_keyboard_keys_"..i.."_"..j, {
          event_mdown = function () private.keyboard.key.Down( i.."_"..j ); end,
          event_mdown = function () private.keyboard.key.MouseEnter( i.."_"..j ); end,
          event_mdown = function () private.keyboard.key.MouseLeave( i.."_"..j ); end
        } );
      end;
    end;

    ObjSet( "spr_cheater_console_keyboard_keys_1_11", { event_mdown = private.keyboard.Backspace } );
    ObjSet( "spr_cheater_console_keyboard_keys_3_1",  { event_mdown = private.keyboard.ShiftDown } );
    ObjSet( "spr_cheater_console_keyboard_keys_3_9",  { event_mdown = function () private.ConsoleDown(); private.keyboard.but.Down(); end; } );
    ObjSet( "spr_cheater_console_keyboard_keys_4_1",  { event_mdown = private.keyboard.Switch } );
    ObjSet( "spr_cheater_console_keyboard_keys_4_3",  { event_mdown = private.keyboard.Space } );

  end;
  --******************************************************************************************
  private.keyboard = {};
  private.keyboard.layout = "abc";
  private.keyboard.shift = "usual";
  private.keyboard["abc"] = {};
  private.keyboard["abc"]['usual'] = {
  { 'q',     'w', 'e', 'r', 't',  'y',  'u',  'i',  'o',     'p',  'zz'        },
  { 'a',     's', 'd', 'f', 'g',  'h',  'j',  'k',  'l',     'zz', 'zz'        },
  { 'shift', 'z', 'x', 'c', 'v',  'b',  'n',  'm',  'zz',    'zz', 'zz'        },
  { 'zz',    ',', 'zz','.', 'zz', 'zz', 'zz', 'zz', 'zz',    'zz', 'zz'        }
  };
  private.keyboard["abc"]['shift'] = {
  { 'Q',     'W', 'E',  'R', 'T',  'Y',  'U',  'I',  'O',    'P',  'zz'        },
  { 'A',     'S', 'D',  'F', 'G',  'H',  'J',  'K',  'L',    'zz', 'zz'        },
  { 'shift', 'Z', 'X',  'C', 'V',  'B',  'N',  'M',  'zz',   'zz', 'zz'        },
  { 'zz',    ',', 'zz', '.', 'zz', 'zz', 'zz', 'zz', 'zz',   'zz', 'zz'        }
  };
  private.keyboard["123"] = {};
  private.keyboard["123"]['usual'] = {
  { '1',     '2', '3', '4', '5',  '6',  '7',  '8',  '9',     '0',  'zz'        },
  { '#',     '/', '{', '}', '(',  ')',  "*",  ':',  '\"',    'zz', 'zz'        },
  { 'shift', '[', ']', '+', '=',  '-',  '_',  ';',  'zz',    'zz', 'zz'        },
  { 'zz',    ',', 'zz','.', 'zz', 'zz', 'zz', 'zz', 'zz',    'zz', 'zz'        }
  };
  private.keyboard["123"]['shift'] = {
  { 'zz',    'zz', 'zz', 'zz', 'zz', 'zz', 'zz', 'zz', 'zz', 'zz', 'zz'        },
  { 'zz',    '\\', 'zz', 'zz', "zz", "zz", 'zz', 'zz', '\'', 'zz', 'zz'        },
  { 'shift', 'zz', 'zz', 'zz', 'zz', 'zz', 'zz', 'zz', 'zz', 'zz', 'zz'        },
  { 'zz',    ',',  'zz', '.',  'zz', 'zz', 'zz', 'zz', 'zz', 'zz', 'zz'        }
  };
  private.keyboard.but = {};
  --******************************************************************************************
  function private.keyboard.but.Down()

    local name_keyboard = "cheater_console_keyboard_keys";
    local is_need_show = not ObjGet( name_keyboard ).visible; 
    local need_show = is_need_show;
    ObjSet( name_keyboard, { visible = need_show, input = need_show } );

    private.keyboard.layout = "abc";
    private.keyboard.shift = "usual";
    if ( is_need_show ) then
      private.keyboard.Update();
    end;

  end
  --******************************************************************************************
  function private.keyboard.Update()

    local text = "";
    local objname = "txt_cheater_console_keyboard_keys_";
    local layout = private.keyboard.layout;
    local shift  = private.keyboard.shift;

    for row = 1, #private.keyboard[ layout ][ shift ] do

      for index = 1, #private.keyboard[ layout ][ shift ][ row ] do

        text = private.keyboard[ layout ][ shift ][ row ][ index ];
        if ( text ~= "zz" ) then
          if ( ObjGet( objname..row.."_"..index ).name ) then  
            ObjSet( objname..row.."_"..index, { text = text } );
          end;
        end;

      end;

    end;

  end
  --******************************************************************************************
  function private.keyboard.ShiftDown()

    local params = {};
    params[ "shift" ] = "usual";
    params[ "usual" ] = "shift";
    private.keyboard.shift = params[ private.keyboard.shift ];
    private.keyboard.Update();

  end;
  --******************************************************************************************
  function private.keyboard.Switch()

    local objname = "cheater_console_keyboard_keys_4_1";
    local params = {};
    ObjSet( "txt_"..objname, { text = private.keyboard.layout } );
    params[ "abc" ] = "123";
    params[ "123" ] = "abc";
    private.keyboard.layout = params[ private.keyboard.layout ];
    private.keyboard.shift = "usual";
    private.keyboard.Update();

  end;
  --******************************************************************************************
  function private.keyboard.Backspace()

    local ted_name = "ted_cheater_execute";
    local text_full = ObjGet( ted_name ).text;
    local text_full_len = string.len( text_full );
    if ( text_full_len ~= 0 ) then  
      local text_cut = string.sub( text_full, 1, text_full_len - 1 );
      ObjSet( ted_name, { text = text_cut } );
    end;

  end;
  --******************************************************************************************
  function private.keyboard.Space()

    private.keyboard.key.Down( "4_3", " " );

  end;
  --******************************************************************************************
  function private.keyboard.but.MouseEnter()

    SetCursor( CURSOR_HAND );
    ObjSet( "spr_cheater_console_keyboard", { color_r = 0 } );

  end;
  --******************************************************************************************
  function private.keyboard.but.MouseLeave()

    SetCursor( CURSOR_DEFAULT );
    ObjSet( "spr_cheater_console_keyboard", { color_r = 0.9 } );

  end;
  --******************************************************************************************
  private.keyboard.key = {};
  --******************************************************************************************
  function private.keyboard.key.Down( pos, newsymbol )

    local ted_name = "ted_cheater_execute";
    local key_name = "txt_cheater_console_keyboard_keys_"..pos;
    local symbol = newsymbol or ObjGet( key_name ).text;

    ObjSet( ted_name, { text = ObjGet( ted_name ).text..symbol } );

    if ( private.keyboard.shift == "shift" ) then
      private.keyboard.ShiftDown();
    end;

  end;
  --******************************************************************************************
  function private.keyboard.key.MouseEnter( pos )

    SetCursor( CURSOR_HAND );
    ObjSet( "spr_cheater_console_keyboard_keys_"..pos, { color_r = 0 } );

  end;
  --******************************************************************************************
  function private.keyboard.key.MouseLeave( pos )

    SetCursor( CURSOR_DEFAULT );
    ObjSet( "spr_cheater_console_keyboard_keys_"..pos, { color_r = 1 } );

end;
--******************************************************************************************
-- function *** ROOMS *** () end;
--******************************************************************************************
  function private.GetRoomNames()

    return game.room_names;

  end;
  --******************************************************************************************
  function private.ShowRooms( p_column_shift )

    if ( not p_column_shift ) then

      private.column.room = 0;
      private.SetArrow( "left", "room", false );
      ObjSet( "cheater_room_names", { pos_x = 0 } );
      private.DetachColumn( "room" );

    end;

    local column_amount = p_column_shift or 0;
    local column_counter = column_amount;

    local room_idstart = column_amount * private.LINE_MAX_COUNT + 1;
    local room_names = private.GetRoomNames();
    local room_color = { ho = { color_b = 0.60, color_g = 1.00 }, 
                         mg = { color_b = 1.00, color_g = 0.75 }, 
                         rm = { color_b = 0.50, color_g = 0.50 },
                         zz = { color_b = 1.00, color_g = 1.00 },
    };

    local arrow_param = false;
    --DbgTrace( "ShowRooms: start_room_id = "..start_room_id );

    local zoom_id = 0

    for room_id = room_idstart, #room_names do

      local room_objname = room_names[ room_id ];

      if ( ( room_id + zoom_id ) > ( column_counter * private.LINE_MAX_COUNT ) ) then
        
        local column_counter_abs = private.COLUMN_MAX_COUNT + column_amount;
        
        if ( ( column_counter >= column_counter_abs ) and ( room_names[ room_id + 1 ] ) ) then

          --DbgTrace( "ShowRooms: break "..room_id );
          arrow_param = true;
          break;

        end;

        --DbgTrace( "ShowRooms: column_counter++ "..column_counter.." ( room_id = "..room_id.." )" );
        column_counter = column_counter + 1;
        local column_params = 
        {
           counter = column_counter,
           amount  = column_amount,
           type    = 'room'
        };
        private.CreateColumn( column_params );
          
      end;

      local room_name   = common.GetObjectPrefix( room_objname );


      local room_num = room_id + zoom_id

      local room_params = 
      {
          obj_num      = room_num
         ,type         = "room"
         ,column       = column_counter 
         ,text         = room_objname
         ,event_mdown  = function () cmn.GotoRoom( room_objname ); private.ButtonDown( "room" ) end
         ,event_menter = function () private.ButtonMouseEnter( "room", room_num ) private.ButMouseEnterZRM( room_objname ) end
         ,event_mleave = function () private.ButtonMouseLeave( "room", room_num ) private.ButMouseLeaveZRM( room_objname ) end
         ,color_b      = room_color[ room_name ][ "color_b" ]
         ,color_g      = room_color[ room_name ][ "color_g" ]
      };
      private.CreateRecord( room_params );

      if ld.IsLdCheater() and ld_impl.SmartHint_GetZzListInRoom and room_objname:find( "^rm" ) then
        local zzs = ld_impl.SmartHint_GetZzListInRoom( room_objname )

        if zzs then
          for i = 1, #zzs do


            if ( ( room_id + zoom_id + 1 ) > ( column_counter * private.LINE_MAX_COUNT ) ) then
              
              local column_counter_abs = private.COLUMN_MAX_COUNT + column_amount;
              
              if ( ( column_counter >= column_counter_abs ) and ( room_names[ room_id + 1 ] ) ) then

                --DbgTrace( "ShowRooms: break "..room_id );
                arrow_param = true;
                break;

              end;

              --DbgTrace( "ShowRooms: column_counter++ "..column_counter.." ( room_id = "..room_id.." )" );
              column_counter = column_counter + 1;
              local column_params = 
              {
                 counter = column_counter,
                 amount  = column_amount,
                 type    = 'room'
              };
              private.CreateColumn( column_params );
                
            end;


            zoom_id = zoom_id + 1
            local zoom_num = room_id + zoom_id
            local room_params = 
            {
                obj_num      = zoom_num
               ,type         = "room"
               ,column       = column_counter 
               ,text         = "   "..zzs[ i ]
               ,event_mdown  = function ()
                  if ld.Room.Current() == room_objname then
                    common.GotoSubRoom( zzs[ i ] );
                  else
                    cmn.GotoRoom( room_objname );
                  end
                  private.ButtonDown( "room" );
                end
               ,event_menter = function () private.ButtonMouseEnter( "room", zoom_num ) private.ButMouseEnterZRM( zzs[ i ] ) end
               ,event_mleave = function () private.ButtonMouseLeave( "room", zoom_num ) private.ButMouseLeaveZRM( zzs[ i ] ) end
               ,color_b      = room_color[ "zz" ][ "color_b" ]
               ,color_g      = room_color[ "zz" ][ "color_g" ]
            };
            private.CreateRecord( room_params );
          end
        end
      end
      
    end;

    private.SetArrow( "right", "room", arrow_param );

  end
--******************************************************************************************
-- function *** BUTTONS *** () end;
--******************************************************************************************
  function private.InitButtons()

    ObjSet( "spr_cheater_but_back", { event_mdown = private.ButDown,
                                      event_menter = private.ButMouseEnter,
                                      event_menter = private.ButMouseLeave  } );

    ObjSet( "cheater_close", { event_mdown = private.Close } );

    ObjSet( "spr_cheater_sound_back", {  event_mdown = private.SoundOnOff,
                                         event_menter = function () private.ButtonMouseEnter( "sound", "back" ); end,
                                         event_menter = function () private.ButtonMouseLeave( "sound", "back" ); end } );
    ObjSet( "spr_cheater_skip_back", { event_mdown = private.SkipVideo,
                                       event_menter = function () private.ButtonMouseEnter( "skip", "back" ); end,
                                       event_menter = function () private.ButtonMouseLeave( "skip", "back" ); end } );
    ObjSet( "spr_cheater_mode_back", { event_mdown = private.ChangeMode,
                                       event_menter = function () private.ButtonMouseEnter( "mode", "back" ); end,
                                       event_menter = function () private.ButtonMouseLeave( "mode", "back" ); end } );


    ObjSet( "spr_cheater_progress_back", { event_mdown = function () private.ButtonDown( "progress" ); end,
                                           event_menter = function () private.ButtonMouseEnter( "progress", "back" ); end,
                                           event_menter = function () private.ButtonMouseLeave( "progress", "back" ); end  } );
    ObjSet( "spr_cheater_progress_step", { event_mdown = private.ProgressStep,
                                           event_menter = function () private.ButtonMouseEnter( "progress", "step" ); end,
                                           event_menter = function () private.ButtonMouseLeave( "progress", "step" ); end  } );
    ObjSet( "spr_cheater_progress_check_back", { event_mdown = private.ProgressCheckDown,
                                           event_menter = function () private.ButtonMouseEnter( "progress_check", "back" ); end,
                                           event_menter = function () private.ButtonMouseLeave( "progress_check", "back" ); end  } );
    ObjSet( "obj_cheater_progress_arrow_left", {  event_mdown = function () private.MoveList( "left", "progress" ); end,
                                              event_menter = function () SetCursor( CURSOR_LEFT ); end,
                                              event_menter = function () SetCursor( CURSOR_DEFAULT ) end  } );
    ObjSet( "obj_cheater_progress_arrow_right", {  event_mdown = function () private.MoveList( "right", "progress" ); end,
                                              event_menter = function () SetCursor( CURSOR_LEFT ); end,
                                              event_menter = function () SetCursor( CURSOR_DEFAULT ) end  } );

    ObjSet( "spr_cheater_room_back", { event_mdown = function () private.ButtonDown( "room" ); end,
                                       event_menter = function () private.ButtonMouseEnter( "room", "back" ); end,
                                       event_menter = function () private.ButtonMouseLeave( "room", "back" ); end  } );
    ObjSet( "obj_cheater_room_arrow_left", {  event_mdown = function () private.MoveList( "left", "room" ); end,
                                              event_menter = function () SetCursor( CURSOR_LEFT ); end,
                                              event_menter = function () SetCursor( CURSOR_DEFAULT ) end  } );
    ObjSet( "obj_cheater_room_arrow_right", {  event_mdown = function () private.MoveList( "right", "room" ); end,
                                              event_menter = function () SetCursor( CURSOR_LEFT ); end,
                                              event_menter = function () SetCursor( CURSOR_DEFAULT ) end  } );

    ObjSet( "spr_cheater_execute_back", {  event_mdown = function () private.ButtonDown( "execute" ); end,
                                           event_menter = function () private.ButtonMouseEnter( "execute", "back" ); end,
                                           event_menter = function () private.ButtonMouseLeave( "execute", "back" ); end  } );
    ObjSet( "spr_cheater_console_clear", { event_mdown = private.ConsoleClearDown,
                                           event_menter = function () private.ButtonMouseEnter( "console", "clear" ); end,
                                           event_menter = function () private.ButtonMouseLeave( "console", "clear" ); end  } );
    ObjSet( "spr_cheater_console_keyboard", {  event_mdown = private.keyboard.but.Down,
                                               event_menter = private.keyboard.but.MouseEnter,
                                               event_menter = private.keyboard.but.MouseLeave  } );

    ObjSet( "ted_cheater_execute", { trg_enter = private.ReviewTextEditingDone  } );
    ObjSet( "ted_cheater_default_review_field_text", { trg_enter = private.ReviewTextEditingDone  } );
    ObjSet( "obj_cheater_default_review_field", { event_mdown = private.ReviewMark  } );

    ObjSet( "spr_cheater_helper_plus_back", { event_mdown = function () private.GetHelper(); end } );
    ObjSet( "spr_cheater_helper_minus_back", { event_mdown = function () private.DropHelper(); end } );
  end;
  --******************************************************************************************
  function private.ButDown()

    ObjSet( "txt_cheater_current_version", { text = "ver: "..GetEngineVersion().." / "..(ConfigGetProjectVersion() or "unknown" ) } );
    
    private.ShowFPS( not ObjGet( "tmr_cheater_fps" ).playing );

    local button_params = { in_menu = { progress = false, room = false, execute = true },
                            in_game = { progress = true, room = true, execute = true } };
    local button_index  = "in_game";
    if ( cmn.is_inmenunow ) then
      button_index  = "in_menu";
    end;

    for key in pairs( button_params[ button_index ] ) do
      ObjSet( "cheater_"..key, { 
        input   = button_params[ button_index ][ key ],
        visible = button_params[ button_index ][ key ] } );
    end;

  end;
  --******************************************************************************************
  function private.ButtonDown( selected_button_name )

    --ObjSet( "cheater_progress_step", { visible = true, input = true } );
    local button_funcs = { room = private.ShowRooms, progress = private.ShowProgress, execute = private.ShowConsole };

    for key in pairs( button_funcs ) do

      local list_name  = "cheater_"..key.."_list";
      local list_param = false;
      
      if ( selected_button_name == key ) then
        
        list_param = not ObjGet( list_name ).visible;
        ObjSet( "cheater_close", { input = list_param } );
        if ( list_param ) then
          button_funcs[ selected_button_name ]();
        end;

      end;

      ObjSet( list_name, { visible = list_param, input = list_param, color_g = list_param } );
      ObjSet( "spr_cheater_"..key.."_back", { color_b = common.ConditionChoose( list_param == 1, 0, 1 ) } );

    end;

  end;
  --******************************************************************************************
  function private.Close()

    local keys = { "room", "progress", "execute" };
    for key, value in pairs( keys ) do
    
      local list_name  = "cheater_"..value.."_list";
      if ( ObjGet( list_name ).visible ) then
        private.ButtonDown( value );
        break;
      end;
    end;

  end;
  --******************************************************************************************
  function private.ButtonMouseEnter( button_part, button_name )

    SetCursor( CURSOR_HAND );
    ObjSet( "spr_cheater_"..button_part.."_"..button_name, { color_r = 0 } );

  end;
  --******************************************************************************************
  function private.ButtonMouseLeave( button_part, button_name )

    SetCursor( CURSOR_DEFAULT );
    local color_r = 0.9;
    if ( button_name ~= "back" ) then color_r = 1; end;
    ObjSet( "spr_cheater_"..button_part.."_"..button_name, { color_r = color_r } );

  end;
  --******************************************************************************************
  function private.ButMouseEnter()

    if ( not ObjGet( "cheater_content" ).visible ) then
      ObjSet( "spr_cheater_but", { alp = 1 } );
    end;
    SetCursor(CURSOR_HAND);

  end;
  --******************************************************************************************
  function private.ButMouseLeave()

    if ( not ObjGet( "cheater_content" ).visible ) then
      ObjSet( "spr_cheater_but", { alp = 0 } );
    end;
    SetCursor(CURSOR_DEFAULT)

  end;
  --******************************************************************************************
  function private.ButMouseEnterZRM( zrm )
    local cp = GetGameCursorPos()
    local obj = "cheater_zrm_preview"
    local o = ObjGet( obj )
    if not o then
      ObjCreate( obj, "spr" )
      ObjSet( obj, { input = 0; pos_z = 9999; pos_x = 512 + 171; pos_y = 384; } )
    end
    ObjAttach( obj, "cheater" )
    local prg = ng_global.currentprogress;
    local level = ng_global.progress[ prg ].common.chapter;
    local res = "assets/levels/"..level.."/"
    if zrm:find( "^zz" ) then
      local rm = ld_impl.SmartHint_GetRoomParent( zrm )
      res = res..rm.."/"..zrm.."/back"
    else
      res = res..zrm.."/miniback"
    end
  
    ObjSet( obj, { res = res; pos_x = 512 + 350 * ( cp[ 1 ] > 512 and - 1 or 1 ) } )
  end;
  --******************************************************************************************
  function private.ButMouseLeaveZRM( zrm )
    local obj = "cheater_zrm_preview"
    ObjDetach( obj )
  end;
  --******************************************************************************************
  function private.HeightChange()

    local param = { wide = 30, custom = 10 };

    local need = "custom";
    if ( private.is_ipad ) then
      need = "wide";
    end;

    local buttons = { "room_back", "progress_back", "execute_back" };

    for but_key, but_name in pairs( buttons ) do

      ObjSet( "spr_cheater_"..but_name, { scale_y = param[ need ] } );
      ObjSet(     "cheater_"..but_name, {   pos_y = param[ need ] } );

    end;  

    buttons = { "progress_check", "console_clear", "console_keyboard" };

    for but_key, but_name in pairs( buttons ) do

      ObjSet( "spr_cheater_"..but_name, { scale_y = param[ need ] } );
      ObjSet(     "cheater_"..but_name, {   pos_y = (-1)*param[ need ] - 10 } );

    end;  

    ObjSet( "spr_cheater_but", { pos_y   = param[ need ]} );
    ObjSet( "spr_cheater_but_back", { scale_y = param[ need ] } );

    ObjSet( "cheater_buttons", { pos_y   = param[ need ] - 10   } );

    ObjSet( "cheater_execute_list",   { pos_y = ( param[ need ] + 10 ) } );
    ObjSet( "cheater_room_list",      { pos_y = ( param[ need ] + 10 ) } );
    ObjSet( "cheater_progress_list",  { pos_y = ( param[ need ] + 10 ) } );

  end;
--******************************************************************************************
--function  *** LIST *** () end;
--******************************************************************************************
--obj_num - id / index_obj
--type - room / progress
--column = 
--text - room_name / progress_name
--event_mdown = 
--event_menter
--event_mleave
--color_b
--color_g
--******************************************************************************************
  function private.CreateRecord( record ) 

        local txtf = record.text
        local add_cube = 0;
        local complex_mark = false

          --complex item
          if ld and ld.StringDivide then
            local div = ld.StringDivide( txtf )
            if div[ 1 ] == "get" and #div == 2 and ObjGet( "inv_complex_"..div[ 2 ] ) then
              complex_mark = true
            end
          end

          --mul Use
          local inv = private.HINT_ROOT[ txtf ] and private.HINT_ROOT[ txtf ].inv_obj or false
          if inv then
            local c = 0
            for k,v in pairs( private.HINT_ROOT ) do
              if type( v ) == "table" then
                if v.inv_obj == inv then
                  c = c + 1;
                  if c >= 2 then
                    record.text = "M"..record.text
                    add_cube = add_cube + 1
                    break
                  end;
                end;
              else
                --ld.LogTrace( k, v )
              end
            end;
          end;

          if common_impl and ld.NumberFromString then
            --mul Get
            if txtf:find( "^get" ) and private.HINT_ROOT[ txtf ] and not private.HINT_ROOT[ txtf ].inv_obj then
              local num = ld.NumberFromString( txtf )
              --ld.LogTrace( txtf, num )
              if num then
                --ld.LogTrace( txtf, num, txtf:gsub( num.."$", "" ) )
                local c = 0
                for k,v in pairs( private.HINT_ROOT ) do
                  local num_next = ld.NumberFromString( k )
                  local inv_use = txtf:gsub( num.."$", "" ):gsub( "^get", "inv" )
                  if  num_next 
                  and txtf:gsub( num.."$", "" ) == k:gsub( num_next.."$", "" ) 
                  and ld.TableContains( private.HINT_ROOT, inv_use )
                  then
                    c = c + 1;
                    if c >= 2 then
                      record.text = "M"..record.text
                      add_cube = add_cube + 1
                      --ld.LogTrace( inv_use )
                      break
                    end;
                  end;
                end;
              end;
            end
          end

        if private.HINT_ROOT[ txtf ] and private.HINT_ROOT[ txtf ].room == "inv_complex_inv" then
          record.text = "D"..record.text
          add_cube = add_cube + 1
        --end;
        end
        if private.HINT_ROOT[ txtf ] and private.HINT_ROOT[ txtf ].room == "int_diary" then
          record.text = "*"..record.text
          add_cube = add_cube + 1
        end;
        

        

      local new_pos_y   = 0;
      local record_name = "cheater_"..record.type.."_"..record.obj_num;
      local column_name = "cheater_"..record.type.."_column_"..record.column;
      local txt_params  = {};
      local spr_params  = {};
      
      new_pos_y = ( ( record.obj_num - 1 ) - ( record.column - 1 )*private.LINE_MAX_COUNT ) * 20;
    
      txt_params.pos_y        = new_pos_y;
      txt_params.text        = record.text;
        txt_params.color_r     = record and record.text_r or 0;
        txt_params.color_g     = record and record.text_g or 0;
        txt_params.color_b     = record and record.text_b or 0;

      spr_params.pos_y        = new_pos_y;
      spr_params.event_mdown  = record.event_mdown;
      spr_params.event_menter = record.event_menter;
      spr_params.event_mleave = record.event_mleave;

      spr_params.color_r      = record.color_r;
      spr_params.color_g      = record.color_g;
      spr_params.color_b      = record.color_b;


      if ( not ObjGet( "spr_"..record_name ) ) then

        ObjCreate( "txt_"..record_name, "text" );
        ObjCreate( "spr_"..record_name, "spr" );

        txt_params.res = "assets/shared/cheater/courier_new";
        txt_params.fontsize    = 12;
        txt_params.align       = 0;
        txt_params.disprawtext = 1;
        txt_params.pos_x       = -80

        txt_params.visible     = true; 
        txt_params.input       = false; 
        txt_params.active      = false;

        spr_params.res = "assets/shared/cheater/editor_back";
        spr_params.scale_x = 80;
        spr_params.scale_y = 10;
        spr_params.visible = true; 
        spr_params.alp     = 1;
        spr_params.input   = true;
        spr_params.active  = false;

          ObjCreate( "spr_"..record_name.."_dm", "spr")
          ObjSet( "spr_"..record_name.."_dm", { res = "assets/shared/cheater/editor_back", pos_x = -0.98 + add_cube * 0.05, color_r = 0.65,color_g = 0.65,color_b = 1, input = 0,scale_x = 1/21*add_cube, scale_y = 1, alp = 0 } )
          ObjAttach( "spr_"..record_name.."_dm", "spr_"..record_name )

          ObjCreate( "obj_"..record_name.."_complex", "obj")
          ObjAttach( "obj_"..record_name.."_complex", "spr_"..record_name )

          ObjCreate( "spr_"..record_name.."_complex_d", "spr")
          ObjSet( "spr_"..record_name.."_complex_d", { res = "assets/shared/cheater/editor_back", pos_x = 0, pos_y = 0.85, color_r = 0.25,color_g = 0.25,color_b = 0.25, input = 0,scale_x = 1, scale_y = 0.15, alp = 1 } )
          ObjAttach( "spr_"..record_name.."_complex_d", "obj_"..record_name.."_complex" )
          ObjCreate( "spr_"..record_name.."_complex_u", "spr")
          ObjSet( "spr_"..record_name.."_complex_u", { res = "assets/shared/cheater/editor_back", pos_x = 0, pos_y = -0.85, color_r = 0.25,color_g = 0.25,color_b = 0.25, input = 0,scale_x = 1, scale_y = 0.15, alp = 1 } )
          ObjAttach( "spr_"..record_name.."_complex_u", "obj_"..record_name.."_complex" )
          ObjCreate( "spr_"..record_name.."_complex_r", "spr")
          ObjSet( "spr_"..record_name.."_complex_r", { res = "assets/shared/cheater/editor_back", pos_x = 0.98, pos_y = 0, color_r = 0.25,color_g = 0.25,color_b = 0.25, input = 0,scale_x = 0.02, scale_y = 0.9, alp = 1 } )
          ObjAttach( "spr_"..record_name.."_complex_r", "obj_"..record_name.."_complex" )
          ObjCreate( "spr_"..record_name.."_complex_l", "spr")
          ObjSet( "spr_"..record_name.."_complex_l", { res = "assets/shared/cheater/editor_back", pos_x = -0.98, pos_y = 0, color_r = 0.25,color_g = 0.25,color_b = 0.25, input = 0,scale_x = 0.02, scale_y = 0.9, alp = 1 } )
          ObjAttach( "spr_"..record_name.."_complex_l", "obj_"..record_name.."_complex" )

      end;

      ObjSet( "txt_"..record_name, txt_params );
      ObjSet( "spr_"..record_name, spr_params );

      if add_cube > 0 then
        ObjSet( "spr_"..record_name.."_dm", { alp = 1, pos_x = -0.98 + add_cube * 0.05, scale_x = 1/21*add_cube } )
      else
        ObjSet( "spr_"..record_name.."_dm", { alp = 0 } )
      end;
      if complex_mark then
        ObjSet( "obj_"..record_name.."_complex", { alp = 1 } )
      else
        ObjSet( "obj_"..record_name.."_complex", { alp = 0 } )
      end;

      ObjAttach( "spr_"..record_name, column_name );
      ObjAttach( "txt_"..record_name, column_name );

  end;
  --******************************************************************************************
  function private.DetachColumn( param0, param1 ) 

    local column_name_temp = "cheater_%s_column_%i";

    if ( param1 ) then

      local column_shifted_amount  = private.column[ param0 ];
      local column_num = column_shifted_amount; 

      if ( param1 == 'left' ) then
        column_num = column_num + private.COLUMN_MAX_COUNT + 1;
      end;

      local column_name = string.format( column_name_temp, param0, column_num );

      ObjDetach( column_name );
      for i,o in ipairs( ObjGetRelations( column_name ).childs ) do
        ObjDetach(o)
      end

    else
      
      local counter = private.COLUMN_MAX_COUNT;
      local column_name = string.format( column_name_temp, param0, counter );

      while ( ObjGet( column_name ) and ObjGet( column_name ).name ) do

        ObjDetach( column_name );
        for i,o in ipairs( ObjGetRelations( column_name ).childs ) do
          ObjDetach(o)
        end
        counter = counter + 1;
        column_name = string.format( column_name_temp, param0, counter);

      end

    end;

  end;
  --******************************************************************************************
  function private.CreateColumn( column ) 

    local hub_name    = string.format( "cheater_%s_names", column.type );
    local column_numb = column.counter;    
    local column_name = string.format( "cheater_%s_column_%i", column.type, column_numb );
    local column_posx = private.RECORD_WIDTH * ( column.counter - 1 );

    if ( not ObjGet( column_name ) ) then
      ObjCreate( column_name, "obj" );
    end;

    ObjSet( column_name, 
    {
      pos_x  = column_posx,
      active = 0
    } );

    ObjAttach( column_name,  hub_name );

  end;
  --******************************************************************************************
  function private.SetArrow( side, name_part, param )

    local arrow_name  = string.format( "obj_cheater_%s_arrow_%s", name_part, side );
    ObjSet( arrow_name,
      {
          input       = param
         ,visible     = param
      } );

  end;
  --******************************************************************************************
  function private.MoveList( side, type )

    --DbgTrace( "MoveList: Moving "..side..". " );

    local direction = { right = 1, left = -1 };
    local show_func = { room = private.ShowRooms, progress = private.ShowProgress }

    private.column[ type ] = private.column[ type ] + direction[ side ];
    local column_shift = private.column[ type ];

    show_func[ type ]( column_shift );

    local hub = string.format( "cheater_%s_names", type );
    ObjSet( hub, 
    {
      pos_x = ( - 1 ) * private.RECORD_WIDTH * column_shift
    } );

    private.DetachColumn( type, side );

    private.SetArrow( "left", type, ( column_shift ~= 0 ) );

  end;
--******************************************************************************************
--function *** OPTIONS ***() end;
--******************************************************************************************
  function private.ChangeMode() 

    private.is_ipad = not private.is_ipad;
    private.HeightChange();

  end;
  --******************************************************************************************
  function private.SkipVideo() 

    if ( _G[ "int_dialog_video" ] ) then
      
      if ObjGet("int_dialog_video").input then -- если играет видео
        int_dialog_video.SkipClick();
      end

    end;

  end;
  --******************************************************************************************
  private.sound = { sfx = 0, env = 0, soundtrack = 0, voice = 0 };
  private.sound.is_on = true;
  --******************************************************************************************
  function private.SoundOnOff()

    private.sound.is_on = not private.sound.is_on;

    for type, value in pairs( private.sound ) do

      if ( private.sound.is_on ) then
        value = 0.7;
      else
        value = 0;
      end;
      SetSoundVolume( type, value );
    
    end;  

  end
  --******************************************************************************************
  function private.ControlButtons( options )

    local buttons = 
      { 
        mode = "cheater_mode", 
        skip = "cheater_skip", 
        sound = "cheater_sound" 
      };
    local popups  = 
      { 
        mode = "Change cheater buttons height", 
        skip = "Skip video", 
        sound = "Enable or disable sounds" 
      };
    for option, value in pairs( options ) do

      local option_name = string.format( "spr_%s_back", buttons[ option ] );
      local option_params = ObjGet( option_name );
      local color = value / 2 + 0.5;
      local events = { enter = option_params.event_menter, leave = option_params.event_mleave };
      if ( value == 0 ) then
        events.enter = "";
        events.leave = "";
        popups[ option ] = popups[ option ].." ( disabled ) ";
      end;
      ObjSet( option_name, 
        { 
          color_r = color,
          color_g = color,
          color_b = color
          --event_menter = events.enter.."interface.PopupShow( '"..popups[ option ].."' );",
          --event_mleave = events.leave.."interface.PopupHide();"
        } );

    end;

  end;
--******************************************************************************************
--function *** REVIWEW ***() end;
--******************************************************************************************
  function private.InitReviewMode()
    private.default = {};

    private.default.review_field = common.GetObjParamsForSet( "obj_cheater_default_review_field" );

    private.default.review_field_mark = common.GetObjParamsForSet( "spr_cheater_default_review_field_mark" );
    private.default.review_field_text = common.GetObjParamsForSet( "ted_cheater_default_review_field_text" );
    private.default.review_field_back = common.GetObjParamsForSet( "spr_cheater_default_review_field_back" );
    private.default.review_field_link = common.GetObjParamsForSet( "grd_cheater_default_review_field_link" );

    private.reviewmode_enabled = false;

    private.review_mark_count = 0;

    private.review_mark_dragged = nil;
    private.review_back_dragged = nil;
  end;
  --******************************************************************************************
  function private.ReviewMode()

    if not ( private.reviewmode_enabled ) then

      private.reviewmode_enabled = true;

      ObjSet( "ng_level", { active = 0 } );

      ObjCreate( "obj_cheater_review_field", "obj" );

      ObjSet( "obj_cheater_review_field", private.default.review_field );
      ObjAttach( "obj_cheater_review_field", "ng_application" );

      ObjAttach( "txt_cheater_review_field", "obj_cheater_review_field" );

      ObjAnimate( "txt_cheater_review_field", "alp", 1, 0, "",
      {
        0.0, 3, 0.5,
        1.5, 3, 1.0,
        3.0, 3, 0.5
      } );

    else

      if ( private.review_text_editing ) then

        private.ReviewTextEditingDone();

      end;

      MsgSubscribe( Event_Level_ScreenshotSaved, private.ReleaseReview );
      MsgSend( Event_Level_CheaterSaveScreenshot );

    end;

  end;
  --******************************************************************************************
  function private.ReviewMark()

    if not ( private.review_text_editing ) then

      private.review_mark_count = private.review_mark_count + 1;
      local current_num = private.review_mark_count;

      local cur_pos = GetGameCursorPos();
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
      local mark_object = "spr_cheater_review_field_mark_"..private.review_mark_count;
      local mark_params = private.default.review_field_mark;

      mark_params.pos_x = cur_pos[ 1 ];
      mark_params.pos_y = cur_pos[ 2 ];

      mark_params.event_startdrag = function () private.ReviewMarkDragStart( current_num ); end;
      mark_params.event_drag      = function () private.ReviewMarkDrag( current_num ); end;
      mark_params.event_dragdrop  = function () private.ReviewMarkDrop( current_num ); end;

      ObjCreate( mark_object, "spr" );
      ObjSet( mark_object, mark_params );
      ObjAttach( mark_object, "obj_cheater_review_field" );

      ObjAnimate( mark_object, "color_rgb", 1, 0, "",
      {
        0.0, 3, 1, 0, 0,
        0.3, 3, 1, 1, 1,
        0.6, 3, 1, 0, 0
      } );
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
      local back_object = "spr_cheater_review_field_back_"..private.review_mark_count;
      local back_params = private.default.review_field_back;

      back_params.pos_x = 150 + 36 + mark_params.pos_x;
      back_params.pos_y = mark_params.pos_y;

      if ( mark_params.pos_x > 512 ) then

        back_params.pos_x = - 150 - 36 + mark_params.pos_x;

      end;

      back_params.event_startdrag = function () private.ReviewBackDragStart( current_num ); end;
      back_params.event_drag      = function () private.ReviewBackDrag( current_num ); end;
      back_params.event_dragdrop  = function () private.ReviewBackDrop( current_num ); end;

      ObjCreate( back_object, "spr" );
      ObjSet( back_object, back_params );
      ObjAttach( back_object, "obj_cheater_review_field" );
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
      local text_object = "ted_cheater_review_field_text_"..private.review_mark_count;
      local text_params = private.default.review_field_text;

      text_params.pos_x = 150 + 36 + mark_params.pos_x;
      text_params.pos_y = mark_params.pos_y;

      if ( mark_params.pos_x > 512 ) then

        text_params.pos_x = - 150 - 36 + mark_params.pos_x;

      end;

      ObjCreate( text_object, "textedit" );
      ObjSet( text_object, text_params );
      ObjAttach( text_object, "obj_cheater_review_field" );
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
      local link_object = "grd_cheater_review_field_link_"..private.review_mark_count;
      local link_params = private.default.review_field_link; 

      ObjCreate( link_object, "grid" );
      ObjSet( link_object, link_params );
      ObjAttach( link_object, "obj_cheater_review_field" );

      private.ReviewLinkUpdatePos( private.review_mark_count );
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
      private.review_text_editing = true;

      local timer_object = "tmr_cheater_review_field_text_"..private.review_mark_count;

      ObjCreate( timer_object, "timer" );
      ObjAttach( timer_object, "obj_cheater_review_field" );
      ObjSet( timer_object, { time = 0.01, endtrig = private.ReviewBackUpdate, playing = true } );
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

    end;

  end;
  --******************************************************************************************
  function private.ReviewBackUpdate()

    if ( private.review_text_editing ) then

      local text_object = "ted_cheater_review_field_text_"..private.review_mark_count;
      local text_params = ObjGet( text_object );

      local back_object = "spr_cheater_review_field_back_"..private.review_mark_count;
      ObjSet( back_object, { scale_y = ( text_params.draw_height / 64 ) } );

      local timer_object = "tmr_cheater_review_field_text_"..private.review_mark_count;
      ObjSet( timer_object, { time = 0.01, endtring = private.ReviewBackUpdate, playing = true } );

    end;

  end;
  --******************************************************************************************
  function private.ReviewTextEditingDone()
    
    if not private.review_text_editing then

      --КОСТЫЛЬ для работы консоли
      local txt = ObjGet( "ted_cheater_execute" ).text
      ObjSet( "ted_cheater_execute", { event_startdrag = txt } ) 
      local func = ObjGet( "ted_cheater_execute" ).event_startdrag;
      if func then
        func();
      else
        ld.LogTrace( "ERROR console can't execute '"..txt.."'" )
      end;

    else

      private.review_text_editing = false;

      local timer_object = "tmr_cheater_review_field_text_"..private.review_mark_count;
      ObjDelete( timer_object );

      local text_object = "ted_cheater_review_field_text_"..private.review_mark_count;
      local text_params = common.GetObjParamsForSet( text_object );
      ObjDelete( text_object );

      local mark_object = "spr_cheater_review_field_mark_"..private.review_mark_count;
      local back_object = "spr_cheater_review_field_back_"..private.review_mark_count;
      local link_object = "grd_cheater_review_field_link_"..private.review_mark_count;

      if ( text_params.text == "" ) then

        ObjDelete( mark_object );
        ObjDelete( back_object );
        ObjDelete( link_object );

      else

        local mark_params = ObjGet( mark_object );
        
        ObjAnimate( mark_object, "color_rgb", 0, 0, "",
        {
          0.0, 3, mark_params.color_r, mark_params.color_g, mark_params.color_b,
          0.3, 3, 1, 0, 0
        } );

        ObjSet( mark_object, { input = true } );
        ObjSet( back_object, { input = true } );

        -- Создание нового.
        text_object = "txt_cheater_review_field_text_"..private.review_mark_count;
        ObjCreate( text_object, "text" );
        text_params.input = false;
        ObjSet( text_object, text_params );
        ObjAttach( text_object, "obj_cheater_review_field" );

      end;

    end

  end;
  --******************************************************************************************
  function private.ReviewMarkDragStart( id )

    SetCursor( CURSOR_NULL );

    private.review_mark_dragged = id;

  end;
  --******************************************************************************************
  function private.ReviewMarkDrag( id )

    local cur_pos = GetGameCursorPos();

    local new_x = cur_pos[ 1 ];
    local new_y = cur_pos[ 2 ];

    local mark_object = "spr_cheater_review_field_mark_"..id;

    ObjSet( mark_object, { pos_x = new_x, pos_y = new_y } );

    private.ReviewLinkUpdatePos( id );

  end;
  --******************************************************************************************
  function private.ReviewMarkDrop( id )

    SetCursor( CURSOR_DEFAULT );

    private.review_mark_dragged = nil;

  end;
  --******************************************************************************************
  function private.ReviewBackDragStart( id )

    SetCursor( CURSOR_NULL );

  end;
  --******************************************************************************************
  function private.ReviewBackDrag( id )

    local cur_pos = GetGameCursorPos();

    local new_x = cur_pos[ 1 ];
    local new_y = cur_pos[ 2 ];

    local back_object = "spr_cheater_review_field_back_"..id;
    local text_object = "txt_cheater_review_field_text_"..id;

    ObjSet( back_object, { pos_x = new_x, pos_y = new_y } );
    ObjSet( text_object, { pos_x = new_x, pos_y = new_y } );

    private.ReviewLinkUpdatePos( id );

  end;
  --******************************************************************************************
  function private.ReviewBackDrop( id )

    SetCursor( CURSOR_DEFAULT );

  end;
  --******************************************************************************************
  function private.ReviewLinkUpdatePos( id )

    local mark_object = "spr_cheater_review_field_mark_"..id;
    local mark_params = ObjGet( mark_object );

    local back_object = "spr_cheater_review_field_back_"..id;
    local back_params = ObjGet( back_object );

    local angle = math.atan( ( back_params.pos_y - mark_params.pos_y ), ( back_params.pos_x - mark_params.pos_x ) );

    -- Право.
    if     ( angle >= - 0.785 ) and ( angle <   0.785 ) then

      mark_params.pos_x = mark_params.pos_x + 0.5 * 64 * mark_params.scale_x;

      back_params.pos_x = back_params.pos_x - 150;

    -- Верх.
    elseif ( angle >= - 2.355 ) and ( angle < - 0.785 ) then

      mark_params.pos_y = mark_params.pos_y - 0.5 * 64 * mark_params.scale_y;

      back_params.pos_y = back_params.pos_y + 0.5 * 64 * back_params.scale_y;

    -- Низ.
    elseif ( angle >=   0.785 ) and ( angle <   2.355 ) then

      mark_params.pos_y = mark_params.pos_y + 0.5 * 64 * mark_params.scale_y;

      back_params.pos_y = back_params.pos_y - 0.5 * 64 * back_params.scale_y;

    -- Лево.
    elseif ( ( angle >=   2.355 ) and ( angle <   3.142 ) )
    or     ( ( angle >= - 3.142 ) and ( angle < - 2.355 ) ) then

      mark_params.pos_x = mark_params.pos_x - 0.5 * 64 * mark_params.scale_x;

      back_params.pos_x = back_params.pos_x + 150;

    end;

    angle = math.atan( ( back_params.pos_y - mark_params.pos_y ), ( back_params.pos_x - mark_params.pos_x ) );

    -- Половина высоты ресурса линка.
    local radius = 9;

    local point0 = { pos_x = mark_params.pos_x + radius * math.cos( - 1.57 + angle ),
                     pos_y = mark_params.pos_y + radius * math.sin( - 1.57 + angle ) };

    local point2 = { pos_x = mark_params.pos_x + radius * math.cos(   1.57 + angle ),
                     pos_y = mark_params.pos_y + radius * math.sin(   1.57 + angle ) };

    local point1 = { pos_x = back_params.pos_x + radius * math.cos( - 1.57 + angle ),
                     pos_y = back_params.pos_y + radius * math.sin( - 1.57 + angle ) };

    local point3 = { pos_x = back_params.pos_x + radius * math.cos(   1.57 + angle ),
                     pos_y = back_params.pos_y + radius * math.sin(   1.57 + angle ) };

    local link_object = "grd_cheater_review_field_link_"..id;
    GridSet( link_object, 0,
    {
      0, point0,
      2, point2,
      1, point1,
      3, point3,
    } );

  end;
  --******************************************************************************************
  function private.ReviewMarkUp()

    if ( private.review_mark_dragged ) then

      local mark_object = "spr_cheater_review_field_mark_"..private.review_mark_dragged;
      local mark_params = ObjGet( mark_object );

      local scale_new = mark_params.scale_x + 0.1;

      ObjSet( mark_object, { scale_x = scale_new, scale_y = scale_new } );

    end;

  end;
  --******************************************************************************************
  function private.ReviewMarkDown()

    if ( private.review_mark_dragged ) then

      local mark_object = "spr_cheater_review_field_mark_"..private.review_mark_dragged;
      local mark_params = ObjGet( mark_object );

      local scale_new = mark_params.scale_x - 0.1;

      ObjSet( mark_object, { scale_x = scale_new, scale_y = scale_new } );

    end;

  end;
  --******************************************************************************************
  function private.ReleaseReview()  

    MsgUnsubscribe( Event_Level_ScreenshotSaved, private.ReleaseReview );
    private.reviewmode_enabled = false;
    ObjDetach( "txt_cheater_review_field" );
    ObjDelete( "obj_cheater_review_field" );
    ObjSet( "ng_level", { active = true } );
    private.text_editing = false;

end;
--******************************************************************************************
-- function *** OTHER *** () end;
--******************************************************************************************
  function private.ShowFPS( playing_value )

    ObjSet( "txt_cheater_current_fps", { text = string.format( "fps: %.1f; draws: %d;", GetFPS(), ne.GetNumDrawCalls() ) } );
    ObjSet( "tmr_cheater_fps",     { playing = playing_value, time = 0.2, endtrig = function () private.ShowFPS( playing_value ); end } );

  end;
  --******************************************************************************************
  function private.HandleAltF1()

    private.onScreen = not private.onScreen;
    ObjSet("cheater",{ visible = private.onScreen, active = private.onScreen, input = private.onScreen } );

  end;
  --******************************************************************************************
  function private.WideScreenUpdate()

    --interface.WideScreenUpdate( "cheater" );

  end;
--******************************************************************************************
  private.FastTravelGridList = {}
  private.FastTravelRoot = "cheater_fasttravel_content"
  private.FastTravelAttachTo = "ng_application"
  private.FastTravelAttached = false

  private.test_room_names = {"rm_entrypoint"};

  function private.SetFastTravelGrid()
    if game and not ld.TableEquals( private.FastTravelGridList, game.room_names ) then
    --if game and not ld.TableEquals( private.FastTravelGridList, private.test_room_names ) then --

      local room_color = { ho = { color_b = 0.60, color_g = 1.00 }, 
                           mg = { color_b = 1.00, color_g = 0.75 }, 
                           rm = { color_b = 0.50, color_g = 0.50 }  };

      for i,o in ipairs(ObjGetRelations( private.FastTravelRoot ).childs) do
        ObjDelete(o)
      end
      ld.CopyObj("cheater_fasttravel_back", "cheater_fasttravel_back_current", "spr", private.FastTravelRoot)

      private.FastTravelGridList = ld.TableCopy( game.room_names )
      --private.FastTravelGridList = ld.TableCopy( private.test_room_names ) --
      local tempSort = {}
      local sortOrder = {"rm_", "mg_", "ho_"}
      for i,o in ipairs(sortOrder) do
        for j,k in ipairs( private.FastTravelGridList ) do
          if k:find("^"..o) then
            table.insert(tempSort,k)
          end
        end
      end
      private.FastTravelGridList = {}
      private.FastTravelGridList = ld.TableCopy(tempSort)

      for i,o in ipairs( private.FastTravelGridList ) do
        local example = "cheater_fasttravel_example"
        local newRoom = "cheater_fasttravel_room_"..o
        local newRoomText = "cheater_fasttravel_txt_"..o
        ld.CopyObj(example, newRoom, "spr", private.FastTravelRoot)
        ld.CopyObj("cheater_fasttravel_txt", newRoomText, "text", private.FastTravelRoot)

        ObjSet( newRoom, { visible = 1, input = 1 } );
        local prg = private.GetCurrentProgress()
        local prgString = "level"..(prg == "std" and "" or prg)
        local newRes = "assets/levels/"..prgString.."/"..o.."/miniback"
        ObjSet( newRoom, { res = newRes } );
        ObjSet( newRoom, { 
          event_mdown = function() cmn.GotoRoom( o ); private.SwtchFastTravelGrid()  end;
          event_menter = function() SetCursor(CURSOR_HAND) end;
          event_mleave = function() SetCursor(CURSOR_DEFAULT) end;
        } );

        ObjSet( newRoomText, {text = ld.StringDivide(o)[2]} );
        for j,k in pairs(room_color) do
          if o:find("^"..j.."_") then
            ObjSet( newRoomText, {fontcolor_g = k.color_g, fontcolor_b = k.color_b} );
            break
          end
        end
      end
        

      local xMax = 3
      local yMax = 3
      local sxMax = 3
      local syMax = 3
      local elems = #private.FastTravelGridList

      local function mul() 
        return xMax*yMax
      end

      while mul() < elems do
        xMax = xMax + 1
        yMax = yMax + 1
      end

      local gridArr = {}
      local count = 1
      local string = {}
      for i = 1,yMax do
        gridArr[i] = {}
        for j = 1,xMax do
          if count <= elems then
            gridArr[i][j] = private.FastTravelGridList[count]
            count = count + 1
          end
        end
      end
      private.FastTravelGridArray = gridArr

      local scaleMul = 1--0.625 new format interface     
      local sx = scaleMul * sxMax/xMax
      local sy = scaleMul * syMax/yMax
      
      local xSize = 512 * sx
      local ySize = 288 * sy
      local xAxis = 1024
      local yAxis = 768
      local yOffs = 30
      local xDif = math.floor((xAxis - #gridArr[1]*xSize)/(#gridArr[1]+1))
      local yDif = math.floor((yAxis - #gridArr*ySize - 2*yOffs)/(#gridArr+1))
      for i,o in ipairs(gridArr) do
        for j,k in ipairs(o) do
          local obj = "cheater_fasttravel_room_"..k
          local text = "cheater_fasttravel_txt_"..k
          ObjSet( obj, { pos_x = (j-1)*xSize+ j*xDif + xSize/2, pos_y = (i-1)*ySize + i*yDif + ySize/2 + yOffs } );
          ObjSet( obj, { 
            scale_x = sx;
            scale_y = sy;
            event_menter = function() 
              SetCursor(CURSOR_HAND)
              local o = ObjGet( obj )
              ObjAnimate( o.name, 6,0,0, nil, { 0,0,o.scale_x,o.scale_y, 0.3,2,sx*1.075,sy*1.075 } )
            end;
            event_mleave = function()
              SetCursor(CURSOR_DEFAULT);
              local o = ObjGet( obj )
              ObjAnimate( o.name, 6,0,0, nil, { 0,0,o.scale_x,o.scale_y, 0.3,3,sx,sy } )
            end;
          } );
          ObjSet( text, { pos_x = (j-1)*xSize+ j*xDif + xSize/2, pos_y = (i-1)*ySize + i*yDif + ySize/2 + yOffs + ySize/2 - 10 } );
        end
      end

    end

    private.SwtchFastTravelGrid()

  end;

  function private.AnimFastTravelGrid( bool, func_end )
    local o
    local way = bool and 1 or -1;
    local h = 800 * way
    local y_beg
    local y_end
    local t = 0
    local ts = 0.015
    local ta = 0.3
    ObjSet( "cheater_fasttravel_back_current", { alp = bool and 0 or 0.6 } )
    for y, j in ipairs( private.FastTravelGridArray ) do
      for x, k in ipairs( j ) do
        o = ObjGet( "cheater_fasttravel_room_"..k )
        y_beg = bool and ( o.pos_y + h ) or ( o.pos_y )
        y_end = bool and ( o.pos_y ) or ( o.pos_y + h )
        ObjSet( o.name, { 
          pos_y = y_beg;
        } )
        ObjAnimate( o.name, 1,0,0, nil, { 
          0, 0, y_beg;
          t, 0, y_beg;
          t + ta, 3, y_end;
        } )
        o = ObjGet( "cheater_fasttravel_txt_"..k )
        y_beg = bool and ( o.pos_y + h ) or ( o.pos_y )
        y_end = bool and ( o.pos_y ) or ( o.pos_y + h )
        ObjSet( o.name, { 
          pos_y = o.pos_y + h;
        } )
        ObjAnimate( o.name, 1,0,0, nil, { 
          0, 0, y_beg;
          t, 0, y_beg;
          t + ta, 3, y_end;
        } )
        t = t + ts
      end
    end
    ld.Anim.Light( "cheater_fasttravel_back_current", bool, 0.6, t + ta, func_end )
  end


  function private.WidescreenUpdateFastTravel()
    ObjSet( private.FastTravelRoot, {pos_x = 0}  );
  end

  function private.SwtchFastTravelGrid()
    
    if private.FastTravelAttached then
      --ld.LockCustom( "cheater_fast_travel_grid",1 )
      --private.AnimFastTravelGrid( false, function() 
      --  ld.LockCustom( "cheater_fast_travel_grid",0 )
        --ObjDetach( private.FastTravelRoot )
        ObjSet( private.FastTravelRoot, {active = 0, input = 0, visible = 0} );
      --end )
      --table.insert(private.test_room_names,"rm_entrypoint"..#private.test_room_names) --
    else
      private.WidescreenUpdateFastTravel()
      if ObjGetRelations( private.FastTravelRoot ).parent ~= private.FastTravelAttachTo then
        ObjAttach( private.FastTravelRoot, private.FastTravelAttachTo )
      end
      ObjSet( private.FastTravelRoot, {active = 1, input = 1, visible = 1} );
      --ld.LockCustom( "cheater_fast_travel_grid",1 )
      --private.AnimFastTravelGrid( true, function() 
      --  ld.LockCustom( "cheater_fast_travel_grid",0 )
      --end )
    end
    private.FastTravelAttached = not private.FastTravelAttached
  end
--******************************************************************************************
  private.SetInventoryGridInit = false
  private.InventoryRoot = "cheater_inventory_content"
  private.InventoryMoove = "cheater_inventory_content_moved"
  private.InventoryExample = "cheater_inventory_example"
  private.InventoryExampleText = "cheater_inventory_example_text"
  private.InventoryAttachTo = "ng_application"
  private.InventoryGeneratedName = "cheater_inventory_item_"
  private.InventoryBacks = false
  private.InventorySmooth = false
  private.InventoryCount = 0
  private.InventoryPos = {}
  function private.UpdateBacksInventoryGrid()
    local colors = {0.5, 1}
    local visible = {0, 1}
    local idx = private.InventoryBacks and 2 or 1
    ObjSet( "cheater_inventory_content_back", {color_r = colors[idx], color_g = colors[idx], color_b = colors[idx]} );
    for i = 1, private.InventoryCount do
      ObjSet( private.InventoryGeneratedName..i.."_back", {visible = visible[idx]} );
    end
  end
  function private.UpdateSmoothInventoryGrid()
    local colors = {0.5, 1}
    local idx = private.InventorySmooth and 2 or 1
    ObjSet( "cheater_inventory_content_smooth", {color_r = colors[idx], color_g = colors[idx], color_b = colors[idx]} );
  end
  function private.SwitchBacksInventoryGrid()
    private.InventoryBacks = not private.InventoryBacks
    private.UpdateBacksInventoryGrid()
  end
  function private.SwitchSmoothInventoryGrid()
    private.InventorySmooth = not private.InventorySmooth
    private.UpdateSmoothInventoryGrid()
  end

  function private.SetInventoryGrid()

    if not private.SetInventoryGridInit then
      private.SetInventoryGridInit = true
      local prg = private.GetCurrentProgress()
      local hubs = {std = "level_inv_hub", ext = "levelext_inv_hub"}
      local hub = hubs[prg]
      local name = private.InventoryGeneratedName
      local rowCount = 12
      
      local function switchStates(name, mainname)
        if not game then return end;
        local progress = private.GetGlobalProgress();
        local progress_names = private.GetProgressNames()
        if public.InsertFastExecuter then
          public.InsertFastExecuter = false;
          --ОТМЕНА прогресса, до первого необходимого для текущей локации
          for i = 1, #progress_names - 1 do

            if not string.find(progress_names[ i ],"^tutorial_") 
              and progress[ progress_names[ i ] ]
              --and progress[ progress_names[ i + 1 ] ].done == 1
              and private.HINT_ROOT[ progress_names[ i ] ]
            then
              if progress_names[ i ] == mainname:gsub("^inv_","get_") then
                local progress = private.GetGlobalProgress();
                local progress_names = private.GetProgressNames();
                for i = 1, i do
                  if ( progress[ progress_names[ i ] ].done == 0 ) then
                    progress[ progress_names[ i ] ].done = 1;
                    progress[ progress_names[ i ] ].start = 1;
                    --progress[ progress_names[ i ] ].state = nil;
                  end;
                end;
                for i = i+1, #progress_names do
                  if ( progress[ progress_names[ i ] ].done == 1 ) then
                    progress[ progress_names[ i ] ].done = 0;
                    progress[ progress_names[ i ] ].start = 0;
                    progress[ progress_names[ i ] ].state = nil;
                  end;
                end;

              if private.GetCurrentProgress() == "std" then
                common.LevelSwitch( "level" );
              elseif private.GetCurrentProgress() == "ext" then
                common.LevelSwitch( "levelext" );
              end
              private.SetInventoryGrid()
              break;

              end;
            end
          end;

        else

          local objs = {}
          local i = 1

          while ObjGet(name.."_"..i) do
            table.insert(objs,name.."_"..i)
            i = i + 1
          end
          if #objs > 0 then
            local visibleCount = 0
            local lastVisible = 0
            for i,o in ipairs(objs) do
              if ObjGet(o).visible then
                visibleCount = visibleCount + 1
                lastVisible = i
              end
            end
            local nextIdx = lastVisible%#objs + 1
            --if visibleCount == #objs then
            --  
            --end

            for i,o in ipairs(objs) do
              ObjSet( o, {visible = i == nextIdx or (visibleCount < #objs and nextIdx == 1) and 1 or 0} );
            end
            --if visibleCount < #objs and nextIdx == 1 then
            --  for i,o in ipairs(objs) do
            --    ObjSet( o, {visible = 1} );
            --  end
            --end        

          end

        end
      end      

      if hub then
        local addPopUse = {}
        for _,x in pairs(common_impl.hint) do
          if x.type == "use" then
            addPopUse[x.inv_obj] = (addPopUse[x.inv_obj] or "")..string.format("\n use at \n%s\n%s",x.room or "-no rm-", x.zz or "-no zz-")
          end
        end
        for i,o in ipairs(ObjGetRelations( hub ).childs) do
          private.InventoryCount = i
          local toname = name..i
          local insideChilds = ObjGetRelations( o ).childs

          ObjCreate(toname,"obj")
          ObjAttach(toname,private.InventoryMoove)
          local row = math.modf((i-1)/rowCount)
          local col = (i-1)%rowCount
          private.InventoryPos[ i ] = { pos_x = - 70 + 100 * col; pos_y = 50 + 100 * row; scale_x = 1; scale_y = 1; }
          ObjSet( toname, private.InventoryPos[ i ] );
          ObjSet( toname, {
            input = 1;
            inputrect_init = 1;
            inputrect_x = -50;
            inputrect_y = -50;
            inputrect_w = 100;
            inputrect_h = 100;
            event_mdown = function() switchStates(toname,o) end;
            event_menter = function() SetCursor(CURSOR_HAND) ObjSet( toname, {pos_z = 1} ); ld.Anim.Light(toname.."_text",true,1,0.2) end;
            event_mleave = function() SetCursor(CURSOR_DEFAULT) ObjSet( toname, {pos_z = 0} ); ld.Anim.Light(toname.."_text",false,1,0.2) end;
          } );        

          ld.CopyObj(private.InventoryExample, toname.."_back", "spr", toname)
          ld.CopyObj(private.InventoryExampleText, toname.."_text", "text", toname)

          if #insideChilds > 0 then
            for j,k in ipairs(insideChilds) do 
              --if j == 2 and i > 100 and i < 150 then --100 150
              if true then
                local child = k
                local prefix = ld.StringDivide(child)[1]
                if prefix == "inv" or prefix == "spr" and ObjGet(child).res ~= "" then
                  local type = "spr"
                  if ObjGet(child).text then type = "text" end
                  ld.CopyObj(child, toname.."_"..j, type, toname)
                  ObjSet( toname.."_"..j, {visible = 1, input = 0} );
                  --ld.LogTrace( "copied", child, toname.."_"..j );
                elseif prefix == "anm" then
                  ld.CopyObj(child, toname.."_"..j, "anim", toname)
                  ObjSet( toname.."_"..j, {visible = 1, input = 0, frame = 1} );
                elseif prefix == "fx" then
                  ld.CopyObj(child, toname.."_"..j, "anim", toname)
                  ObjSet( toname.."_"..j, {visible = 1, input = 0, frame = 1} );
                else
                  ld.LogTrace( "strange obj ", k );
                end
              end
            end
          else
            ld.CopyObj(o, toname.."_1", "video", toname)
            ObjSet( toname.."_1", {visible = 1, input = 0, playing = 0, looped = 1, pos_x = 0, pos_y = 0} );
            --ld.LogTrace( "video ", o );
          end

          local popup = o.." "..i.."\n"..(tostring(StringGet("pop_"..o)):gsub("(.*) assets.*","%1"))
          local findAt = ObjGet(o).res ~= "" and ObjGet(o).res or ObjGet(ObjGetRelations( o ).childs[1]).res
          findAt = findAt:gsub("assets.levels.level","")
          popup = string.format(popup.."\n%s %s", findAt, addPopUse[o] or "")          
          ObjSet( toname.."_text", {text = popup, align = col <= 1 and 0 or col >= rowCount-2 and 2 or 1 } );

        end
      end

      local function slide(v)
        local step = 20
        local time = 0.01
        if v == 0 then
          ObjStopAnimate(private.InventoryMoove,1)
        else
          local current = ObjGet(private.InventoryMoove).pos_y
          local next = current + v*step
          --ld.LockCustom("cheater_inventory_lock",1)
          ObjAnimate( private.InventoryMoove, 1, 0, 0, function() 
            --ld.LockCustom("cheater_inventory_lock",0)
            slide(v)
          end, {0,3,current, time,3,next} );
        end
      end

      ObjSet( "spr_cheater_inventory_content_up", {
        event_mdown = function() slide(1) end;
        event_mup = function() slide(0) end;
        event_menter = function() ld.ShCur(CURSOR_HAND) ObjSet( "cheater_inventory_content_up", {color_r = 1, color_g = 1, color_b = 1} ); end;
        event_mleave = function() ld.ShCur(CURSOR_DEFAULT) ObjSet( "cheater_inventory_content_up", {color_r = 0.5, color_g = 0.5, color_b = 0.5} ); end;
      } );
      ObjSet( "spr_cheater_inventory_content_down", {
        event_mdown = function() slide(-1) end;
        event_mup = function() slide(0) end;
        event_menter = function() ld.ShCur(CURSOR_HAND) ObjSet( "cheater_inventory_content_down", {color_r = 1, color_g = 1, color_b = 1} ); end;
        event_mleave = function() ld.ShCur(CURSOR_DEFAULT) ObjSet( "cheater_inventory_content_down", {color_r = 0.5, color_g = 0.5, color_b = 0.5} ); end;
      } );
      ObjSet( "spr_cheater_inventory_content_back", {
        event_mdown = function() private.SwitchBacksInventoryGrid() end;
        event_menter = function() ld.ShCur(CURSOR_HAND) end;
        event_mleave = function() ld.ShCur(CURSOR_DEFAULT) end;
      } );
      ObjSet( "spr_cheater_inventory_content_smooth", {
        event_mdown = function() private.SwitchSmoothInventoryGrid() end;
        event_menter = function() ld.ShCur(CURSOR_HAND) end;
        event_mleave = function() ld.ShCur(CURSOR_DEFAULT) end;
      } );
      private.UpdateBacksInventoryGrid()
      private.UpdateSmoothInventoryGrid()
    end
    
    local parent = ObjGetRelations( private.InventoryRoot ).parent
    if parent == private.InventoryAttachTo then
      ObjDetach( private.InventoryRoot )
    else
      private.InventoryGridAnimations() 
      ObjAttach( private.InventoryRoot, private.InventoryAttachTo )
    end

  end
    function private.InventoryGridAnimations() 
      local c = GetGameCursorPos()
      local o = ObjGet( private.InventoryMoove )
      c[ 1 ] = c[ 1 ] - o.pos_x;
      c[ 2 ] = c[ 2 ] - o.pos_y;
      local p
      local obj
      local w = 200;
      local sc_add = 0.5;
      local ang, gip
      local x, y, sc
      local pos
      local count = #private.InventoryPos
      local state = { pos_x = 0; pos_y = 0; scale_x = 0; scale_y = 0; }
      for i = 1, count do
        obj = private.InventoryGeneratedName..i
        pos = private.InventoryPos[ i ]
        ang, gip = ld.Math.AngGip( pos.pos_x, pos.pos_y, c[ 1 ], c[ 2 ] )
        --if gip > w then
        --  ObjSet( obj, pos )
        --else

          sc = 1 + sc_add * ( math.max( 0, ( w - gip ^ 1.05 ) ) / w )
          state.pos_x = pos.pos_x - math.cos( ang ) * ( gip ^ 0.5 )
          state.pos_y = pos.pos_y + math.sin( ang ) * ( gip ^ 0.5 )
          state.scale_x = sc;
          state.scale_y = sc;
          if not private.InventorySmooth then
            state = { pos_x = pos.pos_x; pos_y = pos.pos_y; scale_x = 1; scale_y = 1; }    
          end
          ObjSet( obj, state )
        --end
      end
      ObjAnimate( private.InventoryMoove, 7,0,0, private.InventoryGridAnimations, { 0,0,0, 0,0,0 } )
    end
--******************************************************************************************

--******************************************************************************************
-- function *** CHEBOXARY *** () end;
--******************************************************************************************
  function private.GetHelper()
    if not ld.CheckRequirements( {"get_helper"} ) then
      ng_global.progress[ prg.current ][ "get_helper" ].done = 1;
      common.LevelSwitch( "level" );  
    end
  end
  function private.DropHelper()
    if ld.CheckRequirements( {"get_helper"} ) then
      ng_global.progress[ prg.current ][ "get_helper" ].done = 0;
      common.LevelSwitch( "level" );  
    end
  end
-- function Bot() end;
  function private.BotInit()
    
    ModLoad("assets/shared/cheater/mod_botcontroller" );
    if botcontroller then
      botcontroller.BotInit()
    end

  end
  function private.BotTryStartStop()
    if botcontroller then
      botcontroller.BotTryStartStop()
    end
  end
--******************************************************************************************
function private.CheboxaryInit()
  if ne.GetTestMode() == 1 then
    ne.SetTestMode( 0 )
  end
  private.InGameDoneOrder = {}
  private.CheboxaryFuncs = {};
  private.CheboxaryFuncsPOPAP = {};
  ObjSet( "spr_cheater_but", { 
    pos_z = 999;
  } )
  ObjSet( "spr_cheater_but_back", { 
    input = 1;
    event_mdown = private.CheboxaryListShow;
    event_menter = function() ld.ShCur(CURSOR_HAND) end;
    event_mleave = function() ld.ShCur(CURSOR_DEFAULT) end;
  } )

  private.SoundhelperInit()

  --private.CheboxaryListAdd( "ShowAllObjectsWithFonts" )
  private.CheboxaryListAdd( "FPS_lower", "вкл/выкл жесточайшие тормоза)" )
  private.CheboxaryListAdd( "TimeWarp", "ускоритель времени" )
  private.CheboxaryListAdd( "ChangeFontForScreenObjs", "Меняет все тексты на экране на имя шрифта" )
  private.CheboxaryListAdd( "DisableFX_ALL", "выключает visible всех fx,pfx,gfx.grm.gho,gmg,gzz" )
  private.CheboxaryListAdd( "DisableFX_GFX_ONLY", "выключает visible gfx,grm,gho,gmg,gzz" )
  private.CheboxaryListAdd( "Show_count_ho_without_hint", "показать счетчик" )
  private.CheboxaryListAdd( "Show_count_mg_without_skip", "показать счетчик" )
  private.CheboxaryListAdd( "Show_Global_Vars", "вывод переменных из массиве _G" )
  private.CheboxaryListAdd( "Show_SmartHint", "вывод переменных связанных с смартхинт" )
  private.CheboxaryListAdd( "Get_all_puzzles", "взять все пазлы" )
  private.CheboxaryListAdd( "Get_all_collectibles", "взять все коллектиблсы" )
  private.CheboxaryListAdd( "GoToPuzzleRoom", "перейти в комнату с паззлами(CS6)" )
  private.CheboxaryListAdd( "GoToCollectiblesRoom", "перейти в комнату c коллектиблс(CS6)" )
  private.CheboxaryListAdd( "GoToAchivementRoom", "перейти в комнату с ачивками(CS6)" )
  private.CheboxaryListAdd( "ShowCollecttiblesListInRoom", "показывает список колектаблзов для локации и зз в ней" )
  private.CheboxaryListAdd( "ShowMgsListInLevel", "показывает список мг/ммг с указанием комнаты" )

end;
--******************************************************************************************
function private.CheboxaryListAdd( name, opisanie )
  table.insert( private.CheboxaryFuncs, { name, opisanie } )
    local obj = "spr_cheater_but_cheboxary_"..name
    ObjCreate( obj, "obj" )
    ObjSet( obj, { 
      visible = 0;
      input = 0;
      event_mdown = function() private[name]() end;
      event_menter = function() ld.ShCur(CURSOR_HAND) ObjSet( "txt_"..obj, { fontcolor_r = 1; fontcolor_g = 0; fontcolor_b = 1; } ) end;
      event_mleave = function() ld.ShCur(CURSOR_DEFAULT) ObjSet( "txt_"..obj, { fontcolor_r = 1; fontcolor_g = 1; fontcolor_b = 1; } ) end;
      scale_x = 1;
      scale_y = 1;
      attachtype = 2;
      inputrect_init = 1;
      inputrect_x = 0;
      inputrect_y = - ObjGet( "spr_cheater_but_back" ).draw_height / 2 * ObjGet( "spr_cheater_but_back" ).scale_y;
      --inputrect_w = 350* ObjGet( "spr_cheater_but_back" ).scale_x;
      inputrect_h = ObjGet( "spr_cheater_but_back" ).draw_height* ObjGet( "spr_cheater_but_back" ).scale_y;
      pos_x = - ObjGet( "spr_cheater_but_back" ).draw_width * ObjGet( "spr_cheater_but_back" ).scale_x + 30;
      pos_y = ObjGet( "spr_cheater_but_back" ).draw_height * ( #private.CheboxaryFuncs - 0.5 ) * ObjGet( "spr_cheater_but_back" ).scale_y + 10
    } )
    ObjAttach( obj, "spr_cheater_but" )

    ObjCreate( "txt_"..obj, "text" )
    ObjSet( "txt_"..obj, { 
      res = "assets/shared/cheater/arial", 
      align = 0, input = 0, 
      text = #private.CheboxaryFuncs..") "..name..(opisanie and " >> "..opisanie or "" ) } )
    ObjAttach( "txt_"..obj, obj )

    ObjCreate( "spr_back_"..obj, "spr" )
    ObjSet( "spr_back_"..obj, { 
      res = "assets/shared/cheater/editor_back";
      input = 0;
      pos_z = -1;
      --atachtype = 2;
      pos_x = ObjGet( "txt_"..obj ).draw_width / 2;
      scale_x = ObjGet( "txt_"..obj ).draw_width / 2;
      scale_y = ObjGet( "txt_"..obj ).draw_height * 0.32;
      color_r = 0;
      color_g = 0;
      color_b = 0;
    } )
    ObjAttach( "spr_back_"..obj, obj )

  local optionSize = ObjGet( "spr_back_"..obj ).scale_x
    ObjSet( obj, { 
      inputrect_w = optionSize*2;
    })
end
--******************************************************************************************
function private.CheboxaryListShow()
  for i = 1, #private.CheboxaryFuncs do
    local v = not ObjGet( "spr_cheater_but_cheboxary_"..private.CheboxaryFuncs[i][1] ).visible
    ObjSet( "spr_cheater_but_cheboxary_"..private.CheboxaryFuncs[i][1], { input = v, visible = v } )
  end
end;
--******************************************************************************************
function public.AddInGameDoneOrder( event )
  table.insert( private.InGameDoneOrder, event )
end
--******************************************************************************************
function private.SoundhelperInit()

  cmn.AddSubscriber( "ldAnimPlay_end", function()
    local o = ObjGet( ld.LastAnimPlayed[1].anim )
    if o then
      private.SoundHelperShow( "AnimPlay", ld.LastAnimPlayed[1].animfunc.." > "..(math.ceil((o.frame/60)*100)/100) )
    end;   
  end );

  function private.SoundHelperAdd( name, len )
    len = len or 1
    private.SoundHelperList = private.SoundHelperList or {}
    private.SoundHelperLen = private.SoundHelperLen or {}
    private.SoundHelperLen[ name ] = len

    local h = 20;
    local dy = h;
    for i = 1, #private.SoundHelperList do
      dy = dy + h * private.SoundHelperLen[ private.SoundHelperList[ i ] ] + h * 1.5
    end

    table.insert( private.SoundHelperList, name )
    private.SoundHelperNum = private.SoundHelperNum or {}
    private.SoundHelperNum[ name ] = #private.SoundHelperList;

      local txt = "txt_cheater_soundhelper_"..name.."_"..#private.SoundHelperList.."_0"
      ObjCreate( txt, "text" )
      ObjSet( txt, { 
        res = "assets/shared/cheater/arial", 
        align = 0, 
        input = 0, 
        fontsize = 15;
        text = name,
        pos_x = 0;
        pos_y = dy;
      } )
      ObjAttach( txt, "obj_cheater_soundhelper" )
    for i = 1, len do
      local txt = "txt_cheater_soundhelper_"..name.."_"..#private.SoundHelperList.."_"..i
      ObjCreate( txt, "text" )
      ObjSet( txt, { 
        res = "assets/shared/cheater/arial", 
        align = 0, 
        input = 0, 
        fontsize = 15;
        text = #private.SoundHelperList.."_"..i,
        pos_x = 0;
        pos_y = dy + i * h;
      } )
      ObjAttach( txt, "obj_cheater_soundhelper" )
    end

  end
  --private.SoundHelperAdd( "111", 1 )
  --private.SoundHelperAdd( "222", 2 )
  private.SoundHelperAdd( "AnimPlay", 5 )
  private.SoundHelperAdd( "ActionsDone", 5 )
  private.SoundHelperAdd( "UsePlace", 1 )


--cmn.AddSubscriber( "opn_cabinet", opn_cabinet_logic )
  for k, v in pairs( private.HINT_ROOT ) do
    cmn.AddSubscriber( k.."_end", function() private.SoundHelperShow( "ActionsDone", k ) end )
  end

  function public.BbtPrg( prg )
    private.SoundHelperShow( "UsePlace", prg )
  end

  function private.SoundHelperShow( name, text )
    local o
    for i = private.SoundHelperLen[ name ], 2, -1 do
      o = ObjGet( "txt_cheater_soundhelper_"..name.."_"..private.SoundHelperNum[ name ].."_"..( i - 1 ) )
      ObjSet( "txt_cheater_soundhelper_"..name.."_"..private.SoundHelperNum[ name ].."_"..( i ), { 
        text = o.text;
    } )
    end
    ObjSet( "txt_cheater_soundhelper_"..name.."_"..private.SoundHelperNum[ name ].."_1", { 
      text = text;
    } )
  end

end;
--******************************************************************************************
function private.ShowAllObjectsWithFonts( obj )
  
  if not obj then
    ld.LogTrace( ">>>> ShowAllObjectsWithFonts" )
    private.ShowAllObjectsWithFonts( "ne_origin" )
    private.ShowAllObjectsWithFonts( "ne_storage" )
    ld.LogTrace( "<<<< ShowAllObjectsWithFonts" )
  else
    local o = ObjGet( obj )
    
    if o then
      if o.res:find("^assets\\fonts") or o.res:find("^assets/fonts") then
        ld.LogTrace( "\t\t"..o.name.."\t\t"..o.res )
      end;
      local childs = ObjGetRelations( o.name ).childs
      for i = 1, #childs do
        if obj == childs[i] then
          ld.LogTrace( "ERROR: PARRENT IN CHILD!!!" )
        else
          private.ShowAllObjectsWithFonts( childs[i] )
        end
      end
    else
      ld.LogTrace( "ERROR: obj not finded >> "..obj )
    end
  end
end;
--******************************************************************************************
function private.ChangeFontForScreenObjs( obj )
  if not obj then
    if private.ChangeFontForScreenObjs_changed then
      ld.LogTrace( ">>>> ChangeFontForScreenObjs >>>> RETURN FONTS AND VALUES" )
      for k, v in pairs( private.ChangeFontForScreenObjs_changed ) do
        ObjSet( k, v )
      end
      private.ChangeFontForScreenObjs_changed = false
      return
    end
    ld.LogTrace( ">>>> ChangeFontForScreenObjs" )
    private.ChangeFontForScreenObjs_changed = {}
    private.ChangeFontForScreenObjs( "ng_level" )
    ld.LogTrace( "<<<< ChangeFontForScreenObjs" )
  else
    local o = ObjGet( obj )
    if o then
      if o.res:find("^assets\\fonts") or o.res:find("^assets/fonts") then
        --ld.LogTrace( "\t\t"..o.name.."\t\t"..o.res )
        private.ChangeFontForScreenObjs_changed[ o.name ] = { text = o.text; disprawtext = o.disprawtext; }
        ObjSet( o.name, { text = "["..o.res:gsub("^assets\\fonts\\",""):gsub("^assets/fonts/",""):upper().."]", disprawtext = true } )
      end;
      local childs = ObjGetRelations( o.name ).childs
      for i = 1, #childs do
        if obj == childs[i] then
          ld.LogTrace( "ERROR: PARRENT IN CHILD!!!" )
        else
          private.ChangeFontForScreenObjs( childs[i] )
        end
      end
    else
      ld.LogTrace( "ERROR: obj not finded >> "..obj )
    end
  end
end
--******************************************************************************************
function private.DisableFX_ALL( obj, gfx_only )
  if not obj then
    ld.LogTrace( ">>>> DisableFX_ALL" )
    private.DisableFX_ALL( "ng_level", gfx_only )
    ld.LogTrace( "<<<< DisableFX_ALL" )
  else
    local o = ObjGet( obj )
    if o then
      if ( o.name:find("^fx_") and not gfx_only )
      or ( o.name:find("^pfx_") and not gfx_only ) 
      or o.name:find("^gfx_") 
      or o.name:find("^grm_") 
      or o.name:find("^gmg_") 
      or o.name:find("^gho_")
      or o.name:find("^gzz_")
      then
        --ld.LogTrace( "\t\t"..o.name.."\t\t"..o.res )
        ObjSet( o.name, { visible = 0 } )
      end;
      local childs = ObjGetRelations( o.name ).childs
      for i = 1, #childs do
        if obj == childs[i] then
          ld.LogTrace( "ERROR: PARRENT IN CHILD!!!" )
        else
          private.DisableFX_ALL( childs[i], gfx_only )
        end
      end
    else
      ld.LogTrace( "ERROR: obj not finded >> "..obj )
    end
  end
end
function private.DisableFX_GFX_ONLY()
  private.DisableFX_ALL( nil, true )
end
function public.show_ho_count(a) 
  if false then
    local value = tostring(ng_global.achievements.data and ng_global.achievements.data.ho_without_hint and ng_global.achievements.data.ho_without_hint.counter)
    local value2 = tostring(ng_global.achievements.data and ng_global.achievements.data.ho_without_hint and ng_global.achievements.data.ho_without_hint["counter_std"])
    local value3 = tostring(ng_global.achievements.data and ng_global.achievements.data.ho_without_hint and ng_global.achievements.data.ho_without_hint["counter_ext"])
    value = "ho wh:all "..value..",std "..value2..",ext "..value3
    ld.LogTrace( a, value );
  end
end

function private.Show_count_ho_without_hint () 
  local ach_name = "ho_without_hint"
  local value = ng_global.achievements["counter"][ ach_name ]
  local value1 = tostring(ng_global.achievements.data and ng_global.achievements.data.ho_without_hint and ng_global.achievements.data.ho_without_hint.counter)
  local value2 = ng_global.achievements["counter_std"][ ach_name ]
  local value3 = ng_global.achievements["counter_ext"][ ach_name ]
  value = "ho wh:all "..value.."."..value1..",std "..value2..",ext "..value3

  ObjDelete("txt_cheater_ho_count")
  ld.CopyObj("txt_cheater_text_for_copy", "txt_cheater_ho_count", "text")
  ObjSet( "txt_cheater_text_for_copy", {visible = 1, text = value });
  ObjAnimate( "txt_cheater_text_for_copy", 8, 0, 0, function() end, {0,0,0, 0.2,1,1, 3,0,1, 4,0,0} );
end
function private.Show_count_mg_without_skip () 
  local ach_name = "mg_without_skip"
  local value = ng_global.achievements["counter"][ ach_name ]
  local value1 = tostring(ng_global.achievements.data and ng_global.achievements.data.mg_without_skip and ng_global.achievements.data.mg_without_skip.counter)
  local value2 = ng_global.achievements["counter_std"][ ach_name ]
  local value3 = ng_global.achievements["counter_ext"][ ach_name ]

  value = "mg ws:all "..value.."."..value1..",std "..value2..",ext "..value3

  ObjDelete("txt_cheater_ho_count")
  ld.CopyObj("txt_cheater_text_for_copy", "txt_cheater_ho_count", "text")
  ObjSet( "txt_cheater_text_for_copy", {visible = 1, text = value });
  ObjAnimate( "txt_cheater_text_for_copy", 8, 0, 0, function() end, {0,0,0, 0.2,1,1, 3,0,1, 4,0,0} );
end
function private.FPS_lower()
  if private.FPS_lower_on then
    private.FPS_lower_on = false
  else
    private.FPS_lower_on = true
    local stacker = function()  end;
    stacker = function() 
      if not private.FPS_lower_on then return end;
      if not ObjGet( "tmr_FPS_lower" ) then
        for i = 1, 4999999 do
          local a = 1+1;
          local b = a+a;
          local c = a+b;
          local d = a+b+c;
          local e = a+b+c+d;
        end
        ld.StartTimer( "tmr_FPS_lower", 0, stacker )
      else

      end
    end
    stacker()
  end
end;
function private.Show_Global_Vars()
  local m = {}
  for k, v in pairs(_G ) do
    table.insert( m, k )
  end;
  table.sort( m )
  --for i = 1, #m do
    ld.LogTrace( m )
  --end
end
function private.Show_SmartHint()
  ld.LogTrace( "ld_impl.smart_hint", ld_impl.smart_hint )
  ld.LogTrace( "ld_impl.smart_hint_connections", ld_impl.smart_hint_connections )
end

function private.Get_all_collectibles()
  
  for i=1,#ng_global.achievements.miniature do
    ng_global.achievements.miniature[i] = true
  end
end

function private.Get_all_puzzles()
  for i=1,#ng_global.achievements.puzzle do
    ng_global.achievements.puzzle[i] = true
  end
end

function private.GoToPuzzleRoom()
  if cmn.is_inmenunow then
    cmn.GotoRoom( "rm_screensaver" );
  else
    common_impl.PanelNotification_Click( "puzzle" )
  end
end
function private.GoToCollectiblesRoom()
  if cmn.is_inmenunow then
    cmn.GotoRoom( "rm_collectibles" );
  else
    common_impl.PanelNotification_Click( "morphing" )
  end
end
function private.GoToAchivementRoom()
  if cmn.is_inmenunow then
    cmn.GotoRoom( "rm_achievements" );
  else
    common_impl.PanelNotification_Click( "achievement" )  --common.GotoRoom( "rm_clockroom" );
  end
end

function private.TimeWarp()
  if private.TimeWarp_count then
    ne.SetTestMode( 0 )
    private.TimeWarp_count = false
  else
    ne.SetTestMode( 1, 2.5 )
    private.TimeWarp_count = true
  end
end

function private.SmartScreenShot()
  if ld.IsLdCheater() then
    local zrm = interface.GetCurrentComplexInv()
    if zrm == "" then
      zrm = common.GetCurrentSubRoom() or common.GetCurrentRoom()
    end
    if _G[ zrm ] and _G[ zrm ].SmartScreenShotStep then
      _G[ zrm ].SmartScreenShotStep()
    end
    MsgSend( Event_Level_CheaterSaveScreenshot );
  end
end

function private.ShowCollecttiblesListInRoom()
  local hnts = {}

  local adder = function( hints, name, rm, zz )
    zz = zz or ""
    local count = 1
    while common_impl.hint[ name..count ] do
      if ( common_impl.hint[ name..count ].rm == rm or common_impl.hint[ name..count ].room == rm )
      and ( common_impl.hint[ name..count ].zz == zz )
      then
        if not ng_global.achievements[ name ][ count ] then
          table.insert( hints, { 
            name = name..count;
            room = common_impl.hint[ name..count ].rm or common_impl.hint[ name..count ].room;
            zz = common_impl.hint[ name..count ].zz;
          } )
        end
      end
      count = count + 1
    end
  end

  local rm = GetCurrentRoom()

  adder( hnts, "card", rm )
  adder( hnts, "puzzle", rm )
  --adder( hnts, "morphtrash", rm )

  local childs = ObjGetRelations( rm ).childs
  for i = 1, #childs do
    if childs[ i ]:find( "^anm_simplemorphcollect_" ) then
      
      table.insert( hnts, { 
        name = childs[ i ];
        room = rm;
      } ) 
    end
  end

  local zzs = ld_impl.SmartHint_GetZzListInRoom( rm )
  for i = 1, #zzs do
    adder( hnts, "card", rm, zzs[ i ] )
    adder( hnts, "puzzle", rm, zzs[ i ] )
  end

  local answer = "\nShowCollecttiblesListInRoom >>\n\n"
  for i = 1, #hnts do
    answer = answer..i.." >> ";
    answer = answer..hnts[ i ].room.." >> ";
    answer = answer..( hnts[ i ].zz and ( hnts[ i ].zz.." >> " ) or " >> " );
    answer = answer..hnts[ i ].name.." ";
    answer = answer.."\n"
  end

  ld.LogTrace( answer )

end

function private.ShowMgsListInLevel()  
  for i,o in ipairs(game.progress_names) do
    if o:find("^win_") then
      local h = common_impl.hint[o]
      if h and ((h.zz and not h.zz:find("^ho_")) or not h.zz) then
        ld.LogTrace( o, common_impl.hint[o].room, common_impl.hint[o].zz );
        ld.LogTrace( StringGet(o:gsub("^win_","ifo_")) );
        ld.LogTrace( "" );
      end
    end
  end
end
