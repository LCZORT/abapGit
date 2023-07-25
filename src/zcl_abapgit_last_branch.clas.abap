class ZCL_ABAPGIT_LAST_BRANCH definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_overview,
        favorite            TYPE string,
        "! True for offline, false for online repo
        type                TYPE string,
        key                 TYPE zif_abapgit_persistence=>ty_value,
        name                TYPE string,
        labels              TYPE string_table,
        url                 TYPE string,
        package             TYPE devclass,
        branch              TYPE string,
        created_by          TYPE syuname,
        created_at          TYPE string,
        created_at_raw      TYPE timestampl,
        deserialized_by     TYPE syuname,
        deserialized_at     TYPE string,
        deserialized_at_raw TYPE timestampl,
        write_protected     TYPE abap_bool,
      END OF ty_overview .
  types:
    ty_overviews TYPE STANDARD TABLE OF ty_overview
                   WITH NON-UNIQUE DEFAULT KEY .

  class-methods SET_LAST_BRANCH_LIST
    changing
      !CT_OVERVIEW type TY_OVERVIEWS .
  class-methods IS_LAST_BRANCH_ACTIVE
    returning
      value(RV_ACTIVE) type ABAP_BOOL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPGIT_LAST_BRANCH IMPLEMENTATION.


  METHOD is_last_branch_active.
    DATA ls_settings TYPE zif_abapgit_definitions=>ty_s_user_settings.

    ls_settings = zcl_abapgit_persist_factory=>get_settings( )->read( )->get_user_settings( ).
    rv_active = ls_settings-show_last_branch.

  ENDMETHOD.


  METHOD set_last_branch_list.

    DATA li_user TYPE REF TO zif_abapgit_persist_user.
    DATA lo_repo TYPE REF TO zcl_abapgit_repo_online.
    DATA lv_last_branch TYPE string.

    li_user = zcl_abapgit_persistence_user=>get_instance( ).

    LOOP AT ct_overview ASSIGNING FIELD-SYMBOL(<fs_repo>).
      li_user->get_last_branch(
        EXPORTING
          iv_url         = <fs_repo>-url
        IMPORTING
          rv_last_branch = lv_last_branch ).

      CHECK lv_last_branch IS NOT INITIAL.
      lo_repo ?= zcl_abapgit_repo_srv=>get_instance( )->get( <fs_repo>-key ).
      lo_repo->select_branch( lv_last_branch ).
      <fs_repo>-branch = lv_last_branch.
      CLEAR lv_last_branch.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
