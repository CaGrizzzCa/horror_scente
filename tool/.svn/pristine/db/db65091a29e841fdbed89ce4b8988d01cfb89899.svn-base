--*********************************************************************************************************************
function public.Init()
  --------------------------------------------------------------------------------------------------
  room.Define( "{{ho_name}}" );
  --game.relations[ "{{ho_name}}" ].exitroom = "rm_{{room_name}}";
  --------------------------------------------------------------------------------------------------
  local win_{{ho_name}}_func = function ()

    if ( cmn.IsEventDone( "win_{{ho_name}}" ) ) then
      int.InventoryItemAdd( "inv_", "spr_{{ho_name}}_" );
    end;

  end;
  cmn.AddSubscriber( "win_{{ho_name}}", win_{{ho_name}}_func );
  --------------------------------------------------------------------------------------------------
  local start_{{ho_name}}_func = function ()

--    if ( cmn.IsEventStart( "win_{{ho_name}}" ) ) then
--
--      cmn.ProcessHoStart( "{{ho_name}}" );
--      local ho_found = ng_global.progress[ "std" ][ "win_{{ho_name}}" ].found;
--
--      for i = 1, #ho_found, 1 do
--        ObjDelete( ho_found[ i ][ "object" ] );
--      end;
--
--    end;

  end;
  cmn.AddSubscriber( "win_{{ho_name}}", start_{{ho_name}}_func, "ho_{{ho_name}}" );  
  {{#gets_code}}
  {{>get_code_1}}
  {{/gets_code}}

end;
--*********************************************************************************************************************
function public.Load()

end;
--*********************************************************************************************************************
function public.PreOpen()

  if not cmn.IsEventStart( "win_{{ho_name}}" ) then
    cmn.InitHo( "{{ho_name}}" );
  end;

  local ho_items = {};

  --int.ItemPanelItemAdd( ho_items, "angel"    );

  int.ItemPanelShow( ho_items );

end;
--*********************************************************************************************************************
function public.PreClose()

  int.ItemPanelHide();

end;
--*********************************************************************************************************************
function public.HoComplete()

end;
--*********************************************************************************************************************
function public.ItemFound( item_name )

  local item_object_name = "obj_"..cmn.GetObjectName( item_name );

  ObjDelete( item_object_name );

  int.ItemPanelTryToComplete();

end;
--*********************************************************************************************************************
{{#gets_code}}
{{>get_code_2}}
{{/gets_code}}
--*********************************************************************************************************************
