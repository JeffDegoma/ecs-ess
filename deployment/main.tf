
data "template_file" "task_definition" {
  template                          =   "${file("${path.module}/ess_td.json")}"
}


resource "aws_ecs_task_definition" "ESS_image" {
    family                          =      "ESS_image"
    container_definitions           =      "${data.template_file.task_definition.rendered}"

    lifecycle {
        create_before_destroy       =       true            
    }
}

resource "aws_ecs_service" "ESS_service" {
    name = "ESS_service"
    cluster = "${var.cluster_name}"
    task_definition = "${aws_ecs_task_definition.ESS_image.arn}"
    desired_count = 1
    iam_role = "${var.service_role}"

    load_balancer {
    container_name   =  "ess_docker_image"
    target_group_arn = "${var.load_balancer_arn}"
    container_port = "80"
    }
}
