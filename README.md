# LLM Evaluation Framework

A comprehensive evaluation framework for Large Language Models supporting multiple model types, evaluation modes, and automated HPC (SLURM) cluster submissions.

## Supported Models

- **Hugging Face Models**: Local transformers models
- **OpenAI API**: GPT models via OpenAI API
- **vLLM API**: Self-hosted or remote vLLM inference servers

## Evaluation Modes

### 1. Instruction Tuned (IT) Mode (`--mode it`)
For chat/instruction-following models with conversation formats.

### 2. Pretrain Mode (`--mode pt`)
For base/pretrained models without instruction formatting.
> [!NOTE]
> Pretrain mode (`pt`) evaluation typically requires a batch size of 1 for local Hugging Face models.

## Thinking Mode Options (`-t` or `--thinking-mode`)

- `True`: Enable thinking mode (if supported by the model)
- `False`: Disable thinking mode 
- `no_chat_template`: Run the model without applying a chat template for the thinking process
- `None`: Default state (typically used for pretrain mode evaluation)

## Usage Examples

### Hugging Face Models

#### IT Mode with Thinking Enabled
```bash
python -m src.run \
  --model-path Qwen/Qwen3-8B \
  --batch-size 32 \
  --debug \
  -t True \
  --mode it
```

#### IT Mode with Thinking Disabled  
```bash
python -m src.run \
  --model-path Qwen/Qwen3-8B \
  --batch-size 32 \
  --debug \
  -t False \
  --mode it
```

#### Pretrain Mode
```bash
python -m src.run \
  --model-path Qwen/Qwen3-8B \
  --batch-size 1 \
  --debug \
  -t None \
  --mode pt
```

### OpenAI API
```bash
python -m src.run \
  --model-path gpt-4o-mini \
  --mode it \
  -t False \
  --debug \
  --batch-size 10 \
  --openai <YOUR_OPENAI_API_KEY>
```

### vLLM API
```bash
python -m src.run \
  --model-path thaillm-8b \
  --mode it \
  -t True \
  --debug \
  --batch-size 10 \
  --vllm http://example-host/example-sub/
```

---

## Running on HPC Clusters (SLURM)

This framework includes helper scripts for deploying evaluations to a SLURM cluster using pre-configured CUDA environments.

### 1. Single Job Submission (`submit.sh`)
Submits a single evaluation job to the GPU partition. 

**Usage:**
```bash
sbatch submit.sh <CHECKPOINT_PATH> [extra_arguments...]
```

**Example:**
```bash
sbatch submit.sh Qwen/Qwen3-8B --data belebele --mode pt --batch-size 8 --project-name eval_run
```

### 2. Parallel Multi-Dataset Submission (`parallel.sh`)
Launches separate SLURM jobs concurrently for all 9 supported datasets in pretrain (`pt`) mode.

**Usage:**
```bash
./parallel.sh <MODEL_NAME_OR_PATH> <THINKING> <PROJECT_NAME> <BATCH_SIZE>
```

**Example:**
```bash
./parallel.sh Qwen/Qwen3-8B False my_eval_project 8
```
> [!NOTE]
> Currently, `parallel.sh` executes all datasets in pretrain (`pt`) mode. The `THINKING` argument ($2) is parsed but not passed down to the `submit.sh` commands inside the script.

---

## Available Arguments

### Required Arguments
- `--model-path`: Model name, Hugging Face Hub path, or local path to evaluate.

### Model Source Arguments (choose one)
- `--openai`: OpenAI API key for evaluating OpenAI models.
- `--vllm`: Base URL for the vLLM inference server.
  - `--api-key`: API key for the vLLM service (if authentication is required).
- *Neither*: Default option; will load the model as a local Hugging Face transformer.

### Evaluation Configuration
- `--mode`: Evaluation mode. Choose from `pt` (pretrain) or `it` (instruction-tuned). (default: `pt`)
- `-t, --thinking-mode`: Thinking mode configuration. Choose from `True`, `False`, `no_chat_template`, or `None`. (default: `None`)
- `--data`: Space-separated list of datasets to evaluate on.
  - Default: `["belebele", "xcopa", "mmlu_thai", "xnli", "m3exam", "thai_exam", "m6exam", "mmlu", "mmlu_proX_thai"]`
- `--num-shots`: Number of few-shot examples (default: `5`)
- `--batch-size`: Batch size for evaluation (default: `1`)
- `--max-seq-len`: Maximum sequence length for token generation (default: `8192`)
- `--seed`: Random seed for reproducibility (default: `47`)

### Output Configuration
- `--save-result-dir`: Directory where outputs will be saved (default: `./results`)
- `--save-time`: Append a timestamp to the results directory name. (default: `False`)
- `--project-name`: Specify a custom project name folder for saving results (overrides `--save-time` timestamp).
- `--debug`: Run in debug mode (limits evaluation to the **first 5 samples** of each dataset).

---

## Datasets

The framework supports evaluation on multiple Thai and multilingual benchmarks:

- **belebele**: Reading comprehension
- **xcopa**: Causal reasoning  
- **mmlu**: Massive Multitask Language Understanding
- **mmlu_thai**: Thai translation of MMLU
- **mmlu_proX_thai**: Thai translation of the MMLU-Pro dataset
- **xnli**: Cross-lingual natural language inference
- **m3exam**: Thai educational exams for Grade 9
- **thai_exam**: Thai standardized tests
- **m6exam**: Thai educational exams for Grade 12

## Output Structure

Results are saved in JSON format under the specified directory. 

If `--project-name` is used:
```
results/
└── {model_name}_{project_name}/
    └── summary/
        ├── belebele_report.json
        ├── xcopa_report.json
        └── ...
```

Otherwise (if `--save-time` is enabled):
```
results/
└── {model_name}_{timestamp}/
    └── summary/
        ├── belebele_report.json
        └── ...
```

---

## Notes & Limitations
- **Batch Size Limitations**: 
  - Pretrain mode (`pt`) only supports batch size 1 for local Hugging Face models.
  - API models (OpenAI, vLLM) support higher batch sizes for faster concurrent API calls.
- **Connection Diagnostics**: The framework automatically verifies connection health for vLLM servers before commencing evaluation.
