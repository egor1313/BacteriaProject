
class Layer{
  int inp;
  int out;
  ArrayList<Neuron> layer;
  boolean is_input;
  int[] act_count;

  Layer(int inp, int out, boolean full_zeros, boolean is_input, Layer p){
    act_count = new int[4];
    act_count[0] = 0;
    act_count[1] = 0;
    act_count[2] = 0;
    act_count[3] = 0;
    this.inp = inp;
    this.out = out;
    this.is_input = is_input;
    layer = new ArrayList<Neuron>();
    if (p == null){
      if (is_input){
        inp = -1;
        for(int i = 0; i < out; i++){
          layer.add(new Neuron(inp, -1, false, false, true, null));
          int pampam = layer.get(i).type_of_activation;
          act_count[pampam]+=1;
        }
      }
      else{
        for(int i = 0; i < out; i++){
          int k = -1;
          if (use_start_activation){
            k = start_type_of_activation;
          }
          if (full_zeros){
            layer.add(new Neuron(inp, k, true, true, false, null));
          }
          else{
            layer.add(new Neuron(inp, k, false, false, false, null));
          }
          int pampam = layer.get(i).type_of_activation;
          act_count[pampam]+=1;
        }
      }
    }
    else{
      for(int i = 0; i < out; i++){
        if (i < p.out){
          layer.add(new Neuron(inp, -1, true, true, false, p.layer.get(i)));
        }
        else{
          layer.add(new Neuron(inp, -1, true, true, false, null));
        }
        int pampam = layer.get(i).type_of_activation;
        act_count[pampam]+=1;
        
      }
    }
    
    
  }
  
   float[] activate_layer(float[] x){
     if (is_input){
       return x;
     }
     else{
       float[] res = new float[max_neurons_in_layer];
       for(int i = 0; i < out; i++){
         res[i] = layer.get(i).activate(x);
       }
       return res;
     }
   }
  
}
