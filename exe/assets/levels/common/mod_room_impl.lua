-- name=room_impl
--********************************************************************************************************************
function public.Init()

  public.VIA_BLACK_SCREEN = true;
  public.DO_ZOOM_SCREEN = true;
  public.BLACK_NAME = "spr_room_black_screen";
  public.FADE_TIME = 1;

end;
--********************************************************************************************************************
function public.Hide( event_id, obj_name )

  local trg = function()

    --common_impl.VidStaticEvent( "Close", obj_name );
  -->>
    --common_impl.ZRMeventRun( "PreCloseBefore", obj_name );
  --<<
    common_impl.LockRm( 0 )
    room.EventAnimEnd( event_id );

  end;

  if obj_name == private.room_parent and private.room_zoom then

    local div1 = ld.StringDivide( private.room_parent )
    local div2 = ld.StringDivide( private.room_zoom )
    local gate =  "g"..div2[ 1 ].."_"..div1[ 2 ].."_"..div2[ 2 ]
    private.Zoom( obj_name, gate, true, function()
      ObjSet( obj_name, { scale_x = 1; scale_y = 1; pos_x = 0; pos_y = 0; } )
      trg()
    end )

    --ObjAnimate( obj_name, "alp", 0, 0, trg, {0,0,1, public.FADE_TIME/2,2,1} );

  elseif obj_name == private.room_zoom then
  
    ObjAnimate( obj_name, "alp", 0, 0, trg, {0,0,1, public.FADE_TIME/2,1,0} );

  else

    ObjAnimate( obj_name, "alp", 0, 0, trg, {0,0,1, public.FADE_TIME,0,0} );

  end

  -->>
    --common_impl.ZRMeventRun( "PreCloseAfter", obj_name );
  --<<

  common_impl.LockRm( 1 )

end;
--********************************************************************************************************************
function public.Show( event_id, obj_name )

  -->>автохайд инвенторя в МГ, чтобы нельзя было открыть деплой с мг, когда активна МГ
  if obj_name and obj_name:find("^mg_") then
    local prg = "win_"..common.GetObjectName( obj_name );
    if not cmn.IsEventDone( prg ) and cmn.IsEventStart( prg ) then
      interface.WidgetSetInput( InterfaceWidget_Inventory, false );
      interface.WidgetSetVisible( InterfaceWidget_Inventory, false, true );
    end;
  end;  
  --<<    

  local trg = function() 

    -->> запуск муз сопровождения
    if private.SoundBackThemePlaying == nil and obj_name and not obj_name:find("^ho_") then
      if obj_name ~= "rm_credits" then
        ld_impl.SoundBackTheme( true );
      end
    end
    --<<
    common_impl.LockRm( 0 )
    room.EventAnimEnd( event_id );
  end;
  common_impl.LockRm( 1 )


  if obj_name == private.room_parent and private.room_zoom then

    local div1 = ld.StringDivide( private.room_parent )
    local div2 = ld.StringDivide( private.room_zoom )
    local gate =  "g"..div2[ 1 ].."_"..div1[ 2 ].."_"..div2[ 2 ]
    --private.Zoom( "obj_room_impl_bake", "grm_"..div1[ 2 ].."_"..div2[ 2 ], false )

    private.room_parent = nil
    private.room_zoom = nil

    --ObjAnimate( obj_name, "alp", 0, 0, trg, {0,0,0, public.FADE_TIME/2,2,1} );

    -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    -->> реализация бэйка, смещение в 512/384 необходимо по причине запекания 1366*768 >>
    -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ObjAttach( "obj_room_impl_scale", "ng_level_internal" )
    ObjAttach( obj_name, "obj_room_impl_bake" )
    ObjSet( obj_name, { alp = 1; pos_x = -512; pos_y = -384; active = 0; } )
    ObjSet( "obj_room_impl_scale", { pos_x = 512; pos_y = 384; scale_x = 1; scale_y = 1; } )
    ObjSet( "obj_room_impl_bake", { bake = 1; alp = 0; scale_x = 1; scale_y = 1; } )
    private.Zoom( "obj_room_impl_scale", gate, false )
    ObjAnimate( "obj_room_impl_bake", "alp", 0, 0, function()
      ObjSet( "obj_room_impl_bake", { bake = 0; clearbake = 1; alp = 1; } )
      ObjAttach( obj_name, "ng_level_internal" )
      ObjSet( obj_name, { pos_x = 0; pos_y = 0; active = 1; } )
      ObjDetach( "obj_room_impl_scale" )
      trg()
    end, {0,0,0, public.FADE_TIME/2,3,1} );
    --<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    --<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    --<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  elseif obj_name == private.room_zoom then

    ld_impl.UseItemLock = true;
    --ObjAnimate( obj_name, "alp", 0, 0, trg, {0,0,0, public.FADE_TIME/2,2,1} );

    -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    -->> реализация бэйка, смещение в 512/384 необходимо по причине запекания 1366*768 >>
    -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ObjAttach( "obj_room_impl_scale", "ng_level_internal" )
    ObjAttach( obj_name, "obj_room_impl_bake" )
    ObjSet( obj_name, { alp = 1; pos_x = -512; pos_y = -384; active = 0; } )
    ObjSet( "obj_room_impl_scale", { pos_x = 512; pos_y = 384; } )
    ObjSet( "obj_room_impl_bake", { bake = 1; alp = 0; scale_x = 1; scale_y = 1; } )
    --private.Zoom( "obj_room_impl_bake", gate, nil )
    ObjAnimate( "obj_room_impl_bake", "alp", 0, 0, function()
      ObjSet( "obj_room_impl_bake", { bake = 0; clearbake = 1; alp = 1; scale_x = 1; scale_y = 1; } )
      ObjAttach( obj_name, "ng_level_internal" )
      ObjSet( obj_name, { pos_x = 0; pos_y = 0; active = 1; } )
      ObjDetach( "obj_room_impl_scale" )
      ld_impl.UseItemLock = false;
      trg()
    end, {0,0,0, public.FADE_TIME/2,3,1} );
    --<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    --<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    --<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  else

    ObjAnimate( obj_name, "alp", 0, 0, trg, {0,0,0, public.FADE_TIME,0,1} );

  end

end;
--********************************************************************************************************************
function public.HideBlack( event_id )

  -->>автохайд инвенторя в МГ, чтобы нельзя было открыть деплой с мг, когда активна МГ
  -->>срабатывает если загружаемся в сразу в МГ
  local obj_name = common.GetCurrentRoom();
  if obj_name and private.ShowBlackMg ~= obj_name and obj_name:find("^mg_") and ObjGet( obj_name ) then
    local prg = "win_"..common.GetObjectName( obj_name );
    if not cmn.IsEventDone( prg ) and cmn.IsEventStart( prg ) then
      interface.WidgetSetInput( InterfaceWidget_Inventory, false );
      interface.WidgetSetVisible( InterfaceWidget_Inventory, false, false );
    end;
  end;  
  --<<  

  local trg = function() 

    -->> запуск муз сопровождения
    if private.SoundBackThemePlaying == nil and obj_name and not obj_name:find("^ho_") and not obj_name~="rm_menu" then
      if not common_impl.isFlashBackRuning then
        ld_impl.SoundBackTheme( true ); 
      end
    end
    --<<
    common_impl.LockRm( 0 );
    room.EventAnimEnd( event_id ); 
  end;
  ObjAnimate( public.BLACK_NAME, "alp", 0, 0, trg, {0,0,1, public.FADE_TIME/2,0,0} );
  common_impl.LockRm( 1 )

end;
--********************************************************************************************************************
function public.ShowBlack( event_id )

  -->>автохайд инвенторя в МГ, чтобы нельзя было открыть деплой с мг, когда активна МГ
  local obj_name = common.GetCurrentRoom();
  if obj_name and obj_name:find("^mg_") and ObjGet( obj_name ) then
    private.ShowBlackMg = obj_name
    local prg = "win_"..common.GetObjectName( obj_name );
    if not cmn.IsEventDone( prg ) and cmn.IsEventStart( prg ) then
      interface.WidgetSetInput( InterfaceWidget_Inventory, false );
      interface.WidgetSetVisible( InterfaceWidget_Inventory, false, true );
    end;
  end;  
  --<<  

  local trg = function()
    common_impl.LockRm( 0 );
    room.EventAnimEnd( event_id );
  end;

  ObjAnimate( public.BLACK_NAME, "alp", 0, 0, trg, {0,0,0, public.FADE_TIME/2,0,1} );
  common_impl.LockRm( 1 )

end;
--********************************************************************************************************************
function public.SetZoomSwitch( room_zoom, room_parent )
  --private.room_zoom_switch = bool
  private.room_zoom = room_zoom
  private.room_parent = room_parent
end
--********************************************************************************************************************
function private.Zoom( room_obj, target_obj, bool, func_end, sc )
  local p = GetObjPosByObj( target_obj, room_obj )
  sc = sc or 1.1
  local dsc = 1 - 1 / sc
  local o = ObjGet( room_obj )
  local x_beg = o.pos_x;
  local y_beg = o.pos_y;
  local x_end = x_beg;
  local y_end = y_beg;
  local sc_beg = 1;
  local sc_end = sc_beg;
  if bool then
    x_end = x_beg - p[ 1 ] * dsc
    y_end = y_beg - p[ 2 ] * dsc
    sc_end = sc;
  elseif bool == nil then
    x_beg = x_beg - p[ 1 ] * dsc
    y_beg = y_beg - p[ 2 ] * dsc
    sc_beg = sc;
  else
    x_beg = x_beg - p[ 1 ] * dsc
    y_beg = y_beg - p[ 2 ] * dsc
    sc_beg = sc;
  end
  ObjAnimate( room_obj, 3,0,0, nil, { 0,0,x_beg,y_beg, public.FADE_TIME/2,2,x_end,y_end } )
  ObjAnimate( room_obj, 6,0,0, func_end, { 0,0,sc_beg,sc_beg, public.FADE_TIME/2,2,sc_end,sc_end } )
end
--********************************************************************************************************************
function public.Zoom( room_obj, target_obj, bool, func_end, scale )
  if not bool and ld.String.Prefix( room_obj ) == "rm" then
    ObjSet( room_obj, { pos_x = 0; pos_y = 0; } )
  end
  private.Zoom( room_obj, target_obj, bool, func_end, scale )
end
--********************************************************************************************************************