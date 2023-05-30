resource "aws_ecr_repository" "backend" {
    name = "${var.project_name}-bakcend"
    image_tag_mutability = "MUTABLE"
  
}