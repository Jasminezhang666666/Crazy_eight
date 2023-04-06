if (phase_shuffle) {
	if (timer == shuffle_time) {
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
	
	timer--;
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
			card_pile[|0].back = false; //turn it face up
			ds_list_add(hand_player,card_pile[|0]);
			ds_list_delete(card_pile,0);	
			target_position[0] += 50;
			if (ds_list_size(hand_player)==5) {
				//new positions for the first card being revealed
				target_position[0] = x + 200;
				target_position[1] = y;
				phase_deal = false;
				phase_firstcard = true;
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
		card_pile[|0].back = false;
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
		
		//if run out of cards in the card pile:
		if (ds_list_size(card_pile) == 0) {
			//give the rest of the discard pile to the card pile
			for (var l = 0; l < ds_list_size(card_discard_pile)-2; l++) {
				card_discard_pile[|0].back = true;
				ds_list_add(card_pile,card_discard_pile[|0]);
				ds_list_delete(card_discard_pile,0)
			}
			//shuffle the new pile:
			randomise();
			ds_list_shuffle(card_pile);
			//display the new card pile
			for (var u = 0; u < ds_list_size(card_pile); u ++) {
				card_pile[|u].x = room_width/2 - 150 + (0.2*u);	
				card_pile[|u].y = room_height/2 - 60 + (0.2*u);
				card_pile[|u].depth = u;
			}
		}
		
		card_pile[|0].x+=(target_position[0]-card_pile[|0].x)*lerp_speed;
		card_pile[|0].y+=(target_position[1]-card_pile[|0].y)*lerp_speed;
		card_pile[|0].depth = hand_player[|(ds_list_size(hand_player)-1)].depth + 1;
		
		if (abs(card_pile[|0].x-(target_position[0]))<0.1) {
			card_pile[|0].back = false;
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
	if (player_selection && keyboard_check(vk_space)) {
		//add the selected ones to a new list named "player_cards_selected"
		for (var w = 0; w < ds_list_size(hand_player); w++) {
			var a = hand_player[|w];
			if (a.selected)  {
				a.selected = false;
				ds_list_add(player_cards_selected, a);
				ds_list_delete(hand_player, w);
				w--; //because the previous one has been removed
			}
		}
		phase_decision = false;
		phase_put_decision = true;
		player_selection = false;
		//positions for the discard pile
		target_position[0] = x + 200;
		target_position[1] = y;
	}
}

if (phase_put_decision) { //put the player-selected cards into the pile, one-by-one
	player_cards_selected[|0].x+=(target_position[0]-player_cards_selected[|0].x)*lerp_speed;
	player_cards_selected[|0].y+=(target_position[1]-player_cards_selected[|0].y)*lerp_speed;
	player_cards_selected[|0].depth = card_discard_pile[|(ds_list_size(card_discard_pile)-1)].depth - 1;
	
	if (abs(player_cards_selected[|0].y-(target_position[1]))<0.05) {
		ds_list_add(card_discard_pile,player_cards_selected[|0]);
		ds_list_delete(player_cards_selected,0);
		if (ds_list_size(player_cards_selected) == 0) { //all player cards have been put down
			phase_put_decision = false;
			if (ds_list_size(hand_player) == 0) {
				player_win = true;
			} else {
				phase_check_card_enemy = true;
				//rearrange all the cards in player's hand:
				for (var i = 0; i < ds_list_size(hand_player); i++) {
					var c = hand_player[|i];
					c.x = room_width/2 - 150 + 50*i;
				}
			}
		}
	}
	
}
	
if (phase_check_card_enemy) {
	//add cards to enemy if none can be played
	var has_card_toplay = false;
	for (var i = 0; i < ds_list_size(hand_enemy); i++) {
		var c = hand_enemy[|i];
		var t = card_discard_pile[|(ds_list_size(card_discard_pile)-1)]; //the top card on the discard pile
		if (c.suit == t.suit || c.num == t.num) {
			has_card_toplay = true;
			phase_check_card_enemy = false;
			phase_enemy_turn = true;
			timer = enemy_time;
		} else {
			//the new card for the enemy
			target_position[0] = room_width/2 - 150 + 50*ds_list_size(hand_enemy);
			target_position[1] = 100;
		}
	}
	
	if (!has_card_toplay) {
		
		//if run out of cards in the card pile:
		if (ds_list_size(card_pile) == 0) {
			//give the rest of the discard pile to the card pile
			for (var l = 0; l < ds_list_size(card_discard_pile)-2; l++) {
				card_discard_pile[|0].back = true;
				ds_list_add(card_pile,card_discard_pile[|0]);
				ds_list_delete(card_discard_pile,0)
			}
			//shuffle the new pile:
			randomise();
			ds_list_shuffle(card_pile);
			//display the new card pile
			for (var u = 0; u < ds_list_size(card_pile); u ++) {
				card_pile[|u].x = room_width/2 - 150 + (0.2*u);	
				card_pile[|u].y = room_height/2 - 60 + (0.2*u);
				card_pile[|u].depth = u;
			}
		}
		
		card_pile[|0].x+=(target_position[0]-card_pile[|0].x)*lerp_speed;
		card_pile[|0].y+=(target_position[1]-card_pile[|0].y)*lerp_speed;
		card_pile[|0].depth = hand_enemy[|(ds_list_size(hand_enemy)-1)].depth + 1;
		
		if (abs(card_pile[|0].x-(target_position[0]))<0.1) {
			ds_list_add(hand_enemy,card_pile[|0]);
			ds_list_delete(card_pile,0);
		}
	}
}

if (phase_enemy_turn) { //enemy will just play one card. Enemy does not know how to do combo.
	if (timer == enemy_time) {
		//positions for the discard pile
		target_position[0] = x + 200;
		target_position[1] = y;
		//enemy selection:
		var t = card_discard_pile[|(ds_list_size(card_discard_pile)-1)];
		for (var i = 0; i < ds_list_size(hand_enemy); i++) {
			var c = hand_enemy[|i];
			if (c.suit == t.suit || c.num == t.num) {
				ene = i;
			}
		}
	} else if (timer <= 0) {
		//putting the enemy decision
		hand_enemy[|ene].x+=(target_position[0]-hand_enemy[|ene].x)*lerp_speed;
		hand_enemy[|ene].y+=(target_position[1]-hand_enemy[|ene].y)*lerp_speed;
		hand_enemy[|ene].depth = card_discard_pile[|(ds_list_size(card_discard_pile)-1)].depth - 1;
		hand_enemy[|ene].back = false;
		if (abs(hand_enemy[|ene].y-(target_position[1]))<0.1) {
			ds_list_add(card_discard_pile,hand_enemy[|ene]);
			ds_list_delete(hand_enemy,ene);
			phase_enemy_turn = false;
			if (ds_list_size(hand_enemy) == 0) {
				enemy_win = true;
			} else {
				phase_check_card = true; //player's turn again;
				//rearrange all the cards in enemy's hand:
				for (var i = 0; i < ds_list_size(hand_enemy); i++) {
					var c = hand_enemy[|i];
					c.x = room_width/2 - 150 + 50*i;
				}
			}
		}
	}
	timer --;
}
