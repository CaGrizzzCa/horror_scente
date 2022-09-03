--------------------------------------------------------------------------------------------
function public.use_{{use_name}}()

  local item = "inv_{{use_name}}";

  {{#is_zz}}if ApplyObj( item, "gzz_{{room_name}}_{{zz_name}}" ) then

    ObjDoNotDrop( item );
    cmn.GotoSubRoom( "zz_{{zz_name}}" );

  else{{/is_zz}}if ( ApplyObj( item, "obj_{{parent_name}}_use_{{use_name}}" ) ) then

    cmn.CallEventHandler( "use_{{use_name}}_inv" );
    cmn.CallEventHandler( "use_{{use_name}}_beg" );

    local trg_after = function ()

      cmn.SetEventDone( "use_{{use_name}}" );
      cmn.CallEventHandler( "use_{{use_name}}_end" );

      --cmn.DeleteTask( "use_{{use_name}}" );
      --cmn.AddTask( "get_" );
    
	  end;

    --ObjAnimate( "spr", "alp", 0, 0, trg_after,
    --{ 
    --  0.0, 0, 0.0, 
    --  0.3, 0, 1.0
    --} );

  else

    --WrongApply();  

  end;

end;
