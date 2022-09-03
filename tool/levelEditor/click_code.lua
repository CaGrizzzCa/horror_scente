-----------------------------------------------------------------------------------
local clk_{{clk_name}}_beg = function ()

  ObjDelete( "obj_{{parent_name}}_clk_{{clk_name}}" );

end;
local clk_{{clk_name}}_end = function ()


end;
cmn.AddSubscriber( "clk_{{clk_name}}", clk_{{clk_name}}_beg, private.room_objname );
cmn.AddSubscriber( "clk_{{clk_name}}", clk_{{clk_name}}_end, private.room_objname );
cmn.AddSubscriber( "clk_{{clk_name}}_beg", clk_{{clk_name}}_beg, private.room_objname );
cmn.AddSubscriber( "clk_{{clk_name}}_end", clk_{{clk_name}}_end, private.room_objname );
-----------------------------------------------------------------------------------
function private.clk_{{clk_name}}()

  cmn.CallEventHandler( "clk_{{clk_name}}_beg" );

  local trg_after = function ()

    cmn.SetEventDone( "clk_{{clk_name}}" );
    cmn.CallEventHandler( "clk_{{clk_name}}_end" );

    cmn.BlockSubRoomClose( 0 );
  
  end;

  ObjAnimate( "spr_{{parent_name}}_{{clk_name}}", "alp", 0, 0, trg_after, 
    { 
      0.0, 0, 1.0, 
      0.3, 0, 0.0
    } );

  cmn.BlockSubRoomClose( 1 );

end;