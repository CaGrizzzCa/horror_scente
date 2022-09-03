-- name=rm_entrypoint
--*********************************************************************************************************************
function public.Init()
  --------------------------------------------------------------------------------------------
  private.room_objname = "rm_entrypoint";
  --------------------------------------------------------------------------------------------
  private.InitZz()

-------------------------------------------------------------------------------------  
--------------------------------------------------------------------------------------------
function private.opn_entrypoint()

end;


local opn_entrypoint = function()

end;
local opn_entrypoint_logic = function() 

end;
cmn.AddSubscriber( "opn_entrypoint", opn_entrypoint_logic )
cmn.AddSubscriber( "opn_entrypoint", opn_entrypoint, private.room_objname )

--------------------------------------------------------------------------------------------
function private.SeeIntro()

  local vid = "vid_entrypoint_vid_intro";

  local func_end = function() 
    cmn.SetEventDone( "opn_entrypoint" );
    cmn.CallEventHandler( "opn_entrypoint" );
    int.DialogVideoHide()
    VidPause(vid, 1)
    ld.Lock(1)
    ObjAnimate( vid, 8, 0, 0, function() 
      ld.Lock(0)
      ObjDelete(vid)
      ld.ShowBbt("bbt_opn_entrypoint");
      --level.tutorial_question.first()
    end, {0,0,1, 0.5,1,0} );
    ld.SetWidgetsVisible( "DialogVideoShow", true );
    SoundEnv( "aud_entrypoint_env" )
  end

  ld.SetWidgetsVisible( "DialogVideoShow", 0, true );
  ObjAttach(vid, "rm_entrypoint")
  int.DialogVideoShow( "", 1, func_end );
  ObjAnimate(vid, 7, 0, 0, function()
    VidPlay(vid,func_end)
    SoundVoice("aud_vid_intro1_entrypoint_voc")
    SoundVid("aud_vid_intro1_entrypoint")
  end, {0,0,0,    0,0,0});
 
end

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

--------------------------------------------------------------------
--*********************************************************************************************************************
-- function *** PROGRESS MISC *** () end;
--*********************************************************************************************************************

end
--*********************************************************************************************************************
function public.LoadRmForExp()--!EXP функция если нужно что-то для EXP

end
--*********************************************************************************************************************
function public.Load()

end;
--*********************************************************************************************************************
function public.Open()
  private.opn_entrypoint();
  --level.tutorial_question.first()
  --level.tutorial_dialog.first()
  --level.tutorial_zz.first()
  --level.tutorial_deploy.first()
  --level.tutorial_hint.first()
  --level.tutorial_hosparkles.first()
  --level.tutorial_navigation.first()
  --level.tutorial_task.first()

  local inv_hub = "level_inv_hub"
  if ObjGet(inv_hub) then
    for i,o in ipairs(ObjGetRelations( inv_hub ).childs) do
      for j,k in ipairs(ObjGetRelations( o ).childs) do
        if ObjGet(k) and ObjGet(k).input then
          ld.LogTrace( "Error in inv object ",k , "why input is on?");
        end
      end
    end
  end
end;
--*********************************************************************************************************************
function public.PreOpen()
  if not ( cmn.IsEventDone( "opn_entrypoint" ) ) then
    private.SeeIntro()
  else
    SoundEnv( "aud_entrypoint_env" )
  end;
end;
--*********************************************************************************************************************
function public.Close()

end;
--*********************************************************************************************************************
function public.PreClose()
  SoundEnv()
end;
--*********************************************************************************************************************
function private.InitZz()

end;
--*********************************************************************************************************************
-- function *** OTHER *** () end;
--*********************************************************************************************************************