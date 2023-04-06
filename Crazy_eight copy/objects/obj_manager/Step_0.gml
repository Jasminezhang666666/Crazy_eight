if (phase_shuffle) {
	if (timer == shuffle_time) {
		
	show_debug_message("Shuffle")
		randomise();
		ds_list_shuffle(card_pile);
		//shuffle the cards and display the card pile on the left
		for (var u = 0; u < ds_list_size(card_pile); u ++) {
			card_pile[|u].x = room_width/2 - 150 + (0.2*u);	
			card_pile[|u].y = room_height/2 - 60 + (0.2*u);
			card_pile[|u].depth = u;
		}
	} else if (timer <= 0) {
		phase_deal = true;
		phase_shuffle = false;
		target_position = [room_width/2 - 150,100];
	}
}

if (phase_deal) {
	card_pile[|0].x+=(target_position[0]-card_pile[|0].x)*lerp_speed;
	card_pile[|0].y+=(target_position[1]-card_pile[|0].y)*lerp_speed;

	if (abs(card_pile[|0].y-(target_position[1]))<0.1) {
		if (ds_list_size(hand_enemy)<5) {
			ds_list_add(hand_enemy,card_pile[|0]);
			target_position[0] += 50;
			if (ds_list_size(hand_enemy)==5) {
				//new positions for player's hands
				target_position[0] = room_width/2 - 150;
				target_position[1] = 550;
			}
			ds_list_delete(card_pile,0);	
		} else if (ds_list_size(hand_player)<5) {
			ds_list_add(hand_player,card_pile[|0]);
			ds_list_delete(card_pile,0);	
			target_position[0] += 50;
			if (ds_list_size(hand_player)==5) {
				//new positions for the first card being revealed
				target_position[0] = x + 200;
				target_position[1] = y;
				phase_deal = false;
				phase_firstcard = true;
				//player hands visible
				for (var j = 0; j<ds_list_size(hand_player); j++) {
					hand_player[|j].back = false;
				}
			}
		} 
	}
}

if (phase_firstcard) {
	card_pile[|0].x+=(target_position[0]-card_pile[|0].x)*lerp_speed;
	card_pile[|0].y+=(target_position[1]-card_pile[|0].y)*lerp_speed;
	if (ds_list_size(card_discard_pile) > 0) {
		//so discard cards are on top of each other
		card_pile[|0].depth = card_discard_pile[|(ds_list_size(card_discard_pile)-1)].depth - 1;
	}
	
	if (abs(card_pile[|0].x-(target_position[0]))<0.1) {
		if (card_pile[|0].num != 8) { //put a new one if 8
			phase_firstcard = false;
			phase_check_card = true;	
		}
		ds_list_add(card_discard_pile,card_pile[|0]);
		ds_list_delete(card_pile,0);
	}
}

if (phase_check_card) {
	//add cards to player if none can be played
	var has_card_toplay = false;
	for (var i = 0; i < ds_list_size(hand_player); i++) {
		var c = hand_player[|i];
		var t = card_discard_pile[|(ds_list_size(card_discard_pile)-1)]; //the top card on the discard pile
		if (c.suit == t.suit || c.num == t.num) {
			has_card_toplay = true;
			phase_check_card = false;
			phase_decision = true;
		} else {
			//the new card for the player
			target_position[0] = room_width/2 - 150 + 50*ds_list_size(hand_player);
			target_position[1] = 550;
		}
	}
	
	if (!has_card_toplay) {
		card_pile[|0].x+=(target_position[0]-card_pile[|0].x)*lerp_speed;
		card_pile[|0].y+=(target_position[1]-card_pile[|0].y)*lerp_speed;
		
		if (abs(card_pile[|0].x-(target_position[0]))<0.1) {
			ds_list_add(hand_player,card_pile[|0]);
			ds_list_delete(card_pile,0);
		}
	}
}

if (phase_decision) { //player's decision time
	//the juicy indication of card selection:
	for (var i = 0; i < ds_list_size(hand_player); i++) {
		var c = hand_player[|i];
		if (mouse_x > (c.x + 51) && mouse_x < (c.x+c.sprite_width) && mouse_y > c.y && mouse_y < (900+c.sprite_height)) {
			c.y = 500;
			var t = card_discard_pile[|(ds_list_size(card_discard_pile)-1)]; //the top card on the discard pile
			if (mouse_check_button_pressed(mb_left)) { //and player selected the card
				if (c.suit == t.suit || c.num == t.num){
					//selected a card that can be selected according to the discard pile:
					if (!c.selected) {
						c.selected = true;
						player_selection = true;
						c.y = 500;
						current_selected = c;
					} else { //deselect this and all others with the same num
						c.selected = false;
						c.y = 550;
						current_selected = noone;
						player_selection = false;
						for (var d = 0; d < ds_list_size(hand_player); d++) {
							hand_player[|d].selected = false;
							hand_player[|d].y = 550;
						}
					}
				} else if (current_selected != noone && c.num == current_selected.num) {
					if (!c.selected) {
						c.selected = true;
						c.y = 500;
					} else { //deselect
						c.selected = false;
						c.y = 550;
					}
				}
			}
			
		} else if (!c.selected) {
			c.y = 550;
		}
	}
	
	//the final decision of which cards to choose:
	if (player_selection && keyboard_check_pressed(vk_space)) {
		//add the selected ones to a new list named "player_cards_selected"
		for (var i = 0; i < ds_list_size(hand_player); i++) {
			var c = hand_player[|i];
			if (c.selected)  {
				c.selected = false;
				ds_list_add(player_cards_selected, c);
				ds_list_delete(hand_player, i);
			}
		}
		phase_decision = false;
		phase_put_decision = true;
		//positions for the discard pile
		target_position[0] = x + 200;
		target_position[1] = y;
	}
}

if (phase_put_decision) { //put the player-selected cards into the pile, one-by-one
	player_cards_selected[|0].x+=(target_position[0]-player_cards_selected[|0].x)*lerp_speed;
	player_cards_selected[|0].y+=(target_position[1]-player_cards_selected[|0].y)*lerp_speed;
	
	if (abs(player_cards_selected[|0].y-(target_position[1]))<0.1) {
		ds_list_add(card_discard_pile,player_cards_selected[|0]);
		ds_list_delete(player_cards_selected,0);
		if (ds_list_size(player_cards_selected) == 0) { //all player cards have been put down
			phase_put_decision = false;
			phase_enemy_turn = true;
		}
	}
}

if (phase_enemy_turn) {
	
}

timer--;