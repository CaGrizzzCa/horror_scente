--------------------------------------------------------------------------------------------
-- function get_{{get_name}} () end;
--------------------------------------------------------------------------------------------
local get_{{get_name}}_inv = function ()

  int.InventoryItemAdd( "inv_{{get_name}}", "spr_{{parent_name}}_{{get_name}}" );

end;

local get_{{get_name}}_closezz = function ()

  ObjDelete( "gfx_{{parent_name}}_{{get_name}}" );
  ObjDelete( "gzz_{{room_name}}_{{parent_name}}" );

end;

cmn.AddSubscriber( "get_{{get_name}}", get_{{get_name}}_inv );
cmn.AddSubscriber( "get_{{get_name}}", get_{{get_name}}_closezz, private.room_objname );
