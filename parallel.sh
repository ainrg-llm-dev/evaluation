#!/bin/bash
if [ -z "$1" ]; then
  echo "Error: Checkpoint path argument missing"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: Thinking argument missing"
  exit 1
fi

# if [ -z "$2" ]; then
#   echo "Error: Thinking argument missing"
#   exit 1
# fi

# if [ -z "$3" ]; then
#   echo "Error: Project name argument missing"
#   exit 1
# fi

MODEL_NAME=$1
THINKING=$2
# PROJECT_NAME=$3

BATCH_SIZE=8
# sbatch submit.sh $MODEL_NAME --data belebele --mode it -t $2 --batch-size $BATCH_SIZE 
# sbatch submit.sh $MODEL_NAME --data xcopa --mode it -t $2 --batch-size $BATCH_SIZE 
sbatch submit.sh $MODEL_NAME --data xnli --mode it -t $2 --batch-size $BATCH_SIZE 
sbatch submit.sh $MODEL_NAME --data m3exam --mode it -t $2 --batch-size $BATCH_SIZE 
sbatch submit.sh $MODEL_NAME --data thai_exam --mode it -t $2 --batch-size $BATCH_SIZE 
sbatch submit.sh $MODEL_NAME --data m6exam --mode it -t $2 --batch-size $BATCH_SIZE 
sbatch submit.sh $MODEL_NAME --data mmlu --mode it -t $2 --batch-size $BATCH_SIZE 
sbatch submit.sh $MODEL_NAME --data mmlu_thai --mode it -t $2 --batch-size $BATCH_SIZE 