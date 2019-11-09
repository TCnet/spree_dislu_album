Deface::Override.new(
    virtual_path: 'spree/admin/shared/_main_menu',
    name: 'dislu_album_admin_sidebar_menu',
    insert_top: 'nav',
    partial: 'spree/admin/shared/album_sidebar_menu'
  )