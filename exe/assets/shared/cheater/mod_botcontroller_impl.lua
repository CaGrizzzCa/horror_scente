-- name=botcontroller_impl
function public.Init()

  --botcontroller.BotRestartCurrentLevel()
  --botcontroller.BotStop()

  --botcontroller.BotMouseDown( { x, y } )
  --botcontroller.BotMouseUp( { x, y } )
  --botcontroller.BotMouseClick( { x, y } )
  --botcontroller.BotMouseMove( { x, y } )
  --botcontroller.BotMouseLeave( { x, y } )
  --botcontroller.BotMouseDragDrop( { takeX, takeY }, { dropX, dropY } )

  --botcontroller.AddStackHandler( "prg_name", function() end )
    --функция хендлер для ситуации когда бот тупанул
    --функция должна возвращать TRUE если что-то делает, бот будет ждать....
   
  --botcontroller.AddForceHandler( "prg_name", function() end )
    --вызывается до любых попыток бота сделать что либо для выполнения этого прогресса
    --функция хендлер, которая знает что нужно делать для определенного прогресса лучше бота
    --функция должна возвращать TRUE если что-то делает, бот будет ждать....

  --botcontroller.AddActionHandler( "prg_name", function() end )
    --вызывается когда бот находится в месте выполнения прогресса
    --функция хендлер, которая знает что нужно делать для определенного прогресса лучше бота
    --функция должна возвращать TRUE если что-то делает, бот будет ждать....

  --botcontroller.AddLockHandler( "prg_name", function() end )
    --функция хендлер для ситуации когда игра заблокирована
    --функция должна возвращать TRUE если что-то делает, бот будет ждать....
  
--  botcontroller.AddLockHandler( "win_mousemg", function()
--    DbgTrace( "AddLockHandler!!!" ) 
--    botcontroller.BotRestartCurrentLevel()
--    return true 
--  end )
--  botcontroller.AddForceHandler( "win_mousemg", function() DbgTrace( "AddForceHandler!!!" ) return false end )
--  botcontroller.AddStackHandler( "win_mousemg", function() DbgTrace( "AddStackHandler!!!" ) return false end )
--
--  botcontroller.AddForceHandler( "get_pillow", function()
--    DbgTrace( "AddForceHandler get_pillow!!!" ) 
--    botcontroller.BotMouseClick( { 549, 309 } )
--    return true 
--  end )
--


  botcontroller.AddActionHandler( "win_decoratedchristmastree1", function()
    DbgTrace( "AddActionHandler win_decoratedchristmastree1!" ) 
    interface.ItemPanelHide()
    rm_toystoreyard1.win_decoratedchristmastree1()
    return true 
  end )

  botcontroller.AddActionHandler( "win_draingrating1", function()
    DbgTrace( "AddActionHandler win_draingrating1!" ) 
    rm_mainstreet1.win_draingrating1()
    return true 
  end )

  botcontroller.AddActionHandler( "win_hotwater1", function()
    DbgTrace( "AddActionHandler win_hotwater1!" ) 
    mg_hotwater1.Win()
    return true 
  end )
  
  botcontroller.AddActionHandler( "clk_showcase1int", function()
    DbgTrace( "AddActionHandler clk_showcase1int!" ) 
    rm_toystoreyard1.clk_showcase1int()
    return true 
  end )
  
  botcontroller.AddActionHandler( "win_toycar1", function()
    DbgTrace( "AddActionHandler win_toycar1!" ) 
    interface.TaskPanelHide()
    rm_mainstreet1.win_toycar1()
    return true 
  end )
  
  --botcontroller.AddActionHandler( "win_snowplowmg2", function()
  --  DbgTrace( "AddActionHandler mg_snowplowmg2!" ) 
  --  mg_snowplowmg2.Win()
  --  return true 
  --end )

end
