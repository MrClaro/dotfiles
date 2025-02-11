#!/usr/bin/env fish

# Start a new tmux session without a name
tmux new-session -d

# Split the current window vertically with 30% height
tmux split-window -v -l 30%

# Clear the newly created pane
tmux send-keys clear C-m

# Split the newly created pane horizontally by 50%
tmux split-window -h -l 50%

# Clear the new pane
tmux send-keys clear C-m

# Select the original pane and clear it as well
tmux select-pane -t 0
tmux send-keys clear C-m

# Attach to the new tmux session
tmux attach-session
