-- name=menu
 --*********************************************************************************************************************
function public.Start( param )

  --interface.WidgetAdd( InterfaceWidget_Window, 0, "assets/shared/interface/int_window" );
  --interface.WidgetAdd( InterfaceWidget_Pause, 2000, "assets/shared/interface/int_pause" );
  interface.WidgetAdd( InterfaceWidget_DialogVideo, 0, "assets/interface/int_dialog_video" )
  
  interface.LockAdd()

  local modules = 
  {
     "rm_intro"
    ,"rm_menu"
    --,"rm_moregames"
    --,"rm_credits"


  };
  if IsCollectorsEdition() then
    local ce_modules = 
    {
      --"rm_extra",
      --"rm_achievements",
      --"rm_screensaver",
      --"rm_collectibles",
    }

    for i = 1,#ce_modules do
      table.insert(modules,ce_modules[i])
    end

  end
  
  common.MenuLoad( param, modules );
  common.ProjectSet();

end;
--*********************************************************************************************************************