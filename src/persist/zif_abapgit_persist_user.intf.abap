interface ZIF_ABAPGIT_PERSIST_USER
  public .


  types TY_FAVORITES type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO_KEYS .

  methods GET_CHANGES_ONLY
    returning
      value(RV_CHANGES_ONLY) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_DEFAULT_GIT_USER_EMAIL
    returning
      value(RV_EMAIL) type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_DEFAULT_GIT_USER_NAME
    returning
      value(RV_USERNAME) type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_DIFF_UNIFIED
    returning
      value(RV_DIFF_UNIFIED) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_FAVORITES
    returning
      value(RT_FAVORITES) type TY_FAVORITES
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_HIDE_FILES
    returning
      value(RV_HIDE) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_SHOW_FOLDERS
    returning
      value(RV_FOLDERS) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_REPO_GIT_USER_EMAIL
    importing
      !IV_URL type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-URL
    returning
      value(RV_EMAIL) type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_REPO_GIT_USER_NAME
    importing
      !IV_URL type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-URL
    returning
      value(RV_USERNAME) type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_REPO_LAST_CHANGE_SEEN
    importing
      !IV_URL type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-URL
    returning
      value(RV_VERSION) type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_REPO_LOGIN
    importing
      !IV_URL type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-URL
    returning
      value(RV_LOGIN) type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_REPO_SHOW
    returning
      value(RV_KEY) type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-KEY
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods IS_FAVORITE_REPO
    importing
      !IV_REPO_KEY type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-KEY
    returning
      value(RV_YES) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods SET_DEFAULT_GIT_USER_EMAIL
    importing
      !IV_EMAIL type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods SET_DEFAULT_GIT_USER_NAME
    importing
      !IV_USERNAME type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods SET_REPO_GIT_USER_EMAIL
    importing
      !IV_URL type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-URL
      !IV_EMAIL type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods SET_REPO_GIT_USER_NAME
    importing
      !IV_URL type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-URL
      !IV_USERNAME type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods SET_REPO_LAST_CHANGE_SEEN
    importing
      !IV_URL type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-URL
      !IV_VERSION type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods SET_REPO_LOGIN
    importing
      !IV_URL type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-URL
      !IV_LOGIN type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods SET_REPO_SHOW
    importing
      !IV_KEY type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-KEY
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods TOGGLE_CHANGES_ONLY
    returning
      value(RV_CHANGES_ONLY) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_ORDER_BY
    returning
      value(RV_ORDER_BY) type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods SET_ORDER_BY
    importing
      !IV_ORDER_BY type STRING
    returning
      value(RV_ORDER_BY) type STRING
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_ORDER_DESCENDING
    returning
      value(RV_ORDER_DESCENDING) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods SET_ORDER_DESCENDING
    importing
      !IV_ORDER_DESCENDING type ABAP_BOOL
    returning
      value(RV_ORDER_DESCENDING) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_DIFF_FIRST
    returning
      value(RV_DIFF_FIRST) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods SET_DIFF_FIRST
    importing
      !IV_DIFF_FIRST type ABAP_BOOL
    returning
      value(RV_DIFF_FIRST) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods TOGGLE_DIFF_UNIFIED
    returning
      value(RV_DIFF_UNIFIED) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods TOGGLE_FAVORITE
    importing
      !IV_REPO_KEY type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-KEY
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods TOGGLE_HIDE_FILES
    returning
      value(RV_HIDE) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods TOGGLE_SHOW_FOLDERS
    returning
      value(RV_FOLDERS) type ABAP_BOOL
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_SETTINGS
    returning
      value(RS_USER_SETTINGS) type ZIF_ABAPGIT_DEFINITIONS=>TY_S_USER_SETTINGS
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods SET_SETTINGS
    importing
      !IS_USER_SETTINGS type ZIF_ABAPGIT_DEFINITIONS=>TY_S_USER_SETTINGS
    raising
      ZCX_ABAPGIT_EXCEPTION .
  methods GET_LAST_BRANCH
    importing
      !IV_URL type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-URL
    exporting
      !RV_LAST_BRANCH type STRING .
  methods SET_LAST_BRANCH
    importing
      !IV_URL type ZIF_ABAPGIT_PERSISTENCE=>TY_REPO-URL
      !IV_BRANCH type STRING .
endinterface.
