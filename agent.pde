
class Agent
{
  int age; // сколько ей осталость жить
  int x, y; // уоординаты клетки
  
  //############## GENS ##############
  int max_age;
  float force;
  color color1;
  float percent_of_mutation;
  float energy_multiply_coef;
  float coef_is_my_gens;
  
  // ### NN ###
  Mind mind;
  int count_of_neurons;
  
  
  //##################################
  
  float energy;
  int rotation; // 0 влево, 1 лево-вверх, 2 вверх, 3 вверх право, 4 вправо, 5 вправо-низ, 6 низ, 7 низ-лево
  float phot;
  float atack;
  float troop;
  int is_troop;
  int is_falling_troop = 1;
  int mutation = 0;
  int is_die = 0;
  
  Agent(int is_new){
    atack = 0;
    phot = 0;
    troop = 0;
    is_troop = 0;
    rotation = int(random(0, 8));
    color1 = color(255, 0, 0);
    age = 0;
    coef_is_my_gens = start_coef_is_my_gens;
    
    if (is_new == 1){
       x = -1;
       y = -1;
       max_age = start_age;
       energy = start_energy;
       mind = new Mind(null);
       percent_of_mutation = mind.percent_of_change_nn_weight_and_activation;
       color1 = color(int(random(80, 200)), int(random(80, 200)),int(random(80, 200)));
       force = start_force;
       energy_multiply_coef = start_energy_multiply_coef;
       count_of_neurons = mind.count_off_neurons;
    }
    else{
      x = -1;
      y = -1;
      
    }
     
  }
  
  void rotate(float x){
    if (force_rotation){
      if (x > 0.8){
        rotation += 2;
      }
      else if(x > 0.6){
        rotation += 1;
      }
      else if(x > 0.4){
        rotation += 0;
      }
      else if(x > 0.2){
        rotation -= 1;
      }
      else{
        rotation -= 2;
      }
    }
    else{
      if(x > 0.5){
        rotation += 1;
      }
      else{
        rotation -= 1;
      }
    }
    
    rotation = (rotation+8)%8;
  }
  
  void inheritance(Agent parent){
    color1 = parent.color1;
    mind = new Mind(parent.mind);
    percent_of_mutation = mind.percent_of_change_nn_weight_and_activation;
    mutation = mind.have_mutations;
    count_of_neurons = mind.count_off_neurons;
    max_age = parent.max_age;
    force = parent.force;
    energy_multiply_coef = parent.energy_multiply_coef;
    coef_is_my_gens = parent.coef_is_my_gens;
    age = 0;
    if (save_rotate_after_multiply){
      rotation = (parent.rotation + int(random(-2, 3)) + 8) % 8;
    }
    float t = random(0, 1);
    if (t >= percent_of_mutation){ //mutate!!!!
      mutate();
    }
  }
  
  void mutate(){
    float r = red(color1);
    float g = green(color1);
    float b = blue(color1);
    int[] cl = new int[3];
    cl[0] = int(r);
    cl[1] = int(g);
    cl[2] = int(b);
    for(int i = 0; i < 1 + mutation; i++){
      cl[int(random(0,3))] += int(random(-3, 4));
    }
    max_age += int(random(-2, 3));
    if (max_age <= 0){
      max_age = 1;
    }
    force += random(-0.01, 0.01);
    if (force < 0){
      force = 0;
    }
    coef_is_my_gens += random(-0.0001, 0.0001);
    
    for(int i = 0; i < 3; i++){
      if (cl[i] > 180){
        cl[i] = 180;
      }
      if (cl[i] < 80){
        cl[i] = 80;
      }
    }
    
    color1 = color(cl[0], cl[1], cl[2]);
    
  }
}
