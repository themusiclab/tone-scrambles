// Sum all elements in a vector
function sum(vec) {
  let result = 0;
  for (let k = 0; k < vec.length; k++) {
    result += vec[k];
  }
  return result;
}


// Get mean of elements in a vector
function mean(vec) {
  return sum(vec) / vec.length;
}


// Cumulative sum of all elements in a vector
function cumsum(vec) {
  let result = new Array(vec.length);
  let running = 0;
  for (let k = 0; k < vec.length; k++) {
    running += vec[k];
    result[k] = running;
  }
  return result;
}


// Sum of scalar and vector
function sv_sum(scalar, vec) {
  let result = new Array(vec.length);
  for (let k = 0; k < vec.length; k++) {
    result[k] = scalar + vec[k];
  }
  return result;
}


// Product of scalar and vector    
function sv_prod(scalar, vec) {
  let result = new Array(vec.length);
  for (let k = 0; k < vec.length; k++) {
    result[k] = scalar * vec[k];
  }
  return result;
}


// Elementwise sum
function ew_sum(vec1, vec2) {
  // For simplicity, assume both vectors are equal in length
  let result = new Array(vec1.length);
  for (let k = 0; k < vec1.length; k++) {
    result[k] = vec1[k] + vec2[k];
  }
  return result;
}


// Elementwise product
function ew_prod(vec1, vec2) {
  // For simplicity, assume both vectors are equal in length
  let result = new Array(vec1.length);
  for (let k = 0; k < vec1.length; k++) {
    result[k] = vec1[k] * vec2[k];
  }
  return result;
}


// Elementwise quotient
function ew_quot(vec_num, vec_den) {
  // For simplicity, assume both vectors are equal in length
  let result = new Array(vec_num.length);
  for (let k = 0; k < vec_num.length; k++) {
    result[k] = vec_num[k] / vec_den[k];
  }
  return result;
}


// Apply sine function to all elements in a vector
function sin_vec(vec) {
  let result = new Array(vec.length);
  for (let k = 0; k < vec.length; k++) {
    result[k] = Math.sin(vec[k]);
  }
  return result;
}


// Apply cosine function to all elements in a vector
function cos_vec(vec) {
  let result = new Array(vec.length);
  for (let k = 0; k < vec.length; k++) {
    result[k] = Math.cos(vec[k]);
  }
  return result;
}


// Apply exp function to all elements in a vector
function exp_vec(vec) {
  let result = new Array(vec.length);
  for (let k = 0; k < vec.length; k++) {
    result[k] = Math.exp(vec[k]);
  }
  return result;
}


// Apply abs function to all elements in a vector
function abs_vec(vec) {
  let result = new Array(vec.length);
  for (let k = 0; k < vec.length; k++) {
    result[k] = Math.abs(vec[k]);
  }
  return result;
}


// Apply modulo function to all elements in a vector
function mod_vec(vec, d) {
  let result = new Array(vec.length);
  for (let k = 0; k < vec.length; k++) {
    result[k] = vec[k] % d;
  }
  return result;
}


// Get maximum of a vector
function max_vec(vec) {
  return vec.reduce(function (a, b) {
    return Math.max(a, b);
  });
}


// Get minimum of a vector
function min_vec(vec) {
  return vec.reduce(function (a, b) {
    return Math.min(a, b);
  });
}


// Create a vector of ones
function ones(len) {
  return new Array(len).fill(1);
}


// Create a vector of zeros
function zeros(len) {
  return new Array(len).fill(0);
}


// Random permuation of digits from 0 to n-1 (source: https://github.com/scijs/random-permutation)
function randperm(n) {
  var result = new Array(n)
  result[0] = 0
  for (var i = 1; i < n; ++i) {
    var idx = (Math.random() * (i + 1)) | 0
    if (idx < i) {
      result[i] = result[idx]
    }
    result[idx] = i
  }
  return result
}


// 1 x n vector of random unif(a, b) variables
function runif(n, a, b) {
  let result = new Array(n);
  for (let k = 0; k < n; k++) {
    result[k] = Math.random() * (b - a) + a;
  }
  return result;
}


// Use vector I to index vector V
function v_i(V, I) {
  var result = new Array(I.length);
  for (let k = 0; k < I.length; k++) {
    result[k] = V[I[k]];
  }
  return result;
}


// Find the smallest index of element in V that equals X
function which_equals(V, X) {
  for (let k = 0; k < V.length; k++) {
    if (V[k] == X) {
      return k;
    }
  }
  return -1;
}


// Create a vector from 0 to N-1
function consec(N) {
  return Array.from(Array(N).keys());
}