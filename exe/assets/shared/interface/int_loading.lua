-- name=int_loading

--[[
function public.Message ( message_type, message_params )

  if ( message_type == Command_Interface_WidgetInit ) then

    ModLoad( "assets/interface/int_loading_impl" );
    int_loading_impl.Init();

    ObjAttach( "int_loading_impl", "int_loading" );

  end;

end;
]]
--******************************************************************************************
function public.Init()

  ModLoad( "assets/shared/interface/int_loading_impl" );
  int_loading_impl.Init();

  ObjAttach( "int_loading_impl", "int_loading" );

end;
--******************************************************************************************
function public.Destroy()  
end;
--******************************************************************************************