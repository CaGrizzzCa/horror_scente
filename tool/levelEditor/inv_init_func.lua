--*********************************************************************************************************************
-- function *** {{objname}} *** () end;
--*********************************************************************************************************************
function private.init_{{objname}}()

  {{#inv_gets_code}}
  {{>inv_init_get_obj}}
  {{>inv_get_code_1}}
  {{/inv_gets_code}}

  {{#inv_uses_code}}
  {{>inv_use_code_1}}
  {{/inv_uses_code}}

  {{#inv_clicks_code}}
  {{>inv_init_clk_obj}} 
  {{>inv_click_code_1}}
  {{/inv_clicks_code}}


  {{#inv_uses_code}}
  {{>inv_use_code_2}}
  {{/inv_uses_code}}


  {{#inv_gets_code}}
  {{>inv_get_code_2}}
  {{/inv_gets_code}}


  {{#inv_clicks_code}}
  {{>inv_click_code_2}}
  {{/inv_clicks_code}}

end;
