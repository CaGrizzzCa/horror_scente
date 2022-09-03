-- name=int_pause
--******************************************************************************************
function public.Init( pos_z )

  private.event_anim_end = {};

  interface.LoadImplementation( "pause" );
  ObjAttach( "int_pause", interface.originhub );
  ObjSet( "int_pause", { pos_z = pos_z } );

  MsgSubscribe( Command_Pause_Show, private.Show );
  MsgSubscribe( Command_Pause_Hide, private.Hide );

end;
--******************************************************************************************
function public.Destroy()

  MsgUnsubscribe( Command_Pause_Show, private.Show );
  MsgUnsubscribe( Command_Pause_Hide, private.Hide );

end;
--******************************************************************************************
function public.EventAnimEnd( event_id )

  local event_params = private.event_anim_end[ event_id ];
------------------------------------------------------------------------------------
  if ( event_id == "show" ) then

------------------------------------------------------------------------------------
  elseif ( event_id == "hide" ) then

  end;
------------------------------------------------------------------------------------

end;
--******************************************************************************************
function private.Show()

  if IsEditor() then return; end;

  local event_id = "pause_show";
  private.event_anim_end[ event_id ] = {};
  int_pause_impl.ShowAnim( event_id );

end;
--******************************************************************************************
function private.Hide()

  if IsEditor() then return; end;

  local event_id = "pause_hide";
  private.event_anim_end[ event_id ] = {};
  int_pause_impl.HideAnim( event_id );

end;
--******************************************************************************************