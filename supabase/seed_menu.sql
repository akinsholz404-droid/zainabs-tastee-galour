-- Starting menu (sample prices — edit them from the Admin tab)
insert into public.menu_items (id, cat, name, description, price, art, badge, featured, sort) values
  ('puff-puff', 'Small chops', 'Puff-Puff (12 pcs)', 'Soft, golden, lightly sweet fried dough balls. A Naija classic.', 1.000, 'puff', 'Bestseller', true, 10),
  ('spring-rolls', 'Small chops', 'Spring Rolls (6 pcs)', 'Crispy rolls filled with seasoned vegetables.', 1.500, 'roll', null, false, 20),
  ('samosa', 'Small chops', 'Samosa (6 pcs)', 'Crunchy pastry with spiced minced meat filling.', 1.500, 'samosa', null, false, 30),
  ('gizzard', 'Small chops', 'Peppered Gizzard', 'Fried gizzard tossed in spicy pepper sauce.', 2.000, 'bowl', null, false, 40),
  ('meat-pie', 'Pastries', 'Nigerian Meat Pie', 'Flaky buttery crust with minced beef, potato and carrot.', 0.700, 'pie', 'Customer favourite', true, 50),
  ('sausage-roll', 'Pastries', 'Sausage Roll', 'Golden puff pastry wrapped around seasoned sausage.', 0.600, 'roll', null, false, 60),
  ('scotch-egg', 'Pastries', 'Scotch Egg', 'Boiled egg in seasoned sausage meat, crumbed and fried.', 0.800, 'egg', null, false, 70),
  ('fish-roll', 'Pastries', 'Fish Roll', 'Crispy pastry roll with spiced fish filling.', 0.600, 'roll', null, false, 80),
  ('beef-suya', 'Suya & grills', 'Beef Suya', 'Thin-sliced beef with yaji spice, onions and tomatoes.', 2.500, 'suya', 'Spicy', true, 90),
  ('chicken-suya', 'Suya & grills', 'Chicken Suya', 'Grilled chicken in yaji spice with fresh onions.', 2.300, 'suya', null, false, 100),
  ('chin-chin', 'Crunchy snacks', 'Chin Chin (Jar)', 'Crunchy, sweet fried dough bites. Perfect for sharing.', 1.500, 'jar', null, false, 110),
  ('plantain-chips', 'Crunchy snacks', 'Plantain Chips', 'Thin, crispy plantain chips, lightly salted.', 0.800, 'chips', null, false, 120),
  ('coconut-candy', 'Crunchy snacks', 'Coconut Candy', 'Chewy caramelised coconut treats.', 0.700, 'bowl', null, false, 130),
  ('zobo', 'Drinks', 'Zobo (500 ml)', 'Chilled hibiscus drink with ginger and pineapple.', 0.700, 'zobo', null, false, 140),
  ('chapman', 'Drinks', 'Chapman', 'Nigeria''s favourite fruity mocktail, served chilled.', 1.000, 'chapman', null, false, 150),
  ('kunu', 'Drinks', 'Kunu (500 ml)', 'Smooth millet drink with ginger and spices.', 0.700, 'kunu', null, false, 160),
  ('small-chops-tray', 'Party trays', 'Small Chops Tray (10 people)', 'Puff-puff, samosa, spring rolls, gizzard and suya on one tray.', 9.500, 'tray', 'For events', false, 170),
  ('pastry-box', 'Party trays', 'Pastry Box (20 pcs)', 'A mix of meat pies, sausage rolls and fish rolls.', 11.000, 'tray', null, false, 180)
on conflict (id) do nothing;
