
class Neuron{
  int count_of_inputs;
  float[] weight;
  int type_of_activation; // 0 - relu, 1 - binar, 2 - radial, 3 - sigmoid
  float b;
  boolean is_input_layer; // 0 - normal, 1 - input
  
  
  Neuron(int input, int neuron_type, boolean is_all_w_0, boolean is_b_0, boolean is_input_layer, Neuron p){
    this.count_of_inputs = input;
    this.is_input_layer = is_input_layer;
    weight = new float[count_of_inputs];
    if (p == null){
      if (is_input_layer){
        type_of_activation = -1;
        b = -1;
      }
      else{
        if (neuron_type != -1){
          type_of_activation = neuron_type;
        }
        else{
          type_of_activation = int(random(0, 4));
        }
        for(int i = 0; i < count_of_inputs; i++){
          if (is_all_w_0){
            weight[i] = 0;
          }
          else{
            weight[i] = random(-1, 1); // PLEASE SET IT UP
          }
        }
        if (is_b_0){
          b = 0;
        }
        else{
          b = random(-0.5, -0.5);
        }
      }
    }
    else{
      type_of_activation = p.type_of_activation;
      if (p.count_of_inputs >= count_of_inputs){
        for(int i = 0; i < count_of_inputs; i++){
          weight[i] = p.weight[i];
        }
      }
      else if (p.count_of_inputs < count_of_inputs){
        for(int i = 0; i < p.count_of_inputs; i++){
          weight[i] = p.weight[i];
        }
        for(int i = p.count_of_inputs; i < count_of_inputs; i++){
          weight[i] = random(-0.5, 1);
        }
      }

      b = p.b;
    }
    
    
  }
  
  float activate(float[] x){
    float res = 0;
    for(int i = 0; i < count_of_inputs; i++){
      res += x[i]*weight[i];
    }
    res += b;
    if (type_of_activation == 0){
      res = relu(res);
    }
    if (type_of_activation == 1){
      res = binar(res);
    }
    if (type_of_activation == 2){
      res = radial_basis(res);
    }
    if (type_of_activation == 3){
      res = sigmoid(res);
    }
    return res;
  }
  
  void set_random(){
    for(int i = 0; i < count_of_inputs; i++){
      weight[i] = random(-0.5, 1); // PLEASE SET IT UP
    }
  }
  
  void set_ones(){
    for(int i = 0; i < count_of_inputs; i++){
      weight[i] = 1; // PLEASE SET IT UP
    }
  }

}
