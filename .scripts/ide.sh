#!/bin/bash

SESSION="dev"

# Check if the session already exists
tmux has-session -t $SESSION 2>/dev/null

if [ $? != 0 ]; then
  # Create a new detached session
  tmux new-session -d -s $SESSION

  # Window 1: Development
  tmux rename-window -t $SESSION:0 'Editor'
  tmux send-keys -t $SESSION:0 'nvim' C-m # Starts Neovim

  # Window 2: Servers & Logs
  tmux new-window -t $SESSION:1
  tmux split-window -v -p 20 -t $SESSION:1
  tmux split-window -h -p 45 -t $SESSION:1
  tmux send-keys -t $SESSION:1.0 'clear' C-m
  tmux send-keys -t $SESSION:1.1 'clear' C-m
  tmux send-keys -t $SESSION:1.2 'clear' C-m

  # Select the first window before attaching
  tmux select-window -t $SESSION:0
fi

# Attach to the session
tmux attach-session -t $SESSION
