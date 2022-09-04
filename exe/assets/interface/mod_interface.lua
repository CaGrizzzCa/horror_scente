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

  InterfaceWidget_DialogVideo      = "InterfaceWidget_DialogVideo"
  InterfaceWidget_Window           = "InterfaceWidget_Window"
  InterfaceWidget_Pause            = "InterfaceWidget_Pause"
  InterfaceWidget_Top              = "InterfaceWidget_Top"
  InterfaceWidget_Transporter      = "InterfaceWidget_Transporter"
  InterfaceWidget_Custom           = "InterfaceWidget_Custom"
  InterfaceWidget_Top_Name         = "int_top"

end;
--*********************************************************************************************************************
--***function *** Interface *** () end*********************************************************************************
--*********************************************************************************************************************
  function public.LoadImplementation( impl_name, impl_module_name )

    local core_object_name = "int_"..impl_name;
    local impl_object_name = core_object_name.."_impl";

    impl_module_name = impl_module_name or impl_object_name;
    ld.LogTrace("public.LoadImplementation",core_object_name, impl_module_name, impl_object_name )

    ModLoad( "assets/interface/"..impl_module_name );

    _G[ impl_object_name ].Init();

    ObjAttach( impl_object_name, core_object_name );

  end;
--*********************************************************************************************************************
--***function *** Widget *** () end************************************************************************************
--*********************************************************************************************************************
  function private.Init_Widget()
    -------------------------------------------------------------------------------------
    private.widgets = {}
    private.widgets[ InterfaceWidget_DialogVideo ]     = "int_dialog_video"
    private.widgets[ InterfaceWidget_Window ]          = "int_window"
    private.widgets[ InterfaceWidget_Pause ]           = "int_pause"
    private.widgets[ InterfaceWidget_Custom ]          = ""
    private.widgets[ InterfaceWidget_Top ]             = ""
    private.widgets[ InterfaceWidget_Transporter ]     = ""
    private.widgets.count = 0;
    -------------------------------------------------------------------------------------
    ObjCreate( InterfaceWidget_Top_Name, "obj" )
    ObjAttach( InterfaceWidget_Top_Name, public.originhub )
    ObjSet( InterfaceWidget_Top_Name, { pos_z = 665 } )
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
    if _G[ widget_object ] then
      _G[ widget_object ].Init( widget_pos_z );
    end
  end;
  -------------------------------------------------------------------------------------
  function public.WidgetRemove( widget_type )

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
