-- name=interface_impl
-- name=interface_impl
-----------------------------interface_impl------------------------------------------------
function public.Init ()
  
  public.Init_Lock()
  
end;
--******************************************************************************************
function public.Init_Lock()
  DbgTrace("public.Init_Lock()")
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

end