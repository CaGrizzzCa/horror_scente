--------------------------------------------------------------------------------------------
function private.clk_{{clk_name}}()

  cmn.CallEventHandler( "clk_{{clk_name}}_beg" );

  local func_after = function ()

    cmn.SetEventDone( "clk_{{clk_name}}" );
    cmn.CallEventHandler( "clk_{{clk_name}}_end" );

    int.BlockSubroomClose( false );
  
  end;

  ObjAnimate( "obj_{{parent_name}}_{{clk_name}}", "alp", 0, 0, func_after, 
  { 
    0.0, 0, 1.0, 
    0.3, 0, 0.0
  } );
  
  int.BlockSubroomClose( true );

end;
