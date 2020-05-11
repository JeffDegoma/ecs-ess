output "public_subnets" {
  value = "${aws_subnet.public.*.id}"
}

output "vpc" {
  value = "${aws_vpc.seton_dev.id}"
}
