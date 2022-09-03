--------------------------------------------------------------------------------------------
-- function clk_{{clk_name}} () end;
--------------------------------------------------------------------------------------------
local clk_{{clk_name}}_beg = function ()

  ObjSet( "obj_{{parent_name}}_{{clk_name}}", { input = false } );

end;
local clk_{{clk_name}}_end = function ()

  ObjDelete( "obj_{{parent_name}}_{{clk_name}}" );

end;
--------------------------------------------------------------------------------------------
cmn.AddSubscriber( "clk_{{clk_name}}", clk_{{clk_name}}_beg, "inv_{{parent_name}}" );
cmn.AddSubscriber( "clk_{{clk_name}}", clk_{{clk_name}}_end, "inv_{{parent_name}}" );
cmn.AddSubscriber( "clk_{{clk_name}}_beg", clk_{{clk_name}}_beg, "inv_{{parent_name}}" );
cmn.AddSubscriber( "clk_{{clk_name}}_end", clk_{{clk_name}}_end, "inv_{{parent_name}}" );
