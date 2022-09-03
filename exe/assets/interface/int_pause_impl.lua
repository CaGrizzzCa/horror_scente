-- name=int_pause_impl
--******************************************************************************************
function public.Init()

end;
--******************************************************************************************
function public.ShowAnim( event_id )

  ObjSet( "obj_int_pause_pause", { active = true, visible = true, input = true, alp = true } );
  int_pause.EventAnimEnd( event_id );

end;
--******************************************************************************************
function public.HideAnim( event_id )

  ObjAnimate( "obj_int_pause_pause", "alp", 0, 0, 
  function () private.HideAnimEnd( event_id ); end,
  {
    0.0, 3, 1,
    0.3, 3, 0
  } );

end;
--******************************************************************************************
function private.HideAnimEnd( event_id )

  ObjSet( "obj_int_pause_pause", { active = false, visible = false, input = false } );
  int_pause.EventAnimEnd( event_id );

end;
--******************************************************************************************