
function public.Start ( param )

  int.WidgetAdd( InterfaceWidget_Pause, 1800 );

  int.WidgetAdd( InterfaceWidget_BtnMenu, 12 );
  int.WidgetAdd( InterfaceWidget_BtnGuide, 10 );

  int.WidgetAdd( InterfaceWidget_BtnHint, 9  );
  int.WidgetAdd( InterfaceWidget_BtnSkip, 9 );
  int.WidgetAdd( InterfaceWidget_BtnInfo, 9 );
  int.WidgetAdd( InterfaceWidget_BtnReset, 9 );

  --int.WidgetAdd( InterfaceWidget_TaskHeader );
  int.WidgetAdd( InterfaceWidget_Inventory, 9 );
  int.WidgetAdd( InterfaceWidget_TaskPanel, 10 );

  int.WidgetAdd( InterfaceWidget_Effects );

  int.WidgetAdd( InterfaceWidget_BtnMap, 11 );

  int.WidgetAdd( InterfaceWidget_DialogHo );

  int.ButtonLockAdd();

  int.WidgetAdd( InterfaceWidget_FrameSubroom, 8 );

  int.WidgetAdd( InterfaceWidget_ItemPanel );
  int.WidgetAdd( InterfaceWidget_Popup );

  int.WidgetAdd( InterfaceWidget_BlackBarText, 1500 );
  int.WidgetAdd( InterfaceWidget_Dialog );

  int.WidgetAdd( InterfaceWidget_DialogVideo );
  int.WidgetAdd( InterfaceWidget_DialogStory );
  int.WidgetAdd( InterfaceWidget_DialogCharacter, 900 );

  int.WidgetAdd( InterfaceWidget_StrategyGuide );
  int.WidgetAdd( InterfaceWidget_Window );

  int.WidgetAdd( InterfaceWidget_Tutorial );

  int.WidgetAdd( InterfaceWidget_Map, 16  );

  int.PanelNotificationAdd();

  --
  private.Init();
  ModLoad( "assets/levels/{{level_name}}/mod_{{level_name}}_inv" );
  --

  cmn.LevelLoad( "{{level_name}}", "std", "{{start_room_name}}", param );
  --ModLoad( "assets/interface/map/mod_map" );
  
end;
    
function private.Init ()

  game = {};
  game.room_names =
  {
	{{#first_room}}
	   "{{room_name}}"
	{{/first_room}}
	{{#rooms}}
	  ,"{{room_name}}"
	{{/rooms}}
  };

  game.progress_names =
  {
     "beg_{{level_name}}"
	 {{#progress}}
	,"{{progress_name}}"
	 {{/progress}}
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
