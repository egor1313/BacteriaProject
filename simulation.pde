

int[] rotate2coords(int r){
  // 0 влево, 1 лево-вверх, 2 вверх, 3 вверх право, 4 вправо, 5 вправо-низ, 6 низ, 7 низ-лево
  int x = 0;
  int y = 0;
  
  if ( r == 0){
    x -= 1;
  }
  else if (r == 1){
    x -= 1;
    y -= 1;
  }
  else if (r == 2){
    y -= 1;
  }
  else if (r == 3){
    x += 1;
    y -= 1;
  }
  else if (r == 4){
    x += 1;
  }
  else if (r == 5){
    x += 1;
    y += 1;
  }
  else if (r == 6){
    y += 1;
  }
  else if (r == 7){
    x -= 1;
    y += 1;
  }
  
  int[] xy = new int[2];
  
  xy[0] = x;
  xy[1] = y;
  
  return xy;
}

float diff_mind(Mind mind1, Mind mind2){
  if (mind1.count_of_layers != mind2.count_of_layers){
    return 1;
  }
  int r = 0;
  for(int i = 1; i < mind1.count_of_layers; i++){
    r += abs(mind1.layers_size.get(i) - mind2.layers_size.get(i));
  }
  if (r > 4){
    return 1;
  }
  float[] a = new float[mind1.count_of_layers-1];
  float[] b = new float[mind1.count_of_layers-1];
  a = mind1.sum_of_gens();
  b = mind2.sum_of_gens();
  float res = 0;
  for(int i = 0; i < mind1.count_of_layers-1; i++){
    res += abs(abs(a[i]) - abs(b[i]));
  }
  if (res > max_dif_w){
    max_dif_w = res;
  }
  return (res /  max_dif_w);
}

int x_save(int x){
  return (x + sim_width) % sim_width;
}

int y_save(int y){
  return (y + sim_height) % sim_height;
}

void kill(int x, int y, int k){
  bacts[k] = null;
  last_free_cell++;
  free_cells[last_free_cell] = k;
  for_circle_right[for_circle_left[k]] = for_circle_right[k];
  for_circle_left[for_circle_right[k]] = for_circle_left[k];
  map[x][y] = 0;
}

void simulationStep(){ // кол-во входных нейронов // 1. энергия, 2. поворот, 3. - 10. насколько вокруг твоя колония. 11 - 16. прошлые выходы * memory_coef
  int k = 0;
  int size_of_bacteries = 0;
  int count_of_photos = 0;
  int count_of_atack = 0;
  int count_of_organics = 0;
  float count_of_force = 0;
  float count_of_neurons = 0;
  float count_of_energy = 0;
  float count_of_age = 0;
  float count_of_size_of_layers = 0;
  float count_of_random_users = 0;
  float count_of_percent_of_mutate = 0;
  float count_of_giving_energy = 0;
  int count_of_relu = 0;
  int count_of_binar = 0;
  int count_of_radial = 0;
  int count_of_sigmoid = 0;
  float average_neuron_porog = 0;
  while( for_circle_right[k] != 0 ){ 
    
    k = for_circle_right[k];
    Agent b = bacts[k];
    
    
    int x = b.x;
    int y = b.y;
    
    if (b.is_troop == 1){
      
      /*if (y == sim_height - 1){
        continue;
      }
      if (map[x][y+1] == 0 && b.is_falling_troop == 1){
        b.y++;
        map[x][y+1] = map[x][y];
        map[x][y] = 0;
      }
      else{
        b.is_falling_troop = 0;
      }*/
      continue;
    }
    
    b.age+=1;
    b.energy -= iter_energy + b.count_of_neurons * need_epoch_for_neuron + b.force*nead_epoch_for_force + b.age*age_energy_coef;
    
    if (b.energy <= 0 || b.age >= b.max_age){ // kill
      //b.is_troop = 1;
      if (b.age >= b.max_age){
        b.is_troop = 1;
        continue;
      }
      
      kill(x, y, k);
      continue;
    }
    
    
    float[] inp = new float[neurons_input_size];// 1. энергия, 2. поворот, 3. высота, 4. возвраст, 
    //5. что видим (-1 - ничего, 0 - стенка, 1 - бактерия), 6. насколько отличается ( -1 - пусто -0 - ни насколько 1 - много) 7. есть ли впереди органика(1/ 0)
    inp[0] = b.energy;
    inp[1] = b.rotation / 7;
    inp[2] = y / sim_height;
    inp[3] = b.age / b.max_age;
    
    int rotation = b.rotation; // 0 влево, 1 лево-вверх, 2 вверх, 3 вверх право, 4 вправо, 5 вправо-низ, 6 низ, 7 низ-лево
    int[] vect = rotate2coords(rotation);
    int x1 = vect[0];
    int y1 = vect[1];
    int xf = x + x1;
    int yf = y + y1;
    xf = (xf + sim_width) % sim_width;
    
    if ( yf == -1 || yf == sim_height ){
      inp[4] = -1;
    }
    else if (map[xf][yf] == 0){
      inp[4] = 0;
    }
    else{
      inp[4] = 1;
    }
    if (yf != -1 && yf != sim_height && map[xf][yf] != 0 && bacts[map[xf][yf]] == null){
      println("sad");
    }
    if ( yf != -1 && yf != sim_height && map[xf][yf] != 0 && bacts[map[xf][yf]].is_troop == 0){
      float diff =  diff_mind( b.mind,bacts[map[xf][yf]].mind);
      inp[5] = diff;
      //println(diff);
      //println(diff);
      if (inp[5] <= b.coef_is_my_gens){
        inp[5] = 0;
      }
      else{
        inp[5] = 1;
      }
    }
    else{
      inp[5] = -1;
    }
    if ( yf == -1 || yf == sim_height || map[xf][yf] == 0 || bacts[map[xf][yf]].is_troop == 0){
      inp[6] = 0;
    }
    else{
      inp[6] = 1;
    }
    //b.last_out = out;
    
    
    float[] out = new float[max_neurons_in_layer];
    out = b.mind.activate_mind(inp); // 1. энергия, 2. поворот, 3. высота, 4. возвраст, 5. что видим (-1 - стенка, 0 - ничего, 1 - бактерия), 6. насколько отличается ( -1 - пусто -0 - ни насколько 1 - много)
    
    //print(out[0], out[1], out[2], out[3], out[4], out[5]);
    //print("\n");
    
    // 0, делиться ли, 1. кусать ли, 2. будем ли есть органику 3. ходить ли, 4. передать ли енергии 5. фотосинтезировать ли, 6. хотим ли повернуться, 7. насколько повернуться
    
    if (out[0] >= 0.5){ // будет ли бактерия делиться
      if ( yf != -1 && yf != sim_height && map[xf][yf] == 0 && b.age <= max_age_for_multiply){
       
       if (b.energy <= energy_to_multiply){ // kill
         kill(x, y, k);
         continue;
       }
       
       Agent child = new Agent(0); 
       int child_i = free_cells[last_free_cell];
       last_free_cell -= 1;
       
       b.energy -= energy_to_multiply;
       child.energy = b.energy*b.energy_multiply_coef;
       
       child.x = xf;
       child.y = yf;
       child.inheritance(b);
       bacts[child_i] = child;
       map[xf][yf] = child_i;
       int l = child_i-1;
       while(l>0 && bacts[l]==null){
         l--;
       }
       int r = for_circle_right[l];
       for_circle_left[child_i] = l;
       for_circle_right[child_i] = r;
       for_circle_left[r] = child_i;
       for_circle_right[l] = child_i;
       
       //b.energy -= energy_to_multiply;
       
       b.energy -= b.energy*b.energy_multiply_coef;
      }
    }
    if (out[1] >= 0.5){ // будет ли бактерия есть того, на кого смотрит
      if ( yf != -1 && yf != sim_height && map[xf][yf] != 0 && bacts[map[xf][yf]].is_troop == 0){
        if (b.energy <= needs_to_eat_bots){
          kill(x, y, k);
          continue;
        }
        b.energy += min(bacts[map[xf][yf]].energy , b.force*force_coef_mult_energy);
        int fi = map[xf][yf];
        bacts[fi].energy -= b.force*force_coef_mult_energy;
        if (bacts[fi].energy <= 0){
          kill(xf, yf, fi);
          continue;
        
        }
        //b.energy += 20;//bacts[map[xf][yf]].energy;
        //int fi = map[xf][yf];
        //kill(xf, yf, fi);
        b.atack += 1;
        
      }
    }
    if (out[2] >= 0.5){ // хотим ли поесть труппов
      if (yf != -1 && yf != sim_height && map[xf][yf] != 0 && bacts[map[xf][yf]].is_troop == 1){
        if (b.energy <= needs_to_eat_oraganics){
          kill(x, y, k);
          continue;
        }
        int pam = map[xf][yf];
        b.energy += bacts[pam].energy*energy_for_troops_coef;
        kill(xf, yf, pam);
        b.troop += 1;
      }
    }
    
    if (out[6] >= 0.5){ // потом настроить // насколько бактерия будет поварачиватьс
      //println(out[7]);
      b.rotate(out[7]);
    }
    
    if (out[3] >= 0.5){ // будет ли бактерия ходить
      if ( yf != -1 && yf != sim_height && map[xf][yf] == 0){
        map[xf][yf] = k;
        map[x][y] = 0;
        b.x = xf;
        b.y = yf;
        b.energy -= energy_for_walking;
        if (b.energy <= 0){
          kill(xf, yf, k);
          continue;
        }
        
      }
    }
    else if (out[4]  >= 0.5){ // хотим ли передать енергию кому-то
      if(yf != -1 && yf != sim_height && map[xf][yf] != 0 && bacts[map[xf][yf]].is_troop == 0){
        bacts[map[xf][yf]].energy += min(give_energy_to_friend, b.energy);
        b.energy -= give_energy_to_friend;
        if (b.energy <= 0){
          kill(x, y, k);
          continue;
        }
      }
    
    }
    /*int rotation2 = b.rotation; // 0 влево, 1 лево-вверх, 2 вверх, 3 вверх право, 4 вправо, 5 вправо-низ, 6 низ, 7 низ-лево
    int[] vect2 = rotate2coords(rotation2);
    x1 = vect2[0];
    y1 = vect2[1];
    xf = x + x1;
    yf = y + y1;
    xf = (xf + sim_width) % sim_width;*/
    
    
    
    if (out[5] >= 0.5){ // будет ли бактерия фотосинтезировать
      if (y <= sim_height/10){
        b.energy += energy_for_photosintese;
      }
      else if(y <= 2*sim_height/10){
        b.energy += energy_for_photosintese-2;
      }
      else if(y <= 3*sim_height/10){
        b.energy += energy_for_photosintese-3;
      }
      else if(y <= 4*sim_height/10){
        b.energy += energy_for_photosintese-4;
      }
      else if(y <= 5*sim_height/10){
        b.energy += energy_for_photosintese-5;
      }
      else if(y <= 6*sim_height/10){
        b.energy += energy_for_photosintese-6;
      }
      else if(y <= 7*sim_height/10){
        b.energy += energy_for_photosintese-6;
      }
      else if(y <= 8*sim_height/10){
        b.energy += energy_for_photosintese-6;
      }
      else if(y <= 9*sim_height/10){
        b.energy += energy_for_photosintese-7;
      }
      else{
        b.energy += energy_for_photosintese-8;
      }
      b.phot += 1;
    }
    
    if (b.energy >= max_energy){
      b.energy = max_energy;
    }
    
    if (b.energy >= max_energy && use_die_if_no_place){
    
      int die = 1;
      int[] xok = new int[8];
      int[] yok = new int[8];
      int pam = 0;
      for(int i = -1; i < 2; i++){
        for (int j = -1; j < 2; j++){
          if (i == j && i == 0){
            continue;
          }
          if (y == 0 && j == -1){
            continue;
          }
          if (y == sim_height-1 && j == 1){
            continue;
          }
          xok[pam] =  x + i;
          xok[pam] = (xok[pam] + sim_width) % sim_width;
          yok[pam] = y + j;
          
          if (map[xok[pam]][yok[pam]] == 0){
            die = 0;
            pam++;
          }
          
          
        }
      }
      //int t = int(random(0, pam));
      if (die == 1){
        
        bacts[k].is_troop = 1;
        //else{
        //  kill(x, y, k);
        //}
        continue;
      }
      else if(born_when_have_energy){
        if ( yf != -1 && yf != sim_height && map[xf][yf] == 0){
        Agent child = new Agent(0); 
        int child_i = free_cells[last_free_cell];
        last_free_cell -= 1;
        if (i <= energy_to_multiply){ // kill
          bacts[k] = null;
          last_free_cell++;
          free_cells[last_free_cell] = k;
          for_circle_right[for_circle_left[k]] = for_circle_right[k];
          for_circle_left[for_circle_right[k]] = for_circle_left[k];
          map[x][y] = 0;
          continue;
        }
        b.energy -= energy_to_multiply;
        child.energy = b.energy*b.energy_multiply_coef;
        
        child.x = xf;
        child.y = yf;
        child.inheritance(b);
        bacts[child_i] = child;
        map[xf][yf] = child_i;
        int l = child_i-1;
        while(l>0 && bacts[l]==null){
          l--;
        }
        int r = for_circle_right[l];
        for_circle_left[child_i] = l;
        for_circle_right[child_i] = r;
        for_circle_left[r] = child_i;
        for_circle_right[l] = child_i;
       
        //b.energy -= energy_to_multiply;
       
        b.energy -= b.energy*b.energy_multiply_coef;
        
       }
     }
   }
  
    size_of_bacteries+=1;
    if (colorph*b.phot > colorea*b.atack && colorph*b.phot > colortr*b.troop){
      count_of_photos += 1;
    }
    else if ( colorea*b.atack > colorph*b.phot && colorea*b.atack > colortr*b.troop){
      count_of_atack += 1;
    }
    else{
      count_of_organics += 1;
    }
    count_of_force += b.force;
    count_of_energy += b.energy;
    count_of_neurons += b.mind.count_off_neurons;
    count_of_age += b.max_age;
    count_of_size_of_layers += b.mind.count_of_layers;
    count_of_relu += b.mind.act_count[0];
    count_of_binar += b.mind.act_count[1];
    count_of_radial += b.mind.act_count[2];
    count_of_sigmoid += b.mind.act_count[3];
    average_neuron_porog += b.coef_is_my_gens;
    if (b.mind.use_random){
      count_of_random_users += 1;
    }
    count_of_percent_of_mutate += b.mind.percent_of_change_nn_weight_and_activation;
    if (out[4] > 0){
      count_of_giving_energy += 1;
    } 
  }
  
  TableRow newRow = stats.addRow();
  newRow.setInt("Epoch_count", epoch_count);
  newRow.setInt("Agent's size", size_of_bacteries);
  newRow.setInt("Size of predators", count_of_atack);
  newRow.setInt("Size of sun eaters", count_of_photos);
  newRow.setInt("Size of organics eaters", count_of_organics);
  newRow.setFloat("Average agent's neurons size", count_of_neurons / (float) size_of_bacteries);
  newRow.setFloat("Average agent's force", count_of_force / (float) size_of_bacteries);
  newRow.setFloat("Average agent's energy", count_of_energy / (float) size_of_bacteries);
  newRow.setFloat("Average agent's max age", count_of_age / (float) size_of_bacteries);
  newRow.setFloat("Average agent's layers", count_of_size_of_layers / (float) size_of_bacteries);
  newRow.setFloat("Average agent's random_use", count_of_random_users / (float) size_of_bacteries);
  newRow.setFloat("Average agent's percent of mutate", count_of_percent_of_mutate / (float) size_of_bacteries);
  newRow.setFloat("Average agent's giving energy", count_of_giving_energy / (float) size_of_bacteries);
  newRow.setInt("Count rulu agent activation", count_of_relu);
  newRow.setInt("Count binar agent activation", count_of_binar);
  newRow.setInt("Count radial agent activation", count_of_radial);
  newRow.setInt("Count sigmoid agent activation", count_of_sigmoid);
  newRow.setFloat("Average gen porog", average_neuron_porog/ (float) size_of_bacteries);
  //println((float)count_of_neurons / (float) size_of_bacteries);
  
}
void paint_world(int x){
  if (x == 0){
    screen1.beginDraw();
    screen1.noStroke();
  
    screen1.fill(30, 30, 30);
    screen1.rect(0, 0, width, height);
  
    screen1.stroke(30,30,30);
    int k = 0;
  
    while( for_circle_right[k] != 0 ){ 
      Agent i = bacts[for_circle_right[k]];
      k=for_circle_right[k];
      if ( i.is_troop == 1 ){
        screen1.fill(220, 220, 220);
      }
      if(use_troops == false || i.is_troop == 0){
        screen1.fill(int(255*i.atack*i.atack*colorea/(i.atack*i.atack*colorea + i.phot*i.phot*colorph + i.troop*i.troop*colortr)), int(255*i.phot*i.phot*colorph/(i.atack*i.atack*colorea + i.phot*i.phot*colorph + i.troop*i.troop*colortr)), int(255*i.troop*i.troop*colortr/(i.atack*i.atack*colorea + i.phot*i.phot*colorph + i.troop*i.troop*colortr)));
      }
      screen1.rect(cell_size*i.x, cell_size*i.y, cell_size, cell_size);
    }
    screen1.endDraw();
  }
  else if(x == 1){
    screen2.beginDraw();
    screen2.noStroke();
  
    screen2.fill(30, 30, 30);
    screen2.rect(0, 0, width, height);
  
    screen2.stroke(30,30,30);
    int k = 0;
  
    while( for_circle_right[k] != 0 ){ 
      Agent i = bacts[for_circle_right[k]];
      k=for_circle_right[k];
      if ( i.is_troop == 1 ){
        screen2.fill(220, 220, 220);
      }
      if(use_troops == false || i.is_troop == 0){
        screen2.fill(i.color1);
      }

      screen2.rect(cell_size*i.x, cell_size*i.y, cell_size, cell_size);
    }
  
    screen2.endDraw();
  }
  else if(x == 2){
    screen3.beginDraw();
    screen3.noStroke();
  
    screen3.fill(30, 30, 30);
    screen3.rect(0, 0, width, height);
  
    screen3.stroke(30,30,30);
    int k = 0;
  
    while( for_circle_right[k] != 0 ){ 
      Agent i = bacts[for_circle_right[k]];
      k=for_circle_right[k];
      screen3.stroke(30,30,30);
      if ( i.is_troop == 1 ){
        screen3.fill(220, 220, 220);
      }
      if(use_troops == false || i.is_troop == 0){
        screen3.fill(int(255*i.energy*i.energy / max_energy*max_energy), int(255*i.energy / max_energy), 0); //  желтые - много энергии, красные - мало
      }
      if ( i.is_troop == 1 && white_black){
        screen3.stroke(255,30,30);
        screen3.fill(int(255*i.energy / max_energy));
      }
      else if (white_black){
        screen3.fill(int(255*i.energy / max_energy));
      }

      screen3.rect(cell_size*i.x, cell_size*i.y, cell_size, cell_size);
    }
    screen3.endDraw();
  }
  else if (x == 3){
    screen1.beginDraw();
    screen1.noStroke();
    screen1.fill(30, 30, 30);
    screen1.rect(0, 0, width, height);
    screen1.stroke(30,30,30);
    
    screen2.beginDraw();
    screen2.noStroke();
    screen2.fill(30, 30, 30);
    screen2.rect(0, 0, width, height);
    screen2.stroke(30,30,30);
    
    screen3.beginDraw();
    screen3.noStroke();
    screen3.fill(30, 30, 30);
    screen3.rect(0, 0, width, height);
    screen3.stroke(30,30,30);
    
    int k = 0;
    
    while( for_circle_right[k] != 0 ){ 
      Agent i = bacts[for_circle_right[k]];
      k=for_circle_right[k];
      
      if ( i.is_troop == 1 ){
        screen1.fill(220, 220, 220);
      }
      if(use_troops == false || i.is_troop == 0){
        screen1.fill(int(255*i.atack*i.atack/(i.atack*i.atack + i.phot*i.phot + i.troop*i.troop)), int(255*i.phot*i.phot/(i.atack*i.atack + i.phot*i.phot + i.troop*i.troop)), int(255*i.troop*i.troop/(i.atack*i.atack + i.phot*i.phot + i.troop*i.troop)));
      }
      screen1.rect(cell_size*i.x, cell_size*i.y, cell_size, cell_size);
      
      if ( i.is_troop == 1 ){
        screen2.fill(220, 220, 220);
      }
      if(use_troops == false || i.is_troop == 0){
        screen2.fill(i.color1);
      }
      screen2.rect(cell_size*i.x, cell_size*i.y, cell_size, cell_size);
      
      
      screen3.stroke(30,30,30);
      if ( i.is_troop == 1 ){
        screen3.fill(220, 220, 220);
      }
      if(use_troops == false || i.is_troop == 0){
        screen3.fill(int(255*i.energy*i.energy / max_energy*max_energy), int(255*i.energy / max_energy), 0); //  желтые - много энергии, красные - мало
      }
      if ( i.is_troop == 1 && white_black){
        screen3.stroke(255,30,30);
        screen3.fill(int(255*i.energy / max_energy));
      }
      else if (white_black){
        screen3.fill(int(255*i.energy / max_energy));
      }
      screen3.rect(cell_size*i.x, cell_size*i.y, cell_size, cell_size);
    }
    
    screen1.endDraw();
    screen2.endDraw();
    screen3.endDraw();
  }
}

Agent new_rand_bact(int x, int y){ // создаем новую бактерию ( чистую )
  Agent new1 = new Agent(1);
  new1.x = x;
  new1.y = y;
  return new1;
}

void spawn_start_bacts(){ // создаем #count_of_start_bacts начальных случайных бактерий
  for_circle_right[0] = 1;
  for_circle_left[0] = count_of_start_bacts;
  for(int i = 1; i <= count_of_start_bacts; i++){
    int x, y;
    
    x = int(random(0, sim_width));
    y = int(random(0, sim_height));
    while(map[x][y] != 0){
      x = int(random(0, sim_width));
      y = int(random(0, sim_height));
    }
    map[x][y] = i;
    bacts[i] = new_rand_bact(x, y);
    for_circle_right[i] = i+1;
    for_circle_left[i] = i - 1;
    
  }
  for_circle_right[count_of_start_bacts] = 0;
}

float sigmoid(float x){ // применяем функцию сигмоиды к float
  return 1 / (1+exp(-x));
}

float relu(float x){ // применяем функцию релу к float
  /*if ( x > 1 ){
    return 1;
  } */ 
  if(x > 0){
    return x;
  }
  else{
    return 0;
  }
}

float binar(float x){
  if (x > 0.5){
    return 1.0;
  }
  else{
    return 0.0;
  }
}

float radial_basis(float x){
  if (x > 0.40 && x < 0.6){
    return 1;
  }
  else{
    return 0;
  }
}

void sigmoid_arr(int n, float[] x){ // применяем функцию сигмоиды к float[]
  for(int i = 0; i < n; i++){
    x[i] = sigmoid(x[i]);
    x[i] += 1;
    x[i] /= 2;
  }
  
}
void relu_arr(int n, float[] x){ // применяем функцию релу к float[]
  for(int i = 0; i < n; i++){
    x[i] = relu(x[i]);
  }
}

float[] arr_multiply(int n, int m, float[] x, float[][] w){ // перемножаем вектор на матрицу
  float[] res = new float[m];
  for(int i = 0; i < m; i++){
    float op = 0;
    for(int j = 0; j < n; j++){
      op += x[j] * w[j][i];
    }
    res[i] = op;
  }
  return res;
}
