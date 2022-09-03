function private.win_##mmg##_init()
  if private.win_##mmg##_gm then return end
  private.win_##mmg##_gm = {}
  local gm = private.win_##mmg##_gm
  --*********************************************************************************************************************
  --function gm.model() end
  --*********************************************************************************************************************
    function gm.model_init()
      gm.model_activated = gm.model_get_state_default()
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
  --*********************************************************************************************************************
  --function gm.view() end
  --*********************************************************************************************************************
    function gm.view_init()
      gm.view_build()
      gm.view_update()
    end

    function gm.view_build()
      --gm.pool = ld.Pool.New( "##pool##" )
      local w = 25
      for id = 1, 5 do
        ObjSet( gm.view_get_obj_name( id ), {
          inputrect_init = true;
          inputrect_x = -w;
          inputrect_y = -w;
          inputrect_w = 2 * w;
          inputrect_h = 2 * w;
          event_menter = function() gm.controller_event_menter( id ) end;
          event_mleave = function() gm.controller_event_mleave( id ) end;
          event_mdown  = function() gm.controller_event_mdown ( id ) end;
        } )
      end
    end

    function gm.view_update( func_end )
      if func_end then
        func_end()
      else
	  
      end
    end

    function gm.view_menter( obj )
      obj = obj and ( type( obj ) == "table" and obj.sender ) or obj or "";
      obj = ObjGet( obj.."_light" ) and obj.."_light" or ( ObjGet( obj.."_menter" ) and obj.."_menter" ) or obj
      ld.Anim.Light( obj, true )
    end;

    function gm.view_mleave( obj )
      obj = obj and ( type( obj ) == "table" and obj.sender ) or obj or "";
      obj = ObjGet( obj.."_light" ) and obj.."_light" or ( ObjGet( obj.."_menter" ) and obj.."_menter" ) or obj
      ld.Anim.Light( obj, false )
    end;

    function gm.view_get_obj_name( id )
      return "##obj##_"..id
    end
  --*********************************************************************************************************************
  --function gm.controller() end
  --*********************************************************************************************************************
    function gm.controller_init()
      if not gm.controller_initialized then
        private.cur_prg = ng_global.currentprogress; 
        gm.progress = ng_global.progress[ private.cur_prg ][ "win_##mmg##" ]
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
        gm.view_update( gm.controller_event_end )
      end
    end

    function gm.controller_reset()
      if ld.Lock( 1 ) then
        gm.model_reset()
        gm.view_update( gm.controller_event_end )
      end
    end

    function gm.controller_win()
      public.win_##mmg##()
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
      ld.ShCur(CURSOR_GET)
      gm.view_menter( obj )
    end

    function gm.controller_event_mleave( obj )
      ld.ShCur(CURSOR_DEFAULT)
      gm.view_mleave( obj )
    end

    function gm.controller_event_mdown()
      if ld.Lock( 1 ) then
        
      end
    end

    function gm.controller_event_startdrag()

    end

    function gm.controller_event_drag()
      
    end

    function gm.controller_event_dragdrop()
      
    end

  gm.controller_init()
end