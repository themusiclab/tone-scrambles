# Are You a Super-Listener? game code

 ## File descriptions:
- __index.html__             : main page. Open this in your browser to run the experiment (tested on Chrome, Firefox, and Safari).
- __lib/data_mgmt.js__       : functions for data management (randomizing blocks/trials, JSON to CSV conversion).
- __lib/math_helpers.js__    : some helper functions written to perform vector operations in a Matlab-like fashion
- __lib/sound_functions.js__ : functions to generate and playback tone scrambles
- __lib/jsPsych-master/__    : contains files sourced from [jsPsych](https://www.jspsych.org/).

This folder must be hosted on a local testing server and accessed via a web browser to run properly. Several options exist to accomplish this such as the Live Preview function of [Adobe Brackets](https://brackets.io/?lang=en) or [Python's http functions](https://docs.python.org/3/library/http.server.html#command-line-interface), but the easiest way to demo the experiment is to access the the game itself at https://www.themusiclab.org/quizzes/scram.
