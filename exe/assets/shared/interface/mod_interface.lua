-- name=interface
--*********************************************************************************************************************
public.originhub = "ng_interface_internal";
public.NG_INTERFACE = "ng_interface";
--*********************************************************************************************************************
function public.Init ()

  private.InitGlobalConstant();
  private.Init_Widget();

  ModLoad( "assets/interface/mod_interface_impl" );
  interface_impl.Init();

end;
--*********************************************************************************************************************
function private.InitGlobalConstant()

  --InterfaceWidget_FrameSubroom     = "InterfaceWidget_FrameSubroom";
  --InterfaceWidget_Inventory        = "InterfaceWidget_Inventory";
  --InterfaceWidget_TaskPanel        = "InterfaceWidget_TaskPanel";
  --InterfaceWidget_TaskHeader       = "InterfaceWidget_TaskHeader";
  --InterfaceWidget_ItemPanel        = "InterfaceWidget_ItemPanel";
  --InterfaceWidget_BtnHint          = "InterfaceWidget_BtnHint";
  --InterfaceWidget_BtnSkip          = "InterfaceWidget_BtnSkip";
  --InterfaceWidget_BtnInfo          = "InterfaceWidget_BtnInfo";
  --InterfaceWidget_BtnReset         = "InterfaceWidget_BtnReset";
  --InterfaceWidget_BtnGuide         = "InterfaceWidget_BtnGuide";
  --InterfaceWidget_Map              = "InterfaceWidget_Map";
  --InterfaceWidget_BtnMap           = "InterfaceWidget_BtnMap";
  --InterfaceWidget_BtnMenu          = "InterfaceWidget_BtnMenu";
  --InterfaceWidget_DialogHo         = "InterfaceWidget_DialogHo";
  --InterfaceWidget_Dialog           = "InterfaceWidget_Dialog";
  --InterfaceWidget_Tutorial         = "InterfaceWidget_Tutorial";
  --InterfaceWidget_BlackBarText     = "InterfaceWidget_BlackBarText";
  InterfaceWidget_DialogVideo      = "InterfaceWidget_DialogVideo";
  --InterfaceWidget_DialogStory      = "InterfaceWidget_DialogStory";
  --InterfaceWidget_DialogCharacter  = "InterfaceWidget_DialogCharacter";
  InterfaceWidget_Window           = "InterfaceWidget_Window";
  --InterfaceWidget_Popup            = "InterfaceWidget_Popup";
  --InterfaceWidget_Effects          = "InterfaceWidget_Effects";
  InterfaceWidget_Pause            = "InterfaceWidget_Pause";
  InterfaceWidget_Top              = "InterfaceWidget_Top";
  --InterfaceWidget_Transporter      = "InterfaceWidget_Transporter";
  --InterfaceWidget_StrategyGuide    = "InterfaceWidget_StrategyGuide";
  InterfaceWidget_Custom           = "InterfaceWidget_Custom";
  InterfaceWidget_Top_Name         = "int_top";


  -- Messages
  Command_TaskPanel_DecreaseZ = "Command_TaskPanel_DecreaseZ";
  Command_TaskPanel_IncreaseZ = "Command_TaskPanel_IncreaseZ";
  Command_Inventory_IncreaseZ = "Command_Inventory_IncreaseZ";
  Command_Inventory_DecreaseZ = "Command_Inventory_DecreaseZ";

end;
--*********************************************************************************************************************
--***function *** Interface *** () end*********************************************************************************
--*********************************************************************************************************************
  function public.LoadImplementation( impl_name, impl_module_name )

    local core_object_name = "int_"..impl_name;
    local impl_object_name = core_object_name.."_impl";

    impl_module_name = impl_module_name or impl_object_name;

    ModLoad( "assets/interface/"..impl_module_name );

    _G[ impl_object_name ].Init();

    ObjAttach( impl_object_name, core_object_name );

    public.WideScreenUpdate( impl_name );

  end;
  -------------------------------------------------------------------------------------
  function public.WideScreenUpdate( impl_name )
  
--    DbgTrace( "[ int ] public.WideScreenUpdate: "..impl_name );
    local int_impl_name = "int_"..impl_name.."_impl";

    local direction = _G[ int_impl_name ].DIRECTION or 0;

--    DbgTrace( "[ int ] direction = "..tostring(direction));
  
    if ( direction ~= 0 ) then
  
      local offset = 0.5 * ( GetAppWidth() - 1024 );
  
      local position = _G[ int_impl_name ].POSITION or 0; 

--      DbgTrace( "[ int ] position = "..tostring(position));
  
      ObjSet( int_impl_name, { pos_x = position + ( direction * offset ) } );

    end;
  
    if ( _G[ int_impl_name ].WideScreenUpdate ) then
      
      _G[ int_impl_name ].WideScreenUpdate();
  
    end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.GetGlobalVector( obj_fst, obj_lst )
  
    local pos_beg = GetObjPosByObj( obj_fst );
    local pos_end = GetObjPosByObj( obj_lst );
  
    local vect_x = math.abs( pos_beg[ 1 ] - pos_end[ 1 ] );
    local vect_y = math.abs( pos_beg[ 2 ] - pos_end[ 2 ] );
  
    return math.sqrt( ( vect_x * vect_x ) + ( vect_y * vect_y ) );
  
  end;
  -------------------------------------------------------------------------------------
  function public.FrameGridSet( grid_name, grid_params )
  
    local grid_w   = grid_params[ "grid_w" ];
    local grid_h   = grid_params[ "grid_h" ];
    local corner_w = grid_params[ "corner_w" ];
    local corner_h = grid_params[ "corner_h" ];
    local mid_w    = grid_params[ "mid_w" ];
    local mid_h    = grid_params[ "mid_h" ];
  
    local min_grid_w = 2 * ( corner_w ) + mid_w;
  
    if ( grid_w < min_grid_w ) then
      
      grid_w = min_grid_w;
  
    end;
  
    local min_grid_h = 2 * ( corner_h ) + mid_h;
  
    if ( grid_h < min_grid_h ) then
      
      grid_h = min_grid_h;
  
    end;
  
    local top_lft_x =  - math.floor( 0.5 * grid_w );
    local top_lft_y =  - math.floor( 0.5 * grid_h );
  
    local top_rgt_x =    math.floor( 0.5 * grid_w );
    local top_rgt_y =  - math.floor( 0.5 * grid_h );
  
    local bot_lft_x =  - math.floor( 0.5 * grid_w );
    local bot_lft_y =    math.floor( 0.5 * grid_h );
  
    local bot_rgt_x =    math.floor( 0.5 * grid_w );
    local bot_rgt_y =    math.floor( 0.5 * grid_h );
  
    GridSet( "grd_"..grid_name, 0,
    {
       0, { pos_x = top_lft_x,            pos_y = top_lft_y            },
       1, { pos_x = top_lft_x + corner_w, pos_y = top_lft_y            },
       4, { pos_x = top_lft_x,            pos_y = top_lft_y + corner_h },
       5, { pos_x = top_lft_x + corner_w, pos_y = top_lft_y + corner_h },  
       3, { pos_x = top_rgt_x,            pos_y = top_rgt_y            },
       2, { pos_x = top_rgt_x - corner_w, pos_y = top_rgt_y            },
       7, { pos_x = top_rgt_x,            pos_y = top_rgt_y + corner_h },
       6, { pos_x = top_rgt_x - corner_w, pos_y = top_rgt_y + corner_h },  
      12, { pos_x = bot_lft_x,            pos_y = bot_lft_y            },
      13, { pos_x = bot_lft_x + corner_w, pos_y = bot_lft_y            },
       8, { pos_x = bot_lft_x,            pos_y = bot_lft_y - corner_h },
       9, { pos_x = bot_lft_x + corner_w, pos_y = bot_lft_y - corner_h },  
      15, { pos_x = bot_rgt_x,            pos_y = bot_rgt_y            },
      14, { pos_x = bot_rgt_x - corner_w, pos_y = bot_rgt_y            },
      11, { pos_x = bot_rgt_x,            pos_y = bot_rgt_y - corner_h },
      10, { pos_x = bot_rgt_x - corner_w, pos_y = bot_rgt_y - corner_h }
    } );
  
    ObjSet( "grd_"..grid_name,
    {
      inputrect_x    = - ( 0.5 * grid_w ),
      inputrect_y    = - ( 0.5 * grid_h ),
      inputrect_w    = grid_w,
      inputrect_h    = grid_h
    } );
  
    local point_name = "pnt_"..grid_name;
  
    ObjSet( point_name.."_mid",     { pos_x = 0,                  pos_y = 0                  } );
    ObjSet( point_name.."_top",     { pos_x = 0,                  pos_y = - ( 0.5 * grid_h ) } );
    ObjSet( point_name.."_bot",     { pos_x = 0,                  pos_y =   ( 0.5 * grid_h ) } );
    ObjSet( point_name.."_lft",     { pos_x = - ( 0.5 * grid_w ), pos_y = 0                  } );
    ObjSet( point_name.."_rgt",     { pos_x =   ( 0.5 * grid_w ), pos_y = 0                  } );
    ObjSet( point_name.."_lft_top", { pos_x = - ( 0.5 * grid_w ), pos_y = - ( 0.5 * grid_h ) } );
    ObjSet( point_name.."_rgt_top", { pos_x =   ( 0.5 * grid_w ), pos_y = - ( 0.5 * grid_h ) } );
    ObjSet( point_name.."_lft_bot", { pos_x = - ( 0.5 * grid_w ), pos_y =   ( 0.5 * grid_h ) } );
    ObjSet( point_name.."_rgt_bot", { pos_x =   ( 0.5 * grid_w ), pos_y =   ( 0.5 * grid_h ) } );
  
  end;
  -------------------------------------------------------------------------------------
  function public.GetParamsForGrid( widget, width, height )
  
    local widget_params = _G[ widget ];
  
    local in_params = { W = width, H = height };
  
    local param_char = { "W", "H" };
  
    for i = 1, 2, 1 do
  
      local char  = param_char[ i ];
      local param = in_params[ char ];
  
      local fixed = widget_params[ "GRID_FIXED_"..char ];
  
      if ( fixed ) and ( fixed > 0 ) then
  
        param = fixed;
  
        --DbgTrace( "GRID_"..char.." fixed" );
  
      else
  
        --DbgTrace( "GRID_"..char.." not fixed" );
  
        local border = widget_params[ "GRID_BORDER_"..char ];
  
        if ( border ) then
  
          param = param + border;
  
        end;
  
        local min = widget_params[ "GRID_MIN_"..char ];
  
        if ( min ) and ( min > 0 ) and ( param < min ) then
  
          param = min;
  
        end;
  
        local max = widget_params[ "GRID_MAX_"..char ];
  
        if ( max ) and ( max > 0 ) and ( param > max ) then
  
          param = max;
  
        end;
  
      end;
  
      in_params[ char ] = param;
  
      --DbgTrace( "GRID_"..char.." = "..param );
  
    end;
  
    return { width = in_params[ "W" ], height = in_params[ "H" ] };
  
  end;
  -------------------------------------------------------------------------------------
  function public.InterfaceSetVisible( InterfaceSetVisible, interface_fade )
  
    local objparams = ObjGet( public.originhub );

    local alpha = 0;
    if InterfaceSetVisible then alpha = 1; end;

    if interface_fade then

      ObjSet( public.originhub, { visible = true } );
      ObjStopAnimate( public.originhub, "alp" );
      ObjAnimate( public.originhub, "alp", 0, 0, 
        function () ObjSet( public.originhub, { visible = InterfaceSetVisible } ); end, 
        { 0,0,objparams.alp, 0.6,2, alpha } 
      );

    else 

      ObjSet( public.originhub, { visible = InterfaceSetVisible, alp = alpha } );

    end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.InterfaceSetInput( interface_input )
  
    ObjSet( public.originhub, { input = interface_input } );
  
  end;
  -------------------------------------------------------------------------------------
  function public.GetObjectName( object )

    local underscore = string.find( object, "_" );
    local name = nil;

    if ( underscore ) then
      name = string.sub( object, ( underscore + 1 ) );
    end;

    return name;
  
  end;
  -------------------------------------------------------------------------------------
  function public.GetGameModeDesc()

    --if ng_global.gamemode == 0 or ng_global.gamemode == 1 then 
    if ng_global.gamemode == 0 then 
      return "casual";
    else 
      return "adv"; 
    end;

  end;
--*********************************************************************************************************************
--***function *** Widget *** () end************************************************************************************
--*********************************************************************************************************************
  function private.Init_Widget()
    -------------------------------------------------------------------------------------
    private.widgets = {};  
    --private.widgets[ InterfaceWidget_FrameSubroom ]    = "int_frame_subroom";
    --private.widgets[ InterfaceWidget_Inventory ]       = "int_inventory";
    --private.widgets[ InterfaceWidget_TaskPanel ]       = "int_taskpanel";
    --private.widgets[ InterfaceWidget_TaskHeader ]      = "int_taskheader";
    --private.widgets[ InterfaceWidget_ItemPanel ]       = "int_itempanel";
    --private.widgets[ InterfaceWidget_BtnHint ]         = "int_button_hint";
    --private.widgets[ InterfaceWidget_BtnSkip ]         = "int_button_skip";
    --private.widgets[ InterfaceWidget_BtnInfo ]         = "int_button_info";
    --private.widgets[ InterfaceWidget_BtnReset ]        = "int_button_reset";
    --private.widgets[ InterfaceWidget_BtnGuide ]        = "int_button_guide";
    --private.widgets[ InterfaceWidget_Map ]             = "int_map";
    --private.widgets[ InterfaceWidget_BtnMap ]          = "int_button_map";
    --private.widgets[ InterfaceWidget_BtnMenu ]         = "int_button_menu";
    --private.widgets[ InterfaceWidget_DialogHo ]        = "int_dialog_ho";
    --private.widgets[ InterfaceWidget_Dialog ]          = "int_dialog";
    --private.widgets[ InterfaceWidget_Tutorial ]        = "int_tutorial";
    --private.widgets[ InterfaceWidget_BlackBarText ]    = "int_blackbartext";
    private.widgets[ InterfaceWidget_DialogVideo ]     = "int_dialog_video";
    --private.widgets[ InterfaceWidget_DialogStory ]     = "int_dialog_story";
    --private.widgets[ InterfaceWidget_DialogCharacter ] = "int_dialog_character";
    private.widgets[ InterfaceWidget_Window ]          = "int_window";
    --private.widgets[ InterfaceWidget_Popup ]           = "int_popup";
    --private.widgets[ InterfaceWidget_Effects ]         = "int_effects";
    private.widgets[ InterfaceWidget_Pause ]           = "int_pause";
    --private.widgets[ InterfaceWidget_StrategyGuide ]   = "int_strategy_guide";
    private.widgets[ InterfaceWidget_Custom ]          = "";
    private.widgets[ InterfaceWidget_Top ]             = "";
    --private.widgets[ InterfaceWidget_Transporter ]     = "";
    private.widgets.count = 0;
    -------------------------------------------------------------------------------------
    ObjCreate( InterfaceWidget_Top_Name, "obj" );
    ObjAttach( InterfaceWidget_Top_Name, public.originhub );
    ObjSet( InterfaceWidget_Top_Name, { pos_z = 665 } );
    -------------------------------------------------------------------------------------
    private.custom = {};
    private.custom.widget_count  = 0;
  end;
    -------------------------------------------------------------------------------------
  function public.CustomWidgetAdd( widget_type, widget_path, widget_object, widget_pos_z )

    private.custom.widget_count = private.custom.widget_count + 1;
    private.widgets[ widget_type ] = widget_object;
    widget_pos_z = widget_pos_z or #private.widgets;
    public.WidgetAdd( widget_type, widget_pos_z, widget_path );

  end;
  -------------------------------------------------------------------------------------
  function public.WidgetAdd( widget_type, widget_pos_z, widget_path )
    
    local widget_object = private.widgets[ widget_type ];
    
    widget_path = widget_path or "assets/shared/interface/"..widget_object;
    ModLoad( widget_path );

    if ( widget_type == InterfaceWidget_Window ) and ( not widget_pos_z ) then

      widget_pos_z = 1444;

    end;

    private.widgets.count = private.widgets.count + 1;
    widget_pos_z = widget_pos_z or private.widgets.count;
--if _G[ widget_object ] then
    _G[ widget_object ].Init( widget_pos_z );
    --end
  end;
  -------------------------------------------------------------------------------------
  function public.WidgetRemove( widget_type )

--    local widget_object = private.widgets[ widget_type ];
--
--    _G[ widget_object ].Destroy();
--
--    ObjDelete( widget_object );

    
    local widget_object = private.widgets[ widget_type ];
    if _G[ widget_object ] then
      _G[ widget_object ].Destroy();
      ObjDelete( widget_object );
    end
    
  end;
  -------------------------------------------------------------------------------------
  function public.WidgetSetInput( widget_type, widget_input )

    local objname = private.widgets[ widget_type ];
    ObjSet( objname, { input = widget_input } );

  end;
  -------------------------------------------------------------------------------------
  function public.WidgetGetInput( widget_type )

    local objname = private.widgets[ widget_type ];
    
    return ObjGet( objname ) and ObjGet( objname ).input or false;

  end;
  -------------------------------------------------------------------------------------
  function public.WidgetSetVisible( widget_type, widget_visible, need_fade )

    local objname = private.widgets[ widget_type ];
    local objparams = ObjGet( objname );
    local alpha = 0;
    if objparams then 
      
      if widget_visible then alpha = 1; end;

      if need_fade then

        ObjSet( objname, { visible = true } );
        ObjStopAnimate( objname, "alp" );
        ObjAnimate( objname, "alp", 0, 0, 
          function () ObjSet( objname, { visible = widget_visible } ); end, 
          { 0,0,objparams.alp, 0.5,0, alpha } 
        );

      else 

        ObjSet( objname, { visible = widget_visible, alp = alpha } );

      end;
    end
  end;
--*********************************************************************************************************************
--***function *** Inventory *** () end*********************************************************************************
--*********************************************************************************************************************
  -------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------
  function public.InventoryShowObject( object )

    if _G[ "int_inventory" ] then
      int_inventory.ShowObject( object );
    end;

  end;
  -------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------
  function public.InventoryOpen()

    if _G[ "int_inventory" ] then
      int_inventory.Show( true );
    end;

  end;

  function public.InventoryClose()

    if _G[ "int_inventory" ] then
      int_inventory.Hide( false );
    end;

  end;
  -------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------
  function public.InventoryAutoHideSet( autohide, force )
  
    if _G[ "int_inventory" ] then
      int_inventory.SetAutohide( autohide --[[bool value]], force );
    end;
    
    if _G[ "int_button_lock" ] then
      int_button_lock.SetLock( autohide );
    end;
  
  end;
  
  function public.InventoryAutoHideGet()
  
    if _G[ "int_inventory" ] then
      return int_inventory.GetAutohide();
    end;

    return true;
  
  end;
  
  function public.InventoryAutoHideSave()
  
    ng_global.inventory_autohide = public.InventoryAutoHideGet();

  end;
  
  function public.InventoryAutoHideLoad()
  
    public.InventoryAutoHideSet( ng_global.inventory_autohide, true );
  
  end;
  -------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------
  local prevObj = ""
  function public.InventoryItemAdd( item_name, object_name, func_end )

    if object_name and object_name ~= "" and object_name == prevObj then
      ld.LogTrace( "Error! Кто то дважды подобрал объект ", object_name );
      return
    else
      prevObj = object_name
    end

    object_name = object_name or "";
  
    if ( _G[ "cheater" ] ) then
      if ( object_name ~= "" ) and ( cheater.is_progress_executing_now ) then
  
        ObjDelete( object_name );
        object_name = "";
  
      end;
    end;
  
    if _G[ "int_inventory" ] then
      int_inventory.AddObject( item_name, object_name, func_end );
      common_impl.DeleteHintFx()-- очищение частиц хинта
    end;
  
  end;
  -------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------
  function public.InventoryItemRemove( item_name )
  
    if _G[ "int_inventory" ] then
      int_inventory.DeleteObject( item_name );
    end;
  
  end;
--*********************************************************************************************************************
--***function *** Task Panel *** () end********************************************************************************
--*********************************************************************************************************************
  private.taskpanel_countdown = 0;
  -------------------------------------------------------------------------------------
  function public.TaskPanelShow( ho_tasks,ho_name )

    private.taskpanel_countdown = 0;
  
    public.WidgetSetInput( InterfaceWidget_Inventory, false );
    public.EnableZoom(true);
    
    if ( not _G[ "int_taskheader" ] ) then
      public.WidgetSetVisible( InterfaceWidget_Inventory, false, true );
    end;
  
    local ho_name = ho_name or public.GetObjectName( GetCurrentRoom() );
    local ho_progress = ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ];
    
    if (ng_global.currentprogress == "std" or ng_global.currentprogress == "ext") and not _G[GetCurrentRoom()].mini_ho then
      interface_impl.StartHoAchievements( ho_name );
    end
    for i = 1, #ho_tasks, 1 do
  
      local task_name = ho_tasks[ i ][ "name" ];
  
      if ( ho_progress.start == 1 ) then
  
        if ( ho_tasks[ i ][ "marked" ] == 1 ) then

          if ( ho_progress.unmark[ task_name ].done == 1 ) then
  
            ho_tasks[ i ][ "marked" ] = 0;
  
          end;
  
        end;
  
        for j = 1, #ho_progress.found, 1 do
  
          if ( task_name == ho_progress.found[ j ][ "task" ] ) then
  
            ho_tasks[ i ][ "count" ] = ho_tasks[ i ][ "count" ] - 1;
  
          end;
  
        end;
  
      end;
  
      ho_tasks[ i ][ "name" ] = public.TaskPanelGetTaskId( ho_name, task_name );
      
      private.taskpanel_countdown = private.taskpanel_countdown + ho_tasks[ i ][ "count" ];
      ho_progress.start = 1;

    end;

    if ( not _G[ "int_taskheader" ] ) then
  
      if _G[ "int_taskpanel" ] then int_taskpanel.Show( ho_tasks ); end;
      
    else
      
      if _G[ "int_taskheader" ] then int_taskheader.Show(); end;
      if _G[ "int_inventory"  ] then int_inventory.ShowForTaskHeader(); end;
      if _G[ "int_taskpanel"  ] then int_taskpanel.ShowForTaskHeader( ho_tasks ); end;
  
    end;  
  end;
  -------------------------------------------------------------------------------------
  function public.TaskPanelHide()
  
    --local ho_name = public.GetObjectName( GetCurrentRoom() );
    --local ho_progress = ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ];
  
    --if ( ho_progress.done == 0 ) then
    --if ( not public.taskpanel.already_hide ) then
  
      public.WidgetSetInput( InterfaceWidget_Inventory, true );
      public.EnableZoom(false);

      if ( not _G[ "int_taskheader" ] ) then
        public.WidgetSetVisible( InterfaceWidget_Inventory, true, true );
      end;
  
      if ( not _G[ "int_taskheader" ] ) then
  
        if _G[ "int_taskpanel" ] then int_taskpanel.Hide(); end;
  
      else
        
        if _G[ "int_taskheader" ] then int_taskheader.Hide(); end;
        if _G[ "int_inventory"  ] then int_inventory.HideForTaskHeader(); end;
        if _G[ "int_taskpanel"  ] then int_taskpanel.HideForTaskHeader(); end;
  
      end;
  
    --end;
    --end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.TaskPanelShowTextPanel(ho_cut_name)

    if _G[ "int_taskpanel_impl" ] then int_taskpanel_impl.ShowTextPanel(ho_cut_name); end;

  end
  -------------------------------------------------------------------------------------    
  function public.TaskPanelHideTextPanel(ho_cut_name)

    if _G[ "int_taskpanel_impl" ] then int_taskpanel_impl.HideTextPanel(ho_cut_name); end;

  end
  -------------------------------------------------------------------------------------
  function public.TaskPanelTaskAdd( ho_tasks, task_name, task_count, task_marked, ho_hint, group )
  
    local task_table = { name = task_name, count = task_count, marked = task_marked, hint = ho_hint };
    
    --group must be like: { group_name = "group_1", func_start = "some_anim_func_what_need_run_after_objs_group_found(f_end)", func_end = "some_end_func_what_need_run_in_preopen" }
    if group then
    if type(group) =="table" then
      if group["group_name"] then task_table["group"] = group end;  
    end
    end
    
    table.insert( ho_tasks, task_table );

  end;
  -------------------------------------------------------------------------------------
  function public.TaskPanelTaskComplete( ho_name, task_name, object_name, no_anim )
    
    private.taskpanel_countdown=private.taskpanel_countdown-1;
    if ( private.taskpanel_countdown == 0 ) then

      local ho_name = ho_name or public.GetObjectName( GetCurrentRoom() );

      ld.LockCustom( "TaskPanelTaskComplete", 1 )
      ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].done = 1;
      if public.GetObjectName( GetCurrentRoom() )==ho_name and _G[GetCurrentRoom()].mini_ho ~= ho_name then
        ng_global.progress[ ng_global.currentprogress ].common.currentroom = game.relations[ "ho_"..ho_name ].exitroom;
        _G[ "ho_"..ho_name ].HoComplete();        
      end
      

  
    end;
    
    local task_id = public.TaskPanelGetTaskId( ho_name, task_name );
    
    if _G[ "int_taskpanel" ] then
      int_taskpanel.CompleteTask( task_id, object_name, no_anim );
    else
      ld.LogTrace( "func interface.TaskPanelTaskComplete need int_taskpanel!" );
    end;
      
  end;
  -------------------------------------------------------------------------------------
  function public.TaskPanelSetPosTaskByRule( N )

    if _G[ "int_taskpanel_impl" ] then 
      int_taskpanel_impl.SetPosTaskByRule( N )
    end

  end
  -------------------------------------------------------------------------------------
  function public.TaskPanelShowTaskLast(task_params)

    if _G[ "int_taskpanel_impl" ] then 
      int_taskpanel_impl.ShowTaskLast( task_params )
    end

  end
  -------------------------------------------------------------------------------------
  function public.TaskPanelGetTaskId( ho_name, task_name )
  
    local task_id = "tsk_"..ho_name.."_"..task_name;
    return task_id;
  
  end;
  -------------------------------------------------------------------------------------
  function public.TaskPanelHoHintShow()
  
    if _G[ "int_taskpanel" ] then int_taskpanel.ShowHoHint(); end;
  
  end;
  -------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------
  function public.TaskPanelTaskUnmark( ho_name, task_name )

    local task_id = public.TaskPanelGetTaskId( ho_name, task_name );
    
    if _G[ "int_taskpanel" ] then
      int_taskpanel.SetTaskMark( task_id, 0 );
    end;

  end;
  -------------------------------------------------------------------------------------
  function public.TaskPanelTaskMark( ho_name, task_name )

    local task_id = public.TaskPanelGetTaskId( ho_name, task_name );

    if _G[ "int_taskpanel" ] then
      int_taskpanel.SetTaskMark( task_id, 1 );
    end;

  end;
--*********************************************************************************************************************
--***function *** Item Panel *** () end********************************************************************************
--*********************************************************************************************************************
  function public.ItemShowObject( object )

    if _G[ "int_itempanel" ] then
      int_itempanel.ShowObject( object );
    end;

  end;

  function public.ItemPanelItemAdd( ho_items, item_name,ho_hint,ho_name ) 
  
    local ho_name = public.GetObjectName( GetCurrentRoom() );
    if _G[GetCurrentRoom()].mini_ho then ho_name = _G[GetCurrentRoom()].mini_ho end
    if interface.GetCurrentComplexInv() ~= "" then 
      if ng_global.currentprogress == "std" and  _G["level_inv"].mini_ho then 
        ho_name = _G["level_inv"].mini_ho 
      elseif ng_global.currentprogress == "ext" and _G["levelext_inv"].mini_ho  then
        ho_name = _G["levelext_inv"].mini_ho 
      end
    end 
    local ho_progress = ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ];
  
    local item_found = false;
  
    for i = 1, #ho_progress.found, 1 do
  
      if ( string.find( ho_progress.found[ i ][ "item" ], item_name ) ) then
  
        item_found = true;
        break;
  
      end;
  
    end;
  
    if ( not item_found ) then
  
      local item_object_name = "itm_"..ho_name.."_"..item_name;
      local hint_object_name = ho_hint or "obj_"..ho_name.."_"..item_name;
  
      local item_table = { name = item_object_name, hint = hint_object_name };
  
      table.insert( ho_items, item_table );

    end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.ItemPanelShow( ho_items )
    local ho_name = public.GetObjectName( GetCurrentRoom() );
    if _G[GetCurrentRoom()].mini_ho then ho_name = _G[GetCurrentRoom()].mini_ho end
      
    public.itempanel = {};
    public.itempanel.countdown = #ho_items;

    public.WidgetSetInput( InterfaceWidget_Inventory, false );
    public.EnableZoom(true);
    
    if ( not _G[ "int_taskheader" ] ) then
      public.WidgetSetVisible( InterfaceWidget_Inventory, false, true );
    end;

    
    if (ng_global.currentprogress == "std" or ng_global.currentprogress == "ext" ) and not _G[GetCurrentRoom()].mini_ho then
      interface_impl.StartHoAchievements( ho_name );
    end
    if _G[ "int_itempanel" ] then int_itempanel.Show( ho_items ); end;

  end;
  -------------------------------------------------------------------------------------
  function public.ItemPanelHide()
  
    public.WidgetSetInput( InterfaceWidget_Inventory, true );
    public.EnableZoom(false);

     if ( not _G[ "int_taskheader" ] ) then
        public.WidgetSetVisible( InterfaceWidget_Inventory, true, true );
      end;

  
    if _G[ "int_itempanel" ] then int_itempanel.Hide(); end;
  
  end;
  
  -------------------------------------------------------------------------------------
  function public.ItemPanelItemRemove( item_name )
  
    if _G[ "int_itempanel" ] then
      int_itempanel.DeleteObject( item_name );
    end;
  
    public.itempanel.countdown = public.itempanel.countdown - 1;
  
    if ( public.itempanel.countdown == 0 ) then
  
      local ho_name = public.GetObjectName( GetCurrentRoom() );
      if _G[GetCurrentRoom()].mini_ho then ho_name = _G[GetCurrentRoom()].mini_ho end
      if interface.GetCurrentComplexInv() ~= "" then 
        if ng_global.currentprogress == "std" and  _G["level_inv"].mini_ho then 
          ho_name = _G["level_inv"].mini_ho 
        elseif ng_global.currentprogress == "ext" and _G["levelext_inv"].mini_ho  then
          ho_name = _G["levelext_inv"].mini_ho 
        end
      end 
      
      ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].done = 1;
      if not _G[GetCurrentRoom()].mini_ho and interface.GetCurrentComplexInv() == "" then
        ng_global.progress[ ng_global.currentprogress ].common.currentroom = game.relations[ "ho_"..ho_name ].exitroom;
      else
        common_impl.DialogHo_Show()
      end
      if _G[ "ho_"..ho_name ] then
        _G[ "ho_"..ho_name ].HoComplete();
      end
    else 
      --DbgTrace(public.itempanel.countdown)
    end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.ItemPanelHoHintShow()
  
    if _G[ "int_itempanel" ] then
      int_itempanel.ShowHoHint();
    end;
  
  
  end;
  -------------------------------------------------------------------------------------
  function public.ItemPanelTryToComplete()
  
    if _G[ "int_itempanel" ] then
      int_itempanel.TryCompleteHo();
    end;
  
  end;
--*********************************************************************************************************************
--***function *** Button Hint *** () end*******************************************************************************
--*********************************************************************************************************************
  function public.ButtonHintShow()
  
    if _G[ "int_button_hint" ] then int_button_hint.Show(); end;

  end;
  -------------------------------------------------------------------------------------
  function public.ButtonHintHide()
  
    if _G[ "int_button_hint" ] then
      int_button_hint.Hide();
    end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.ButtonHintReload( reload_time )
  
    if _G[ "int_button_hint" ] then int_button_hint.Reload( reload_time ); end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.ButtonHintGetTime()
  
    if _G[ "int_button_hint" ] then
      return int_button_hint.GetTime();
    end;
    
    return 0;
    
  end;
--*********************************************************************************************************************
--***function *** Button Skip *** () end*******************************************************************************
--*********************************************************************************************************************
  function public.ButtonSkipShow()
  
    if _G[ "int_button_skip" ] then int_button_skip.Show(); end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.ButtonSkipHide()
  
    if _G[ "int_button_skip" ] then int_button_skip.Hide(); end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.ButtonSkipReload( reload_time, reload_multiplier )
  
    reload_multiplier = reload_multiplier or 1;

    if _G[ "int_button_skip" ] then int_button_skip.Reload( reload_time, reload_multiplier ); end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.ButtonSkipGetTime()
    
    if _G[ "int_button_skip" ] then
      return int_button_skip.GetTime();
    end;
    
    return 0;


  
  end;
--*********************************************************************************************************************
--***function *** Button Info *** () end*********************************************************************************
--*********************************************************************************************************************
  function public.ButtonInfoUpdate()
  
    if _G[ "int_button_info" ] then int_button_info.UpdateInfo(); end;

  end;
  -------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------
  function public.ButtonInfoShow( minigame_name )
  
    if _G[ "int_button_info" ] then int_button_info.Show( minigame_name ); end;

  end;
  -------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------
  function public.ButtonInfoHide()
  
    if _G[ "int_button_info" ] then int_button_info.Hide(); end;
  
    public.DialogHide();
  
  end;
--*********************************************************************************************************************
--***function *** Button Reset *** () end******************************************************************************
--*********************************************************************************************************************
  function public.ButtonResetShow()
  
    if _G[ "int_button_reset" ] then int_button_reset.Show(); end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.ButtonResetHide()
  
    if _G[ "int_button_reset" ] then int_button_reset.Hide(); end;
  
  end;
--*********************************************************************************************************************
--***function *** Black Bar Text *** () end****************************************************************************
--*********************************************************************************************************************
  function public.BBTShow( bbt_text, bbt_extended )
  
    bbt_extended = bbt_extended or {};
  
    if _G[ "int_blackbartext" ] then
      int_blackbartext.Show( bbt_text, bbt_extended );
    end;
  
  end;
--*********************************************************************************************************************
--***function *** Dialog *** () end************************************************************************************
--*********************************************************************************************************************
  function public.DialogShow( dlg_text, dlg_pos_x, dlg_pos_y, params_extended )
  
    dlg_pos_x = dlg_pos_x or 512;
    dlg_pos_y = dlg_pos_y or 384;
      
    if _G[ "int_dialog" ] then
      int_dialog.Show( dlg_text, dlg_pos_x, dlg_pos_y, params_extended );
    end;

  end;
  -------------------------------------------------------------------------------------
  function public.DialogHide( extended )
        
    if _G[ "int_dialog" ] then
      int_dialog.Hide( extended );
    end;
  
  end;
--*********************************************************************************************************************
--***function *** Dialog Ho *** () end*********************************************************************************
--*********************************************************************************************************************
  function public.DialogHoShow(ho_name)
  
    local ho_name = ho_name or public.GetObjectName( GetCurrentRoom() );
  
    if _G[GetCurrentRoom()].mini_ho then ho_name = _G[GetCurrentRoom()].mini_ho end
    
    local ho_win_item = "spr_"..ho_name.."_win";

    if _G[ "int_dialog_ho" ] then
      int_dialog_ho.Show( ho_win_item );
    end;
  
  end;
--*********************************************************************************************************************
--***function *** Dialog Video *** () end******************************************************************************
--*********************************************************************************************************************
  function public.DialogVideoShow( object_name, block_input, skip_func, skip_time )
  
    block_input  = block_input or 0;
    skip_trigger = skip_trigger or "";
    skip_time    = skip_time or 0;
  
    public.WidgetSetInput( InterfaceWidget_Inventory, false );
  
    if _G[ "int_dialog_video" ] then
      int_dialog_video.Show( object_name, block_input, skip_func, skip_time );
    end;

  end;
  -------------------------------------------------------------------------------------
  function public.DialogVideoHide()
  
    public.WidgetSetInput( InterfaceWidget_Inventory, true );

    public.DialogVideoSubtitleHide()
  
    ld_impl.VideoSubtitleVocStop()
  
    if _G[ "int_dialog_video" ] then int_dialog_video.Hide(); end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.DialogVideoSubtitleShow( subtitle_text_id )
  
    if _G[ "int_dialog_video" ] then
      int_dialog_video.ShowSubtitle( "", { text_id = subtitle_text_id, show = 1 } );
    end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.DialogVideoSubtitleHide()
  
    if _G[ "int_dialog_video" ] then int_dialog_video.HideSubtitle(); end;
  
  end;
--*********************************************************************************************************************
--***function *** Dialog Character *** () end**************************************************************************
--*********************************************************************************************************************
  function public.DialogCharacterShow( object_name, max_number, trigger_click, trigger_skip, func_after_frase, answer, end_trigger )
    if _G[ "int_dialog_character" ] then
      common_impl.Show( object_name, max_number, trigger_click, trigger_skip, func_after_frase, answer, end_trigger );
    end;
  end;
  -------------------------------------------------------------------------------------
  function public.DialogCharacterHide()
    if _G[ "int_dialog_character" ] then 
      public.DialogCharacterClearAvatar()
      int_dialog_character.Hide(); 
    end;
  end;
  -------------------------------------------------------------------------------------
  function public.DialogCharacterShowAvatar(character, show_or_hide, fast)
    if _G[ "int_dialog_character_impl" ] then
      int_dialog_character_impl.ShowAvatar(character, show_or_hide, fast )
    end
  end
  -------------------------------------------------------------------------------------
  function public.DialogCharacterClearAvatar()
    if _G[ "int_dialog_character_impl" ] then
      int_dialog_character_impl.ClearAvatar()
    end
  end
  -------------------------------------------------------------------------------------
  --function public.DialogCharacterShow( object_name, char_text_id, trigger_click, trigger_skip, pos_x, pos_y )
  --
  --  if _G[ "int_dialog_character" ] then
  --    int_dialog_character.Show( char_text_id, object_name, trigger_click, trigger_skip, pos_x, pos_y );
  --  end;
  --  public.WidgetSetInput( InterfaceWidget_Inventory, false );
  --
  --end;
  ---------------------------------------------------------------------------------------
  --function public.DialogCharacterHide()
  --
  --  if _G[ "int_dialog_character" ] then int_dialog_character.Hide(); end;
  --  public.WidgetSetInput( InterfaceWidget_Inventory, true );
  --
  --end;
--*********************************************************************************************************************
--***function *** Dialog Story *** () end******************************************************************************
--*********************************************************************************************************************
  function public.DialogStoryShow( object_name, story_text_id, click_func, skip_func, skip_delay_time, show_character )

    skip_delay_time = skip_delay_time or 0;

    show_character = show_character or 0;

    public.WidgetSetInput( InterfaceWidget_Inventory, false );

    if _G[ "int_dialog_story" ] then
      int_dialog_story.Show( story_text_id, object_name, click_func, skip_func, skip_delay_time, show_character );
    end;

  end;
  -------------------------------------------------------------------------------------
  function public.DialogStoryHide()

    public.WidgetSetInput( InterfaceWidget_Inventory, true );

    if _G[ "int_dialog_story" ] then int_dialog_story.Hide(); end;

  end;
--*********************************************************************************************************************
--***function *** Frame Subroom *** () end*****************************************************************************
--*********************************************************************************************************************
  function public.ConstructFrameSubroom( frame_w, frame_h, extended )
  
    frame_w = frame_w or 0;
    frame_h = frame_h or 0;

    if _G[ "int_frame_subroom" ] then
      int_frame_subroom.Construct( frame_w, frame_h, extended );
    end;

  end;
  --------------------------------------------------------------------
  function public.ShowFrameSubroom( alpha_anm_table, pos_xy_anm_table, scale_xy_anm_table )
  
    if _G[ "int_frame_subroom" ] then
      int_frame_subroom.Show( alpha_anm_table, pos_xy_anm_table, scale_xy_anm_table );
    end;

  end;
  --------------------------------------------------------------------
  function public.HideFrameSubroom( alpha_anm_table, pos_xy_anm_table, scale_xy_anm_table  )
    
    if _G[ "int_frame_subroom" ] then
      int_frame_subroom.Hide( alpha_anm_table, pos_xy_anm_table, scale_xy_anm_table );
    end;

  end;
  --------------------------------------------------------------------
  function public.BlockSubroomClose( bvalue )
    
    if _G[ "int_frame_subroom" ] then
      int_frame_subroom.BlockClose( bvalue );
    end;

  end;
--*********************************************************************************************************************
--***function *** Window *** () end************************************************************************************
--*********************************************************************************************************************
  function public.WindowShow( module_path, module_name, objname, func, pos_beg, pos_end )  

    pos_beg = pos_beg or { 512, 384 };
    pos_end = pos_end or { 512, 384 };  
    if _G[ "int_window" ] then
      int_window.Show( { window_name = objname, window_module_path = module_path, window_module_name = module_name, func = func, window_pos_beg = pos_beg, window_pos_end = pos_end } );
    end;  

  end;
  --------------------------------------------------------------------
  function public.WindowHide( name )  

    if _G[ "int_window" ] then
      int_window.Hide( { window_name = name } );    
    end;  

  end;
--*********************************************************************************************************************
--***function *** Popup *** () end*************************************************************************************
--*********************************************************************************************************************
  function public.PopupShow( popup_text, popup_param0, popup_param1, popup_param2, popup_param3, popup_param4 )

    popup_param0 = popup_param0 or "";
    popup_param1 = popup_param1 or "";
    popup_param2 = popup_param2 or "";
    popup_param3 = popup_param3 or "";
    popup_param4 = popup_param4 or "";

    if _G[ "int_popup" ] then
      int_popup.Show( popup_text, popup_param0, popup_param1, popup_param2, popup_param3, popup_param4 );
    end;
    
  end;
  -------------------------------------------------------------------------------------
  function public.PopupHide()

    if _G[ "int_popup" ] then
      int_popup.Hide();
    end;

  end;
--*********************************************************************************************************************
--***function *** Tutorial *** () end**********************************************************************************
--*********************************************************************************************************************
  public.tutorial_arrows_show = {};
  -------------------------------------------------------------------------------------
  function public.TutorialShow( dlg_text, block_input, dlg_pos_x, dlg_pos_y, arrows, force )
  
    block_input = block_input or false;
  
    dlg_pos_x = dlg_pos_x or 512;
    dlg_pos_y = dlg_pos_y or 384;
  
    if ( not force ) and ( _G[ "int_tutorial" ] and int_tutorial.IsActive() ) then
  
      public.TutorialHide();
  
      local func_show = function ()

        public.TutorialShow( dlg_text, block_input, dlg_pos_x, dlg_pos_y, arrows, force );

      end;
  
      ObjSet( "tmr_int_tutorial",
      {
        time    = 0.1,
        endtrig = func_show,
        playing = 1
      } );
  
    else
  
      local tutorial_table = { text = dlg_text, pos_x = dlg_pos_x, pos_y = dlg_pos_y, input = block_input };
  
      local arrows_out = arrows or public.tutorial_arrows_show[ dlg_text ];
  
      if ( arrows_out ) then
    
        tutorial_table[ "arrows" ] = arrows_out;
  
        public.tutorial_arrows_show[ dlg_text ] = nil;
  
      end;
  
      if _G[ "int_tutorial" ] then
        int_tutorial.Show( dlg_text, block_input, { x = dlg_pos_x, y = dlg_pos_y }, arrows_out );
      end;

      if ( force ) then

        if _G[ "int_tutorial" ] then
          int_tutorial.ForceShowEnd();
        end;

      end;
  
    end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.TutorialHide( force )
  
    if _G[ "int_tutorial" ] then
      int_tutorial.Hide();
    end;

    if ( force ) then

      if _G[ "int_tutorial" ] then
        int_tutorial.ForceHideEnd();
      end;

    end;
  
  end;
--*********************************************************************************************************************
--***function *** Panel Notification *** () end************************************************************************
--*********************************************************************************************************************
  function public.PanelNotificationAdd( pos_z )

    InterfaceWidget_PanelNotification = "InterfaceWidget_PanelNotification";
    public.CustomWidgetAdd( InterfaceWidget_PanelNotification, "assets/shared/interface/int_panel_notification", "int_panel_notification", pos_z );

  end;
  --------------------------------------------------------------------
  function public.PanelNotificationShow( notification_type, notification_data )

    if _G[ "int_panel_notification" ] then
      int_panel_notification.Show( notification_type, notification_data );
    end;

  end;
  --------------------------------------------------------------------
  function public.PanelNotificationHide()

    if _G[ "int_panel_notification" ] then int_panel_notification.Hide(); end;

  end;
--*********************************************************************************************************************
--***function *** Cheater *** () end***********************************************************************************
--*********************************************************************************************************************
  function public.CheaterStep( room_name )
  
    if ( _G[ "cheater" ] ) then
  
      cheater.Step();
  
    end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.CheaterUpdateRoom( room_name )
  
    if ( _G[ "cheater" ] ) then
  
      cheater.UpdateRoom( room_name );
  
    else
  
      --DbgTrace( "На данный момент триггер инициализации читера еще не загружен." );
  
    end;
  
  end;
  -------------------------------------------------------------------------------------
  function public.CheaterUpdateSubroom( subroom_name )
  
    if ( _G[ "cheater" ] ) then
  
      cheater.StartUpdateSubroom( subroom_name );
  
    end;
  
  end;
--*********************************************************************************************************************
--***function *** Strategy Guide *** () end****************************************************************************
--*********************************************************************************************************************
  function public.StrategyGuideShow( strguide_page )

    strguide_page = strguide_page or ng_global.strategy_guide_page or - 1;

    if _G[ "int_strategy_guide" ] then int_strategy_guide.Show( strguide_page ); end;

  end;
--*********************************************************************************************************************
--***function *** Map *** () end***************************************************************************************
--*********************************************************************************************************************
  function public.MapShow()
  
    if _G[ "int_map" ] then int_map.Show(); end;
  
  end;
--*********************************************************************************************************************
--***function *** Button Lock *** () end*******************************************************************************
--*********************************************************************************************************************
  function public.ButtonLockAdd( pos_z )
  
    InterfaceWidget_BtnLock = "InterfaceWidget_BtnLock";
    public.CustomWidgetAdd( InterfaceWidget_BtnLock, "assets/shared/interface/int_button_lock", "int_button_lock", pos_z );

  end;
--*********************************************************************************************************************
--***function *** Cube *** () end*******************************************************************************
--*********************************************************************************************************************
  function public.CubeAdd( pos_z )
  
    InterfaceWidget_Cube = "InterfaceWidget_Cube";
    public.CustomWidgetAdd( InterfaceWidget_Cube, "assets/interface/int_cube", "int_cube", pos_z );

  end;
--*********************************************************************************************************************
--***function *** Complex Inv *** () end************************************************************************
--*********************************************************************************************************************
  function public.ComplexInvAdd( pos_z )

    InterfaceWidget_ComplexInv = "InterfaceWidget_ComplexInv";
    public.CustomWidgetAdd( InterfaceWidget_ComplexInv, "assets/shared/interface/int_complex_inv", "int_complex_inv", pos_z );

  end;
  --------------------------------------------------------------------
  function public.GetCurrentComplexInv()

    if _G[ "int_complex_inv" ] then
      if int_complex_inv.IsOnScreen() then
        return int_complex_inv.GetCurrentName();
      end;
    end;
    return "";

  end;
  --------------------------------------------------------------------
  function public.ComplexInvShow( objname )

    if _G[ "int_complex_inv" ] then
      int_complex_inv.Show( objname );
    end;

  end;
  --------------------------------------------------------------------
  function public.ComplexInvHide()

    if _G[ "int_complex_inv" ] then
      int_complex_inv.Hide();
    end;

  end;
--*********************************************************************************************************************
--***function *** Mouse Over *** () end********************************************************************************
--*********************************************************************************************************************
  public.MOUSE_OVER_ANIM_TIME = 0.3;
  ------------------------------------------------------------------------------------
  function public.ButtonMouseEnterAnim( sender, anim, focus )

    SetCursor( CURSOR_HAND );

    local obj = focus or string.format( "spr_%s_focus", public.GetObjectName( sender ) );
    local alp = ObjGet( obj ).alp;
    local tme = ( 1 - alp ) * public.MOUSE_OVER_ANIM_TIME;

    ObjAnimate( obj, "alp", 0, 0, "",
    {
      0.0, 2, alp,
      tme, 2, 1
    } );

  end;
  ------------------------------------------------------------------------------------
  function public.ButtonMouseLeaveAnim( sender, anim, focus )

    SetCursor( CURSOR_DEFAULT );

    local obj = focus or string.format( "spr_%s_focus", public.GetObjectName( sender ) );
    local alp = ObjGet( obj ).alp;
    local tme = alp * public.MOUSE_OVER_ANIM_TIME;

    ObjAnimate( obj, "alp", 0, 0, "",
    {
      0.0, 1, alp,
      tme, 1, 0
    } );

  end;
--*********************************************************************************************************************

  function public.EnableHoZoom( obj_name, param, only_object )

    if ( ( GetPlatform() == "ios" ) or ( GetPlatform() == "android" ) ) then

      if (IsIphone() == true) then
        if (param == true) then
          MsgSend( Command_Level_SetZoom, { zoom = false } );
        else
          MsgSend( Command_Level_SetZoom, { zoom = true } );
        end;
      else
        MsgSend( Command_Level_SetZoom, { zoom = false } );
      end;
      local obj_zoom        = obj_name;
      local zoom_params     = {};
      zoom_params.candrag   = param;
      zoom_params.canzoom   = param;

      if ( ObjGet(obj_zoom) ) then
         ObjSet( obj_zoom, zoom_params );
      end;
    else
      if ( only_object == true ) then
        MsgSend( Command_Level_SetZoom, { zoom = false } );
      end;
    end;
  end;

  function public.EnableZoom( param )

    if ( ( GetPlatform() == "ios" ) or ( GetPlatform() == "android" ) ) then
      if (IsIpad() == true) then
        MsgSend( Command_Level_SetZoom, { zoom = param } );
      end;
    else
      MsgSend( Command_Level_SetZoom, { zoom = param } );
    end;

  end;
--*********************************************************************************************************************
