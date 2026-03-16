## Product Selection Page

TODO
- sort items alphabetically
- allow item section to be updated from grocery list
- prevent item that's already in the grocery or fridge lists to be add as a product
- show user added items first
- add frequently/recently purchased items to initial view
- refix items not appearing in product list after being added by user
- Add section filter
- Add more items to the database?

UP NEXT
- Tests

DONE
- Allow API to be accessible over LAN
- Move buttons to correct spots / keep option to manually create grocery item
  -- maybe the full add form can appear on a long press?
- Prevent users from adding an existing product. Maybe the Create can be swapped to update, and disabled for the time being? <:
- Fix list not displaying on initial load <:
- Refresh list so that newly created item appears (if user hasn't added it to grocery list) <:
- Prevent items that are already in the grocery list / fridge from appearing in the selection menu <:
 -- need to join on item id and then exclude products that are not in there

NOT DOING
- Add remaining fields to the create product form -- skip
- Ask users if they want to add the item to their grocery list after creating the product --skip
- Implement an update option -> must also change product to user_created.

