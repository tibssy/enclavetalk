import 'package:enclavetalk/models/ai_model.dart';

const List<AIModel> availableModels = [
  AIModel(
    id: 'gemma-3-270m',
    name: 'Gemma 3 270M',
    description: 'Ultra-compact model, great for fast on-device inference.',
    size: '300 MB',
    filename: 'gemma3-270m-it-q8.task',
    url:
        'https://huggingface.co/litert-community/gemma-3-270m-it/resolve/main/gemma3-270m-it-q8.task',
    requiresAuth: true,
  ),
  AIModel(
    id: 'gemma-3-1b',
    name: 'Gemma 3 1B',
    description: 'Balanced performance and size for general purpose chat.',
    size: '1.1 GB',
    filename: 'gemma3-1b-it-int4.task',
    url:
        'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/gemma3-1b-it-int4.task',
    requiresAuth: true,
  ),
  AIModel(
    id: 'gemma-3-nano',
    name: 'Gemma 3 Nano',
    description: 'Multimodal model with vision capabilities.',
    size: '2.5 GB',
    filename: 'gemma-3n-E2B-it-int4.task',
    url:
        'https://huggingface.co/google/gemma-3n-E2B-it-litert-preview/resolve/main/gemma-3n-E2B-it-int4.task',
    requiresAuth: true,
  ),
  AIModel(
    id: 'tinyllama-1.1b',
    name: 'TinyLlama 1.1B',
    description: 'Compact chat model, very fast on older devices.',
    size: '1.2 GB',
    filename: 'TinyLlama-1.1B-Chat-v1.0_seq128_q8_ekv1280.tflite',
    url:
        'https://huggingface.co/litert-community/TinyLlama-1.1B-Chat-v1.0/resolve/main/TinyLlama-1.1B-Chat-v1.0_seq128_q8_ekv1280.tflite',
    requiresAuth: false,
  ),
  AIModel(
    id: 'qwen-2.5-0.5b',
    name: 'Qwen 2.5 0.5B',
    description: 'Lightweight instruction-tuned model.',
    size: '600 MB',
    filename: 'Qwen2.5-0.5B-Instruct_seq128_q8_ekv1280.tflite',
    url:
        'https://huggingface.co/litert-community/Qwen2.5-0.5B-Instruct/resolve/main/Qwen2.5-0.5B-Instruct_seq128_q8_ekv1280.tflite',
    requiresAuth: false,
  ),
  AIModel(
    id: 'smolvlm-256m',
    name: 'SmolVLM 256M',
    description: 'Very small Vision Language Model.',
    size: '280 MB',
    filename: 'smalvlm-256m-instruct_q8_ekv2048.tflite',
    url:
        'https://huggingface.co/litert-community/SmolVLM-256M-Instruct/resolve/main/smalvlm-256m-instruct_q8_ekv2048.tflite',
    requiresAuth: false,
  ),
  AIModel(
    id: 'qwen-2.5-1.5b',
    name: 'Qwen 2.5 1.5B',
    description: 'Strong instruction following capabilities.',
    size: '1.6 GB',
    filename: 'Qwen2.5-1.5B-Instruct_seq128_q8_ekv1280.task',
    url:
        'https://huggingface.co/litert-community/Qwen2.5-1.5B-Instruct/resolve/main/Qwen2.5-1.5B-Instruct_seq128_q8_ekv1280.task',
    requiresAuth: false,
  ),
  AIModel(
    id: 'deepseek-r1-1.5b',
    name: 'DeepSeek R1',
    description: 'Distilled reasoning model based on Qwen.',
    size: '1.7 GB',
    filename: 'deepseek_q8_ekv1280.task',
    url:
        'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B/resolve/main/deepseek_q8_ekv1280.task',
    requiresAuth: false,
  ),
  AIModel(
    id: 'gemma-2-2b',
    name: 'Gemma 2 2B',
    description: 'Previous generation reliable chat model.',
    size: '2.0 GB',
    filename: 'gemma2_q8_multi-prefill-seq_ekv1280.task',
    url:
        'https://huggingface.co/litert-community/Gemma2-2B-IT/resolve/main/gemma2_q8_multi-prefill-seq_ekv1280.task',
    requiresAuth: true,
  ),
];
