-- name=level

function public.Start ( param )


  interface.WidgetAdd( InterfaceWidget_Pause, 1800 );
  interface.WidgetAdd( InterfaceWidget_BtnMenu, 8 );
  interface.WidgetAdd( InterfaceWidget_BtnHint, 11  );
  interface.WidgetAdd( InterfaceWidget_BtnSkip, 11 );
  interface.WidgetAdd( InterfaceWidget_BtnInfo, 9 );
  interface.WidgetAdd( InterfaceWidget_BtnReset, 10 );
  interface.WidgetAdd( InterfaceWidget_Inventory, 9 );
  interface.WidgetAdd( InterfaceWidget_TaskPanel, 9 );
  interface.WidgetAdd( InterfaceWidget_Effects );
  interface.WidgetAdd( InterfaceWidget_DialogHo,30 );

  interface.ButtonLockAdd();
  interface.LockAdd();

  interface.WidgetAdd( InterfaceWidget_FrameSubroom, 8 );
  interface.WidgetAdd( InterfaceWidget_ItemPanel,9 );
  interface.WidgetAdd( InterfaceWidget_Popup,17 );
  interface.WidgetAdd( InterfaceWidget_BlackBarText, 1500 );
  interface.WidgetAdd( InterfaceWidget_Dialog,30 );
  interface.WidgetAdd( InterfaceWidget_DialogVideo,30 );
  interface.WidgetAdd( InterfaceWidget_DialogStory,30 );
  interface.WidgetAdd( InterfaceWidget_DialogCharacter, 30 );
  interface.WidgetAdd( InterfaceWidget_Window );
  interface.WidgetAdd( InterfaceWidget_Tutorial,30 );
  interface.WidgetAdd( InterfaceWidget_Map, 16  );
  ObjSet( "obj_map_arrows", {input = 0, visible = 0} );
  interface.WidgetAdd( InterfaceWidget_BtnMap, 13 );

  interface.PanelNotificationAdd(10);

  if IsCollectorsEdition() then
    if false then -- temp for version (false for off guide)
      interface.WidgetAdd( InterfaceWidget_StrategyGuide,30 );
      interface.WidgetAdd( InterfaceWidget_BtnGuide, 12 );
    end
  end  

  interface.ComplexInvAdd( 8 )
  interface.DialogHintAdd(20);

  interface.PanelhopairAdd(9)

  interface.ButtonTaskAdd(20)
  interface.DialogTaskAdd(10)

  private.Init( param );

  ModLoad( "assets/levels/level/mod_level_inv" );
  level_inv.Init()

  private.TutorInit()--тутор

  interface.ArrPuzzles()

  common.LevelLoad( "level", "std", "rm_entrypoint", param );

  --interface.ArrPuzzlesHelper() -- Хэлпер для вывода комон импл для паззлов выключить если не надо 
  -- для interface.ArrPuzzles()

  interface.ArrInvPlus()  -- проверка состояния плюсика для деплойных инв предметов

  interface.KeyUpdate();

  ObjSet( "txt_int_dialog_character", {param0 = GetCurrentProfile()} );  --автоподствновка имени игрока в диалоги

  interface.CheckPuzzles()
  interface.CheckMorphing()

  ld.SetGHOMask() -- нужно для работы частиц по маске гейтов в хо
  --int_button_map_impl.Lock()
 
  --ld.LogMgNames() ALT+F1; 16 punct

  --private.ClearMemoryOrder()

end;

function public.CubeAdd() -- get_casket
  
  interface.CubeAdd( -999 )
  cmn.CallEventHandler( "LevelLoaded" )

end

function public.HelperAdd()
  
  interface.HelperAdd(14)
 -- int_helper.LoadAnotherPrg()
end

function public.HintAdd()

  --interface.WidgetSetVisible( InterfaceWidget_BtnHint, true );
  --interface.WidgetSetInput( InterfaceWidget_BtnHint, true );
  --interface.WidgetSetVisible( InterfaceWidget_StrategyGuide, true );
  --interface.WidgetSetVisible( InterfaceWidget_BtnGuide, true );
  if IsCollectorsEdition() then
    if false then -- temp for version (false for off guide)
      interface.WidgetAdd( InterfaceWidget_StrategyGuide,30 );
      interface.WidgetAdd( InterfaceWidget_BtnGuide, 12 );
    end
  end

  --if ld.CheckRequirements( {"clk_outro1"} ) and not ld.CheckRequirements( {"get_lockpart1"} ) then
  --  int_button_hint_impl.SetCustomHint(true)
  --  int_button_skip_impl.SetCustomSkip(true)
  --end     --second custom hint skip
end

function public.BtnMapAdd()
  interface.WidgetSetVisible( InterfaceWidget_BtnMap, true );
  --interface.WidgetSetInput( InterfaceWidget_BtnMap, true );  
end

function private.Init ( cheatLoad )

  game = {};
  game.room_names =
  {
     "rm_entrypoint"
    ,"rm_outro"


  };

  game.progress_names = 
  {
     "opn_entrypoint"

  };

game.relations = {};

--------------------------------------------------------------------------------
-- function TASKS () end;
--{ prg_true; prg_false; };
game.level_tasks = {
  ------ LEVEL 1 ---- 
  --{"dlg_entrypoint_nick1", ""};         --Find the Christmas symbol to question Nick.
  --{"clk_vidbanksy", ""};                --Learn how you can help Jonathan.
  --{"dlg_toystoreyard1_jonathan2", ""};  --Find the missing toys.
  --{"dlg_toystoreyard1_jonathan3", ""};  --Find the truck.
  --{"dlg_busstop1_driver1", ""};         --Help the driver repair the truck.
  --{"dlg_busstop1_driver2", ""};         --Find the box with toys.
  --{"get_box", "use_box"};               --Give Jonathan the found toys.
  ------------ LEVEL 2 ----
  --{"opn_townsquare2",  ""};             --Find out how you can help the fundraiser.
  --{"clk_vidnomoney",  ""};              --Offer Bob some other help.
  --{"dlg_townsquare2_bob2",  ""};        --Learn where you can sew a new santa costume.
  --{"clk_animstudiopath",  ""};          --Clear the way to Sewing Street and go to the tailor shop.
  --{"clk_animclosed",  ""};              --Fix the tailor shop door and get inside.
  --{"dlg_tailorshop2_tailor0",  ""};     --Ask the tailor how to get a costume for free.
  --{"dlg_tailorshop2_tailor1",  ""};     --Find fabric for a santa costume and give it to the tailor.
  --{"dlg_tailorshop2_tailor2",  ""};     --Take the costume to Bob.
  --{"dlg_townsquare2_bob3",  ""};        --Get the cauldron from the roof and blanch it.
  --{"get_cauldron",  ""};                --Take the cauldron to Bob.
  --{"dlg_townsquare2_bob4",  ""};        --Fix the bell and give it to Bob.
  ---------- LEVEL 3 ----
  --{"opn_nearofficeafter",""};                   --Отдайте Малькольму признание Чена. 
  --{"dlg_nearofficeafter_mel5",""};              --Отправляйтесь в клинику Уитмана.
  --{"opn_clinicentrance",""};                    --Найдите способ попасть в клинику.
  --{"dlg_clinicreception_iv2","opn_basement"};   --Найдите улики против доктора Уитмана.
  --{"clk_animbasement",""};                      --Выберитесь из подвала.
  --{"opn_laboratory",""};                        --Найдите доктора Уитмана.
  --{"clk_vidlastchance","clk_outro3"};           --Не дайте Уитману уничтожить улики и задержите его до приезда полиции.
};
--------------------------------------------------------------------------------
  
--[[ function MEMORIES SECTION () end;

  game.rooms_after_memory = 
  {
    "rm_mansion",     --после одного воспоминания
    "rm_smithhouse",  --после двух воспоминаний
    "rm_outskirts"    --после трёх воспоминаний
  }

  common.dialog.common.buttons[ "memory_not_in_demo" ] = { left = nil, center = { text = "ok", func = "Close" }, right = nil };

  function public.CountCompletedMemories()

    return ld.CheckRequirements( {"clk_completememory1","clk_completememory2","clk_completememory3"}, 1 )

  end

  function public.GotoRoomAfterMemory()
    
    cmn.GotoRoom( game.rooms_after_memory[ public.CountCompletedMemories() ] );

  end 

  --one more clear in common_impl ProfileReset
  --ng_global.memory_order = nil
  function private.ClearMemoryOrder()

    if cheatLoad then

      ng_global.memory_order = nil

    end

  end

  function public.ReorderProgress( memory_idx )

    --save new memory
    if memory_idx then
      
      ng_global.memory_order = ng_global.memory_order or {}
      table.insert( ng_global.memory_order, memory_idx )
      SaveProfiles();

    end

    --divide game.progress_names to chapters
    if not private.progress_order then

      private.progress_order = {}
      local borders = { 
        {"opn_entrypoint", "clk_startmemory"};
        {"clk_startmemory1", "clk_endmemory"};
        {"clk_endmemory1", "clk_startmemory"};
        {"clk_startmemory2", "clk_endmemory"};
        {"clk_endmemory2", "clk_startmemory"};
        {"clk_startmemory3", "clk_endmemory"};
        {"clk_endmemory3", nil};
      }

      for chapter, border in ipairs( borders ) do 

        private.progress_order[ chapter ] = {}
        local doInsert = false

        for i,v in ipairs(game.progress_names) do
          
          if v == border[ 1 ] then doInsert = true end
          
          if border[ 2 ] and v:match( border[ 2 ] ) then doInsert = false end
            
          if doInsert then

            table.insert( private.progress_order[ chapter ], v )

          end          

        end

      end

    end

    --form order from save or default
    local local_order = { 1, 2, 3 }

    if ng_global.memory_order then

      local insert_at = 1

      for i, v in ipairs( ng_global.memory_order ) do
        
        local key = ld.Table.Contains( local_order, v, true )
        table.remove( local_order, key )
        table.insert( local_order, insert_at, v )
        insert_at = insert_at + 1

      end
      
      ld.LogTrace( "SET CUSTOM MEMORY ORDER", local_order[1], local_order[2], local_order[3] );

    else

      ld.LogTrace( "SET DEFAULT ORDER", 1, 2, 3  );

    end

    --set order
    game.progress_names = {}

    for i, t in ipairs( private.progress_order ) do 

      local insert_from = t

      local isMemoryIdx = i%2 == 0

      if isMemoryIdx then

        local correctIdx = local_order[ math.tointeger( i/2 ) ] * 2
        insert_from = private.progress_order[ correctIdx ]

      end

      for j, v in ipairs( insert_from ) do

        table.insert( game.progress_names, v )

      end

    end

    ld_impl.SmartHint_UpdateCache()

  end 
]]
--------------------------------------------------------------------------------
  
  if not cheatLoad then

    LoadCurrentProfile() --crutch, it could break the game

  end

  --public.ReorderProgress()

end;

--------------------------------------------------------------------------------------------



function public.Test ()

  local profiles = GetProfileList();

  local cheater = false;

  for i = 1, #profiles, 1 do

    if ( profiles[ i ] == "CHEATER" ) then

      cheater = true;

    end;

  end;

  AddProfile( "CHEATER" );
  SetCurrentProfile( "CHEATER" );

  if ( not cheater ) then

    ng_global.gamemode = 0;
    ng_global.currentprogress = "std";
    ng_global.progress = {};
    ng_global.progress[ "std" ] = {};
    ng_global.progress[ "std" ].common = {};
    ng_global.progress[ "std" ].common.hinttimer = 0;

    SaveProfiles();

  end;

end;


--------------------------------------------------------------------------------------------

function public.ReplaceHelperToClicks()
  ld.LogTrace( "ReplaceHelperToClicks" );
  for i,o in ipairs(game.progress_names) do
    if common_impl.hint[ o ] and common_impl.hint[ o ].inv_obj and common_impl.hint[ o ].inv_obj == "obj_helper_cursor_drag" then
      ld.LogTrace( o)
      local rm = common_impl.hint[ o ].room
      local use_plase_room 
      
      if common_impl.hint[ o ].zz then
        use_plase_room = common.GetObjectName(common_impl.hint[ o ].zz)
      else
        use_plase_room = common.GetObjectName(rm)
      end
      
      ObjSet(common_impl.hint[ o ].use_place , {event_menter = function()ld.ShCur(CURSOR_HAND)end;
                                                event_mdown = function() _G[rm]["use_helper_"..use_plase_room]() end} );
      common_impl.hint[ o ].type = "click";
      common_impl.hint[ o ].inv_obj = nil;
    end
    
  end  
end

--------------------------------------------------------------------------------------------
--------------------------------------tutorial----------------------------------------------

function private.TutorInit()

--level.tutorial_question.first()
--level.tutorial_dialog.first()
--level.tutorial_zz.first()
--level.tutorial_get1.first()
--level.tutorial_use.first()
--level.tutorial_deploy.first()
--level.tutorial_hint.first()
--level.tutorial_hosparkles.first()
--level.tutorial_navigation.first()
--level.tutorial_map1.first()
--level.tutorial_map2.first()
--level.tutorial_mg.first()
--level.tutorial_puzzle2.first()
--level.tutorial_coll2.first()
--level.tutorial_task.first()
--level.tutorial_ho.first()
--level.tutorial_newho1.first()
--level.tutorial_newho2.first()
--level.tutorial_newho3.first()
--level.tutorial_newho4.first()
--level.tutorial_ach.first()

--level.tutorial_helper.first()
--level.tutorial_helper2.first()
--level.tutorial_memory.first()
--public.tutorial_morph2.first()
----------------------progress for tutorial
  game.tutorial_progress =
  {
    ["tutorial_specialfeatureson"] = {} --специальный маркер показывающий скипнули мы туториал на спец.фишки или нет

    ,["tutorial_question"]    = { unchecked = true, lock = 1, pos_x = 512, pos_y = 260 }
    ,["tutorial_dialog"]      = { pos_x = 700, pos_y = 190, tut_arrows= {{pos_x = -270, pos_y = 130, ang =  1.00}} }        
    ,["tutorial_zz"]          = { pos_x = 440, pos_y = 310, tut_arrows= {{pos_x =  -240, pos_y = 130, ang =  2.06}} }
    ,["tutorial_get1"]        = { pos_x = 700, pos_y = 390, tut_arrows= {{pos_x = -280, pos_y = -70, ang = -6.86}} }
    ,["tutorial_use"]         = { pos_x = 360.0; pos_y = 260.0; tut_arrows= {{pos_x = -80, pos_y = 380, ang =  3.14}, {pos_x = 298.0; pos_y = -10.0; ang = -0.44; }} }
    ,["tutorial_deploy"]      = { gamemode_custom = "plus_inv", special = true, pos_x = 530, pos_y = 380, tut_arrows= {{pos_x = -250, pos_y =  260, ang =  3.14}} }
    ,["tutorial_hint"]        = { gamemode_custom = "hint", pos_x = 580, pos_y = 390, tut_arrows= {{pos_x =  300, pos_y =  190, ang =  3.92}} }    
    ,["tutorial_hosparkles"]  = { gamemode_custom = "sparkle_area", gamemodeoff = 2, pos_x = 530.0; pos_y = 400.0; tut_arrows= {{pos_x = -230.0; pos_y = 150.0; ang = 1.03; }} }
    ,["tutorial_navigation"]  = { pos_x = 590.0; pos_y = 410.0; tut_arrows= {{pos_x = 320.0; pos_y = -10.0; ang = -7.26; }}--[[, gamemode_custom = "cursor" ]] }
    ,["tutorial_map1"]        = { pos_x = 350, pos_y = 400, tut_arrows= {{pos_x = -210, pos_y =  210, ang =  2.56}} }
    ,["tutorial_map2"]        = { pos_x = 600, pos_y = 200 }
    ,["tutorial_mg"]          = { gamemode_custom = "skip", gamemodeoff = 2, pos_x = 530, pos_y = 360, tut_arrows= {{pos_x =  60, pos_y =   300, ang =  -2.41}, {pos_x =  340, pos_y =   220, ang =  4.00}} }
    ,["tutorial_puzzle2"]     = { hide_in_se = true, special = true, pos_x = 700.0; pos_y = 230.0; tut_arrows= {{pos_x = -200.0; pos_y = 232.0; ang = 1.94;}} }
    ,["tutorial_coll2"]       = { hide_in_se = true, special = true, pos_x = 440.0; pos_y = 320.0; tut_arrows= {{pos_x = -170.0; pos_y = 230.0; ang = -4.54; }} }    
    ,["tutorial_task"]        = { lock_widgets = 1, pos_x = 370, pos_y = 390, tut_arrows= {{pos_x =  -160, pos_y =  300, ang =  -3.14}} }
    ,["tutorial_ho"]          = { pos_x = 512, pos_y = 350, tut_arrows= {{pos_x = 0, pos_y = 270, ang = 3.14}} }
    ,["tutorial_newho1"]      = { special = true, pos_x = 512, pos_y = 350, tut_arrows= {{pos_x = 0, pos_y = 270, ang = 3.14}} }
    ,["tutorial_newho2"]      = { special = true, pos_x = 512, pos_y = 350, tut_arrows= {{pos_x = 0, pos_y = 270, ang = 3.14}, {pos_x = -320.0; pos_y = 150.0; ang = 0.94;}} }
    ,["tutorial_newho3"]      = { special = true, pos_x = 512, pos_y = 350, tut_arrows= {{pos_x = 0, pos_y = 270, ang = 3.14}} }
    ,["tutorial_newho4"]      = { special = true, pos_x = 512, pos_y = 350, tut_arrows= {{pos_x = 0, pos_y = 270, ang = 3.14}} }
    ,["tutorial_newho5"]      = { special = true, pos_x = 512, pos_y = 350, tut_arrows= {{pos_x = 0, pos_y = 270, ang = 3.14}} }
    ,["tutorial_newho6"]      = { special = true, pos_x = 512, pos_y = 350, tut_arrows= {{pos_x = 0, pos_y = 270, ang = 3.14}} }

    ,["tutorial_ach"]     = { hide_in_se = true, special = true, pos_x = 562.0; pos_y = 370.0; tut_arrows= {{pos_x = -300.0; pos_y = -100.0; ang = 1.30; }} }

    --не используются VVV
    ,["tutorial_helper"]      --[[-]]= { special = true, pos_x = 380, pos_y = 340, tut_arrows= {{pos_x = -250, pos_y = 190, ang = 2.16}} }
    ,["tutorial_helper2"]     --[[-]]= { gamemode_custom = "cursor", special = true, pos_x = 770, pos_y = 220, tut_arrows= {{pos_x = -190, pos_y = 190, ang = 1.56}} }
    ,["tutorial_morph2"]      --[[-]]= { hide_in_se = true, special = true, pos_x = 372, pos_y = 220, tut_arrows= {{pos_x = -270, pos_y = 130, ang = 2.29}} }

  };
  
  for i,o in pairs(game.tutorial_progress) do

    table.insert(   game.progress_names, i );

    level[ i ] = {}
  end;

   level.tutorial_current = "";
----------------------------------------------------------------------------------------
  function private.TutorialWidgetsInput(lock)  -- для последовательных туториалов требуется лок для некоторых виджетов на время показа
    local arr = {InterfaceWidget_BtnMenu,InterfaceWidget_BtnMap,InterfaceWidget_BtnGuide}
    for _,o in ipairs(arr) do
      --ld.LogTrace( o, interface.WidgetGetInput( o ) );
      interface.WidgetSetInput(o,lock)
    end
  end

  function private.TutorialShow(name, offset) -- set current and Show
    if game.tutorial_progress[name].unchecked or ( private.TutorialGameModeCheck( name ) ) then
      level.tutorial_current = name;
      local tut_params = game.tutorial_progress[name];
      if offset then
        for i = 1,#offset-1 do
          tut_params.tut_arrows[i].pos_x = tut_params.tut_arrows[i].pos_x + offset[i+1];
        end
        tut_params.pos_x = tut_params.pos_x + offset[1]
      end
      if not (IsCollectorsEdition() or IsSurveyEdition()) then
        if tut_params.hide_in_se then
          cmn.SetEventDone( name );
          return false
        end
      end
      if tut_params.gamemodeoff then
        if ng_global.gamemode == tut_params.gamemodeoff then
          cmn.SetEventDone( name );
          return false
        end
      end
      if tut_params.gamemode_custom then
        if ng_global.gamemode == 3 and not ng_global.gamemode_custom[ tut_params.gamemode_custom ] then
          cmn.SetEventDone( name );
          return false
        end
      end
      if tut_params.lock_widgets then
        private.TutorialWidgetsInput(false)
      end
      interface.TutorialShow( "str_"..name, tut_params.lock, tut_params.pos_x, tut_params.pos_y, tut_params.tut_arrows );
      return true
    else
      cmn.SetEventDone( name );
      return false
    end
  end

  function private.TutorialHide() -- set current nil and Hide
    cmn.SetEventDone( level.tutorial_current );
    local tut_params = game.tutorial_progress[level.tutorial_current];
    level.tutorial_current = nil
    if tut_params.lock_widgets then
      private.TutorialWidgetsInput(true)
    end
    interface.TutorialHide();
  end

  function public.TutorialDisable() -- skip tutor all
    level.tutorial_current = nil
    if private.panel_notification_on_screen then
      ObjSet( "tmr_int_panel_notification", {playing = 1} );
    end
    for i,o in pairs(game.tutorial_progress) do

      cmn.SetEventDone( i );

    end;

  end;

  function public.TutorialSpecialDisable() --  вырубает только стандартные
    cmn.SetEventDone( level.tutorial_current );
    if private.panel_notification_on_screen then
      ObjSet( "tmr_int_panel_notification", {playing = 1} );
    end
    level.tutorial_current = nil
    for i,o in pairs(game.tutorial_progress) do

      if not o.special then
        cmn.SetEventDone( i );
      end

    end;
  end;

  function private.TutorialGameModeCheck(tutorial_name)  -- проверка на кастом режим и выключен ли туториал
    if ng_global.gamemode == 3 and not ng_global.gamemode_custom["tutorial"] then
      cmn.SetEventDone(tutorial_name)
    end
    if not cmn.IsEventDone(tutorial_name) and cmn.IsEventDone( "tutorial_question" ) then
      return true
    else
      return false
    end
  end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
  function public.tutorial_question.first()

    if ( ng_global.gamemode == 0 ) or (ng_global.gamemode == 3) then

      if ng_global.gamemode == 3 and not ng_global.gamemode_custom["tutorial"] then  --
        for i,o in pairs(game.tutorial_progress) do
          cmn.SetEventDone( i );
        end;
      end
      if  ( cmn.IsEventDone( "opn_entrypoint" ) )
      and ( not cmn.IsEventDone( "tutorial_question" ) )
      then
        private.TutorialShow("tutorial_question");
      end;

    else
      level.TutorialDisable();
    end;

  end;

  function public.tutorial_question.click() -- событие по клику на да
    private.TutorialHide()
    level.tutorial_dialog.first()
  end
  function public.tutorial_question.click_no() --не обязательно
    interface.TutorialHide();
    level.TutorialDisable();
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_dialog.first()
     if ld.CheckRequirements( {"tutorial_question"} ) then
       private.TutorialShow("tutorial_dialog");
     end
  end

  function public.tutorial_dialog.click()
    private.TutorialHide()
  end  
--------------------------------------------------------------------------------------------
  function public.tutorial_zz.first()
    if ( cmn.IsEventDone( "dlg_entrypoint_nick1" ) ) then
      if private.panel_notification_on_screen then
        cmn.SetEventDone( "tutorial_zz" );
      else
        private.TutorialShow("tutorial_zz");
      end
    end
  end

  function public.tutorial_zz.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_get1.first()
     private.TutorialShow("tutorial_get1");
  end

  function public.tutorial_get1.click()
    private.TutorialHide()
  end  
--------------------------------------------------------------------------------------------
  function public.tutorial_use.first()
    if ld.CheckRequirements( {"get_goldenclip", "clk_sunscreen11"} ) and not ld.CheckRequirements( {"use_goldenclip"} ) then
      local offset = ObjGet("hub_int_inventory_goldenclip") and ObjGet("hub_int_inventory_goldenclip").pos_x
      private.TutorialShow("tutorial_use",{0,offset});
    end
  end

  function public.tutorial_use.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_deploy.first()
    if  ( ld.CheckRequirements( {"get_waxstick", "get_taxishape1"} ) ) then
      local offset = ObjGet("hub_int_inventory_taxishape1") and ObjGet("hub_int_inventory_taxishape1").pos_x
      private.TutorialShow("tutorial_deploy",{0,offset});
      return
    end
  end

  function public.tutorial_deploy.click()
    private.TutorialHide()
    level.tutorial_zz.first()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_hint.first()
    if  ( cmn.IsEventDone( "use_goldenclip" ) ) then
      local offset = 0.5 * ( GetAppWidth() - 1024 );
      private.TutorialShow("tutorial_hint",{offset});
    end
  end

  function public.tutorial_hint.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_hosparkles.first()
    if ld.CheckRequirements({"use_taxi"}) then
      private.TutorialShow("tutorial_hosparkles");
    end
  end

  function public.tutorial_hosparkles.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_navigation.first(memory_idx)
--    if memory_idx == 1 then --туториал для 1 воспоминмния в rm_firstmemoryfirst
      if (cmn.IsEventDone("clk_vidbanksy")) then
        private.TutorialShow("tutorial_navigation");
      end
--    elseif memory_idx == 2 then --альтернативный туториал для 2 воспоминания (скорее всего в rm_secondmemoryfirst)
--
--      --game.tutorial_progress["tutorial_navigation"].pos_x = 500
--      --game.tutorial_progress["tutorial_navigation"].pos_y = 180
--      game.tutorial_progress["tutorial_navigation"].tut_arrows[1].pos_x = -20 - 250
--      if (cmn.IsEventDone("clk_vidsantahelp")) then
--        private.TutorialShow("tutorial_navigation");
--      end      
--
--    elseif memory_idx == 3 then --альтернативный туториал для 3 воспоминания (скорее всего в rm_thirdmemoryfirst)
--
--      game.tutorial_progress["tutorial_navigation"].pos_x = 580
--      game.tutorial_progress["tutorial_navigation"].pos_y = 200
--      game.tutorial_progress["tutorial_navigation"].tut_arrows[1] = {pos_x = -300, pos_y =  150, ang =  -3.76}
--      if (cmn.IsEventDone("use_hansknob")) then
--        private.TutorialShow("tutorial_navigation");
--      end
--
--    end
  end

  function public.tutorial_navigation.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_map1.first()
    if ld.CheckRequirements({"opn_toystoreyard1"}) then
      local offset = 0.5 * ( GetAppWidth() - 1024 );
      private.TutorialShow("tutorial_map1",{-offset});
    end
  end

  function public.tutorial_map1.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function private.tutorial_show_map()
    level.tutorial_map2.first() 
  end
  cmn.AddSubscriber( "show_map_tutorial", private.tutorial_show_map);  

  function public.tutorial_map2.first()
     private.TutorialShow("tutorial_map2");
  end

  function public.tutorial_map2.click()
    private.TutorialHide()
    cmn.SetEventDone( "tutorial_map1" );
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_mg.first()
    if ld.CheckRequirements({"use_valve"}) then
      local offset = 0.5 * ( GetAppWidth() - 1024 );
      if offset == 0 then
        game.tutorial_progress["tutorial_mg"].tut_arrows[1].pos_x =  game.tutorial_progress["tutorial_mg"].tut_arrows[1].pos_x+171
      end
      private.TutorialShow("tutorial_mg",{offset});
    end
  end

  function public.tutorial_mg.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_puzzle2.first(alter)
    if ld.CheckRequirements({"clk_dashboard1note"}) then
      local target = ObjGet("spr_puzzle_1")
      --if alter then
      --  target = ObjGet("spr_puzzle_2")
      --  if target and target.input then
      --    
      --    game.tutorial_progress["tutorial_puzzle2"] =
      --      { hide_in_se = true, special = true, pos_x = 700, pos_y = 200, tut_arrows= {{pos_x = 20, pos_y = 252, ang = 3.14}} }          
      --  end
      --end
      if target and target.input then
        --if ld.CheckRequirements( {"tutorial_deploy"} ) and not ld.CheckRequirements( {"tutorial_zz"} ) then
        --  --if in beetweeen two tutorials
        --else
          private.TutorialShow("tutorial_puzzle2");
        --end
      end
    end
  end

  function public.tutorial_puzzle2.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_coll2.first(memory_idx)
    --if memory_idx == 1 then --туториал для 1 воспоминмния в rm_firstmemoryfirst
      local target = ObjGet("anm_morphcollect_1")
      if target and target.input then
        private.TutorialShow("tutorial_coll2");
      end
--    elseif memory_idx == 2 then --альтернативный туториал для 2 воспоминания (скорее всего в rm_secondmemoryfirst)
--
--      game.tutorial_progress["tutorial_coll2"].pos_x = 405
--      game.tutorial_progress["tutorial_coll2"].pos_y = 370
--      game.tutorial_progress["tutorial_coll2"].tut_arrows= {{pos_x = 70, pos_y = -160, ang = 0.24}}    
--      local target = ObjGet("anm_morphcollect_4")
--      if target and target.input and ( cmn.IsEventDone( "clk_animtrap" ) )then
--        private.TutorialShow("tutorial_coll2");
--      end     
--
--    elseif memory_idx == 3 then --альтернативный туториал для 3 воспоминания (скорее всего в rm_thirdmemoryfirst)
--
--      --game.tutorial_progress["tutorial_coll2"].pos_x = 560
--      game.tutorial_progress["tutorial_coll2"].pos_y = 350
--      game.tutorial_progress["tutorial_coll2"].tut_arrows= {{pos_x = -120, pos_y = -140, ang = 1.47}}    
--      local target = ObjGet("anm_morphcollect_7")
--      if target and target.input and ( cmn.IsEventDone( "opn_thirdmemoryfirst" ) )then
--        private.TutorialShow("tutorial_coll2");
--      end
--
--    end



  end

  function public.tutorial_coll2.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_task.first()
    if  ( cmn.IsEventDone( "use_cigarettelighter" ) ) then
      if private.TutorialShow("tutorial_task") then
        int_inventory_impl.TempLock(true)
      end
    end
  end

  function public.tutorial_task.click()
    int_inventory_impl.TempLock(false)
    private.TutorialHide()
    --level.tutorial_coll2.first()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_ho.first()
     private.TutorialShow("tutorial_ho");      
  end

  function public.tutorial_ho.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_newho1.first() 
    private.TutorialShow("tutorial_newho1");
  end

  function public.tutorial_newho1.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_newho2.first() 
    private.TutorialShow("tutorial_newho2");
  end

  function public.tutorial_newho2.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_newho3.first() 
    private.TutorialShow("tutorial_newho3");
  end

  function public.tutorial_newho3.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_newho4.first() 
    private.TutorialShow("tutorial_newho4");
  end

  function public.tutorial_newho4.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_newho5.first() 
    private.TutorialShow("tutorial_newho5");
  end

  function public.tutorial_newho5.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_newho6.first() 
    private.TutorialShow("tutorial_newho6");
  end

  function public.tutorial_newho6.click()
    private.TutorialHide()
  end
--------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--function reserved tutorial code()  end
--------------------------------------------------------------------------------------------
  function private.tutorial_notification_first(type)
    if  ( cmn.IsEventDone( "tutorial_question" ) ) then
      local func_end = function()
        if level.tutorial_current == type then
          ObjSet( "tmr_int_panel_notification", {playing = 0} );
          private.panel_notification_on_screen = true;
        end
      end
      local offset = 0.5 * ( GetAppWidth() - 1024 );
      if private.TutorialShow(type, {-offset}) then
        ld.StartTimer( 0.7 , func_end )
      end
    end
  end
  
  function private.tutorial_notification_click()
    private.panel_notification_on_screen = false;
    ObjSet( "tmr_int_panel_notification", {playing = 1} );
    private.TutorialHide()
  end

  --------------------------------------------------------------------------------------------
  --  function public.tutorial_coll.first()
  --    private.tutorial_notification_first("tutorial_coll")
  --  end
  --
  --  function public.tutorial_coll.click()
  --    private.tutorial_notification_click()
  --  end
  --------------------------------------------------------------------------------------------
  function public.tutorial_ach.first()
   
    --if (GetCurrentRoom()== "ho_investigation" or GetCurrentRoom()=="rm_entrypoint") and ho_investigation.turotial_ach_off then
    --  return
    --end
    private.tutorial_notification_first("tutorial_ach")
  end

  function public.tutorial_ach.click()
    private.tutorial_notification_click()
  end
  ----------------------------------------------------------------------------------------------
  --  function public.tutorial_morph.first()
  --    private.tutorial_notification_first("tutorial_morph")
  --  end
  --
  --  function public.tutorial_morph.click()
  --    cmn.SetEventDone( "tutorial_morph2" );
  --    private.tutorial_notification_click()
  --  end

  --------------------------------------------------------------------------------------------
  --  function public.tutorial_helper.first()
  --    if ld.CheckRequirements( {"get_helper"} ) then
  --      local offset = 0.5 * ( GetAppWidth() - 1024 );
  --      private.TutorialShow("tutorial_helper",{-offset});
  --    end
  --  end
  --
  --  function public.tutorial_helper.click()
  --    private.TutorialHide()
  --  end
  ----------------------------------------------------------------------------------------------
  --  function public.tutorial_helper2.first()
  --    private.TutorialShow("tutorial_helper2");
  --  end
  --
  --  function public.tutorial_helper2.click()
  --    private.TutorialHide()
  --  end
  ----------------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------
  --  function public.tutorial_morph2.first()
  --    local target = ObjGet("anm_simplemorphcollect_1")
  --    if ( cmn.IsEventDone( "clk_anmwarmclothes" ) ) and target and target.input then
  --      private.TutorialShow("tutorial_morph2");
  --    end
  --  end
  --
  --  function public.tutorial_morph2.click()
  --    private.TutorialHide()
  --  end

--end

end