-- name=subroom_impl
--********************************************************************************************************************
function public.Init()

  public.BLACK = "spr_subroom_black_screen";
  private.BLACK_ALP = 0.8;

  private.SHOW_TIME = 0.5;
  private.HIDE_TIME = 0.5;
  public.IsAnim = false;

end;
--********************************************************************************************************************
function public.Show( event_id, subroom_name, pos_beg, pos_end )
  --ld.LockCustom( "subroom_impl", 1 )
  local zz_name = ld.StringDivide(subroom_name)[2]
  if ObjGet("obj_"..zz_name.."_overlay") then
    ObjSet("obj_"..zz_name.."_overlay", {pos_z = 10})
    ObjAttach("obj_"..zz_name.."_overlay","int_frame_subroom_impl")
  end
    
  public.IsAnim = true;
  --ObjSet( subroom_name, { bake = 1 } )
  --local trg = function() ObjSet( subroom_name, { clear_bake = 1, bake = 0 } ) subroom.EventAnimEnd( event_id ); end;
  local trg = function()
    --ld.LockCustom( "subroom_impl", 0 )
    subroom.EventAnimEnd( event_id );
    public.IsAnim = false;

  end;
  local tme = private.SHOW_TIME;

  local alpha_anm_table = {0,0,0, tme*0.5,2,1, tme,0,1};
  local pos_xy_anm_table = {0,0,pos_beg.x,pos_beg.y, tme,2,pos_end.x,pos_end.y};
  local scale_xy_anm_table = {0,1,0,0, tme,2,1,1};

  SoundSfx( "reserved/aud_open_zz" )

  ObjAnimate( subroom_name, "alp", 0, 0, trg, alpha_anm_table );
  ObjAnimate( subroom_name, "pos_xy", 0, 0, "", pos_xy_anm_table );
  ObjAnimate( subroom_name, "scale_xy", 0, 0, "", scale_xy_anm_table );
  ObjAnimate( public.BLACK, "alp", 0, 0, "", {0,0,0, tme,0,private.BLACK_ALP} );

  interface.ShowFrameSubroom( alpha_anm_table, pos_xy_anm_table, scale_xy_anm_table );

end;
--********************************************************************************************************************
function public.Hide( event_id, subroom_name, pos_beg, pos_end )
  --ld.LockCustom( "subroom_impl", 1 )
  public.IsAnim = true;
  --ObjSet( subroom_name, { bake = 1 } )
  --local trg = function() ObjSet( subroom_name, { clear_bake = 1, bake = 0 } ) subroom.EventAnimEnd( event_id ); end;
  local trg = function()
    --ld.LockCustom( "subroom_impl", 0 )
    subroom.EventAnimEnd( event_id );
    public.IsAnim = false;

    local zz_name = ld.StringDivide(subroom_name)[2]
    if ObjGet("obj_"..zz_name.."_overlay") then
      ObjDetach("obj_"..zz_name.."_overlay")
    end
    
  end;
  local o = ObjGet( subroom_name )
  local tme = private.HIDE_TIME * o.scale_x;

  local alpha_anm_table = {0,0,o.alp, tme*0.5,0,o.alp, tme,2,0 };
  local pos_xy_anm_table = {0,0,o.pos_x,o.pos_y, tme,2,pos_beg.x,pos_beg.y};
  local scale_xy_anm_table = {0,0,o.scale_x,o.scale_y, tme,2,0,0};

  SoundSfx( "reserved/aud_close_zz" )

  ObjAnimate( subroom_name, "alp", 0, 0, trg, alpha_anm_table );
  ObjAnimate( subroom_name, "pos_xy", 0, 0, "", pos_xy_anm_table );
  ObjAnimate( subroom_name, "scale_xy", 0, 0, "", scale_xy_anm_table );
  ObjAnimate( public.BLACK, "alp", 0, 0, "", {0,0,private.BLACK_ALP, tme,0,0} );

  interface.HideFrameSubroom( alpha_anm_table, pos_xy_anm_table, scale_xy_anm_table );

  ---- MiniGameHide ----
  local index = string.len(subroom_name);
  local name = cmn.current_mg or string.sub( subroom_name, 4, index );
  
  if ( ng_global.progress[ng_global.currentprogress]["win_"..name] ~= nil ) then

    if cmn.current_mg and common_impl.hint["win_"..name].zz and common_impl.hint["win_"..name].zz:find("^mg_") then

      --исключение для MG с зумзонами

    elseif  ( cmn.IsEventStart( "win_"..name ) ) and ( not cmn.IsEventDone( "win_"..name )  ) then

      cmn.MiniGameHide( name );

    end;

  end;

  -- >>>> показ спрайта на BBT блэкбаре + липсинк >>>>
    int_blackbartext_impl.HideLipSink( subroom_name )
  -- <<<< показ спрайта на BBT блэкбаре + липсинк <<<<

end;
--********************************************************************************************************************
