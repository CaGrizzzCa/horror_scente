-- name=room
--********************************************************************************************************************
function public.Init()

  private.ROOMS_HUB = "room_hub";
  private.NG_LEVEL_INTERNAL = "ng_level_internal";
  private.current = nil;
  private.event_anim_end = {};
  private.is_autosave = false;

  ModLoad( "assets/levels/common/mod_room_impl" );
  room_impl.Init();

end;
--********************************************************************************************************************
function public.Destroy()

end;
--********************************************************************************************************************
function public.Switch( newroom )

  local is_zoomable_next, zoomable_next 
  if _G[ newroom ] and _G[ newroom ].IsZoomable then
    is_zoomable_next, zoomable_next = _G[ newroom ].IsZoomable()
  end
  local is_zoomable_previous, zoomable_previous 
  if _G[ private.current ] and _G[ private.current ].IsZoomable then
     is_zoomable_previous, zoomable_previous = _G[ private.current ].IsZoomable()
  end

  zoomable_next = is_zoomable_next or zoomable_next
  zoomable_previous = is_zoomable_previous or zoomable_previous
  local via_hint_dialog = ObjGet("int_dialog_hint")

  if (private.current ~= newroom) and (( not room_impl.VIA_BLACK_SCREEN ) or ( zoomable_next or zoomable_previous )) then
    if (via_hint_dialog and via_hint_dialog.visible) or (not room_impl.DO_ZOOM_SCREEN) then
      --normal transfer
    else
      if zoomable_next then
        room_impl.SetZoomSwitch( newroom, private.current )
      else
        room_impl.SetZoomSwitch( private.current, newroom )
      end
    end
    private.Hide( "hide_without_black", private.current, newroom );
    private.current = newroom;
    local event_id = "show_without_black";
    private.Show( newroom, "show_without_black" );

  else

    private.Hide( "hide_with_black", private.current, newroom );

  end;

end;
--********************************************************************************************************************
function public.Define( fullRoomName )

  ObjAttach( fullRoomName, private.ROOMS_HUB );

end;
--********************************************************************************************************************
function public.EventAnimEnd( event_id )

------------------------------------------------------------------------------------
  if ( event_id == "show" ) then

------------------------------------------------------------------------------------
  elseif ( event_id == "show_without_black" ) then

    local room = private.event_anim_end[ event_id ].room;
    private.ShowEnd( room );

------------------------------------------------------------------------------------
  elseif ( event_id == "show_with_black" ) then

    local room = private.event_anim_end[ event_id ].room;
    private.ShowEnd( room );
    ObjSet( room, { active = true } );

    ObjSet( room_impl.BLACK_NAME, { active = false, visible = false, alp = false } );
    ObjAttach( room_impl.BLACK_NAME, private.ROOMS_HUB );

------------------------------------------------------------------------------------
  elseif ( event_id == "hide_without_black" ) then

    local curroom = private.event_anim_end[ event_id ].curroom;

    if curroom then

      private.HideEnd( curroom );

    end;


    if private.is_autosave then

      SaveProfiles();

    end;

------------------------------------------------------------------------------------
  elseif ( event_id == "hide_with_black" ) then

    local newroom = private.event_anim_end[ event_id ].newroom;
    local curroom = private.event_anim_end[ event_id ].curroom;

    if curroom then

      private.HideEnd( curroom );
      ObjSet( curroom, { active = true } );

    end;

    if private.is_autosave then

      SaveProfiles();

    end;

    local event_id = "show_with_black";
    private.current = newroom;
    private.Show( newroom, event_id );

  end;

end;
--********************************************************************************************************************
function public.GetCurrent()

  return private.current or "";

end;
--********************************************************************************************************************
function public.SetAutosave( value )

  private.is_autosave = value;

end;
--********************************************************************************************************************
function public.SetCurrentRoomActive( value )

  if private.current then
    if (value == true) then
      MsgSend( Command_Level_RestoreZoom );
      common.SetMultiTouch(private.current);
    end;    
    ObjSet( private.current, { active = value });
  end;

end;
--********************************************************************************************************************
function public.SetCurrentRoomInput( value )

  if private.current then
    ObjSet( private.current, { input = value });
  end;

end;
--********************************************************************************************************************
function private.ShowEnd( room )



  private.Execute( room, "Open" );
  ObjSet( room, { input = true } );

end;
--********************************************************************************************************************
function private.HideEnd( room )

  if room then

    private.Execute( room, "Close" );
    ObjAttach( room, private.ROOMS_HUB ); 

  end;

end;
--********************************************************************************************************************
function private.Hide( event_id, curroom, newroom )

  private.event_anim_end[ event_id ] = { newroom = newroom, curroom = curroom };

  if event_id == "hide_with_black" then

    ObjAttach( room_impl.BLACK_NAME, private.NG_LEVEL_INTERNAL );
    ObjSet( room_impl.BLACK_NAME, { active = true, visible = true, alp = 0 } );

  end;

  if curroom then

    private.Execute( curroom, "PreClose" );

    ObjSet( curroom, { input = false, active = true } );
    if event_id == "hide_without_black" then

      room_impl.Hide( event_id, curroom ); 

    else

      ObjSet( curroom, { active = false } );
      room_impl.ShowBlack( event_id ); 

    end;

  else
    
    public.EventAnimEnd( event_id );

  end;

end;
--********************************************************************************************************************
function private.Show( room, event_id )

  private.event_anim_end[ event_id ] = { room = room };

  ObjAttach( room, private.NG_LEVEL_INTERNAL );

  private.Execute( room, "PreOpen" );

  if event_id == "show_with_black" then

    ObjSet( room, { input = false, active = false, visible = true, alp = 1 } );
    ObjSet( room_impl.BLACK_NAME, { active = true, visible = true, alp = 1 } );
    room_impl.HideBlack( event_id ); 

  else

    ObjSet( room, { input = false, active = true, visible = true, alp = 0 } );
    room_impl.Show( event_id, room ); 

  end;

end;
--********************************************************************************************************************
function private.Execute( room, func )

  -->>
    common_impl.ZRMeventRun( func.."Before", room );
  --<<

  if room and func and _G[ room ] and _G[ room ][ func ] then
    _G[ room ][ func ]();
  end;

  -->>
    common_impl.ZRMeventRun( func.."After", room );
  --<<

end;
--********************************************************************************************************************
function private.GetRoomName(object)

  local underscore = string.find( object, "_" );
  local name = nil;
  if ( underscore ) then
    name = string.sub( object, ( underscore + 1 ) );
  end;
  return name;

end;
--********************************************************************************************************************
GetCurrentRoom = public.GetCurrent;
--********************************************************************************************************************