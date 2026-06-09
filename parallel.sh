#!/bin/bash
if [ -z "$1" ]; then
  echo "Error: Checkpoint path argument missing"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: Thinking argument missing"
  exit 1
fi


if [ -z "$3" ]; then
  echo "Error: Project name argument missing"
  exit 1
fi

if [ -z "$4" ]; then
  echo "Error: BATCH_SIZE argument missing"
  exit 1
fi

MODEL_NAME=$1
THINKING=$2
PROJECT_NAME=$3
BATCH_SIZE=$4


sbatch submit.sh $MODEL_NAME --data belebele --mode pt --batch-size $BATCH_SIZE --project-name $PROJECT_NAME 
sbatch submit.sh $MODEL_NAME --data xcopa --mode pt --batch-size $BATCH_SIZE --project-name $PROJECT_NAME 
sbatch submit.sh $MODEL_NAME --data xnli --mode pt --batch-size $BATCH_SIZE --project-name $PROJECT_NAME 
sbatch submit.sh $MODEL_NAME --data m3exam --mode pt --batch-size $BATCH_SIZE --project-name $PROJECT_NAME 
sbatch submit.sh $MODEL_NAME --data thai_exam --mode pt --batch-size $BATCH_SIZE --project-name $PROJECT_NAME 
sbatch submit.sh $MODEL_NAME --data m6exam --mode pt --batch-size $BATCH_SIZE --project-name $PROJECT_NAME 
sbatch submit.sh $MODEL_NAME --data mmlu --mode pt --batch-size $BATCH_SIZE --project-name $PROJECT_NAME 
sbatch submit.sh $MODEL_NAME --data mmlu_thai --mode pt --batch-size $BATCH_SIZE --project-name $PROJECT_NAME
sbatch submit.sh $MODEL_NAME --data mmlu_proX_thai --mode pt --batch-size $BATCH_SIZE --project-name $PROJECT_NAME