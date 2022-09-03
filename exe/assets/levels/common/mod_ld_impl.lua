-- name=ld_impl
--*********************************************************************************************************************
--*********************************************************************************************************************

function public.Init()  

  ld.TableValuesCount       = public.TableValuesCount;
  ld.TableCount             = public.TableCount;
  ld.ZzCompleteCheck        = public.ZzCompleteCheck;
  ld.CheckRequirements      = public.CheckRequirements;
  ld.CheckRequirementsLast  = public.CheckRequirementsLast;
  ld.SetCursor              = public.ShCur;
  ld.ShCur                  = public.ShCur;
  ld.ObjCreate              = public.ObjCreate;
  ld.CopyObj                = public.CopyObj;
  ld.CopyStruct             = public.CopyStruct;
  ld.StartTimer             = public.StartTimer;
  --ld.LogTrace               = common.LogTrace;
  ld.StringDivide           = public.StringDivide;
  ld.NumberFromString       = public.NumberFromString;
  ld.MicroClick             = public.MicroClick;
  ld.SetWidgetsVisible      = public.SetWidgetsVisible;    
  ld.AnimPlayFromStatic     = public.AnimPlayFromStatic;      
  ld.TableContains          = public.TableContains;
  ld.PlayGetSound           = public.PlayGetSound;
  ld.TableCopy              = public.TableCopy;
  ld.TableEquals            = public.TableEquals;
  ld.TableSum               = public.TableSum;
  ld.TableShuffle           = public.TableShuffle; 
  ld.IsLdCheater            = public.IsLdCheater; 
  ld.CloseSubRoom           = public.CloseSubRoom;

  ld.AnimPlay               = private.AnimPlay;
  ld.ObjIntersectCheck      = public.ObjIntersectCheck;
  ld.ApplyCheck             = public.ApplyCheck;
  ld.SetGHOMask             = private.SetGHOMask;
  ld.FxAnmObj               = public.FxAnmObj;
  ld.FxBlickAnmObj          = public.FxBlickAnmObj;
  ld.FxBlick                = public.FxBlick;
  ld.mmgZoomInit            = public.mmgZoomInit;
  ld.mhoZoomInit            = public.mhoZoomInit;  
  ld.NoteInit               = public.NoteInit;
  ld.NoteRelaseLock         = public.NoteRelaseLock;
  ld.NoteRemovable          = public.NoteRemovable;
  ld.VidStaticInit          = public.VidStaticInit
  ld.VidStaticPlay          = public.VidStaticPlay 
  ld.VidStaticPause         = public.VidStaticPause
  ld.VidStaticShow          = public.VidStaticShow 
  ld.VidStaticHide          = public.VidStaticHide 
  ld.VidStaticAttach        = public.VidStaticAttach
  ld.VidStaticDetach        = public.VidStaticDetach 
  ld.VidStaticReset         = public.VidStaticReset
  ld.VidStaticContinue      = public.VidStaticContinue

  ld.SetMinibackPostfixForRoom = public.SetMinibackPostfixForRoom;
  ld.GetMinibackPostfixForRoom = public.GetMinibackPostfixForRoom;

  ld.Quick                  = public.Quick;
  ld.Math                   = public.Math;
  ld.Collision              = public.Collision;
  ld.Anim                   = public.Anim;
  ld.Debag                  = public.Debag;
  ld.Debug                  = public.Debug;
  ld.Clock                  = public.Clock;
  ld.Pool                   = public.Pool;
  ld.Table                  = public.Table;
  ld.Room                   = public.Room;
  ld.SubRoom                = public.SubRoom;
  ld.String                 = public.String;  

  SoundSfx                  = public.SoundSfx;
  SoundSfxGame              = public.SoundSfxGame;
  SoundSfxStop              = public.SoundSfxStop;
  SoundSfxPause             = public.SoundSfxPause
  SoundEnv                  = public.SoundEnv;
  SoundEnvHide              = public.SoundEnvHide;
  SoundEnvInit              = public.SoundEnvInit;
  SoundTheme                = public.SoundTheme;
  SoundIsPlaying            = public.SoundIsPlaying;
  SoundSfxTick              = public.SoundSfxTick;
  SoundVoice                = public.SoundVoice;
  SoundVid                  = public.SoundVid;
  SoundHoTheme              = public.SoundHoTheme;
  SoundMgTheme              = public.SoundMgTheme;
end;




--------------------------------------------------------------------------------------
function public.GetCurrentPlace()
  return common_impl.GetCurrentPlace();
end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--Выключение/включение альфы перечисленных виджетов
--list - массив виджетов либо имя presets ( "DialogVideoShow" - будут скрыты виджеты перечисленные в presets.DialogVideoShow )
function public.SetWidgetsVisible( list, visible, fast )
  if list ~= nil then
    
    --пресеты
    if type( list ) == "string" then
      local presets = {};
      presets.Empty = {};
      presets.DialogVideoShow = {
          InterfaceWidget_Inventory;
          InterfaceWidget_BtnHint;
          InterfaceWidget_BtnGuide;
          InterfaceWidget_BtnMenu;
          InterfaceWidget_BtnMap;  
          InterfaceWidget_Helper;
      };
      presets.DialogVideoShowNoHint = {
          InterfaceWidget_Inventory;
          InterfaceWidget_BtnMenu;
          --InterfaceWidget_BtnMap;  
          InterfaceWidget_Helper;
      };
      presets.DialogVideoShowNoMap = {
          InterfaceWidget_Inventory;
          InterfaceWidget_BtnHint;
          InterfaceWidget_BtnGuide;
          InterfaceWidget_BtnMenu;
          --InterfaceWidget_BtnMap;  
          InterfaceWidget_Helper;
      };        
      presets.DialogStoryMG = {
          InterfaceWidget_BtnSkip;
          InterfaceWidget_BtnReset;
          InterfaceWidget_BtnInfo;
          InterfaceWidget_BtnGuide;
          InterfaceWidget_BtnMenu;
          InterfaceWidget_BtnMap;  
          InterfaceWidget_Helper;
      };
      presets.DialogVideoHide = presets.DialogVideoShow
      if presets[ list ] then
        list = ld.TableCopy( presets[ list ] );
      end;
    end

    if type( visible ) == "number" then
      if visible == 1 then
        visible = true
      else
        visible = false
      end;
    elseif visible == nil then
      visible = false
    end;

    if type( list ) == "table" then
      for i,o in pairs(list) do
        if list[i] then
          interface.WidgetSetVisible( list[i], visible, not fast );
        end
      end;
    else

    end;
  end;
end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--function Quick() end
public.Quick = {}
  function public.Quick.GetInputRect(...)--выдача таблицы инпутректа от объекта "zz_test" или {width, height}
    local error = function (n,params)
      local errors = {
--[[1 ]]"zero size args",
--[[2 ]]"above 2 arguments",
--[[3 ]]"wrong types of arguments",
--[[4 ]]"object not found",
      }
      ld.LogTrace( "Error "..n.." in Quick.GetInputRect: "..errors[n], params );
    end

    local result = function(w,h)
      return {inputrect_init = true, inputrect_x = -w/2, inputrect_y = -h/2, inputrect_w = w, inputrect_h = h}
    end

    local arg = {...}
    if #arg == 0 then error(1,arg) return end
    if #arg > 2 then error(2,arg) end
    if (type(arg[1]) == "number" and type(arg[2]) == "number") then
      return result(arg[1],arg[2])
    elseif type(arg[1]) == "table" and (type(arg[1][1]) == "number" and type(arg[1][2]) == "number") then
      return result(arg[1][1],arg[1][2])
    elseif type(arg[1]) == "string" then

      local obj = ObjGet(arg[1])
      if not obj then error(4,arg) end
      if obj.inputrect_init then --Copy inputrect
        return {inputrect_init = true, inputrect_x = obj.inputrect_x, inputrect_y = obj.inputrect_y, 
          inputrect_w = obj.inputrect_w, inputrect_h = obj.inputrect_h}
      else --Get inputrect from texture
        return result(obj.draw_width, obj.draw_height)
      end
    else
      error(3,arg) 
      return
    end
  end

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  function public.Quick.GetColor(obj)
    local result = {}
    if type(obj) == "string" then
      local params = ObjGet(obj)
      result.color_r = params.color_r
      result.color_g = params.color_g
      result.color_b = params.color_b
    elseif type(obj) == "table" then
      result.color_r = obj[1]
      result.color_g = obj[2]
      result.color_b = obj[3]
    elseif type(obj) == "number" then
      result.color_r = obj
      result.color_g = obj
      result.color_b = obj
    else
      return false
    end
    return result
  end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  function public.Quick.GetPos(obj, objByObj, angByObj)
    if type(obj) == "number" and type(objByObj) == "number" then
      return {pos_x = obj, pos_y = objByObj}
    end
    if type(obj) == "table" then
      return public.Quick.GetPos(obj[1], obj[2])
    end
    local params = ObjGet(obj)
    if params then
      if objByObj then
        local pos = GetObjPosByObj(obj, type(objByObj) == "string" and objByObj or nil)
        if angByObj then 
          local ang = GetObjAngByObj(obj, type(angByObj) == "string" and angByObj or nil)
          return {pos_x = pos[1], pos_y = pos[2], ang = ang}
        else
          return {pos_x = pos[1], pos_y = pos[2]}
        end
      else
        return {pos_x = params.pos_x, pos_y = params.pos_y}
      end
    else
      ld.LogTrace( "Error in ld.Quick.GetPos", obj, "obj not exist" );
    end
  end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  function public.Quick.CopyPosRect(obj, from)
    ObjSet( obj, ld.Quick.GetInputRect(from)  );
    ObjSet( obj, ld.Quick.GetPos(from)  );
    ObjSet( obj, {ang = ObjGet( from ).ang} );
  end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  function public.Quick.GetPosByGrid( pos, cellSizes, fieldStart )
    cellSizes = cellSizes or {1,1,1}
    fieldStart = fieldStart or {0,0,0}
    local errPrefix = "Error in Quick.GetPosByGrid"
    if type(pos) ~= "table" or type(cellSizes) ~= "table" or type(fieldStart) ~= "table" then 
      ld.LogTrace( errPrefix, "some of the args is not a table type" );
      return {}
    end
    if #cellSizes < #pos or #fieldStart < #pos then 
      ld.LogTrace( errPrefix, "some of the args is less lenght then first" );
      return {}
    end
    local dimensions = {"pos_y", "pos_x", "pos_z"}
    local result = {}
    for i,o in ipairs(pos) do
      result[ dimensions[i] ] = (o-1)*cellSizes[i] + fieldStart[i]
    end
    return result
  end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  function public.Quick.SetGfxToTop(get_prg)
    if public.CheckRequirements( {get_prg} ) then
      return
    end
    local hint_table = common_impl.hint[get_prg]
    if hint_table and hint_table.type ~= "get" then
      ld.LogTrace( "ERROR in ld.Quick.SetGfxToTop, param1 expected get progress name, but was", get_prg );
      return
    end
    local overlay_expected = "obj_"..ld.String.Split(hint_table.zz)[2].."_overlay"
    local is_overlay = room ~= "inv_complex_inv" and hint_table.zz and ObjGet(overlay_expected)
    local attach_target = is_overlay and overlay_expected or hint_table.zz or hint_table.room
    local gfx_name = string.gsub(hint_table.get_obj, "^spr_", "gfx_")
    if not ObjGet(gfx_name) then
      ld.LogTrace( "ERROR in ld.Quick.SetGfxToTop, cant find such gfx, used name was", gfx_name );
      return      
    end
    local pos = GetObjPosByObj(gfx_name, attach_target)
    local ang = GetObjAngByObj(gfx_name, attach_target)
    ObjAttach(gfx_name, attach_target)
    ObjSet( gfx_name, {pos_x = pos[1], pos_y = pos[2], ang = ang} );
  end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--function Math() end
public.Math = {}

  function public.Math.CustomRandom(max, chancesTable) -- возвращает value в пределах 1 и max

    if not chancesTable then
      return math.random(1,max)
    end
    local newMax = 0
    for i = 1,max do
      newMax = newMax + (chancesTable[i] or 1) 
    end
    local newRandom = math.random(1,newMax)

    for i = 1,max do
      if newRandom-1 < (chancesTable[i] or 1) then return i end
      newRandom = newRandom - (chancesTable[i] or 1)
    end 
    return 1

  end
--------------------------------------------------------------------------------------
  function public.Math.Sign(value)
    return ( value >= 0 and 1 or -1)
  end
--------------------------------------------------------------------------------------
  function public.Math.Clamp(value, min, max) -- возвращает value в пределах min и max
    if min > max then
      min, max = max, min
    end
    return ( value > max and max ) or ( value < min and min ) or value
  end
--------------------------------------------------------------------------------------
  function public.Math.InBorders(value, limits) -- возвращает истину если value в пределах limits[1] limits[2]
    if type(value) ~= "number" or type(limits) ~= "table" or 
       type(limits[1]) ~= "number" or type(limits[2]) ~= "number" then
      ld.LogTrace( "Error in ld.Math.InBorders; wrong type" );
      return false
    end
    if limits[1] > limits[2] then
        limits[1], limits[2] = limits[2], limits[1]
    end
    if (value >= limits[1] and value <= limits[2]) then
      return true
    end
    return false
  end
--------------------------------------------------------------------------------------
  function public.Math.RotTable(n)
    if type(n) ~= "number" or n ~= math.tointeger(n) then
      ld.LogTrace( "Error in ld.Math.RotTable(n): wrong type of n",n );
      return
    end
    local step = (math.pi*2)/n
    local result = {}
    for i = 1,n do
      local val = math.modf(step*(i-1) * 1000)/1000
      table.insert(result,val)
    end
    return result
  end
--------------------------------------------------------------------------------------
  -- возвращаяет угол в пределах 0 <= ang <= math.pi*2
  function public.Math.AngNorm( ang )
    ang = ang % ( math.pi * 2 )
    if ang < 0 then ang = ang + math.pi * 2 end
    return ang
  end
--------------------------------------------------------------------------------------
  -- вернет a_beg, a_beg+math.pi*2, или a_beg-math.pi*2
  -- для кратчайшей анимации поворота угла от a_beg к a_end
  -- 0 <= ( a_beg и a_end ) <= math.pi*2
  function public.Math.AngCloser( a_beg, a_end )
    if math.abs(a_beg-a_end) > math.pi then
      if a_beg > a_end then
        a_beg = a_beg - math.pi * 2
      else
        a_beg = a_beg + math.pi * 2
      end;
    end;
    return a_beg;
  end;
--------------------------------------------------------------------------------------
  -- возвращает угол между прямой и осью ОХ, расстояние между точками
  function public.Math.AngGip( x1,y1,x2,y2,len )
    len = len or ( (x1-x2)^2 +(y1-y2)^2 )^0.5
    y1=-y1; --переворот для игровой системы координат
    y2=-y2; --переворот для игровой системы координат
    if len == 0 then return 0,0 end --исключение
    local k = ( y1 - y2 ) / len
    local a = math.abs( math.asin( k ) )
    if x2 >= x1 and y2 <= y1 then
      a = math.pi*2 - a
      return a,len
    elseif x2 >= x1 and y2 >= y1 then
      return a,len
    elseif x2 <= x1 and y2 <= y1 then
      a = math.pi + a
      return a,len
    elseif x2 <= x1 and y2 >= y1 then
      a = math.pi - a
      return a,len
    end;
  end
--------------------------------------------------------------------------------------
  -- возвращает расстояние между точками или точкой и началом координат
  function public.Math.Len( x1,y1,x2,y2 )
    return ( ( x1 - ( x2 or 0 ) ) ^ 2 + ( y1 - ( y2 or 0 ) ) ^ 2 ) ^ 0.5
  end
  
--------------------------------------------------------------------------------------
  ---- вовзращает координаты окружности с центром center с радиусом radius, делит круг на points_count частей
  function public.Math.OnCircle(center, radius, points_count, offset)
    local coordinates = {}
    local xc = center[1]
    local yc = center[2]
    for p=1,points_count do
      local ang = 2*math.pi*(p-1)/points_count - (offset or 0);
      local x = xc + radius*math.cos( ang );
      local y = yc + radius*math.sin( ang );
      coordinates[p] = {x=x, y=y, ang=-ang}
    end;
    return coordinates;
  end;  
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------  
  function public.Math.Round( x )
    local dx = x - math.floor(x);
    local res
    if dx>=0.5 then
      res = math.ceil(x);
    else 
      res = math.floor(x);
    end
    return res
  end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--function Collision() end
public.Collision = {}
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  -- возращает координаты пересечения прямых
  -- in_line - если истинно, и точка пересечения находится вне отрезках, вернёт false
  function public.Collision.LineWithLine( line1_x1, line1_y1, line1_x2, line1_y2, line2_x1, line2_y1, line2_x2, line2_y2, in_line )
  --ld.LogTrace( line1, line2 )

    if in_line then
      if (    line1_x1 > line2_x1
          and line1_x1 > line2_x2
          and line1_x2 > line2_x1
          and line1_x2 > line2_x2
         ) 
        or 
        (     line1_x1 < line2_x1
          and line1_x1 < line2_x2
          and line1_x2 < line2_x1
          and line1_x2 < line2_x2
         )
        or
         (    line1_y1 > line2_y1
          and line1_y1 > line2_y2
          and line1_y2 > line2_y1
          and line1_y2 > line2_y2
         ) 
        or 
        (     line1_y1 < line2_y1
          and line1_y1 < line2_y2
          and line1_y2 < line2_y1
          and line1_y2 < line2_y2
         )
      then
        --[[ не пересекаются ]]
          return false;
      end
    end

    line1_y1 = -line1_y1; --переворот для игровой системы координат
    line1_y2 = -line1_y2; --переворот для игровой системы координат
    line2_y1 = -line2_y1; --переворот для игровой системы координат
    line2_y2 = -line2_y2; --переворот для игровой системы координат

    local zk1 = ( line1_x1 - line1_x2 )
    local zk2 = ( line2_x1 - line2_x2 )
    local k1
    local k2
    local b1
    local b2
    local x, y
    local n = 0
    if math.abs( zk1 ) < 0.001 and math.abs( zk2 ) < 0.001then
      --[[ паралельные прямые отностительно У ]]
      return false
    elseif math.abs( zk1 ) < 0.001 then
      k2 = ( line2_y1 - line2_y2 ) / zk2;
      x = line1_x1
      y = k2 * ( line1_x1 - line2_x1 ) + line2_y1
    elseif math.abs( zk2 ) < 0.001 then
      k1 = ( line1_y1 - line1_y2 ) / zk1;
      x = line2_x1
      y = k1 * ( line2_x1 - line1_x1 ) + line1_y1
    else
      k1 = ( line1_y1 - line1_y2 ) / zk1;
      k2 = ( line2_y1 - line2_y2 ) / zk2;
      b1 = line1_y1 - k1 * line1_x1
      b2 = line2_y1 - k2 * line2_x1
      x = ( b2 - b1 ) / ( k1 - k2 )
      y = k2 * x + b2
      x = x
    end

    y=-y

    line1_y1 = -line1_y1; --переворот для игровой системы координат
    line1_y2 = -line1_y2; --переворот для игровой системы координат
    line2_y1 = -line2_y1; --переворот для игровой системы координат
    line2_y2 = -line2_y2; --переворот для игровой системы координат

    --ld.LogTrace( line1, line2, n, k1, b1, k2, b2, x, y )

    if in_line then
      if ( ( x > line1_x1 and x > line1_x2 ) or ( x > line2_x1 and x > line2_x2 ) )
      or ( ( x < line1_x1 and x < line1_x2 ) or ( x < line2_x1 and x < line2_x2 ) )
      or ( ( y > line1_y1 and y > line1_y2 ) or ( y > line2_y1 and y > line2_y2 ) )
      or ( ( y < line1_y1 and y < line1_y2 ) or ( y < line2_y1 and y < line2_y2 ) )
      then
        --точка пересечения не лежит на отрезках
        return false
      end
    end

    --ld.LogTrace( line1, line2, n, k1, b1, k2, b2, x, y )

    return { pos_x = x, pos_y = y }

  end;
--------------------------------------------------------------------------------------
  --  возвращяет координаты пересечения прямой lx1,ly1, lx2,ly2 и окружности cx,cy,cr
  --  first_closer_to_lx1_ly1 - нужно ли учитовать близость координат к началу линии
  function public.Collision.LineWithCircle( lx1, ly1, lx2, ly2, cx, cy, cr, first_closer_to_lx1_ly1 )
    ly1 = -ly1; --переворот для игровой системы координат
    ly2 = -ly2; --переворот для игровой системы координат
    cy  = -cy;  --переворот для игровой системы координат

    if not ( ( ( ( ( lx1 - cr ) < cx ) and ( cx < ( lx2 + cr ) ) ) or ( ( ( lx1 + cr ) > cx ) and ( cx > ( lx2 - cr ) ) ) )
    and ( ( ( ( ly1 - cr ) < cy ) and ( cy < ( ly2 + cr ) ) ) or ( ( ( ly1 + cr ) > cy ) and ( cy > ( ly2 - cr ) ) ) ) )
    then
      --  окружность не входит в пределы отрезка ( упрощенная обработка окружности в виде квадрата )
      return false;
    end;

    local X1
    local X2
    local Y1
    local Y2

    --if math.abs( lx1 - lx2 ) < 0.001 then
    --  --обработка линии паралельной оси ОУ
    --  local collision = public.Collision.NormalFromDotToLine( cx, -cy, lx1, -ly1, lx2, -ly2, true )
    --  --if not collision then
    --  --  ld.LogTrace( cx, cy, lx1, ly1, lx2, ly2 )
    --  --else
    --  --  ld.LogTrace( cx, cy, lx1, ly1, lx2, ly2, collision )
    --  --end
    --  collision.pos_y = - collision.pos_y
    --  local a = math.abs( cx - collision.pos_x )
    --  local c = cr
    --  local b = ( ( c ^ 2 ) - ( a ^ 2 ) ) ^ 0.5
    --  X1 = ( lx1 + lx2 ) / 2
    --  Y1 = collision.pos_y + b
    --  X2 = X1
    --  Y2 = collision.pos_y - b
    --  --ld.LogTrace( "OX", a, b, c, X1, Y1, X2, Y2 )
    --elseif math.abs( ly1 - ly2 ) < 0.001 then
    --  --обработка линии паралельной оси ОХ
    --  local collision = public.Collision.NormalFromDotToLine( cx, -cy, lx1, -ly1, lx2, -ly2, true )
    --  --if not collision then
    --  --  ld.LogTrace( cx, cy, lx1, ly1, lx2, ly2 )
    --  --else
    --    --ld.LogTrace( cx, cy, lx1, ly1, lx2, ly2, collision )
    --  --end
    --  collision.pos_y = - collision.pos_y
    --  local a = math.abs( cy - collision.pos_y )
    --  local c = cr
    --  local b = ( ( c ^ 2 ) - ( a ^ 2 ) ) ^ 0.5
    --  X1 = collision.pos_x + b
    --  Y1 = ( ly1 + ly2 ) / 2
    --  X2 = collision.pos_x - b
    --  Y2 = Y1
    --  --ld.LogTrace( "OY", a, b, c, X1, Y1, X2, Y2 )
    --else
      --local k = ( ly1 - ly2 ) / ( lx1 - lx2 );
      --local b = ly2 - k * lx2
      ---- уравнение прямой      {  y = kx + b
      ---- уравнение окружности  { (x-cx)^2+(y-cy)^2=cr^2
      ---- >> (x-cx)^2 + (kx+b-cy)^2 = cr^2
      ---- >> x^2 - 2xcx + cx^2 + (kx+b)^2 - 2(kx+b)cy + cy^2 - cr^2 = 0
      ---- >> X^2 - 2cxX + cx^2 + k^2X^2 + 2kbX + b^2 - 2kcyX - 2bcy + cy^2 - cr^2 = 0
      ---- >> ( 1 + k^2 ) X^2 + ( -2cx + 2kb - 2kcy ) X + ( cx^2 + b^2 - 2bcy + cy^2 - cr^2 ) = 0
      ---- > A = ( 1 + k^2 ); B = ( -2cx + 2kb - 2kcy ); C = ( cx^2 + b^2 - 2bcy + cy^2 - cr^2 );
      --local A = 1 + k ^ 2;
      --local B = -2 * cx + 2 * k * b - 2 * k * cy;
      --local C = cx ^ 2 + b ^ 2 - 2 * b * cy + cy ^ 2 - cr ^ 2;
      --local D = B ^ 2 - 4 * A * C
      --if D < 0 then
      --  return false
      --else
      --  D = D ^ 0.5;
      --end;
      --X1 = ( -B - D ) / ( 2 * A );
      --X2 = ( -B + D ) / ( 2 * A );
      --Y1 = k * X1 + b;
      --Y2 = k * X2 + b;

      --изменен способ определения коллизии ( при больших расстояниях переполнение INT )
      local _cx = cx;
      local _cy = cy;
      cx = 0;
      cy = 0;
      lx1 = lx1 - _cx;
      lx2 = lx2 - _cx;
      ly1 = ly1 - _cy;
      ly2 = ly2 - _cy;

      local collision = public.Collision.NormalFromDotToLine( cx, -cy, lx1, -ly1, lx2, -ly2, true )
      if not collision then return false end;
      local ang, a = ld.Math.AngGip( cx, -cy, collision.pos_x, collision.pos_y )
      local c = cr
      local b = ( ( c ^ 2 ) - ( a ^ 2 ) ) ^ 0.5
      ang = ang + math.pi * 0.5
      local dx = b * math.cos( ang )
      local dy = b * math.sin( ang )
      X1 = collision.pos_x + dx + _cx;
      Y1 = ( -collision.pos_y + dy ) + _cy;
      X2 = collision.pos_x - dx + _cx;
      Y2 = ( -collision.pos_y - dy ) + _cy;
    --end

    lx1 = lx1 + _cx;
    lx2 = lx2 + _cx;
    ly1 = ly1 + _cy;
    ly2 = ly2 + _cy;

    if first_closer_to_lx1_ly1 == true then
      if ld.Math.Len( lx1,ly1, X1,Y1 ) > ld.Math.Len( lx1,ly1, X2,Y2 ) then
        X1,Y1,X2,Y2 = X2,Y2,X1,Y1
      end;
    elseif first_closer_to_lx1_ly1 == false then
      if ld.Math.Len( lx1,ly1, X1,Y1 ) < ld.Math.Len( lx1,ly1, X2,Y2 ) then
        X1,Y1,X2,Y2 = X2,Y2,X1,Y1
      end;
    end;

    if not (
      ( ( ( lx1 <= X1 and X1 <= lx2 ) or ( lx2 <= X1 and X1 <= lx1 ) ) and ( ( ly1 <= Y1 and Y1 <= ly2 ) or ( ly2 <= Y1 and Y1 <= ly1 ) ) )
      or ( ( ( lx1 <= X2 and X2 <= lx2 ) or ( lx2 <= X2 and X2 <= lx1 ) ) and ( ( ly1 <= Y2 and Y2 <= ly2 ) or ( ly2 <= Y2 and Y2 <= ly1 ) ) )
    ) then
      --  отрезок не входит в окужность
      return false;
    end;

    Y1 = - Y1;  --переворот для игровой системы координат
    Y2 = - Y2;  --переворот для игровой системы координат

    --return { { pos_x = X1; pos_y = Y1; }; { pos_x = X2; pos_y = Y2; } }
    return { { pos_x = X1; pos_y = Y1; }; { pos_x = X2; pos_y = Y2; } }
  end
--------------------------------------------------------------------------------------
  -- возращает координаты пересечения прямой c линиями составленными из polygon_points ( + последняя и первая точка )
  -- line_points = { { x1; y1; }; { x2; y2; } }
  -- polygon_points = { { x1; y1; }; { x2; y2; }; ...; { xn; yn; }; }
  --     >> { { x(n-1); y(n-1); }; { xn; yn; }; } 
  -- nearest - для определения ближайшего пересечения
  function public.Collision.LineWithPolygon( line_points, polygon_points, nearest )
    local points_count = #polygon_points;
    local answer
    local answer_len
    local collision
    for i = 1, points_count do
      if i == points_count then
        collision = ld.Collision.LineWithLine( line_points[ 1 ][ 1 ], line_points[ 1 ][ 2 ], line_points[ 2 ][ 1 ], line_points[ 2 ][ 2 ],
                                               polygon_points[ i ][ 1 ], polygon_points[ i ][ 2 ], polygon_points[ 1 ][ 1 ], polygon_points[ 1 ][ 2 ], true )
      else
        collision = ld.Collision.LineWithLine( line_points[ 1 ][ 1 ], line_points[ 1 ][ 2 ], line_points[ 2 ][ 1 ], line_points[ 2 ][ 2 ],
                                               polygon_points[ i ][ 1 ], polygon_points[ i ][ 2 ], polygon_points[ i + 1 ][ 1 ], polygon_points[ i + 1 ][ 2 ], true )
      end
      if collision then
        if nearest then
          if answer then
            answer_len = answer_len or ld.Math.Len( line_points[ 1 ][ 1 ], line_points[ 1 ][ 2 ], answer.pos_x, answer.pos_y )
            local len = ld.Math.Len( line_points[ 1 ][ 1 ], line_points[ 1 ][ 2 ], collision.pos_x, collision.pos_y )
            if len < answer_len then
              answer_len = len
              answer = collision
            end
          else
            answer = collision
          end
        else
          return collision
        end
      end
    end
    return answer
  end
--------------------------------------------------------------------------------------
  -- возвращает координату точки пересечения перпендикуляра опущенного с точки на линию
  -- in_line - если истинно, и точка пересечения находится вне отрезках, вернёт false
  function public.Collision.NormalFromDotToLine( dot_x, dot_y, line_x1, line_y1, line_x2, line_y2, in_line )
    local ang = ld.Math.AngGip( line_x1, line_y1, line_x2, line_y2 ) + math.pi / 2
    local dot_x2 = dot_x + 1000 * math.cos( ang )
    local dot_y2 = dot_y - 1000 * math.sin( ang )
    dot_x = dot_x - 1000 * math.cos( ang )
    dot_y = dot_y + 1000 * math.sin( ang )
    return public.Collision.LineWithLine( dot_x, dot_y, dot_x2, dot_y2, line_x1, line_y1, line_x2, line_y2, in_line )
  end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------  
--function Anim()  end
public.Anim = {}
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  function public.Anim.BakedSwitch(...) --local baked, alphed, val, time
    local error = function (n,params)
      local errors = {
--[[1 ]]"lengh of args is wrong",
--[[2 ]]"wrong type of some argument",
--[[3 ]]"val is out of bounds 0..1",
--[[3 ]]"time is out of bounds 0..100"
      }
      ld.LogTrace( "Error "..n.." in ld.Anim.BakedSwitch: "..errors[n], params  );
    end

    local arg = {...}
    if #arg ~= 3 and #arg ~= 4 then error(1,arg) return end
    local baked, alphed, val, time
    if #arg == 3 then
      baked, alphed, val, time = arg[1], arg[1], arg[2], arg[3]
    else
      baked, alphed, val, time = arg[1], arg[2], arg[3], arg[4]
    end

    if type(baked) == "string" and type(alphed) == "string" and type(val) == "number" and type(time) == "number" then
      if not ld.Math.InBorders(val, {0,1}) then error(3,val) return end
      if not ld.Math.InBorders(time, {0,100}) then error(4,time) end
    else error(2,arg) return end
    
    ObjSet( baked, {bake = 1} );
    ObjAnimate( alphed, 8, 0, 0, function() end, {0,0,ObjGet(alphed).alp, time,0,val} );
    ld.StartTimer( time, function()  
      ObjSet( baked, {clear_bake = 1, bake = 0} );
    end )
  end
  --------------------------------------------------------------------------------------
  function public.Anim.Blink(obj, params)  --мерцаем объектом
    local objParams = ObjGet(obj)
    if not objParams then return end
    local default = {                     --дефолт
      blinkTime = 0.5;                    --полное время 1 блинка
      blinkCount = 2;                     --сколько раз
      startAlp = objParams.alp;           --из какой альфы
      midAlp = 1;                         --какая альфа в середине блинка
      func_end = function()  end;         --ф-я callback
    }
    params = params or {}
    for i,o in pairs(default) do
      if not params[i] then
        params[i] = o
      end
    end
    local counter = params.blinkCount

    local function blink()
      if counter <= 0 then
        ObjStopAnimate(obj, 8)
        if params.func_end then
          params.func_end()
        end
      else
        ObjAnimate( obj, 8, 0, 0, function() counter = counter - 1; blink() end, {
          0,3,params.startAlp, 
          params.blinkTime*0.5,3,params.midAlp, 
          params.blinkTime,3,params.startAlp
        } );
      end
    end
    blink()
  end
  --------------------------------------------------------------------------------------
  function public.Anim.Set(obj, arr, slowTimeOrLiquid, spiral, interpolation)
    interpolation = interpolation or 3
    local currentParams = ObjGet(obj)
    if not currentParams then return end
    local spiralDone
    if slowTimeOrLiquid then
      for i,o in pairs(arr) do
        local animExept = {"input","visible","active","inputrect_init","drag","realdrag","croprect_init"}
        local from = currentParams[i]
        if i == "alp" then
          o = ld.Math.Clamp(o, 0, 1)
        end
        if i == "ang" then
          from = ld.Math.AngCloser( from, o )
        end
        if ld.TableContains(animExept, i) then -- если параметр булевый 
          ld.StartTimer( o*slowTimeOrLiquid, function()
            ObjSet( currentParams.name, {[i] = o} );
          end )
        else
          if type(slowTimeOrLiquid) == "number" then
            if spiral and (i == "pos_x" or i == "pos_y") then
              if not spiralDone then
                spiralDone = true
                local len = ld.Math.Len( currentParams.pos_x,currentParams.pos_y,arr.pos_x,arr.pos_y )
                local animtable = ld.Anim.Spiral( {currentParams.pos_x,currentParams.pos_y}, 
                  {arr.pos_x,arr.pos_y}, spiral, slowTimeOrLiquid)
                ObjAnimate( obj, 3, 0, 0, function() end, animtable );
              end
            else
              ObjAnimate( obj, i, 0, 0, function() end, {0,interpolation,from, slowTimeOrLiquid,interpolation,o} );
            end
          elseif type(slowTimeOrLiquid) == "table" then
            --liquid
            if #slowTimeOrLiquid < 6 then ld.LogTrace( "Error in ld.Anim.Set: lenght of slowTimeOrLiquid low",slowTimeOrLiquid  ); end
            local currLiquid = {}
            currLiquid = ld.TableCopy(slowTimeOrLiquid)
            local diff = o-from
            local smoothDif
            if #currLiquid > 9 then
              smoothDif = currLiquid[9]
            end
            for k,v in ipairs(currLiquid) do
              if k%3 == 0 then
                currLiquid[k] = from + diff*v
                if i == "alp" then
                  currLiquid[k] = ld.Math.Clamp(currLiquid[k], 0, 1)
                end
              end
            end
            if i == "ang" then
              for k = #currLiquid,1,-1 do
                if k%3 == 0 and currLiquid[k-3] then
                  currLiquid[k-3] = ld.Math.AngCloser( currLiquid[k-3], currLiquid[k] )
                end
              end
            end
            if smoothDif and i == "ang" then
              currLiquid[9] = currLiquid[6] + smoothDif*(currLiquid[12] - currLiquid[6]) 
            end 

            ObjAnimate( obj, i, 0, 0, function() end, currLiquid );
          end
        end
      end
    else
      ObjSet( obj, arr );
    end
  end
--------------------------------------------------------------------------------------
  function private.AnimPlay( anim, animfunc, func_end, sfx )

    func_end = func_end or function() end
    if anim == "" and animfunc == "" and func_end and type( func_end ) == "function" then
      ld.StartTimer( 0.0, func_end )
    else
      if sfx then
        SoundSfx( sfx )
      end
      AnimPlay( anim, animfunc, function()
        if not ld.LastAnimPlayed then
          ld.LastAnimPlayed = {}
        end
        table.insert(ld.LastAnimPlayed, {anim = anim, animfunc = animfunc} )
        cmn.CallEventHandler( "ldAnimPlay_end" );
        table.remove(ld.LastAnimPlayed, 1);
        if type( func_end ) == "function" then
          func_end()
        end
      end )
    end 
  end

  --------------------------------------------------------------------------------------
  function private.AnimReverse( anim, func_end, sfx, interpolation )
    local o = ObjGet( anim )
    if not o.frame then return end
    local t = o.frame / 60
    ObjAnimate( anim, "frame", 0, 0, func_end, { 
      0, 0, o.frame;
      t, interpolation or 0, 0;
    } )
    if sfx then
      SoundSfx( sfx )
    end
  end
  
  function public.Anim.Reverse( anim, func_end, sfx, interpolation )
    private.AnimReverse( anim, func_end, sfx, interpolation )
  end
  --------------------------------------------------------------------------------------
  function public.Anim.Liquid(time,count,minValue,maxValue,percentOverlay,oneWay,smoothPercent,smoothTime )
    --percentOverlay 0..1 возвращает таблицу таблиц для анимации 
    --smoothPercent 0..0.1 и т.п. - сколько процентов значения от общего изменения будет избыточным сдвигом относительно финальной точки, smoothTime - время в секундах на анимацию избыточного сдвига
    --smoothTime time*0.1 и т.п.
    minValue = minValue or 0
    maxValue = maxValue or 1
    percentOverlay = percentOverlay or 0
    oneWay = oneWay or false
    local result = {}
    local animtime = time/((1-percentOverlay+percentOverlay/count)*count)

    if not ld.Math.InBorders( percentOverlay, {0,1} ) then
      ld.LogTrace( "Warning: ld.Anim.Liquid percentOverlay wrong value parameter" );
    end
    for i = 1,count do
      local start = (i-1)*animtime*(1-percentOverlay)
      local midpoint = start+0.5*animtime
      local finish = start+animtime
      --print(string.format("start %s finish %s",start,finish))
      if oneWay then
        if smoothPercent and smoothTime and smoothTime < finish then
          table.insert(result,{0,3,minValue, 0.01+start,3,minValue, finish-smoothTime,3,maxValue+(maxValue-minValue)*smoothPercent, finish,3,maxValue})
        else
          table.insert(result,{0,3,minValue, 0.01+start,3,minValue, finish,3,maxValue})
        end
      else
        table.insert(result,{0,3,minValue, 0.01+start,3,minValue, midpoint,3,maxValue, finish,3,minValue})
      end
    end
    return result
  end
  --------------------------------------------------------------------------------------
  --local at = ld.Anim.SinFadeOut(time, from, to, 20, 0.4, 2) -- example
  --local at = ld.Anim.SinFadeOut(time, from, to, true)
  function public.Anim.SinFadeOut(time, min, max, maxOffset, fadePercent, fadeWawes)
    if maxOffset == true then --autoparams
      maxOffset = math.abs(max - min) * 0.05 --10% перелёт
      fadeWawes = 2
      local coefficient = 0.5
      local wayForChange = maxOffset
      local wayForJiggle = maxOffset*fadeWawes*coefficient
      fadePercent = (time/(wayForJiggle/wayForChange + 1))/time
    end
    local resultTime = {0, time}
    local resultVal = {min, max}
    local linearTime = time*(1-fadePercent)
    local fadeTime = time*fadePercent
    local cosDots = ld.Math.Round( fadeWawes*2 )
    local offsetSign = max>min and 1 or -1
    local function mergeTables()
      local result = {}
      for i,o in ipairs(resultTime) do
        local idx = (i-1)*3+1
        result[idx] = o
        result[idx+1] = 3 
        result[idx+2] = resultVal[i]
      end
      return result
    end
    table.insert(resultTime, 2, linearTime)
    table.insert(resultVal, 2, max+offsetSign*maxOffset)
    if cosDots-1 > 0 then
      local fadeStep = fadeTime/cosDots
      for i = cosDots, 2, -1 do
        local stepTime = fadeStep*(i-1)
        local decreaser = (1-math.pow(stepTime/fadeTime,2))
        local offset = math.cos((i-1)*math.pi)*offsetSign*maxOffset*decreaser
        table.insert(resultTime, 3, linearTime+stepTime)
        table.insert(resultVal, 3, max+offset)        
      end
    end
    return mergeTables()
  end
  --------------------------------------------------------------------------------------
  --возвращает таблицу движения от точки p0 к точке p1 по спиральной траектории
  -- Rot - количество поворотов за полёт ( можно использовать отрицательное значение для контроля направления поворота )
  -- T - время полёта
  -- N - количество точек в таблице

  -- Пример использования - два объекта движутся друг к другу с завихрением вокруг финальной точки 
  --local o1 = ObjGet(private.obj_prev);
  --local o2 = ObjGet(obj);
  --local xmean = (o1.pos_x+o2.pos_x)/2;
  --local ymean = (o1.pos_y+o2.pos_y)/2;
  --local table1 = ld.Anim.Spiral( {o1.pos_x, o1.pos_y}, {xmean, ymean} , 0.5, 0.5, 100);
  --local table2 = ld.Anim.Spiral( {o2.pos_x, o2.pos_y}, {xmean, ymean} , 0.5, 0.5, 100);                
  --ObjAnimate( private.obj_prev, 3, 0, 0, func_end, table1 );
  --ObjAnimate( obj,              3, 0, 0, _,        table2 );
  function public.Anim.Spiral( p0, p1, Rot, T, N )
    Rot = Rot or 1;
    N = N or 20;
    T = T or 1;

    local anm = {};

    local ang0, rmax = ld.Math.AngGip( p0[ 1 ], p0[ 2 ], p1[ 1 ], p1[ 2 ] );

    local phimax = math.pi * 2 * Rot;
    
    local r, phi, x, y, nmn

    for n = 1, ( N + 1 ) do

      nmn = ( n - 1 ) / N 

      r = rmax * ( 1 - nmn );

      phi = ang0 + phimax * nmn;
      x = p1[ 1 ] - r * math.cos( phi );
      y = p1[ 2 ] + r * math.sin( phi );

      table.insert( anm, nmn * T )
      table.insert( anm, 0 )
      table.insert( anm, x )
      table.insert( anm, y )

    end

    return anm

  end

  --------------------------------------------------
  function public.Anim.Vortex(obj, settings, func_end)
    local default_settings = 
    {
      animTime=0.4,
      Rot = 0.5;
      R = 200,
      P = 5,
      start_scale = 0,
      end_scale = 1,
      res = "assets/interface/resources/int_inventory/item_back",
      expand=false,
      straight=false,
      parent=false, 
      animEnd = 2 ,
      ang0=0,
      galactic_root=false,
      galactic_Rot = 4,
      galactic_createroot=true,
      galactic_dir=1,
      galactic_scaleend=0.5,
      galactic_animtime=0.5
    }
    settings = settings or default_settings;

    settings.animTime = settings.animTime or default_settings.animTime      
    settings.Rot = settings.Rot or default_settings.Rot
    settings.R = settings.R or default_settings.R
    settings.P = settings.P or default_settings.P
    settings.start_scale = settings.start_scale or default_settings.start_scale
    settings.end_scale = settings.end_scale or default_settings.end_scale
    settings.res = settings.res or default_settings.res
    settings.expand = settings.expand or default_settings.expand
    settings.straight = settings.straight or default_settings.straight
    settings.parent = settings.parent or default_settings.parent
    settings.animEnd = settings.animEnd or default_settings.animEnd
    settings.ang0 = settings.ang0 or default_settings.ang0
    settings.galactic_root = settings.galactic_root or default_settings.galactic_root
    settings.galactic_Rot = settings.galactic_Rot or default_settings.galactic_Rot
    settings.galactic_createroot = settings.galactic_createroot or default_settings.galactic_createroot
    settings.galactic_dir = settings.galactic_dir or default_settings.galactic_dir
    settings.galactic_animtime = settings.galactic_animtime or settings.animTime
    local xc = 0;
    local yc = 0;
    local z = 100;
     
    local maskname = "spr_vortexmask_"
    if type( obj ) == "table" then
      xc=obj[1];
      yc=obj[2];
    else
      local o = ObjGet(obj);
      if o==nil then
        ld.LogTrace( "Error! obj not exist!",obj );
        return;
      end 
      maskname=obj;
      xc = o.pos_x;
      yc = o.pos_y;
      z=o.pos_z+1;
      if not settings.parent then
        settings.parent = ObjGetRelations( obj ).parent end
    end
    if not settings.parent then
      settings.parent = common.GetCurrentSubRoom() or GetCurrentRoom()
      if interface.GetCurrentComplexInv() ~= "" then
        settings.parent = interface.GetCurrentComplexInv()
      end
    end
    
    if settings.galactic_root and settings.galactic_createroot then
      if ObjGet(settings.galactic_root) then ObjDelete(settings.galactic_root);ObjDelete("tmr_"..settings.galactic_root) end
      ObjCreate(settings.galactic_root,"obj")
      ObjAttach(settings.galactic_root,settings.parent)
      ObjSet( settings.galactic_root, {pos_x=xc,pos_y=yc,pos_z=100} );
    end
    if settings.galactic_createroot then
      if ObjGet( "tmr_"..settings.galactic_root) then return end
    end
    for p=1,settings.P do
      local parthost = maskname.."_vortex_"..p;
      local oo = ObjGet(parthost)
      if not oo then
        ObjCreate(parthost,"spr"); 
      else
        ld.LogTrace( "Error! double run of ld.Anim.Vortex"  );
        break;
        ObjDelete("tmr_"..parthost)
      end
      if ObjGet("tmr_"..parthost) then ld.LogTrace( "Error! double run of ld.Anim.Vortex"  );break end
      
      local parent = settings.parent
      if settings.galactic_root then
         parent = settings.galactic_root; 
      end
      ObjAttach(parthost,parent)       
      local ang = settings.ang0 + 2*math.pi*(p-1)/(settings.P);
      local x = xc + settings.R*math.cos( ang );
      local y = yc + settings.R*math.sin( ang );
      
      local x_start = settings.expand and xc or x
      local y_start = settings.expand and yc or y
      local x_end   = settings.expand and x or xc
      local y_end   = settings.expand and y or yc
      if settings.galactic_root then
          x_start=x_start-xc
          y_start=y_start-yc
          x_end=x_end-xc
          y_end=y_end-yc
      end
      ObjSet( parthost, {pos_x = x, pos_y = y, pos_z=z,  res = settings.res, input=0,visible=0} );
      
      local anm = {};
      if settings.straight then
        anm = {0,0, x_start,y_start,  settings.animTime,0,x_end,y_end }
      else
        anm = ld.Anim.Spiral( {x_start,y_start}, {x_end,y_end}, settings.Rot, settings.animTime )
      end
      ObjAnimate( parthost, 3, 0, 0, _,   anm  );
      ObjAnimate( parthost, 6, 0, 0, _, {0,0,settings.start_scale,settings.start_scale,   settings.animTime,0,settings.end_scale,settings.end_scale} );
      ObjDelete("fx_item_name_collectblick_"..parthost)
      ld.FxBlickAnmObj(parthost)
      ld.StartTimer( "tmr_"..parthost, settings.animEnd, function() ObjDelete(parthost) end )
    end
    if settings.galactic_root then
      ObjAnimate( settings.galactic_root, 7, 0, 0, _, {0,0,0,   settings.galactic_animtime,0,settings.galactic_Rot*math.pi*2*settings.galactic_dir} );
      ObjAnimate( settings.galactic_root, 6, 0, 0, _, {0,0,1,1, settings.galactic_animtime,2,settings.galactic_scaleend,settings.galactic_scaleend} );
      ld.StartTimer( "tmr_"..settings.galactic_root, settings.animEnd, function() ObjDelete(settings.galactic_root) end )
    end
    
    
    ld.StartTimer( settings.animTime, 
      function()  
        if func_end then func_end() end
      end )
  end
  
  --------------------------------------------------------------------------------------
  function public.Anim.SwitchByAlpha(obj1, obj2, time, extrapolation)  
    time = time or 0.5
    extrapolation = extrapolation == nil and true or false
    ObjAnimate( obj1, 8, 0, 0, function() end, {0,0,1, time,extrapolation and 1 or 0,0} );
    ObjAnimate( obj2, 8, 0, 0, function() end, {0,0,0, time,extrapolation and 2 or 0,1} );
  end
  --------------------------------------------------------------------------------------
  function public.Anim.ObjLevitationStart( obj, config, notRandom )
    private.ObjLevitation_cache = private.ObjLevitation_cache or {}
    if not config then
      config = {
        pos_x = { t_min = 3.5; t_max = 5.5; delta_min = 2.0; delta_max = 4.0; };
        pos_y = { t_min = 4.0; t_max = 6.0; delta_min = 2.0; delta_max = 4.0; };
        ang   = { t_min = 4.5; t_max = 6.5; delta_min = 0.02; delta_max = 0.04; };
      }
    end
    private.ObjLevitation_cache[ obj ] = config
    for k, v in pairs( config ) do
      public.Anim.ObjLevitation( obj, k, v, not notRandom )
    end
  end

  function public.Anim.ObjLevitationStop( obj )
    if not private.ObjLevitation_cache then 
      return 
    end
    local config = private.ObjLevitation_cache[ obj ]
    if config then
      for k, v in pairs( config ) do
        ObjStopAnimate( obj, k )
      end
      private.ObjLevitation_cache[ obj ] = nil
      return true
    else
      return false
    end
  end
  function public.Anim.ObjLevitation( obj, anim_type, config, random_step )
    if not private.ObjLevitation_cache and not private.ObjLevitation_cache[ obj ] then 
      return 
    end
    if anim_type == "scale" then
      public.Anim.ObjLevitation( obj, "scale_x", config, random_step )
      public.Anim.ObjLevitation( obj, "scale_y", config, random_step )
      return;
    end
    local o = ObjGet( obj )
    if o then
      local t_anim = config.t_min + ( config.t_max - config.t_min ) * math.random()
      local delta_anim = config.delta_min + ( config.delta_max - config.delta_min ) * math.random()
      local anm = {
        0,0,o[ anim_type ];
        t_anim*0.25,2,o[ anim_type ]+delta_anim; 
        t_anim*0.50,1,o[ anim_type ];
        t_anim*0.75,2,o[ anim_type ]-delta_anim;
        t_anim,1,o[ anim_type ];
      }
      -->> сеим хаос
      if random_step then
        local step = math.random( 1, 4 )
        for i = 1, step - 1 do
          table.remove( anm, 1 )
          table.remove( anm, 1 )
          table.remove( anm, 1 )
        end
        for i = 0, step - 1 do
          anm[ 1 + i * 3 ] = i * 0.25 * t_anim
        end
        local set = {}
        set[ anim_type ] = anm[ 3 ]
        ObjSet( obj, set )
      end
      --<< сеим хаос
      ObjAnimate( o.name, anim_type,0,0, function()
        public.Anim.ObjLevitation( obj, anim_type, config );
      end, anm )
    end
  end;
--------------------------------------------------------------------------------------
-- имитирует падение объекта ( в "слот" или из "слота" )
-- v_x - начальная скорость объекта по оси Х
-- v_y - начальная скорость объекта по оси У
-- v_a - начальная угловая скорость объекта
-- g - "гравитация"
-- y_max - максимальное значение по у, до которого будут производится рассчёты
-- y_min - минимальное значение по у, до которого будут производится рассчёты
-- scale - скейл, до которого увеличется объект
-- reverse - если истинно, анимация будет построена наоборот
-- pause - задержка падения
-- func_end - будет вызвано в конце анимации
  function public.Anim.ObjDrop( obj, params )
    params = params or {};
    local vx = params.v_x or math.random(-40,40);
    local vy = params.v_y or math.random(-80,-40)
    local va = params.v_a or math.random()*0.75
    local g = params.g or 40
    params.y_max = params.y_max or 1000
    params.y_min = params.y_min or -1000
    params.scale = params.scale or 1.1
    params.reverse = params.reverse or false

    params.pause = params.pause or 0
    params.func_end = params.func_end or function()  end;

    if params.reverse then
      g = - g
    end
    local y_max = params.y_max
    local y_min = params.y_min
    local sc = params.scale

    vx = vx * 0.1
    vy = vy * 0.1
    g = g * 0.1

    local o = ObjGet( obj )

    local func_end = params.func_end

    local ts = 0.05
    local t = params.pause
    local y = o.pos_y
    local x = o.pos_x
    local anm = {}

    if t > 0 then
      table.insert( anm, 0 )
      table.insert( anm, 0 )
      table.insert( anm, x )
      table.insert( anm, y )
    end

      table.insert( anm, t )
      table.insert( anm, 0 )
      table.insert( anm, x )
      table.insert( anm, y )

    repeat
      x = x + vx
      y = y + vy
      vy = vy + g
      t = t + ts
      table.insert( anm, t )
      table.insert( anm, 0 )
      table.insert( anm, x )
      table.insert( anm, y )
    until ( ( y < y_min ) or ( y > y_max ) )

    local pos_x_beg = o.pos_x
    local pos_y_beg = o.pos_y
    local pos_x_end = x
    local pos_y_end = y

    local scale_x_beg = o.scale_x
    local scale_y_beg = o.scale_y
    local scale_x_end = math.abs( o.scale_x ) == o.scale_x and sc or ( -sc )
    local scale_y_end = math.abs( o.scale_y ) == o.scale_y and sc or ( -sc )

    local ang_beg = o.ang
    local ang_end = o.ang + va * ( math.random( 0, 1 ) == 0 and 1 or -1 )

    if params.reverse then
      pos_x_beg, pos_y_beg, pos_x_end, pos_y_end = pos_x_end, pos_y_end, pos_x_beg, pos_y_beg
      scale_x_beg, scale_y_beg, scale_x_end, scale_y_end = scale_x_end, scale_y_end, scale_x_beg, scale_y_beg
      ang_beg, ang_end = ang_end, ang_beg

      local anm_reverse = {}
      local count = #anm
      local steps = #anm / 4 - 1
    
      local step
      for i = 0, steps do
        step = i * 4
        anm_reverse[ step + 1 ] = anm[ step + 1 ]
        anm_reverse[ step + 2 ] = anm[ step + 2 ]
        anm_reverse[ step + 3 ] = anm[ count - step - 1 ]
        anm_reverse[ step + 4 ] = anm[ count - step ]
      end

      anm = anm_reverse
    end

    ObjAnimate( o.name, 6,0,0, _, {
      0, 0, scale_x_beg, scale_y_beg;
      params.pause, 0, scale_x_beg, scale_y_beg;
      params.pause + 0.4, 2, scale_x_end, scale_y_end;
    } )
    ObjAnimate( o.name, 7,0,0, _, { 
      0, 0, ang_beg;
      params.pause, 0, ang_beg;
      t, 2, ang_end;
    } )

    ObjAnimate( o.name, 3,0,0, _, anm )
    ld.StartTimer( "tmr_common_impl_anim_objdrop_"..o.name, t, function()
      ObjStopAnimate(o.name,3)
      ObjStopAnimate(o.name,6)
      ObjStopAnimate(o.name,7)
      ObjSet( o.name, { 
        pos_x = pos_x_end;
        pos_y = pos_y_end;
        scale_x = scale_x_end;
        scale_y = scale_y_end;
        ang = ang_end;
      } ) 
      func_end()
    end )

  end;
--------------------------------------------------------------------------------------
-- имитирует падение объектов
-- objs - список объектов
-- func_end - функция будет вызвана после окончания всех анимаций
-- t_step_wait - пауза между падениями объектов ( по умолчанию 0 )
-- params - параметры имитации падения ( по умолчанию стандартные значения )
  function public.Anim.ObjsDrop( objs, func_end, t_step_wait, params )
    params = params or {}
    t_step_wait = t_step_wait or 0
    local func_callbacks = #objs + 1
    local func_callback = function()
      func_callbacks = func_callbacks - 1
      if func_callbacks == 0 and func_end then
        func_end()
      end
    end
    if params.func_end then
      local func_step = params.func_end
      params.func_end = function() 
        func_step()
        func_callback()
      end
    else
      params.func_end = func_callback
    end
    local t = 0
    for i = 1, #objs do
      t = t + t_step_wait
      params.pause = t;
      ld.Anim.ObjDrop( objs[ i ], params )
    end
    ld.StartTimer( t, func_callback )
  end
--------------------------------------------------------------------------------------
-- имитирует падение объектов "волной"
-- objs - список объектов
-- wave_x - pos_x начала волны
-- wave_y - pos_y начала волны
-- func_end - функция будет вызвана после окончания всех анимаций
-- wave_speed - скорость распростронения волны
-- params - параметры имитации падения ( по умолчанию стандартные значения )
  function public.Anim.ObjsDropWave( objs, wave_x, wave_y, func_end, wave_speed, params )
    wave_x = wave_x or 512
    wave_y = wave_y or 384
    wave_speed = wave_speed or 1000
    params = params or {}
    local func_callbacks = #objs + 1
    local func_callback = function()
      func_callbacks = func_callbacks - 1
      if func_callbacks == 0 and func_end then
        func_end()
      end
    end
    if params.func_end then
      local func_step = params.func_end
      params.func_end = function() 
        func_step()
        func_callback()
      end
    else
      params.func_end = func_callback
    end
    local t = 0
    local o
    for i = 1, #objs do
      o = ObjGet( objs[ i ] )
      t = ld.Math.Len( wave_x, wave_y, o.pos_x, o.pos_y ) / wave_speed
      params.pause = t;
      ld.Anim.ObjDrop( objs[ i ], params )
    end
    ld.StartTimer( t, func_callback )
  end
--------------------------------------------------------------------------------------
  --анимация скейла из текущего скейла
  -- obj - анимируемы объект
  -- scale - скейл объекта на конец анимации
  -- func_end - запустится по окончании анимации
  -- t - время анимации, по умоляанию 1 еденица скейла в секунду
  -- interpolation - интерполяция анимации, по умолчанию 2
  -- возвращает time анимации
  function public.Anim.Scale( obj, scale, func_end, t, interpolation )
    interpolation = interpolation or 2
    local o = ObjGet( obj )
    t = t or math.abs( o.scale_x - scale )
    ObjAnimate( o.name, 6,0,0, func_end, { 
      0, 0, o.scale_x, o.scale_y, 
      t, interpolation, scale, scale 
    } )
    return t
  end
--------------------------------------------------------------------------------------
  --анимация скейла X из текущего скейла
  -- obj - анимируемы объект
  -- scale - скейл объекта на конец анимации
  -- func_end - запустится по окончании анимации
  -- t - время анимации, по умоляанию 1 еденица скейла в секунду
  -- interpolation - интерполяция анимации, по умолчанию 2
  -- возвращает time анимации
  function public.Anim.ScaleX( obj, scale, func_end, t, interpolation )
    interpolation = interpolation or 2
    local o = ObjGet( obj )
    t = t or math.abs( o.scale_x - scale )
    --ld.LogTrace( "ScaleX", o.scale_x, scale, t )
    ObjAnimate( o.name, 4,0,0, func_end, { 
      0, 0, o.scale_x,
      t, interpolation, scale,
    } )
    return t
  end
--------------------------------------------------------------------------------------
  --анимация скейла Y из текущего скейла
  -- obj - анимируемы объект
  -- scale - скейл объекта на конец анимации
  -- func_end - запустится по окончании анимации
  -- t - время анимации, по умоляанию 1 еденица скейла в секунду
  -- interpolation - интерполяция анимации, по умолчанию 2
  -- возвращает time анимации
  function public.Anim.ScaleY( obj, scale, func_end, t, interpolation )
    interpolation = interpolation or 2
    local o = ObjGet( obj )
    t = t or math.abs( o.scale_y - scale )
    --ld.LogTrace( "ScaleY", o.scale_y, scale, t )
    ObjAnimate( o.name, 5,0,0, func_end, { 
      0, 0, o.scale_y,
      t, interpolation, scale,
    } )
    return t
  end
--------------------------------------------------------------------------------------
  --анимация скейла XY из текущего скейла
  -- obj - анимируемы объект
  -- scale_x - скейл объекта по x на конец анимации
  -- scale_y - скейл объекта по y на конец анимации
  -- func_end - запустится по окончании анимации
  -- t - время анимации, по умоляанию 1 еденица скейла в секунду (берётся максимальное время для scale_x scale_y)
  -- interpolation - интерполяция анимации, по умолчанию 2
  -- возвращает time анимации
  function public.Anim.ScaleXY( obj, scale_x, scale_y, func_end, t, interpolation )
    interpolation = interpolation or 2
    local o = ObjGet( obj )
    if not t then
      local tx = math.abs( o.scale_x - scale_x )
      local ty = math.abs( o.scale_y - scale_y )
      t = math.max( tx, ty )
    end
    --ld.LogTrace( "ScaleY", o.scale_y, scale, t )
    ObjAnimate( o.name, 6,0,0, func_end, { 
      0, 0, o.scale_x, o.scale_y,
      t, interpolation, scale_x, scale_y
    } )
    return t
  end
--------------------------------------------------------------------------------------
  --анимация скейла из текущего скейла до scale и обратно
  -- objs - анимируемые объект
  -- scale - скейл объекта, до которого он будет анимироваться
  -- func_end - запустится по окончании анимации
  -- params - параметры анимации
  -- params.t_anim - время анимации одного объекта
  -- params.t_step - время ожидания до начала анимации следуещего объекта
  -- params.t_half - время "середины" анимации объекта
  -- params.interpolation_beg - тип интерполяции начала анимации
  -- params.interpolation_end - тип интерполяции конца анимации
  -- возвращает время анимации
  function public.Anim.ScaleWave( objs, scale, func_end, params )
    params = params or {}
    params.t_anim = params.t_anim or 0.4
    params.t_step = params.t_step or 0.075
    params.t_half = params.t_half or params.t_anim / 2
    params.interpolation_beg = params.interpolation_beg or 3
    params.interpolation_end = params.interpolation_end or 3
    local t = 0
    local o
    for i = 1, #objs do
      o = ObjGet( objs[ i ] )
      if o then
        ObjAnimate( o.name, 6,0,0, nil, { 
          0, 0, o.scale_x, o.scale_y; 
          t, 0, o.scale_x, o.scale_y;
          t + params.t_half, params.interpolation_beg, scale, scale;
          t + params.t_anim, params.interpolation_end, params.scale_x_end or o.scale_x, params.scale_y_end or o.scale_y;
        } )
      end
      if params.sound then
        ld.StartTimer( t, function() SoundSfx(params.sound) end )  
      end
      t = t + params.t_step
    end
    t = t + params.t_anim
    ld.StartTimer( t, func_end )
    return t
  end
--------------------------------------------------------------------------------------
  --анимация альфы из текущей альфы в alp_max либо 0 ( bool >> true or false )
  --за время time на полный цикл от 0 до alp_max
  -- если текущая альфа = alp_max/2, то время будет = time/2
  -- по окончанию анимации запустится func_end
  -- func_end можно передать вместо alp_max или time
  -- возвращает time анимации
  function public.Anim.Light( obj, bool, alp_max, time, func_end )
    if type( alp_max ) == "function" then
      func_end = alp_max;
      alp_max = nil;
    elseif type( time ) == "function" then
      func_end = time;
      time = nil;
    end
    local o = ObjGet( obj )
    if not o then return end;
    alp_max = alp_max or 1
    time = time or 0.3
    local t = 1
    if bool then
      t = math.abs( alp_max - o.alp ) * time * ( 1 / alp_max )
      ObjAnimate( o.name, 8,0,0, func_end, { 
        0, 0, o.alp, 
        t, 2, alp_max 
      } )
    else
      t = o.alp * time * ( 1 / alp_max )
      ObjAnimate( o.name, 8,0,0, func_end, { 
        0, 0, o.alp,
        t, 2, 0
      } )
    end
    return t
  end
--------------------------------------------------------------------------------------
  --анимация альфы из текущей альфы в alp_max либо 0 ( bool >> true or false )
  --за время time на полный цикл от 0 до alp_max
  -- если текущая альфа = alp_max/2, то время будет = time/2
  -- по окончанию анимации запустится func_end
  -- func_end можно передать вместо alp_max или time
  function public.Anim.ObjsLight( objs, bool, func_end, t_step_wait, alp_max, time )
    t_step_wait = t_step_wait or 0
    local func_callbacks = #objs + 1
    local func_callback = function()
      func_callbacks = func_callbacks - 1
      if func_callbacks == 0 and func_end then
        func_end()
      end
    end
    local t = 0
    for i = 1, #objs do
      ld.StartTimer( t, function() ld.Anim.Light( objs[ i ], bool, alp_max, time, func_callback ) end )
      t = t + t_step_wait
    end
    ld.StartTimer( t, func_callback )
  end
--------------------------------------------------------------------------------------
  --анимация альфы из текущей альфы в alp_mid затем в alp_end
  function public.Anim.LightBlink( obj, func_end )
    public.Anim.Light( obj, true, function()
      public.Anim.Light( obj, false, func_end )
    end )
  end
--------------------------------------------------------------------------------------
  --анимация альфы из текущей альфы в alp_max либо 0 ( bool >> true or false )
  --за время time на полный цикл от 0 до alp_max
  -- если текущая альфа = alp_max/2, то время будет = time/2
  -- по окончанию анимации запустится func_end
  -- func_end можно передать вместо alp_max или time
  -- возвращает time анимации
  function public.Anim.ObjsLightWave( objs, bool, wave_x, wave_y, func_end, alp_max, time, wave_speed )
    wave_speed = wave_speed or 1000
    local func_callbacks = #objs + 1
    local func_callback = function()
      func_callbacks = func_callbacks - 1
      if func_callbacks == 0 and func_end then
        func_end()
      end
    end
    local t = 0
    local pos
    for i = 1, #objs do
      pos = GetObjPosByObj( objs[ i ] )
      t = ld.Math.Len( wave_x, wave_y, pos[ 1 ], pos[ 2 ] ) / wave_speed
      ld.StartTimer( t, function() public.Anim.Light( objs[ i ], bool, alp_max, time, func_callback ) end )
    end
    ld.StartTimer( t, func_callback )
    return time
  end
--------------------------------------------------------------------------------------
  --анимация цвета из текущего в params.max или params.min
  function public.Anim.Color( obj, bool_to_max, func_end, params )

    local o = ObjGet( obj )
    if not o then return end;

    params = params or {}
    params.min    = params.min or 0.35
    params.max    = params.max or 1.00
    params.t      = params.t   or 0.35
    
    local t_scale = 1 / ( math.abs( params.max - params.min ) )
    local color_now = ( o.color_r + o.color_g + o.color_b ) / 3
    local color_end = bool_to_max and bool_to_max and params.max or params.min
    local t = math.abs( color_end - color_now ) * params.t * t_scale

    ObjAnimate( o.name, 12,0,0, func_end, { 
      0, 0, o.color_r, o.color_g, o.color_b,
      t, 2, color_end, color_end, color_end 
    } )

    return t, color_end

  end
--------------------------------------------------------------------------------------
  function public.Anim.Fly( obj, params )
    params = params or {}
    params.speed = params.speed or 2000;
    params.speed_pow = params.speed_pow or 0.5;
    params.interpolation = params.interpolation or 2;
    params.pause = params.pause or 0;
    params.interpolation_x = params.interpolation_rnd and math.random( 0, 3 ) or params.interpolation_x
    params.interpolation_y = params.interpolation_rnd and math.random( 0, 3 ) or params.interpolation_y
    local o = ObjGet( obj )
    local t 
    if params.t then
      t  = params.t
    else
      t = ld.Math.Len( o.pos_x, o.pos_y, params.pos_x, params.pos_y )
      t = ( t / params.speed ) ^ params.speed_pow
    end
    --ld.LogTrace( obj, o.pos_x, o.pos_y, t, params )
    if params.interpolation_x or params.interpolation_y then
      ObjAnimate( o.name, 0,0,0, nil, { 
        0, 0, o.pos_x;
        params.pause, 0, o.pos_x;
        params.pause + t, params.interpolation_x, params.pos_x;
      } )
      ObjAnimate( o.name, 1,0,0, params.func_end, { 
        0, 0, o.pos_y;
        params.pause, 0, o.pos_y;
        params.pause + t, params.interpolation_y, params.pos_y;
      } )
    else
      ObjAnimate( o.name, 3,0,0, params.func_end, { 
        0, 0, o.pos_x, o.pos_y;
        params.pause, 0, o.pos_x, o.pos_y;
        params.pause + t, params.interpolation, params.pos_x, params.pos_y;
      } )
    end
    return t
  end
--------------------------------------------------------------------------------------  
    function public.Anim.FlyStarMode(obj,target,custom_params)
    ---- 
    local params;
    local params0 ={func_end = function()  end, isClearTarget=true}
    if not custom_params then
      params = params0
    else
      if type(custom_params)=="table" then
        params = custom_params;
      elseif type(custom_params)=="function" then
        params = params0
        params.func_end = custom_params;
      else
        params = params0
      end;
    end;
    local func_end = function() 
      if type(target)=="string" and params.isClearTarget then
        local T3 = 0.4
        ObjAnimate( target, 8, 0, 0, function() 
          if params.func_end then
            params.func_end()
          end
          end, {0,0,1,    T3,1,0} );
        ObjAnimate( target, 6, 0, 0, function() end, {0,0,1,1,  T3,1,0,0} );
      else
        if params.func_end then
          params.func_end()
        end
      end; 
    end
    ----- 
    local root = params.root or InterfaceWidget_Top_Name
    local pos_1 = GetObjPosByObj(obj,params.root)
    local pos_2 = type(target)=="string" and GetObjPosByObj(target,params.root) or target

    local T1 = 0.3
    ObjAnimate( obj, 6, 0, 0, _, {0,0,1,1,   T1,0,0,0} );
    ObjAttach(obj,root)
    ObjSet( obj, {pos_z=666, pos_x = pos_1[1], pos_y=pos_1[2], input=false} );
  
    local star = obj.."_star";
    ObjCreate(star,"spr")
    ObjSet( star, {res = "assets/levels/common/fx/sparkle_2", pos_z=666, pos_x = pos_1[1], pos_y = pos_1[2]} );
    ObjAttach(star,root)
    ObjAnimate( star, 8, 0, 0, function() end, {0,0,0,     T1,0,1} );
    ObjAnimate( star, 6, 0, 0, function()
      
      local T2  = 0.35
      ld.FxBlickAnmObj(star);
      ObjAnimate( star, 3, 0, 0, func_end, {
        0,  0, pos_1[1], pos_1[2],
        T2, 1, pos_2[1], pos_2[2]} );
      
      ObjAnimate( star, 6, 0, 0, function() end, {0,0,1,1,   T2*0.85,0,1,1,     T2,0,0,0} );
      ObjAnimate( star, 7, 0, 0, function() end, {0,0,0,     T2,0,math.pi*4} );
      
    end, {0,0,0,0,  T1*0.65,0,2,2,   T1,0,1,1} );
  end;
--------------------------------------------------------------------------------------
  -- obj - анимируемый объект
  -- ang_end - конечный угол
  -- func_end -- калбэк
  -- params - параметры анимации
  -- params.speed - скорость анимации ( радиан в секунду, по умолчанию 10 )
  -- params.speed_pow - сила сгаживания скорости анимации ( по умолчанию 0.75  )
  -- params.interpolation - интерполяция анимации ( по умолчанию 3 )
  -- params.t - если указано, игнорирует speed и speed_pow
  function public.Anim.AngNorm( obj, ang_end, func_end, params )
    params = params or {}
    params.speed = params.speed or 8
    params.speed_pow = params.speed_pow or 0.75
    params.interpolation = params.interpolation or 3
    ang_end = ld.Math.AngNorm( ang_end )
    private._o = ObjGet( obj )
    local ang_beg = ld.Math.AngCloser( ld.Math.AngNorm( private._o.ang ), ang_end )
    local t = params.t or math.pow( math.abs( ang_end - ang_beg ) / params.speed, params.speed_pow )
    ObjAnimate( obj, 7,0,0, func_end, { 0,0,ang_beg, t,params.interpolation,ang_end } )
    return t
  end
--------------------------------------------------------------------------------------
  -- obj - анимируемый объект
  -- ang_end - конечный угол
  -- func_end -- калбэк
  -- params - параметры анимации
  -- params.speed - скорость анимации ( радиан в секунду, по умолчанию 10 )
  -- params.speed_pow - сила сгаживания скорости анимации ( по умолчанию 0.75  )
  -- params.interpolation - интерполяция анимации ( по умолчанию 3 )
  -- params.t - если указано, игнорирует speed и speed_pow
  function public.Anim.AngNormWave( objs, ang_end, wave_x, wave_y, func_end, wave_speed, params  )
    local func_callbacks = #objs + 1
    local func_callback = function()
      func_callbacks = func_callbacks - 1
      if func_callbacks == 0 and func_end then
        func_end()
      end
    end
    local t = 0
    local pos
    for i = 1, #objs do
      pos = GetObjPosByObj( objs[ i ] )
      t = ld.Math.Len( wave_x, wave_y, pos[ 1 ], pos[ 2 ] ) / wave_speed
      ld.StartTimer( t, function() public.Anim.AngNorm( objs[ i ], ang_end, func_callback, params ) end )
    end
    ld.StartTimer( t, func_callback )
  end
--------------------------------------------------------------------------------------
  -- obj - анимируемый объект
  -- path - массив координат точек пути { { x1; y1;}; { x2; y2;}; ... } (PngToPath умеет обрабатывать путь из png картинки)
  -- speed - скорость анимации (пикселей в секунду)
  -- func_end -- калбэк
  -- func_step -- калбэк на старт каждого участка пути, передаёт параметр - номер шага
  function public.Anim.ObjPath( obj, path, speed, func_end, ang_t, func_step, step )
    step = step or 2
    --if func_step then
    --  func_step( step )
    --end
    if step > #path then
      if func_end then
        func_end()
      end
      return
    end
    private._p1 = path[ step - 1 ]
    private._p2 = path[ step ]
    private._l = ld.Math.Len( private._p1[ 1 ], private._p1[ 2 ], private._p2[ 1 ], private._p2[ 2 ] )
    private._t = private._l / speed
    if ang_t then
      private._a , private._l  = ld.Math.AngGip( private._p1[ 1 ], private._p1[ 2 ], private._p2[ 1 ], private._p2[ 2 ], private._l )
      local t = ang_t and ( ang_t < private._t and ang_t ) or private._t
      ld.Anim.AngNorm( obj, private._a, nil, { t = t } )
    end
    if func_step then
      func_step( step - 1 )
    end
    ObjAnimate( obj, 3,0,0, function()
      public.Anim.ObjPath( obj, path, speed, func_end, ang_t, func_step, step + 1 )
    end, {
      0, 0, private._p1[ 1 ], private._p1[ 2 ];
      private._t, 0, private._p2[ 1 ], private._p2[ 2 ];
    } )
  end
--------------------------------------------------------------------------------------
  --проигрывает анимацию и показвает ббт по окончанию
  function public.Anim.Need( anim_obj, anim_func, bbt_need , sfx )
    ld.Lock( 1 )
    ld.AnimPlay( 
    anim_obj or "", 
    anim_func or "", 
    function() 
      if bbt_need then
        if type( bbt_need ) == "function" then
          bbt_need()
        elseif type( bbt_need ) == "string" then
          ld.ShowBbt( bbt_need )
        end
      end
      ld.Lock( 0 )
    end, 
    sfx )
  end
--------------------------------------------------------------------------------------
  function public.Anim.Need_Simple( obj, bbt_need , sfx, anim_info, func_end )
    ld.Lock(1);
    local T  = 0.4
    local anim_type = "pos_y"
    local value0 = 0;
    local dvalue = 10
    
    if not anim_info then
      anim_info = {0,0,value0,  T/2,0,value0 - dvalue,  T,0,value0}
    else
      local not_table = false
      if anim_info.anim_type then
        anim_type = anim_info.anim_type
        anim_info.anim_type=nil
      end;
      if anim_info.T then
        T = anim_info.T
        anim_info.T=nil
      end;
      if anim_info.value0 then
        value0 = anim_info.value0
        anim_info.value0=nil
      end;
      if anim_info.dvalue then
        dvalue = anim_info.dvalue
        anim_info.dvalue=nil
      end;
      if #anim_info==0 then anim_info=nil end
    end
    
    anim_info = anim_info or {0,0,value0,  T/2,0,value0 - dvalue,  T,0,value0}
    
    ObjAnimate( obj, anim_type, 0, 0, 
    function() 
      if bbt_need then ld.ShowBbt(bbt_need); end
      if func_end then 
        if type(func_end)=="function" then 
          func_end() 
        end 
      end
      ld.Lock(0) 
    end, anim_info );
    if sfx then SoundSfx( sfx ) end
  end;
--------------------------------------------------------------------------------------
  --проигрывает анимацию если она не проигрывается и запускает звук при указании
  function public.Anim.PlayCheck( anim_obj, anim_func, sfx )
    if not ObjGet( anim_obj ).playing then
      if sfx then
        SoundSfx( sfx );
      end
      ld.AnimPlay( anim_obj, anim_func, nil )
    end
  end
--------------------------------------------------------------------------------------
--Играющую анимацию статики прервать показом анимации потом снова запустить ту статику(для холостого хода)
  function public.Anim.PlayFromStatic( obj, anmfunc_play, anmfunc_after, func_after, donotlock )
    if not donotlock then ld.Lock(1); end
    ld.AnimPlay( obj, anmfunc_play,
      function()
        ld.AnimPlay( obj, anmfunc_after, nil )
        if func_after then func_after() end
        if not donotlock then ld.Lock(0); end
      end
    )
  end
--------------------------------------------------------------------------------------
--проиграть видео в зумзоне с переключением по альфе, с аттачем и ожиданием подгрузки
  function public.Anim.PlayVid( vid, attachTo, func_end, hided, sfx, hidedTime, func_on_load )

    if ObjGetRelations( vid ).parent ~= attachTo then
      ObjSet( vid, {visible = 0} );
      ObjAttach( vid, attachTo )
    end

    ObjAnimate( vid, 7, 0, 0, function() 
      ObjSet( vid, {visible = 1} );
      VidPlay( vid, func_end or "" )

      if func_on_load then
        func_on_load()
      end

      if hided then
        ObjSet( vid, {alp = 0} );
        ld.Anim.SwitchByAlpha( hided, vid, hidedTime or 0.3)
      end

      if sfx then 
        SoundSfx( sfx ) 
      end
    end, {0,0,0} );

  end
--------------------------------------------------------------------------------------
  function public.Anim.ReTag(anim, prefix)
    if type(anim) == "table" then
      for i,o in ipairs(anim) do
        public.Anim.ReTag(o, prefix)
      end
      return
    end
    local childs = ObjGetRelations( anim ).childs
    local playing = ObjGet(anim).playing
    ObjSet( anim, {input = 1, playing = 0} );

    for i,o in ipairs(childs) do
      local newroot, replaces = o:gsub("^spr_",prefix or "obj_")
      if replaces == 1 then
        --local tag = ObjGet(o).anim_tag
        local tag = ObjGet(o).res:match("[^//]+$") -- взять имя ресурса
        --ld.LogTrace( tag, tag_res, tag == tag_res );
        ObjCreate(newroot,"obj")
        ObjAttach(newroot,anim)
        ObjAttach(o,newroot)
        ObjSet( newroot, {anim_tag = tag, pos_x = 0, pos_y = 0} );
        ObjSet( o, {anim_tag = "", pos_x = 0, pos_y = 0})
      end
    end
    ObjSet( anim, {playing = playing} );
  end
--Частица исчезновения предмета
  --------------------------------------------------------------------------------------
  function public.Anim.FxFind( object_name, params  )
    params = params or {}      
    params.res = params.res or "assets/interface/resources/fx/effects_ho"

    private.FxFindPool = private.FxFindPool or ld.Pool.New( "FxFind" )
    if not private.FxFindPool.objs[ object_name ] then
      private.FxFindPool.obj_new( object_name, "partsys", InterfaceWidget_Top_Name, {
        res = params.res;
        input = 0;
        pos_z = 10;
      } )      
    end
    local collect_pos = GetObjPosByObj( object_name, InterfaceWidget_Top_Name );
    --если в имени объекта на 2 позиции присутствует имя существующего ИП
    local locName = ld.String.Divide(object_name)[2]
    local offsetForDeploy = ObjGet("inv_complex_"..locName) and {512,384} or {0,0}
    local o = ObjGet( object_name )
    local collect_name = private.FxFindPool.obj_get( object_name, 5 )
    PartSysRestart( collect_name )
    ObjSet( collect_name,
    {
      pos_x = o.drawoff_x + offsetForDeploy[1];
      pos_y = o.drawoff_y + offsetForDeploy[2],
    } );
    PartSysSetMaskObj( collect_name, object_name );  
  end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--function Debug()  end
public.Debug = {}
public.Debag = public.Debug
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  function public.Debag.Line( name, pos_x1, pos_y1, pos_x2, pos_y2, t, r, g, b )
    if not public.IsLdCheater() then return end
    t = t or 1
    local place = public.GetCurrentPlace()
    local obj = "spr_common_impl_debag_line_"..place.."_"..name
    if not ObjGet( obj ) then
      ObjCreate( obj, "spr" )
      ObjSet( obj, { input = 0; pos_z = 99; scale_y = 2; drawoff_x = 1; res = "assets/shared/cheater/editor_back"; } )
      ObjAttach( obj, place ) 
    end
    local ang, gip = ld.Math.AngGip( pos_x1, pos_y1, pos_x2, pos_y2 )
    ObjSet( obj, {
      pos_x = pos_x1;
      pos_y = pos_y1;
      ang = ang;
      scale_x = gip / 2;
      color_r = r or 1;
      color_g = g or 1;
      color_b = b or 1;
    } )
    ObjAnimate( obj, 8, 0, 0, function() ObjDelete( obj ) end, { 0, 0, 1, t, 1, 1, t + 0.25, 1, 0 } )
  end
  function public.Debag.Dot( name, pos_x, pos_y, t, r, g, b )
    if not public.IsLdCheater() then return end
    t = t or 1
    local place = public.GetCurrentPlace()
    local obj = "spr_common_impl_debag_dot_"..place.."_"..name
    if not ObjGet( obj ) then
      ObjCreate( obj, "spr" )
      ObjSet( obj, { input = 0; pos_z = 99; scale_x = 2; scale_y = 2; res = "assets/shared/cheater/editor_back"; } )
      ObjAttach( obj, place ) 
    end
    ObjSet( obj, {
      pos_x = pos_x;
      pos_y = pos_y;
      color_r = r or 1;
      color_g = g or 1;
      color_b = b or 1;
    } )
    ObjAnimate( obj, 8, 0, 0, function() ObjDelete( obj ) end, { 0, 0, 1, t, 1, 1, t + 0.25, 1, 0 } )
  end
  function public.Debag.Text( name, pos_x, pos_y, text, t, r, g, b )
    if not public.IsLdCheater() then return end
    t = t or 1
    local place = public.GetCurrentPlace()
    local obj = "txt_common_impl_debag_text_"..place.."_"..name
    if not ObjGet( obj ) then
      ObjCreate( obj, "text" )
      ObjSet( obj, { 
        input = 0;
        pos_z = 99;
        res = "assets/shared/cheater/arial";
        disprawtext = true;
        display_outline = true;
        outline_size = 2;
      } )
      ObjAttach( obj, place ) 
    end
    ne.reshub.ClearUsedRes();
    ObjSet( obj, {
      pos_x = pos_x;
      pos_y = pos_y;
      text = tostring( text );
      color_r = r or 1;
      color_g = g or 1;
      color_b = b or 1;
    } )
    ObjAnimate( obj, 8, 0, 0, function() ObjDelete( obj ) end, { 0, 0, 1, t, 1, 1, t + 0.25, 1, 0 } )
  end
  function public.Debag.TextTarget( text, target, t, r, g, b )
    if not public.IsLdCheater() then return end
    t = t or 1
    local place = public.GetCurrentPlace()
    if not place then return end
    local obj = "txt_common_impl_debag_texttarget_"..place.."_"..target
    if not ObjGet( obj ) then
      ObjCreate( obj, "text" )
      ObjSet( obj, { 
        input = 0;
        pos_z = 99;
        res = "assets/shared/cheater/arial";
        disprawtext = true;
        display_outline = true;
        outline_size = 2;
      } )
      ObjAttach( obj, place ) 
    end
    local obj_set = function()end
    obj_set = function()
      local o = ObjGet( target )
      if o then
        local p = GetObjPosByObj( target, place )
        ne.reshub.ClearUsedRes();
        ObjSet( obj, {
          pos_x = p[ 1 ];
          pos_y = p[ 2 ];
          ang = ang;
          text = tostring( text );
          color_r = r or 1;
          color_g = g or 1;
          color_b = b or 1;
        } )
        ObjAnimate( obj, 7,0,0, function() public.Debag.TextTarget( text, target, t, r, g, b ) end, { 0,0,0, 0,0,0 } )
      end
    end
    obj_set()
    ObjAnimate( obj, 8, 0, 0, function() ObjDelete( obj ) end, { 0, 0, 1, t, 1, 1, t + 0.25, 1, 0 } )
  end
--------------------------------------------------------------------------------------
  private.Debug_ControlParam_ = {}

  function public.Debug.ControlParam(name, func_update, func_change, step)
    if not _G["cheater"] then return end

    local colors = {{1,0.6,0.6}, {0.6,1,0.6}}
    local arrows_gap = 20
    local param = private.Debug_ControlParam_
    if type(name) == "table" then
      local t = name
      name = t[1].." "..t[2]
      step = step or t[3]
      func_update = func_update or function() return ObjGet(t[1])[ t[2] ] end;
      func_change = func_change or function(ch) ObjSet(t[1], {[ t[2] ] = ObjGet(t[1])[ t[2] ] + ch}) end;
    end
    table.insert(param, name)
    local idx = #param
    local modname = "_common_impl_debug_control_param_"
    local obj = "txt"..modname..idx
    local arrows = { "spr"..modname..idx.."_down", "spr"..modname..idx.."_up" }
    local pos = ld.Quick.GetPosByGrid( {idx,1}, {30, 100}, {100, 1300} )
    local function set_val()
      local result = func_update()
      result = result or "n/a"
      ObjSet(obj,{ text = name..": "..result })
    end
    if ObjGet(obj) then
      ObjDelete(obj)      
    end
    ObjCreate( obj, "text" )
    ObjSet( obj, { 
      input = 1;
      pos_z = 99;
      res = "assets/shared/cheater/arial";
      disprawtext = true;
      display_outline = true;
      outline_size = 2;
      align = 2;
    } )
    if true then
      ld.StartTimer( 0, function()  
        ObjAttach(obj, "cheater")
      end )
    else -- for test
      --ld.StartTimer( 0, function()  
      --  ObjAttach(obj, "mg_boardgameext")
      --end )
      --pos.pos_x = pos.pos_x - 171
    end
    for aidx,arrow in ipairs(arrows) do
      local sign = aidx == 1 and -1 or 1
      local aroot = arrow.."_root"
      ObjCreate( aroot, "obj")
      ObjAttach( aroot, obj)
      ObjCreate( arrow, "spr")
      ObjAttach( arrow, aroot)
      ObjSet( aroot, ld.Quick.GetInputRect( { arrows_gap, arrows_gap*math.sqrt(2)} ));
      ObjSet( aroot, {inputrect_x = -arrows_gap/2*(1 + -sign) });
      local params = ObjGet(aroot)
      ObjSet( aroot, {
        croprect_init = 1;
        croprect_x = params.inputrect_x;
        croprect_y = params.inputrect_y;
        croprect_w = params.inputrect_w;
        croprect_h = params.inputrect_h;
      } );
      ObjSet( aroot, {
        pos_x =  arrows_gap + aidx * arrows_gap * 0.1;
        event_mdown = function() func_change( sign*step ) set_val() end
      } );
      ObjSet( arrow, {
        res = "assets/shared/cheater/editor_back";
        scale_x = arrows_gap/2;
        scale_y = arrows_gap/2;
        ang = math.pi/4;
        input = 0;
      } );
      ObjSet( arrow, ld.Quick.GetColor(colors[aidx]) );
    end
    ObjSet( obj, pos );
    set_val()
    ne.reshub.ClearUsedRes();
  end

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--function Clock()  end
public.Clock = {}
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  --для замера времени
  function public.Clock.Start( name )
    private.Clock = {}
    private.Clock.name = name
    private.Clock.value = os.clock()
  end
  function public.Clock.Show()
    ld.LogTrace( "Clock "..( private.Clock.name or "" ), os.clock() - private.Clock.value )
  end
  function public.Clock.Stop()
    public.Clock.Show()
    private.Clock.value = 0
  end
  function public.Clock.Restart()
    public.Clock.Stop()
    public.Clock.Start()
  end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--function Pool()  end
public.Pool = {}
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  --получение нового пула - 
  function public.Pool.New( pool_name )
    ObjCreate( "obj_common_impl_pool_root_"..pool_name, "obj" )
    public.Pool.pools = public.Pool.pools or {}

    if public.Pool.pools[ pool_name ] then
      ld.LogTrace( "ERROR: Pool.New >> "..pool_name.." EXIST!!!" );
      return false
    end

    local pool = {}
    pool.owner_pool_by_obj = {}
    pool.objs = {}
    pool.objs_created = {}

    --function pool.obj_new()  end
    -- инициализация нового объекта - правила создания объекта
    pool.obj_new = function( name, obj_type, obj_owner, obj_set ) 
      pool.objs[ name ] = {
        name = name;
        obj_type = obj_type;
        obj_type = obj_type;
        obj_owner = obj_owner;
        obj_set = obj_set;
        created_count = 0;
        pooled = {};
        uniques = {};
        pool_name = pool_name;
        pool_root = "obj_common_impl_pool_root_"..pool_name;
        created = {};
      }
    end

    --function pool.obj_prepare()  end
    -- создание prepare_count объектов по описанным правилам
    pool.obj_prepare = function( name, prepare_count )
      local obj
      local pool_rule = pool.objs[ name ]
      for i = 1, prepare_count do
        pool_rule.created_count = pool_rule.created_count + 1
        obj = pool_rule.pool_root.."_"..name.."_"..pool_rule.created_count
        ObjCreate( obj, pool_rule.obj_type )
        ObjSet( obj, pool_rule.obj_set )
        table.insert( pool_rule.pooled, obj )
        table.insert( pool.objs_created, obj )
        pool.owner_pool_by_obj[ obj ] = name
      end
    end

    --function pool.obj_get()  end
    -- получить имя свободного объекта из пула и атач к владельцу
    -- return_to_pool_time - возвращает объект в пул через указанное время
    pool.obj_get = function( name, return_to_pool_time )
      local obj
      local pool_rule = pool.objs[ name ]
      if #pool_rule.pooled == 0 then
        pool.obj_prepare( name, 1 )
      end
      obj = table.remove( pool_rule.pooled )
      if pool_rule.obj_owner then
        ObjAttach( obj, pool_rule.obj_owner )
      end
      if return_to_pool_time then
        ld.StartTimer( "tmr_"..obj, return_to_pool_time, function()
          pool.obj_put( obj )
        end )
      end
      return obj
    end

    --function pool.objs_get()  end
    -- получить имена свободных объектов из пула и атач к владельцу
    -- count - количество нужных объектов
    -- return_to_pool_time - возвращает объекты в пул через указанное время
    pool.objs_get = function( name, count, return_to_pool_time )
      local objs = {}
      local pool_rule = pool.objs[ name ]
      if #pool_rule.pooled < count then
        pool.obj_prepare( name, count - #pool_rule.pooled )
      end
      for i = 1, count do
       table.insert( objs, table.remove( pool_rule.pooled ) )
      end
      if pool_rule.obj_owner then
        for i = 1, count do
          ObjAttach( objs[ i ], pool_rule.obj_owner )
        end
      end
      if return_to_pool_time then
        pool.objs_put( objs, return_to_pool_time )
      end
      return objs
    end

    --function pool.unique_get()  end
    -- получить имя уникального свободного объекта из пула и атач к владельцу
    -- name - имя пресета
    -- unique_name - уникальное имя для группы
    -- locked - при вызове с параметром true группа будет запомнена
    --   после вызова с параметром false следующее обращение вернет новые объекты
    -- count - количество необходимых объектов
    --   при наличии параметра возвращает массив объектов, иначе просто объект
    pool.unique_get = function( name, unique_name, locked, count )
      local obj
      local pool_rule = pool.objs[ name ]
      unique_name = unique_name or "default"
      if pool_rule.uniques[ unique_name ] then
        obj = pool_rule.uniques[ unique_name ]
      else
        if count then
          obj = {}
          for i = 1, count do
            obj[ i ] = pool.obj_get( name )
          end
        else
          obj = pool.obj_get( name )
        end
        pool_rule.uniques[ unique_name ] = obj
      end
      if not locked then
        pool_rule.uniques[ unique_name ] = nil
      end
      return obj
    end

    --function pool.unique_put()  end
    -- возвращает в пул уникальные объекты
    -- locked - при true ничего никуда не вернет
    pool.unique_put = function( obj_or_objs, locked )
      if not locked then
        if type( obj_or_objs ) == "table" then
          if #obj_or_objs == 0 then return end;
          pool.objs_put( obj_or_objs )
        else
          pool.obj_put( obj_or_objs )
        end
      end
    end

    pool.obj_return = function( obj, pool_rule )
      table.insert( pool_rule.pooled, obj )
      ObjAttach( obj, pool_rule.pool_root )
    end

    pool.objs_return = function( objs, pool_rule )
      for i, v in ipairs( objs ) do
        pool.obj_return( v, pool_rule )
      end
    end

    --function pool.obj_put()  end
    -- вернуть объект в пул
    -- return_to_pool_time - возвращает объект в пул через указанное время, либо сразу
    pool.obj_put = function( obj, return_to_pool_time )
      local pool_rule = pool.objs[ pool.owner_pool_by_obj[ obj ] ]
      if return_to_pool_time then
        ld.StartTimer( "tmr_"..obj, return_to_pool_time, function()
          pool.obj_return( obj, pool_rule )
        end )
      else
        pool.obj_return( obj, pool_rule )
      end
    end

    --function pool.objs_put()  end
    -- вернуть объекты в пул
    -- return_to_pool_time - возвращает объект в пул через указанное время, либо сразу
    pool.objs_put = function( objs, return_to_pool_time )
      if #objs == 0 then return end
      local pool_rule = pool.objs[ pool.owner_pool_by_obj[ objs[ 1 ] ] ]
      if return_to_pool_time then
        ld.StartTimer( "tmr__"..objs[ 1 ], return_to_pool_time, function()
          pool.objs_return( objs, pool_rule )
        end )
      else
        pool.objs_return( objs, pool_rule )
      end
    end

    --function pool.destroy()  end
    -- уничтожение пула
    pool.destroy = function( bool_all )
      if bool_all == nil then
        bool_all = true
      end
      public.Pool.Destroy( pool_name, bool_all )
    end

    --function pool.show_state()  end
    pool.show_state = function()
      --pool.objs[ name ] = {
      --  name = name;
      --  obj_type = obj_type;
      --  obj_type = obj_type;
      --  obj_owner = obj_owner;
      --  obj_set = obj_set;
      --  created_count = 0;
      --  pooled = {};
      --  uniques = {};
      --  pool_name = pool_name;
      --  pool_root = "obj_common_impl_pool_root_"..pool_name;
      --}
      local state = ""
      local count = 0
      for k, v in pairs( pool.objs ) do
        count = count + #v.pooled
        state = state.."\t"..v.name.." created="..v.created_count.." pooled="..#v.pooled.."\n"
      end
      ld.LogTrace( count.."\n"..state )
    end

    public.Pool.pools[ pool_name ] = pool
    return pool
  end

  function public.Pool.Destroy( pool_name, bool_all )
    local pool = public.Pool.pools[ pool_name ]
    if bool_all then
      for k, v in pairs( pool.objs_created ) do
        ObjDelete( v )
      end
    else
      for k, v in pairs( pool.objs ) do
        for i = 1, #v do
          ObjDelete( v[ i ] )
        end
      end
    end
    pool.obj_new = nil;
    pool.obj_prepare = nil;
    pool.obj_get = nil;
    pool.obj_put = function( obj ) ObjDelete( obj ) end;
    pool.destroy = function()  end;
    public.Pool.pools[ pool_name ] = nil
    ObjDelete( "obj_common_impl_pool_root_"..pool_name )
  end

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--function Table()  end
public.Table = {}
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  function public.Table.Iterate2d(collection)
    local index = 0
    local rowIndex = 1
    local colIndex = 0
    local rowCount = #collection
    local colCount = #collection[1]
    local count = rowCount*colCount

    return function ()
      index = index + 1
      colIndex = colIndex + 1
      if colIndex > colCount then
        colIndex = 1
        rowIndex = rowIndex + 1
      end
      if index <= count then
         return index, rowIndex, colIndex, collection[rowIndex][colIndex]
      end
    end
  end

  function public.Table.Reverse( i_table )

    local i, j = 1, #i_table
    while i < j do
      i_table[i], i_table[j] = public.Table.Copy(i_table[j]), public.Table.Copy(i_table[i])
      i = i + 1
      j = j - 1
    end

  end
--------------------------------------------------------------------------------

  function public.Table.Contains( test, val, keyReturn )

    local matched = false
    local keyValue = 0

    for key in pairs( test ) do --pairs is used, as opposed to ipairs, because ipairs stops at any nil value

      if type( test[ key ] )=="table" then

        for k, v in pairs( test[ key ] ) do

          if val == v then

            matched = true
            keyValue = key

          end

        end

      else

        if val == test[ key ] then

          matched = true
          keyValue = key

        end

      end

    end

    return keyReturn and keyValue or matched

  end

  public.TableContains = public.Table.Contains;

--------------------------------------------------------------------------------
  function public.Table.Equals( t1, t2 )
    local a, b = private.TableEquals( t1, t2 )
    return a == b, a, b
  end
    function private.TableEquals(t1,t2,count,max)
      local count = 0 or count;
      local max = 0 or max;
      if type(t1) == type(t2) and type(t1) == "table" then
        if #t1 == #t2 then
          for k,v in pairs(t1) do
            if type(v) == "table" then
              local answer, count1, max1
              answer, count1, max1 = ld.TableEquals(t1[k],t2[k],count,max)
              if not ( answer or count1 or max1 ) then return false end
              count, max = count + count1, max + max1
            else
              if (type(t1[k]) == type(t2[k])) then
                if t1[k] == t2[k] then
                  count = count + 1
                end
                max = max + 1;
              else
                ld.LogTrace(string.format("Error: in ld.TableEquals, different keys or types of values in comparable tables %s ~= %s",
                type(t1[k]),type(t2[k])))
                return false
              end
            end
          end
          return count,max
        else
          --ld.LogTrace("Error: in ld.TableEquals, lenghts not equals")
          return false
        end
      else
        ld.LogTrace("Warning: in ld.TableEquals, type is not a table")
        return false
      end
    end
    public.TableEquals = public.Table.Equals;
  --------------------------------------------------------------------------------------
  function public.Table.Shuffle(tab)
    local n, order, res = #tab, {}, {}
    for i=1,n do order[i] = { rnd = math.random(), idx = i } end
    table.sort(order, function(a,b) return a.rnd < b.rnd end)
    for i=1,n do res[i] = tab[order[i].idx] end
    if ld.TableEquals(tab,res) and #tab>1 then
      return public.TableShuffle(tab)
    else
      return res
    end
  end
    public.TableShuffle = public.Table.Shuffle
  --------------------------------------------------------------------------------------
  function public.Table.Sum(table)
    local sum = 0
    local check
    for i,o in pairs(table) do
      sum = sum + tonumber( o )
      check = true
    end
    return sum or check
  end
    public.TableSum = public.Table.Sum
  --------------------------------------------------------------------------------------
  function public.Table.Copy(t)
    local t2 = {};
    if type(t) == "table" then
      for k,v in pairs(t) do
        if type(v) == "table" then
            t2[k] = ld.Table.Copy(v);
        else
            t2[k] = v;
        end
      end
    else
      t2=t
    end
    return t2;
  end
    public.TableCopy = public.Table.Copy
  --------------------------------------------------------------------------------------
  function public.Table.ValuesCount( t )
    local count = 0
    for k, v in pairs( t ) do
      if type( v ) == "table" then
        count = count + public.TableValuesCount( v )
      else
        count = count + 1
      end
    end
    return count
  end
    public.TableValuesCount = public.Table.ValuesCount;
  --------------------------------------------------------------------------------------
  function public.Table.Count( t, recursive, count )
    count = count or 0
    for k, v in pairs( t ) do
      if recursive and type( v ) == "table" then
        count = public.Table.Count( v, recursive, count )
      else
        count = count + 1;
      end
    end
    return count;
  end
    public.TableCount = public.Table.Count;
  --------------------------------------------------------------------------------------
  function public.Table.Chain( count, value )  
    local result = {}
    if type(count) == "number" then
      for i = 1,count do
        local insert = i
        if value ~= nil then 
          insert = value
        end
        table.insert( result, insert )
      end
      return result
    else
      ld.LogTrace( "Error in ld.Table.Chain: count not number", count );
    end
  end
  --------------------------------------------------------------------------------------
  --[[ сделать действие для всех элементов таблицы(+ вложенные)
  если индексы не совпадают или типы не сответствуют, запись не будет произведена
  t1 - таблица
  t2 - таблица или значение
   t2 может быть не таблицей тогда будет произведео действие для всех элементов t1 cо значением t2
  action - строка код действия(см. registredActions) "+", "-"..
    action может быть функцией принимающей 2 параметра(2 не обязательный) и возвращающей результат обработки
  Примеры:
    ld.Table.Action( t1, t2, "+" ) --сложить поэлементно t1 и t2
    ld.Table.Action( t1, 2, "/" ) --разделить t1 поэлементно на 2
    ld.Table.Action( t1, t2, function(e1, e2) return e1^e2 end ) --возвести элементы t1 в степень элементов t2
    ld.Table.Action( t3, nil, function(e1) return math.tointeger(e1) or false end ) --привести к целому типу, проверка "or false" 
      нужна чтобы таблица сформировалась, т.к. math.tointeger может вернуть nil
  ]]
  --------------------------------------------------------------------------------------
  function public.Table.Action( t1, t2, action )
    local result = {}
    local allTypes = {
      "number", "string", "nil", "boolean", "function"
    }
    local numberType = {allTypes[1]}
    local concatType = {allTypes[1], allTypes[2]}
    local registredActions = {
      ["+"] =   { reqType = numberType, func = function(o1, o2) return o1+o2 end };
      ["-"] =   { reqType = numberType, func = function(o1, o2) return o1-o2 end  };
      ["*"] =   { reqType = numberType, func = function(o1, o2) return o1*o2 end  };
      ["/"] =   { reqType = numberType, func = function(o1, o2) return o1/o2 end  };
      [".."] =  { reqType = concatType, func = function(o1, o2) return o1..o2 end  };
      ["=="] =  { reqType = allTypes,   func = function(o1, o2) return o1 == o2 end };
      ["~="] =  { reqType = allTypes,   func = function(o1, o2) return o1 ~= o2 end };
      ["&"] =   { reqType = allTypes,   func = function(o1, o2) return o1 and o2 end };
      ["|"] =   { reqType = allTypes,   func = function(o1, o2) return o1 or o2 end };
      ["&&"] =  { reqType = allTypes,   func = function(o1, o2) return (o1 and o2) and true or false end };
      ["||"] =  { reqType = allTypes,   func = function(o1, o2) return (o1 or o2) and true or false end };
    }
    local actionTable = registredActions[action]
    local t2IsTable = type(t2) == "table"
    local customAction = type(action) == "function" and action or false

    if not (actionTable or customAction) then
      return 
    end
    
    local function makeAction( obj1, obj2 )
      local function checkType(obj, sType)
        for i,o in ipairs(sType) do
          if type(obj) == o then
            return true
          end
        end
        return false
      end
      if customAction then
        return customAction(obj1, obj2)
      end
      if checkType(obj1, actionTable.reqType) and checkType(obj2, actionTable.reqType) then
        return actionTable.func(obj1, obj2)
      end
    end
    for i,o in pairs(t1) do
      local secondOperand = t2IsTable and t2[i] or t2
      if type(o) == "table" then
        result[i] = public.Table.Action( o, secondOperand, action )
      else
        local val = makeAction( o, secondOperand )
        result[i] = val
      end
    end
    --if #result == 0 then return false end
    return result
  end
--------------------------------------------------------------------------------------
  --проверка наличия ячейки в двумерном массиве
  function public.Table.CellExist( table, pos, returnVal )
    if table and table[ pos[1] ] and table[ pos[1] ][ pos[2] ] then
      return returnVal and table[ pos[1] ][ pos[2] ] or true
    else
      return false
    end
  end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--function Room() end
public.Room = {}
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  function public.Room.IsZoomable( obj ) -- является ли комната obj Zoomable
    return _G[ obj ] and _G[ obj ].IsZoomable and _G[ obj ].IsZoomable()
  end
  --------------------------------------------------------------------------------------
  function public.Room.Current() -- текущая комната
    return GetCurrentRoom();
  end
  --------------------------------------------------------------------------------------
  function public.Room.CurrentParent() -- "родитель" текущей комнаты
    return public.Room.Parent( ld.Room.Current() );
  end
  --------------------------------------------------------------------------------------
  function public.Room.Parent( obj ) -- комната "родитель" связанная гейтом с комнатой obj
    return public.SmartHint_GetRoomParent( obj )
  end
  --------------------------------------------------------------------------------------
  function public.Room.ParentGate( obj ) -- имя гейта из "родителя" в комнату obj
    local div = ld.StringDivide( obj )
    return "g"..div[ 1 ].."_"..ld.StringDivide( ld.Room.Parent( obj ) )[ 2 ].."_"..div[ 2 ]
  end
  --------------------------------------------------------------------------------------
  function public.Room.Opened( obj ) -- сохронено ли в прогрессе открытие комнаты obj
    return ld.CheckRequirements( { obj:gsub( "^"..ld.StringDivide( obj )[ 1 ], "opn" ) } )
  end
  --------------------------------------------------------------------------------------
  function public.Room.GateAwailable( obj ) -- доступность гейта для перехода в комнату obj
    local o = ObjGet( public.Room.ParentGate( obj ) )
    return o and o.input
  end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--function SubRoom() end
public.SubRoom = {}
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  function public.SubRoom.Current() -- текущая открытая zz
    --local opened = subroom.GetSubRoomOpened();
    return common.GetCurrentSubRoom()
  end
  --------------------------------------------------------------------------------------
  function public.SubRoom.Owner( zz_name ) -- "владелец вложенности" zz
    return subroom.GetSubRoomOwner( zz_name ) 
  end
  --------------------------------------------------------------------------------------
  function public.SubRoom.Parent( zz_name ) -- "родитель" zz
    zz_name = zz_name or public.SubRoom.Current()
    return subroom.GetSubRoomOwner( zz_name ) 
        or public.smart_hint_connections[ zz_name ] 
        or public.ObjGetOwnerZzRmMgHo( zz_name )
  end
  --------------------------------------------------------------------------------------
  function public.SubRoom.Gate( zz_name ) -- гейт в zz
    zz_name = zz_name or public.SubRoom.Current()
    local parent_name = public.SubRoom.Parent( zz_name )
    return "gzz_"..ld.String.Postfix( parent_name ).."_"..ld.String.Postfix( zz_name )
  end
  --------------------------------------------------------------------------------------
  function public.SubRoom.OwnerGate( zz_name ) -- гейт в "владельца вложенности" zz, или просто гейт
    zz_name = public.SubRoom.Owner( zz_name ) or zz_name or public.SubRoom.Current()
    return public.SubRoom.Gate( zz_name )
  end
  --------------------------------------------------------------------------------------
  function public.SubRoom.IsOwned( zz_name ) -- является ли zz вложенной
    return subroom.GetSubRoomOwner( zz_name ) ~= nil
  end
  --------------------------------------------------------------------------------------
  function public.SubRoom.IsZz( zz_name ) -- является ли zz_name zz
    return zz_name and zz_name:find( "^zz" )
  end
  --------------------------------------------------------------------------------------
  function public.SubRoom.Close() -- закрывает зз
    ld_impl.CloseSubRoom()
  end
  public.CloseSubRoom = function()
    common.CloseSubRoom()
    common_impl.FrameSubroom_Click();
    interface.CheaterUpdateSubroom( "" );
  end
  --------------------------------------------------------------------------------------
  function public.SubRoom.CompleteCheck( progress, typep, no )
    return public.ZzCompleteCheck( progress, typep, no )
  end
  private.ZzCompleteChecked = {};
  public.ZzCompleteCheck = function( progress, typep, no )
    local zz = (typep and progress) or common_impl.hint[progress].zz 
    if not zz then
      ld.LogTrace( "Error: You try to check not zoomable progress "..progress.." (ld_impl:public.ZzCompleteCheck)" );
      return false
    end
    --ld.LogTrace( "ZzCompleteCheck "..progress );
    if private.notes_initialized_loc[ zz ] then
      --disable zz closing with NoteInit
      return false
    elseif private.ZzCompleteChecked[ zz ] and not typep then
      --ld.LogTrace( zz, private.ZzCompleteChecked[ zz ] );
      if type(private.ZzCompleteChecked[ zz ]) == "boolean" then
        return true;    
      elseif type(private.ZzCompleteChecked[ zz ]) == "table" then
        local complete = ld.CheckRequirements( private.ZzCompleteChecked[ zz ] );
        if complete then
          private.ZzCompleteChecked[ zz ] = true;
        end
        return complete;
      end
    else
      local tocheck = {}
      for i,o in pairs(common_impl.hint) do
        if o.zz == zz then
          if (typep and ((no and o.type ~= typep) or (not no and o.type == typep))) or (not typep and true) then
            table.insert(tocheck,i)
          end
        end
      end
      --ld.LogTrace( zz.." left "..count.." "..((no and "not ") or "")..((typep and typep.." ") or "").." actions" );
      if not typep then
        private.ZzCompleteChecked[ zz ] = tocheck
        return public.ZzCompleteCheck( progress,typep,no );
      else
        return ld.CheckRequirements( tocheck );
      end
    end;
  end;
  --------------------------------------------------------------------------------------
  function public.SubRoom.IsStarted( zz )
    return public.ZzIsStarted( zz )
  end
  public.ZzIsStarted = function( zz )
    --возвращает TRUE если какой-нибудь прогресс в зз стартовал или завершён
    if public.smart_hint_full[ zz ] then
      for i, o in ipairs( public.smart_hint_full[ zz ] ) do
        if common_impl.IsEventDone( o ) or common_impl.IsEventStart( o ) then
          return true;
        end;
      end
      --return ld.CheckRequirements( public.smart_hint_full[ zz ], 1 ) > 0
    end
    return false
  end;
  --------------------------------------------------------------------------------------
  function public.SubRoom.Tint(zz, onOff, exceptionsTable, forceUpdate)
    local color = onOff and 0.3 or 1
    local time = 0.45
    if forceUpdate then
      private["overlay_tint_list_for_"..zz] = ObjGetRelations( "obj_"..zz.."_overlay" ).childs
    else
      private["overlay_tint_list_for_"..zz] = private["overlay_tint_list_for_"..zz] or ObjGetRelations( "obj_"..zz.."_overlay" ).childs
    end
    ld.Anim.Set( "zz_"..zz, {color_r = color, color_g = color, color_b = color}, time)
    for i,o in ipairs(private["overlay_tint_list_for_"..zz]) do

      if exceptionsTable and ld.Table.Contains(exceptionsTable, o) then
      else
        if not (ld.StringDivide(o)[1] == "gfx" or ld.StringDivide(o)[1] == "pfx") then
          ld.Anim.Set(o,{color_r = color, color_g = color, color_b = color},time)
        end
      end
    end
  end;
--------------------------------------------------------------------------------------
  function public.SubRoom.Complete ( progress, room_after_mg )

    local type = ld.String.Divide(common_impl.hint[progress].zz)[1] -- zz inv mg

    if common_impl.ZzCompleteCheck(progress) then

      local answer = MsgSend( Request_Level_IsLoading, {} );

      if _G[ "cheater" ] and cheater.is_progress_executing_now then
        answer.loading = 1
      end;      

      if type == "zz" then --удаляет гейт и закрывает зз

        ObjSet( common_impl.hint[progress].zz_gate, { visible = 0, input = 0 } );

        if ( answer.loading == 0 ) then

          ld.CloseSubRoom();

        end

      elseif type == "inv" then --удаляет инвентарник и закрывает деплой

        interface.InventoryItemRemove(common_impl.hint[progress].zz_gate)

        if ( answer.loading == 0 ) then

          common_impl.HideComplexItem()

        end

      elseif type == "mg" then --кидает в указанную локу или брёт родительскую локу

        if ( answer.loading == 0 ) then

          cmn.GotoRoom( room_after_mg or common_impl.hint[progress].room );

        end

      else

        ld.LogTrace( "Error: in ld_impl.SubRoom.Complete. Wrong prefix of zz (allowed zz inv mg)", type );

      end

      return true,answer.loading --возврат выполненности ЗЗ, маркер загрузки в данный момент(если 0 то не загрузка)
      
    end;

    return false

  end;
--------------------------------------------------------------------------------------
--function String() end
public.String = {}
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
  function public.String.Split( str, divider )
    return public.String.Divide( str, divider )
  end

  function public.String.Divide( str, divider ) -- возвращяет массив строк, разделённых divider'ом ( по умолчанию "_")
    return public.StringDivide( str, divider )
  end

    public.StringDivide = function( str, divider )
      divider = divider or "_"
      local answer = {}
      local id = 1
      local il = 1
      for i = 1, str:len() do
        if str:sub( i, i ) == divider then
          answer[ id ] = str:sub( il, i - 1 )
          il = i + 1
          id = id + 1
        end
        if i == str:len() then
          answer[ id ] = str:sub( il, i )
          il = i + 1
          id = id + 1
        end
      end
      return answer
    end
  --------------------------------------------------------------------------------------
  function public.String.Prefix( str, divider ) -- возвращяет строку перед первым divider ( по умолчанию "_")
    return public.String.Divide( str, divider )[ 1 ]
  end
  --------------------------------------------------------------------------------------
  function public.String.Postfix( str, divider ) -- возвращяет строку после последнего divider ( по умолчанию "_")
    local divided = public.String.Divide( str, divider )
    return divided[ #divided ]
  end
  --------------------------------------------------------------------------------------
  function public.String.UpperFirst( str ) -- возвращяет строку c большой первой буквой 
    return public.StringUpperFirst( str )
  end
  public.StringUpperFirst = function( string )
    return string.upper( string.sub( string, 1, 1 ) )..string.sub( string, 2 )
  end
  --------------------------------------------------------------------------------------
  function public.String.Getnumber( str ) -- возвращяет цифру в конце строки
    return public.NumberFromString( str )
  end
  public.NumberFromString = function( string )
    local int = "";
    local count = 0
    string = tostring( string )
    while string:len() > 0 and count < 10 do
      local s = string:sub(string:len(),string:len());
      local n = tonumber( string:sub( string:len(), string:len() ) )
      if n then
        int = n..int;
        string = string:sub(1,string:len()-1);
      else
        break;
      end;
      count = count + 1
    end;
    return tonumber( int )
  end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
function public.IsLdCheater()
  if _G["cheater"] then
    return cheater.IsLdCheater()
  end
end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-----------для активных инв предметов
function public.ObjIntersectCheck(obj1,obj2)
  if ObjIntersect(obj1,obj2) and ( ( ObjGet("inv_complex_"..public.StringDivide(obj2)[2]) and  ObjGet("inv_complex_"..public.StringDivide(obj2)[2]).input)) and ( ObjGet(obj2) and ObjGet(obj2).input ) then
    return true
  else
    return false
  end
end
-----------
function public.ApplyCheck(obj, zone, inzz, parent)
  if common.ApplyObj(obj, zone, inzz,  parent) and ObjGet( zone ).input then
    return true
  else
    return false
  end
end
--------------------------------------------------------------------------------------
-- dragdrop: use( {ld.loc0.use, ld.loc1.use, ld.loc3.use} )
public.UseItemGotoZzLock = false;
public.UseItemLock = false;
public.UseItemLastPrg = false;
function public.UseItem(obj)
--ld.LogTrace( "UseItem >> "..obj, not public.UseItemLock, not subroom.open_anim, not subroom.close_anim )
  local inv = obj
  local found = false

  --local t = os.clock();
  if not public.UseItemLock and not subroom.open_anim and not subroom.close_anim then
    for i,o in pairs(common_impl.hint) do                                    --перебор common_impl.hint
      --DbgTrace(i)
      --DbgTrace(o)
      if o.inv_obj == inv and o.type == "use" then                     --если у типа use есть применяемый предмет с таким именем
  --TODO:>> Перебор и проверку сделать одноразовой заполняющей масив который потом и проверяется(в ините)
        if not public.CheckRequirements({i}) then                         --если этот прогресс не выполнен

--ld.LogTrace( 
--  "1", 
--  interface.GetCurrentComplexInv() == "", 
--  o.zz_gate,
--  public.ApplyCheck(inv, o.zz_gate, false),
--  ObjGet( o.use_place ) and true or false,
--  ObjGet( o.use_place ) and ObjGet( o.use_place ).input,
--  not public.UseItemGotoZzLock,
--
--  "\n", 
--
--  "2",
--  interface.GetCurrentComplexInv() == "",
--  public.ApplyCheck(inv, o.use_place, (o.zz and not o.zz:find("^mg_"))),
--  (interface.GetCurrentComplexInv() == "" and public.ApplyCheck(inv, o.use_place, (o.zz and not o.zz:find("^mg_"))) ),
--
--  interface.GetCurrentComplexInv(),
--  public.ObjIntersectCheck(inv, o.use_place),
--  interface.GetCurrentComplexInv() == o.zz,
--  (interface.GetCurrentComplexInv() ~= "" and public.ObjIntersectCheck(inv, o.use_place) and interface.GetCurrentComplexInv() == o.zz  )
--
--)
          if interface.GetCurrentComplexInv() == "" and o.zz_gate and public.ApplyCheck(inv, o.zz_gate, false) and ObjGet( o.use_place ) and ObjGet( o.use_place ).input             --пересечение с переходом если переход есть
          and not public.UseItemGotoZzLock then                                                    --залоченость перехода в ЗЗ
            local zz = public.StringDivide(o.zz)
             --ld["Goto"..public.StringUpperFirst(zz[1])](zz[2])             --переход в Mg или Zz
            if inv == "obj_helper_cursor_drag" then
              ObjDoNotDrop()
            else 
              ld.InvSetDropable( inv, false, true )--аналог 
            end
            
            if zz[1]== "zz" then
            --DbgTrace(o.zz)
             cmn.GotoSubRoom(o.zz)
            elseif zz[1]=="mg" then
             cmn.GotoRoom(o.zz)
            end
            found = true;                                             --функция найдена
            break;                                                    --разрыв цикла
          elseif  (interface.GetCurrentComplexInv() == "" and public.ApplyCheck(inv, o.use_place, (o.zz and not o.zz:find("^mg_"))) ) --
          or ( interface.GetCurrentComplexInv() == "" and public.ApplyCheck( inv, o.use_place, true, "int_frame_subroom_impl" ) ) --OVERLAY
          or (interface.GetCurrentComplexInv() ~= "" and public.ObjIntersectCheck(inv, o.use_place) and interface.GetCurrentComplexInv() == o.zz  ) then                    --пересечение с целевой зоной, ng_var.note_opened - глобальная переменная открытия записок в зз
          --ld.LogTrace( tostring(int_deploy_inv.show) );
            local room =(o.zz and o.zz:find("^mg_") and o.zz) or o.room --определить имя комнаты или миниигры
            --DbgTrace(room)
            --DbgTrace(i)
            public.UseItemLastPrg = i;
            if room == "inv_complex_inv" then level_inv[i](inv) else _G[room][i](inv) end --выполнить функцию

            if ( ObjGet(inv) and ObjGet(inv).looped) then  VidPause(inv, 1); end         --если видео - запаузить
            if ( ObjGet("fx_"..public.StringDivide(inv)[2]) and ObjGet("fx_"..public.StringDivide(inv)[2]).active ) then ObjSet( "fx_"..public.StringDivide(inv)[2], {active = 0} ); end -- если есть частица(с правильным именем) запаузить
            found = true;                                             --функция найдена
            break;                                                    --разрыв цикла
          end
        end
  --TODO:<<
      end
    end

    --ld.LogTrace( "UseItem pairs(common_impl.hint) execute time", os.clock() - t )

    if (not found) and level_inv.use_add[inv] then

      for i,o in ipairs(level_inv.use_add[inv]) do

        --ld.LogTrace( interface.GetCurrentComplexInv() , o, o.zz, public.ObjIntersectCheck(inv, o[1]) );

        if    ( interface.GetCurrentComplexInv() == "" and public.ApplyCheck(inv, o[1], common.GetCurrentSubRoom() and true or false ) ) 
           or ( interface.GetCurrentComplexInv() == "" and public.ApplyCheck( inv, o[ 1 ], true, "int_frame_subroom_impl" ) ) --OVERLAY
           or ( interface.GetCurrentComplexInv() ~= "" and public.ObjIntersectCheck(inv, o[1]) and interface.GetCurrentComplexInv() == o.zz ) then

          if type( o[2] ) == "string" then
            ld.ShowBbt(o[2])
            if inv == "obj_helper_cursor_drag" then
              interface.HelperWrongApply()
            end
          elseif  type( o[2] ) == "function" then
            o[2]();
          else
            ld.LogTrace( "ERROR: level_inv.use_add - параметр не строка и не функция" )
          end
          --if o[2]:find("^*") then
          --  TrgSet( "trg_common_impl_init_misc_temp", {code = "local obj = '"..inv.."';\n"..o[2]:gsub("^*","")} );
          --  TrgExecute("trg_common_impl_init_misc_temp");
          --else
          --  ld.ShowBbt(o[2])
          --end
          if ObjGet(inv).looped then  VidPause(inv, 1); end         --если видео - запаузить
          if ObjGet("fx_"..ld.StringDivide(inv)[2]) and ObjGet("fx_"..ld.StringDivide(inv)[2]).active then ObjSet( "fx_"..ld.StringDivide(inv)[2], {active = 0} ); end -- если есть частица(с правильным именем) запаузить
          found = true;
          break;
        end
      end
    end

  end;



  if (not found) then
    if ( ObjGet(inv) and  ObjGet(inv).looped) then  VidPause(inv, 1); end         --если видео - запаузить
    if ( ObjGet("fx_"..public.StringDivide(inv)[2]) and ObjGet("fx_"..public.StringDivide(inv)[2]).active) then ObjSet( "fx_"..public.StringDivide(inv)[2], {active = 0} ); end -- если есть частица(с правильным именем) запаузить
    SoundSfx( "reserved/aud_wrong_apply" )
    public.UseItemWrong(inv)
    if inv == "obj_helper_cursor_drag" then
      interface.HelperWrongApply()
    end
  end
end;

--для необходимости вызвать wrong bbt c учетом возможности что инвентарный - видос и/или у него есть частица
function public.UseItemWrong(inv)
  if ( ObjGet(inv) and  ObjGet(inv).looped) then  VidPause(inv, 1); end         --если видео - запаузить
  if (ObjGet("fx_"..public.StringDivide(inv)[2]) and ObjGet("fx_"..public.StringDivide(inv)[2]).active) then ObjSet( "fx_"..public.StringDivide(inv)[2], {active = 0} ); end -- если есть частица(с правильным именем) запаузить
  common_impl.WrongApply();
end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--function Gate( ) end
  function public.Gate_MDown( gate, zz_pos_beg )

    if ng_global.currentprogress == "scr" and
       ng_global.MOD_MASTERSCR_GOTO_ROOM and
       common.GetObjectPrefix( gate ):gsub("^g","") ~= "zz" then
      
      --GREAT FUTURE
      --if _G["rm_secretroomscr"] then 
      --  rm_secretroomscr.GotoRoom( 'rm_secretroomscr' ) 
      --end  
      
      -- TERRIBLE PAST:
      local mgho_objname = ng_global.MOD_MASTERSCR_GOTO_ROOM;
      local mgho = ld.StringDivide( mgho_objname )[ 2 ];
      if ld.CheckRequirements( { "win_"..mgho } ) then
        ng_global.progress["scr"]["win_"..mgho]={}
        ng_global.progress["scr"]["win_"..mgho].done = 0
        ng_global.progress["scr"]["win_"..mgho].start = 0
        if ng_global.progress["scr"]["opn_"..mgho] then
          ng_global.progress["scr"]["opn_"..mgho].done = 0
        end
      end
      ng_global.is_scr = true;
      ng_global.MOD_MASTERSCR_GOTO_ROOM = false
      common.LevelSwitch( "menu", "game" )

    elseif GetCurrentRoom() == "mg_casket" then
      int_cube.GoOut()
      
    --if ng_global.currentprogress == "scr" and ng_global.MOD_MASTERSCR_GOTO_ROOM then  
 
    else
      local to = common.GetObjectPrefix( gate ):gsub("^g","")
      local to_name = public.StringDivide( gate )
      to_name = to_name[#to_name]
      local goto_name = to.."_"..to_name
      if to == "zz" then
        cmn.GotoSubRoom( goto_name, zz_pos_beg, {512,350} )
      elseif to == "rm" then
        cmn.GotoRoom( goto_name )
      elseif to == "mg" then
        cmn.GotoRoom( goto_name )
      elseif to == "ho" then
        cmn.GotoRoom( goto_name )
      end;
    end
  end;
  --------------------------------------------------------------------------------------
  function public.Gate_MEnter( gate, cursor )
    local to = common.GetObjectPrefix( gate ):gsub("^g","")
    if to == "zz" then
      cursor = cursor or CURSOR_LOUPE
    elseif to == "rm" then
      --if  ng_global.MOD_MASTERSCR_GOTO_ROOM then
      if  ng_global.currentprogress == "scr" then
        cursor = cursor or CURSOR_UP
        --common_impl.PopupShow( "secretroomscr" ) --if need
      elseif GetCurrentRoom() == "mg_casket" then
        local to_name = public.StringDivide( ng_global.progress[ ng_global.currentprogress ].common.currentroom )
        to_name = to_name[#to_name]
        common_impl.PopupShow( to_name )
      else
        local to_name = public.StringDivide( gate )
        to_name = to_name[#to_name]
        local room =  "rm_"..to_name
        local is_zoomable, is_zoomable_anim 
        if _G[ room ] and _G[ room ].IsZoomable then
          is_zoomable, is_zoomable_anim = _G[ room ].IsZoomable()
        end
        if is_zoomable or is_zoomable_anim then
          cursor = cursor or CURSOR_LOUPE
        else
          cursor = cursor or CURSOR_UP
          common_impl.PopupShow( to_name )
        end
      end

    elseif to == "mg" then
      cursor = cursor or CURSOR_LOUPE
    elseif to == "ho" then
      cursor = cursor or CURSOR_LOUPE
    else
      cursor = cursor or CURSOR_DEFAULT
    end;

    local o = ObjGet( gate.."_focus" )
    if o then ObjAnimate( gate.."_focus", 8,0,0, "", { 0,0,o.alp, ((1-o.alp)^0.5)/3,2,1 } ) end;
    -- SetCursor( cursor );

    public.ShCur(cursor)

  end;
  --------------------------------------------------------------------------------------
  function public.Gate_MLeave( gate, cursor )
    common_impl.PopupHide()
    public.ShCur( cursor or CURSOR_DEFAULT );
    local o = ObjGet( gate.."_focus" )
    if o then ObjAnimate( gate.."_focus", 8,0,0, "", { 0,0,o.alp, (o.alp)/1,2,0 } ) end;
  end;
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

function public.CheckRequirements( requirements, return_count )
  local count = 0;
  local prg = ng_global.currentprogress;
  if type(requirements) == "string" then
    requirements = {requirements}
  end

  for i = 1, #requirements, 1 do
    --ld.LogTrace( requirements[i] );
    --if not ng_global.progress[prg][ requirements[i] ] then ld.LogTrace( "ERROR : ld.CheckRequirements progress '"..requirements[i].."' not finded"  ) end
    if ng_global.progress[prg][ requirements[i] ] and ng_global.progress[prg][ requirements[i] ].done == 1 then
      count = count + 1;
    elseif string.find(requirements[i],"^puzzle") then
      local str = requirements[i]:gsub("puzzle","")
      local num = tonumber(str)
      if ng_global.achievements.puzzle[num] then
        count = count + 1;
      else 
       -- ld.LogTrace( requirements[i] );
      end

    else 
      --ld.LogTrace( requirements[i] );
    end;
  end;
  if return_count then
    return count;
  end
  if ( count == #requirements ) then
    return true;
  else
    return false;
  end;
end;
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
function public.CheckRequirementsLast( requirements )
  return (ld.CheckRequirements( requirements, 1 ) + 1 == #requirements)
end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--TODO: МАССИВЫ ФОРМИРОВАТЬ 1 РАЗ ПРИ ЗАГРУЗКЕ(тот же что и в UseItem)
function public.ProcessMultiUseAll(obj, except)
  local count = 0
  local countmax = 0
  local diff = 0
  local except = except or ""
  if not string.find(obj,"^inv_") then
    obj = "inv_"..obj
  end

  for i,o in pairs(common_impl.hint) do
    if o.inv_obj == obj and o.type == "use" then
      if i == "use_"..except then
        diff = 1
      else
        if public.CheckRequirements({i}) then
          count = count + 1
        end
      end
      countmax = countmax + 1
      --ld.LogTrace( "!!! "..i );
    end
  end
  --ld.LogTrace( obj.." "..countmax.." "..diff.." "..count );
  if countmax - diff == count then
    interface.InventoryItemRemove(obj);
    if countmax == 1 then
     else
      --ld.LogTrace( "multi use item deleted" );
      return true
      -- можно вставить свою функцию на проверку возвращаемого заначения true или nil
    end
  end

end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
function public.ObjCreate(obj_name, obj_type, parent, obj_properties)
  ObjCreate(obj_name, obj_type)
  if obj_properties then
    ObjSet(obj_name, obj_properties)
  end
  ObjAttach(obj_name, parent)
end;
--------------------------------------------------------------------------------------
function public.CopyObj(fromname, toname, obj_type, attachto)
  if type(fromname) == "string" and type(toname) == "string" then

    obj_type = obj_type or "spr"
    ObjCreate(toname, obj_type)   -- создание объекта по умолчанию spr

    if type(attachto) == "string" then
      ObjAttach(toname, attachto)
    end                       -- аттач к заданному объекту

    local objtable = {}
    objtable = ObjGet(fromname) -- считывание параметров
    if not objtable then
      ld.LogTrace( "Error in CopyObj: fromname not exist", fromname );
      return
    end
    for i,o in pairs(objtable) do
      if i == "name" then
        objtable[i] = toname  -- присваивание нового имени (чтобы не затереть)
      end
      if type(o) == "boolean" then
        objtable[i] = o and "1" or "0"       -- конвекртирование булевых параметров в строковые 1/0
      end
    end

    ObjSet(toname, objtable); -- установка параметров

  else
    common.LogTrace("Error in ld.CopyObj(): incorrect names or type of names",fromname, toname, obj_type, attachto);
    --a = b + c;
  end
end
--------------------------------------------------------------------------------------
function public.CopyStruct(fromname,count, pos_step) 
  -- ld.CopyStruct("obj_test_1",5) -- добавит 4 копии стуктур с именами obj_test_(2-5)
  --ld.CopyStruct("obj_test_1_1",{2,5}) добавит 2*5-1 = 9 копии стуктур с именами obj_test_1_2..obj_test_1_5,obj_test_2_1..obj_test_2_5
  local function error(n,params)
    local errors = {
--[[1 ]]"pos_step must be table because count is table",
--[[2 ]]"#pos_step ~= 2",
--[[3 ]]"pos_step[1] not number",
--[[4 ]]"pos_step[1] not integer",
--[[5 ]]"pos_step[2] not number",
--[[6 ]]"pos_step[2] not integer",
--[[7 ]]"pos_step not number",
--[[8 ]]"pos_step not integer",
--[[9 ]]"#count ~= 2",
--[[10]]"count[1] not number",
--[[11]]"count[1] not integer",
--[[12]]"count[2] not number",
--[[13]]"count[2] not integer",
--[[14]]"count not number",
--[[15]]"count not integer",
--[[16]]"count < 2",
--[[17]]"fromname not exist",
--[[18]]"struct contains wrong prefix childs, registrate conversion rules",
--[[19]]"toname already exist, set positions only"
    }
    ld.LogTrace( "Error "..n.." in ld.CopyStruct: "..errors[n], params  );
  end

  local rows = 1
  local cols = 1
  local step_x = 0
  local step_y = 0
  local square = type(count) == "table"
  if pos_step then
    if square then
      if type(pos_step) ~= "table" then error(1,pos_step) return end
      if #pos_step~=2 then error(2,pos_step) return end
      if type(pos_step[1]) ~= "number" then error(3,pos_step[1]) return end
      if pos_step[1]~=math.tointeger(pos_step[1]) then error(4,pos_step[1]) return end
      if type(pos_step[2]) ~= "number" then error(5,pos_step[2]) return end
      if pos_step[2]~=math.tointeger(pos_step[2]) then error(6,pos_step[2]) return end
      step_x = pos_step[2]
      step_y = pos_step[1]
    else
      if type(pos_step) ~= "number" then error(7,pos_step) return end
      if pos_step~=math.tointeger(pos_step) then error(8,pos_step) return end      
      step_x = pos_step
    end
  end    
  if square then
    if #count~=2 then error(9,count) return end
    if type(count[1]) ~= "number" then error(10,count[1]) return end
    if count[1]~=math.tointeger(count[1]) then error(11,count[1]) return end
    if type(count[2]) ~= "number" then error(12,count[2]) return end
    if count[2]~=math.tointeger(count[2]) then error(13,count[2]) return end
    rows = count[1] or rows
    cols = count[2] or cols
  else
    if type(count) ~= "number" then error(14,count) return end
    if count~=math.tointeger(count) then error(15,count) return end
    cols = count
  end
  
  count = rows*cols    

  local source_t = ObjGet(fromname)
  if count<2 then error(16,count) return end
  if not source_t then error(17,fromname) return end
  
  local convert = {
    obj = "obj";
    spr = "spr";
    fx  = "partsys";
    txt = "text";
    anm = "anim";
   }
  local root = ObjGetRelations( fromname ).parent
  
  local function getType(s)
    local tp = s:match("^[^_]*")
    local convertedtp = convert[tp]
    local function defaultType()
      error(18, tp.." in "..s );
      ld.LogTrace( s.." copied as obj" );
      return "obj"
    end
    return convertedtp or defaultType()
  end

  local function replaceIdx(s,idx)
    if type(idx) == "table" then
      return s:gsub("1_1(%D*)$",idx[1].."_"..idx[2].."%1")
    else
      return s:gsub("1(%D*)$",idx.."%1")
    end
  end

  local function copy_struct_recursive(name,idx,chroot)
    local toname = replaceIdx(name,idx)
    local obj_type = getType(name)
    if ObjGet(toname) then
      --error(19, toname );
    else
      ld.CopyObj(name, toname, obj_type, chroot)
    end
    if chroot == root then -- если объект верхнего уровня
      local offset = {}
      if type(idx) == "table" then
        offset[1] = (idx[1]-1)*step_y
        offset[2] = (idx[2]-1)*step_x
      else
        offset[1] = 0
        offset[2] = (idx-1)*step_x
      end
      ObjSet( toname, {pos_y = source_t.pos_y + offset[1], pos_x = source_t.pos_x + offset[2]} );
    end
    for k,v in ipairs(ObjGetRelations(name).childs) do
      copy_struct_recursive(v,idx,toname)
    end
  end

  if square then
    for i = 1,rows do
      for j = 1,cols do
        if i == 1 and j == 1 then
          --skipped
        else
          copy_struct_recursive(fromname,{i,j},root)
        end
      end
    end 
  else
    for i = 2,count do
      copy_struct_recursive(fromname,i,root)
    end
  end
end
--------------------------------------------------------------------------------------
----устаревший синтаксис, тип объектов может отличаться(поля параметров возможно тоже)
--function public.CopyObjFull( fromname, attachto, parent )
--
--  obj_type = "spr"
--  local o = ObjGet( fromname )
--  if o.animfunc ~= nil then
--    obj_type = "complexanim"
--  elseif o.looped ~= nil then
--    obj_type = "video"
--  elseif o.frame ~= nil thens
--    obj_type = "anim"
--  elseif o.name:find("^fx_") then
--    obj_type = "partsys"
--  elseif o.name:find("^gfx_") then
--    obj_type = "partsys_gm"
--  elseif o.fontsize ~= nil then
--    obj_type = "text"
--  end;
--  --ld.LogTrace( tostring( fromname ).."\t"..tostring( atachto ).."\t"..tostring( parent ).."\t"..tostring( obj_type ) )
--  if not parent then
--    ld.CopyObj( fromname, fromname.."_copy", obj_type, attachto)
--    local ch = ObjGetRelations( o.name ).childs
--    for i = 1, #ch do
--      ld.CopyObjFull( ch[i], fromname.."_copy", fromname.."_copy" )
--    end;
--  else
--    ld.CopyObj( fromname, fromname.."_copy", obj_type, attachto)
--  end;
--end;
--------------------------------------------------------------------------------------
function public.StartTimer( timer_name, time, endtrig, locked )  --- 2 (time, endtrig) or 3 ( timer_name, time, endtrig )
  if type(timer_name) == "number" or type(timer_name) == "nil" then
    time,endtrig,locked = timer_name,time,endtrig
    repeat
      timer_name = "tmr_global_temp_timer_"..math.random(1,100000)
    until not ObjGet(timer_name)
  end
  time = tonumber( time )
  if time then
    public.CopyObj("tmr_common_timer", timer_name, "timer", "cmn_timers")
    --ld.LogTrace( timer_name );
    if locked then ld.Lock(1) end
    ObjSet( timer_name, { time = time, endtrig =  function () 
      ObjDelete(timer_name);
      if locked then ld.Lock(0) end; 
      if endtrig then
        endtrig()
      end
    end , playing = 1 } );
  else
    if endtrig then
      endtrig()
    end
  end
end
--function public.StartTimer( timer_name, time, endtrig, locked )  --- 2 (time, endtrig) or 3 ( timer_name, time, endtrig )
--  if type(timer_name) == "number" then
--    time,endtrig,locked = timer_name,time,endtrig
--    repeat
--      timer_name = "tmr_global_temp_timer_"..math.random(1,10000)
--    until not ObjGet(timer_name)
--  end
--  time = tonumber( time )
--  public.CopyObj("tmr_common_timer", timer_name, "timer", "cmn_timers")
--  --ld.LogTrace( timer_name );
--  if locked then ld.Lock(1) end
--  ObjSet( timer_name, { time = time, endtrig =  function () 
--    ObjDelete(timer_name);
--    if locked then ld.Lock(0) end; 
--    if endtrig then
--      endtrig()
--    end
--  end , playing = 1 } );
--end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
function public.ShCur(cursor_type)
  
  if ( ng_global.gamemode < 3 ) or (ng_global.gamemode == 3 and ng_global.gamemode_custom[ "cursor" ]) then -- если отображение курсоров включено
    --if prg.current == "std" and ld.CheckRequirements( {"get_mouse"} ) and not ld.CheckRequirements( {"use_elf_sewingtable"} ) then 
    --  if (cursor_type == "CURSOR_HELPER1" or cursor_type == CURSOR_HELPER1) then
    --    SetCursor( CURSOR_HELPER2 );
    --  elseif (cursor_type == "CURSOR_HELPER1_HOWER" or cursor_type == CURSOR_HELPER1_HOWER) then
    --    SetCursor( CURSOR_HELPER2_HOWER );
    --  elseif (cursor_type == "CURSOR_HELPER1_DRAG" or cursor_type == CURSOR_HELPER1_DRAG) then
    --    SetCursor( CURSOR_HELPER2_DRAG );
    --  else
    --    SetCursor( cursor_type );
    --  end
    --elseif prg.current == "ext" and ld.CheckRequirements( {"get_fairyext"} ) then 
    --  if (cursor_type == "CURSOR_HELPER1" or cursor_type == CURSOR_HELPER1) then
    --    SetCursor( CURSOR_HELPER3 );
    --  elseif (cursor_type == "CURSOR_HELPER1_HOWER" or cursor_type == CURSOR_HELPER1_HOWER) then
    --    SetCursor( CURSOR_HELPER3_HOWER );
    --  elseif (cursor_type == "CURSOR_HELPER1_DRAG" or cursor_type == CURSOR_HELPER1_DRAG) then
    --    SetCursor( CURSOR_HELPER3_DRAG );
    --  else
    --    SetCursor( cursor_type );
    --  end
    --else
    if cursor_type == CURSOR_HELPER1 then -- Если курсор пытаемся показать до взятия помощника - выводить обычный USE
      if ObjGet("int_helper") and ObjGet("int_helper").input then
      else
        cursor_type = CURSOR_USE
      end
    end

    if prg.current == "ext" then -- в бонусе переключаем курсор на бонусного помощника
      if cursor_type == CURSOR_HELPER1 then
        cursor_type = CURSOR_HELPER2
      end
      if cursor_type == CURSOR_HELPER1_DRAG then
        cursor_type = CURSOR_HELPER2_DRAG
      end
      if cursor_type == CURSOR_HELPER1_HOWER then
        cursor_type = CURSOR_HELPER2_HOWER
      end
    end

    SetCursor( cursor_type );
    --end
  else
    SetCursor( CURSOR_DEFAULT );
  end
end;

  --SoundSfx                  = public.SoundSfx;
  --SoundEnv                  = public.SoundEnv;
  --SoundTheme                = public.SoundTheme;

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
-- Доп Эвенты комнат и зз
private.ZRMevents = {

  PreOpenBefore = {};
  PreOpenAfter = {};

  OpenBefore = {};
  OpenAfter = {};

  PreCloseBefore = {};
  PreCloseAfter = {};

  CloseBefore = {};
  CloseAfter = {};

}
-- доавляет функцию в Доп Эвенты комнат и зз ( event >> "PreOpenBefore", "PreOpenAfter", ... )
function public.ZRMeventAdd( event, zrm, func )
  private.ZRMevents[ event ][ zrm ] = private.ZRMevents[ event ][ zrm ] or {}
  table.insert( private.ZRMevents[ event ][ zrm ], func )
end
--запускаем функции Доп евента для комнаты или зз
function public.ZRMeventRun( event, zrm )
  if private.ZRMevents[ event ][ zrm ] then
    for k, v in ipairs( private.ZRMevents[ event ][ zrm ] ) do
      --ld.LogTrace( k, event, zrm )
      v();
    end;
  end;
end
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

private.SoundPlays = { 
  sfx = {}; 
  env = {};
  soundtrack = {};
  voice  = {};
}
private.SoundPath = "assets/audio/"

-- вызов и проигрование SFX-трека, если указан параметр add, выключаться другие проигрываемые енвы не будут
-- name = 0 or nil -> выключаются все sfx
-- fade < 0 -> если он проигрывается, выключаться не будет, запустится поверх
function public.SoundSfx( name, fade, strim, loop )
  if name and type( name ) == "string" and name:find( "_mus$" ) and not fade and not strim then
    ld.LogTrace( "WARNING: SoundTheme run as SFX >> "..name )
    public.SoundTheme( name, fade );
    return
  end;
  local plays = private.SoundPlays.sfx;
  if not name or name == 0 then
    --выключаем весь запускавшийся sfx
    local fade = fade or 0.5
    for k, v in pairs( plays ) do
      SndStop( private.SoundPath..k, fade )
      plays[ k ] = nil;
    end
  else
    --local fade = fade or 0
    if plays[ name ] and fade and fade >= 0 then
      --отключаем проигрываемый звук
      SndStop( private.SoundPath..name )
    elseif fade == -1 then
      fade = 0;
    end;
    fade = fade or 0
    --включаем новый трек
    public.SoundFileCheck( name )
    SndPlay( private.SoundPath..name, "sfx", loop or 0, strim and 0 or 1, fade )
    plays[ name ] = true;
  end
end;

  function public.SoundSfxStop( name, fade )
    private.SoundPlays.sfx[ name ] = false;
    SndStop( private.SoundPath..name, fade or 0.25 )
  end
  function public.SoundSfxPause( name, status )
    ne.snd.SndPause(private.SoundPath..name,status);
  end
  -- проверка проигрывается ли сейчас данный звук name 
  function public.SoundIsPlaying(name)
    return ne.snd.SndIsPlaying( private.SoundPath..name);
  end
  -- для мг/ммг: при быстрых кликах нужно воспроизводить звуки кликов не каждый раз,
  -- пример использования:
  --  if SoundSfxTick( "aud_clk_wood_fragment" ) then
  --    SoundSfx ( "aud_clk_wood_fragment" )
  --  end
  function public.SoundSfxTick( name, t )
    local tmr_name = "tmr_sound_tick_"..name;
    if ObjGet(tmr_name) then
      return false;
    else
      t = t or 0;
      ld.StartTimer( tmr_name, t, function() end )
      return true;
    end
  end
  -- для мг/ммг: запускает звук в режиме поверх текущего, не чаще чем раз в тик/t
  -- num_from, num_to - используется для проигрывания звука с рандомным номером на конце имени
  -- при наличии только 3х параметров, параметр "t" "игнорится"
  function public.SoundSfxGame( name, t, num_from, num_to )
    local sfx_name = name
    if num_from ~= nil then
      if num_to == nil then
        num_from, num_to = t, num_from
        t = nil
      end
      sfx_name = sfx_name..math.random( num_from, num_to )
    end
    t = t or 0.04
    if public.SoundSfxTick( name, t ) then
      SoundSfx( sfx_name, -1 )
      return true
    end
    return false
  end

  function public.SoundVid( name, fade)
    SoundTheme( 0 )
    if name and type( name ) == "string" then
      name = name:gsub("^vid_","aud_");
    end
    if name == 0 then
      public.SoundBackTheme( true );
    end
    public.SoundSfx( name, fade, true )
  end;

  -- вызов и проигрование энвайромент-трека, если указан параметр add, выключаться другие проигрываемые енвы не будут
  -- name = 0 or nil -> выключаются все енвы
  -- add =  1 -> включается дополнительный енв name
  -- add =  0 -> выключается только дополнительный енв name
  -- add = -1 -> выключается/включаются все енвы и включается/выключается дополнительный енв name
  -- prg_true -> для add == 1 -> енв включится при ld.CheckRequirements( prg_true ) == true
  -- prg_false-> для add == 1 -> енв включится при ld.CheckRequirements( prg_false ) == false
  function public.SoundEnv( name, add, prg_true, prg_false )
    local plays = private.SoundPlays.env;
    if not name or name == 0 then
      for k, v in pairs( plays ) do
        SndStop( private.SoundPath..k, 1 )
        plays[ k ] = nil;
      end
    else
      local fade = fade or 0
      if not add then
        --public.SoundEnv( 0 )
        for k, v in pairs( plays ) do
          if k ~= name then
            SndStop( private.SoundPath..k, 1 )
            plays[ k ] = nil;
          end
        end
      end;
      if not add then
        if not plays[ name ] then
          public.SoundFileCheck( name )
          SndPlay( private.SoundPath..name, "env", 1, 0, 0.75 )
          plays[ name ] = true;
        end
      elseif add == 1 then
        if plays[ name ] ~= true
        and ( not prg_true and true or ld.CheckRequirements( prg_true ) )
        and ( not prg_false and true or not ld.CheckRequirements( prg_false ) )
        then
          --ld.LogTrace( 1, private.SoundPath..name  )
          public.SoundFileCheck( name )
          SndPlay( private.SoundPath..name, "env", 1, 0, 0.75 )
          plays[ name ] = true;
        end
      elseif add == 0 then
        if plays[ name ] == true then
          --ld.LogTrace( 0, private.SoundPath..name  )
          SndStop( private.SoundPath..name, 0.75 )
          plays[ name ] = nil;
        end
      elseif add == -1 then
        --смена включенных енвов на другой и обратно
        if plays[ name ] == false then
          SndStop( private.SoundPath..name, 1 )
          for k, v in pairs( plays ) do
            public.SoundFileCheck( name )
            SndPlay( private.SoundPath..k, "env", 1, 0, 0.75 )
          end
        else
          for k, v in pairs( plays ) do
            SndStop( private.SoundPath..k, 1 )
          end
          public.SoundFileCheck( name )
          SndPlay( private.SoundPath..name, "env", 1, 0, 0.75 )
          plays[ name ] = false
        end;
      end;
    end
  end;

  -- подписка енвов окружения
  -- name -> имя енва
  -- owners - "zz" или "rm" или { "ZZ" } или { "RM", "ZZinRM_1", "ZZinRM_n"}
  -- prg_true -> енв включится при ld.CheckRequirements( prg_true ) == true
  -- prg_false-> енв включится при ld.CheckRequirements( prg_false ) == FALSE
  public.SoundEnvInitList = {}
  function public.SoundEnvInit( name, owners, prg_true, prg_false )
    --отложенная подписка
    table.insert( public.SoundEnvInitList, { name=name, owners=owners, prg_true=prg_true, prg_false=prg_false } )
  end
  public.SoundEnvInitAll = function( name, owners, prg_true, prg_false )
    --запуск подписки, вызывать после SmartHintInit
    for i, o in ipairs( public.SoundEnvInitList ) do
      public.SoundEnvInitNow( o.name, o.owners, o.prg_true, o.prg_false )
    end
  end;
  public.SoundEnvInitNow = function( name, owners, prg_true, prg_false )
  
    if prg_false and ld.CheckRequirements( prg_false ) then
      --не подписываемся за ненадобностью
    else

      if type( owners ) == "string" then
        if owners:find( "^zz_" ) or not public.smart_hint_connections[ owners ] then
          owners = { owners }
        else
          owners = { owners }
          for i, o in pairs( public.smart_hint_connections[ owners[ 1 ] ] ) do
            table.insert( owners, o )
          end;
        end
      end

      public.ZRMeventAdd( "PreOpenAfter", owners[ 1 ], function() public.SoundEnv( name, 1, prg_true, prg_false ); end )
      public.ZRMeventAdd( "PreCloseAfter", owners[ 1 ], function() public.SoundEnv( name, 0 ); end )

      for i = 2, #owners do
        public.ZRMeventAdd( "PreOpenAfter", owners[ i ], function() public.SoundEnv( name, 0 ); end )
        public.ZRMeventAdd( "PreCloseAfter", owners[ i ], function() public.SoundEnv( name, 1, prg_true, prg_false ); end )
      end;

    end

  end;
  
  -- выключение.включенте проигрываемых энвов
  -- value = 1 выключение энвов
  -- value != 1 включение энвов
  function public.SoundEnvHide(value) -- 1-hide, not 1-play
    local plays = private.SoundPlays.env;
    if value==1 then 
      for k, v in pairs( plays ) do
         SndStop( private.SoundPath..k, 1 )
      end
    else
      for k, v in pairs( plays ) do
         SndPlay( private.SoundPath..k, "env", 1, 0, 1 )
      end
    end;  
  end; 

  -- вызов и проигрование Voice-трека, перед проигрыванием стопятся остальные войсы
  -- name = 0 or nil -> выключаются все Voice
  function public.SoundVoice( name, fade )
    local plays = private.SoundPlays.voice;
    if not name or name == 0 then
      --выключаем весь запускавшийся sfx
      local fade = fade or 0.5
      for k, v in pairs( plays ) do
        SndStop( private.SoundPath..k, fade )
        plays[ k ] = nil;
      end
    else
      local fade = fade or 0
      SoundVoice( 0 )
      public.SoundFileCheck( name )
      SndPlay( private.SoundPath..name, "voice", 0, 0, fade )
      plays[ name ] = true;
    end
  end;
  private.music_shift_time = 2;
  -- вызов и проигрование "звуковая тема"-трека
  -- name = 0 or nil -> выключаются все темы
  function public.SoundTheme( name, loop )

    ObjDelete( "tmr_sound_theme" )
    loop = loop and 1 or 0;

    --ld.LogTrace( "===========  function public.SoundTheme( name, loop ) common_impl string 5666 >>  SoundTheme", name, loop )
    --if name == 0 then
    --  local a = b + c
    --end

    local plays = private.SoundPlays.soundtrack;
    if not name or name == 0 then
      for k, v in pairs( plays ) do
        SndStop( private.SoundPath..k, private.music_shift_time )
        plays[ k ] = nil;
      end
      private.SoundThemePlaying = false
      private.SoundBackThemePlaying = false
    else
      if not ne.file.IsExist( private.SoundPath..name..".ogg" ) then
        name = "reserved/"..name
      end

      if not plays[ name ] then

        for k, v in pairs( plays ) do
          SndStop( private.SoundPath..k, private.music_shift_time )
          plays[ k ] = nil;
        end

        public.SoundFileCheck( name )
        SndPlay( private.SoundPath..name, "soundtrack", loop, 1, private.music_shift_time )

        if loop == 0 then
          if private.SoundHoThemePlaying then
            ld.StartTimer( "tmr_sound_theme", private.SoundThemeTimes[ name ] or 120, function() 
              --ld.LogTrace( "tmr_sound_theme 11111" )
              public.SoundHoTheme( true )
            end )
          elseif private.SoundMgThemePlaying then
            ld.StartTimer( "tmr_sound_theme", private.SoundThemeTimes[ name ] or 120, function() 
              --ld.LogTrace( "tmr_sound_theme 11111" )
              public.SoundMgTheme( true )
            end )
          else
            if private.SoundBackThemeEnabled then
              ld.StartTimer( "tmr_sound_theme", private.SoundThemeTimes[ name ] or 120, function() 
                --ld.LogTrace( "tmr_sound_theme 22222" )
                private.SoundBackThemePlaying = false
                public.SoundBackTheme( true )
              end )
            end
          end
        end

        plays[ name ] = true;
      end;
      private.SoundThemePlaying = true
    end
    --ld.LogTrace( ObjGet( "tmr_sound_theme" ) )
  end;


  --тайминги муз треков
  private.SoundThemeTimes = {

    aud_track1_mus_env = 60*4 + 55;
    aud_track2_mus_env = 60*6 + 27;
    aud_track3_mus_env = 60*5 + 29;
    aud_track4_mus_env = 60*6 + 22;
    aud_track5_mus_env = 60*3 + 53;
    --aud_track6_mus_env = 60*1 + 42;
    --aud_track7_mus_env = 60*2 + 10;
    --aud_track8_mus_env = 60*2 + 20;
    --aud_track9_mus_env = 60*2 + 40;
    --aud_track10_mus_env = 60;
    --aud_track11_mus_env = 57;
    --aud_track12_mus_env = 77;
    --aud_track13_mus_env = 134;
    
    aud_maintheme_mus = 60*2 + 26;
    aud_ho_mus = 60*2 + 41;
    aud_mg_mus = 60*2 + 32;

    aud_worry_mus = 24;

  }

  function public.SoundHoTheme( play )
    --ld.LogTrace( "SoundHoTheme", play )
    if play == nil or play == true then
        play = true
    else
        play = false
    end
    local themes = { 
      "aud_ho_mus";
    }
    if play then
      if #themes == 1 then
        if not private.SoundHoThemePlaying then
          private.SoundHoThemePlaying = 1
          SoundTheme( themes[ private.SoundHoThemePlaying ], 1 )
        end
      else
        private.SoundHoThemePlaying = private.SoundHoThemePlaying or 0
        private.SoundHoThemePlaying = private.SoundHoThemePlaying + 1
        private.SoundHoThemePlaying = private.SoundHoThemePlaying > #themes and 1 or private.SoundHoThemePlaying
        SoundTheme( 0 )
        SoundTheme( themes[ private.SoundHoThemePlaying ] )
      end
    else
      private.SoundHoThemePlaying = false
      SoundTheme( 0 )
      private.SoundBackThemePlaying = false
      public.SoundBackTheme( true )
    end;
    return true;
  end;

  function public.SoundMgTheme( play )
    --ld.LogTrace( "SoundMgTheme", play )
    if ( play == nil ) or ( play == true ) then
        play = true
    else
        play = false
    end
    local themes = { 
      "aud_mg_mus";
    }
    if play then
      if #themes == 1 then
        if not private.SoundMgThemePlaying then
          private.SoundMgThemePlaying = 1
          SoundTheme( themes[ private.SoundMgThemePlaying ], 1 )
        end
      else
        private.SoundMgThemePlaying = private.SoundMgThemePlaying or 0
        private.SoundMgThemePlaying = private.SoundMgThemePlaying + 1
        private.SoundMgThemePlaying = private.SoundMgThemePlaying > #themes and 1 or private.SoundMgThemePlaying
        SoundTheme( 0 )
        SoundTheme( themes[ private.SoundMgThemePlaying ] )
      end
    else
      private.SoundMgThemePlaying = false
      SoundTheme( 0 )
      private.SoundBackThemePlaying = false
      public.SoundBackTheme( true )
    end;
    return true;
  end;

  private.SoundBackThemeEnabled = true
  function public.SoundBackThemeOn( play )
    private.SoundBackThemePlaying = not play
    private.SoundBackThemeEnabled = play
  end
  function public.SoundBackTheme( play )
    --ld.LogTrace( "public.SoundBackTheme()",private.SoundHoThemePlaying, private.SoundMgThemePlaying );
    if private.SoundBackThemeEnabled and ( not private.SoundHoThemePlaying ) and ( not private.SoundMgThemePlaying ) then
        --ld.LogTrace( "SoundBackTheme", play )
      --ld.LogTrace( "SoundBackTheme 1", play, private.SoundBackThemePlaying )
      if play == nil or play == true then

        if private.SoundBackThemePlaying then

          return false

        else

          play = true

        end;

      else

        if not private.SoundBackThemePlaying then

          return false

        else

          play = false

        end

      end
      --треки для фонового проигрывания
      local themes = { 
        "aud_track1_mus_env";
        "aud_track2_mus_env";
        "aud_track3_mus_env";
        "aud_track4_mus_env";
        --"aud_track5_mus_env";
        --"aud_track6_mus_env";
        --"aud_track7_mus_env";
        --"aud_track8_mus_env";
        --"aud_track9_mus_env";
        --"aud_track10_mus_env";
        --"aud_track11_mus_env";
        --"aud_track12_mus_env";
        --"aud_track13_mus_env";
      }

      if #themes > 0 then

        if play then

          SoundTheme( 0 )

          local rnd = math.random( 1, #themes )
          if private.SoundBackThemePlaying_rnd_old == rnd then
            rnd = rnd + 1
            if rnd > #themes then
              rnd = 1
            end
          end
          private.SoundBackThemePlaying_rnd_old = rnd

          private.SoundBackThemePlaying = themes[ rnd ]


          SoundTheme( private.SoundBackThemePlaying )

        else

          SoundTheme( 0 )

        end;
        --ld.LogTrace( "SoundBackTheme 2", play, private.SoundBackThemePlaying )
        return true;

      else

        return false

      end

    end
  end

  function public.PlayGetSound()
    --ld.LogTrace( "PlayGetSound()" )
    if not ObjGet( "tmr_play_get_sound" ) then
      public.SoundFileCheck( "reserved/aud_get_inv_sfx" )
      SndPlay( private.SoundPath.."reserved/aud_get_inv_sfx", "sfx", 0, 1, 0 )
      ld.StartTimer( "tmr_play_get_sound", 0, function()  end )
    end
  end;


  function public.SoundFileCheck( aud )
    if ld.IsLdCheater() and ne.GetTestMode() == 1 then
      if not ne.file.IsExist( private.SoundPath..aud..".ogg" ) then
        ld.LogTrace( "ERROR: aud file not exist", aud )
      end
    end
  end
  
--------
--ХО частицы над объектом с его последующим удалением
function public.FxAnmObj( object_name, with_no_delete, anim_table )
  local func_end = function()
    -- ld.Lock(0)
    if with_no_delete then
      ObjSet( object_name, {input = 0, visible = 0, active = 0} );
    else
      ObjDelete(object_name)
    end
    --ObjDetach( object_name )
  end
  local o = ObjGet(object_name)
  if not o then return; end
  if not o.visible or not o.active then return end
    
  ObjSet( object_name, {pos_z = 1,input = false} );
  local collect_pos = GetObjPosByObj( object_name, InterfaceWidget_Top_Name );
  local collect_ang = GetObjAngByObj( object_name, InterfaceWidget_Top_Name );  
  local collect_drawoff_x = ObjGet( object_name ).drawoff_x;
  local collect_drawoff_y = ObjGet( object_name ).drawoff_y;

  local collect_name  = "fx_item_name_collect_"..object_name;

  if not ObjGet( "tmr_common_impl_fx_anm_obj" ) then
    SoundSfxGame("reserved/aud_hide", 0.05)
    ld.StartTimer( "tmr_common_impl_fx_anm_obj", 0, function()  end )
  end

  ObjAttach( object_name, InterfaceWidget_Top_Name );
  ObjSet( object_name ,{ pos_x = collect_pos[1], pos_y = collect_pos[2],input=0,ang = collect_ang });
  if ObjGet(collect_name) then ObjDelete(collect_name) end
  ObjCreate( collect_name, "partsys" );
  
  ObjSet( collect_name,
  {
    res = "assets/interface/resources/fx/effects_ho",
    pos_x = collect_drawoff_x, pos_y = collect_drawoff_y,
    active = 1, visible = 1, input = 0, pos_z = 10
  } );

  ObjAttach( collect_name, InterfaceWidget_Top_Name );
  ObjSet(collect_name, {blendmode = 2,pos_z = 50});
  ld.StartTimer( 5, function() ObjDelete( collect_name ) end )
  
  local anim_table_default = 
  { 
      0.0, 0, 1,
      0.3, 0, 1,
      0.6, 0, 0
  }
  anim_table = anim_table or anim_table_default 

  PartSysSetMaskObj( collect_name, object_name );  
  ObjAnimate( object_name, "alp",0,0, func_end, anim_table   );
end


--проиграть хо частицы над объектом по маске
function public.FxBlickAnmObj( object_name, with_sound, resource, dont_clear_particle )

  local parent = ObjGetRelations(object_name).parent;
  local o = ObjGet(object_name);      
  local res = resource or "assets/interface/resources/fx/effects_ho_fly"

  if with_sound then
    if not ObjGet( "tmr_common_impl_fxblick_anm_obj" ) then
      SoundSfxGame("reserved/aud_hide", 0.05)
      ld.StartTimer( "tmr_common_impl_fxblick_anm_obj", 0, function()  end )
    end
  end
  
  local collect_name  = "fx_item_name_collectblick_"..object_name;
  if ObjGet(collect_name) then ObjDelete(collect_name) end
  ObjCreate( collect_name, "partsys" );   
  ObjSet( collect_name,
  {
    res = res,
    pos_x = o.drawoff_x, pos_y = o.drawoff_y;
    active = 1, visible = 1, input = 0, pos_z = (o.pos_z)+1, blendmode = 2,
  } );
  ObjAttach( collect_name, parent );
  local tmr_name  = "tmr_item_name_collectblick_"..object_name;
  if ObjGet(tmr_name) then ObjDelete(tmr_name) end
  if not dont_clear_particle then
    ld.StartTimer( tmr_name, 5, function() ObjDelete( collect_name ) end )
  end
  
  PartSysSetMaskObj( collect_name, object_name );  

  if dont_clear_particle then
    return collect_name
  end
end

function public.FxBlick(target, resource, root)
  root = root or InterfaceWidget_Top_Name;
  if not resource then
    resource = "assets/interface/resources/fx/effects_ho_fly2"
  else
    if not string.find(resource,"assets/interface/resources") then
      root = resource
      resource = "assets/interface/resources/fx/effects_ho_fly2"
    end
  end;
  --resource = resource or "assets/interface/resources/fx/effects_ho_fly2";
  
  local name_suffix;
  local pos;
  if target then
    if type(target) == "table" then
    pos = target;
    name_suffix = pos[1].."_"..pos[2]
    else
    pos = GetObjPosByObj(target,root);
    name_suffix = target;
    end;
  else
  pos = {0,0};
  name_suffix = pos[1].."_"..pos[2]
  end
    
  local collect_name  = "fx_blick_"..name_suffix;
  if ObjGet(collect_name) then ObjDelete(collect_name) end
  ObjCreate( collect_name, "partsys" );
  
  ObjSet( collect_name,
  {
    res = resource,
    active = 1, visible = 1, input = 0, pos_z =999, blendmode = 2,pos_x=pos[1],pos_y=pos[2],
    } );
  ObjAttach( collect_name, root ); 
  
  local tmr_name  = "tmr_blick_"..name_suffix;
  if ObjGet(tmr_name) then ObjDelete(tmr_name) end
  ld.StartTimer( tmr_name, 2, function() ObjDelete( collect_name ) end )
end
--подписка на функционал зума ММГ
--имя зоны зума "obj_"..common_impl.hint[ prg ].zz:gsub("^zz_","").."_"..prg.."_zoom"
--  obj_ZZ_PRG_zoom
function public.mmgZoomInit( prg, sfx_zoom_in, sfx_zoom_out, prg_off_init ) --Марат: добавил "prg_off_init" - прогресс после которого не будет инициализации(по умолчанию win_<имя ммг>)
  prg_off_init = prg_off_init or prg
  if not ld.CheckRequirements( { prg_off_init } ) then
    private.mmgZoomInitSfx = private.mmgZoomInitSfx or {}
    private.mmgZoomInitSfx[ prg ] = { sfx_zoom_in = sfx_zoom_in; sfx_zoom_out = sfx_zoom_out }
    local hnt = common_impl.hint[ prg ];
    local obj = "obj_"..hnt.zz:gsub("^zz_","").."_"..prg.."_zoom";
    ObjSet( obj, { 
      event_menter = function() public.mmgZoomMenter( prg ) end;
      event_mleave = function() public.mmgZoomMleave( prg ) end;
      event_mdown  = function() public.mmgZoomMdown(  prg ) end;
      inputrect_init = true;
      inputrect_x = -1024;
      inputrect_y = -1024;
      inputrect_w = 2048;
      inputrect_h = 2048;
      input = false;
      visible = false;
      alp = 0;
    } )

    --if _G[hnt.zz].Close then
    --  local close = _G[hnt.zz].Close
    --  _G[hnt.zz].Close = function() close(); public.mmgZoomReset( prg ) end
    --else
    --  _G[hnt.zz].Close = function() public.mmgZoomReset( prg ) end
    --end;
    public.ZRMeventAdd( "CloseAfter", hnt.zz, function() public.mmgZoomReset( prg ) end )

    local obj = "gfx_"..hnt.zz:gsub("^zz_","").."_"..prg.."_zone";
    ObjSet( obj, { 
      event_menter = function() ld.ShCur(CURSOR_LOUPE) end;
      event_mleave = function() ld.ShCur(CURSOR_DEFAULT) end;
      event_mdown  = function() public.mmgZoomShow( prg ) end;
    } )
  else

  end
end;

public.mmgZoomMenter = function( prg )
  ld.ShCur(CURSOR_DOWN)
end
public.mmgZoomMleave = function( prg )
  ld.ShCur(CURSOR_DEFAULT)
end
public.mmgZoomMdown = function( prg )
  public.mmgZoomShow( prg )
end
private.mmgZoomEvents = function( event, prg )
  if common_impl.hint[prg] and _G[common_impl.hint[prg].room][prg.."_"..event] then
    _G[common_impl.hint[prg].room][prg.."_"..event]()
  end
end
public.mmgZoomShow = function( prg )
  local hnt = common_impl.hint[ prg ];
  local obj = "gfx_"..hnt.zz:gsub("^zz_","").."_"..prg.."_zone";
  local o = ObjGet( "obj_"..hnt.zz:gsub("^zz_","").."_"..prg.."_zoom" )
  local t = 0.5
  ld.LockCustom( "mmgzoom", 1 )
  if o.input then
    ObjAnimate( o.name, 8,0,0, function() private.mmgZoomEvents("close",prg) ld.LockCustom( "mmgzoom", 0 ) ObjSet( o.name, { visible = false, clear_bake = 1, bake = 0 } ) end, { 0,0,o.alp, t,0,0 } )
    ObjSet( o.name, { input = false, bake = 1 } )
    ObjSet( obj, { input = true } )
    public.UseItemLock = false;

    if private.mmgZoomInitSfx[ prg ].sfx_zoom_out then
      SoundSfx( private.mmgZoomInitSfx[ prg ].sfx_zoom_out )
    end
    
    local mmg = prg:gsub("^win_","");
    if not ld.CheckRequirements( {prg} ) then
      if not private.mhoZoomInit_zz[prg] then
        cmn.MiniGameHide( mmg );
      end
    end
    private.mmgZoomEvents("preclose",prg)
  else

    ObjSet( o.name, { active=true, input = true, visible = true, bake = 1 } )
    ObjAnimate( o.name, 8,0,0, function() private.mmgZoomEvents("open",prg) ld.LockCustom( "mmgzoom", 0 ) ObjSet( o.name, { clear_bake = 1, bake = 0 } ) end, { 0,0,o.alp, t,0,1 } )
    ObjSet( obj, { input = false } )
    public.UseItemLock = true;
    
    if private.mmgZoomInitSfx[ prg ].sfx_zoom_in then
      SoundSfx( private.mmgZoomInitSfx[ prg ].sfx_zoom_in )
    end

    local mmg = prg:gsub("^win_","");
    if not ld.CheckRequirements( {prg} ) then
      if not private.mhoZoomInit_zz[prg] then
        cmn.MiniGameShow( mmg ); 
      end
    end
    private.mmgZoomEvents("preopen",prg)
  end;
end
public.mmgZoomReset = function( prg )
  local hnt = common_impl.hint[ prg ];
  if ObjGet( "obj_"..hnt.zz:gsub("^zz_","").."_"..prg.."_zoom" ).input then
    ObjSet( "obj_"..hnt.zz:gsub("^zz_","").."_"..prg.."_zoom", { alp = 0; input = false } )
    ObjSet( "gfx_"..hnt.zz:gsub("^zz_","").."_"..prg.."_zone", { input = true } )
    public.UseItemLock = false;
  end
end

private.mhoZoomInit_zz={}
function public.mhoZoomInit( prg, sfx_zoom_in, sfx_zoom_out, prg_off_init )
  private.mhoZoomInit_zz = private.mhoZoomInit_zz or {};
  private.mhoZoomInit_zz[prg]=true
  public.mmgZoomInit( prg, sfx_zoom_in, sfx_zoom_out, prg_off_init )
end;

private.notesActiveInScr = {}
function public.NoteSetActiveInScr(closed)
  private.notesActiveInScr[closed]=true;
end
function public.NoteUnSetActiveInScr(closed)
  private.notesActiveInScr[closed]=false;
end

private.notes_initialized_arr = {}
private.notes_initialized_loc = {}
--подписка на функционал записки
--closed - лежащая записка
--opened - открывающаяся записка
--bbt_reaction - если таблица - в ней должны быть указаны 
----{ func_preopen = function()  end;  func_open = function()  end; func_close = function()  end; func_preclose = function()  end;} - запускаем, иначе - ld.ShowBbt( bbt_reaction )
--bbt_reaction - если функция - запускаем, иначе - ld.ShowBbt( bbt_reaction )
--sfx_open - звук на открытие отличающийся от стандартного
--sfx_close - звук на закрытиу отличающийся от стандартного
--close_init - не юзать - используется для сброса состояния
function public.NoteInit( closed, opened, bbt_reaction, sfx_open, sfx_close, close_init )
  if ng_global.currentprogress == "exp" then
    ObjSet( closed, {input=0} );
    ObjSet( opened, {alp=0,input=0} );
    return
  end
  if not private.notes_initialized_arr[closed..""..opened] then
    local owner = public.ObjGetOwnerZzRmMgHo( closed )
    private.notes_initialized_loc[ owner ] = private.notes_initialized_loc[ owner ] and ( private.notes_initialized_loc[ owner ] + 1 ) or 1;
    private.notes_initialized_arr[closed..""..opened] = {
      ObjGet(closed).event_mdown or function() end;
      ObjGet(opened).event_mdown or function() end;
    };
  end
  if not public.NoteInitLetters then
    public.NoteInitLetters = {};
    ObjCreate( "spr_note_init_black_back", "spr" )
    ObjSet( "spr_note_init_black_back", { 
      input = true;
      alp = 0;
      res = "assets/interface/resources/editor_back";
      color_r = 0; color_g = 0; color_b = 0;
      scale_x = 1024; scale_y = 512;
      event_menter = function() public.NoteMEnter( "hide" ) end;
      event_mleave = function() public.NoteMLeave() end;
      event_mdown  = function() public.NoteHide() end;
    } )
    ObjCreate( "obj_note_init_overlay_back", "obj" )
    ObjSet( "obj_note_init_overlay_back", { 
      input = true;
      inputrect_init = true;
      event_menter = function() public.NoteMEnter( "hide" ) end;
      event_mleave = function() public.NoteMLeave() end;
      event_mdown  = function() public.NoteHide() end;
    } )  
  end;
  if not close_init then
    ObjSet( closed, { 
      event_mdown  = function() private.notes_initialized_arr[closed..""..opened][1]() public.NoteMDown( closed, opened, false, bbt_reaction, sfx_open, sfx_close ) end;
      event_menter = function() public.NoteMEnter( "closed" ) end;
      event_mleave = function() public.NoteMLeave() end;
    } )
    ObjSet( opened, { 
      visible = 1;
      alp = 0;
      event_mdown  = function() private.notes_initialized_arr[closed..""..opened][2]() public.NoteMDown( closed, opened, false, bbt_reaction, sfx_open, sfx_close ) end;
      event_menter = function() public.NoteMEnter( "opened" ) end;
      event_mleave = function() public.NoteMLeave() end;
    } )
  else
    if not public.NoteInitLetters[ closed.."___"..opened ] then
      --подписка производится только после открытия записки
      if interface.GetCurrentComplexInv() == "" then
        local zrm = common.GetCurrentSubRoom() or common.GetCurrentRoom()
        public.NoteInitLetters[ closed.."___"..opened ] = zrm;
        public.ZRMeventAdd( "CloseAfter", zrm, function() public.NoteMDown( closed, opened, true, bbt_reaction ) end )
        if ld.StringDivide(zrm)[1] == "zz" then
          local zzBack = ObjGet(zrm)
          local additionSize = 200
          local dw,dh = zzBack.draw_width + additionSize, zzBack.draw_height + additionSize
          ObjSet( "obj_note_init_overlay_back", {
            inputrect_init = true;
            inputrect_x = -dw/2;
            inputrect_y = -dh/2;
            inputrect_w = dw;
            inputrect_h = dh;
          } );
        end

      else
        local zrm = interface.GetCurrentComplexInv()
        --zrm = ld.StringDivide( zrm )[3];
        --ld.LogTrace( zrm )
        public.NoteInitLetters[ closed.."___"..opened ] = zrm;
        --if level_inv[zrm.."_close"] then
        --  local close = level_inv[zrm.."_close"] 
        --  level_inv[zrm.."_close"]  = function() close(); public.NoteMDown( closed, opened, true, bbt_reaction ) end
        --else
        --  level_inv[zrm.."_close"]  = function()          public.NoteMDown( closed, opened, true, bbt_reaction ) end
        --end;
        public.ZRMeventAdd( "CloseAfter", zrm, function() public.NoteMDown( closed, opened, true, bbt_reaction ) end )
      end
    end;
  end
end;
  --разрешает автовыключение гейта связанного с этой запиской
  function public.NoteRelaseLock( closed )
    if ng_global.currentprogress == "exp" then
      return
    end
    local owner = public.ObjGetOwnerZzRmMgHo( closed )
    private.notes_initialized_loc[ owner ] = private.notes_initialized_loc[ owner ] - 1;
    if private.notes_initialized_loc[ owner ] == 0 then
      private.notes_initialized_loc[ owner ] = false
    end;
  end
  -- для реализации исчезающих записок 
  -- при закрытии, закрытая записка не покажется по альфе
  -- и будет вызвана func_end после анимации
  function public.NoteRemovable( closed, func_end )
    public.NoteRelaseLock( closed )
    private.NoteRemovable_funcs = private.NoteRemovable_funcs or {}
    private.NoteRemovable_funcs[ closed ] = func_end or function( ne_params ) end
  end
  function public.NoteMEnter( obj )
    if ng_global.currentprogress == "scr" then
      return
    end
    if obj == "closed" then
      ld.ShCur(CURSOR_LOUPE)
    elseif obj == "hide" then
      ld.ShCur(CURSOR_HAND)
    else
      ld.ShCur(CURSOR_HAND)
    end;
  end;
  function public.NoteMLeave()
    if ng_global.currentprogress == "scr" then
      return
    end
    ld.ShCur(CURSOR_DEFAULT)
  end;
  function public.NoteHide()
    if public.NoteOpened then
      return ObjGet( public.NoteOpened ).event_mdown();
    end;
  end;
  function public.NoteMDown( closed, opened, reset, bbt_reaction, sfx_open, sfx_close )
    if ng_global.currentprogress == "scr" then
      ObjSet( closed, { input = 0 } )
      return
    end
    local black = ObjGet( "spr_note_init_black_back" )
    local o1 = ObjGet( closed )
    local o2 = ObjGet( opened )
    if reset then
      --ld.LogTrace( "reset 1",o2.input )
      --if o2.input then
        --вызывать в close
        ObjSet( closed, { alp = 1 } )
        ObjSet( opened, { input = 0, alp = 0 } )
        ObjDetach( "spr_note_init_black_back" )
        ObjDetach( "obj_note_init_overlay_back" )
        ObjStopAnimate( "spr_note_init_black_back", 8 )
        ObjSet( "spr_note_init_black_back", { alp = 0 } )

        public.UseItemLock = false;
        public.NoteOpened = false;
      --end;
      --ld.LogTrace( "reset 2",o2 )
      --ld.LogTrace( 4444, ObjGet( "spr_note_init_black_back" ) )
    else
      ld.LockCustom( "noteanim", 1 )
      local t = 0.45
      if o2.input then
        --closing
        
        if type( bbt_reaction ) == "table" then
          if bbt_reaction.func_preclose then
            bbt_reaction.func_preclose()
          end
        end
          
        if sfx_close ~= false then
          SoundSfx( sfx_close or "reserved/aud_paper_close" )
        end
        public.UseItemLock = false;
        public.NoteOpened = false
        --if not public.NoteInitLetters[ closed.."___"..opened ]:find( "^inv_complex_" ) then
          ObjAnimate( black.name, 8,0,0, function() ObjDetach( black.name ) ObjDetach("obj_note_init_overlay_back") end, { 0,3,black.alp, t,3,0 } )
        --end
        if not private.NoteRemovable_funcs or not private.NoteRemovable_funcs[ closed ] then
          ObjAnimate( o1.name, 8,0,0, _, { 0,0,o1.alp, t,2,1 } )
        end
        ObjAnimate( o2.name, 8,0,0, _, { 0,0,o2.alp, t,2,0 } )
        local p = GetObjPosByObj( o1.name, ObjGetRelations( o2.name ).parent )
        ObjAnimate( o2.name, 3,0,0, _, { 0,0,o2.pos_x,o2.pos_y, t,2,p[ 1 ],p[ 2 ] } )
        ObjAnimate( o2.name, 6,0,0, _, { 0,0,1,1, t,2,0.5,0.5 } )
        ld.StartTimer( t, function() 
          ld.LockCustom( "noteanim", 0 );
          ObjSet( o2.name, { input = false, pos_x = o2.pos_x, pos_y = o2.pos_y, scale_x = o2.scale_x, scale_y = o2.scale_y } )
          if private.NoteRemovable_funcs and private.NoteRemovable_funcs[ closed ] then
            private.NoteRemovable_funcs[ closed ]()
          end
          if type( bbt_reaction ) == "table" then
            if bbt_reaction.func_close then
              bbt_reaction.func_close()
            end
          end
        end )
      else
        --opening
        public.NoteInit( closed, opened, bbt_reaction, sfx_open, sfx_close, true )
        if type( bbt_reaction ) == "table" then
          if bbt_reaction.func_preopen then
            bbt_reaction.func_preopen()
          end
        end
        public.NoteOpened = opened
        --if not public.NoteInitLetters[ closed.."___"..opened ]:find( "^inv_complex_" ) then
          ObjAttach( "spr_note_init_black_back", public.NoteInitLetters[ closed.."___"..opened ] )
          ObjSet( "spr_note_init_black_back", { pos_z = o2.pos_z - 0.01 } )
          local zz_name = ld.StringDivide(public.NoteInitLetters[ closed.."___"..opened ])[2]
          if ObjGet("obj_"..zz_name.."_overlay") then
            ObjAttach( "obj_note_init_overlay_back", "obj_"..zz_name.."_overlay" )
            ObjSet( "obj_note_init_overlay_back", { pos_z = o2.pos_z - 0.01 } )
          end
          if common.GetCurrentSubRoom() or interface.GetCurrentComplexInv() ~= "" then
            ObjSet( black.name, { pos_x = 0, pos_y = 0 } )
          else
            ObjSet( black.name, { pos_x = 512, pos_y = 384 } )
          end
          local parent = public.NoteInitLetters[ closed.."___"..opened ]

          --в круглых и оверлейных зз не включать черную подложку под записки(делается через ld.SubRoom.Tint)
          local black_val = (_G[parent] and (_G[parent].isRound or ObjGet("obj_"..zz_name.."_overlay"))) and 0 or t 
          --в ИП не включать черную подложку под записки(?)
          black_val = interface.GetCurrentComplexInv() == "" and black_val or 0

          ObjAnimate( black.name, 8,0,0, _, { 0,3,black.alp, t,3,black_val } )
        --end
        if sfx_open ~= false then
          SoundSfx( sfx_open or "reserved/aud_paper_open" )
        end
        public.UseItemLock = true;
        ObjAnimate( o1.name, 8,0,0, _, { 0,0,o1.alp, t,2,0 } )
        ObjAnimate( o2.name, 8,0,0, _, { 0,0,o2.alp, t,2,1 } )
        local p = GetObjPosByObj( o1.name, ObjGetRelations( o2.name ).parent )
        ObjAnimate( o2.name, 3,0,0, _, { 0,0,p[ 1 ],p[ 2 ], t,2,o2.pos_x,o2.pos_y } )
        ObjAnimate( o2.name, 6,0,0, _, { 0,0,0.5,0.5, t,2,1,1 } )
        ld.StartTimer( t, function() 
          ld.LockCustom( "noteanim", 0 );
          ObjSet( o2.name, { input = true } )
          if bbt_reaction then
            if type( bbt_reaction ) == "function" then
              bbt_reaction()
            elseif type( bbt_reaction ) == "table" then
              if bbt_reaction.func_open then
                bbt_reaction.func_open()
              end
            else
              ld.ShowBbt( bbt_reaction );
            end
          end
        end )
      end;
      return t;
    end;
  end;

-- подписка на функционал статичных видосов
-- vid - имя видео, или {vid_1,...,vid_n}, playing и looped должны быть выключены
---- при использовании {vid_1,...,vid_n}, для ручного вызова команд нужно использовать ссылку на этот массив
-- owners - "zz" or "rm" or { "ZZ" } или { "RM", "ZZinRM_1", "ZZinRM_n"}
-- sfx - имя звука, или {sfx_vid_1,...,sfx_vid_n}, если какой-то видос без звука - false
-- delay - {t_min,t_max} - рандомная пауза между запусками play ( используется анимация угла ); по умолчанию {0,0}
-- prg_true - массив прогрессов после выполнения которых будет запускаться Play; по умолчанию {}
-- prg_false - массив прогрессов после выполнения которых НЕ будет запускаться Play; по умолчанию {}
-- sfx_rnd - массив имён звуков, будут запускаться поверх sfx, по умолчанию false
-- root - нужен если используется {vid_1,...,vid_n} - рут для ObjAttach, по умолчанию "zz" or "rm" or "ZZ" or "RM"
public.VidStaticList = {}
function public.VidStaticInit( vid, owners, sfx, delay, prg_true, prg_false, sfx_rnd, root )

  delay = delay or {0,0};
  prg_true = prg_true or {};
  prg_false = prg_false or false;

  public.VidStaticList[ vid ] = { owners=owners, sfx=sfx, delay=delay, prg_true=prg_true, prg_false=prg_false, sfx_rnd=sfx_rnd, sfx_rnd_now = false, root=root }
  --ld.LogTrace( "VidStaticInit",vid,public.VidStaticList[ vid ] )
end
public.VidStaticInitAll = function()
  for k, v in pairs( public.VidStaticList ) do
    public.VidStaticInitNow( 
      k, 
      v.owners, 
      v.prg_true, 
      v.prg_false 
    );
  end
end
public.VidStaticInitNow = function( vid, owners, prg_true, prg_false )

  if prg_false and ld.CheckRequirements( prg_false ) then
    --не подписываемся за ненадобностью
  else

    if type( owners ) == "string" then
      if owners:find( "^zz_" ) or owners:find( "^inv_complex_" ) or not public.smart_hint_connections[ owners ] then
        owners = { owners }
      else
        owners = { owners }
        if type( public.smart_hint_connections[ owners[ 1 ] ] ) == "string" then
          if public.smart_hint_connections[ owners[ 1 ] ]:find( "^zz_" ) then
            table.insert( owners, public.smart_hint_connections[ owners[ 1 ] ] )
          end
        else
          for i, o in pairs( public.smart_hint_connections[ owners[ 1 ] ] ) do
            if o:find( "^zz_" ) then
              table.insert( owners, o )
            end
          end;
        end
      end
    end

    public.VidStaticList[ vid ].owners = owners
    -- если видосов несколько, то при первом запуске первый видос будет приатачен к руту
    if type( vid ) == "table" and prg_true and ld.CheckRequirements( prg_true ) then
      public.ZRMeventAdd( "PreOpenBefore", owners[1],
        function()
          if not public.VidStaticList[ vid ].now then
            ObjAttach( vid[ 1 ], public.VidStaticList[ vid ].root or public.VidStaticList[ vid ].owners[ 1 ] )
          end;
        end
      );
    end;

    -- RM or ZZ
    public.ZRMeventAdd( "PreOpenBefore", owners[1], function() private.VidStaticCheckDraw( vid, prg_true, prg_false ) end )
    --public.ZRMeventAdd( "OpenBefore", owners[1], function() public.VidStaticPlay( vid, prg_true, prg_false ) end )
    public.ZRMeventAdd( "OpenBefore", owners[1], function() public.VidStaticContinue( vid, prg_true, prg_false ) end )
    public.ZRMeventAdd( "PreCloseBefore", owners[1], function() public.VidStaticPause( vid, prg_true, prg_false ) end )
    --public.ZRMeventAdd( "CloseBefore", owners[1], function() public.VidStaticReset( vid, prg_true, prg_false ) end )
    -- ZZ in RM
    for i = 2, #owners do
      public.ZRMeventAdd( "PreOpenBefore", owners[i], function() public.VidStaticPause( vid, prg_true, prg_false ) end )
      --public.ZRMeventAdd( "OpenBefore", owners[i], function() public.VidStaticReset( vid, prg_true, prg_false ) end )
      public.ZRMeventAdd( "CloseBefore", owners[i], function() public.VidStaticContinue( vid, prg_true, prg_false ) end )
      --public.ZRMeventAdd( "CloseBefore", owners[i], function() public.VidStaticPlay( vid, prg_true, prg_false ) end )
    end;

  end;

end;
private.VidStaticCheck = function( prg_true, prg_false )
  if prg_true then 
    prg_true = ld.CheckRequirements( prg_true )
  else
    prg_true = true;
  end
  if prg_false then 
    prg_false = ld.CheckRequirements( prg_false )
  else
    prg_false = false;
  end
  return prg_true and not prg_false
end;
private.VidStaticGetRndVidName = function( vid, set_next )
  if type( vid ) == "string" then
    return vid
  else
    local vid_now
    local vid_next
    if not public.VidStaticList[ vid ].now then
      public.VidStaticList[ vid ].now = 1
      vid_now = vid[ public.VidStaticList[ vid ].now ]
      vid_next = vid_now
    else
      vid_now = vid[ public.VidStaticList[ vid ].now ]
      if set_next then 
          private.VidStaticSetRndVidName( vid )
      end
      vid_next = vid[ public.VidStaticList[ vid ].now ]
    end
    return vid_now, vid_next
  end
end;
private.VidStaticSetRndVidName = function( vid )
  if type( vid ) == "table" then
    public.VidStaticList[ vid ].now = math.random( 1, #vid )
  end
end;
private.VidStaticGetRndSfxName = function( vid )
  if type( vid ) == "table" and type(public.VidStaticList[ vid ].sfx) == "table" then
    if public.VidStaticList[ vid ].sfx then
      return public.VidStaticList[ vid ].sfx[ public.VidStaticList[ vid ].now ]
    end
  else
    --ld.LogTrace( "sound sfx", public.VidStaticList[ vid ].sfx )
    return public.VidStaticList[ vid ].sfx
  end
end;

  function public.VidStaticPlay( vid, prg_true, prg_false, not_change_vid )
    --ld.LogTrace( "VidStaticPlay 1 ", vid, prg_true, prg_false )
    if private.VidStaticCheck( prg_true, prg_false ) then

      local vid_name, vid_name_next

      if not_change_vid == nil then
        vid_name, vid_name_next = private.VidStaticGetRndVidName( vid, true )
        --ld.LogTrace( 1, vid_name, vid_name_next )
      else
        vid_name = private.VidStaticGetRndVidName( vid, false )
        vid_name_next = vid_name
        --ld.LogTrace( 2, vid_name, vid_name_next )  
      end
      local dt = math.random( public.VidStaticList[ vid ].delay[1] * 100, public.VidStaticList[ vid ].delay[2] * 100 ) / 100
      VidStop( vid_name )
      if public.VidStaticList[ vid ].sfx_rnd then
        public.VidStaticList[ vid ].sfx_rnd_now = public.VidStaticList[ vid ].sfx_rnd[ math.random( 1, #public.VidStaticList[ vid ].sfx_rnd ) ];
        if public.VidStaticList[ vid ].sfx_rnd_now then
          --ld.LogTrace( "vid static play sfx rdn:",public.VidStaticList[ vid ].sfx_rnd_now );
          SndPlay( "assets/audio/"..public.VidStaticList[ vid ].sfx_rnd_now, "sfx", 0, 0 );
        end
      end
      if vid_name_next and vid_name_next ~= vid_name then
        ObjDetach( vid_name )
        vid_name = vid_name_next
        VidStop( vid_name )
      end;
      --ld.LogTrace( vid_name, public.VidStaticList[ vid ].root or public.VidStaticList[ vid ].owners[ 1 ] )

      if public.VidStaticList[ vid ].root_last then
        --вызывался VidStaticDetach
        ObjAttach( vid_name, public.VidStaticList[ vid ].root_last )
        public.VidStaticList[ vid ].root_last = false
      elseif type( vid ) == "table" then
        --многовидосная статика
        ObjAttach( vid_name, public.VidStaticList[ vid ].root or public.VidStaticList[ vid ].owners[ 1 ] )
      end

      local rndSfxName=private.VidStaticGetRndSfxName( vid )
      if rndSfxName then
        SoundSfxStop(rndSfxName,0)
        if not SoundIsPlaying(rndSfxName) then
          --ld.LogTrace( "vid static play rndSfxName:", rndSfxName );
          SndPlay( "assets/audio/"..rndSfxName, "sfx", 0, 0 );
        end
      end
      --ld.LogTrace( "vid_name = ",vid_name );
      VidPlay( vid_name, function()
        private.VidStaticLog( "VidStaticPlay VidPlay DONE", vid_name, vid, prg_true, prg_false )
        ObjAnimate( vid_name, 7,0,0, function()
          private.VidStaticLog( "VidStaticPlay ObjAnimate DONE", vid_name, vid, prg_true, prg_false )
          public.VidStaticPlay( vid, prg_true, prg_false ) 
        end, { 0,0,0, dt,0,0 } ) 
      end )
      --private.VidStaticLog( "VidStaticPlay", vid_name, vid, prg_true, prg_false )
    end;
  end;
  function public.VidStaticPause( vid, prg_true, prg_false )
    if private.VidStaticCheck( prg_true, prg_false ) then
      local vid_name = private.VidStaticGetRndVidName( vid )
      private.VidStaticPause_now = private.VidStaticPause_now or {}
      private.VidStaticPause_now[ vid_name ] = true
      ObjStopAnimate( vid_name, 7 )
      if private.VidStaticGetRndSfxName( vid ) then
        --SndStop( "assets/audio/"..private.VidStaticGetRndSfxName( vid ), 0.25 )
        ne.snd.SndPause( "assets/audio/"..private.VidStaticGetRndSfxName( vid ), 1 )
      end
      if public.VidStaticList[ vid ].sfx_rnd_now then
        --SndStop( "assets/audio/"..public.VidStaticList[ vid ].sfx_rnd_now, 0.25 );
        ne.snd.SndPause( "assets/audio/"..public.VidStaticList[ vid ].sfx_rnd_now, 1 )
        --public.VidStaticList[ vid ].sfx_rnd_now = false
      end
      VidPause( vid_name, 1 )
      --private.VidStaticLog( "VidStaticPause", vid_name, vid, prg_true, prg_false )
    end;
  end;
  function public.VidStaticContinue( vid, prg_true, prg_false )
    if private.VidStaticCheck( prg_true, prg_false ) then
      local vid_name = private.VidStaticGetRndVidName( vid )
      private.VidStaticPause_now = private.VidStaticPause_now or {}
      if not private.VidStaticPause_now[ vid_name ] then
        public.VidStaticPlay( vid, prg_true, prg_false )
        return
      end
      --ObjStopAnimate( vid_name, 7 )
      local rndSfxName=private.VidStaticGetRndSfxName( vid )
      if rndSfxName then
        --SndStop( "assets/audio/"..private.VidStaticGetRndSfxName( vid ), 0.25 )
        ne.snd.SndPause( "assets/audio/"..rndSfxName, 0 )
      end
      if public.VidStaticList[ vid ].sfx_rnd_now then
        --SndStop( "assets/audio/"..public.VidStaticList[ vid ].sfx_rnd_now, 0.25 );
        ne.snd.SndPause( "assets/audio/"..public.VidStaticList[ vid ].sfx_rnd_now, 0 )
        --public.VidStaticList[ vid ].sfx_rnd_now = false
      end
      VidPause( vid_name, 0 )
      --private.VidStaticLog( "VidStaticContinue", vid_name, vid, prg_true, prg_false )
    end;
  end;

  function public.VidStaticAttach( vid )
    
    local vid_name = private.VidStaticGetRndVidName( vid, false );      
    if public.VidStaticList[ vid ].root_last then
      --вызывался VidStaticDetach
      ObjAttach( vid_name, public.VidStaticList[ vid ].root_last )
      public.VidStaticList[ vid ].root_last = false
    elseif type( vid ) == "table" then
      --многовидосная статика
      ObjAttach( vid_name, public.VidStaticList[ vid ].root or public.VidStaticList[ vid ].owners[ 1 ] )
    end
    ObjSet( vid_name, {alp=1} );
    VidStop( vid_name )      
    
  end

  function public.VidStaticDetach( vid )
    public.VidStaticReset( vid )
    local vid_name = private.VidStaticGetRndVidName( vid )
    public.VidStaticList[ vid ].root_last = ObjGetRelations( vid_name ).parent
    ObjDetach( vid_name );
    --private.VidStaticLog( "VidStaticDetach", vid_name, vid )
  end
  function public.VidStaticHide( vid, t )
    t = t or 0.5
    --if private.VidStaticCheck( prg_true, prg_false ) then
      local vid_name = private.VidStaticGetRndVidName( vid )
      local alp = ObjGet( vid_name ).alp
      public.VidStaticPause( vid )
      ObjAnimate( vid_name, 8,0,0, _, { 0,0,alp, t,1,0 } )
    --end;
    --private.VidStaticLog( "VidStaticHide", vid_name, vid )
  end;
  function public.VidStaticShow( vid, t, alp )
    t = t or 0.5
    --if private.VidStaticCheck( prg_true, prg_false ) then
      --public.VidStaticReset( vid, prg_true, prg_false )
      public.VidStaticPlay( vid, prg_true, prg_false, true )
      local vid_name = private.VidStaticGetRndVidName( vid )
      alp = alp or ObjGet( vid_name ).alp
      ObjAnimate( vid_name, 8,0,0, _, { 0,0,alp, t,2,1 } )
    --end;
    --private.VidStaticLog( "VidStaticShow", vid_name, vid )
  end;
  function public.VidStaticReset( vid, prg_true, prg_false )
    if private.VidStaticCheck( prg_true, prg_false ) then
      local vid_name = private.VidStaticGetRndVidName( vid )
      ObjStopAnimate( vid_name, 7 )
      if private.VidStaticGetRndSfxName( vid ) then
        SndStop( "assets/audio/"..private.VidStaticGetRndSfxName( vid ), 0.25 )
      end
      if public.VidStaticList[ vid ].sfx_rnd_now then
        SndStop( "assets/audio/"..public.VidStaticList[ vid ].sfx_rnd_now, 0.25 );
        public.VidStaticList[ vid ].sfx_rnd_now = false
      end
      VidStop( vid_name )
      --private.VidStaticLog( "VidStaticReset", vid_name, vid, prg_true, prg_false )
    end;
  end;

  function private.VidStaticLog( func_name, vid_name, vid_list, prg_true, prg_false )
    --ld.LogTrace( "\n\nVidStaticLog\n",func_name, ObjGet( vid_name ).draw_width, ObjGet( vid_name ).frame, vid_name, "\n\n" )
  end
  function private.VidStaticCheckDraw( vid, prg_true, prg_false )
    if private.VidStaticCheck( prg_true, prg_false ) and public.VidStaticList and public.VidStaticList[ vid ] then
      local vid_name = private.VidStaticGetRndVidName( vid )
      local o = ObjGet( vid_name )
      if o and o.draw_width < 1 then
        --private.VidStaticLog( "VidStaticCheckDraw Restore DrawWidth", vid_name, vid, prg_true, prg_false )
        public.VidStaticReset( vid, prg_true, prg_false )
        return
      end
    end
  end

function public.ObjGetOwnerZzRmMgHo( obj )
  --ld.LogTrace( obj )
  local owner = ObjGetRelations( obj ).parent
  if owner:find( "^zz_" ) or owner:find( "^rm_" ) or owner:find( "^mg_" ) or owner:find( "^ho_" ) or owner:find( "^inv_complex_" ) then
    --ld.LogTrace( ">>> " ..owner)
    return owner;
  else
    return public.ObjGetOwnerZzRmMgHo( owner );
  end;
end;

--function public.IsLastActionLeft( prg ) 
--  return ld.CheckRequirements( prg, true ) == ( #prg - 1 )
--end;

--obj_root - рут, в клторый будут атачится видосы
--func_end - будет вызвана при скипе
--vid_prefix - префикс видео перед номером
--str_prefix - префикс id trings перед номером
--lip_prefix - префикс липсинка перед номером
--aud_count_dif - разница между номером флэшбека, и номером аудио
--voice = lip_prefix[n]:gsub( "^vid_"..ld.StringDivide( GetCurrentRoom() )[2].."_vid", "aud" )
function public.FlashbackInit( obj_root, func_end, vid_prefix, str_prefix, lip_prefix, aud_count_dif, voice_prefix, sfx_prefix )
  private.FlashbackParams = {
    obj_root = obj_root;
    func_end = func_end;
    vid_prefix = vid_prefix;
    str_prefix = str_prefix;
    lip_prefix = lip_prefix;
    aud_count_dif = aud_count_dif or 0;

    played = {};
    vid_ended = false;
    voice_prefix = voice_prefix;
    sfx_prefix=sfx_prefix;

    is_zz_opened = common.GetCurrentSubRoom();
  }
  int_blackbartext.Hide()
end
  function public.FlashbackShow( n, func_step )
    public.isFlashBackRuning=true;
    ld.LockCustom( "flashback", 1 )
    --SoundTheme( "aud_flashback_mus", 1 )
    interface.DialogStoryShow( 
      private.FlashbackParams.obj_root,
      private.FlashbackParams.str_prefix..n,
      func_step,
      private.FlashbackParams.func_end,
      0.5
    )
    private.FlashbackVidPlay( n, func_step )
    private.FlashbackParams.vid_ended = false
    ld.StartTimer( 0.75, function() 
      if private.FlashbackParams.vid_prefix and not private.FlashbackParams.is_zz_opened then 
        ObjSet( GetCurrentRoom(), { visible = 0, input = 0, active = 0 } ) 
      end
      ld.LockCustom( "flashback", 0 )
    end )
  end
  function public.FlashbackHide()
    public.isFlashBackRuning=true;
    ld.LockCustom( "flashback", 1 )
    if private.FlashbackParams.vid_prefix and not private.FlashbackParams.is_zz_opened then
      ObjSet( GetCurrentRoom(), { visible = 1, input = 1, active = 1 } )
    end
    interface.DialogStoryHide()
    SoundVoice( 0 )
    SoundVid( 0 )
    SoundSfx( 0 )
    SoundTheme( 0 )
    public.SoundBackTheme( true );

    ld.StartTimer( 0.75, function() 
      for k,v in pairs( private.FlashbackParams.played ) do
        if private.FlashbackParams.vid_prefix then
          ObjDelete( private.FlashbackParams.vid_prefix..v )
        end
        if private.FlashbackParams.lip_prefix then
          ObjDelete( private.FlashbackParams.lip_prefix..( v + private.FlashbackParams.aud_count_dif ).."_voc" )
        end
      end
      ld.LockCustom( "flashback", 0 )
    end );

  end
private.FlashbackVidStatic =  function( n, func )
  local d = 25;
  local o = ObjGet( private.FlashbackParams.vid_prefix..n )
  if not o then return end
  local t = math.random(4000,5000)/1000
  local sc = math.random(1050,1150)/1000
  ObjAnimate( o.name, 6,0,0, _, { 0,0,o.scale_x,o.scale_y, t,3,sc,sc } )
  ObjAnimate( o.name, 3,0,0, function() func(n,func) end, { 0,0,o.pos_x,o.pos_y, t,3,512+math.random(-d,d),384+math.random(-d,d) } )
end;
private.FlashbackVidPlay =  function( n, func )

  table.insert( private.FlashbackParams.played, n )
  if private.FlashbackParams.vid_prefix then

    SoundSfxStop("reserved/aud_flashback_clk")  
    SoundSfx( "reserved/aud_flashback_clk" )
    
    VidPlay( private.FlashbackParams.vid_prefix..n, function() 
      private.FlashbackParams.vid_ended = true 
      ObjAnimate( private.FlashbackParams.vid_prefix..n, 6,0,0, function() private.FlashbackVidStatic(n,private.FlashbackVidStatic) end, { 0,0,1,1, 1,0,1.05,1.05 } )
    end )
    ObjAttach( private.FlashbackParams.vid_prefix..n, private.FlashbackParams.obj_root )
    local prew = ObjGet(private.FlashbackParams.vid_prefix..(n-1))
    if prew then
      ld.Anim.Set( private.FlashbackParams.vid_prefix..n, {scale_x = prew.scale_x, scale_y = prew.scale_y, pos_x = prew.pos_x, pos_y = prew.pos_y})
    end
    ObjAnimate( private.FlashbackParams.vid_prefix..n, 8,0,0, function() 
      if prew then
        ObjDetach( private.FlashbackParams.vid_prefix..(n-1) ); 
        ld.StartTimer( 0.5, function() ld.Anim.Set( private.FlashbackParams.vid_prefix..n, {scale_x = 1, scale_y = 1, pos_x = 512, pos_y = 384}, 1) end )
      end
    end, { 0,0,0, private.FlashbackParams.vid_ended and 0 or 0.2,0,1 } )
  else
    private.FlashbackParams.vid_ended = true
  end
  if private.FlashbackParams.lip_prefix then
    local lip_vid_1 = private.FlashbackParams.lip_prefix..( n + private.FlashbackParams.aud_count_dif ).."_voc"
    local lip_vid_0 = private.FlashbackParams.lip_prefix..( n - 1 + private.FlashbackParams.aud_count_dif ).."_voc"
    ObjSet( lip_vid_1, { pos_x = ObjGet( "obj_int_dialog_story_continue" ).pos_x - 110, pos_y = 200, pos_z = 33 } )
    ObjAttach( lip_vid_1, "obj_int_dialog_story" )
    VidPlay( lip_vid_1, "" )
    
    local voice = private.FlashbackParams.lip_prefix..( n + private.FlashbackParams.aud_count_dif ).."_voc";

    if private.FlashbackParams.voice_prefix then
      if type( private.FlashbackParams.voice_prefix ) == "table" then
        voice = private.FlashbackParams.voice_prefix[n]
      else
        voice = private.FlashbackParams.voice_prefix..n.."_voc"
      end
    else      
      if voice:find( "^vid_"..ld.StringDivide( GetCurrentRoom() )[2].."_vid" ) then
        voice = voice:gsub( "^vid_"..ld.StringDivide( GetCurrentRoom() )[2].."_vid", "aud" );
      else
        voice = voice:gsub( "^vid_"..ld.StringDivide( private.FlashbackParams.lip_prefix )[2].."_vid", "aud" );        
      end 
    end
    if voice ~= "none" then  
      SoundVoice( voice )
    end
    
    if private.FlashbackParams.sfx_prefix then
      local sfx
      if type( private.FlashbackParams.sfx_prefix ) == "table" then
        sfx = private.FlashbackParams.sfx_prefix[n]
      else
        sfx = private.FlashbackParams.sfx_prefix..n
      end
      if sfx ~= "none" then
        SoundSfx( sfx )
      end
    end

    ObjAnimate( lip_vid_1, 8,0,0, _, { 0,0,0, private.FlashbackParams.vid_ended and 0.5 or 0,2,1 } )
    ObjAnimate( lip_vid_0, 8,0,0, function() ObjDetach( lip_vid_0 ); end, { 0,0,1, private.FlashbackParams.vid_ended and 0.5 or 0,1,0 } )
  end

end

function public.ShowObjTree( obj, show_params, str, stack )
  local show = true

  if str then 
   show = false
  else
    str = "\n";
  end
  stack = stack or "";

  str = str..stack..obj;
  if show_params then
    if type( show_params ) == "string" then
      str = str.."   "..show_params.." = "..tostring( ObjGet( obj )[ show_params ] );
    elseif type( show_params ) == "table" then
      local o = ObjGet( obj )
      for i = 1, #show_params do
        str = str.."\t"..show_params[i].." = "..tostring( o[ show_params[i] ] )..";";
      end
    end
  end;
  str = str.."\n";

  stack = stack.."| "

  local ch = ObjGetRelations( obj ).childs
  for i = 1, #ch do
    str = public.ShowObjTree( ch[i], show_params, str, stack )
  end;

  if show then
    ld.LogTrace( str )
  else
    return str
  end;
end;

function public.SmartHint_Init()
  --кэшируем хинт по rm/zz/mg/ho
  public.smart_hint = {} --кешируется только НЕ выполненный прогресс!
  public.smart_hint_full = {} --весь кеш
  --кешируем связи rm/zz/mg/ho
  public.smart_hint_connections = {}
  --кешируем связи rm/zz/mg/ho/RM
  public.smart_hint_connections_full = {}
  --запоминаем позицию прогресса в game.progress_names
  public.smart_hint_prg_id = {}

  local add_zz_connection = function( zz, room )
    public.smart_hint_connections[ zz ] = room
    public.smart_hint_connections[ room ] = public.smart_hint_connections[ room ] or {}
    --добовляем связь комнате с zz/mg/ho/inv_complex
    table.insert( public.smart_hint_connections[ room ], zz )
  end

  local k, v;
  for i, o in ipairs( game.progress_names ) do
    public.smart_hint_prg_id[ o ] = i
    v = common_impl.hint[ o ]
    k = o
    --ld.LogTrace( i, o )
    if v then
      if v.zz then
        --if v.zz:find( "^zz_" ) then
          --zz/inv_complex
          if not cmn.IsEventDone( o ) then
            public.smart_hint[ v.zz ] = public.smart_hint[ v.zz ] or {}
            table.insert( public.smart_hint[ v.zz ], k )
          end
          public.smart_hint_full[ v.zz ] = public.smart_hint_full[ v.zz ] or {}
          table.insert( public.smart_hint_full[ v.zz ], k )

          if not public.smart_hint_connections[ v.zz ] then
            --для комплексных предметов room = "inv_complex_inv"
            --добовляем связь zz/mg/ho/inv_complex с комнатой
            if ld.TableContains( game.room_names, v.room ) then
              if ld.SubRoom.IsOwned( v.zz ) then
                local zz_owner = ld.SubRoom.Owner( v.zz )
                if not public.smart_hint_connections[ zz_owner ] then
                  add_zz_connection( zz_owner, v.room )
                end
                table.insert( public.smart_hint_connections[ v.room ], v.zz )
                public.smart_hint_connections[ v.zz ] = zz_owner
              else
                add_zz_connection( v.zz, v.room )
              end
            end
          end
        --else
        --  --mg/ho
        --  public.smart_hint[ v.zz ] = public.smart_hint[ v.zz ] or {}
        --  public.smart_hint[ v.zz ][ k ] = common_impl.hint[ k ]
        --end
      else
        --rm
        if not cmn.IsEventDone( o ) then
          public.smart_hint[ v.room ] = public.smart_hint[ v.room ] or {}
          table.insert( public.smart_hint[ v.room ], k )
        end
        public.smart_hint_full[ v.room ] = public.smart_hint_full[ v.room ] or {}
        table.insert( public.smart_hint_full[ v.room ], k )
        if ld.Room.IsZoomable( v.room ) then
          local parent = ld.Room.Parent( v.room )
          public.smart_hint_full[ parent ] = public.smart_hint_full[ parent ] or {}
          table.insert( public.smart_hint_full[ parent ], k )
          public.smart_hint_connections[ parent ] = public.smart_hint_connections[ parent ] or {}
          if not ld.Table.Contains( public.smart_hint_connections[ parent ], v.room) then
            table.insert( public.smart_hint_connections[ parent ], v.room )
          end
        end
      end
    end
    local prg_room, prg_rghz
    if v then
      prg_rghz = v.room
    elseif k:find( "^opn_" ) then
      prg_rghz = "rm_"..k:gsub( "^opn_", "" )
      if not ObjGet( prg_rghz ) then prg_rghz = false end
    end
    if prg_rghz then
      if not public.smart_hint_connections_full[ prg_rghz ] then
        public.smart_hint_connections_full[ prg_rghz ] = {}
        local gates = public.SmartHint_GetObjGates( prg_rghz )
        local div, rghz
        for i = 1, #gates do
          div = ld.StringDivide( gates[ i ] )
          rghz = div[ 1 ]:gsub( "^g", "" ).."_"..div[ 3 ]
          if not public.smart_hint_connections_full[ rghz ] then
            public.smart_hint_connections_full[ prg_rghz ][ rghz ] = true
          end
        end
      end
    end
  end
  --ld.LogTrace( public.smart_hint, public.smart_hint_connections, public.smart_hint_connections_full )
  public.SoundEnvInitAll();
  public.VidStaticInitAll();
end;

  function public.SmartHint_UpdateCache()
    public.smart_hint_prg_id = {}
    for i, o in ipairs( game.progress_names ) do
      public.smart_hint_prg_id[ o ] = i
    end
  end

  function public.SmartHint_Refresh()
    --local t = os.clock()
    --чистит выполненый прогресс в smart_hint
    local keys_to_remove = {}
    for k,v in pairs( public.smart_hint ) do
      while v[ 1 ] and cmn.IsEventDone( v[ 1 ] ) do
        table.remove( v, 1 );
      end;
      if #v == 0 then
        table.insert( keys_to_remove, k )
      end
    end;
    for k, v in ipairs( keys_to_remove ) do
      public.smart_hint[ v ] = nil;
    end;
    --ld.LogTrace( "SmartHint_Refresh execution time", os.clock() - t )
  end

  function public.SmartHint_GetNearestPrg()
    public.SmartHint_Refresh();
    --ld.LogTrace( "SmartHint_GetNearestPrg", interface.GetCurrentComplexInv() )
    if interface.GetCurrentComplexInv() ~= "" then
      --ld.LogTrace( "SmartHint_GetNearestPrg", "SmartHint_GetNearestPrg_InComplexInv" )
      return private.SmartHint_GetNearestPrg_InComplexInv( interface.GetCurrentComplexInv() ) or public.SmartHint_GetNearestPrg_InRmMgHo();
    elseif common.GetCurrentSubRoom() then
      --ld.LogTrace( "SmartHint_GetNearestPrg", "SmartHint_GetNearestPrg_InSubRoom" )
      return private.SmartHint_GetNearestPrg_InSubRoom( common.GetCurrentSubRoom() ) or public.SmartHint_GetNearestPrg_InRmMgHo();
    else
      --ld.LogTrace( "SmartHint_GetNearestPrg", "SmartHint_GetNearestPrg_InMgHo" )
      return public.SmartHint_GetNearestPrg_InRmMgHo();
    end
    --ld.LogTrace( "SmartHint_GetNearestPrg", "FALSE!!!" )
    return false
  end;

  function public.SmartHint_GetNearestPrg_Full( room, from )
    room = room or GetCurrentRoom()
    from = from or room
    --ld.LogTrace( "SmartHint_GetNearestPrg_Full", room, from )
    local answer = public.SmartHint_GetNearestPrg_InRoom( room );
    if not answer then
      local conections = public.SmartHint_GetConnectedActiveRooms( room, from )
      for i = 1, #conections do
        if "rm_"..conections[ i ] ~= from then
          answer = public.SmartHint_GetNearestPrg_InRoom( "rm_"..conections[ i ] );
          if answer then
            return answer
          end
        end
      end
      for i = 1, #conections do
        if "rm_"..conections[ i ] ~= from then
          answer = public.SmartHint_GetNearestPrg_Full( "rm_"..conections[ i ], room );
          if answer then
            return answer
          end
        end
      end
    end
    return false
  end

  function public.SmartHint_GetObjGates( obj )
    local childs = ObjGetRelations( obj ).childs
    local div
    local gates = {}
    if childs then
      for i = 1, #childs do
        div = ld.StringDivide( childs[ i ] )
        if div[ 1 ] == "grm" or div[ 1 ] == "gho" or div[ 1 ] == "gmg" or div[ 1 ] == "gzz" then
          table.insert( gates, childs[ i ] )
        end
      end
    end
    return gates;
  end

  function public.SmartHint_GetConnectedRooms( room, rm_except )
    local links = public.smart_hint_connections_full[ room ] 
    local rooms = {}
    if links then
      for i = 1, #links do
        if links[ i ]:find( "^rm" ) and links[ i ] ~= "rm_"..rm_except then
          table.insert( rooms, obj )
        end
      end
    end
    return rooms;
  end

  function public.SmartHint_GetConnectedActiveRooms( room, rm_except )
    local links = public.SmartHint_GetConnectedRooms( room, rm_except )
      
    local o, obj
    local rooms = {}
    if links then
      for i = 1, #links do
        obj = "grm"..room:gsub( "^rm", "" )..links[ i ]:gsub( "^rm", "" )
        o = ObjGet( obj )
        if o and o.input then
          table.insert( rooms, links[ i ] )
        end
      end
    end
    return rooms;
  end

  function public.SmartHint_GetConnectedActiveNotOpenedRoom( room, rm_except )
    local rooms = public.SmartHint_GetConnectedActiveRooms( room, rm_except )
    for i = 1, #rooms do
      if not ld.CheckRequirements( { "opn"..rooms[ i ]:gsub( "^rm", "" ) } ) then
        return rooms[ i ]
      end
    end
    return false;
  end

  function public.SmartHint_GetRoomParent( room )
    --ld.LogTrace( "SmartHint_GetRoomParent", room, public.smart_hint_connections, public.smart_hint_connections_full )
    local o, obj
    for location, childs in pairs( public.smart_hint_connections_full ) do
      for child, bool in pairs( childs ) do
        if child == room then
          return location
        end
      end
    end
    return false;
  end


  function public.SmartHint_IsInvItemUsable( inv_item )
    if inv_item == "obj_helper_cursor_drag" then
      return _G[ "int_helper" ]  and ObjGet( inv_item ) and ObjGet( inv_item ).visible
    else
      local item = inv_item:gsub( "^inv_", "" );
      if ng_global.currentprogress == "scr" then
        return ObjGetRelations( inv_item ).parent == "spr_panelscr_slot";
      else
        return public.TableContains( ObjGetRelations("obj_int_inventory").childs,"hub_int_inventory_"..item ) and ObjGet( inv_item ).drag
      end
    end
  end
  
  function private.SmartHint_GetNearestPrg_InComplexInv( inv_complex )
    --возвращяет имя доступного прогресса, либо false
    --if not public.smart_hint[ inv_complex ] or not ObjGet( public.smart_hint[ inv_complex ][ 1 ].zz_gate ).input then
    --  return false
    --end;
    for k, prg_name in ipairs( public.smart_hint[ inv_complex ] or {} ) do

      if private.SmartHint_IsActivePrg( prg_name ) then 
        return prg_name
      end   

    end

    return false
    --return false
  end;
  function private.SmartHint_GetNearestPrg_InSubRoom( zz )
    --возвращяет имя доступного прогресса, либо false
    --ld.LogTrace( public.smart_hint[ zz ] )
    if not public.smart_hint[ zz ] or not ObjGet( common_impl.hint[ public.smart_hint[ zz ][ 1 ] ].zz_gate ).input then
      return false
    end;

    for k, prg_name in ipairs( public.smart_hint[ zz ] or {} ) do

      if private.SmartHint_IsActivePrg( prg_name ) then 
        return prg_name
      end   

    end

    return false
  end;
  function private.SmartHint_GetNearestPrg_InMgHo( mgho )
    --возвращяет имя доступного прогресса, либо false
    --ld.LogTrace( "SmartHint_GetNearestPrg_InMgHo", mgho )
    --ld.LogTrace( public.smart_hint[ mgho ], common_impl.hint[ public.smart_hint[ mgho ][ 1 ] ].zz_gate , ObjGet( common_impl.hint[ public.smart_hint[ mgho ][ 1 ] ].zz_gate ) )
    if not public.smart_hint[ mgho ] or not ( ObjGet( common_impl.hint[ public.smart_hint[ mgho ][ 1 ] ].zz_gate ) and ObjGet( common_impl.hint[ public.smart_hint[ mgho ][ 1 ] ].zz_gate ).input ) then
      return false
    end;
    local o,o2,v
    for k, prg_name in ipairs( public.smart_hint[ mgho ] or {} ) do
      --ld.LogTrace( "SmartHint_GetNearestPrg_InMgHo", k, prg_name )
      v = common_impl.hint[ prg_name ]
      if v.type == "win" and ( not cmn.IsEventDone( prg_name ) ) then 
        o = ObjGet( v.use_place )
        o2 = ObjGet( v.zz_gate )
        if ( o and o2 and o.input and o2.input ) or cmn.IsEventStart( prg_name ) then
          if not cmn.IsEventStart( prg_name ) and k ~= 1 then

          else
            return prg_name
          end
        end
      elseif private.SmartHint_IsActivePrg( prg_name ) then 
        return prg_name
      end    

    end
    local prg = "win_"..( mgho:gsub( "^ho_", "" ):gsub( "^mg_", "" ) );
    local o = ObjGet( common_impl.hint[ prg ].zz_gate )
    --ld.LogTrace( prg, common_impl.hint[ prg ].zz_gate, o and o.input or false )
    if o and o.input and #public.smart_hint[ mgho ] == 1 then
      return prg;
    else
      return false;
    end
  end;
  public.SmartHint_GetNearestPrg_InMgHo = private.SmartHint_GetNearestPrg_InMgHo;
  function public.SmartHint_GetNearestPrg_InRoom( room )
    --возвращяет имя доступного прогресса, либо false
    --ld.LogTrace( "SmartHint_GetNearestPrg_InRoom", room )
    for k, prg_name in ipairs( public.smart_hint[ room ] or {} ) do

      if private.SmartHint_IsActivePrg( prg_name ) then 
        return prg_name
      end

    end
    local prg_id = 99999
    --проверяем прилинкованные zz/mg/ho
    if public.smart_hint_connections[ room ] then
      local answer
      for k, v in ipairs( public.smart_hint_connections[ room ] or {} ) do
        --ld.LogTrace( "SmartHint_GetNearestPrg_InRoom", room, k, v )
        if v:find( "^zz_" ) then
          answer = private.SmartHint_GetNearestPrg_InSubRoom( v )
          prg_id = math.min( prg_id, public.smart_hint_prg_id[ answer or 99999 ] or 99999 )
        elseif v:find( "^rm_" ) then
          --ld.LogTrace( room, v, ld.Room.IsZoomable( v ) )
          if ld.Room.IsZoomable( v ) then
            answer = public.SmartHint_GetNearestPrg_InRoom( v )
            prg_id = math.min( prg_id, public.smart_hint_prg_id[ answer or 99999 ] or 99999 )
          end
        else
          answer = private.SmartHint_GetNearestPrg_InMgHo( v )
          prg_id = math.min( prg_id, public.smart_hint_prg_id[ answer or 99999 ] or 99999 )
        end
      end
    end
    --проверяем есть ли прилинкованные rm, в которые можно зайти, но мы там ещё не были
    --local connected_rm = public.SmartHint_GetConnectedActiveNotOpenedRoom( room, except )
    --if connected_rm then
    --  prg_id = math.min( prg_id, public.smart_hint_prg_id[ "opn_"..connected_rm ] or 99999 )
    --end
    --
    return game.progress_names[ prg_id ] or false
  end;
  function public.SmartHint_GetNearestPrg_InRmMgHo( room )
    room = room or GetCurrentRoom()
    if room:find( "^rm" ) then
      return public.SmartHint_GetNearestPrg_InRoom( room )
    else
      return public.SmartHint_GetNearestPrg_InMgHo( room )
    end
  end
  private.SmartHint_o = nil;
  private.SmartHint_v = nil
  function private.SmartHint_IsActivePrg( prg_name )
    --ld.LogTrace( "SmartHint_IsActivePrg 0", prg_name )
    if not cmn.IsEventDone( prg_name ) then
      private.SmartHint_v = common_impl.hint[ prg_name ]
      --ld.LogTrace( "SmartHint_IsActivePrg 1", private.SmartHint_v )
      if private.SmartHint_v.type == "get" then 
        private.SmartHint_o = ObjGet( private.SmartHint_v.get_obj )
        --ld.LogTrace( "SmartHint_IsActivePrg 2", private.SmartHint_o )
        if private.SmartHint_o and private.SmartHint_o.input then
          return true
        end
      elseif private.SmartHint_v.type == "use" then
        private.SmartHint_o = ObjGet( private.SmartHint_v.use_place )
        --ld.LogTrace( "SmartHint_IsActivePrg 3", private.SmartHint_o )
        if ( private.SmartHint_o and private.SmartHint_o.input ) and public.SmartHint_IsInvItemUsable( private.SmartHint_v.inv_obj ) then
          return true
        end
      elseif private.SmartHint_v.type == "click" then 
        private.SmartHint_o = ObjGet( private.SmartHint_v.use_place )
        --ld.LogTrace( "SmartHint_IsActivePrg 4", private.SmartHint_o )
        if ( private.SmartHint_o and private.SmartHint_o.input ) or cmn.IsEventStart( prg_name ) then
          return true
        end
      elseif private.SmartHint_v.type == "win" then 
        private.SmartHint_o = ObjGet( private.SmartHint_v.use_place )
        --ld.LogTrace( "SmartHint_IsActivePrg 5", private.SmartHint_o )
        if ( private.SmartHint_o and private.SmartHint_o.input ) or cmn.IsEventStart( prg_name ) then
          return true
        end
      else 
        --не активный
      end
    end
    return false
  end

  function public.SmartHint_GetZzListInRoom( rm )
    local zz = {}
    if rm and public.smart_hint_connections[ rm ] then
      for i = 1, #public.smart_hint_connections[ rm ] do
        if public.smart_hint_connections[ rm ][ i ]:find( "^zz" ) then
          table.insert( zz, public.smart_hint_connections[ rm ][ i ] )
        end
      end
    end
    return zz--public.smart_hint_connections[ rm ]
  end

  --function private.xxx()end

  --params = { 
  --  { srt_id, aud_voc or false, time_show, time_hide or false };
  --  ...
  --};
  function public.VideoSubtitleVocStart( params )
    public.VideoSubtitleVocStop()
    private.VideoSubtitleVocParams = params;
    for i = 1, #params do
      ld.StartTimer( "tmr_video_subtitle_voc_show_"..i, params[ i ][ 3 ], function()
        if params[ i ][ 1 ] then
          interface.DialogVideoSubtitleShow( params[ i ][ 1 ] )
        end
        if params[ i ][ 2 ] then
          SoundVoice( params[ i ][ 2 ] )
        end
      end )
      if params[ i ][ 4 ] then
        ld.StartTimer( "tmr_video_subtitle_voc_hide_"..i, params[ i ][ 4 ], function() interface.DialogVideoSubtitleHide() end )
      end
    end
  end
  function public.VideoSubtitleVocStop()
    if private.VideoSubtitleVocParams then
      for i = 1, #private.VideoSubtitleVocParams do
        ObjDelete( "tmr_video_subtitle_voc_show_"..i )
        ObjDelete( "tmr_video_subtitle_voc_hide_"..i )
      end
      private.VideoSubtitleVocParams = false
    end
  end


  function public.MicroClick( fx_type, pos_z, t_delay, count_max, life_time )
    
    local life_times = {
      dust_small_wall = 2;
    }

    local sfx = {
      dust_small_wall = "reserved/aud_xx_stones";
      click_fx = "aud_xx_dust";
    }

    t_delay = t_delay or 0.2;
    pos_z = pos_z or 39;
    life_time = life_time or life_times[ fx_type ] or 2;  --время жизни частички, затем удаление
    count_max = count_max or ( life_time / t_delay );
    
    local owner = common.GetCurrentSubRoom() or common.GetCurrentRoom();  --при необходимости добавить деплой

    -->>init
    private.micro_click = private.micro_click or {}
    private.micro_click[ owner ] =   private.micro_click[ owner ] or {}
    private.micro_click[ owner ][ fx_type ] =   private.micro_click[ owner ][ fx_type ] or {}
    private.micro_click[ owner ][ fx_type.."_count" ] =   private.micro_click[ owner ][ fx_type.."_count" ] or 0
    private.micro_click[ owner ][ fx_type.."_counter" ] =   private.micro_click[ owner ][ fx_type.."_counter" ] or 0
    --<<init
    
    if not ObjGet( "tmr_common_impl_micro_click" ) then
      local fx = "fx_"..owner.."_micro_click_"..fx_type.."_"..private.micro_click[ owner ][ fx_type.."_counter" ]
      if not ObjGet( fx ) and private.micro_click[ owner ][ fx_type.."_count" ] < count_max then
      ld.StartTimer(  "tmr_common_impl_micro_click",  t_delay, function() end );
        private.micro_click[ owner ][ fx_type.."_count" ] = private.micro_click[ owner ][ fx_type.."_count" ] + 1
        private.micro_click[ owner ][ fx_type.."_counter" ] = private.micro_click[ owner ][ fx_type.."_counter" ] + 1
        if private.micro_click[ owner ][ fx_type.."_counter" ] > 1000 then
          private.micro_click[ owner ][ fx_type.."_counter" ] = 0
        end;
        local p = GetGameCursorPos()
        local o = ObjGet( owner )
      
        ObjCreate( fx, "partsys" )
        ObjSet( fx, { 
          res = "assets/levels/common/fx/fx_micro_click_"..fx_type;
          pos_x = p[ 1 ] - o.pos_x;
          pos_y = p[ 2 ] - o.pos_y;
          pos_z = pos_z;
        } );
        ObjAttach( fx, owner )
        ObjAnimate( fx, 7,0,0, function() 
          ObjDelete( fx );
          private.micro_click[ owner ][ fx_type.."_count" ] = private.micro_click[ owner ][ fx_type.."_count" ] - 1
        end, { 0,0,0, life_time,0,0 } )
      
        if sfx[ fx_type ] then
          SoundSfx( sfx[ fx_type ], -1 )
        end

      end;
    end
  end;
  --------------------------------------------------------------------------------------
  --удаляет объект с аним тагом, чтобы художникам не приходилось удалять ресурсы
  function public.TagedObjDel( obj )
    local o = ObjGet( obj )
    if o and o.anim_tag and o.anim_tag and o.anim_tag ~= "" then
      ObjCreate( "taged_"..obj, "obj" )
      ObjSet( "taged_"..obj, { anim_tag = o.anim_tag } )
      ObjAttach( "taged_"..obj, ObjGetRelations( obj ).parent )
      ObjDelete( obj )
    end
  end
  --------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------
  
  function private.SetGHOMask()
    for i,o in ipairs(game.room_names) do
      if o:find("^ho_") then
        local fxGate = common_impl.hint[o:gsub("^ho_","win_")].zz_gate
        local fx = ObjGet(fxGate)
        if fx then
          local createdMask = fxGate:gsub("^gho_","spr_").."_ghomask"
          if ObjGet(createdMask) then return end 
          local dummyMask = "spr_common_ghomask"
          local dMSize = 64
          local heightLimit = 100 --обрежет столько пикселей у маски сверху
          local wightPercent = 0.8 -- уменьшит маску на столько процентов
          local heightPercent = 0.8
          
          
          local scalex,scaley = wightPercent*fx.inputrect_w/dMSize, heightPercent*(fx.inputrect_h-heightLimit)/dMSize
          local posx,posy = fx.inputrect_w/2 + fx.inputrect_x, (fx.inputrect_h+heightLimit)/2 + fx.inputrect_y
          --ld.LogTrace( fxGate );
          --ld.LogTrace( createdMask );
          ld.CopyObj(dummyMask, createdMask, "spr", fxGate)
          ObjSet( createdMask, {scale_x = scalex, scale_y = scaley} );
          ObjSet( createdMask, {pos_x = posx, pos_y = posy} );

          PartSysSetMaskObj(fxGate, createdMask, 0) 
        end
      end
    end
  end
  --------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------
--**************************************************************************************************************
--***function *** Miniback postfix *** () end*******************************************************************
--**************************************************************************************************************

  function public.SetMinibackPostfixForRoom( room, postfix, prg )
    if not ng_global.minibackpostfix then
      ng_global.minibackpostfix = {};
    end
    if not ng_global.minibackpostfix[prg] then
      ng_global.minibackpostfix[prg] = {};
    end
    ng_global.minibackpostfix[ prg ][ room ] = postfix
  end;

  function public.GetMinibackPostfixForRoom( room, prg )
    if ng_global.minibackpostfix then 
      if ng_global.minibackpostfix[prg] then 
        local result = ng_global.minibackpostfix[prg][ room ] or "";

        return result;
      else
        return "";
      end
    else
      return "";
    end
  end;
  
--************************************************************************************************************
--***function *** Marked Task Ho *** () end******************************************************************* 
--************************************************************************************************************
    --EXAMPLE
    --iii = {type_unmark = "click",
    --    zone = "obj_barnho_iii_zone", --на какую зону кликнуть
    --    obj_anim = "anm_barnho_iii",  --имя анимации
    --    animfunc = "iii",             --имя функции
    --    sfx = "aud_iii_ho_yard",      --звук
    --    func_load = function()        --что выполнить чтобы разблочить
    --      ObjSet( "spr_barnho_iii", {input=1} );
    --    end,
    --};

    --hhh = {type_unmark = "dragdrop",
    --    item = "obj_barnho_click_3", 
    --    zone = "obj_barnho_hhh_zone",
    --    obj_anim = "anm_barnho_hhh",
    --    anim_idle = "idle_cap",
    --    animfunc = "hhh",
        --    pos_z_drop_item = 1;  --опционально позиция z объекта дял воостановления после драга
        --    sfx_get = "aud_get_cap_ho_yard",  --взятие объекта
        --    sfx_drop_wrong = "aud_drop_cap_ho_yard", --положили обратно
        --    sfx_idle = "aud_xx_cap_ho_yard", --хх на зону применения
        --    sfx = "aud_use_cap_ho_yard",     --правильное применение
    --    func_load = function()
    --      ObjSet( "spr_barnho_hhh", {input=1} );
    --    end,
    --};

  function public.MarkedTaskHoInit(ho_name,arr_task)
    
    for i,o in pairs(arr_task) do
      local task = i
      local param = ld.TableCopy(o)
      local zone            = param.zone            or "gfx_"..ho_name.."_unmark_"..task.."_zone"
      local obj_anim        = param.obj_anim        or "anm_"..ho_name.."_unmark_"..task

      if param.type_unmark == "dragdrop" then
        
        local item            = param.item            or "spr_"..ho_name.."_"..task.."_part_1"      
        local pos_z_drop_item = param.pos_z_drop_item or 0 
        local sfx_get = param.sfx_get or "reserved/aud_get"
        local zone_mdown
        if param.zone_mdown then
          zone_mdown = param.zone_mdown 
        elseif param.anim_idle then
          local idle_animfunc =  "idle_"..task
          if type(param.anim_idle)=="string" then 
            idle_animfunc =  param.anim_idle
          end
          zone_mdown = function()
            ld.Anim.Need( obj_anim, idle_animfunc, "need_"..ho_name.."_"..task, param.sfx_idle );
          end
        else 
          zone_mdown = function()ld.ShowBbt("need_"..ho_name.."_"..task) end
        end
        
        local item_param = ObjGet(item)
        local nil_f= function()end 
        local item_event_func={}
        item_event_func.event_mdown=(item_param and item_param.event_mdown) or nil_f       
        item_event_func.event_menter=(item_param and item_param.event_menter) or nil_f            
        item_event_func.event_mleave=(item_param and item_param.event_mleave) or nil_f 
        item_event_func.event_dragdrop=(item_param and item_param.event_dragdrop) or nil_f        
        
        ObjSet( item, {pos_z = pos_z_drop_item,drag=1,
          event_mdown = function()item_event_func.event_mdown();ObjSet( item, { pos_z = 50 } );ObjSet( item.."_sh", { alp=0 } );SoundSfx( sfx_get );end;
          event_menter = function()item_event_func.event_menter(); ld.ShCur(CURSOR_GET);  end;
          event_mleave = function()item_event_func.event_mleave(); ld.ShCur(CURSOR_DEFAULT);   end;
          event_dragdrop =  function()item_event_func.event_dragdrop();public.MarkedTaskHo_unmark(ho_name,task);  end;
        } );
          
        local zone_param = ObjGet(zone)
        local nil_f= function()end 
        local zone_event_func={}
        zone_event_func.event_mdown=zone_param and zone_param.event_mdown or nil_f       
        zone_event_func.event_menter=zone_param and zone_param.event_menter or nil_f            
        zone_event_func.event_mleave=zone_param and zone_param.event_mleave or nil_f
        
        ObjSet( zone, {
          event_mdown = zone_mdown;
          event_menter = function()zone_event_func.event_menter();ld.SetCursor( CURSOR_USE ); end;
          event_mleave = function()zone_event_func.event_mleave();ld.SetCursor( CURSOR_DEFAULT ); end;

        } );
      elseif  param.type_unmark == "click" then  
        local zone_param = ObjGet(zone)
        local nil_f= function()end 
        local zone_event_func={}
        zone_event_func.event_mdown=(zone_param and zone_param.event_mdown) or nil_f       
        zone_event_func.event_menter=(zone_param and zone_param.event_menter) or nil_f            
        zone_event_func.event_mleave=(zone_param and zone_param.event_mleave) or nil_f       
        
        ObjSet( zone, {
          event_mdown  = function()zone_event_func.event_mdown(); public.MarkedTaskHo_unmark(ho_name,task) end;
          event_menter = function()zone_event_func.event_menter(); ld.SetCursor( CURSOR_HAND ); end;
          event_mleave = function()zone_event_func.event_mleave(); ld.SetCursor( CURSOR_DEFAULT ); end;

        } );
      end 
    end    
  end
  
    function public.MarkedTaskHo_unmark(ho_name,task)
      --local type_rm = "ho_"
      --if .mini_ho then type_rm = "rm_" end
      if _G[GetCurrentRoom()].mark_task_arr[task] then
        local param = ld.TableCopy(_G[GetCurrentRoom()].mark_task_arr[task])
        

        local zone            = param.zone            or "gfx_"..ho_name.."_unmark_"..task.."_zone"
        local obj_anim        = param.obj_anim        or "anm_"..ho_name.."_unmark_"..task
        local animfunc        = param.animfunc        or "unmark_"..task
        local func_start      = param.func_start        
        local func_end        = param.func_end
        local func_load       = param.func_load        
        local sfx             = param.sfx    
        
        if param.type_unmark == "dragdrop" then
          
          local item            = param.item            or "spr_"..ho_name.."_"..task.."_part_1"      
          local pos_z_drop_item = param.pos_z_drop_item or 0   
          local sfx_drop_wrong  = param.sfx_drop_wrong or false
          
          if ld.ApplyCheck(item,zone) then 
            local f_end = function()
              ld.Lock(0)
              cmn.UnmarkTask( ho_name, task );
              cmn.CallEventHandler( ho_name.."_unmark_"..task ); 
              if func_end then func_end() end   
              if func_load then func_load() end                  
            end
            ld.Lock(1)  
            --ObjSet(item,{active = 0, visible = 0 , input =0})
            --ObjSet(zone,{active = 0, visible = 0 , input =0})
            ObjDelete(item)
            ObjDelete(zone)            
            if obj_anim then
              if func_start then func_start() end   
              ld.AnimPlay(obj_anim,animfunc,f_end, sfx )
            end
          else 
            ObjSet(item,{pos_z = pos_z_drop_item});ObjSet( item.."_sh", {alp=1} );
            if sfx_drop_wrong then
              SoundSfx( sfx_drop_wrong )
            end
          end 
        elseif param.type_unmark == "click" then
          local f_end = function()
            ld.Lock(0)
            cmn.UnmarkTask( ho_name, task );
            cmn.CallEventHandler( ho_name.."_unmark_"..task ); 
              if func_end then func_end() end   
              if func_load then func_load() end     
          end
          ld.Lock(1)  
          --ObjSet(zone,{active = 0, visible = 0 , input =0})
          ObjDelete(zone)
          ld.AnimPlay(obj_anim,animfunc,f_end, sfx )      
        end
      
      end


    end
    
    
    function public.MarkedTaskHo_unmark_func(task,param,ho_name)
      local zone            = param.zone            or "gfx_"..ho_name.."_unmark_"..task.."_zone"
      local obj_anim        = param.obj_anim        or "anm_"..ho_name.."_unmark_"..task
      local item            = param.item            or "spr_"..ho_name.."_"..task.."_part_1"      
      local animfunc        = param.animfunc        or "unmark_"..task
      local func_load       = param.func_load
      local  unmark_func= function()
        --ObjSet(item,{active = 0, visible = 0 , input =0})
        --ObjSet(item.."_sh",{active = 0, visible = 0 , input =0}) 
        --ObjSet(zone,{active = 0, visible = 0 , input =0})
        ObjDelete(item)
        ObjDelete(item.."_sh")        
        ObjDelete(zone)        
        ObjSet(obj_anim,{animfunc = animfunc,frame=999,playing=0})
        ObjSet( "spr_"..ho_name.."_"..task, {alp = 1,input = 1} );
        if func_load then
           func_load()
        end
      end  
      return unmark_func;      
    end