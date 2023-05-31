TASK_ID=$(aws ecs list-tasks --cluster prod --service-name prod-backend-web  --query 'taskArns[0]' --output text  | awk '{split($0,a,"/"); print a[3]}')
aws ecs execute-command --task arn:aws:ecs:us-east-2:373903915873:task/prod/dbb7ba041ead4f5fa5f476b03f3ac3a4 --command "bash" --interactive --cluster prod --region us-east-2

