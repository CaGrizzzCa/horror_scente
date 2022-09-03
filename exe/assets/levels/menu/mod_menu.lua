-- name=menu
 --*********************************************************************************************************************
function public.Start( param )

  interface.WidgetAdd( InterfaceWidget_Window );
  interface.WidgetAdd( InterfaceWidget_Pause, 2000 );
  interface.WidgetAdd( InterfaceWidget_DialogVideo );
  --interface.WidgetAdd( InterfaceWidget_Effects );
  --interface.WidgetAdd( InterfaceWidget_Popup );

  interface.LockAdd();
  --interface.WidgetAdd( InterfaceWidget_StrategyGuide );

  interface.PanelNotificationAdd(10);

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