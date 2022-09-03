--------------------------------------------------------------------------------------------
-- function use_{{use_name}} () end;
--------------------------------------------------------------------------------------------
local use_{{use_name}}_inv = function ()

  int.InventoryItemRemove( "inv_{{use_name}}" );

end;
local use_{{use_name}}_beg = function ()

  ObjDelete( "obj_{{parent_name}}_use_{{use_name}}" );

end;
local use_{{use_name}}_end = function ()

   --ObjSet( "spr_{{parent_name}}_key", { input = true, visible = true, active = true } );

end;
--------------------------------------------------------------------------------------------
cmn.AddSubscriber( "use_{{use_name}}", use_{{use_name}}_beg, "inv_{{parent_name}}" );
cmn.AddSubscriber( "use_{{use_name}}", use_{{use_name}}_inv );
cmn.AddSubscriber( "use_{{use_name}}", use_{{use_name}}_end, "inv_{{parent_name}}" );
cmn.AddSubscriber( "use_{{use_name}}_inv", use_{{use_name}}_inv, "inv_{{parent_name}}" );
cmn.AddSubscriber( "use_{{use_name}}_beg", use_{{use_name}}_beg, "inv_{{parent_name}}" );
cmn.AddSubscriber( "use_{{use_name}}_end", use_{{use_name}}_end, "inv_{{parent_name}}" );
