alias k=kubectl
#source ~/kubectl-completion.sh
source <(kubectl completion bash | sed s/kubectl/k/g)
