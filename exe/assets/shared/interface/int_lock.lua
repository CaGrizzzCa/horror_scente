-- name=int_lock
--******************************************************************************************
function public.Init (pos_z)
  ObjAttach( "int_lock", interface.originhub );
  ObjSet( "int_lock", { pos_z = pos_z } );
  private.custom_locks = {}
end;
--******************************************************************************************
function public.Destroy()

end;
--******************************************************************************************
function public.Show(  )

  ObjSet( "obj_int_lock", { input = 1 } );

end;
--******************************************************************************************
function public.Hide()

  ObjSet( "obj_int_lock", { input = 0 } );

end;
--******************************************************************************************

--******************************************************************************************
function public.ShowRm(  )

  ObjSet( "obj_int_lock_room", { input = 1 } );

end;
--******************************************************************************************
function public.HideRm()

  ObjSet( "obj_int_lock_room", { input = 0 } );

end;
--******************************************************************************************

--******************************************************************************************
function public.ShowTask(  )

  ObjSet( "obj_int_lock_task", { input = 1 } );

end;
--******************************************************************************************
function public.HideTask()

  ObjSet( "obj_int_lock_task", { input = 0 } );

end;
--******************************************************************************************

--******************************************************************************************
function public.ShowCustom( name )

  if not ObjGet( "obj_int_lock_custom_"..name ) then
    ObjCreate( "obj_int_lock_custom_"..name, "obj" )
    local o = ObjGet( "obj_int_lock" )
    o.name = nil
    ObjSet( "obj_int_lock_custom_"..name, o )
    ObjAttach( "obj_int_lock_custom_"..name, "int_lock" )
  end;
  private.custom_locks[ "obj_int_lock_custom_"..name ] = true
  ObjSet( "obj_int_lock_custom_"..name, { input = 1 } );

end;
--******************************************************************************************
function public.HideCustom( name )

  private.custom_locks[ "obj_int_lock_custom_"..name ] = false
  ObjSet( "obj_int_lock_custom_"..name, { input = 0 } );

end;
--******************************************************************************************
function public.IsAnyCustomNow()

  for k, v in pairs( private.custom_locks ) do
    if v then
      return true
    end
  end

  return false

end;
--******************************************************************************************