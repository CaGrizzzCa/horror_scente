-- name=int_window
--******************************************************************************************
function public.Init( pos_z )  

  private.list = {};
  private.position = {};
  private.event_anim_end = {};

  private.SHOW_ANIM_TIME  = 0.30;
  private.BLACKBACK_ALPHA = 0.80;
  private.SHADE_RGB       = 0.10;

  private.hub = "int_window_hub";
  private.blackback_name = "spr_int_window_blackback";

  ObjCreate( private.hub, "obj" );
  ObjSet( private.hub, { pos_z = pos_z } );
  ObjAttach( private.hub, interface.originhub );

end;
--******************************************************************************************
function public.Destroy()  
end;
--******************************************************************************************
function public.Show( message_params )

  local window_name    = message_params.window_name;
  local window_pos_beg = message_params.window_pos_beg;
  local window_pos_end = message_params.window_pos_end;

  local module_path = message_params.window_module_path;
  local module_name = message_params.window_module_name;

  if _G[ module_name ] == nil then

    ModLoad( module_path );
    _G[ module_name ].Init();

  end;

  if message_params.func then

    message_params.func();

  end;

  local is_already_show = false;
 
  for i = 1, #private.list do

    if ( private.list[ i ] == window_name ) then

      --DbgTrace( "Dialog window < "..dlgname.." > already on the screen!" );
      is_already_show = true;
      break;

    end;

  end;

  if ( not is_already_show ) then
  
    ObjSet( window_name, { input = false } );
    ObjAttach( window_name, private.hub );

    table.insert( private.list, window_name );

    if ( #private.list == 1 ) then

      ObjSet( private.blackback_name, { active = true, visible = true, input = true } );
      ObjAttach( private.blackback_name, private.hub );

      local event_id = "show_blackback";
      private.event_anim_end[ event_id ] = {};
      private.BlackBackShowAnim( event_id );

    else

      local window_shade = private.list[ #private.list - 1 ];
      
      ObjSet( window_shade, { input = false } );

      local event_id = "shade_"..window_shade;
      private.event_anim_end[ event_id ] = {};
      private.ShadeAnim( window_shade, event_id );

    end;

    private.position[ window_name ] = window_pos_beg;

    local event_id = "show_"..window_name;
    private.event_anim_end[ event_id ] = window_name;
    private.ShowAnim( window_name, window_pos_beg, window_pos_end, event_id );

  end;

end;
--******************************************************************************************
function public.Hide( message_params )

  local window_name    = message_params.window_name;
  local window_pos_beg = { ObjGet( window_name ).pos_x, ObjGet( window_name ).pos_y };
  local window_pos_end = private.position[ window_name ];

  ObjSet( window_name, { input = false } );

  table.remove( private.list );

  if ( #private.list == 0 ) then

    local event_id = "hide_blackback";
    private.event_anim_end[ event_id ] = {};
    private.BlackBackHideAnim( event_id );

  else

    local window_bright = private.list[ #private.list ];

    local event_id = "bright_"..window_bright;
    private.event_anim_end[ event_id ] = window_bright;
    private.BrightAnim( window_bright, event_id );

  end;

  local event_id = "hide_"..window_name;
  private.event_anim_end[ event_id ] = window_name;
  private.HideAnim( window_name, window_pos_beg, window_pos_end, event_id );

end;
--******************************************************************************************
function private.BlackBackShowAnim( event_id )

  local trg = function () private.EventAnimEnd( event_id ); end;
  local tme = private.SHOW_ANIM_TIME;
  local alp = private.BLACKBACK_ALPHA;

  ObjAnimate( private.blackback_name, "alp", 0, 0, trg,
  {
    ( 0 * tme ), 0, 0,
    ( 1 * tme ), 0, alp
  } );

end;
--******************************************************************************************
function private.BlackBackHideAnim( event_id )

  local trg = function () private.EventAnimEnd( event_id ); end;
  local tme = private.SHOW_ANIM_TIME;
  local alp = private.BLACKBACK_ALPHA;

  ObjAnimate( private.blackback_name, "alp", 0, 0, trg,
  {
  ( 0 * tme ), 0, alp,
  ( 1 * tme ), 0, 0
  } );

end;
--******************************************************************************************
function private.ShadeAnim( obj_name, event_id )

  local trg = function () private.EventAnimEnd( event_id ); end;
  local tme = private.SHOW_ANIM_TIME;
  local rgb = private.SHADE_RGB;

  ObjAnimate( obj_name, "color_rgb", 0, 0, trg,
  {
  ( 0 * tme ), 0, 1, 1, 1,
  ( 1 * tme ), 0, rgb, rgb, rgb
  });

end;
--******************************************************************************************
function private.BrightAnim( obj_name, event_id )

  local trg = function () private.EventAnimEnd( event_id ); end;
  local tme = private.SHOW_ANIM_TIME;
  local rgb = private.SHADE_RGB;

  ObjAnimate( obj_name, "color_rgb", 0, 0, trg,
  {
  ( 0 * tme ), 0, rgb, rgb, rgb,
  ( 1 * tme ), 0, 1, 1, 1
  } );

end;
--******************************************************************************************
function private.ShowAnim( obj_name, pos_beg, pos_end, event_id )

  local trg = function () private.EventAnimEnd( event_id ); end;
  local tme = private.SHOW_ANIM_TIME;

  ObjAnimate( obj_name, "pos_xy", 0, 0, trg,
  {
  ( 0.0 * tme ), 0, pos_beg[ 1 ], pos_beg[ 2 ],
  ( 1.0 * tme ), 0, pos_end[ 1 ], pos_end[ 2 ],
  } );
  ObjAnimate( obj_name, "scale_xy", 0, 0, "",
  {
  ( 0.0 * tme ), 0, 0, 0,
  ( 1.0 * tme ), 0, 1, 1
  } );
  ObjAnimate( obj_name, "alp", 0, 0, "",
  {
  ( 0.0 * tme ), 2, 0,
  ( 0.5 * tme ), 2, 0,
  ( 1.0 * tme ), 2, 1 
  });

end;
--******************************************************************************************
function private.HideAnim( obj_name, pos_beg, pos_end, event_id )

  local trg = function () private.EventAnimEnd( event_id ); end;
  local tme = private.SHOW_ANIM_TIME;

  ObjAnimate( obj_name, "pos_xy", 0, 0, trg,
  {
  ( 0.0 * tme ), 0, pos_beg[ 1 ], pos_beg[ 2 ],
  ( 1.0 * tme ), 0, pos_end[ 1 ], pos_end[ 2 ],
  } );
  ObjAnimate( obj_name, "scale_xy", 0, 0, "",
  {
  ( 0.0 * tme ), 0, 1, 1,
  ( 1.0 * tme ), 0, 0, 0
  } );
  ObjAnimate( obj_name, "alp", 0, 0, "",
  {
  ( 0.0 * tme ), 1, 1,
  ( 0.5 * tme ), 1, 0,
  ( 1.0 * tme ), 1, 0
  } );

end;
--******************************************************************************************
function private.EventAnimEnd( event_id )

  local event_params = private.event_anim_end[ event_id ];

------------------------------------------------------------------------------------
  if ( event_id == "show_blackback" ) then

    --

------------------------------------------------------------------------------------
  elseif ( string.find( event_id, "shade" ) ) then

    --

------------------------------------------------------------------------------------
  elseif ( string.find( event_id, "show" ) ) then

    local wnd_name = event_params;
    ObjSet( wnd_name, { input = true } );

------------------------------------------------------------------------------------
  elseif ( event_id == "hide_blackback" ) then

    ObjSet( private.blackback_name, { active = false, visible = false, input = false } );
    ObjDetach( private.blackback_name );

------------------------------------------------------------------------------------
  elseif ( string.find( event_id, "bright" ) ) then

    local wnd_name = event_params;
    ObjSet( wnd_name, { input = true } );

------------------------------------------------------------------------------------
  elseif ( string.find( event_id, "hide" ) ) then

    local wnd_name = event_params;
    ObjDetach( wnd_name );

------------------------------------------------------------------------------------
  end;

end;
--******************************************************************************************