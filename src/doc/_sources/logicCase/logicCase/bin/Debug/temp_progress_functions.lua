
private.dlg_nearmuseum_hunchback2_logic = function()
  ObjSet( "spr_nearmuseum_gear2", { visible = 1, input = 1, active = 1 } )

end;

private.dlg_nearmuseum_hunchback2_beg = function()
  ObjDelete( "gfx_nearmuseum_dlg_nearmuseum_hunchback2_zone" );
end;

private.dlg_nearmuseum_hunchback2_end = function()
  ObjSet( "anm_nearmuseum_anm_nearmuseum_gorbyn", {animfunc = "static_gorbyn", frame = 0,visible = 1, playing = 1 } );  
end;

function public.dlg_nearmuseum_hunchback2( obj )

  local func_end = function()
     cmn.SetEventDone( "dlg_nearmuseum_hunchback2" );
    cmn.CallEventHandler( "dlg_nearmuseum_hunchback2_end" );
    common_impl.Lock(0);
    cmn.SetEventDone( "get_gear2" );
    if not private.dialog_get_gear2 then
      ObjSet( "spr_bookstorage_gear2", {visible = 1} );
      cmn.CallEventHandler( "get_gear2" );
    end
    ld.ShowBbt("after_dlg_nearmuseum_hunchback2")  
    --cmn.GotoRoom( "rm_outro" );
  end;
  function public.dlg_nearmuseum_hunchback2_end()
    ObjSet( "dlg_nearmuseum_hunchback2", {bake=1} );
    common_impl.Lock(1);
    func_end()
  end
  cmn.CallEventHandler( "dlg_nearmuseum_hunchback2_beg" );
  

  --ld.AnimPlay( "", "", func_end );
  --SoundSfx( 0 )
  common_impl.dialog_character_loc = "anm_nearmuseum_anm_nearmuseum_gorbyn"
  common_impl.continue_visible = false;
  common_impl.Start( "hunchback2", 2, nil, nil, true, "dlg_nearmuseum_hunchback2_end",{} );
end;
