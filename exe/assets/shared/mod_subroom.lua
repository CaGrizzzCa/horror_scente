-- name=subroom
--********************************************************************************************************************
function public.Init()

  private.opened_sub_rooms = {}
  private.opening_now = 0
  private.closing_now = 0
  private.frame_state = nil
  private.owned = {}

  private.current = nil;
  private.pos_beg = nil;
  private.pos_end = nil;
  public.open_anim = false;
  public.close_anim = false;
  private.event_anim_end = {};
  private.SUBROOM = "subroom";
  ObjAttach( private.SUBROOM, "ng_level_internal" );

  ModLoad( "assets/levels/common/mod_subroom_impl" );
  subroom_impl.Init();

end;
--********************************************************************************************************************
function public.Destroy()

end;
--********************************************************************************************************************
function public.Define( subroom, param1, param2 )
  _G[ subroom ] = {};
  local owner,isRound
  
 if (param1 and type(param1)== "string") then
    owner = param1
 elseif  (param2 and type(param2)== "string") then
    owner = param2
 end 
 
 if (param1 and type(param1)== "number") then
    isRound = param1
 elseif  (param2 and type(param2)== "number") then
    isRound = param2
 end 
 
 if owner then
   local o = ObjGet( subroom )
   private.owned[ subroom ] = { o.pos_x; o.pos_y; owner = owner; }
 end
 if isRound then
   _G[ subroom ] = {isRound = isRound};     
 end;
  

end;
--********************************************************************************************************************
function public.EventAnimEnd( event_id )

------------------------------------------------------------------------------------
  if ( event_id == "show" ) then

    ObjSet( private.current, { input = true } );
    private.Execute( private.current, "Open" );
    private.RemoveOpeningNow()

------------------------------------------------------------------------------------
  elseif ( event_id == "hide" ) then

    ld.LockCustom( "subroom_deep", 0 )

    private.Execute( private.current, "Close" );

    private.RemoveClosingNow()
    if not private.IsSubRoomOpened( subroom_name ) then
      ObjDetach( private.current );
      ObjDetach( subroom_impl.BLACK );
      ObjSet( private.SUBROOM, { input = false, visible = false, active = false } );
      --private.current = nil;
      --private.pos_beg = nil;
      --private.pos_end = nil;
      room.SetCurrentRoomActive( true );
      room.SetCurrentRoomInput( true );
    end

  end;

end;
--********************************************************************************************************************
function public.Open( subroom_name, pos_beg, pos_end )
  
  if not private.IsSubRoomOpened( subroom_name ) then
  --if not private.current then

    private.AddSubRoomOpened( subroom_name, pos_beg, pos_end )
    private.AddOpeningNow()
    local pos_z = private.GetSubRoomOpenedCount()
    room.SetCurrentRoomActive( false );
    room.SetCurrentRoomInput( false );
    ObjSet( private.SUBROOM, { input = true, visible = true, active = true } );
    --private.current = subroom_name;
    private.pos_beg = pos_beg; --DbgTrace((pos_beg.x).." "..(pos_beg.y));
    private.pos_end = pos_end; --DbgTrace((pos_end.x).." "..(pos_end.y));
    ObjAttach( subroom_impl.BLACK, private.SUBROOM );
    ObjSet( "obj_subroom_deep", { pos_z = pos_z; input = pos_z > 1 } )
    ObjSet( subroom_name, { pos_z = pos_z, input = false } );
    ObjAttach( subroom_name, private.SUBROOM );

    local zz_param = ObjGet(subroom_name)

    subroom_impl.Show( "show", subroom_name, pos_beg, pos_end, pos_z > 1 );  

    if pos_z == 1 then
      ObjSet( subroom_name, {
        croprect_init = true;
        croprect_x    = - ( 0.5 * zz_param.draw_width  );
        croprect_y    = - ( 0.5 * zz_param.draw_height );
        croprect_w    = zz_param.draw_width;
        croprect_h    = zz_param.draw_height;
      } );
      local back_params = ObjGet( subroom_name );
      interface.ConstructFrameSubroom( back_params.draw_width, back_params.draw_height,_G[subroom_name].isRound);
      if private.frame_state then
        ObjSet( "int_frame_subroom", { pos_z = private.frame_state.pos_z } )
        ObjAttach( "int_frame_subroom", "ng_interface_internal" )
        private.frame_state = nil
      end
    elseif private.frame_state == nil then
      private.frame_state = ObjGet( "int_frame_subroom" )
      ObjSet( "int_frame_subroom", { pos_z = 1 } )
      ObjAttach( "int_frame_subroom", "subroom" )
    end

    private.Execute( private.current, "PreOpen" );

  end;

end;
--********************************************************************************************************************
function public.Close( subroom_name )

  --if private.current then
  if private.IsSubRoomOpened( subroom_name ) and not private.IsClosingNow() then
    private.Close( subroom_name )
  end;

end;
function private.Close( subroom_name )
  local subroom = private.RemoveSubRoomOpened( subroom_name )
  private.AddClosingNow()
  ObjSet( subroom.name, { input = false } );
  ObjSet( "obj_subroom_deep", {  input = private.GetSubRoomOpenedCount() > 1 } )
  if private.GetSubRoomOpenedCount() > 0 then
    ld.LockCustom( "subroom_deep", 1 )
  end
  private.Execute( subroom.name, "PreClose" );
  subroom_impl.Hide( "hide", subroom.name, subroom.pos_beg, subroom.pos_end, private.IsSubRoomOpened() );    
end
function public.CloseAll()
  while private.IsSubRoomOpened() do
    private.Close()
  end
end;
--********************************************************************************************************************
function private.Execute( room, func )

  -->> очиститель для хинтовых частиц, которые не успели доиграться
  if func == "PreOpen" then
    common_impl.DeleteZzHintFx( room )
  end
  --<< очиститель для хинтовых частиц, которые не успели доиграться

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
--********************************************************************************************************************
--function Deep() end
--********************************************************************************************************************
--********************************************************************************************************************
  function private.IsSubRoomOpened( subroom_name )
    if subroom_name == nil then
      return private.GetSubRoomOpenedCount() > 0
    end
    for k, v in ipairs( private.opened_sub_rooms ) do
      if v.name == subroom_name then
        return true
      end
    end
    return false
  end
  function public.IsSubRoomOwned( subroom_name )
    subroom_name = subroom_name or public.GetSubRoomOpened()
    return private.owned[ subroom_name ] ~= nil
  end
  function private.IsOpeningNow()
    return private.opening_now ~= 0
  end
  function private.IsClosingNow()
    return private.closing_now ~= 0
  end
  function private.GetSubRoomOpenedCount()
    return #private.opened_sub_rooms
  end
  function public.GetSubRoomOpened()
    return #private.opened_sub_rooms > 0
       and private.opened_sub_rooms[ #private.opened_sub_rooms ]
       and private.opened_sub_rooms[ #private.opened_sub_rooms ].name
        or nil
  end
  function public.GetSubRoomOwnedInitPos( subroom_name )
    return private.owned[ subroom_name ]
  end
  function public.GetSubRoomOwner( subroom_name )
    return private.owned[ subroom_name ] and private.owned[ subroom_name ].owner
  end
  function public.GetSubRoomExitButton( subroom_name )
    subroom_name = subroom_name or public.GetSubRoomOpened()
    return private.owned[ subroom_name ] and "obj_"..( ld.StringDivide( subroom_name )[ 2 ] ).."_exit" or "obj_int_frame_subroom_button"
  end
  function private.AddSubRoomOpened( subroom_name, pos_beg, pos_end )
    table.insert( private.opened_sub_rooms, { name = subroom_name; pos_beg = pos_beg; pos_end = pos_end; } )
    private.current = subroom_name;
  end
  function private.AddOpeningNow()
    if public.close_anim then
      private.RemoveClosingNow()
    end
    private.opening_now = private.opening_now + 1
    public.open_anim = true
  end
  function private.AddClosingNow()
    if public.open_anim then
      private.RemoveOpeningNow()
    end
    private.closing_now = private.closing_now + 1
    public.close_anim = true
  end
  function private.RemoveSubRoomOpened( subroom_name )
    if subroom_name == nil then
      return table.remove( private.opened_sub_rooms )
    end
    for k, v in ipairs( private.opened_sub_rooms ) do
      if v.name == subroom_name then
        table.remove( private.opened_sub_rooms, k )
        return v
      end
    end
  end
  function private.RemoveOpeningNow()
    private.opening_now = private.opening_now - 1
    public.open_anim = private.IsOpeningNow()
  end
  function private.RemoveClosingNow()
    private.closing_now = private.closing_now - 1
    public.close_anim = private.IsClosingNow()
  end