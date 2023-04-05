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
	show_debug_message(card_pile[|0].depth);
	
	if (abs(card_pile[|0].x-(target_position[0]))<0.1) {
		show_debug_message("FUCK")
		if (card_pile[|0].num != 8) { //put a new one if 8
			phase_firstcard = false;
			phase_decision = true;
		}
		ds_list_add(card_discard_pile,card_pile[|0]);
		ds_list_delete(card_pile,0);
	}
}

if (phase_decision) {
	//the juicy indication of card selection:
	for (var i = 0; i < ds_list_size(hand_player); i++) {
		var c = hand_player[|i];
		if (!player_selected && mouse_x > (c.x + 51) && mouse_x < (c.x+c.sprite_width) && mouse_y > c.y && mouse_y < (900+c.sprite_height)) {
			c.y = 500;
			/*
			if (mouse_check_button_pressed(mb_left)) { //and player selected the card
				ply = i;
				player_selected = true;
				hand_enemy[|ene].back = false;
				audio_play_sound(snd_flip,0,false);
			}
			*/
		} else if (!player_selected) {
			c.y = 550;
		}
	}
}

/*
if (phase_decision) {
	if (!enemy_decision_finished) {
		hand_enemy[|ene].x+=(target_position[0]-hand_enemy[|ene].x)*lerp_speed;
		hand_enemy[|ene].y+=(target_position[1]-hand_enemy[|ene].y)*lerp_speed;
		
		if (abs(hand_enemy[|ene].y-target_position[1])<0.2) {
			enemy_decision_finished = true;
		}
	}	
	
	//the juicy indication of decision:
	for (var i = 0; i < ds_list_size(hand_player); i++) {
		var c = hand_player[|i];
		if (!player_selected && mouse_x > c.x && mouse_x < (c.x+c.sprite_width) && mouse_y > c.y && mouse_y < (900+c.sprite_height)) {
			c.y = 865;
			if (mouse_check_button_pressed(mb_left)) { //and player selected the card
				ply = i;
				player_selected = true;
				hand_enemy[|ene].back = false;
				audio_play_sound(snd_flip,0,false);
			}
		} else if (!player_selected) {
			c.y = 900;
		}
	}
	
	if (player_selected) {
		hand_player[|ply].x+=(600-hand_player[|ply].x)*lerp_speed;
		hand_player[|ply].y+=(625-hand_player[|ply].y)*lerp_speed;
	}
	
	if (abs(hand_player[|ply].y-625)<0.2 && enemy_decision_finished) {
		phase_scoring = true;
		phase_decision = false;
		timer = scoring_time;
		player_selected = false;
		enemy_decision_finished = false;
	}
}*/

timer--;