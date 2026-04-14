//////////////////////////////////
// Global variables
//////////////////////////////////

// Number of trials in the given block (referenced by the game HUD code to set visual parameters)
// This value is updated in the jsPsych code using the reset_block() function below.
var N = 30;

// FPS to tell p5js to run at
var fps = 30;

// Some graphics params
var hud_on = false;
var canvas;
var c_red = [255, 0, 0];
var c_green = [0, 128, 0];
var c_blue = [112, 197, 207];
var c_bluegrey = [93, 98, 117];
var bgc = c_blue;

// Images
var im_cloud;
var im_bird_d;
var im_bird_u;
var im_state;
var im_dens_fill;
var im_bars_fill;

// Unit variable to help scale everything when viewport size changes
// TODO: use viewport size to choose this value (note: current fixed settings look OK on all displays tested)
var adj = 3;

// Parameters of bird avatar
var bird_x;
var bird_y;
var bird_x_i = 0;
var bird_y_i = 0;
var bird_y_i_max = 30;
var bird_w;
var bird_h;

// Variables to give the bird a bounce
var bounce_t = 0;
var bounce_a = 10;

function bounce_y(t) {
  y = (Math.sin(bounce_t - Math.PI / 2) + 1) / 2;
  y *= bounce_a;
  return y;
}

// Used to record the path traversed
var path_y = [];
var path_dots = [];

// Parameters of the animated clouds
var cloud_x;
var cloud_w;
var cloud_h;

// Fonts
var fontRegular;
var fontBold;
var fontBoldEx;

// Score keeper
var score = 0;
var new_score = 0;
var streak = 0;

// Score timer
var rtime = 0;
var rt_bonus = 50;
var timer_start = NaN;
var timer_on = false;
var timer_finish = false;
var timer_finish_ctr;
var timer_finish_pos = true;

// Progress bar
var progress = 0;
var prog_w;
var prog_h;

// Density plots
var dens_plot;

// End-of-game summary
var summary_on = false;
var cur_level = -1;
var levels_summary = new Array(3);
for (let k = 0; k < 3; k++) {
  levels_summary[k] = {
    p_corr: 0,
    correct :[],
    points_earned : [],
    rtimes : []
  }
}
var score_step = 9;
var mask_p = 1;



//////////////////////////////////
// Custom functions to handle most graphics operations
//////////////////////////////////

// Use this to figure out where to draw the dots that trace the bird's path
function calc_path() {
  path_dots = new Array(path_y.length - 1);
  for (let k = 0; k < path_y.length - 1; k++) {
    let dx = bird_x[k + 1] - bird_x[k];
    let dy = bird_y[path_y[k + 1]] - bird_y[path_y[k]];
    let ndots = Math.max(3, ceil(Math.hypot(dx, dy) / (bird_w / 6)));
    let dots_x = sv_sum(bird_x[k] + bird_w / 2, sv_prod(dx / ndots, consec(ndots + 1)));
    let dots_y = sv_sum(bird_y[path_y[k]] + bird_h, sv_prod(dy / ndots, consec(ndots + 1)));
    path_dots[k] = [dots_x, dots_y];
  }
}


//Draw the clouds, update the position to produce an animation
function draw_clouds() {
  cloud_x = sv_sum(-1, cloud_x);
  for (let k = 0; k < cloud_x.length; k++) {
    if (cloud_x[k] < -cloud_w) {
      cloud_x[k] = max_vec(cloud_x) + cloud_w;
    }
    image(im_cloud, cloud_x[k], canvas.height - cloud_h, cloud_w, cloud_h)
  }
}


// Draw the bird's path so far
function draw_path() {
  noFill();
  stroke(0);
  strokeWeight(1);
  for (let i = 0; i < path_dots.length; i++) {
    for (let j = 0; j < path_dots[i][0].length; j++) {
      circle(path_dots[i][0][j], path_dots[i][1][j], (j == 0 || j == path_dots[i][0].length - 1) ? 16 / adj : 10 / adj / 2);
    }
  }
}


//Draw the bird
function draw_bird() {
  bounce_t += Math.PI / 16;
  bounce_t %= 2 * Math.PI;
  image(im_state, bird_x[bird_x_i], bird_y[bird_y_i] - bounce_y(bounce_t), bird_w, bird_h);
}


// Make the background pixels of the images transparent
function make_transparent(im) {
  im.loadPixels();
  for (let k = 0; k < im.pixels.length; k += 4) {
    if (im.pixels[k] == c_blue[0] && im.pixels[k + 1] == c_blue[1] && im.pixels[k + 2] == c_blue[2]) {
      im.pixels[k + 3] = 0;
    }
  }
  im.updatePixels();
}


// Create polygon (edited from: https://p5js.org/examples/form-regular-polygon.html)
function polygon(x, y, radius, npoints, noff, rot = 0) {
  let angle = TWO_PI / npoints;
  beginShape();
  for (let a = 1; a < npoints + 1; a++) {
    let sx;
    let sy;
    if (a < noff) {
      sx = x;
      sy = y;
    } else {
      sx = x + sin(a * angle + rot) * radius;
      sy = y - cos(a * angle + rot) * radius;
    }
    vertex(sx, sy);
  }
  endShape(CLOSE);
}


// Update the bird based on whether the current trial was correct or incorrect. Also update the path accordingly
function update_bird(correct) {
  bird_x_i++;
  if (correct) {
    im_state = im_bird_u;
    bird_y_i = Math.min(bird_y_i + 1, bird_y_i_max);
    path_y.push(bird_y_i);
    streak++;
  } else {
    im_state = im_bird_d;
    bird_y_i = Math.max(0, bird_y_i - 1);
    path_y.push(bird_y_i);
    streak = 0;
  }
  calc_path();
}


// Update the score
function update_score(correct) {
  timer_on = false;
  timer_finish = true;
  timer_finish_ctr = 30;
  timer_finish_pos = correct;

  // Finish previous update if not done by this time
  score = new_score;
  new_score = score + (correct ? rt_bonus : 0 - rt_bonus);
}


// Update the summary object to be used at the end
function update_summary(correct) {
  // Calculate points
  let pts = 50 - Math.floor(40 * Math.min(1, rtime / 1000));
  if (!correct) {
    pts = -pts;
  }
  
  // Update the summary object
  levels_summary[cur_level].correct = levels_summary[cur_level].correct.concat(correct ? 1 : 0);
  levels_summary[cur_level].points_earned = levels_summary[cur_level].points_earned.concat();
  levels_summary[cur_level].rtimes = levels_summary[cur_level].rtimes.concat(rtime);
  levels_summary[cur_level].p_corr = mean(levels_summary[cur_level].correct);
}


// Draw the score
function draw_score() {
  strokeWeight(0);

  textFont(fontBold);
  textSize(56 / adj);
  textAlign(LEFT, CENTER);
  fill(0);
  text(("Streak: ").concat(String(streak)), 100 / adj, 100 / adj + 64 / adj);

  textFont(fontBold);
  textSize(56 / adj + 1.5 * Math.abs(new_score - score) / adj);
  textAlign(LEFT, CENTER);
  if (new_score > score) {
    fill(c_green);
    score = Math.min(score + 3, new_score);
  } else if (new_score < score) {
    fill(c_red);
    score = Math.max(score - 3, new_score);
  } else {
    fill(0);
  }
  text(("Score: ").concat(String(score)), 100 / adj, 100 / adj);
}


// Start the trial timer
function start_timer() {
  timer_on = true;
  timer_finish = false;
  timer_start = Date.now();
}


// Draw the trial timer on HUD
function draw_timer() {
  if (timer_on) {
    rtime = Date.now() - timer_start;
    rt_bonus = 50 - Math.floor(40 * Math.min(1, rtime / 1000));
    let npts = 60;

    // Show score button
    fill(128);
    polygon(canvas.width / 2, canvas.height / 2, 144 / adj + 2, npts, 0);

    fill(255);
    polygon(canvas.width / 2, canvas.height / 2, 144 / adj, npts, npts * ((50 - rt_bonus) / 40));

    fill(0)
    textFont(fontBold);
    textSize(144 / adj);
    textAlign(CENTER, CENTER);
    text(String(rt_bonus), canvas.width / 2, canvas.height / 2 - 24 / adj);

  } else if (timer_finish) {
    let sgn;
    if (timer_finish_pos) {
      sgn = "+";
      fill(c_green.concat(255 * (timer_finish_ctr / 30)));
    } else {
      sgn = "-";
      fill(c_red.concat(255 * (timer_finish_ctr / 30)));
    }

    textFont(fontBoldEx);
    textSize(144 / adj);
    textAlign(CENTER, CENTER);
    text(sgn.concat(String(rt_bonus)), canvas.width / 2, canvas.height / 2 - 24 / adj - (30 - timer_finish_ctr) * adj);

    timer_finish_ctr--;
    if (timer_finish_ctr == 0) {
      timer_finish = false;
    }
  }
}


// Draw the progress bar top-center
function draw_progress() {
  // Empty bar
  fill(128);
  rect(windowWidth / 2 - prog_w / 2, prog_h, prog_w, prog_h);

  // Progress fill
  fill(c_green);
  rect(windowWidth / 2 - prog_w / 2, prog_h, prog_w * progress, prog_h);

  // Label
  fill(0)
  textFont(fontRegular);
  textSize(40 / adj);
  textAlign(CENTER, TOP);
  text("PROGRESS", canvas.width / 2, 2.5 * prog_h);
}


// Redundant, but used to harmonize function name with the one below
function start_trial() {
  start_timer();
}


// End the current trial by updating the score and bird's position
function end_trial(correct) {
  update_score(correct);
  update_bird(correct);
  update_summary(correct);

  // Update progress bar
  progress += 1 / N / 3;
}


// Set the size/position of the images (clouds, bird) and path grid.
// Called whenever there's a new block (to change grid based on num trials) or whenever the window is resized
function set_sizes() {
  // Dimensionaless variable used to scale visual elements
  adj = Math.min(Math.max(2, 3000 / min_vec([windowHeight, windowWidth])), 4);
  
  // Scale the cloud image
  cloud_w = 6400 / adj;
  cloud_h = 256 / adj;

  // Scale the bird images
  bird_w = 700 / adj / 3;
  bird_h = 700 / adj / 3;

  // Scale the progress bar
  prog_w = Math.min(1000 / adj, windowWidth / 3);
  prog_h = 30 / adj;

  // Create the array specifying the cloud positions
  cloud_x = sv_prod(cloud_w, consec(Math.ceil(canvas.width / cloud_w) + 1));

  // Create the array specifying the bird's position
  bird_x = sv_prod((canvas.width - bird_w) / N, consec(N + 1));
  bird_y = sv_sum(canvas.height - cloud_h, sv_prod(-(canvas.height - cloud_h) / (bird_y_i_max + 1), consec(bird_y_i_max + 1)));
}


// This is called at the beginning of every new block. Resets bird position, sizes, and streak (score is not reset)
function reset_block(ntrials) {
  resizeCanvas(windowWidth, 7 * windowHeight / 16);
  background(bgc);
  N = ntrials;
  bird_y_i_max = ntrials;
  set_sizes();
  bird_x_i = 0;
  bird_y_i = 0;
  path_y = [0];
  streak = 0;
  calc_path();
  im_state = im_bird_u;
  hud_on = true;
  
  // This function is called at the start of every block and can be used to track level number
  cur_level++;
}


// Turn the game HUD off (during final survey Qs)
function hide_game() {
  resizeCanvas(windowWidth, 0);
  hud_on = false;
}



//////////////////////////////////
// Functions for showing the summary at the end
//////////////////////////////////

// Generate fill image for the results density
function gen_dens_fill() {

  // Resolution of the fill image in y
  let reso_y = 1000;

  // Generate the image
  let img = createImage(dens.fx.length, reso_y);
  img.loadPixels();
  for (let i = 0; i < img.width; i++) {
    for (let j = 0; j < img.height; j++) {
      let c = c_bluegrey;
      img.set(i, j, (reso_y - j > dens.fx[i] * reso_y) ? color(0, 0, 0, 0) : color(c[0], c[1], c[2], 255 - j * 255 / reso_y));
    }
  }
  img.updatePixels();

  // Return an object containing the image and the density curve
  return img;
}


// Generate bar fill for the results bar chart
function gen_bars_fill(p_conds) {

  // Resolution of the fill image in y
  let reso_y = 1000;

  // Generate the image
  let img = createImage(dens.fx.length, reso_y);
  img.loadPixels();
  for (let i = 0; i < img.width; i++) {
    for (let j = 0; j < img.height; j++) {
      let c = c_bluegrey;
      let bin = Math.floor((i / img.width) * 7);
      if (bin % 2 == 0) {
        img.set(i, j, color(0, 0, 0, 0));
      } else {
        img.set(i, j, (reso_y - j > p_conds[Math.floor(bin / 2)] * reso_y) ? color(0, 0, 0, 0) : color(c[0], c[1], c[2], 255 - j * 255 / reso_y));
      }
    }
  }
  img.updatePixels();

  // Return an object containing the image and the density curve
  return img;
}


// Draw the feedback plot
function draw_dens(x, y, w, h, p_corr) {
  
  // Get the fill image for the density
  let img = im_dens_fill;
  
  // Get the plot params from the dens_plot object
  let xx = dens.x;
  let fx = sv_sum(y + h, sv_prod(-h, dens.fx));


  // Draw the background grid --------------
  stroke(0);
  strokeWeight(1);
  let dot_space = h / 40;

  // Grid columns
  for (let c = 0; c <= 1; c += 0.2) {
    if (c >= min_vec(xx) && c <= max_vec(xx)) {
      for (let yp = y; yp < y + h; yp += dot_space) {
        point(x + w * c, yp);
      }

      // Include x ticks at the bottom
      strokeWeight(0);
      fill(0);
      textFont(fontRegular);
      textSize(50 / adj);
      textAlign(CENTER, TOP);
      text((c * 100).toFixed(0), x + w * c, y + h + dot_space)
    }
  }

  // Grid rows
  for (let r = y; r < y + h; r += h / 4) {
    for (let xp = x; xp < x + w; xp += dot_space) {
      point(xp, r);
    }
  }


  // Draw the curve shape --------------
  // Init shape
  noFill()
  stroke(c_bluegrey);
  strokeWeight(1.5);
  beginShape();

  // Draw the curve
  for (let k = 0; k < fx.length; k++) {
    vertex(k / (fx.length - 1) * w + x, fx[k]);
  }
  endShape();


  // Draw the fill --------------
  image(img, x, y, w, h);


  // Draw subject's performance --------------
  stroke(c_red);
  strokeWeight(2);
  line(x + p_corr * w, y, x + p_corr * w, y + h);

  strokeWeight(0);
  fill(c_red);
  textFont(fontBold);
  textSize(60 / adj);
  textAlign(CENTER, BOTTOM);
  text((p_corr * 100).toFixed(1).concat("%"), x + p_corr * w, y - dot_space);

  textFont(fontRegular);
  textSize(50 / adj);
  textAlign(CENTER, BOTTOM);
  text("You", x + p_corr * w, y - 30 / adj - 4 * dot_space);


  // Draw the axis & label --------------
  stroke(0);
  strokeWeight(1);
  line(x, y + h, x + w, y + h);

  strokeWeight(0);
  fill(0);
  textFont(fontRegular);
  textSize(60 / adj);
  textAlign(CENTER, TOP);
  text("Percent correct overall", x + w / 2, y + h + 30 / adj + 4 * dot_space)
}


// Draw the feedback plot
function draw_bars(x, y, w, h, p_conds, p_means) {
  
  // Get the fill image for the density
  let img = im_bars_fill;
  
  // Get the plot params from the dens_plot object
  let xx = dens.x;


  // Draw the average player's performance --------------
  stroke(c_red);
  strokeWeight(2);
  line(x + 0.8 / 7 * w, y + h * (1 - p_means[0]), x + 2.2 / 7 * w, y + h * (1 - p_means[0]));
  line(x + 2.8 / 7 * w, y + h * (1 - p_means[1]), x + 4.2 / 7 * w, y + h * (1 - p_means[1]));
  line(x + 4.8 / 7 * w, y + h * (1 - p_means[2]), x + 6.2 / 7 * w, y + h * (1 - p_means[2]));

  strokeWeight(0);
  fill(c_red);
  textFont(fontRegular);
  textSize(50 / adj);
  textAlign(LEFT, CENTER);
  text("Average\nPlayer", x + 6.4 / 7 * w, y + h * (1 - p_means[2]));
  
  
  // Draw the background grid --------------
  stroke(0);
  strokeWeight(1);
  let dot_space = h / 40;

  // Grid columns
  for (let c = 0; c <= 1; c += 1) {
    if (c >= min_vec(xx) && c <= max_vec(xx)) {
      for (let yp = y; yp < y + h; yp += dot_space) {
        point(x + w * c, yp);
      }
    }
  }

  // Grid rows
  for (let r = y; r < y + h; r += h / 4) {
    for (let xp = x; xp < x + w; xp += dot_space) {
      point(xp, r);
    }
  }


  // Draw the bar outlines --------------
  // Init shape
  noFill()
  stroke(c_bluegrey);
  strokeWeight(1.5);

  // Bar outlines
  for (let k = 1; k < 7; k += 2) {
    beginShape();
    vertex(k       / 7 * w + x, y + h);
    vertex(k       / 7 * w + x, y + h * (1 - p_conds[Math.floor(k / 2)]));
    vertex((k + 1) / 7 * w + x, y + h * (1 - p_conds[Math.floor(k / 2)]));
    vertex((k + 1) / 7 * w + x, y + h);
    endShape();
  }
  

  // Draw the fill --------------
  image(img, x, y, w, h);


  // Text for subject's performance --------------
  strokeWeight(0);
  fill(0);
  textFont(fontBold);
  textSize(60 / adj);
  textAlign(CENTER, BOTTOM);
  text((p_conds[0] * 100).toFixed(1).concat("%"), x + 1.5 / 7 * w, y + h * (1 - p_conds[0]) - dot_space);
  text((p_conds[1] * 100).toFixed(1).concat("%"), x + 3.5 / 7 * w, y + h * (1 - p_conds[1]) - dot_space);
  text((p_conds[2] * 100).toFixed(1).concat("%"), x + 5.5 / 7 * w, y + h * (1 - p_conds[2]) - dot_space);
  

  // Draw the axis & label --------------
  stroke(0);
  strokeWeight(1);
  line(x, y + h, x + w, y + h);

  strokeWeight(0);
  fill(0);
  textFont(fontRegular);
  textSize(60 / adj);
  textAlign(CENTER, TOP);
  text("Percent correct by level", x + w / 2, y + h + 30 / adj + 4 * dot_space);
  
  textSize(50 / adj);
  text("Level 1", x + 1.5 / 7 * w, y + h + dot_space);
  text("Level 2", x + 3.5 / 7 * w, y + h + dot_space);
  text("Level 3", x + 5.5 / 7 * w, y + h + dot_space);
}


// Draw the summary
function draw_summary() {
  
  // Plot sizes
  let h = canvas.height / 4;
  let w = 9 * canvas.width / 24;
  
  // Draw percent correct overall
  let agg = levels_summary[0].correct.concat(levels_summary[1].correct, levels_summary[2].correct);
  p_corr = agg.length == 0 ? 0 : mean(agg);
  draw_dens(canvas.width / 12, canvas.height / 2  + 80 / adj + h / 10, w, h, p_corr);
  draw_bars(11 * canvas.width / 12 - w, canvas.height / 2 + 80 / adj + h / 10, w, h, [levels_summary[0].p_corr, levels_summary[1].p_corr, levels_summary[2].p_corr], mean_performance);
  
  // Draw a mask to hide above until score finishes counting
  strokeWeight(0);
  fill(255);
  rect((1 - mask_p) * canvas.width, 0, mask_p * canvas.width, canvas.height);
  
  // Score
  // Animate score at start
  if (new_score > score) {
    score = Math.min(score + score_step, new_score);
  } else if (new_score < score) {
    score = Math.max(score - score_step, new_score);
  } else {
    // Wipe the mask to show graphs underneath
    mask_p = Math.max(mask_p - 0.02, 0);
  }
  
  // Final score at the top
  textAlign(CENTER, BOTTOM);
  textFont(fontBoldEx);
  textSize(70 / adj);
  fill(0);
  text("Your final score is...", canvas.width / 2, canvas.height / 4 - 80 / adj);
  
  textAlign(CENTER, TOP);
  textFont(fontBoldEx);
  textSize(280 / adj * ((new_score != 0) ? Math.abs(score / new_score) : 1));
  fill(score >= 0 ? c_green : c_red);
  text(score.toString(), canvas.width / 2, canvas.height / 4 - 60 / adj);
  
  // Better than statement
  let percentile = 0;
  for (let k = 0; k < samp_all.length; k++) {
    percentile += (p_corr > samp_all[k]) ? 1 : 0;
  }
  percentile /= samp_all.length;
  fill(0);
  textFont(fontRegular);
  textSize(70 / adj);
  textAlign(CENTER, TOP); 
  text(("Better than ").concat((percentile * 100).toFixed(1), "% of players"), canvas.width / 2,  canvas.height / 4 + 300 / adj);
}


//Called by the jsPysch script to show the performance summary
function show_summary() {
  
  // Set score to zero so that it animates on screen pop-up
  score = 0;
  score_step = Math.abs(Math.ceil(new_score / 100));
  if (score_step == 0) {
    score_step = 1;
  }
  
  // Turn the summary on and elongate canvas
  summary_on = true;
  resizeCanvas(windowWidth, 4 * windowHeight / 6);
  
  //Recalculate the graphical parameters
  set_sizes();
  
  // Update the correct fill for the bar graph
  im_bars_fill = gen_bars_fill( [levels_summary[0].p_corr, levels_summary[1].p_corr, levels_summary[2].p_corr]);
}



//////////////////////////////////
// Built-in p5js functions that are called by its internal logic
//////////////////////////////////

//Load the images before anything else
function preload() {
  im_cloud = loadImage('../img/cloud.png');
  im_bird_d = loadImage('../img/bird_dn.png');
  im_bird_u = loadImage('../img/bird_up.png');
  im_dens_fill = gen_dens_fill();
  im_bars_fill = gen_bars_fill([0.5, 0.5, 0.5]); // This is replaced once game is completed

  fontRegular = loadFont("../fonts/OpenSans-Regular.ttf");
  fontBold = loadFont("../fonts/OpenSans-Bold.ttf");
  fontBoldEx = loadFont("../fonts/OpenSans-ExtraBold.ttf");

  //TODO: CORS policy restricts access to local files, so you will need to run in a local server (e.g., using Brackets) to load images
}


// Initial setup
function setup() {
  // Initialize canvas
  canvas = createCanvas(windowWidth, 0);
  canvas.parent('p5js-target');
  background(bgc);

  // Set frame rate
  frameRate(fps);

  // Make these images transparent (delete sky color in images)
  make_transparent(im_bird_u);
  make_transparent(im_bird_d);
  make_transparent(im_cloud);
}


// This function is run every time the window is resized
function windowResized() {
  if (hud_on) {
    if (!summary_on) {
      resizeCanvas(windowWidth, 7 * windowHeight / 16);
      background(bgc);

      //Recalculate the graphical parameters
      set_sizes();

      //Recalculate the path based on new parameters
      calc_path();
    } else {
      resizeCanvas(windowWidth, 4 * windowHeight / 6);
      
      //Recalculate the graphical parameters
      set_sizes();
    }
  } else {
    resizeCanvas(windowWidth, 0);
  }
}


//This function is called frequently (tries to match 30 fps, set above)
function draw() {
  if (hud_on) {
    if (!summary_on) {
      //Clear and redraw canvas
      clear();
      background(bgc);

      //Draw the clouds, update the position to produce an animation
      draw_clouds();
      
      //Draw the path
      draw_path();

      //Draw the bird
      draw_bird();

      //Show score
      draw_score();

      //Draw timer
      draw_timer();

      //Draw progress bar
      draw_progress();
      
    } else {
      clear();
      background(255);
      draw_summary();
    }
  }
}