Deface::Override.new(
    virtual_path: 'spree/admin/variants/_form',
    name: 'add_standard_price_to_variants_form',
    insert_top: 'div[data-hook="admin_variant_form_additional_fields"]',
    text: <<-HTML
              
              <div  data-hook="standard_price">
                <%= f.field_container :standard_price, class: ['form-group'] do %>
                  <%= f.label :standard_price, Spree.t(:standard_price) %>
                  <%= f.text_field :standard_price, class: 'form-control standard_price' %>
                  <%= f.error_message_on :standard_price %>
                <% end %>
              </div>
               <div  data-hook="list_price">
                <%= f.field_container :list_price, class: ['form-group'] do %>
                  <%= f.label :list_price, Spree.t(:list_price) %>
                  <%= f.text_field :list_price, class: 'form-control list_price' %>
                  <%= f.error_message_on :list_price %>
                <% end %>
              </div>
          HTML
)