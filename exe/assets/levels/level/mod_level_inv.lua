-- name=level_inv
-- name=level_inv


-->>constant Объекты не удаляемые из инвентаря

--common_impl.hint[ "use_hippogriff_constant" ] = { type = "use", inv_obj = "inv_hippogriff" };

--<<constant


public.use_add = {

   --["inv_crowbar"]  = {    
   --   { "gfx_bush_yellowdragon_zone", "wrong_use_crowbar"};
   -- };

}

ld.InvSetDropable         = int_inventory.InvSetDropable;   --ObjDoNotDrop для инв. предметов

private.ProcessDragChecker_func_cache = {}
function public.ProcessDragChecker( inv, prg, prg_all )
  --ld.LogTrace( prg, not int_inventory.InventoryItemAddFly[inv], ld.CheckRequirements( prg_all )  );
  --ld.LogTrace( "inv", inv );
  --ld.LogTrace( "int_inventory.InventoryItemAddFly[inv]", int_inventory.InventoryItemAddFly[inv] );
  --ld.LogTrace( "ld.CheckRequirements( prg_all, 1 )", ld.CheckRequirements( prg_all, 1 ) );
  --ld.LogTrace( "( #prg_all - ( ld.CheckRequirements( { prg } ) and 0 or 1 ) )", ( #prg_all - ( ld.CheckRequirements( { prg } ) and 0 or 1 ) ) );
  if ( int_inventory.InventoryItemAddFly[inv] and int_inventory.InventoryItemAddFly[inv] == 0 and ( ld.CheckRequirements( prg_all, 1 ) == ( #prg_all - ( ld.CheckRequirements( { prg } ) and 0 or 1 ) ) ) )
  or ( not int_inventory.InventoryItemAddFly[inv] and ld.CheckRequirements( prg_all ) ) then 
    if not private.ProcessDragChecker_func_cache[ inv ] then
      private.ProcessDragChecker_func_cache[ inv ] = ObjGet( inv ).event_menter
    end
    ObjSet( inv, { 
      drag = 1; 
      event_mdown = ""; 
      event_menter = function()
        private.ProcessDragChecker_func_cache[ inv ]();
        interface.PopupShow( "pop_"..inv.."_all" );
      end;
    } );
    --return true
  else
    ObjSet( inv, { drag = 0 } );
    local count = ld.CheckRequirements( prg_all, true )
    local popup = "pop_"..inv.."_"..count
    if StringGet( popup ) ~= popup then
        ObjSet( inv, { 
        event_menter = function()
          interface.PopupShow( popup );
        end;
      } );
    end;
    --ld.LogTrace( "!!!! "..inv.." ДРАГ не включен потому что" );
    --if int_inventory.InventoryItemAddFly[inv] then
    --  ld.LogTrace( "Предмет летит в инвентарь" );
    --  ld.LogTrace( "Предмет долетел в инвентарь ", int_inventory.InventoryItemAddFly[inv] == 0 );
    --  ld.LogTrace( "Счетчик полёта в инвентарь ", int_inventory.InventoryItemAddFly[inv] )
    --  ld.LogTrace( "Прогрессы выполнены кроме текущего ",ld.CheckRequirements( prg_all, 1 ) ==  #prg_all - ( ld.CheckRequirements( { prg } ) and 0 or 1 ) );
    --else
    --  ld.LogTrace( "Предмет НЕ летит в инвентарь" );
    --  ld.LogTrace( "Прогрессы выполнены ",ld.CheckRequirements( prg_all )  );
    --end
  end 
  interface.CheckInvPlus()
end;

function public.ProcessUseChecker( inv, prg, prg_all )
  if ( ld.CheckRequirements( prg_all, 1 ) == ( #prg_all - ( ld.CheckRequirements( { prg } ) and 0 or 1 ) ) )
  then 
    return true
  else
    return false
  end 
end;


--*********************************************************************************************************************
--public.chainedgolem_onmouse_enter = function()
--  if ObjGet( "int_popup" ).visible==false then
--    interface.PopupShow("pop_inv_chainedgolem");
--  end
--  if not ObjGet("tmr_inv_chainedgolem_vid") then  
--    VidPlay("inv_chainedgolem","")
--    ld.StartTimer("tmr_inv_chainedgolem_vid", math.random(2,4),  public.chainedgolem_onmouse_enter );
--  end
--end
--
--
--public.chainedgolem_mouse_leave = function()
--  if ObjGet("tmr_inv_chainedgolem_vid") then  
--    ObjDelete("tmr_inv_chainedgolem_vid")
--  end
--
--  VidStop("inv_chainedgolem")
--  interface.PopupHide()
--end
--
--public.chainedgolem_startdrag = function()
--  if ObjGet("tmr_inv_chainedgolem_vid") then  
--    ObjDelete("tmr_inv_chainedgolem_vid")
--  end
--  
--  if not ObjGet("tmr_inv_chainedgolem_vid") then
--    VidPlay("inv_chainedgolem","")
--    ld.StartTimer("tmr_inv_chainedgolem_vid", math.random(2,4),  public.chainedgolem_startdrag );
--  end
--end
----**************


function public.Init()
--ld.NoteInit( "spr_suitcase_paper_small", "spr_suitcase_paper_big", "suitcase_note" )        -- пример ЗАПИСКИ
--ld.NoteRemovable( "spr_suitcase_paper_small", function() public.clk_suitcasenote() end )    -- пример закрывающейся ЗАПИСКИ
--ld.NoteInit( "spr_tristancase_paper", "spr_tristancase_paper_1", { 
--  func_open = function() ld.ShowBbt("txt_tristancase_paper");  ObjSet("spr_tristancase_paper",{pos_x=-999})   end;
--})
-------------------------------------------------------------------- пример выключения кропа для деплоя
--public.gordonnotes_preopen = function()
--  ObjSet( "int_complex_inv_impl", {
--  croprect_init = false
--  } );
--  ObjSet( "inv_complex_gordonnotes", {
--  croprect_init = false
--  } );
--end
--public.gordonnotes_close = function()
--  ObjSet( "int_complex_inv_impl", {
--  croprect_init = true,
--  croprect_x    = - ( 0.5 * 1366  ),
--  croprect_y    = - ( 0.5 * 768 ),
--  croprect_w    = 1366,
--  croprect_h    = 768
--  } );
--  ObjSet( "inv_complex_gordonnotes", {
--  croprect_init = true,
--  croprect_x    = - ( 0.5 * 1366  ),
--  croprect_y    = - ( 0.5 * 768 ),
--  croprect_w    = 1366,
--  croprect_h    = 768
--  } );
--end




--------------------------------------------------------------------------------------------
--*********************************************************************************************************************
-- function *** PROGRESS MISC *** () end;
--*********************************************************************************************************************
  function public.ItemFound( task )
    
    --if public.mini_ho == "extinctcrystal" then
    --  private.extinctcrystal_ItemFound(task)
    --end  
  end;
end

function private.ResetSkip(command)
  local mg_name = interface.GetCurrentComplexInv()
  local mg_name_formated = "win_"..ld.StringDivide(mg_name)[3].."_gm"
  local call = private[mg_name_formated] and private[mg_name_formated]["controller_"..command] 
  if call and not ld.CheckRequirements( { "win_"..ld.StringDivide(mg_name)[2] } ) then
    call()
  end
end

function public.Reset()
  private.ResetSkip("reset")
end;
function public.Skip()
  private.ResetSkip("skip")
end




---------------