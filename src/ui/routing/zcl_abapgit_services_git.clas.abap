class ZCL_ABAPGIT_SERVICES_GIT definition
  public
  final
  create public .

public section.

  class-methods PULL
    importing
      !IV_KEY type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-KEY
    raising
      ZCX_ABAPGIT_EXCEPTION .
  class-methods CREATE_BRANCH
    importing
      !IV_KEY type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-KEY
    raising
      ZCX_ABAPGIT_EXCEPTION .
  class-methods SWITCH_BRANCH
    importing
      !IV_KEY type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-KEY
    raising
      ZCX_ABAPGIT_EXCEPTION .
  class-methods DELETE_BRANCH
    importing
      !IV_KEY type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-KEY
    raising
      ZCX_ABAPGIT_EXCEPTION .
  class-methods DELETE_TAG
    importing
      !IV_KEY type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-KEY
    raising
      ZCX_ABAPGIT_EXCEPTION .
  class-methods SWITCH_TAG
    importing
      !IV_KEY type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-KEY
    raising
      ZCX_ABAPGIT_EXCEPTION .
  class-methods COMMIT
    importing
      !IO_REPO type ref to ZCL_ABAPGIT_REPO_ONLINE
      !IS_COMMIT type ZIF_ABAPGIT_SERVICES_GIT=>TY_COMMIT_FIELDS
      !IO_STAGE type ref to ZCL_ABAPGIT_STAGE
    raising
      ZCX_ABAPGIT_EXCEPTION .
  class-methods CREATE_PULL_REQUEST
    importing
      !IO_REPO type ref to ZCL_ABAPGIT_REPO_ONLINE
      !IS_COMMIT type ZIF_ABAPGIT_SERVICES_GIT=>TY_COMMIT_FIELDS
    exporting
      !EV_R_CODE type I
      !EV_REASON type STRING .
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_ABAPGIT_SERVICES_GIT IMPLEMENTATION.


  METHOD commit.

    DATA: ls_comment TYPE zif_abapgit_git_definitions=>ty_comment,
          li_user    TYPE REF TO zif_abapgit_persist_user.

    li_user = zcl_abapgit_persistence_user=>get_instance( ).
    li_user->set_repo_git_user_name( iv_url      = io_repo->get_url( )
                                     iv_username = is_commit-committer_name ).
    li_user->set_repo_git_user_email( iv_url   = io_repo->get_url( )
                                      iv_email = is_commit-committer_email ).

    IF is_commit-committer_name IS INITIAL.
      zcx_abapgit_exception=>raise( 'Commit: Committer name empty' ).
    ELSEIF is_commit-committer_email IS INITIAL.
      zcx_abapgit_exception=>raise( 'Commit: Committer email empty' ).
    ELSEIF is_commit-author_email IS NOT INITIAL AND is_commit-author_name IS INITIAL.
      zcx_abapgit_exception=>raise( 'Commit: Author name empty' ). " Opposite should be OK ?
    ELSEIF is_commit-comment IS INITIAL.
      zcx_abapgit_exception=>raise( 'Commit: empty comment' ).
    ENDIF.

    ls_comment-committer-name  = is_commit-committer_name.
    ls_comment-committer-email = is_commit-committer_email.
    ls_comment-author-name     = is_commit-author_name.
    ls_comment-author-email    = is_commit-author_email.
    ls_comment-comment         = is_commit-comment.

    IF NOT is_commit-body IS INITIAL.
      CONCATENATE ls_comment-comment '' is_commit-body
        INTO ls_comment-comment SEPARATED BY cl_abap_char_utilities=>newline.
    ENDIF.

    zcl_abapgit_exit=>get_instance(  )->validate_before_push(
      is_comment = ls_comment
      io_stage   = io_stage
      io_repo    = io_repo ).

    io_repo->push( is_comment = ls_comment
                   io_stage   = io_stage ).

    COMMIT WORK.

  ENDMETHOD.


  METHOD create_branch.

    DATA: lv_name               TYPE string,
          lv_cancel             TYPE abap_bool,
          lo_repo               TYPE REF TO zcl_abapgit_repo_online,
          lv_msg                TYPE string,
          li_popups             TYPE REF TO zif_abapgit_popups,
          lv_source_branch_name TYPE string.


    lo_repo ?= zcl_abapgit_repo_srv=>get_instance( )->get( iv_key ).
    lv_source_branch_name = lo_repo->get_selected_branch( ).

    li_popups = zcl_abapgit_ui_factory=>get_popups( ).
    li_popups->create_branch_popup(
      EXPORTING
        iv_source_branch_name = lv_source_branch_name
      IMPORTING
        ev_name               = lv_name
        ev_cancel             = lv_cancel ).

    IF lv_cancel = abap_true.
      RAISE EXCEPTION TYPE zcx_abapgit_cancel.
    ENDIF.

    lo_repo->create_branch( lv_name ).

    lv_msg = |Branch switched from { zcl_abapgit_git_branch_list=>get_display_name( lv_source_branch_name )
      } to new branch { zcl_abapgit_git_branch_list=>get_display_name( lv_name ) }|.
    MESSAGE lv_msg TYPE 'S'.

  ENDMETHOD.


  method CREATE_PULL_REQUEST.

DATA: lo_http_client TYPE REF TO if_http_client,
      lv_url TYPE string,
      lv_body Type string,
      lv_authorization Type string,
      lt_string_parts TYPE TABLE OF string,
      lv_workspace Type string,
      lv_repo Type string,
      lv_branch Type string.

*Url und benoetigte authorization holen
lv_url = io_repo->get_url( ).
lv_authorization = zcl_abapgit_login_manager=>load( lv_url ).

*Aufbereiten der URL
Split lv_url AT '/' INTO TABLE lt_string_parts.
lv_workspace = lt_string_parts[ 4 ].
lv_repo = lt_string_parts[ 5 ].
Clear lt_string_parts.
lv_url = 'https://api.bitbucket.org/2.0/repositories/' && lv_workspace && '/' && lv_repo && '/pullrequests'.

*Branchname nehmen und aufbereiten
lv_repo = IO_REPO->GET_SELECTED_BRANCH( ).
Split lv_repo AT '/' INTO TABLE lt_string_parts.
lv_branch = lt_string_parts[ 3 ].


lv_body = '{"title": "' && is_commit-comment && '", "description": "' && is_commit-BODY && '", "source": {"branch": {"name": "' && lv_branch &&'"}}}'.

*Erstellen des http client
cl_http_client=>create_by_url( EXPORTING
                                url = lv_url
                               IMPORTING
                                client = lo_http_client ).

lo_http_client->request->set_method( if_http_request=>co_request_method_post ).
lo_http_client->request->set_header_field( name  = 'Content-Type'  value = 'application/json' ).
lo_http_client->request->set_header_field( name  = 'Authorization' value = lv_authorization ).
LO_HTTP_CLIENT->REQUEST->APPEND_CDATA( lv_body ).

*Senden des Requests und empfangen
lo_http_client->send( ).
LO_HTTP_CLIENT->RECEIVE( ).
lo_http_client->response->get_status( IMPORTING
                                        code = ev_r_code
                                        reason = ev_reason ).
  endmethod.


  METHOD delete_branch.

    DATA: lo_repo   TYPE REF TO zcl_abapgit_repo_online,
          ls_branch TYPE zif_abapgit_git_definitions=>ty_git_branch,
          lv_msg    TYPE string,
          li_popups TYPE REF TO zif_abapgit_popups.


    lo_repo ?= zcl_abapgit_repo_srv=>get_instance( )->get( iv_key ).

    li_popups = zcl_abapgit_ui_factory=>get_popups( ).
    ls_branch = li_popups->branch_list_popup( iv_url         = lo_repo->get_url( )
                                              iv_hide_branch = lo_repo->get_selected_branch( )
                                              iv_hide_head   = abap_true ).
    IF ls_branch IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abapgit_cancel.
    ENDIF.

    zcl_abapgit_git_porcelain=>delete_branch(
      iv_url    = lo_repo->get_url( )
      is_branch = ls_branch ).

    lv_msg = |Branch { ls_branch-display_name } deleted|.
    MESSAGE lv_msg TYPE 'S'.

  ENDMETHOD.


  METHOD delete_tag.

    DATA: lo_repo TYPE REF TO zcl_abapgit_repo_online,
          ls_tag  TYPE zif_abapgit_git_definitions=>ty_git_tag,
          lv_text TYPE string.

    lo_repo ?= zcl_abapgit_repo_srv=>get_instance( )->get( iv_key ).

    ls_tag = zcl_abapgit_ui_factory=>get_popups( )->tag_list_popup( lo_repo->get_url( ) ).
    IF ls_tag IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abapgit_cancel.
    ENDIF.

    zcl_abapgit_git_porcelain=>delete_tag(
      iv_url = lo_repo->get_url( )
      is_tag = ls_tag ).

    lv_text = |Tag { ls_tag-display_name } deleted|.

    MESSAGE lv_text TYPE 'S'.

  ENDMETHOD.


  METHOD pull.

    DATA: lo_repo TYPE REF TO zcl_abapgit_repo.

    lo_repo ?= zcl_abapgit_repo_srv=>get_instance( )->get( iv_key ).

    lo_repo->refresh( ).

    zcl_abapgit_services_repo=>gui_deserialize( lo_repo ).

  ENDMETHOD.


  METHOD switch_branch.

    DATA: lo_repo   TYPE REF TO zcl_abapgit_repo_online,
          ls_branch TYPE zif_abapgit_git_definitions=>ty_git_branch.


    lo_repo ?= zcl_abapgit_repo_srv=>get_instance( )->get( iv_key ).

    ls_branch = zcl_abapgit_ui_factory=>get_popups( )->branch_list_popup(
      iv_url             = lo_repo->get_url( )
      iv_default_branch  = lo_repo->get_selected_branch( )
      iv_show_new_option = abap_true ).
    IF ls_branch IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abapgit_cancel.
    ENDIF.

    IF ls_branch-name = zif_abapgit_popups=>c_new_branch_label.
      create_branch( iv_key ).
      RETURN.
    ENDIF.

    IF lo_repo->get_selected_commit( ) IS NOT INITIAL.
      lo_repo->select_commit( space ).
    ENDIF.

    lo_repo->select_branch( ls_branch-name ).
    COMMIT WORK AND WAIT.

  ENDMETHOD.


  METHOD switch_tag.

    DATA: lo_repo TYPE REF TO zcl_abapgit_repo_online,
          ls_tag  TYPE zif_abapgit_git_definitions=>ty_git_tag,
          lv_text TYPE string.

    lo_repo ?= zcl_abapgit_repo_srv=>get_instance( )->get( iv_key ).

    ls_tag = zcl_abapgit_ui_factory=>get_popups( )->tag_list_popup( lo_repo->get_url( ) ).
    IF ls_tag IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abapgit_cancel.
    ENDIF.

    lo_repo->select_branch( zcl_abapgit_git_tag=>remove_peel( ls_tag-name ) ).

    COMMIT WORK AND WAIT.

    lv_text = |Tag switched to { ls_tag-display_name } |.

    MESSAGE lv_text TYPE 'S'.

  ENDMETHOD.
ENDCLASS.
