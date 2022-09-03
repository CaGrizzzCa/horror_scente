
private.get_secateurslbag_inv = function()
  interface.InventoryItemAdd("inv_secateurslbag","spr_wagon_secateurslbag");
end;

private.get_secateurslbag_logic = function()
  
end;

private.get_secateurslbag_beg = function()
  ObjDelete("gfx_wagon_secateurslbag")
end;

private.get_secateurslbag_end = function()
  if common_impl.ZzCompleteCheck("get_secateurslbag") then ObjSet( common_impl.hint["get_secateurslbag"].zz_gate, { visible = 0, input = 0 } ); end;
end;

function public.get_secateurslbag()
  cmn.SetEventDone( "get_secateurslbag" );
  cmn.CallEventHandler( "get_secateurslbag" );
  ld.PlayGetSound();
  if common_impl.ZzCompleteCheck("get_secateurslbag") then ld.CloseSubRoom() end;
end
