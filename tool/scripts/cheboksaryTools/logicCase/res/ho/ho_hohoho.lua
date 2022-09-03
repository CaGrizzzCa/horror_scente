-- name=ho_##rm##
--*********************************************************************************************************************
function public.Init()
  --------------------------------------------------------------------------------------------------
  room.Define( "##rm##" );
  game.relations[ "ho_##rm##" ].exitroom = "rm_##rmowner##";
 
--------------------------------------------------------------------------------------------------
  common_impl.hint[ "win_##rm##" ] = { type = "win", room = "rm_##rmowner##", zz = "ho_##rm##", zz_gate = "gho_##rmowner##_##rm##" };
 
  local win_##rm##_func = function ()

    if ( cmn.IsEventDone( "win_##rm##" ) ) then
      interface.InventoryItemAdd( "inv_##inv##", "spr_##rm##_win" );##complex##
      ObjDelete( "gho_##rmowner##_##rm##" );
    end;

  end;
  cmn.AddSubscriber( "win_##rm##", win_##rm##_func );
  
  local start_##rm##_func = function ()
	private.cur_prg = ng_global.currentprogress;  
	if not cmn.IsEventDone("win_##rm##") then
	
	end
  end;
  cmn.AddSubscriber( "win_##rm##", start_##rm##_func, "ho_##rm##" );  

--*********************************************************************************************************************
-- function *** PROGRESS MISC *** () end;
--*********************************************************************************************************************

end;
  --------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------
--*********************************************************************************************************************
function public.Load()

end;
--*********************************************************************************************************************
function public.PreOpen()

  private.cur_prg = ng_global.currentprogress;  
  
  SoundEnv( "aud_##rmowner##_env" )

  if ( not cmn.IsEventDone( "opn_##rm##" ) ) then

    cmn.InitHo( "##rm##" );

    cmn.SetEventDone( "opn_##rm##" );
 
  end;

  local ho_items = {};

  interface.TaskPanelTaskAdd( ho_items, "aaa",          1, 0, { { "spr_##rm##_aaa" } });
  interface.TaskPanelTaskAdd( ho_items, "bbb",          1, 0, { { "spr_##rm##_bbb" } } );
  interface.TaskPanelTaskAdd( ho_items, "ccc",          1, 0, { { "spr_##rm##_ccc" } } );
  interface.TaskPanelTaskAdd( ho_items, "ddd",          1, 0, { { "spr_##rm##_ddd" } } );
  interface.TaskPanelTaskAdd( ho_items, "eee",          1, 0, { { "spr_##rm##_eee" } } );
  interface.TaskPanelTaskAdd( ho_items, "fff",          1, 0, { { "spr_##rm##_fff" } } );
  interface.TaskPanelTaskAdd( ho_items, "ggg",          1, 0, { { "spr_##rm##_ggg" } } );
  interface.TaskPanelTaskAdd( ho_items, "hhh",          1, 0, { { "spr_##rm##_hhh" } } );
  interface.TaskPanelTaskAdd( ho_items, "iii",          1, 0, { { "spr_##rm##_iii" } } );
  interface.TaskPanelTaskAdd( ho_items, "jjj",          1, 0, { { "spr_##rm##_jjj" } } );
  interface.TaskPanelTaskAdd( ho_items, "kkk",          1, 0, { { "spr_##rm##_kkk" } } );
  interface.TaskPanelTaskAdd( ho_items, "lll",          1, 0, { { "spr_##rm##_lll" } } );
  
  SoundHoTheme( true );
  interface.TaskPanelShow( ho_items );

   for j = 1, #ng_global.progress[private.cur_prg]["win_##rm##"].found do

    local name = tostring( ng_global.progress[private.cur_prg]["win_##rm##"].found[j]["object"] );
   
    ObjDelete( name );

  end;

end;
--*********************************************************************************************************************
function public.PreClose()

  SoundHoTheme( false );
  interface.TaskPanelHide();

end;
--*********************************************************************************************************************
function public.HoComplete()

  --common_impl.PlayAudio("sfx","common/audio/aud_ho_win");
   
end;
--*********************************************************************************************************************
function public.ItemFound( item_name )

end;
--*********************************************************************************************************************
--*********************************************************************************************************************
--------------------------------------------------------------------------------------------
function private.TaskComplete( task_name )
  
  ObjSet( "spr_##rm##_"..task_name, { pos_z = 1 } );

  cmn.HoTaskFind( "spr_##rm##_"..task_name, task_name );

end;
---------------------------------------------------------------------------------------------
-----------------------------------------------

function private.GetItem( name )
  
  --ld.PlayAudio("sfx","common/audio/aud_get_item");

end;

----------------------------------------------------------------------------