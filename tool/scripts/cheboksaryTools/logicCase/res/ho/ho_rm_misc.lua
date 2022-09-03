  local win_##rm##_for_##rm_owner## = function()
    if ld.CheckRequirements( {"win_##rm##"} ) then
      ObjSet( "gho_##rm_owner##_##rm##", {input = 0, visible = 0} );
    end
  end;
  cmn.AddSubscriber("win_##rm##", win_##rm##_for_##rm_owner##, private.room_objname )