function public.ProcessGet##Item##All( prg )
  local inv = "inv_##item##"
  local anm = "anm_##item##"
  local prg_all = {"##prg##"}
  ObjSet( anm, { frame = ObjGet( anm ).frame + 1 } );
  ObjSet( inv..ld.NumberFromString( prg ), { visible = 1 } );
  public.ProcessDragChecker( inv, prg, prg_all )
end