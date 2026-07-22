import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:image/image.dart' as img;

class FoodAiResult {
  const FoodAiResult({
    required this.category,
    required this.categoryConfidence,
    this.freshness,
    this.freshnessConfidence,
  });

  final String category;
  final double categoryConfidence;
  final String? freshness;
  final double? freshnessConfidence;
}

class FoodAiService {
  FoodAiService._();

  static final instance = FoodAiService._();
  final _runtime = OnnxRuntime();
  final _sessions = <String, OrtSession>{};

  Future<FoodAiResult> predict(Uint8List bytes) async {
    final input = _preprocess(bytes);
    final router = await _session('assets/models/router.onnx');
    final categoryOutput = await _run(router, input);
    final categoryIndex = _argmax(categoryOutput);
    const categories = ['cu', 'gia_suc', 'qua', 'rau'];
    final category = categories[categoryIndex];
    final expert = await _session('assets/models/freshness/$category.onnx');
    final freshnessOutput = await _run(expert, input);
    final freshnessIndex = _argmax(freshnessOutput);
    const freshness = ['FRESH', 'HALF-FRESH', 'SPOILED'];
    final categoryProbabilities = _softmax(categoryOutput);
    final freshnessProbabilities = _softmax(freshnessOutput);
    return FoodAiResult(
      category: category,
      categoryConfidence: categoryProbabilities[categoryIndex],
      freshness: freshness[freshnessIndex],
      freshnessConfidence: freshnessProbabilities[freshnessIndex],
    );
  }

  Future<OrtSession> _session(String asset) async {
    return _sessions[asset] ??= await _runtime.createSessionFromAsset(
      asset,
      options: OrtSessionOptions(),
    );
  }

  Future<List<double>> _run(OrtSession session, List<double> input) async {
    final value = await OrtValue.fromList(input, [1, 3, 224, 224]);
    final outputs = await session.run({'image': value});
    final output = outputs[session.outputNames.first];
    await value.dispose();
    if (output == null) throw StateError('ONNX output is missing');
    final values = await output.asFlattenedList();
    await output.dispose();
    return values.map((item) => (item as num).toDouble()).toList();
  }

  List<double> _preprocess(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw StateError('Cannot decode image');
    final scale = 232 / math.min(decoded.width, decoded.height);
    final resized = img.copyResize(
      decoded,
      width: (decoded.width * scale).round(),
      height: (decoded.height * scale).round(),
    );
    final cropped = img.copyCrop(
      resized,
      x: (resized.width - 224) ~/ 2,
      y: (resized.height - 224) ~/ 2,
      width: 224,
      height: 224,
    );
    final values = <double>[];
    const means = [0.485, 0.456, 0.406];
    const stds = [0.229, 0.224, 0.225];
    for (var channel = 0; channel < 3; channel++) {
      for (var y = 0; y < 224; y++) {
        for (var x = 0; x < 224; x++) {
          final pixel = cropped.getPixel(x, y);
          final value = [pixel.r, pixel.g, pixel.b][channel] / 255.0;
          values.add((value - means[channel]) / stds[channel]);
        }
      }
    }
    return values;
  }

  int _argmax(List<double> values) {
    var index = 0;
    for (var i = 1; i < values.length; i++) {
      if (values[i] > values[index]) index = i;
    }
    return index;
  }

  List<double> _softmax(List<double> values) {
    final maxValue = values.reduce(math.max);
    final exponentials = values.map((value) => math.exp(value - maxValue)).toList();
    final total = exponentials.reduce((a, b) => a + b);
    return exponentials.map((value) => value / total).toList();
  }
}
