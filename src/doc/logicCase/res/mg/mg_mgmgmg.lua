-- name=mg_##rm##
private.game = {};
local gm = private.game;
--*********************************************************************************************************************
function public.Init()
  --------------------------------------------------------------------------------------------
  private.room_objname = "mg_##rm##";
  --------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------
  common_impl.hint[ "win_##rm##" ] = {type = "win", use_place = "mg_##rm##", room = "rm_##rmowner##", zz = "mg_##rm##", zz_gate = "gmg_##rmowner##_##rm##" };

  local win_##rm##_logic = function()
    if ld.CheckRequirements( {"win_##rm##"} ) then
      
    end
  end;
  local win_##rm## = function()
    if ld.CheckRequirements( {"win_##rm##"} ) then
      
    end
  end;
  cmn.AddSubscriber("win_##rm##", win_##rm##, private.room_objname )
  cmn.AddSubscriber("win_##rm##", win_##rm##_logic )
  --------------------------------------------------------------------------------------------

--*********************************************************************************************************************
-- function *** PROGRESS MISC *** () end;
--*********************************************************************************************************************

end;
--*********************************************************************************************************************
function public.Open()
  if not ld.CheckRequirements( {"win_##rm##"} ) then
    SoundMgTheme( true )
    cmn.MiniGameShow( "##rm##" );
  end
end;
--*********************************************************************************************************************
function public.PreOpen()
  SoundEnv( "aud_##rmowner##_env" )
  gm.controller_init();
end;
--*********************************************************************************************************************
function public.Close()
  if not ld.CheckRequirements( {"win_##rm##"} ) then
    SoundMgTheme( false )
    cmn.MiniGameHide( "##rm##" );
  end
end;
--*********************************************************************************************************************
function public.PreClose()
end;
--*********************************************************************************************************************
function public.IsZoomable()
  return false
end;
--*********************************************************************************************************************
function public.Reset()
  gm.controller_reset()
end;
--*********************************************************************************************************************
function public.Skip()
  gm.controller_skip()
end;
--*********************************************************************************************************************
function public.GetInfoId()
  return false
end;
--*********************************************************************************************************************
function public.GetInfoLongId()
  return false
end;
--*********************************************************************************************************************
function private.WinEnd()
  ld.Lock(0);
  cmn.SetEventDone( "win_##rm##" );
  cmn.CallEventHandler( "win_##rm##" );
  if private.cur_prg == "scr" then
    if _G["rm_secretroomscr"] then 
      if _G["rm_secretroomscr"].ResetMgGame then
        _G["rm_secretroomscr"].ResetMgGame(); 
        return; 
      end
    end;
  end
  ld.SubRoom.Complete( "win_##rm##", "rm_##rmowner##" )
  interface_impl.ShowMgAchievements();
end;
--*********************************************************************************************************************
function private.Win()
  ld.Lock(1);
  cmn.MiniGameHide();
  SoundMgTheme( false )
  ld.StartTimer( 0.5, private.WinEnd  );
end;
--*********************************************************************************************************************
--*********************************************************************************************************************
-- function *** GAME *** () end;
--*********************************************************************************************************************
--*********************************************************************************************************************
--*********************************************************************************************************************
--function gm.model() end
--*********************************************************************************************************************
  function gm.model_init()
    gm.model_load()
  end
  
  function gm.model_load()
    if gm.progress.state then
      gm.state = ld.TableCopy( gm.progress.state )
    else
      gm.model_reset()
    end
  end
  
  function gm.model_save()
    gm.progress.state = ld.TableCopy( gm.state )
  end
  function gm.model_reset()
    gm.state = gm.model_get_state_default()
  end
  
  function gm.model_skip()
    gm.state = gm.model_get_state_win()
  end
  
  function gm.model_win_check()
    return ld.Table.Equals( gm.state, gm.model_get_state_win() )
  end
  
  function gm.model_get_state_default()
    if gm.state_default == nil then
      gm.state_default = { "default" }
    end
    return ld.Table.Copy( gm.state_default )
  end
  
  function gm.model_get_state_win()
    if gm.state_win == nil then
      gm.state_win = { "win" }
    end
    return ld.Table.Copy( gm.state_win )
  end
  
  function gm.model_mdown(id)
    
  end
--*********************************************************************************************************************
--function gm.view() end
--*********************************************************************************************************************
  function gm.view_init()
    --gm.pool = ld.Pool.New( private.room_objname )
    gm.view_build()
    gm.view_update_all()
  end
  
  function gm.view_build()
    
  end
  
  function gm.view_get_obj_name( id )
    return "spr_##rm##_"..id
  end
  
  function gm.view_get_obj_menter_name( id )
    return gm.view_get_obj_name( id ).."_menter"
  end
  
  function gm.view_reset( func_end )
    gm.view_update_all( func_end )
  end
  
  function gm.view_update_all( func_end )
    if func_end then
      func_end()
    end
  end
  
  function gm.view_menter( id )
    local obj = gm.view_get_obj_menter_name( id )
    ld.Anim.Light( obj, true )
  end;
  
  function gm.view_mleave( id )
    local obj = gm.view_get_obj_menter_name( id )
    ld.Anim.Light( obj, false )
  end;
  
  function gm.view_mdown( id, func_end )
    func_end()
  end
--*********************************************************************************************************************
--function gm.controller() end
--*********************************************************************************************************************
  function gm.controller_init()
    if not gm.controller_initialized then
      private.cur_prg = ng_global.currentprogress; 
      gm.progress = ng_global.progress[ private.cur_prg ][ "win_"..( ld.String.Divide( private.room_objname )[ 2 ] ) ]
      gm.model_init()
      gm.view_init()
      gm.controller_initialized = true;
    end;
  end
  
  function gm.controller_save()
    gm.model_save()
  end
  
  function gm.controller_skip()
    if ld.Lock( 1 ) then
      gm.model_skip()
      gm.view_reset( gm.controller_event_end )
    end
  end
  
  function gm.controller_reset()
    if ld.Lock( 1 ) then
      gm.model_reset()
      gm.view_reset( gm.controller_event_end )
    end
  end
  
  function gm.controller_win()
    private.Win()
  end
  
  function gm.controller_event_end()
    if gm.model_win_check() then
      gm.controller_win()
    else
      gm.controller_save()
      ld.Lock( 0 )
    end
  end
  
  function gm.controller_event_menter( obj )
    ld.ShCur(CURSOR_HAND)
    gm.view_menter( obj )
  end
  
  function gm.controller_event_mleave( obj )
    ld.ShCur(CURSOR_DEFAULT)
    gm.view_mleave( obj )
  end
  
  function gm.controller_event_mdown( obj )
    if ld.Lock( 1 ) then
      gm.model_mdown( obj )
      gm.view_mdown( obj, gm.controller_event_end )
    end
  end
  
  function gm.controller_event_startdrag()

  end
  
  function gm.controller_event_drag()

  end
  
  function gm.controller_event_dragdrop()

  end