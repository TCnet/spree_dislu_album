Deface::Override.new(
    virtual_path: 'spree/products/show',
    name: 'dislu_album_points',
    insert_before: '#cart-form',
    partial: 'spree/products/points'
  )