
function public.Start ( param )

  interface.WidgetAdd( InterfaceWidget_Pause, 1800 );

  interface.WidgetAdd( InterfaceWidget_BtnMenu, 13 );
  interface.WidgetAdd( InterfaceWidget_BtnGuide, 12 );

  interface.WidgetAdd( InterfaceWidget_BtnHint, 11  );
  interface.WidgetAdd( InterfaceWidget_BtnSkip, 11 );
  interface.WidgetAdd( InterfaceWidget_BtnInfo, 9 );
  interface.WidgetAdd( InterfaceWidget_BtnReset, 9 );

  --interface.WidgetAdd( InterfaceWidget_TaskHeader );
  interface.WidgetAdd( InterfaceWidget_Inventory, 9 );
  interface.WidgetAdd( InterfaceWidget_TaskPanel, 9 );

  interface.WidgetAdd( InterfaceWidget_Effects );



  interface.WidgetAdd( InterfaceWidget_DialogHo,30 );

  interface.ButtonLockAdd();
  interface.LockAdd();

  interface.WidgetAdd( InterfaceWidget_FrameSubroom, 8 );

  interface.WidgetAdd( InterfaceWidget_ItemPanel,9 );
  interface.WidgetAdd( InterfaceWidget_Popup );

  interface.WidgetAdd( InterfaceWidget_BlackBarText, 1500 );
  interface.WidgetAdd( InterfaceWidget_Dialog,30 );

  interface.WidgetAdd( InterfaceWidget_DialogVideo,30 );
  interface.WidgetAdd( InterfaceWidget_DialogStory,30 );
  interface.WidgetAdd( InterfaceWidget_DialogCharacter, 30 );

  --interface.WidgetAdd( InterfaceWidget_StrategyGuide,30 );
  interface.WidgetAdd( InterfaceWidget_Window );

  interface.WidgetAdd( InterfaceWidget_Tutorial,30 );

  interface.WidgetAdd( InterfaceWidget_Map, 16  );

  interface.PanelNotificationAdd(10);


  --interface.DeployInvAdd(7);
  interface.ComplexInvAdd( 9 )
  interface.DialogHintAdd(20);
  --interface.Btn_DiaryAdd(12)
  --interface.InvestigationButtonAdd( 17 );
  --interface.DiaryAdd( 18 );
  --interface.DiaryDcnAdd( 31 );

  interface.PanelhopairAdd(9)

  interface.ButtonTaskAdd(20)
  interface.DialogTaskAdd(1000)

  private.Init();



  ModLoad( "assets/levels/levelext/mod_levelext_inv" );
  level_inv.Init()

  private.TutorInit()--тутор
  --

  interface.ArrPuzzles()

  common.LevelLoad( "levelext", "ext", "rm_roomext", param );
  --ModLoad( "assets/interface/map/mod_map" );


  --public.init_diary_analysis()  ---клики для дневника

  interface.KeyUpdate();

  --временно залочена кнопка SG
  interface.WidgetSetInput(InterfaceWidget_BtnGuide, 0)

  ObjSet( "txt_int_dialog_character", {param0 = GetCurrentProfile()} );
  --автоподствновка имени игрока в диалоги

  interface.CheckPuzzles()
  interface.CheckMorphing()

end;

function public.SimonAdd() -- get_simon
  interface.WidgetAdd( InterfaceWidget_BtnMap, 11 );
  interface.SimonAdd(10)
 -- int_simon.LoadAnotherPrg()
end

function private.Init ()

  game = {};
  game.room_names =
  {
	 "rm_roomext"
  };

  game.progress_names =
  {

  };

  game.relations = {};

end;

function Test ()

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
--------------------------------------------------------------------------------------------
--------------------------------------tutorial----------------------------------------------

function private.TutorInit()

----------------------progress for tutorial
  game.tutorial_progress =
  {

  };

  for i=1, #game.tutorial_progress do

    table.insert(   game.progress_names, game.tutorial_progress[ i ] );

    level[game.tutorial_progress[ i ]] = {}
  end;


   level.tutorial_current = "";
----------------------------------------------------------------------------------------
  function public.TutorialDisable() -- skip tutor all
    level.tutorial_current = nil
    for i = 1, ( #game.tutorial_progress ), 1 do

      local tutorial_element = game.tutorial_progress[ i ];

      cmn.SetEventDone( tutorial_element );

    end;

  end;
  function public.TutorialSpecialDisable() --  вырубает только стандартные
    level.tutorial_current = nil
    for i = 1, ( #game.tutorial_progress - 7 ), 1 do

      local tutorial_element = game.tutorial_progress[ i ];

      cmn.SetEventDone( tutorial_element );

    end;
    level.tutorial_sp_skiped = true
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
  function public.tutorial_question.first()

    if ( ng_global.gamemode == 0 ) then
      if  ( cmn.IsEventDone( "opn_room" ) )
      and ( not cmn.IsEventDone( "tutorial_question" ) )
      then
        level.tutorial_current = "tutorial_question";
        interface.TutorialShow( "str_tutorial_question", 1, 500, 180 );
      end;
    elseif ng_global.gamemode == 3  then

      if  not ng_global.gamemode_custom["tutorial"] then  --
        --DbgTrace("off tutor")
        for i = 1, ( #game.tutorial_progress), 1 do
          local tutorial_element = game.tutorial_progress[ i ];
          cmn.SetEventDone( tutorial_element );
        end;
      end

      if  ( cmn.IsEventDone( "opn_room" ) )
      and ( not cmn.IsEventDone( "tutorial_question" ) )
      then
        level.tutorial_current = "tutorial_question";
        interface.TutorialShow( "str_tutorial_question", 1, 500, 180 );
      end;


    else
      level.TutorialDisable();
    end;

  end;
--------------------------------------------------------------------------------------------
  function public.tutorial_question.click() -- событие по клику на да
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_question" );
    ld.Lock(1)
    ld.StartTimer( 0.3, function() ld.Lock(0);level.tutorial_dialog.first() end )
  end
  function public.tutorial_question.click_no() --не обязательно
    --some code
    interface.TutorialHide();
    level.TutorialDisable();

  end
--------------------------------------------------------------------------------------------
  function public.tutorial_dialog.first()
      if  ( cmn.IsEventDone( "tutorial_question" ) )
      and ( private.TutorialGameModeCheck( "tutorial_dialog" ) ) then
        level.tutorial_current = "tutorial_dialog";
        local tut_arrows={{pos_x = 0,pos_y=220,ang=3.14}};
        interface.TutorialShow( "str_tutorial_dialog", false, 500, 100,tut_arrows );
      end
  end

  function public.tutorial_dialog.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_dialog" );

  end
--------------------------------------------------------------------------------------------
  function public.tutorial_ho.first()
      if  ( cmn.IsEventDone( "dlg_room_simon" ) )
      and ( private.TutorialGameModeCheck( "tutorial_ho" ) ) then
        level.tutorial_current = "tutorial_ho";
        local tut_arrows={{pos_x = 0,pos_y=200,ang=3.14}};
        interface.TutorialShow( "str_tutorial_ho", false, 512, 400,tut_arrows );
      end
  end

  function public.tutorial_ho.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_ho" );
    level.tutorial_hint.first()

  end
--------------------------------------------------------------------------------------------
  function public.tutorial_hint.first()
      if  ( cmn.IsEventDone( "tutorial_ho" ) )
      and ( private.TutorialGameModeCheck( "tutorial_hint" ) ) then
        level.tutorial_current = "tutorial_hint";
        local tut_arrows={{pos_x = 300,pos_y=140,ang=3.925}};
        local offset = 0.5 * ( GetAppWidth() - 1024 );
        interface.TutorialShow( "str_tutorial_hint", false, 580+offset, 450,tut_arrows );
      end
  end

  function public.tutorial_hint.click()
    level.tutorial_current = nil  
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_hint" );
  
    local func_end = function ()
      level.tutorial_zz.first()
    end
    ld.StartTimer( "tmr_tutorial_zz", 0.1, func_end )
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_zz.first()
      if  ( cmn.IsEventDone( "tutorial_hint" ) )
      and ( private.TutorialGameModeCheck( "tutorial_zz" ) ) then
        level.tutorial_current = "tutorial_zz";
        local tut_arrows={{pos_x = -270,pos_y=100,ang=2.355}};
        interface.TutorialShow( "str_tutorial_zz", false, 450, 280,tut_arrows );
      end
  end

  function public.tutorial_zz.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_zz" );

  end
--------------------------------------------------------------------------------------------
  function public.tutorial_get.first()
      if  ( cmn.IsEventDone( "use_simon_cats" ) )
      and ( private.TutorialGameModeCheck( "tutorial_get" ) ) then
        level.tutorial_current = "tutorial_get";
        local tut_arrows={{pos_x = 0,pos_y=220,ang=3.14}};
        interface.TutorialShow( "str_tutorial_get", false, 600, 170,tut_arrows );
      end
  end

  function public.tutorial_get.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_get" );

  end
--------------------------------------------------------------------------------------------
  function public.tutorial_use.first()
      if  ( cmn.IsEventDone( "get_coin" ) ) and (( cmn.IsEventDone( "get_ring1" ) ) or ( cmn.IsEventDone( "get_ring2" ) )) 
      and ( private.TutorialGameModeCheck( "tutorial_use" ) ) then
        level.tutorial_current = "tutorial_use";
        local offset
        if ( cmn.IsEventDone( "get_ring1" ) ) then
          offset = ObjGet("hub_int_inventory_ring1").pos_x
        elseif ( cmn.IsEventDone( "get_ring2" ) ) then
          offset = ObjGet("hub_int_inventory_ring2").pos_x
        end
        
        local tut_arrows={{pos_x = -270+offset,pos_y=550,ang=3.14},{pos_x = 0,pos_y=210,ang=3.14}};
        interface.TutorialShow( "str_tutorial_use", false, 520, 120,tut_arrows );
      end
  end

  function public.tutorial_use.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_use" );

  end
--------------------------------------------------------------------------------------------
  function public.tutorial_mg.first()
      if  ( cmn.IsEventStart( "win_startrek" ) )
      and ( private.TutorialGameModeCheck( "tutorial_mg" ) ) then
        level.tutorial_current = "tutorial_mg";
        local tut_arrows={{pos_x = 130,pos_y=0,ang=4.71},{pos_x = 300,pos_y=140,ang=3.925}};
        local offset = 0.5 * ( GetAppWidth() - 1024 );
        interface.TutorialShow( "str_tutorial_mg", false, 550+offset, 490,tut_arrows );
      end
  end

  function public.tutorial_mg.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_mg" );

  end
--------------------------------------------------------------------------------------------
  function public.tutorial_map1.first()
      if  ( cmn.IsEventDone( "opn_sweetquarter" ) )
      and ( private.TutorialGameModeCheck( "tutorial_map1" ) ) then
        level.tutorial_current = "tutorial_map1";
        local tut_arrows={{pos_x = -300,pos_y=140,ang=2.355}};
        local offset = 0.5 * ( GetAppWidth() - 1024 );
        interface.TutorialShow( "str_tutorial_map1", false, 480-offset, 460,tut_arrows );
      end
  end

  function public.tutorial_map1.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_map1" );

  end
--------------------------------------------------------------------------------------------
  function public.tutorial_map2.first()
      if  ( cmn.IsEventDone( "tutorial_question" ) )
      and ( private.TutorialGameModeCheck( "tutorial_map2" ) ) then
        level.tutorial_current = "tutorial_map2";
        local tut_arrows={{pos_x = 0,pos_y=190,ang=3.14}};
        interface.TutorialShow( "str_tutorial_map2", false, 700, 280,tut_arrows );
      end
  end

  function public.tutorial_map2.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_map1" );
    cmn.SetEventDone( "tutorial_map2" );
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_deploy.first()
      if  ( cmn.IsEventDone( "dlg_square_santa" ) )
      and ( private.TutorialGameModeCheck( "tutorial_deploy" ) ) then
        level.tutorial_current = "tutorial_deploy";
        local tut_arrows={{pos_x = 0,pos_y=200,ang=3.14}};
        interface.TutorialShow( "str_tutorial_deploy", false, 250, 430,tut_arrows );
      end
  end

  function public.tutorial_deploy.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_deploy" );
   
    local func_end = function ()
        if int_complex_inv.GetCurrentName() == "" then
           level.tutorial_getsimon.first()
        end
    end
    ld.StartTimer( "tmr_tutorial_getsimon", 0.1, func_end )

  end
--------------------------------------------------------------------------------------------
  function public.tutorial_getsimon.first()
      if  ( cmn.IsEventDone( "tutorial_deploy" ) ) and ( cmn.IsEventDone( "dlg_square_santa" ) )
      and ( private.TutorialGameModeCheck( "tutorial_getsimon" ) ) then
        level.tutorial_current = "tutorial_getsimon";
        local tut_arrows={{pos_x = 0,pos_y=200,ang=3.14}};
        interface.TutorialShow( "str_tutorial_getsimon", false, 700, 300,tut_arrows );
      end
  end

  function public.tutorial_getsimon.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_getsimon" );

  end

  function public.tutorial_usesimon.first()
      if  ( cmn.IsEventDone( "get_simon" ) )
      and ( private.TutorialGameModeCheck( "tutorial_usesimon" ) ) then
        level.tutorial_current = "tutorial_usesimon";
        local offset = 0.5 * ( GetAppWidth() - 1024 );
        local tut_arrows={{pos_x = -450-offset,pos_y=350,ang=2.355},{pos_x = 0,pos_y=200,ang=3.14}};
        interface.TutorialShow( "str_tutorial_usesimon", false, 600, 150,tut_arrows );
      end
  end

  function public.tutorial_usesimon.click()
    level.tutorial_current = nil
    if not cmn.IsEventDone( "tutorial_usesimon" )  then
      interface.TutorialHide();
      cmn.SetEventDone( "tutorial_usesimon" );
    end
  end
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
  function public.tutorial_snegoskop1.first()
      if  ( cmn.IsEventDone( "get_snegoskop" ) )
      and ( private.TutorialGameModeCheck( "tutorial_snegoskop1" ) ) then
        level.tutorial_current = "tutorial_snegoskop1";
        local offset = 0 
         if ObjGet("hub_int_inventory_snegoskop") then
          offset =  ObjGet("hub_int_inventory_snegoskop").pos_x
         end
        local tut_arrows={{pos_x = -350+offset,pos_y=200,ang=3.14}};
        interface.TutorialShow( "str_tutorial_snegoskop1", false, 590, 450,tut_arrows );
      end
  end

  function public.tutorial_snegoskop1.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_snegoskop1" );
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_snegoskop2.first()
      local room = GetCurrentRoom()
      if  ( cmn.IsEventDone( "use_snegoskop_"..ld.StringDivide(room)[2] ) )
      and ( private.TutorialGameModeCheck( "tutorial_snegoskop2" ) ) then
        level.tutorial_current = "tutorial_snegoskop2";
        
        local pos_arrows = {}
              pos_arrows.rm_museum       = { 300,0,4.71} 
              pos_arrows.rm_square       = {-300,0,1.57} 
              pos_arrows.rm_sweetquarter = {0,220,3.14} 
              pos_arrows.rm_sweetshop    = {0,200,3.14} 
              pos_arrows.rm_toyquarter   = {-300,0,1.57} 
              pos_arrows.rm_toyshop      = {-300,0,1.57} 
        local tut_arrows={{pos_x = pos_arrows[room][1],pos_y=pos_arrows[room][2],ang=pos_arrows[room][3]}};

        local pos = {}
                    pos.rm_museum       = {550,400} 
                    pos.rm_square       = {530,260} 
                    pos.rm_sweetquarter = {770,270} 
                    pos.rm_sweetshop    = {250,240} 
                    pos.rm_toyquarter   = {500,320} 
                    pos.rm_toyshop      = {500,300} 


        interface.TutorialShow( "str_tutorial_snegoskop2", false, pos[room][1], pos[room][2],tut_arrows );
      end
  end

  function public.tutorial_snegoskop2.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_snegoskop2" );
  end
--------------------------------------------------------------------------------------------
  function public.tutorial_newho1.first()
      if  ( cmn.IsEventDone( "opn_stuffho" ) )
      and ( private.TutorialGameModeCheck( "tutorial_newho1" ) ) then
        level.tutorial_current = "tutorial_newho1";
        local tut_arrows={{pos_x = 0,pos_y=250,ang=3.14}};
        interface.TutorialShow( "str_tutorial_newho1", false, 512, 350,tut_arrows );
      end
  end

  function public.tutorial_newho1.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_newho1" );

  end
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
  function public.tutorial_newho2.first()
      if  ( cmn.IsEventDone( "opn_showcaseho" ) )
      and ( private.TutorialGameModeCheck( "tutorial_newho2" ) ) then
        level.tutorial_current = "tutorial_newho2";
        local tut_arrows={{pos_x = 0,pos_y=250,ang=3.14}};
        interface.TutorialShow( "str_tutorial_newho2", false, 512, 350,tut_arrows );
      end
  end

  function public.tutorial_newho2.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_newho2" );

  end
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
  function public.tutorial_newho3.first()
      if  ( cmn.IsEventDone( "opn_workshop" ) )
      and ( private.TutorialGameModeCheck( "tutorial_newho3" ) ) then
        level.tutorial_current = "tutorial_newho3";
        local tut_arrows={{pos_x = 0,pos_y=250,ang=3.14}};
        interface.TutorialShow( "str_tutorial_newho3", false, 512, 350,tut_arrows );
      end
  end

  function public.tutorial_newho3.click()
    level.tutorial_current = nil
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_newho3" );

  end
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
  function public.tutorial_ach.first()
      if  ( cmn.IsEventDone( "tutorial_question" ) )
      and ( private.TutorialGameModeCheck( "tutorial_ach" ) ) then
        local func_end = function()
          if level.tutorial_current == "tutorial_ach" then
            ObjSet( "tmr_int_panel_notification", {playing = 0} );
          end
        end
        ld.StartTimer( "tmr_tutorial_panel_notification", 0.7 , func_end )
        level.tutorial_current = "tutorial_ach";
        local tut_arrows={{pos_x = -300,pos_y=-50,ang=0.785}};
        interface.TutorialShow( "str_tutorial_ach", false, 512, 300,tut_arrows );
      end
  end

  function public.tutorial_ach.click()
    level.tutorial_current = nil
    ObjSet( "tmr_int_panel_notification", {playing = 1} );
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_ach" );

  end
--------------------------------------------------------------------------------------------
  function public.tutorial_puzzle.first()
      if  ( cmn.IsEventDone( "tutorial_question" ) )
      and ( private.TutorialGameModeCheck( "tutorial_puzzle" ) ) then
        local func_end = function()
          if level.tutorial_current == "tutorial_puzzle" then
            ObjSet( "tmr_int_panel_notification", {playing = 0} );
          end
        end
        ld.StartTimer( "tmr_tutorial_panel_notification", 0.7 , func_end )
        level.tutorial_current = "tutorial_puzzle";
        local tut_arrows={{pos_x = -300,pos_y=-50,ang=0.785}};
        interface.TutorialShow( "str_tutorial_puzzle", false, 512, 300,tut_arrows );
      end
  end

  function public.tutorial_puzzle.click()
    level.tutorial_current = nil
    ObjSet( "tmr_int_panel_notification", {playing = 1} );
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_puzzle" );

  end
--------------------------------------------------------------------------------------------
  function public.tutorial_morph.first()
      if  ( cmn.IsEventDone( "tutorial_question" ) )
      and ( private.TutorialGameModeCheck( "tutorial_morph" ) ) then
        local func_end = function()
          if level.tutorial_current == "tutorial_puzzle" then
            ObjSet( "tmr_int_panel_notification", {playing = 0} );
          end
        end
        ld.StartTimer( "tmr_tutorial_panel_notification", 0.7 , func_end )
        level.tutorial_current = "tutorial_morph";
        local tut_arrows={{pos_x = -300,pos_y=-50,ang=0.785}};
        interface.TutorialShow( "str_tutorial_morph", false, 512, 300,tut_arrows );
      end
  end

  function public.tutorial_morph.click()
    level.tutorial_current = nil
    ObjSet( "tmr_int_panel_notification", {playing = 1} );
    interface.TutorialHide();
    cmn.SetEventDone( "tutorial_morph" );

  end
--tmr_int_panel_notification


end