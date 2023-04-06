x = room_width/2 - 150;
y = room_height/2 - 60;

//standard 52 cards: (without jokers
for (var i=1; i<=13; i++) {
	//instance_create_layer(x,y,"Cards",obj_card_club);
}
for (var i=1; i<=13; i++) {
	//instance_create_layer(x,y,"Cards",obj_card_diamond);
}
for (var i=1; i<=13; i++) {
	instance_create_layer(x,y,"Cards",obj_card_heart);
}
for (var i=1; i<=13; i++) {
	instance_create_layer(x,y,"Cards",obj_card_spade);
}

target_position = [0,0];
lerp_speed = 0.3;

shuffle_time = 120;
timer = shuffle_time;

current_selected = card_pile[|0];
player_selection = false;
player_cards_selected = ds_list_create();

enemy_time = 120; //time for enemy decision
ene = 0;


player_win = false;
enemy_win = false;