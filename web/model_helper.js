// ══════════════════════════════════════════════════════
// 🧠 BinIt — TFJS Model Helper (Graph Model)
// ══════════════════════════════════════════════════════

let _model = null;

const CLASS_NAMES = [
  "battery", "e-waste", "food-waste", "garden-waste", "glass",
  "gloves", "masks", "medicines", "metal", "other-organic",
  "paper", "plastic", "syringe", "textile_fabric", "trash"
];

/**
 * Load the TFJS Graph Model (called once on app start).
 * Returns true if successful, false otherwise.
 */
async function loadModel() {
  try {
    if (_model) return true;
    console.log("[BinIt] Loading TFJS Graph Model...");
    _model = await tf.loadGraphModel("model/model.json");
    // Warm up with a dummy tensor
    const dummy = tf.zeros([1, 224, 224, 3]);
    const warmup = _model.predict(dummy);
    warmup.dispose();
    dummy.dispose();
    console.log("[BinIt] ✅ Model loaded & warmed up");
    return true;
  } catch (e) {
    console.error("[BinIt] ❌ Model load failed:", e);
    return false;
  }
}

/**
 * Classify an image element (img, canvas, or video frame).
 * Accepts an HTMLImageElement or base64 data URL string.
 * Returns: { className, confidence, allScores }
 */
async function classifyImage(imageSource) {
  if (!_model) {
    console.error("[BinIt] Model not loaded. Call loadModel() first.");
    return null;
  }

  try {
    let imgTensor;

    if (typeof imageSource === "string") {
      // Base64 data URL → create an Image element
      const img = new Image();
      img.crossOrigin = "anonymous";
      await new Promise((resolve, reject) => {
        img.onload = resolve;
        img.onerror = reject;
        img.src = imageSource;
      });
      imgTensor = tf.browser.fromPixels(img);
    } else {
      // HTMLImageElement / HTMLCanvasElement / HTMLVideoElement
      imgTensor = tf.browser.fromPixels(imageSource);
    }

    // Resize to 224x224, keep [0,255] range, add batch dim
    const resized = tf.image.resizeBilinear(imgTensor, [224, 224]);
    const batched = resized.expandDims(0).cast("float32"); // [1, 224, 224, 3]

    // Run inference
    const predictions = _model.predict(batched);
    const scores = await predictions.data(); // Float32Array of 15 values

    // Find top prediction
    let maxIdx = 0;
    let maxVal = scores[0];
    for (let i = 1; i < scores.length; i++) {
      if (scores[i] > maxVal) {
        maxVal = scores[i];
        maxIdx = i;
      }
    }

    // Cleanup tensors
    imgTensor.dispose();
    resized.dispose();
    batched.dispose();
    predictions.dispose();

    const result = {
      className: CLASS_NAMES[maxIdx],
      confidence: maxVal,
      allScores: Array.from(scores),
    };

    console.log(`[BinIt] 🎯 ${result.className} (${(maxVal * 100).toFixed(1)}%)`);
    return result;

  } catch (e) {
    console.error("[BinIt] ❌ Classification failed:", e);
    return null;
  }
}

// Expose to Dart via globalThis
window.loadModel = loadModel;
window.classifyImage = classifyImage;