//////////////////////////////////
// Setup
//////////////////////////////////

//See audio buffering example: https://mdn.github.io/webaudio-examples/audio-buffer/
var fs = NaN;

var AudioContext = window.AudioContext || window.webkitAudioContext;
var aud_ctx;
var source;
var gain_node;

//Mono
let channels = 1;

function init() {
  // Create the audio context
  aud_ctx = new AudioContext();
  fs = aud_ctx.sampleRate;
  
  // Attach a gain node to the end to random down before stopping
  // (Training examples allow early input)
  gain_node = aud_ctx.createGain();
}



//////////////////////////////////
// Tone scramble generating functions
//////////////////////////////////

//Create array containing tone scramble waveform from array containing sequence of frequencies
function freqs_2_wave(freqs) {
    //Parameters
    let pip_duration = 0.0650;
    let pip_len      = Math.ceil(fs * pip_duration);
    let ramp_dur     = 0.0225;
    let r            = Math.ceil(ramp_dur * fs);

    //Create the ramp-damp mask
    let damp = sv_prod(1/2, sv_sum(1, cos_vec(sv_prod(Math.PI / r, Array.from(Array(r).keys())))));
    let ramp = sv_sum(1, sv_prod(-1, damp));
    let mask = ramp.concat(ones(pip_len - 2 * r).concat(damp));

    //Create scramble waveform
    var waveform = new Array;
    for (let f = 0; f < freqs.length; f++) {
        if (Number.isNaN(freqs[f])) {
            waveform = waveform.concat(gen_gap());
        }else{
            waveform = waveform.concat(ew_prod(mask, cos_vec(sv_prod(2 * Math.PI * freqs[f] / fs, Array.from(Array(pip_len).keys())))))
        }
    }
    return waveform;
}

//Create array containing sequence of frequencies from an array containing a sequence of semitone distances from tonic, assuming TET    
function seq_2_freqs(seq, f_I) {
    let result = new Array(seq.length);
    for (let k = 0; k < seq.length; k++) {
        result[k] = f_I * Math.pow(2, seq[k] / 12);
    }
    return result;
}

//Create a sequence for the tone scramble
function gen_seq(stim_type, cond, reference) {
    // cond
    // 0: 3-task, 2-interval same-different (mandatory)
    // 1: C/C# (excluded due to tonic)
    // 2: C#/D
    // 3: D/D#
    // 4: Eb/E (3-task, standard, mandatory)
    // 5: E/F
    // 6: F/F#
    // 7: F#/G (excluded due to dominant)
    // 8: G/G# (excluded due to dominant)
    // 9: Ab/A
    // 10: A/Bb
    // 11: Bb/B
    // 12: B/C (excluded due to tonic)
    
    //if cond==0
    //  stim type == 1 -> same
    //  stim_type == 2 -> different
    //  response specifies type of first interval for same-different trials
    //else
    //  stim type == 1 -> diminished/minor
    //  stim_type == 2 -> augmented/major
    
    
    //Number of pips per frequency (minimum 2)
    let n_each = 3;
    
    var SEQ;
    if (cond == 0){
        //Put all the notes in a vector for each interval
        let tgt = (stim_type==1)?reference:(reference*-1+3);
        SEQ_a = zeros(n_each).concat(sv_prod(2+reference, ones(n_each))).concat(sv_prod(7, ones(n_each))).concat(sv_prod(12, ones(n_each)));
        SEQ_b = zeros(n_each).concat(sv_prod(2+tgt,       ones(n_each))).concat(sv_prod(7, ones(n_each))).concat(sv_prod(12, ones(n_each)));
        
        //Scramble the vectors and put together, with a NaN in the middle for the ISI
        SEQ = v_i(SEQ_a, randperm(SEQ_a.length)).concat([NaN]).concat(v_i(SEQ_b, randperm(SEQ_b.length)));
    }else{
        //Put all the notes in a vector
        SEQ = zeros(n_each).concat(sv_prod(cond-2+stim_type, ones(n_each))).concat(sv_prod(7, ones(n_each))).concat(sv_prod(12, ones(n_each)));
        
        //Scramble the vector
        SEQ = v_i(SEQ, randperm(SEQ.length));
    }
    
    //Done
    return SEQ;
}

//Create a gap to separate the two intervals in same-different task
function gen_gap() {
    //Gap parameters
    let isi_dur  = 0.300;
    let isi_len  = Math.ceil(fs * isi_dur);
    
    //Return gap waveform 
    return zeros(isi_len);
}



//////////////////////////////////
// Play a tone scramble
//////////////////////////////////
function play_scramble(scramble_type, cond, reference) {
    //scramble_type : 1 (minor, same), 2 (major, different)
    //reference     : the type of the first scramble (1: minor, 2: major)
    // Cond
    // 0: 3-task, 2-interval same-different (mandatory)
    // 1: C/C# (excluded due to tonic)
    // 2: C#/D
    // 3: D/D#
    // 4: Eb/E (3-task, standard, mandatory)
    // 5: E/F
    // 6: F/F#
    // 7: F#/G (excluded due to dominant)
    // 8: G/G# (excluded due to dominant)
    // 9: Ab/A
    // 10: A/Bb
    // 11: Bb/B
    // 12: B/C (excluded due to tonic)
    
    //Create audio context if it hasn't been made already (some browsers will prevent the audio context from being created before user input)
    if(!aud_ctx) {
        init();
    }
    
    //Always use 783.99 Hz as the tonic (as in Chubb et al, 2013)
    let f_I = 783.99;
    
    //Generate stimulus based on task type
    var seq;
    var freqs;
    var scramble;

    //Create the tone scramble waveform / PCM data
    seq      = gen_seq(scramble_type, cond, reference);
    freqs    = seq_2_freqs(seq, f_I);
    scramble = freqs_2_wave(freqs);
    
    //Initialize the audio buffer for playback
    let frame_count = scramble.length;
    let arr_buf = aud_ctx.createBuffer(channels, frame_count, aud_ctx.sampleRate);

    //Fill the buffer with the tone scramble waveform
    for (let channel = 0; channel < channels; channel++) {
      //This gives us the actual array that contains the data
      let now_buffering = arr_buf.getChannelData(channel);
      for (let k = 0; k < frame_count; k++) {
          now_buffering[k] = scramble[k];
      }
    }

    //Get an AudioBufferSourceNode; this is the AudioNode to use when we want to play an AudioBuffer
    source = aud_ctx.createBufferSource();
    source.buffer = arr_buf;                // Set the buffer in the AudioBufferSourceNode
    source.connect(gain_node);              // Connect the AudioBufferSourceNode to the gain node (to allow dynamic damping)
    gain_node.connect(aud_ctx.destination); // Connect the gain node to the destination so we can hear the sound
    gain_node.gain.setValueAtTime(1, aud_ctx.currentTime);               // Start gain node at full volume (doesn't need to change unless participant stops sound early)
    source.start();                         // Start the source playing

    //Print a message to the console when the sound is done playing
    /*source.onended = () => {
        console.log('Sound finished.');
    }*/
    
    //Playback initiated, return an object with all the scramble parameters
    var trial_obj = new Object();
    trial_obj.seq = seq;
    trial_obj.freqs = freqs;
    trial_obj.f_I = f_I;
    return trial_obj;
}

//End playback of tone scramble if subject responds early
// TODO: ending early often causes a click to be heard (playback is immediately halted). Ideally, the playback would be ramped down.
function stop_scramble() {
  // Ramp down to zero over the next 5 ms
  gain_node.gain.setValueAtTime(1, aud_ctx.currentTime);
  gain_node.gain.linearRampToValueAtTime(0, aud_ctx.currentTime + 0.015);
  source.stop(aud_ctx.currentTime + 0.025);
}