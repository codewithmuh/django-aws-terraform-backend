[
  {
    "name": "${name}",
    "image": "${image}",
    "essential": true,
    "links": [],
    "portMappings": [
      {
        "containerPort": 8000,
        "hostPort": 8000,
        "protocol": "tcp"
      }
    ],
    "command": ${jsonencode(command)},
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${log_stream}"
      }
    }
  }
]
