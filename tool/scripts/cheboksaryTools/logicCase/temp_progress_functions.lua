
private.get_aaa_inv = function()
  interface.InventoryItemAdd("inv_aaa","spr_aaaa_aaa");
end;

private.get_aaa_logic = function()
  
end;

private.get_aaa_beg = function()
  ObjDelete("gfx_aaaa_aaa")
end;

private.get_aaa_end = function()
  ld.SubRoom.Complete( "get_aaa" )
end;

function public.get_aaa()
  cmn.SetEventDone( "get_aaa" );
  cmn.CallEventHandler( "get_aaa" );
end
