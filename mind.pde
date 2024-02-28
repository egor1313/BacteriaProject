
class Mind{
  
  IntList layers_size; // количество нейронов в каждом слое
  ArrayList<Layer> layers;
  
  boolean use_random;
  boolean use_memory;
  int inp;
  int out;
  int count_of_layers; // кол-во слоев
  float percent_of_change_nn_weight_and_activation;
  int have_mutations = 0;
  int count_off_neurons = 0;
  int[] act_count = new int[4];
  Mind(Mind mp){
    layers_size = new IntList();
    layers = new ArrayList<Layer>();
    if (mp == null){
      use_random = start_use_random;
      use_memory = start_use_memory;
      inp = neurons_input_size; // кол-во входных нейронов // 1. энергия, 2. поворот, 3. высота, 4. возвраст, 5. что видим (-1 - ничего, 0 - стенка, 1 - бактерия), 6. насколько отличается ( -1 - пусто -0 - ни насколько 1 - много) 7. есть ли впереди органика(1/ 0)
      out = neurons_output_size; // 0, делиться ли, 1. кусать ли, 2. будем ли есть органику 3. ходить ли, 4. передать ли енергии 5. фотосинтезировать ли, 6. хотим ли повернуться, 7. насколько повернуться
      count_of_layers = layers_of_nn;
      percent_of_change_nn_weight_and_activation = start_percent_of_change_nn_weight_and_activation;
      layers_size.append(inp);
      count_off_neurons += inp;
      for(int i = 1; i < count_of_layers-1; i++){
        layers_size.append(start_neurons_in_mid_layer);
        count_off_neurons += start_neurons_in_mid_layer;
      }
      layers_size.append(out);
      count_off_neurons += out;
      int inp_temp = inp;
      int out_temp;
      for(int i = 1; i < count_of_layers; i++){
        out_temp = layers_size.get(i); 
        if (i == 1){
          layers.add(new Layer(inp_temp, out_temp, false, false, null)); // int inp, int out, boolean full_zeros, boolean is_input
          
          ///////////to make colony ///////
          //layers.get(i-1).layer.get(0).weight[5] = 1;
        }
        else if(i == count_of_layers-1){
          layers.add(new Layer(inp_temp, out_temp, false, false, null));
          layers.get(i-1).layer.get(7).type_of_activation = 3;
          layers.get(i-1).layer.get(0).set_ones();
          layers.get(i-1).layer.get(5).set_ones();
          ///////////to make colony ///////
          //layers.get(i-1).layer.get(1).type_of_activation = 3;
          //layers.get(i-1).layer.get(1).weight[0] = 1;
        }
        else{
          layers.add(new Layer(inp_temp, out_temp, false, false, null)); // int inp, int out, boolean full_zeros, boolean is_input
          layers.get(i-1).layer.get(0).set_ones();
          layers.get(i-1).layer.get(5).set_ones();
          
          ///////////to make colony ///////
          //layers.get(i-1).layer.get(0).weight[0] = 1;
          
        }
        act_count[0] += layers.get(i-1).act_count[0];
        act_count[1] += layers.get(i-1).act_count[1];
        act_count[2] += layers.get(i-1).act_count[2];
        act_count[3] += layers.get(i-1).act_count[3];
        inp_temp = out_temp;
      }
      
      
    }
    else{
      // with mutate
      use_random = mp.use_random;
      use_memory = mp.use_memory;
      inp = mp.inp;
      out = mp.out;
      count_of_layers = mp.count_of_layers;
      percent_of_change_nn_weight_and_activation = mp.percent_of_change_nn_weight_and_activation;
      count_off_neurons = mp.count_off_neurons;
      if (mp.layers_size.size() <= 2){
        println("!");
      }
      float per = random(0, 1);
      float per2 = random(0, 1);
      
      if ( percent_of_use_random >= per2){
        use_random = !use_random;
        have_mutations += 1;
        if (use_random){
          inp += 1;
        }
        else{
          inp -= 1;
        }
      }
      int ind = -1;
      int is_up = 1;
      /*if (percent_of_change_nn_count_of_layer >= per){ //change size of layers
        have_mutations+=1;
        float pl = 1;//random(0, 1);
        if (pl > 0.5 && count_of_layers < max_layers_size){ // увеличиваем кол-во слоев
          ind = int(random(1, count_of_layers-1));
          grow_up_layer(ind, mp);

        }
        else if (count_of_layers > 3){ // уменьшаем кол-во слоев
          is_up = 0;
          ind = int(random(1, count_of_layers-2));
          layers_size.append(inp);
          count_off_neurons -= mp.layers_size.get(ind);
          for(int i = 1; i < count_of_layers-1; i++){
            if (i != ind){
              layers_size.append(mp.layers_size.get(i));
              
            }
          }
          layers_size.append(out);
          count_of_layers -= 1;
          
        }
        
      }
      else{*/
        layers_size.append(inp);
        for(int i = 1; i < count_of_layers-1; i++){
          layers_size.append(mp.layers_size.get(i));
        }
        layers_size.append(out);

      //}
      

      if (percent_of_change_nn_layer_size >= per){ // change layer size
        have_mutations+=1;
        int r = int(random(1, count_of_layers-1));
        int tak = int(random(-1, 2));
 //<>// //<>//
        if (tak == -1 && layers_size.get(r) >= 3){
          layers_size.add(r, tak);
          count_off_neurons += tak;
        }
        if (tak == 1 && layers_size.get(r) < max_neurons_in_layer){
          layers_size.add(r, tak);
          count_off_neurons += tak;
        }
      }
      
      // создаем массив layers
      if (ind == -1){
        int inp_temp = inp;
        int out_temp;
        for(int i = 1; i < count_of_layers; i++){
          out_temp = layers_size.get(i); 
          layers.add(new Layer(inp_temp, out_temp, false, false, mp.layers.get(i-1))); // int inp, int out, boolean full_zeros, boolean is_input
          act_count[0] += layers.get(i-1).act_count[0];
          act_count[1] += layers.get(i-1).act_count[1];
          act_count[2] += layers.get(i-1).act_count[2];
          act_count[3] += layers.get(i-1).act_count[3];
          inp_temp = out_temp;
        }
      }
      else{
        if (is_up == 1){
          int inp_temp = inp;
          int out_temp;
          int pam = 1;
          for(int i = 1; i < count_of_layers; i++){
            out_temp = layers_size.get(i);
            if (i == ind){
              pam += 1;
              layers.add(new Layer(inp_temp, out_temp, false, false, null));
            }
            else{
              layers.add(new Layer(inp_temp, out_temp, false, false, mp.layers.get(i-pam))); // int inp, int out, boolean full_zeros, boolean is_input
            }
            inp_temp = out_temp;
          }
        }
        else{
          int inp_temp = inp;
          int out_temp;
          int pam = 1;
          for(int i = 1; i < count_of_layers; i++){
            out_temp = layers_size.get(i);
            if (i == ind){
              pam -= 1;
            }
            layers.add(new Layer(inp_temp, out_temp, false, false, mp.layers.get(i-pam))); // int inp, int out, boolean full_zeros, boolean is_input
            inp_temp = out_temp;
            
          }
        }
      }
      
      if (percent_of_delete_connect >= per2){ // make weight zeros
        have_mutations+=1;
        int lay1 = int(random(1, count_of_layers));
        int neuro1 = int(random(0, layers_size.get(lay1)));

        layers.get(lay1-1).layer.get(neuro1).weight[int(random(0, layers_size.get(lay1-1)))] = 0;
        
      }
      if (percent_of_change_nn_weight_and_activation >= per){ // chang weight, bias and activations
        have_mutations += 1;
        for(int i = 0; i < int(random(2, force_of_mutate+1)); i++){
          int lay1 = int(random(1, count_of_layers));
          int neuro1 = int(random(0, layers_size.get(lay1)));

          layers.get(lay1-1).layer.get(neuro1).weight[int(random(0, layers_size.get(lay1-1)))] += random(-count_w_mutate, count_w_mutate);
          
          layers.get(lay1-1).layer.get(neuro1).b += random(-count_w_mutate, count_w_mutate);
        }
        for(int i = 0; i < int(random(1, force_of_mutate)); i++){
          int lay1 = int(random(1, count_of_layers));
          int neuro1 = int(random(0, layers_size.get(lay1)));
          int was = layers.get(lay1-1).layer.get(neuro1).type_of_activation;
          layers.get(lay1-1).layer.get(neuro1).type_of_activation += int(random(0, 6));
          layers.get(lay1-1).layer.get(neuro1).type_of_activation = layers.get(lay1-1).layer.get(neuro1).type_of_activation % 4;
          int rr = layers.get(lay1-1).layer.get(neuro1).type_of_activation;
          act_count[was] -= 1;
          act_count[rr] += 1;
          
        }
      }
      if (percent_of_change_percent_mutate >= per2){ // change percent of mutate percent
        have_mutations+=1;
        percent_of_change_nn_weight_and_activation += random(-0.05, 0.05);
        percent_of_change_nn_weight_and_activation = max(percent_of_change_nn_weight_and_activation, 0);
        percent_of_change_nn_weight_and_activation = min(percent_of_change_nn_weight_and_activation, 1);
      }
    }
  }
  
  void grow_up_layer(int ind, Mind mp){
    
    layers_size.append(inp);
    this.count_off_neurons += start_neurons_in_mid_layer;
    for(int i = 1; i < count_of_layers-1; i++){
      if (i == ind){
        layers_size.append(start_neurons_in_mid_layer);
      }
      layers_size.append(mp.layers_size.get(i));
    }
    layers_size.append(out);
    this.count_of_layers += 1;
  }
  
  float[] activate_mind(float[] input_mind){
    
    float[] x = new float[max_neurons_in_layer];
    int inp_now = inp;
    
    if (use_random){
      x[inp-1] = random(0, 1);
      inp_now -= 1;
    }

    
    for(int i = 0; i < inp_now; i++){
      x[i] = input_mind[i];
    }
    for(int i = 0; i < count_of_layers-1; i++){
      x = layers.get(i).activate_layer(x);
    }
    return x;
  }
  float[] sum_of_gens(){
    float[] x = new float[count_of_layers-1];
    for(int i = 1; i < count_of_layers; i++){
      x[i-1] = 0;
      int pam = layers_size.get(i);
      for(int j = 0; j < pam; j++){
        int op = layers_size.get(i-1);
        for(int k = 0; k < op; k++){
          x[i-1] += abs(layers.get(i-1).layer.get(j).weight[k]);
        }
        x[i-1] += abs(layers.get(i-1).layer.get(j).b);
      }
    }
    return x;
  }
}
