*&---------------------------------------------------------------------*
*& Report ZSO_INVENTORY_MANEGMENT_DB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zso_inventory_manegment_db.
type-pools:slis.

TABLES: vbak,vbap,makt,kna1.

types:begin of f_tab,
      vbeln type vbak-vbeln,
      erdat type vbak-erdat,
      kunnr type vbak-kunnr,
      vkorg type vbak-vkorg,
      waerk type vbak-waerk,
      Name1 type kna1-name1,
      ort01 type kna1-ort01,
      posnr type vbap-posnr,
      matnr type vbap-matnr,
      kwmeng type vbap-kwmeng,
      vrkme type vbap-vrkme,
      netwr type vbap-netwr,
      maktx type makt-maktx,
      end of f_tab.

Data: f_result type standard table of f_tab,
      wa type f_tab.

data: t_fcat type lvc_t_fcat,
      w_fcat type lvc_S_fcat,
       w_layout TYPE lvc_s_layo.





SELECTION-SCREEN:BEGIN OF BLOCK blk1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: S_vbeln FOR vbak-vbeln, "sales order number
                  S_erdat FOR vbak-erdat, "creation date
                  S_kunnr FOR vbak-kunnr, "customer number
                  S_matnr FOR vbap-matnr. "material number

SELECTION-SCREEN:END OF BLOCK blk1.


start-of-selection.


select vbeln,erdat,kunnr,vkorg,waerk from vbak into table @DATA(vbak_it) where vbeln in @S_vbeln and erdat in @S_erdat and kunnr in @S_kunnr .

if vbak_it is not initial.
  select Name1,ort01,kunnr from KNA1 into table @DATA(kna1_it) for all entries in @vbak_it where kunnr = @vbak_it-kunnr.

  select posnr,matnr,kwmeng,vrkme,netwr,vbeln from vbap into table @DATA(vbap_it) for all entries in @vbak_it where vbeln = @vbak_it-vbeln.

  if vbap_it is not initial.
    select maktx,matnr from makt into table @DATA(makt_it) for all entries in @vbap_it where matnr = @vbap_it-matnr.
  endif.
  else.
    message 'Vbak is empty' type 'I'.
endif.

end-of-selection.

loop at vbak_it assigning field-symbol(<fs>).
  wa-vbeln = <fs>-vbeln.
  wa-erdat = <fs>-erdat.
  wa-kunnr = <fs>-kunnr.
  wa-vkorg = <fs>-vkorg.
  wa-waerk = <fs>-waerk.

  read table kna1_it assigning field-symbol(<fs2>) with key kunnr = <fs>-kunnr.
  if <fs2> is assigned.
  wa-name1 = <fs2>-name1.
  wa-ort01 = <fs2>-ort01.

  endif.

 loop at vbap_it assigning field-symbol(<fs3>) where vbeln = <fs>-vbeln.
    wa-posnr = <fs3>-posnr.
    wa-matnr = <fs3>-matnr.
    wa-kwmeng = <fs3>-kwmeng.
    wa-vrkme = <fs3>-vrkme.
    wa-netwr = <fs3>-netwr.




  read table makt_it assigning field-symbol(<fs4>) with key matnr = <fs3>-matnr.
  if <fs4> is assigned.
  wa-maktx = <fs4>-maktx.
  else.
    clear wa-maktx.
  endif.


  append wa to f_result.

endloop.

clear wa.

endloop.



w_fcat-FIELDNAME = 'VBELN'.
w_fcat-SCRTEXT_L = 'sales order'.
w_fcat-HOTSPOT = 'X'.
append w_fcat to t_fcat.
clear w_fcat.

w_fcat-FIELDNAME = 'erdat'.
w_fcat-SCRTEXT_L = 'erdat'.
append w_fcat to t_fcat.
clear w_fcat.

w_fcat-FIELDNAME = 'kunnr'.
w_fcat-SCRTEXT_L = 'kunnr'.
append w_fcat to t_fcat.
clear w_fcat.

w_fcat-FIELDNAME = 'vkorg'.
w_fcat-SCRTEXT_L = 'vkorg'.
append w_fcat to t_fcat.
clear w_fcat.

w_fcat-FIELDNAME = 'waerk'.
w_fcat-SCRTEXT_L = 'waerk'.
append w_fcat to t_fcat.
clear w_fcat.

w_fcat-FIELDNAME = 'name1'.
w_fcat-SCRTEXT_L = 'name1'.
append w_fcat to t_fcat.
clear w_fcat.

w_fcat-FIELDNAME = 'ort01'.
w_fcat-SCRTEXT_L = 'ort01'.
append w_fcat to t_fcat.
clear w_fcat.

w_fcat-FIELDNAME = 'posnr'.
w_fcat-SCRTEXT_L = 'posnr'.
append w_fcat to t_fcat.
clear w_fcat.

w_fcat-FIELDNAME = 'matnr'.
w_fcat-SCRTEXT_L = 'matnr'.
append w_fcat to t_fcat.
clear w_fcat.

w_fcat-FIELDNAME = 'kwmeng'.
w_fcat-SCRTEXT_L = 'kwmeng'.
append w_fcat to t_fcat.
clear w_fcat.

w_fcat-FIELDNAME = 'vrkme'.
w_fcat-SCRTEXT_L = 'vrkme'.
append w_fcat to t_fcat.
clear w_fcat.

w_fcat-FIELDNAME = 'netwr'.
w_fcat-SCRTEXT_L = 'netwr'.
append w_fcat to t_fcat.
clear w_fcat.

w_fcat-FIELDNAME = 'maktx'.
w_fcat-SCRTEXT_L = 'material description'.
append w_fcat to t_fcat.
clear w_fcat.

w_layout-sel_mode = 'D'.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                =
*   I_BUFFER_ACTIVE                   =
    I_CALLBACK_PROGRAM                = sy-repid
*   I_CALLBACK_PF_STATUS_SET          = ' '
    I_CALLBACK_USER_COMMAND           = 'USER_CMD'
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
   IS_LAYOUT_LVC                     = w_layout
     IT_FIELDCAT_LVC                   = t_fcat
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS_LVC             =
*   IT_SORT_LVC                       =
*   IT_FILTER_LVC                     =
*   IT_HYPERLINK                      =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT_LVC                      =
*   IS_REPREP_ID_LVC                  =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 =
*   I_HTML_HEIGHT_END                 =
*   IT_ALV_GRAPHICS                   =
*   IT_EXCEPT_QINFO_LVC               =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    t_outtab                          = f_result
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

form user_cmd using r_cmd like sy-ucomm r_sel type slis_selfield.
  case r_cmd.
    when '&IC1'.
      if r_sel-fieldname eq 'VBELN'.
        read table f_result assigning field-symbol(<wa>) index r_sel-tabindex.
        IF sy-subrc = 0.
          set parameter id 'AUN' field <wa>-vbeln.
          call transaction 'VA03' AND SKIP FIRST SCREEN.
         endif.
        endif.

    when others.
      MESSAGE 'CLIKC BUTTON' TYPE 'i'.
   endcase.

endform.
*loop at f_result assigning field-symbol(<record>).
*  write:<record>-vbeln,<record>-erdat,<record>-kunnr,<record>-vkorg,<record>-waerk,<record>-name1,<record>-ort01,<record>-posnr,<record>-matnr,<record>-kwmeng,<record>-vrkme,<record>-netwr,<record>-maktx.
*  new-line.
*endloop.