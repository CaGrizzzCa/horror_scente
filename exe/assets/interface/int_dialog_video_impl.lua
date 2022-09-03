-- name=int_dialog_video_impl
--******************************************************************************************
function public.Init ()

  public.DIRECTION  = 0;
  private.SKIP_POS_X = ObjGet( "obj_int_dialog_video_skip" ).pos_x;

  private.TOP_POS_BEG = -400;
  private.TOP_POS_END = -368;
  private.BOT_POS_BEG = 400;
  private.BOT_POS_END = 369;

  private.SHOW_ANIM_TIME            = 0.6;
  private.SUBTITLE_SHOW_ANIM_TIME   = 0.3;
  private.SKIP_MOUSE_OVER_ANIM_TIME = 0.3;
  private.SKIP_SHOW_ANIM_TIME       = 0.3;

  ObjSet("obj_int_dialog_video_skip", {
    event_mdown = int_dialog_video.SkipClick,
    event_menter = public.SkipMouseEnterAnim,
    event_mleave = public.SkipMouseLeaveAnim
  });

end;
--******************************************************************************************
function public.WideScreenUpdate()

  if ( not GetWideScreen() ) then

    ObjSet( "obj_int_dialog_video_skip", { pos_x = private.SKIP_POS_X } );

  else

    local offset = 0.5 * ( GetAppWidth() - 1024 );
    ObjSet( "obj_int_dialog_video_skip", { pos_x = ( private.SKIP_POS_X + offset ) } );

  end;

end;
--******************************************************************************************
function public.SkipShowAnim( event_id )

  local obj = "obj_int_dialog_video_skip";
  local trg = function () int_dialog_video.EventAnimEnd( event_id ); end;
  local tme = private.SKIP_SHOW_ANIM_TIME;

  ObjAnimate( obj, "alp", 0, 0, trg,
  {
    0.0, 3, 0,
    tme, 3, 1
  } );

end;
--******************************************************************************************
function public.SkipMouseEnterAnim()

  SetCursor( CURSOR_HAND );

  local objs = {
    --"txt_int_dialog_video_skip_focus";
    "spr_int_dialog_video_skip_button_focus";
    "spr_int_dialog_video_skip_button_focus_add";
  }

  for _,obj in ipairs(objs) do

    local alp = ObjGet( obj ).alp;
    local tme = ( 1 - alp ) * private.SKIP_MOUSE_OVER_ANIM_TIME;

    ObjAnimate( obj, "alp", 0, 0, "",
    {
      0.0, 2, alp,
      tme, 2, 1
    } );

  end

end;
--******************************************************************************************
function public.SkipMouseLeaveAnim()

  SetCursor( CURSOR_DEFAULT );

  local objs = {
    --"txt_int_dialog_video_skip_focus";
    "spr_int_dialog_video_skip_button_focus";
    "spr_int_dialog_video_skip_button_focus_add";
  }

  for _,obj in ipairs(objs) do

    local alp = ObjGet( obj ).alp;
    local tme = alp * private.SKIP_MOUSE_OVER_ANIM_TIME;

    ObjAnimate( obj, "alp", 0, 0, "",
    {
      0.0, 1, alp,
      tme, 1, 0
    } );

  end

end;
--******************************************************************************************
function public.ShowAnim( event_id )

  local trg = function () int_dialog_video.EventAnimEnd( event_id ); end;
  local tme = private.SHOW_ANIM_TIME;

  if int_blackbartext then
    int_blackbartext.Hide()
  end

  ObjAnimate( "int_dialog_video", "alp", 0, 0, trg,
  {
    0.0, 3, 0,
    tme, 3, 1
  } );

  ObjAnimate( "spr_int_dialog_video_top", 1, 0, 0, function() end, {0,0,private.TOP_POS_BEG, tme,3,private.TOP_POS_END} );
  ObjAnimate( "spr_int_dialog_video_bot", 1, 0, 0, function() end, {0,0,private.BOT_POS_BEG, tme,3,private.BOT_POS_END} );

end;
--******************************************************************************************
function public.HideAnim( event_id )

  int_dialog_video.HideSubtitle()
  SoundVoice( 0 )
  local trg = function () int_dialog_video.EventAnimEnd( event_id ); end;
  local tme = private.SHOW_ANIM_TIME;

  ObjAnimate( "int_dialog_video", "alp", 0, 0, trg,
  {
    0.0, 3, 1,
    tme, 3, 0
  } );

  ObjAnimate( "spr_int_dialog_video_top", 1, 0, 0, function() end, {0,0,private.TOP_POS_END, tme,3,private.TOP_POS_BEG} );
  ObjAnimate( "spr_int_dialog_video_bot", 1, 0, 0, function() end, {0,0,private.BOT_POS_END, tme,3,private.BOT_POS_BEG} );

end;
--******************************************************************************************
function public.SubtitleShowAnim( event_id )

  local obj = "txt_int_dialog_video_subtitle";
  local trg = function () int_dialog_video.EventAnimEnd( event_id ); end;
  local alp = ObjGet( obj ).alp;
  local tme = ( 1 - alp ) * private.SUBTITLE_SHOW_ANIM_TIME;

  ObjAnimate( obj, "alp", 0, 0, trg,
  {
    0.0, 3, alp,
    tme, 3, 1
  } );

end;
--******************************************************************************************
function public.SubtitleHideAnim( event_id )

  local obj = "txt_int_dialog_video_subtitle";
  local trg = function () int_dialog_video.EventAnimEnd( event_id ); end;
    if ObjGet( obj ) then
      local alp = ObjGet( obj ).alp;
      local tme = alp * private.SUBTITLE_SHOW_ANIM_TIME;

      ObjAnimate( obj, "alp", 0, 0, trg,
      {
        0.0, 3, alp,
        tme, 3, 0
      } );
    end
end;
--******************************************************************************************