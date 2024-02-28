

//#################### Settings #########################

int window_width = 1920;
int window_height = 1080;
//int sim_width_px = 1200;
//int sim_height_px = 1000;
int sim_size_coef = 1; // уменьшаем во столько окно
int menu_size = 0; // сколько px на меню

int cell_size = 5; // размер одной клетки X на X
int sim_width; // ширина симуляциии
int sim_height; // высота симуляции
int view_mode  = 0; // режим отображения 0 - по специализации, 1 - колонии, 2 - енергия
boolean white_black = false;
boolean LOOP = true;  // пауза/работа

int draw_each = 1; //100; // отрисовываем каждый _ шаг
int NUM_CELLS = 6000000; // максимальное кол-во бактерий

//Cell[] cells = new Cell[NUM_CELLS]; // массив бактерий
int[][] map;   // карта с номерами бактеий в массиве
Agent[] bacts = new Agent[NUM_CELLS]; // массив бактерий
int[] for_circle_right = new int[NUM_CELLS]; // чтобы зациклить проход
int[] for_circle_left = new int[NUM_CELLS];
int[] free_cells = new int[NUM_CELLS]; // 
int last_free_cell = -1;

PGraphics screen1;
PGraphics screen2;
PGraphics screen3;

Table stats;

long name_png_1 = 1;
String name_folder_pngs = "1BEOO" + int(random(0,100000));
boolean SAVE =  false; // сохранять ли картинки

//######################## Bact Simulation settings ##############################

// WORLD SETTING
int count_of_start_bacts = 10000; // сколько создаем изначально клеток
int start_age = 100; // максимальный возраст бактерии
float start_energy = 120; // кол-во начальной энергии у бактерии
float max_energy = 126;
float energy_for_photosintese = 20; // кол-во даваемой энергии за фотосинтез
//float energy_after_eating = 0.7; // кол-во украденой енргии
float start_energy_multiply_coef = 0.5; // коэффицент передаваемой энергии от родителя к ребенку
float energy_to_multiply = 15;
float max_age_for_multiply = 100;
float energy_for_troops_coef = 1; // коэффицент поглащаемой энергии
float energy_for_walking = 4; // кол-во даваемой энергии за движение
float give_energy_to_friend = 10; // сколько отдаем энергии
float needs_to_eat_oraganics = 10.0; // нужно иметь енергии чтобы есть органику
float needs_to_eat_bots = 15.0; // нужно иметь енергии чтобы атаковать
float start_force = 1; // стартовая сила у бактерии
float force_coef_mult_energy = 25; // сколько енергии за атаку за единицу силы
float iter_energy = 4; // кол-во энергии за 1 итерацию
float nead_epoch_for_force = 4; // нужно отдавать энергии за свою силу
float need_epoch_for_neuron = 0.01; // сколько нужно отдавать энергии за кол-во скрытых нейронов
float age_energy_coef = 0.01;
float start_coef_is_my_gens = 0.015;
boolean save_rotate_after_multiply = true;
boolean force_rotation = false;
boolean use_troops = true; // Будут ли в симуляции трупы n если откл, то нужно уменьшить кол-во входных слоев и испраить обновление ротэйта
boolean use_die_if_no_place = false;
boolean born_when_have_energy = false;
float max_dif_w = 200; // максимальная разница в суммах веса

// MUTATE
//float start_percent_of_mutate = 0.15;
int force_of_mutate = 4; // чем больше, тем больше раз в мутацию меняются веса
float percent_of_change_percent_mutate = 0.05;
float percent_of_change_force = 0.05;
float percent_of_change_nn_layer_size = 0.02;
float percent_of_change_nn_count_of_layer = 0.003;
//float percent_of_change_nn_activation_neuron = 0.02;
float start_percent_of_change_nn_weight_and_activation = 0.04;
float percent_of_change_age = 0.02;
float percent_of_change_energy_multiply_coef = 0.01;
float percent_of_delete_connect = 0.009;
float percent_of_use_random = 0.003;
float count_w_mutate = 0.12; // насколько количественно изменяются веса

// Neural Network
int max_layers_size = 8; // максимальное количество слоев у НС
int start_neurons_in_mid_layer = 9; // сколько нейронов в первом скрытом слое изначально
int layers_of_nn = 5; // cколько слоев при инициальизации бактерии
int neurons_input_size = 7; // кол-во входных нейронов // 1. энергия, 2. поворот, 3. высота, 4. возвраст, 5. что видим (-1 - ничего, 0 - стенка, 1 - бактерия), 6. насколько отличается ( -1 - пусто -0 - ни насколько 1 - много) 7. есть ли впереди органика(1/ 0)
int neurons_output_size = 8; // 0, делиться ли, 1. кусать ли, 2. будем ли есть органику 3. ходить ли, 4. передать ли енергии 5. фотосинтезировать ли, 6. хотим ли повернуться, 7. насколько повернуться
int max_neurons_in_layer = 15; // максимальное кол-во нейронов в слое
boolean start_use_memory = false;
boolean start_use_random = true;
boolean use_start_activation = false;
int start_type_of_activation = 3; // 0 - relu, 1 - binar, 2 - radial, 3 - sigmoid


//################################################################################

float colorph = 1;
float colortr = 10;
float colorea = 3;
int i;
int t = 0;
int is_up = 1;
int last_draw_each;
boolean otrmin = true;
int epoch_count = 0;

void settings() {
  size(window_width + menu_size, window_height);
  //fullScreen(1); 
}

void setup(){
  
  //fullScreen(1); // полноэкранный режим
  
  screen1 = createGraphics(window_width, window_height);
  screen2 = createGraphics(window_width, window_height);
  screen3 = createGraphics(window_width, window_height);
  
  sim_width = window_width/cell_size;
  sim_height = window_height/cell_size;
  
  map = new int[sim_width][sim_height];
  
  stats = new Table();
  stats.addColumn("Epoch_count");
  stats.addColumn("Agent's size");
  stats.addColumn("Size of predators");
  stats.addColumn("Size of sun eaters");
  stats.addColumn("Size of organics eaters");
  stats.addColumn("Average agent's neurons size");
  stats.addColumn("Average agent's force");
  stats.addColumn("Average agent's energy");
  stats.addColumn("Average agent's max age");
  stats.addColumn("Average agent's layers");
  //stats.addColumn("Average agent's memory_use");
  stats.addColumn("Average agent's random_use");
  stats.addColumn("Average agent's percent of mutate");
  stats.addColumn("Average agent's giving energy");
  stats.addColumn("Count rulu agent activation");
  stats.addColumn("Count binar agent activation");
  stats.addColumn("Count radial agent activation");
  stats.addColumn("Count sigmoid agent activation");
  stats.addColumn("Average gen porog");
  
  for(int i = NUM_CELLS-1; i > count_of_start_bacts; i--){
    last_free_cell++;
    free_cells[last_free_cell] = i;
  }
  spawn_start_bacts();
  
}
void draw(){
  
  if (LOOP){
    i = 1;
    while(true){
      simulationStep();
      epoch_count++;
      /*for(int x1 = 0; x1 < sim_width; x1++){
        for(int y1 = 0; y1 < sim_height; y1++){
          if (map[x1][y1] != 0 && bacts[map[x1][y1]] == null){
            println("very sad");
          }
        }
      }*/
      
      
      if(i % draw_each == 0) break; 
      i++;
    }
  }
  if ( SAVE == false && otrmin){
    paint_world(view_mode);
  }
  if (SAVE == true && LOOP){
    
    paint_world(3);
    String name1 = name_folder_pngs + "/specialisation/";// + name_png_1 + ".png";
    String name2 = name_folder_pngs + "/population/";
    String name3 = name_folder_pngs + "/energy/";
    String name_table = name_folder_pngs + "/stats/table.csv";
    for(int i = 0; i < 30 - str(name_png_1).length(); i++){
      name1 = name1  + "0";
      name2 = name2 + "0";
      name3 = name3 + "0";
    }
    name1 = name1 +  name_png_1 + ".png";
    name2 = name2 + name_png_1 + ".png";
    name3 = name3 + name_png_1 + ".png";
    screen1.save(name1);
    screen2.save(name2);
    screen3.save(name3);
    saveTable(stats, name_table);
    name_png_1+=1;
    
  }
  fill(30, 30, 30);
  rect(0, 0, width, height);
  if (otrmin){
    if (view_mode == 0){
      image(screen1, menu_size, 0, width, height);
    }
    else if (view_mode == 1){
      image(screen2, menu_size, 0, width, height);
    }
    else if (view_mode == 2){
      image(screen3, menu_size, 0, width, height);
    }
  }
  //delay(100);
}

void keyPressed(){
  
 if (key == '1'){
   view_mode = 0;
 } 
 if (key == '2'){
   view_mode = 1;
 }
 if (key == '3'){
   view_mode = 2;
 }
 if (key == 'c'){ // отключить отрисовку
   otrmin = !otrmin;
 }
 if (key == 's'){
    SAVE = !SAVE; 
 }
 if (key == 'p') {
   LOOP = !LOOP;
 }
 if (key == 'o'){
   white_black = ! white_black;
 }
 if (key == 'r'){
   
   for(int x = 0; x < sim_width; x++){
     for(int y = 0; y < sim_height; y++){
       map[x][y] = 0;
     }
   }
   for(int i = 0; i < NUM_CELLS;i++){
     for_circle_left[i] = 0;
     for_circle_right[i] = 0;
     free_cells[i] = 0;
   }
   last_free_cell = -1;
  for(int i = NUM_CELLS-1; i > count_of_start_bacts; i--){
    last_free_cell++;
    free_cells[last_free_cell] = i;
  }
  spawn_start_bacts();
 }
}
