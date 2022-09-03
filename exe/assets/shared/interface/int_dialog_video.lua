-- name=int_dialog_video
--******************************************************************************************
function public.Init( pos_z )

  interface.LoadImplementation( "dialog_video" );
  private.object_current = nil;
  private.skip_func = nil;
  private.event_anim_end = {};
  ObjAttach( "int_dialog_video", interface.originhub );
  ObjSet( "int_dialog_video", { pos_z = pos_z } );
  
  MsgSubscribe(Command_ShowSubtitles, private.ShowSubtitle);
  MsgSubscribe( Command_Interface_UpdateTextures, private.WideScreenUpdate );

end;
--******************************************************************************************
function public.Destroy()

  MsgUnsubscribe(Command_ShowSubtitles, private.ShowSubtitle);
  MsgUnsubscribe( Command_Interface_UpdateTextures, private.WideScreenUpdate );

end;
--******************************************************************************************
function public.Show( object_name, block_input, skip_func, skip_time )

  if ( not private.object_current ) then

    ObjSet( "int_dialog_video", { active = true, visible = true, input = true } );

    ObjSet( "obj_int_dialog_video_skip", { input = false } );
    ObjSet( "tmr_int_dialog_video_skip", { playing = false } );

    if ( skip_time == 0 ) then
      ObjSet( "obj_int_dialog_video_skip", { visible = true } );
    else
      ObjSet( "obj_int_dialog_video_skip", { visible = false } );
    end;

    local add_width = 40
    local skip_w = add_width + ObjGet( "txt_int_dialog_video_skip" ).draw_width;
    local skip_h = 10 + ObjGet( "txt_int_dialog_video_skip" ).draw_height;
    ObjSet( "obj_int_dialog_video_skip", {
      inputrect_init = 1,
      inputrect_x    = -0.5*skip_w,
      inputrect_y    = -0.5*skip_h,
      inputrect_w    = skip_w,
      inputrect_h    = skip_h
    } );

    private.object_current = object_name;
    private.skip_func = skip_func;

    ObjSet( object_name, {pos_z = -1000} );
    ObjAttach( object_name, "int_dialog_video" );
    ObjSet( "obj_int_dialog_video_input", { input = block_input } );

    local event_id = "show";
    private.event_anim_end[ event_id ] = { skip_time = skip_time };
    int_dialog_video_impl.ShowAnim( event_id );

  end;

end;
--******************************************************************************************
function public.Hide()

  if ( private.object_current ) then

    ObjSet( "obj_int_dialog_video_skip", { input = false } );

    local event_id = "hide";
    private.event_anim_end[ event_id ] = {};
    int_dialog_video_impl.HideAnim( event_id );

  end;

end;
--******************************************************************************************
function public.EventAnimEnd( event_id )

  local event_params = private.event_anim_end[ event_id ];

  ------------------------------------------------------------------------------------
  if ( event_id == "show" ) then

  local skip_time = event_params[ "skip_time" ];
  if ( skip_time == 0 ) then
    ObjSet( "obj_int_dialog_video_skip", { input = true } );
  else
    ObjSet( "tmr_int_dialog_video_skip", { 
      endtrig = private.SkipShow,
      time    = skip_time,
      playing = 1
    } );
  end;

------------------------------------------------------------------------------------
  elseif ( event_id == "skip_show" ) then

  ObjSet( "obj_int_dialog_video_skip", { input = true } );

------------------------------------------------------------------------------------
  elseif ( event_id == "hide" ) then

  ObjDetach( private.object_current );
  private.object_current = nil;
  ObjSet( "int_dialog_video", { active = false, visible = false, input = false } );

------------------------------------------------------------------------------------
  elseif ( event_id == "subtitle_show" ) then
  --

------------------------------------------------------------------------------------
  elseif ( event_id == "subtitle_hide" ) then
  --

------------------------------------------------------------------------------------
  end;

end;
--******************************************************************************************
function public.SkipClick()

  if private.object_current and type(private.object_current) == "string" and private.object_current:find("^vid_") then
    ld.LogTrace( "paused", private.object_current);
    VidPause(private.object_current, 1)
  end

  if private.skip_func then
    if GetCurrentRoom() ~= "rm_intro" then
      SoundVid( 0 )
    end
    private.skip_func();
  end;

end;
--******************************************************************************************
function private.SkipShow()

  ObjSet( "obj_int_dialog_video_skip", { visible = true } );

  local event_id = "skip_show";
  private.event_anim_end[ event_id ] = message_params;
  int_dialog_video_impl.SkipShowAnim( event_id );

end;
--******************************************************************************************
function private.WideScreenUpdate()

  interface.WideScreenUpdate( "dialog_video" );

end;
--******************************************************************************************
function private.ShowSubtitle( msg, message_params )

  if message_params[ "show" ] == 1 then

    local text_id = message_params[ "text_id" ];

    ObjSet( "txt_int_dialog_video_subtitle", { text = text_id } );

    local event_id = "subtitle_show";
    private.event_anim_end[ event_id ] = {};
    int_dialog_video_impl.SubtitleShowAnim( event_id );

  else

    private.HideSubtitle();

  end;

end;
--******************************************************************************************
function private.HideSubtitle()

  local event_id = "subtitle_hide";
  private.event_anim_end[ event_id ] = {};
  int_dialog_video_impl.SubtitleHideAnim( event_id );

end;
--******************************************************************************************
--******************************************************************************************
function public.ShowSubtitle( msg, message_params )

  private.ShowSubtitle( msg, message_params )

end;
--******************************************************************************************
function public.HideSubtitle()

  private.HideSubtitle()

end;
--******************************************************************************************