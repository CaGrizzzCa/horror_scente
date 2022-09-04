-- name=int_panel_notification
--******************************************************************************************
function public.Init( pos_z )

  interface.LoadImplementation( "panel_notification" );
  ObjAttach( "int_panel_notification", interface.originhub );
  ObjAttach( "int_panel_notification_storage_impl", "int_panel_notification_storage" );
  ObjSet( "int_panel_notification", { pos_z = pos_z } );
  private.event_anim_end = {};
  MsgSubscribe( Command_Interface_UpdateTextures, private.WideScreenUpdate );
  MsgSubscribe( Command_Level_Pause, int_panel_notification_impl.PauseLevel );

  private.queue = {};
  private.current_type = "";
  private.state = "hide";

end;
--******************************************************************************************
function public.Destroy()

  MsgUnsubscribe( Command_Interface_UpdateTextures, private.WideScreenUpdate );
  MsgUnsubscribe( Command_Level_Pause, int_panel_notification_impl.PauseLevel );

end;
--******************************************************************************************
function public.Hide( hide_params )

  if private.state == "show" then

    private.state = "hiding";

    ObjSet( "int_panel_notification", { input = false } );

    local event_id = "hide";
    private.event_anim_end[ event_id ] = hide_params;
    int_panel_notification_impl.HideAnim( event_id );

  end;

end;
--******************************************************************************************
function public.EventAnimEnd( event_id )

  local event_params = private.event_anim_end[ event_id ];

  ----------------------------------------------------------------------------------
  if ( event_id == "show" ) then

    if private.state == "showing" then

      private.state = "show";
      ObjSet( "int_panel_notification", { input = true } );
      private.TimerStart();

    end;

  ----------------------------------------------------------------------------------
  elseif ( event_id == "hide" ) then

    if private.state == "hiding" then

      private.state = "hide";
      ObjSet( "int_panel_notification", { input = false, visible = false, active = false } );
      local notification_current = "obj_int_panel_notification_"..private.current_type;
      ObjAttach( notification_current, "int_panel_notification_storage" );
      private.ShowFromQueue();

    end;

  end;
  ----------------------------------------------------------------------------------

end;
--******************************************************************************************
function public.MouseDown()

  private.TimerStop();
  public.Hide();

  MsgSend( Event_PanelNotification_Click, { notification_type = int_panel_notification_impl.type_nfction } );

end
--******************************************************************************************
function public.Show( notification_type, notification_data )

  if ( private.state == "hide" ) then

    private.state = "showing";

    --DbgTrace( "Show "..notification_type.." "..( notification_data.text ) );
    private.Set( notification_type, notification_data );
    private.Show();

  else

    --DbgTrace( "AddInQueue:" );
    private.AddInQueue( { type = notification_type, data = notification_data } );
    --local str = ""
    --for i = 1, #private.queue do
    --  str = str.."\n "..( private.queue[ i ].type ).." "..( private.queue[ i ].data.text );
    --end;
    --DbgTrace(str);

  end;

end;
--******************************************************************************************
function private.Show( show_params )

  ObjSet( "int_panel_notification", { active = true, visible = true, input = false } );

  local event_id = "show";
  private.event_anim_end[ event_id ] = show_params;
  int_panel_notification_impl.ShowAnim( event_id );

end;
--******************************************************************************************
function private.AddInQueue( notification_params )

  table.insert( private.queue, notification_params );

end;
--******************************************************************************************
function private.Set( notification_type, notification_data )

  private.current_type = notification_type;

  local notification_current = "obj_int_panel_notification_"..( private.current_type );

  ObjAttach( notification_current, "int_panel_notification_impl_root" );
  int_panel_notification_impl.SetExtended( notification_type, notification_data );

end;
--******************************************************************************************
function private.ShowFromQueue()

  if ( #private.queue > 0 ) then

    if ( private.state == "hide" ) then

      private.state = "showing";

      private.is_on_screen = true;

      local notification_params = table.remove( private.queue, 1 );

      local notification_type = notification_params[ "type" ];
      local notification_data = notification_params[ "data" ];

      --DbgTrace( "ShowFromQueue "..notification_type.." "..( notification_data.text ) );
      private.Set( notification_type, notification_data );
      private.Show();

    end;

  end;

end;
--******************************************************************************************
function private.TimerStart()

  local tmr_name = "tmr_int_panel_notification";

  if ( not ObjGet( tmr_name ).playing ) then 

    ObjSet( tmr_name,
    {
      time    = int_panel_notification_impl.DELAY_TIME,
      endtrig = public.Hide,
      playing = true
    } );

    --DbgTrace( "started timer" );

  end;

end;
--******************************************************************************************
function private.TimerStop()

  local tmr_name = "tmr_int_panel_notification";

  ObjSet( tmr_name, 
  {
    playing = 0
  } );

end;
--******************************************************************************************
function private.WideScreenUpdate()

  interface.WideScreenUpdate( "panel_notification" );

end;
--******************************************************************************************
