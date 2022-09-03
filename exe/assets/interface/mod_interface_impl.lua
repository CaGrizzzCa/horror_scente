-- name=interface_impl
-----------------------------interface_impl------------------------------------------------
function public.Init ()
    

    private.Init_Deploy();
    public.Init_DialogHint();
    public.Init_BtnProvide();
    public.Init_Lock();
    public.Init_InvestigationButton();
    private.Init_Diary();
    public.Init_Btn_Diary();

    private.Init_Task()
    
    private.Init_Helper()

    private.Init_Panelhopair()


    private.ach_mg_count = 13;
    private.ach_ho_count = 13;
    private.InitAchievement()

    --private.InitPanelscr()   
    private.InitPanelsgm()
    private.InitMap() 
    private.InitBtnHintInsgm()
end;
--******************************************************************************************
function private.Init_Deploy()

  function interface.DeployInvAdd(pos_z)

    InterfaceWidget_Deploy_Inv = "InterfaceWidget_Deploy_Inv";
    interface.CustomWidgetAdd( InterfaceWidget_Deploy_Inv, "assets/interface/int_deploy_inv", "int_deploy_inv",pos_z );

  end;

  -------------------------------------------------------------------------------------

  function interface.DeployInvShow( inv_obj )

    common_impl.DeleteHintFx()

    local obj = "";
    common.CallRoomEventHandlers( inv_obj );
    --DbgTrace( "DeployInvShow" );
    if ( ng_global.currentprogress == "std" ) then

      --local lvl = string.sub( prg.level, 6 );
      --local level = tonumber( lvl );
      subroom.Close();     
      obj = "level1_inv_deploy";

    end;

    if level1_inv.list_obj ~= nil then

      for i=1, #level1_inv.list_obj do

        ObjAttach( level1_inv.list_obj[i], obj);

      end;

    end;

    if int_deploy_inv.show == 0 then   

      if _G[ "int_deploy_inv" ] then

        int_deploy_inv.Show( inv_obj );

      end;

    else

      interface.DeployInvHide();

    end;


  end;

  -------------------------------------------------------------------------------------

  function interface.DeployInvHide()

    --common_impl.DeleteHintFx()

    if int_deploy_inv.show == 1 then
  
      if _G[ "int_deploy_inv" ] then

        int_deploy_inv.Hide();

      end;
    
    end;
    
  end;

end;
--******************************************************************************************
function public.Init_DialogHint()

  -------------------------------------------------------------------------------------
  function interface.DialogHintAdd(pos_z)

    InterfaceWidget_Dialog_Hint = "InterfaceWidget_Dialog_Hint";
    interface.CustomWidgetAdd( InterfaceWidget_Dialog_Hint, "assets/interface/int_dialog_hint", "int_dialog_hint",pos_z );

  end;

  -------------------------------------------------------------------------------------

  function interface.DialogHintShow( dlg_room )

    dlg_room = dlg_room;  
    SoundSfx( "reserved/aud_click_menu" )
    int_dialog_hint.Show( dlg_room );

  end;

  -------------------------------------------------------------------------------------

  function interface.DialogHintHide()

    int_dialog_hint.Hide();

  end;

end;
--******************************************************************************************
function public.Init_BtnProvide()

  -------------------------------------------------------------------------------------
  function interface.BtnProvideAdd(pos_z)

    InterfaceWidget_Btn_Providence = "InterfaceWidget_Btn_Providence";
    interface.CustomWidgetAdd( InterfaceWidget_Btn_Providence, "assets/interface/int_button_providence", "int_button_providence", pos_z );

  end;

  -------------------------------------------------------------------------------------

  function interface.BtnProvideShow()

    if _G[ "int_button_providence" ] then

        int_button_providence.Show();

    end;

  end;

  -------------------------------------------------------------------------------------

  function interface.BtnProvideHide()

    if _G[ "int_button_providence" ] then

      int_button_providence.Hide();

    end;

  end;

end;
--******************************************************************************************
function public.Init_Lock()

  function interface.LockAdd()

    InterfaceWidget_Lock = "InterfaceWidget_Lock";
    interface.CustomWidgetAdd( InterfaceWidget_Lock, "assets/interface/int_lock", "int_lock",1490 );

    ------------------------------------------------------------------------------------

    function interface.LockShow()

      if _G[ "int_lock" ] then

        int_lock.Show();

      end;

    end;

    ------------------------------------------------------------------------------------
    
    function interface.LockHide()

      if _G[ "int_lock" ] then

          int_lock.Hide();

      end;

    end;

    ------------------------------------------------------------------------------------

    function interface.LockShowRm()

      if _G[ "int_lock" ] then

        int_lock.ShowRm();

      end;

    end;

    ------------------------------------------------------------------------------------
    
    function interface.LockHideRm()

      if _G[ "int_lock" ] then

          int_lock.HideRm();

      end;

    end;

    ------------------------------------------------------------------------------------

    function interface.LockShowTask()

      if _G[ "int_lock" ] then

        int_lock.ShowTask();

      end;

    end;

    ------------------------------------------------------------------------------------
    
    function interface.LockHideTask()

      if _G[ "int_lock" ] then

          int_lock.HideTask();

      end;

    end;

    ------------------------------------------------------------------------------------

    function interface.LockShowCustom( name )

      if _G[ "int_lock" ] then

        int_lock.ShowCustom( name );

      end;

    end;

    ------------------------------------------------------------------------------------
    
    function interface.LockHideCustom( name )

      if _G[ "int_lock" ] then

          int_lock.HideCustom( name );

      end;

    end;

  end;

end;
--******************************************************************************************
function public.Init_Btn_Diary()

  function interface.Btn_DiaryAdd(pos_z)

    InterfaceWidget_Btn_Diary = "InterfaceWidget_Btn_Diary";
    interface.CustomWidgetAdd( InterfaceWidget_Btn_Diary, "assets/interface/int_button_diary", "int_button_diary",pos_z );

    ------------------------------------------------------------------------------------


--
 end;

end;


--******************************************************************************************
function public.Init_InvestigationButton()

  function interface.InvestigationButtonAdd( pos_z )

    InterfaceWidget_InvestigationButton = "InterfaceWidget_InvestigationButton";
    interface.CustomWidgetAdd( InterfaceWidget_InvestigationButton, "assets/interface/int_investigation_button", "int_investigation_button", pos_z );

  end;

end;
--******************************************************************************************
function private.Init_Diary()

  function interface.DiaryAdd(pos_z)

    InterfaceWidget_Diary = "InterfaceWidget_Diary";
    interface.CustomWidgetAdd( InterfaceWidget_Diary, "assets/interface/int_diary", "int_diary",pos_z );

  end;
  ------------------------------------------------------------------------------------

  function interface.DiaryDcnAdd( pos_z )

    InterfaceWidget_Diary_Dcn = "InterfaceWidget_Diary_Dcn";
    interface.CustomWidgetAdd( InterfaceWidget_Diary_Dcn, "assets/interface/int_diary_dcn", "int_diary_dcn", pos_z );

  end;
  ------------------------------------------------------------------------------------

  function interface.DiaryShow()
    
    if int_diary.show == 0 then 
     
      if _G[ "int_diary" ] then

         int_diary.Show();

      end;

    else

      interface.DiaryHide();

    end;

  end;

  ------------------------------------------------------------------------------------

  function interface.DiaryHide()

    if int_diary.show == 1 then

      if _G[ "int_diary" ] then

         int_diary.Hide();

      end;

    end;
    
  end;

  ------------------------------------------------------------------------------------

  function interface.DiaryDcnShow( name_obj,func )
    
    local diary   = "int_diary";
    local storage = "obj_diary_evidence_big";

    if int_diary_dcn.show == 0 then 

      if int_diary_dcn.show_obj ~= "" then
    
        ObjAttach( int_diary_dcn.show_obj, storage );
        int_diary_dcn.show_obj = "";
      
      end;
      
      if _G[ "int_diary_dcn" ] then

        int_diary_dcn.Show( name_obj,func );

      end;
      
    else
    
      interface.DiaryDcnHide();
    
    end;

  end;

  ------------------------------------------------------------------------------------

  function interface.DiaryDcnHide()

    if int_diary_dcn.show == 1 then

        if _G[ "int_diary_dcn" ] then

          local index = string.find( int_diary_dcn.show_obj, "_evidence_" );
          local len = string.len( int_diary_dcn.show_obj );
          local dcn = string.sub( int_diary_dcn.show_obj, index + 1, len );

          int_diary_dcn.Hide();
          common_impl.ShowCurrentInterface( dcn );

        end;

    end;

  end;

end;
--******************************************************************************************
--******************************************************************************************
function private.Init_Task ()

  function interface.ButtonTaskAdd ( pos_z )

    InterfaceWidget_Button_Task = "InterfaceWidget_Button_Task";
    interface.CustomWidgetAdd( InterfaceWidget_Button_Task, "assets/interface/int_button_task", "int_button_task", pos_z );

  end;
  ------------------------------------------------------------------------------------
  function interface.DialogTaskAdd ( pos_z )

    InterfaceWidget_Dialog_Task = "InterfaceWidget_Dialog_Task";
    interface.CustomWidgetAdd( InterfaceWidget_Dialog_Task, "assets/interface/int_dialog_task", "int_dialog_task", pos_z );

  end;
  ------------------------------------------------------------------------------------
  function interface.DialogTaskShow ( task, state, func_end )
    
    if not _G[ "cheater" ] or not cheater.is_progress_executing_now then

      local data = { task = task or ng_global["task_current_"..ng_global.currentprogress], state = state or "current_task", func_end = func_end };

      if ( not int_dialog_task.show ) then 
       
        if ( _G[ "int_dialog_task" ] ) then

            SoundSfx( "reserved/aud_global_task" )
           int_dialog_task.Show( data );

        end;

      else

        interface.DialogTaskHide();

      end;

    end

  end;
  ------------------------------------------------------------------------------------
  function interface.DialogTaskHide (force)

    --local func_end = function() 
    --  SndStop( "assets/audio/aud_task_window", 0.5 )
    --  int_dialog_task.Hide();
    --end 
    --
    --if ng_global.currentprogress == "scr" then
    --  func_end()
    --  return;
    --end;
    
    if  ( int_dialog_task.show ) or force then
      if ( _G[ "int_dialog_task" ] ) then

        SndStop( "assets/audio/aud_task_window", 0.5 )
        int_dialog_task.Hide();

      end;

    end;
    
  end;
  ------------------------------------------------------------------------------------
  function interface.KeyTaskAdd ( task_name, runtime, func_end )

    ng_global["task_current_"..ng_global.currentprogress] = task_name;
    int_button_task.Update( true, task_name );

    --SoundSfx( "aud_task" )
    
    interface.DialogTaskShow( task_name, "new_task", func_end );

  end;
  ------------------------------------------------------------------------------------
  function interface.KeyTaskDone ( runtime )

    if ( runtime ) then

      interface.DialogTaskShow( ng_global["task_current_"..ng_global.currentprogress], "done_task" );  

    end;
    int_button_task.Update( false, "none" );
    ng_global["task_current_"..ng_global.currentprogress] = "none";
  
  end;
  ------------------------------------------------------------------------------------
  function interface.KeyUpdate ()
    -->> забиваем таск, чтобы по умолчанию быд активен, в первом же доне должен быть выставлен нормальный таск
    --ng_global["task_current_"..ng_global.currentprogress] = ng_global["task_current_"..ng_global.currentprogress] or "first_free"
    --<<
    local active = false;
    if ( ng_global["task_current_"..ng_global.currentprogress] ) and ( ng_global["task_current_"..ng_global.currentprogress] ~= "none" ) then
      active = true;
    end;

    int_button_task.Update( active, ng_global["task_current_"..ng_global.currentprogress] );
  
  end;
  ------------------------------------------------------------------------------------
  function interface.SetTask(task_name)

    ng_global["task_current_"..ng_global.currentprogress] = task_name;
    int_button_task.Update( true, task_name );
    if MsgSend( Request_Level_IsLoading, {} ).loading == 0 then

      --if task_name == "leveltask_1" then 
      --  --interface.DialogTaskShow (nil,"new_task",level.tutorial_question.first) -- после первого таска запустить первый туториал
      --elseif task_name == "leveltask_2" then 
      --  --interface.DialogTaskShow (nil,"new_task",level.tutorial_map1.first) -- после первого таска запустить первый туториал
      --else
      
        interface.DialogTaskShow (nil,"new_task")
        --end

    end
  end

end

--******************************************************************************************
--******************************************************************************************
function private.Init_Helper()

  function interface.HelperAdd(pos_z)

    InterfaceWidget_Helper = "InterfaceWidget_Helper";
    interface.CustomWidgetAdd( InterfaceWidget_Helper, "assets/interface/int_helper", "int_helper",pos_z );
    int_helper.HelperStaticStart()

    ng.debug.AddHintVideo("vid_helper_static")
    ng.debug.AddHintVideo("vid_helper_vid_dojump")
    ng.debug.AddHintVideo("vid_helper_vid_doreturn")
    ng.debug.AddHintVideo("vid_helper_vid_first")
    ng.debug.AddHintVideo("vid_helper_vid_dobackready")
    ng.debug.AddHintVideo("vid_helper_vid_static_3")
    ng.debug.AddHintVideo("vid_helper_vid_static_5")
    ng.debug.AddHintVideo("vid_helper_vid_static_4")
    ng.debug.AddHintVideo("vid_helper_vid_static_2")
    ng.debug.AddHintVideo("vid_helper_vid_doready")
    ng.debug.AddHintVideo("vid_helper_vid_static_1")
    
  end;

-------------------------------------------------------------------------------------

  function interface.HelperSetVisible(set_visible)
    int_helper.HelperSetVisible(set_visible)
  end

  --function interface.HelperActiveDeploy(set_active)
  --  SendMessage(Command_Helper_ActiveDeploy, { set_active = set_active } );
  --end
  --

  function interface.HelperGet()   
    int_helper.HelperGet()
  end

  function interface.HelperEnterZone(zz)
    if not InterfaceWidget_Helper then return end

    local inv = "obj_helper_cursor_drag"
    local found = false
    
    if zz then
      zz = zz:gsub("^gzz_%w+_", "")
      for i,o in pairs(common_impl.hint) do    
        if o.inv_obj == inv and o.type == "use" and o.zz == "zz_"..zz and not ld.CheckRequirements({i}) and ObjGet( o.use_place ).input then
          found = true
          break
        end
      end
    else 
      found = true -- если не зз
    end
    if int_helper.drag_helper == 1 and found then
    
      int_helper.HelperCursorEnterZone()
    end

  end

  function interface.HelperLeaveZone(zz)
    if not InterfaceWidget_Helper then return end
    if int_helper.drag_helper == 1 then
      int_helper.HelperCursorLeaveZone()
    end
  end

  function interface.HelperWrongApply()
      int_helper.HelperDeActiveCursor()
  end

  function interface.HelperFirstVid()
      int_helper.HelperFirstVid()
  end


  function interface.HelperJump(func)
      int_helper.HelperJump(func)
  end

  function interface.HelperReturn()
      int_helper.HelperReturn()
  end

  function interface.HelperVidStart() --vid_attention_cycle
    int_helper.HelperVidStart()
  end

  function interface.HelperVidEnd()    
    int_helper.HelperVidEnd()
  end

end
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
function private.Init_Panelhopair()

  function interface.PanelhopairAdd(pos_z)
    InterfaceWidget_PanelHoPair = "InterfaceWidget_PanelHoPair";
    interface.CustomWidgetAdd( InterfaceWidget_PanelHoPair, "assets/interface/int_panelhopair", "int_panelhopair",pos_z );
  end;


  function interface.PanelHoPair_Show(ho_name,ho_tasks)
    if ng_global.currentprogress == "std" then
      interface_impl.StartHoAchievements( ho_name );
    end

    interface.panelhopair = {}
    interface.panelhopair.taskname = {"",""}
    interface.panelhopair.taskname_num = {0,0}
    interface.panelhopair.taskname_pair = 0
    interface.panelhopair.countdown = 0

    interface.WidgetSetVisible( "InterfaceWidget_Inventory", false,true );
    interface.WidgetSetInput("InterfaceWidget_Inventory", 0 )

    --local ho_name = cmn.GetObjectName( GetCurrentRoom() );
    local ho_progress = ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ];

    for i = 1, #ho_tasks, 1 do
      interface.panelhopair.countdown = interface.panelhopair.countdown + 1
    end

    --SendMessage(Command_PanelHoPair_Show)
    int_panelhopair.ShowAnim("show")
    interface.panelhopair.ho_tasks = ho_tasks


    
  end

  function interface.PanelHoPair_Hide(ho_name)
    interface.WidgetSetVisible( "InterfaceWidget_Inventory", true,true );
    interface.WidgetSetInput("InterfaceWidget_Inventory", 1 )
    int_panelhopair.HideAnim("hide")
    if ng_global.currentprogress=="std" then
     interface_impl.SaveAchievementsTimers();
    end
  end

  function private.PanelHoPair_SendTask(ho_name,task_name,num)
    int_panelhopair.SendTask(ho_name,task_name,num)
  end

  function private.PanelHoPair_CompliteTask(ho_name,task_name,assoc)
    int_panelhopair.CompliteTask(ho_name,task_name,assoc)
  end

  function private.PanelHoPair_ClearTask()
    int_panelhopair.ClearTask()
  end
  function private.PanelHoPair_LoadLights(ho_name,assoc)
    int_panelhopair.LoadLights(ho_name,assoc)
  end


  function interface.ItemHoPairOpen(obj,not_anim)
    

    local ho_name = ld.StringDivide(obj)[2]
    local task_name = ld.StringDivide(obj)[3]
    local num = ld.StringDivide(obj)[5]

    
    ng_global.progress[ prg.current ][ "win_"..ho_name ].start = 1;

    ObjSet( obj, {input = 0} );
    ld.Lock(1)
    
    
    ObjSet( "spr_"..ho_name.."_"..task_name.."_"..num, {input=1} );

  --  ObjSet( "anm_"..ho_name.."_anim_glow_"..task_name, {alp=1} );
  --  ObjSet( "anm_"..ho_name.."_anim_glow_"..task_name.."_"..num, {alp=1} );

    local sfx = {
      cachehoext = {
        aaa = { "aud_click_cachehoext_vase", "aud_click_cachehoext_teddybear" };
        bbb = { "aud_click_cachehoext_sun", "aud_click_cachehoext_book" };
        ccc = { "aud_click_cachehoext_christmasbook", "aud_click_cachehoext_plate" };
        ddd = { "aud_click_cachehoext_curtain", "aud_click_cachehoext_statuette" };
        eee = { "aud_click_cachehoext_box", "aud_click_cachehoext_shield" };
        fff = { "aud_click_cachehoext_wreath", "aud_click_cachehoext_binoculars" };
      };
    }
    if ho_name == "tree" then
      PlaySfx( "assets/audio/aud_click_ho_tree_things", 0, "", 0.0 )
    elseif sfx[ho_name] and sfx[ho_name][task_name] and sfx[ho_name][task_name][tonumber( num )] then
      SoundSfx( sfx[ho_name][task_name][tonumber( num )] )
    end

    if interface.panelhopair.taskname_pair== 0 then
      interface.panelhopair.taskname[1] = task_name
      interface.panelhopair.taskname_num[1] = num
      interface.panelhopair.taskname_pair = 1 
     -- ObjAnimate( obj, 8, 0, 0, "", {0,0,1, 0.5,0,0} );
      if not_anim then
        ld.Lock(0);

      else
       -- DbgTrace("anm_"..ho_name.."_anim_open_"..task_name.."_"..num)
       -- DbgTrace("anim_open_"..task_name..num)
        ld.AnimPlay("anm_"..ho_name.."_anim_open_"..task_name.."_"..num, "anim_open_"..task_name..num,function () ld.Lock(0)end)
      end
      ObjSet( "fx_pyrotechnics_items_back_"..interface.panelhopair.taskname_pair, {active = 1 , visible = 1 , pos_x = ObjGet("spr_"..ho_name.."_"..task_name.."_"..num).pos_x,pos_y = ObjGet("spr_"..ho_name.."_"..task_name.."_"..num).pos_y} );
    else 
      interface.panelhopair.taskname[2] = task_name
      interface.panelhopair.taskname_num[2] = num
      interface.panelhopair.taskname_pair = 2
      if not_anim then
        
        ld.StartTimer( "t_itemhopaircheck", 0.5, "*ld.Lock(0);private.ItemHoPairCheck(1);" )
      else
        ld.AnimPlay("anm_"..ho_name.."_anim_open_"..task_name.."_"..num,"anim_open_"..task_name..num,function () ld.Lock(0);private.ItemHoPairCheck()end );
      end    
      ObjSet( "fx_pyrotechnics_items_back_"..interface.panelhopair.taskname_pair, {active = 1 , visible = 1 , pos_x = ObjGet("spr_"..ho_name.."_"..task_name.."_"..num).pos_x,pos_y = ObjGet("spr_"..ho_name.."_"..task_name.."_"..num).pos_y} );
    end
      if not_anim then
        private.PanelHoPair_SendTask(ho_name,task_name,num)
      else 
        private.PanelHoPair_SendTask(ho_name,task_name)
      end
  end


   function private.ItemHoPairCheck(not_anim)
    local ho_name = common.GetObjectName( GetCurrentRoom() );
    local ho_progress = ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ];


    if interface.panelhopair.taskname[1] == interface.panelhopair.taskname[2] then
      
      table.insert( ho_progress.found, interface.panelhopair.taskname[1] );
      --Анимация исчезновение
      if not ObjGet( "tmr_interface_impl_item_ho_pair_open" ) then
        SoundSfxGame("reserved/aud_hide", 0.05)
        ld.StartTimer( "tmr_interface_impl_item_ho_pair_open", 0, function()  end )
      end

              
      local ho_found =  ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].found;
      local win_task =  ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].wintask
      local count = 0
      for i = 1, #ho_found, 1 do
        count = count + 1
      end;
      
      private.PanelHoPair_CompliteTask(ho_name,interface.panelhopair.taskname[1],not_anim)
      if count == 6 then
          common_impl.DialogHo_Show()
          if ng_global.currentprogress == "scr" then
            --.CheckTmr("ho_"..ho_name)
          end
          --ld.Lock(1)
          --ld.StartTimer( "tmr_panelhopair_sendtask", 1, function()private.ProcessHoPairComplete() end )

      end
      if ho_name == "cacheho" then
        game[ho_name].open_casket(count)
      end
--      ObjDelete("anm_"..ho_name.."_anim_glow_"..interface.panelhopair.taskname[1])
--
--      ObjDelete( "anm_"..ho_name.."_anim_glow_"..interface.panelhopair.taskname[1].."_"..interface.panelhopair.taskname_num[1] );
--      ObjDelete( "anm_"..ho_name.."_anim_glow_"..interface.panelhopair.taskname[2].."_"..interface.panelhopair.taskname_num[2] );
--

      ld.FxAnmObj("spr_"..ho_name.."_"..interface.panelhopair.taskname[1].."_"..interface.panelhopair.taskname_num[1])
      ld.FxAnmObj("spr_"..ho_name.."_"..interface.panelhopair.taskname[2].."_"..interface.panelhopair.taskname_num[2])


    else 

      local sfx = {
        cachehoext = {
          aaa = { "aud_click_cachehoext_vase", "aud_click_cachehoext_teddybear" };
          bbb = { "aud_click_cachehoext_sun", "aud_click_cachehoext_book" };
          ccc = { "aud_click_cachehoext_christmasbook", "aud_click_cachehoext_plate" };
          ddd = { "aud_click_cachehoext_curtain", "aud_click_cachehoext_statuette" };
          eee = { "aud_click_cachehoext_box", "aud_click_cachehoext_shield" };
          fff = { "aud_click_cachehoext_wreath", "aud_click_cachehoext_binoculars" };
        };
      }
      if sfx[ho_name] and sfx[ho_name][ interface.panelhopair.taskname[1] ] and sfx[ho_name][ interface.panelhopair.taskname[1] ][1] then
        SoundSfx( sfx[ho_name][ interface.panelhopair.taskname[1] ][1] )
      end;
      if sfx[ho_name] and sfx[ho_name][ interface.panelhopair.taskname[2] ] and sfx[ho_name][ interface.panelhopair.taskname[2] ][2] then
        SoundSfx( sfx[ho_name][ interface.panelhopair.taskname[2] ][2] )
      end;

      local obj1 = "anm_"..ho_name.."_anim_open_"..interface.panelhopair.taskname[1].."_"..interface.panelhopair.taskname_num[1]
      local obj2 = "anm_"..ho_name.."_anim_open_"..interface.panelhopair.taskname[2].."_"..interface.panelhopair.taskname_num[2]
      ld.Lock(1)

      if not_anim then
          ld.Lock(0)
      else      
        if ho_name == "tree" then
          PlaySfx( "assets/audio/aud_ho_tree_things_back", 0, "", 0.0 )
        end
          ld.AnimPlay(obj1,"anim_close_"..interface.panelhopair.taskname[1]..interface.panelhopair.taskname_num[1],"")
          ld.AnimPlay(obj2,"anim_close_"..interface.panelhopair.taskname[2]..interface.panelhopair.taskname_num[2],"*ld.Lock(0);  ")
      end
      
--      ObjSet( "anm_"..ho_name.."_anim_glow_"..interface.panelhopair.taskname[1], {alp=0} );
--      ObjSet( "anm_"..ho_name.."_anim_glow_"..interface.panelhopair.taskname[2], {alp=0} );
--
--      ObjSet( "anm_"..ho_name.."_anim_glow_"..interface.panelhopair.taskname[1].."_"..interface.panelhopair.taskname_num[1], {alp=0} );
--      ObjSet( "anm_"..ho_name.."_anim_glow_"..interface.panelhopair.taskname[2].."_"..interface.panelhopair.taskname_num[2], {alp=0} );
--

      ObjSet( "obj_"..ho_name.."_"..interface.panelhopair.taskname[1].."_close_"..interface.panelhopair.taskname_num[1], {input=1} );
      ObjSet( "obj_"..ho_name.."_"..interface.panelhopair.taskname[2].."_close_"..interface.panelhopair.taskname_num[2], {input=1} );
      ObjSet( "spr_"..ho_name.."_"..interface.panelhopair.taskname[1].."_"..interface.panelhopair.taskname_num[1], {input=0} );
      ObjSet( "spr_"..ho_name.."_"..interface.panelhopair.taskname[2].."_"..interface.panelhopair.taskname_num[2], {input=0} );
      private.PanelHoPair_ClearTask()
    end
      interface.panelhopair.taskname = {"",""}
      interface.panelhopair.taskname_num = {0,0}
      interface.panelhopair.taskname_pair = 0

  end


  function interface.ProcessHoPairStart( ho_name,assoc )
   
    local ho_found =  ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].found;
    local win_task =  ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].wintask
    local count = 0


    for i = 1, #ho_found, 1 do
      ObjDelete("spr_"..ho_name.."_"..ho_found[i].."_1")
      ObjDelete("spr_"..ho_name.."_"..ho_found[i].."_2")
      ObjDelete("obj_"..ho_name.."_"..ho_found[i].."_close_1")
      ObjDelete("obj_"..ho_name.."_"..ho_found[i].."_close_2")
      ObjDelete("anm_"..ho_name.."_anim_glow_"..ho_found[i])

      ObjSet( "anm_"..ho_name.."_anim_open_"..ho_found[i].."_1", {animfunc ="anim_close_"..ho_found[i].."1",frame = 0} );
      ObjSet( "anm_"..ho_name.."_anim_open_"..ho_found[i].."_2", {animfunc ="anim_close_"..ho_found[i].."2",frame = 0} );
      count = count + 1   
      --DbgTrace("anm_"..ho_name.."_anim_open_"..ho_found[i].."_1".."   ".."anim_close_"..ho_found[i].."1")
    end;
   
    --if count == 6 then
    --    --ObjSet( "obj_"..ho_name.."_"..win_task.."_close", {input= 1 } );
    --   -- private.PanelHoPair_SendTask(ho_name,win_task)
    --   -- ObjSet( "anm_"..ho_name.."_anim_glow_"..win_task, {alp=1} );
    --end
    private.PanelHoPair_LoadLights(ho_name,assoc)
  end;

  function private.ItemHoPairLastOpen()
    local ho_name = common.GetObjectName( GetCurrentRoom() );
    local obj = ne_params.sender
    --local ho_name = ld.StringDivide(obj)[2]
    --local task_name = ld.StringDivide(obj)[3]
   -- local end_trig = "*cmn.ProcessHoPairComplete()"
    game[ho_name].wintaskanim_open()
   -- ObjAnimate( ne_params.sender, 8, 0, 0, "*cmn.ProcessHoPairComplete()", {0,0,1, 0.5,0,0} );
  end

  function private.ProcessHoPairComplete()
      local ho_name = common.GetObjectName( GetCurrentRoom() );
      --cmn.PlayGetHoSound()

      ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].done = 1;
      ng_global.progress[ ng_global.currentprogress ].common.currentroom = ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].exitroom;

      _G["ho_"..ho_name].HoComplete();

   
  end


  function interface.PanelHoPairHintShow()

  local ho_name = common.GetObjectName( GetCurrentRoom() );
  local ho_progress = ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ];
  local ho_tasks  = interface.panelhopair.ho_tasks
  local items_names = {}
  local itm_name
  local hint_obj = {}
  local count = 0
if ho_tasks then
  
  local ho_found =  ho_progress.found;
    for i = 1, #ho_found, 1 do
       count  = count + 1
    end


if interface.panelhopair.taskname_pair == 1  then --- если открыт один предмет
    --interface.panelhopair.taskname[1] 
    --interface.panelhopair.taskname_num[1] = num

    for i = 1, #ho_tasks do
      if  interface.panelhopair.taskname[1] == ho_tasks[i][1] then
        for j = 1, #ho_tasks[i][2] do
          hint_obj[j] = ho_tasks[i][2][j]
         -- DbgTrace(hint_obj[j])
        end
      end
    end

    table.remove(hint_obj,interface.panelhopair.taskname_num[1])


--elseif count == 6 then
--  if ObjGet(ho_tasks[7][2][1]).input then
--    hint_obj[1] = ho_tasks[7][2][1]
--  else 
--    hint_obj[1] = ho_tasks[7][3][1]
--  end
else
    for i = 1,#ho_tasks do   -- последний таск не проверяем

     itm_name = ho_tasks[i][1]
     local item_found = false; 
 
       for a = 1, #ho_progress.found, 1 do
            if ( string.find( ho_progress.found[a], ho_tasks[i][1] ) ) then
              item_found = true;
              break;
            end;
       end;

      if not item_found then
       table.insert(items_names,itm_name)       
      end

    end

    local name_task= items_names[math.random(1,#items_names)]

    --local obj_name_index
    --for i=1,#items_names do
    --   if name_task == items_names[i][1] then 
    --     obj_name_index = i;
    --     break;
    --   end;
    --end

   
   
    for i = 1, #ho_tasks do
      if  name_task == ho_tasks[i][1] then
        for j = 1, #ho_tasks[i][2] do
          hint_obj[j] = ho_tasks[i][2][j]
         -- DbgTrace(hint_obj[j])
        end
      end
    end
end
---------------------------------
    local hint_param = {}
    for e=1,#hint_obj do
      hint_param[e] = {["pos_x"]=ObjGet(hint_obj[e]).pos_x,["pos_y"]=ObjGet(hint_obj[e]).pos_y,["obj_name"]=hint_obj[e]}

    end
--    
--
    private.PanelHoPairEffect_ShowHoHint(hint_param)



  end
  end;

  function interface.PanelHoPairEffect_ResetState(ho_name)

    for a = 1,6 do 
   -- DbgTrace(game[ho_name].ho_tasks[a][1])

      ObjSet("spr_"..ho_name.."_"..game[ho_name].ho_tasks[a][1].."_1",{input = 0})
      ObjSet("spr_"..ho_name.."_"..game[ho_name].ho_tasks[a][1].."_2",{input = 0})
      ObjSet("obj_"..ho_name.."_"..game[ho_name].ho_tasks[a][1].."_close_1",{input = 1})
      ObjSet("obj_"..ho_name.."_"..game[ho_name].ho_tasks[a][1].."_close_2",{input = 1})
      ObjSet( "anm_"..ho_name.."_anim_open_"..game[ho_name].ho_tasks[a][1].."_1", {animfunc = "anim_open_"..game[ho_name].ho_tasks[a][1].."1",frame = 0} );
      ObjSet( "anm_"..ho_name.."_anim_open_"..game[ho_name].ho_tasks[a][1].."_2", {animfunc = "anim_open_"..game[ho_name].ho_tasks[a][1].."2",frame = 0} );

    end

    local ho_found =  ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].found;
    local win_task =  ng_global.progress[ ng_global.currentprogress ][ "win_"..ho_name ].wintask
    local count = 0


    if ho_found then
      for i = 1, #ho_found, 1 do
        ObjDelete("spr_"..ho_name.."_"..ho_found[i].."_1")
        ObjDelete("spr_"..ho_name.."_"..ho_found[i].."_2")
        ObjDelete("obj_"..ho_name.."_"..ho_found[i].."_close_1")
        ObjDelete("obj_"..ho_name.."_"..ho_found[i].."_close_2")
        ObjSet( "anm_"..ho_name.."_anim_open_"..ho_found[i].."_1", {animfunc ="anim_close_"..ho_found[i].."1",frame = 0} );
        ObjSet( "anm_"..ho_name.."_anim_open_"..ho_found[i].."_2", {animfunc ="anim_close_"..ho_found[i].."2",frame = 0} );
        count = count + 1   
    
    end;
    end


  end

  function private.PanelHoPairEffect_ShowHoHint(hint_param)
    SendMessage(Command_Effect_ShowHoHint,{hint = hint_param})
  end


end
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
function private.InitAchievement()


  function interface.AchShow(type,achievement_param)
    if IsCollectorsEdition() or IsSurveyEdition() then
      if achievement_param then
        achievement_param.text = "str_achievement_"..achievement_param.text
        
        interface.PanelNotificationShow("achievement", achievement_param )
      end
    end
  end

  function interface.GetAchievement(ach_name)

    if IsCollectorsEdition() or IsSurveyEdition() then
      if ng_global.achievements.flag[ach_name] == false then -- if flag doesn't exist do nothing
        ng_global.achievements.flag[ach_name] = true
        local achievement_param = {text = ach_name}
        interface.AchShow("achievement",achievement_param)
      end
    end
  end

  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  private.achievements_data = {};
  private.achievements_data.func = {};
  private.achievements_data.data = {};


  ----------------------------------------------------------------------------------
  local ach_local_hub = private.achievements_data.data;
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  -- работа с прогрессом
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local is_achievement_completed = function ( ach_type, ach_name )

    local ach_global = ng_global.achievements;
    --DbgTrace("is_achievement_completed  "..ach_type.." "..ach_name)
    return ach_global[ ach_type ][ ach_name ];

  end
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local get_achievement_data = function ( ach_name )

    local ach_global = ng_global.achievements;  
    --DbgTrace("get_achievement_data "..ach_name)
    return ach_global.data[ ach_name ];

  end
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local change_achievement_value = function ( ach_name, ach_type, value )

    local ach_global = ng_global.achievements;
    ach_global[ ach_type ][ ach_name ] = value;

  end
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local save_achievement_data = function ( ach_name, ach_local_data )

    local ach_global = ng_global.achievements;

    ach_global.data[ ach_name ] = ach_local_data;
    --DbgTrace("save_achievement_data  "..ach_name)
    --DbgTrace(ach_local_data)

  end
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local insert_achived_room = function (prg,ach)
    local room = GetCurrentRoom()
    if not ng_global.achievements["counter_"..prg][ ach.."_rooms" ] then
      ng_global.achievements["counter_"..prg][ ach.."_rooms" ] = {}
    end
    if not ld.TableContains(ng_global.achievements["counter_"..prg][ ach.."_rooms" ], room) then
      table.insert(ng_global.achievements["counter_"..prg][ ach.."_rooms" ],room)
    end
  end
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  -- хо без хиинта
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local ho_without_hint_start = function ( ho_name )

    local ach_name = "ho_without_hint";

    if ( not ach_local_hub[ ach_name ] ) then

      ach_local_hub[ ach_name ] = {};

    end;

    local ach_local_data = ach_local_hub[ ach_name ];
    
    ach_local_data.counter = is_achievement_completed( "counter", ach_name ); -- 3, 5 или 7

    if ( ach_local_data.counter < private.ach_ho_count  ) then --макс количество хо 9+4
    
      local ach_global_data = get_achievement_data( ach_name );

      if ( ach_global_data and ach_global_data.counter ) then

        ach_local_data.counter = ach_global_data.counter;

      else

        ach_local_data.counter = 0;

      end;

      ach_local_data.is_active = true;

    
    end;

  end;
  ----------------------------------------------------------------------------------
  local ho_without_hint_sumup = function ()

    local ach_name = "ho_without_hint";

    local ach_local_data = ach_local_hub[ ach_name ];

    if ( ach_local_data and ach_local_data.is_active ) then

      ach_local_data.counter = ach_local_data.counter + 1;
--DEBUG rooms
      insert_achived_room(ng_global.currentprogress,ach_name)
    
      ng_global.achievements["counter_"..ng_global.currentprogress][ ach_name ] = ng_global.achievements["counter_"..ng_global.currentprogress][ ach_name ] + 1;

      save_achievement_data( ach_name, { counter = ach_local_data.counter } );

      if ( ach_local_data.counter == 1 or ach_local_data.counter == 3 or ach_local_data.counter == 5 or ach_local_data.counter == 10 ) then
        if ach_local_data.counter > is_achievement_completed( "counter", ach_name ) then
        change_achievement_value( ach_name, "counter", ach_local_data.counter ); -- должно быть == 3, 5 или 7 
        --save_achievement_data( ach_name, { counter = 0 } );
          ach_local_hub[ ach_name ].is_completed = true;
        --if not is_achievement_completed( "flag", "ho_without_hint_"..ach_local_data.counter ) then
          --change_achievement_value( "ho_without_hint_"..ach_local_data.counter, "flag", true );
          interface.AchShow( "achievement", { text = ach_name, count = ach_local_data.counter } );
        --end
        end
      elseif ( ach_local_data.counter == private.ach_ho_count  ) then

        interface.GetAchievement("ho_without_hint_all")

      end;
    
      ach_local_hub[ ach_name ].is_active = false;
      ach_local_hub[ ach_name ].is_completed = false;
    end;

  end;
  ----------------------------------------------------------------------------------
  local ho_without_hint_save = function ()

    local ach_name = "ho_without_hint";
    local ach_local_data  = ach_local_hub[ ach_name ];

    if ( ach_local_data and not ach_local_hub[ ach_name ].is_completed ) then

      local ach_global_data = get_achievement_data( ach_name );
      local save_data = {};

      save_data.counter = ach_local_data.counter;

      save_achievement_data( ach_name, save_data );

    end;

  end;
  ----------------------------------------------------------------------------------
  local ho_without_hint_check = function ()
    
    local ach_name = "ho_without_hint";

    local ach_local_data = ach_local_hub[ ach_name ];

    if ( ach_local_data and ach_local_hub[ ach_name ].is_completed ) then

      interface.AchShow( "achievement", { text = ach_name, count = ach_local_data.counter } );

    end

  end
  ----------------------------------------------------------------------------------
  local count_ho_hint = function()

    local ach_name = "ho_without_hint";
    --ach_local_hub[ ach_name ].counter = 0;
    
    --DbgTrace( "ho_without_hint fail" );

    ach_local_hub[ ach_name ].is_completed = false;
    ach_local_hub[ ach_name ].is_active = false;
  end
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  -- n тасков за n времени
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local _ho_complete_task_start = function ( num, ho_name )

    local ach_name = string.format( "ho_complete_task_%d", num );
    
    if ( not ach_local_hub[ ach_name ] ) then

      ach_local_hub[ ach_name ] = {};

    end;

    local ach_local_data = ach_local_hub[ ach_name ];

    ach_local_data.ho_name = ho_name;
    ach_local_data.need_count = num;
    ach_local_data.tmr_time = num;
    ach_local_data.counter = 0;
      local tmr_name = string.format( "tmr_%s_%s", ho_name, ach_name );
    if ( not ObjGet(tmr_name) ) then
--    if ( not ach_local_data.tmr_name ) then
--
--      local tmr_name = string.format( "tmr_%s_%s", ho_name, ach_name );

      ach_local_data.tmr_name = tmr_name;

      ObjCreate( tmr_name, "timer" );
      ObjAttach( tmr_name, "ho_"..ho_name );

      ach_local_data.tmr_trig = function() private.achievements_data.func._ho_complete_task_fail(num) end; 

    end;

    local ach_global_data = get_achievement_data( ach_name );  

    if ( ach_global_data ) then

      if ( ach_global_data.counter and ach_global_data.counter ~= 0 ) then

        ach_local_data.counter = ach_global_data.counter;

      end;

      if ( ach_global_data.time and ach_global_data.time ~= 0 ) then

        ach_local_data.tmr_time = ach_global_data.time; 
        ach_local_data.tmr_playing = true;
        ObjSet( ach_local_data.tmr_name,
        {
          playing = 1,
          time = ach_local_data.tmr_time,
          endtrig = ach_local_data.tmr_trig
        } );

      end;  

    end;

  end;
  ----------------------------------------------------------------------------------
  local _ho_complete_task_fail = function ( num )

    local ach_name = string.format( "ho_complete_task_%d", num );
    local ach_local_data = ach_local_hub[ ach_name ];

    ach_local_data.counter = 0;
    ach_local_data.tmr_playing = false;
    
  end;
  ----------------------------------------------------------------------------------
  local _ho_complete_task_timerstop = function ( num )

    local ach_name = string.format( "ho_complete_task_%d", num );
    ach_local_hub[ ach_name ] = {};

  end;
  ----------------------------------------------------------------------------------
  local _ho_complete_task_save = function ( num )

    local ach_name = string.format( "ho_complete_task_%d", num );

    local ach_local_data = ach_local_hub[ ach_name ];
    local ach_global_data = get_achievement_data( ach_name );
    local save_data = {};

    if ( ach_local_data and ach_local_data.tmr_playing ) and ObjGet( ach_local_data.tmr_name )then

      save_data.time = ObjGet( ach_local_data.tmr_name ).time;
      save_data.counter = ach_local_data.counter;

    else

      save_data.time = 0;
      save_data.counter = 0;

    end;

    save_achievement_data( ach_name, save_data );

   -- DbgTrace( "ho_complete_task_save_"..num.." counter =  "..save_data.counter );
   -- DbgTrace( "ho_complete_task_save_"..num.." time =  "..save_data.time );

  end;
  ----------------------------------------------------------------------------------
  function private._ho_complete_task_count( num )
   -- ld.LogTrace( num );
    local ach_name = string.format( "ho_complete_task_%d", num );

    local ach_local_data = ach_local_hub[ ach_name ];

    local result = {};

    if ( ach_local_data and ach_local_data.tmr_playing )  then

      ach_local_data.counter = ach_local_data.counter + 1;
      
      if ( ach_local_data.counter == ach_local_data.need_count ) then
      
        change_achievement_value( ach_name, "flag", true );  
        
        interface.AchShow( "achievement", { text = ach_name } );
        
        ObjDelete( ach_local_data.tmr_name );
    
        result = { is_completed = true, ho_name = ach_local_data.ho_name }

        ach_local_data = {};
      
      end;

    else

      ach_local_data.counter = 1;
      ach_local_data.tmr_playing = true;

      ObjSet( ach_local_data.tmr_name,
      {
        playing = 1,
        time    = ach_local_data.tmr_time,
        endtrig = ach_local_data.tmr_trig
      } );

    end;

    return result;
    
  end;
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local get_ho_complete_task_order = function ()

    if ( not is_achievement_completed( "flag", "ho_complete_task_3" ) ) then
    
      return { near = 3, next = 5, all = 10 };
    
    elseif ( not is_achievement_completed( "flag", "ho_complete_task_5" ) ) then
    
      return { near = 5, next = 10 };
      
    elseif ( not is_achievement_completed( "flag", "ho_complete_task_10" ) ) then
    
      return { near = 10, next = nil };

    else

      return { near = nil, next = nil };
    
    end;

  end;
  ----------------------------------------------------------------------------------
  local ho_complete_task_start = function ( ho_name )
    
    local order = get_ho_complete_task_order();

    if ( order.near ) then
    --  ld.LogTrace( order.near );
      _ho_complete_task_start( order.near, ho_name );

    end;
    if ( order.next ) then
     -- ld.LogTrace( order.next );
      _ho_complete_task_start( order.next, ho_name );

    end;

    if ( order.all ) then
     -- ld.LogTrace( order.all );
      _ho_complete_task_start( order.all, ho_name );  

    end;

  end;
  ----------------------------------------------------------------------------------
  local ho_complete_task_save = function ()

    local order = get_ho_complete_task_order();

    if ( order.near ) then

      _ho_complete_task_save( order.near, ho_name );

    end;

    if ( order.next ) then

      _ho_complete_task_save( order.next, ho_name );

    end;

    if ( order.all ) then

      _ho_complete_task_save( order.all, ho_name );

    end;

  end;
  ----------------------------------------------------------------------------------
  local ho_complete_task_timerstop = function ()

    local order = get_ho_complete_task_order();

    if ( order.near ) then

      _ho_complete_task_timerstop( order.near, ho_name );

    end;

    if ( order.next ) then

      _ho_complete_task_timerstop( order.next, ho_name );

    end;

    if ( order.all ) then

      _ho_complete_task_timerstop( order.all, ho_name );

    end;

  end;
  ----------------------------------------------------------------------------------
  function private.achievements_data.func._ho_complete_task_fail( num )

    _ho_complete_task_fail( num );
    
  end;
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local count_ho_task = function()

    local order = get_ho_complete_task_order();

    if ( order.near ) then

      local result = private._ho_complete_task_count( order.near );

  --    if ( order.next and result.is_completed ) then
  --
  --      _ho_complete_task_start( order.next, result.ho_name );
  --
  --    end;

    end;
  -- переделано, чтобы счет сразу на все ачивки, а не на текущую.
    if ( order.next ) then

      local result = private._ho_complete_task_count( order.next );

    end;

    if ( order.all ) then

      local result = private._ho_complete_task_count( order.all ); 

    end;
    
  end;
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  -- хо меньше минуты
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local ho_less_1min_start = function ( ho_name )

    local ach_name = "ho_less_1min";

    ng_global.achievements.data.ho_less_1min_miss = ng_global.achievements.data.ho_less_1min_miss or {}
    
    if ( not is_achievement_completed( "flag", ach_name ) and not ng_global.achievements.data.ho_less_1min_miss[ ho_name ] ) then

      if ( not ach_local_hub[ ach_name ] ) then

        ach_local_hub[ ach_name ] = {};

      end;

      local ach_local_data = ach_local_hub[ ach_name ];

      local ach_global_data = get_achievement_data( ach_name );

      local tmr_time = 60;

      if ( ach_global_data and ach_global_data.time and ach_global_data.time ~= 0 ) then

        tmr_time = ach_global_data.time; 

      end;
        local tmr_name = string.format( "tmr_%s_%s", ho_name, ach_name );
      if (not  ObjGet(tmr_name) ) then
--      if ( not ach_local_data.tmr_name ) then
--
--        local tmr_name = string.format( "tmr_%s_%s", ho_name, ach_name );
        ach_local_data.tmr_name = tmr_name;

        ObjCreate( tmr_name, "timer" );

        ObjAttach( tmr_name, "ho_"..ho_name );

        ach_local_data.is_completed = true;
        ach_local_data.is_active = true;
      else 
       -- DbgTrace(ach_local_data.tmr_name)

      end;

      if ( ach_local_data.is_active ) then

        local tmr_trig = function()
          ng_global.achievements.data.ho_less_1min_miss[ ho_name ] = true
          private.achievements_data.func._ho_less_1min_fail();
        end;

        ObjSet( ach_local_data.tmr_name,
        {
          time    = tmr_time,
          endtrig = tmr_trig,
          playing = 1
        } );

      end;

    end;

  end;
  ----------------------------------------------------------------------------------
  function private.achievements_data.func._ho_less_1min_fail()

    local ach_name = "ho_less_1min";
    ach_local_hub[ ach_name ].is_completed = false;
    ach_local_hub[ ach_name ].is_active = false;

  end;
  ----------------------------------------------------------------------------------
  local ho_less_1min_timerstop = function ()

    local ach_name = "ho_less_1min";
    local ach_local_data = ach_local_hub[ ach_name ];

    if ( ach_local_data and ach_local_data.is_completed ) then

      change_achievement_value( ach_name, "flag", true );

      ach_local_data.is_active = false;

    end;

  end;
  ----------------------------------------------------------------------------------
  local ho_less_1min_save = function ()

    local ach_name = "ho_less_1min";
    local ach_local_data = ach_local_hub[ ach_name ];
    local save_data = {};

    if ( ach_local_data and ach_local_data.is_active ) then

      local time = ObjGet( ach_local_data.tmr_name ).time;
      save_data.time = time;
      --DbgTrace( "ho_less_1min_save "..save_data.time );

    end;

    save_achievement_data( ach_name, save_data );


  end;
  ----------------------------------------------------------------------------------
  local ho_less_1min_check = function ()

    local ach_name = "ho_less_1min";

    local ach_local_data = ach_local_hub[ ach_name ];

    if ( ach_local_data and ach_local_data.is_completed ) then

      interface.AchShow( "achievement", { text = ach_name } );
      ach_local_hub[ ach_name ] = {};

    end

  end
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  -- хо меньше 3 минут
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local ho_less_3min_start = function ( ho_name )

    local ach_name = "ho_less_3min";

    if ( not ach_local_hub[ ach_name ] ) then

      ach_local_hub[ ach_name ] = {};

    end;

    local ach_local_data = ach_local_hub[ ach_name ];
    
    ach_local_data.counter = is_achievement_completed( "counter", ach_name ); -- 3, 5 или 7

    if ( ach_local_data.counter < private.ach_ho_count  ) then   --9 кольво хо

      local ach_global_data = get_achievement_data( ach_name );

      if ( ach_global_data and ach_global_data.counter ) then

        ach_local_data.counter = ach_global_data.counter;-- от 0 до 9. Обнуляется при ресете. 

      else

        ach_local_data.counter = 0;

      end;
     
      local tmr_time = 180;

      if ( ach_global_data and ach_global_data.time ) then

        tmr_time = ach_global_data.time; 

      end;  
        local tmr_name = string.format( "tmr_%s_%s", ho_name, ach_name );
      if (not  ObjGet(tmr_name) ) then
--      if ( not ach_local_data.tmr_name ) then
--
--        local tmr_name = string.format( "tmr_%s_%s", ho_name, ach_name );
        ach_local_data.tmr_name = tmr_name;

        ObjCreate( tmr_name, "timer" );

        ObjAttach( tmr_name, "ho_"..ho_name );

        ach_local_data.is_active = true;

      end;

      ach_local_data.is_completed = true;

      if ( ach_local_data.is_active ) then

        local tmr_trig = function() private.achievements_data.func._ho_less_3min_fail()end;

        ObjSet( ach_local_data.tmr_name,
        {
          time    = tmr_time,
          endtrig = tmr_trig,
          playing = 1
        
        } );

      end;

    end;

  end;
  ----------------------------------------------------------------------------------
  function private.achievements_data.func._ho_less_3min_fail()

    local ach_name = "ho_less_3min";
    ach_local_hub[ ach_name ].is_completed = false;
    ach_local_hub[ ach_name ].is_active = false;

  end;
  ----------------------------------------------------------------------------------
  local ho_less_3min_timerstop = function ()

    local ach_name = "ho_less_3min";

    local ach_local_data = ach_local_hub[ ach_name ];

    if ( ach_local_data and ach_local_data.is_completed ) then
    
      ach_local_data.counter = ach_local_data.counter + 1;
--DEBUG rooms
      insert_achived_room(ng_global.currentprogress,ach_name)

      ng_global.achievements["counter_"..ng_global.currentprogress][ ach_name ] = ng_global.achievements["counter_"..ng_global.currentprogress][ ach_name ] + 1;

      save_achievement_data( ach_name, { counter = ach_local_data.counter } );

      if ( ach_local_data.counter == 3 or ach_local_data.counter == 5 or ach_local_data.counter == 10 )and (ach_local_data.counter > is_achievement_completed( "counter", ach_name ))  then

          change_achievement_value( ach_name, "counter", ach_local_data.counter ); -- должно быть == 3, 5 или 7 

        --save_achievement_data( ach_name, { counter = 0 } );

      else

        ach_local_data.is_completed = false;

      end;
    
      ach_local_hub[ ach_name ].is_active = false;

      ObjDelete( ach_local_data.tmr_name );

    end;

  end;
  ----------------------------------------------------------------------------------
  local ho_less_3min_save = function ()

    local ach_name = "ho_less_3min";
    local ach_local_data  = ach_local_hub[ ach_name ];

    if ( ach_local_data ) then

      local ach_global_data = get_achievement_data( ach_name );
      local save_data = {};

      save_data.counter = ach_local_data.counter;

      if ( ach_local_data.is_active ) then

        local time = ObjGet( ach_local_data.tmr_name ).time;
        save_data.time = time;
      --  DbgTrace( "ho_less_3min_save time "..save_data.time );

      end;

      save_achievement_data( ach_name, save_data );

    end;

  end;
  ----------------------------------------------------------------------------------
  local ho_less_3min_check = function ()

    local ach_name = "ho_less_3min";

    local ach_local_data = ach_local_hub[ ach_name ];
--and (not is_achievement_completed( "flag", "ho_less_3min_"..ach_local_data.counter ))
   if ( ach_local_data and ach_local_data.is_completed )  then
     -- change_achievement_value( "ho_less_3min_"..ach_local_data.counter, "flag", true );
      interface.AchShow( "achievement", { text = ach_name, count = ach_local_data.counter } );

   end

  end
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  -- хо больше 10 минут
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local ho_more_10min_start = function ( ho_name )

    local ach_name = "ho_more_10min";

    if ( not ach_local_hub[ ach_name ] ) then

      ach_local_hub[ ach_name ] = {};

    end;


    if ( not is_achievement_completed( "flag", ach_name ) ) then

      local ach_local_data = ach_local_hub[ ach_name ];

      local ach_global_data = get_achievement_data( ach_name );

      local ach_full_time = 601;--601

      local tmr_time = ach_full_time;

      if ( ach_global_data and ach_global_data.time and ach_global_data.time ~= 0 ) then

        tmr_time = ach_global_data.time; 

      end;

      local tmr_name = string.format( "tmr_%s_%s", ho_name, ach_name );
      if ( not ObjGet(tmr_name)) then
--      if ( not ach_local_data.tmr_name ) then
--
--        local tmr_name = string.format( "tmr_%s_%s", ho_name, ach_name );
        ach_local_data.tmr_name = tmr_name;

        ObjCreate( tmr_name, "timer" );

        ObjAttach( tmr_name, "ho_"..ho_name );

        ach_local_data.is_active = true;

      end;

      if ( ach_local_data.is_active ) then

        local tmr_trig = function() private.achievements_data.func._ho_more_10min_win();end

        ObjSet( ach_local_data.tmr_name,
        {
          time    = tmr_time,
          endtrig = tmr_trig,
          playing = 1    
        } );

      end;

    end;

  end;
  ----------------------------------------------------------------------------------
  function private.achievements_data.func._ho_more_10min_win()

    local ach_name = "ho_more_10min";
    local ach_local_data = ach_local_hub[ ach_name ];

    if ( ach_local_data and ach_local_data.is_active ) then

      ObjDelete( ach_local_data.tmr_name );
      
      change_achievement_value( ach_name, "flag", true );
      
      interface.AchShow( "achievement", { text = ach_name } );

      ach_local_hub[ ach_name ].is_active = false;

    end;

  end;
  ----------------------------------------------------------------------------------
  local ho_more_10min_timerstop = function ()

    local ach_name = "ho_more_10min";
    ach_local_hub[ ach_name ].is_completed = false;
    ach_local_hub[ ach_name ].is_active = false;

  end;
  ----------------------------------------------------------------------------------
  local ho_more_10min_save = function ()

    local ach_name = "ho_more_10min";
    local ach_local_data = ach_local_hub[ ach_name ];
    local save_data = {};

    if ( ach_local_data and ach_local_data.is_active ) then

      local time = ObjGet( ach_local_data.tmr_name ).time;
      save_data.time = time;
      --DbgTrace( "ho_more_10min save time "..tostring( save_data.time ) );

    end;

    save_achievement_data( ach_name, save_data );

  end;
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  -- все хо без хинта
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local ho_without_hint_all_fail = function ()

    local ach_name = "ho_without_hint_all";
    save_achievement_data( ach_name, { is_failed = true } );  

  end;
  ----------------------------------------------------------------------------------
  local ho_without_hint_all_check = function ()

    local ach_name = "ho_without_hint_all";

    local ach_local_data = get_achievement_data( ach_name );

    if ( ach_local_data and not ach_local_data.is_failed ) then
      
      interface.GetAchievement( ach_name )

    end

  end
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  -- все ми без скипа
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local mg_without_skip_all_fail = function ()

    local ach_name = "mg_without_skip_all";
    save_achievement_data( ach_name, { is_failed = true } );  

  end;
  ----------------------------------------------------------------------------------
  local mg_without_skip_all_check = function ()

    local ach_name = "mg_without_skip_all";

    local ach_local_data = get_achievement_data( ach_name );

    if ( ach_local_data and not ach_local_data.is_failed ) then
      
      interface.GetAchievement( ach_name )

    end

  end
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  -- мг без скипа
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local mg_without_skip_start = function ()
   
    local ach_name = "mg_without_skip";

    if ( not ach_local_hub[ ach_name ] ) then

      ach_local_hub[ ach_name ] = {};

    end;

    local ach_local_data = ach_local_hub[ ach_name ];
    
    ach_local_data.counter = is_achievement_completed( "counter", ach_name ); -- 3, 5 или 7

    if ( ach_local_data and ach_local_data.counter < private.ach_mg_count ) then   --кольво мг 8
    
      local ach_global_data = get_achievement_data( ach_name );

      if ( ach_global_data and ach_global_data.counter ) then
      
        ach_local_data.counter = ach_global_data.counter;

      else

        ach_local_data.counter = 0;

      end;

      ach_local_data.is_active = true;
    
    end;

    local ach_name = "mg_without_skip";

    if ( not ach_local_hub[ ach_name ] ) then

      ach_local_hub[ ach_name ] = {};

    end;


  end;
  ----------------------------------------------------------------------------------
  local mg_without_skip_save = function ()

    local ach_name = "mg_without_skip";
    local ach_local_data  = ach_local_hub[ ach_name ];

    if ( ach_local_data and not ach_local_data.is_completed ) then

      local ach_global_data = get_achievement_data( ach_name );
      local save_data = {};

      save_data.counter = ach_local_data.counter;

      save_achievement_data( ach_name, save_data );

    end;

  end;
  ----------------------------------------------------------------------------------
  local mg_without_skip_check = function ()

    local ach_name = "mg_without_skip";

    local ach_local_data = ach_local_hub[ ach_name ];

    if ( ach_local_data and ach_local_data.is_active ) then
      ach_local_data.counter = ach_local_data.counter + 1;

--DEBUG rooms
      insert_achived_room(ng_global.currentprogress,ach_name)

      ng_global.achievements["counter_"..ng_global.currentprogress][ ach_name ] = ng_global.achievements["counter_"..ng_global.currentprogress][ ach_name ] + 1;

      save_achievement_data( ach_name, { counter = ach_local_data.counter } );

      
      if ( ach_local_data.counter == 1 or ach_local_data.counter == 3 or ach_local_data.counter == 5 or ach_local_data.counter == 10 )  and (ach_local_data.counter > is_achievement_completed( "counter", ach_name )) then 

        change_achievement_value( ach_name, "counter", ach_local_data.counter ); -- должно быть == 3, 5 или 7
        interface.AchShow( "achievement", { text = ach_name, count = ach_local_data.counter } );

        --save_achievement_data( ach_name, { counter = 0 } );

        ach_local_hub[ ach_name ].is_completed = true;

      elseif ( ach_local_data.counter == private.ach_mg_count ) then

        interface.GetAchievement("mg_without_skip_all")

      else 
        
      end;

      ach_local_hub[ ach_name ].is_active = false;
    else 
       -- 
    end;

  end;
  ----------------------------------------------------------------------------------
  local count_mg_skip = function ()

  --  if ( ach_local_hub[ "mg_without_skip" ] ) then
  --
  --    --ach_local_hub[ "mg_without_skip" ].counter = 0;
  --    DbgTrace(ach_local_hub[ "mg_without_skip" ].counter)
  --    ach_local_hub[ "mg_without_skip" ].counter = ach_local_hub[ "mg_without_skip" ].counter - 1;
  --    DbgTrace(ach_local_hub[ "mg_without_skip" ].counter)  
  --  end;


    if ( ach_local_hub[ "mg_without_skip" ] ) then

      ach_local_hub[ "mg_without_skip" ].is_active = false;
      --ach_local_hub[ "mg_without_skip" ].counter = 0;
    end;

    if ( ach_local_hub[ "mg_less_1min" ] ) then
      
      ach_local_hub[ "mg_less_1min" ].is_completed = false;
      ach_local_hub[ "mg_less_1min" ].is_active = false;

    end;

  end
  ----------------------------------------------------------------------------------




  -- мг меньше минуты
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  local mg_less_1min_start = function ( mg_name )

    local ach_name = "mg_less_1min";
    
    ng_global.achievements.data.mg_less_1min_miss = ng_global.achievements.data.mg_less_1min_miss or {}
    
    if ( not is_achievement_completed( "flag", ach_name ) and not ng_global.achievements.data.mg_less_1min_miss[ mg_name ] ) then

      if ( not ach_local_hub[ ach_name ] ) then

        ach_local_hub[ ach_name ] = {};

      end;

      local ach_local_data = ach_local_hub[ ach_name ];

      local ach_global_data = get_achievement_data( ach_name );

      local tmr_time = 60;

      if ( ach_global_data and ach_global_data.time and ach_global_data.time ~= 0 ) then

        tmr_time = ach_global_data.time; 

      end;
        local tmr_name = string.format( "tmr_%s_%s", mg_name, ach_name );
      if ( not ObjGet(tmr_name) ) then
--      if ( not ach_local_data.tmr_name ) then
--
--        local tmr_name = string.format( "tmr_%s_%s", mg_name, ach_name );
        ach_local_data.tmr_name = tmr_name;

        ObjCreate( tmr_name, "timer" );
        ObjAttach( tmr_name, "mg_"..mg_name );

        ach_local_data.is_completed = true;
        ach_local_data.is_active = true;
      else 
       -- DbgTrace("already "..ach_local_data.tmr_name)
      end;

      if ( ach_local_data.is_active ) then

        local tmr_trig = function()
            ng_global.achievements.data.mg_less_1min_miss [ mg_name ] = true;
            private.achievements_data.func._mg_less_1min_fail();
          end

        ObjSet( ach_local_data.tmr_name,
        {
          time    = tmr_time,
          endtrig = tmr_trig,
          playing = 1
        } );

      end;

    end;

  end;

  ----------------------------------------------------------------------------------
  function private.achievements_data.func._mg_less_1min_fail()

    local ach_name = "mg_less_1min";
    ach_local_hub[ ach_name ].is_completed = false;
    ach_local_hub[ ach_name ].is_active = false;
  --  DbgTrace("fail mg_less_1min")

    ach_local_hub[ ach_name ] = {};
  end;
  ----------------------------------------------------------------------------------
  local mg_less_1min_save = function ()

    local ach_name = "mg_less_1min";
    local ach_local_data = ach_local_hub[ ach_name ];
    local save_data = {};

    if ( ach_local_data and ach_local_data.is_active ) then

      local time = ObjGet( ach_local_data.tmr_name ).time;
      save_data.time = time;
      --DbgTrace( "mg_less_1min_save "..tostring( save_data.time ) );

    end;

    save_achievement_data( ach_name, save_data );

  end;
  ----------------------------------------------------------------------------------
  local mg_less_1min_check = function ()
    local ach_name = "mg_less_1min";

    local ach_local_data = ach_local_hub[ ach_name ];

    if ( ach_local_data and ach_local_data.is_completed ) then

      interface.AchShow( "achievement", { text = ach_name } );
      change_achievement_value( ach_name, "flag", true );
      
      ach_local_hub[ ach_name ] = {};
      save_achievement_data( ach_name, {} );

    end;
    
  end
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  -- extern functions
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  function public.StartMgAchievements( mg_name )
    if (IsCollectorsEdition() ) or IsSurveyEdition() then
    mg_without_skip_start();
    mg_less_1min_start( mg_name );
    DbgTrace("public.StartMgAchievements "..mg_name)
    end;
  
  end
  ----------------------------------------------------------------------------------
  function public.ShowMgAchievements()

    if (IsCollectorsEdition() ) or IsSurveyEdition() then
      mg_without_skip_check();
      mg_less_1min_check();   
     DbgTrace("public.ShowMgAchievements")
    end;


  end


  ----------------------------------------------------------------------------------
  function public.StartHoAchievements( ho_name )   ---старт таймеров для хо
    if (IsCollectorsEdition() ) or IsSurveyEdition() then
      ho_less_1min_start( ho_name );    --прохождение 1-го ХО меньше чем за 1 минуту  
      ho_less_3min_start( ho_name );    --прохождение n ХО подряд, меньше чем за 3 минуты каждое   
      ho_more_10min_start( ho_name );   --прохождение 1-го ХО больше чем за 10 минут    
      ho_complete_task_start( ho_name );  --подбор объектов ХО за t секунды  ...
      ho_without_hint_start( ho_name );   --прохождение n ХО без подсказки 
    DbgTrace("StartHoAchievements "..ho_name)
    end
  end
  ----------------------------------------------------------------------------------
  function public.ShowHoAchievements()    -- проверка таймеров для хо

    if IsCollectorsEdition()  or IsSurveyEdition() then

      ho_less_1min_check();
      ho_less_3min_check();
      ho_without_hint_check();
      DbgTrace("ShowHoAchievements")
    end;
  
  end
  ----------------------------------------------------------------------------------
  function public.StopHoAchievements()   -- стоп таймеров

    if IsCollectorsEdition()  or IsSurveyEdition() then
      ho_less_1min_timerstop();
      ho_less_3min_timerstop();
      ho_more_10min_timerstop();
      ho_complete_task_timerstop();
      ho_without_hint_sumup();
      DbgTrace("StopHoAchievements")
    end
    
  end
  ----------------------------------------------------------------------------------
  function public.SaveAchievementsTimers( room ) --сохранение  таймеров при выходе 
    local currentroom = room or GetCurrentRoom()
    local currentroom_prefix = common.GetObjectPrefix( currentroom );

    if ( currentroom_prefix == "ho" ) then
      ho_less_1min_save();
      ho_less_3min_save();
      ho_more_10min_save();
      ho_complete_task_save();
      ho_without_hint_save();

    elseif ( currentroom_prefix == "mg" ) then
      mg_without_skip_save();
      mg_less_1min_save();
    end;
    
  end
  ----------------------------------------------------------------------------------
  function public.CountSkipMgAchievement()
    if IsCollectorsEdition() or IsSurveyEdition() then
      count_mg_skip();
      mg_without_skip_all_fail();
    end
  end;
  ----------------------------------------------------------------------------------
  function public.CountTaskHoAchievement()

  if IsCollectorsEdition() or IsSurveyEdition() then
    count_ho_task();
  end
   -- ho_without_hint_all_fail();


  end;
  ----------------------------------------------------------------------------------

  function public.TaskHoWithoutHintFailed()
    if IsCollectorsEdition()  or IsSurveyEdition() then
      ho_without_hint_all_fail();
    end
  end;

  ----------------------------------------------------------------------------------
  function public.CountHintHoAchievement()
    if IsCollectorsEdition()  or IsSurveyEdition() then
      count_ho_hint();
    end
  end;
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  function public.LastHoCheckAchievement()
    if IsCollectorsEdition()  or IsSurveyEdition() then
      ho_without_hint_all_check();
    end
  end;
  ----------------------------------------------------------------------------------
  function public.LastMgCheckAchievement()
    if IsCollectorsEdition()  or IsSurveyEdition() then
      mg_without_skip_all_check();
    end
  end;
  ----------------------------------------------------------------------------------




  function interface.GetPuzzle(sender)
     local num = tonumber( ld.StringDivide(sender)[3] )
     local typeOfPuzzle = ld.StringDivide(sender)[2]
     local object_name = "spr_"..typeOfPuzzle.."_"..num
        
     ng_global.achievements[typeOfPuzzle][num] = true

      local ach_name = typeOfPuzzle
       --ld.LogTrace( "puzzle"..num    );

      local count=0
      --local collect_pos={}
      for i=1,#ng_global.achievements[typeOfPuzzle] do
        if ng_global.achievements[typeOfPuzzle][i] then
          count=count+1
        end
      end

      if typeOfPuzzle == "clockpart" then
        int_inventory.StdItemFlyAnimation( object_name, "obj_int_button_hint_point_for_clock", function() 
           ObjDelete(object_name)
           int_button_clock.Update()
        end );
      else
        interface.AchShow( "achievement", { text = ach_name, count = count } );
        ld.FxAnmObj(object_name)
      end
      
      
      if typeOfPuzzle == "puzzle" and count == #ng_global.achievements.puzzle then
        interface.GetAchievement("puzz_all")
      end
--      local  PuzzleAnimFx = function()
--        
--      end
--
--
--      ObjSet( object_name, { input=0 } );
--      ObjAttach( object_name, InterfaceWidget_Top_Name );
--
--        collect_pos[1]= ObjGet(object_name).pos_x
--        collect_pos[2]= ObjGet(object_name).pos_y
--
--        if ( common.GetObjectPrefix( GetCurrentRoom() ) == "zz"  ) then 
--           collect_pos[1]= ObjGet(GetCurrentRoom()).pos_x + collect_pos[1]
--           collect_pos[2]= ObjGet(GetCurrentRoom()).pos_y + collect_pos[2]
--        end
--
--      ObjSet( object_name ,{ pos_x = collect_pos[1], pos_y = collect_pos[2],input=0 });
--      ObjAnimate(object_name, 6, 0, 0, PuzzleAnimFx , {0,0,1,1,0.5,0,1.5,1.5});
--     --   miniature_all_check(count)

    
    if common_impl.hint[typeOfPuzzle..num].zz_gate and ld.ZzCompleteCheck(typeOfPuzzle..num)   then 
      ObjSet( common_impl.hint[typeOfPuzzle..num].zz_gate, { visible = 0, input = 0 } );
      ld.CloseSubRoom() 
      --DbgTrace(common_impl.hint[typeOfPuzzle..num].zz_gate) 
    end;

  end

function interface.ArrPuzzles()

    local room = {
      {"rm_entrypoint",  "zz_dashboard1"};
      {"rm_toystoreyard1",  "zz_childrenstown1"};
      {"rm_mainstreet1",  "zz_toycar1"};
      {"rm_warehousedeadend1",  "zz_mailbox1"};
      {"rm_busstop1",  "zz_stopsign1"};
      {"rm_autopartsstore1",  "zz_storewindowsill1"};
      {"rm_kiosk2",  "zz_grindingmachine2"};
      {"rm_townsquare2",  "zz_parkingcolumn2"};
      {"rm_sewingstreet2",  "zz_mailbox2"};
      ---
      {"rm_citystreet",  "zz_bench"};
      {"rm_citystreet",  "zz_kiosk"};
      {"rm_hall",  "zz_mailboxes"};

    }

    for i = 1, #room do
      common_impl.hint["puzzle"..i] = { room = room[i][1], zz_gate = "",  zz=room[i][2]}
      if common_impl.hint["puzzle"..i].zz ~= "" then
        local gzz = "gzz_"..ld.String.Divide(room[i][1])[2].."_"..ld.String.Divide(room[i][2])[2]
        common_impl.hint["puzzle"..i].zz_gate = gzz
      end
    end


    local miniatures = {
      {"rm_warehousedeadend1"};
      {"rm_busstop1"};
      {"rm_autopartsstore1"};

      {"rm_townpark2"};
      {"rm_snowyalley2"};
      {"rm_townsquare2"};
    }

    for i = 1, #miniatures do
      common_impl.hint["miniature"..i] = { room = miniatures[i][1] }
    end

end                              

  function interface.ArrPuzzlesHelper()
    for i = 1,#ng_global.achievements.puzzle do
      local puz = "spr_puzzle_"..i
      if ObjGet(puz) then
        local parent = puz
        repeat
          parent = ObjGetRelations( parent ).parent
        until ( ld.StringDivide(parent)[1] == "zz" )

        local hint = {room = ld_impl.smart_hint_connections[parent], zz= parent}
        hint.zz_gate = "gzz_"..ld.StringDivide(hint.room)[2].."_"..ld.StringDivide(hint.zz)[2]
        --ld.LogTrace( hint );
        --common_impl.hint["puzzle"..i]  = hint
        local s = string.format("common_impl.hint[%q]  = {room = %q, zz_gate = %q, zz = %q}", "puzzle"..i, hint.room, hint.zz_gate, hint.zz )
        ld.LogTrace( s );
      end
    end
  end

  function interface.CheckPuzzles()
    --DbgTrace("CheckPuzzles")
        
    local puzzle_total = #ng_global.achievements.puzzle--общее количество миниатюр    
    local count_pz = 0
    local str_pz = " "
  --
    for i=1,puzzle_total do
      if (not IsCollectorsEdition()) and (not IsSurveyEdition()) then
          ObjDelete("spr_puzzle_"..i)
          ng_global.achievements.puzzle[i] = true

          
      elseif  ng_global.achievements.puzzle[i] then
          ObjDelete("spr_puzzle_"..i)
          count_pz = count_pz + 1


      else 
        ObjSet( "spr_puzzle_"..i, {input = 1,
          event_mdown = function()  
            interface.GetPuzzle("spr_puzzle_"..i)
          end} 
        );

      end;

    end
    
      --DbgTrace(count_pz)
    --DbgTrace("str_pz "..str_pz)
  end



  --common_impl 1297
  --local morph_total = 14 --общее количество миниатюр   
  --local simplemorph_total = 14 --общее количество миниатюр 
function interface.GetMorphing(sender, simple)
    local object_name = sender
    local anm_name
    local morph_param
    local ach_name
    local num = tonumber( ld.StringDivide(sender)[3] )
    if simple then
      morph_param = "morphtrash"
      ach_name    = "morphtrash"
      anm_name = ObjGetRelations(object_name).parent
    else
      morph_param = "miniature"
      ach_name    = "morphing" 
      anm_name = object_name
    end
    --local frame = ObjGet(anm_name).frame
    ----DbgTrace( frame )
    --if frame>60 and frame<360 then
      SoundSfx( "reserved/aud_get_collectibles" )      

      local count=0
      ng_global.achievements[morph_param][num] = true
      for i=1,#ng_global.achievements[morph_param] do
        if ng_global.achievements[morph_param][i] then
          count=count+1
        end
      end    

      interface.AchShow( "achievement", { text = ach_name, count = count, num = num } );
      if morph_param == "morphtrash" and count == #ng_global.achievements.morphtrash then
        interface.GetAchievement("morph_all")
      elseif morph_param == "miniature" and count == #ng_global.achievements.miniature then
        interface.GetAchievement("coll_all")
      end

      ObjSet( anm_name, {input=0} );
      --ObjAttach( anm_name, InterfaceWidget_Top_Name );
      local collect_name  = "fx_item_name_collect_"..anm_name..tostring(simple);
      ObjCreate( collect_name, "partsys" );
      
      local pos = simple and GetObjPosByObj(object_name, anm_name) or {0,0}
      ObjSet( collect_name,
      {
        res = "assets/levels/common/particle_collect",
        pos_x = pos[1], pos_y = pos[2],
        active = 1, visible = 1, input = 0, pos_z = 10
      } );

      ObjAttach( collect_name, anm_name );
      ObjSet(collect_name, {blendmode = 2,pos_z = 50});
      PartSysStart(collect_name)


      local func_end = function()
        -- ld.Lock(0)
        
        ObjAnimate( collect_name, 8, 0, 0, function()ObjDelete(collect_name)end, {0,0,1, 0.3,0,0} );
        ObjDelete(anm_name)
      end

      ObjAnimate( anm_name, "alp",0,0, func_end,
      { 
          0.0, 0, 1,
          0.3, 0, 1,
          0.6, 0, 0
      } );


      --end
end
 
function interface.CheckMorphing()

    local morphArr = 
    {
--      { room = "rm_entrypoint",     prg = "", params = { pos_z = -5 }, pos_tr = {973,443}, pos = {974,434} };
--      { room = "rm_street",         prg = "", params = { pos_z = -5 }, pos_tr = {439,479}, pos = {437,478} };
--      { room = "rm_nearforest",     prg = "", params = { pos_z = -5 }, pos_tr = {741,403}, pos = {741,408} };
--      { room = "rm_forestedge",     prg = "", params = { pos_z = -5 }, pos_tr = {393,242}, pos = {391,244} };
--      { room = "rm_witchhouse",     prg = "", params = { pos_z = -5 }, pos_tr = {136,557}, pos = {140,545} };
--
--      { room = "rm_christmasglade", prg = "", params = { pos_z = -5 }, pos_tr = {915,410}, pos = {902,412} };
--      { room = "rm_magicgarden", prg = "", params = { pos_z = -5 }, pos_tr = {127,519}, pos = {133,513} };
--      { room = "rm_nearcastle", prg = "", params = { pos_z = -5 }, pos_tr = {801,244}, pos = {804,240} };
--      { room = "rm_throneroom", prg = "", params = { pos_z = -5 }, pos_tr = {349,530}, pos = {351,531} };
--      { room = "rm_grylaroom", prg = "", params = { pos_z = -5 }, pos_tr = {221,575}, pos = {218,573} };
--
--      { room = "rm_backyard", prg = "", params = { pos_z = -5 }, pos_tr = {936,380}, pos = {939,384} };
--      { room = "rm_inforest", prg = "", params = { pos_z = -5 }, pos_tr = {878,325}, pos = {885,313} };      
--      --vvv13vvv
--      { room = "rm_nearriver", prg = "", params = { pos_z = -.5 }, pos_tr = {668,416}, pos = {669,410} };
--      { room = "rm_santahome", prg = "", params = { pos_z = -5 }, pos_tr = {320,264}, pos = {316,256} };
--      { room = "rm_workshop", prg = "", params = { pos_z = 5.1 }, pos_tr = {887,465}, pos = {885,458} };
--
--      { room = "rm_yard", prg = "", params = { pos_z = -5 }, pos_tr = {394,568}, pos = {396,562} };
--      { room = "rm_cliff", prg = "", params = { pos_z = -5 }, pos_tr = {112,466}, pos = {108,461} };
--      { room = "rm_riversource", prg = "", params = { pos_z = -5 }, pos_tr = {213,553}, pos = {199,554} };
--      --vvv19vvv
--      { room = "rm_riversourceext", prg = "ext", params = { pos_z = -5 }, pos_tr = {832,246}, pos = {828,244} };
--      { room = "rm_squareext", prg = "ext", params = { pos_z = -5 }, pos_tr = {399,579}, pos = {397,578} };
--
--      { room = "rm_witchhouseext", prg = "ext", params = { pos_z = -5 }, pos_tr = {506,241}, pos = {506,236} };
--      { room = "rm_nearriverext", prg = "ext", params = { pos_z = -5 }, pos_tr = {44,367}, pos = {43,370} };
--      { room = "rm_mousevilleext", prg = "ext", params = { pos_z = -5 }, pos_tr = {591,362}, pos = {584,377} };
--      { room = "rm_forestedgeext", prg = "ext", params = { pos_z = -5 }, pos_tr = {143,533}, pos = {142,541} };
--      { room = "rm_entrypointext", prg = "ext", params = { pos_z = -5 }, pos_tr = {270,425}, pos = {271,423} };
--
--      { room = "rm_mousehouseext", prg = "ext", params = { pos_z = -5 }, pos_tr = {514,416}, pos = {513,422} };
      
    }

    local prg = ng_global.currentprogress == "std" and "" or ng_global.currentprogress
    local path = "assets/levels/level"..prg.."/%s/morph_%s%d"
    local count_mr = 0
    local str_mr = " "
    
    for i=1,#ng_global.achievements.miniature do
      if (not IsCollectorsEdition()) and (not IsSurveyEdition()) then
        ObjDelete("anm_morphcollect_"..i)
        ng_global.achievements.miniature[i] = true
      elseif  ng_global.achievements.miniature[i] then
        ObjDelete("anm_morphcollect_"..i)
        count_mr = count_mr + 1
      end;
    end

    local simple = "anm_simplemorphcollect_"
    local simple_morph = "spr_simplemorphcollect_"
    local simple_morph_tr = "spr_simplemorphcollect_tr_"
    if (IsCollectorsEdition() or IsSurveyEdition()) and #ng_global.achievements.morphtrash > 0 then
      ld.CopyStruct(simple.."1",#ng_global.achievements.morphtrash)
    end
    
    for i=1,#ng_global.achievements.morphtrash do
      local curSimple = simple..i
      if (not IsCollectorsEdition()) and (not IsSurveyEdition()) then
        ObjDelete(curSimple)
        ng_global.achievements.morphtrash[i] = true
      elseif  ng_global.achievements.morphtrash[i] then
        ObjDelete(curSimple)
        count_mr = count_mr + 1
      else
        if morphArr[i] then
          if morphArr[i].room and morphArr[i].prg == prg then
            ObjAttach( curSimple, morphArr[i].room )
            ObjSet( simple_morph..i, {res = path:format(morphArr[i].room, "", i), pos_x = morphArr[i].pos[1], pos_y = morphArr[i].pos[2],
              event_mdown = function() interface.GetMorphing(simple_morph..i,1) end
            } );
            ObjSet( simple_morph_tr..i, {res = path:format(morphArr[i].room, "tr_", i), pos_x = morphArr[i].pos_tr[1], pos_y = morphArr[i].pos_tr[2]} );
          else
            ObjDelete(curSimple)
          end
          if morphArr[i].params then
            ObjSet( curSimple, morphArr[i].params );
          end
        end  
      end;
    end    
      --DbgTrace(count_mr)
end


function private.InitPanelscr()
  
  function interface.PanelscrAdd(pos_z)
    InterfaceWidget_Panelscr = "InterfaceWidget_Panelscr";
    interface.CustomWidgetAdd( InterfaceWidget_Panelscr, "assets/interface/int_panelscr", "int_panelscr",pos_z );
  end;

  function interface.Panelscr_Show()

    interface.panelscr = {}
    int_panelscr.ShowAnim("show")
    
  end

  function interface.Panelscr_Hide(ho_name)
    int_panelscr.HideAnim("hide")
  end
  
end






end





function private.InitMap()
  
  function interface.MapRoomLock(rm, lock)
    if _G[ "int_map_impl" ] then
      int_map_impl.RoomLock(rm, lock)
    end    
  end
  
end


function private.InitPanelsgm()
  
  function interface.PanelsgmAdd(pos_z)
    InterfaceWidget_Panelsgm = "InterfaceWidget_Panelsgm";
    interface.CustomWidgetAdd( InterfaceWidget_Panelsgm, "assets/interface/int_panelsgm", "int_panelsgm",pos_z );
  end;

  function interface.Panelsgm_Show()

    interface.panelsgm = {}
    int_panelsgm.ShowAnim("show")
    
  end

  function interface.Panelsgm_Hide(ho_name)
    int_panelsgm.HideAnim("hide")
  end
  
end

function private.InitBtnHintInsgm()

  function interface.BtnHintUpdateInSecretRoom()
    if _G[ "int_button_hint_impl" ] then
      int_button_hint_impl.UpdateInSecretRoom()
    end   
  end

end
