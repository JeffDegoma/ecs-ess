// natgateway will incur costs

resource "aws_nat_gateway" "nat" {
  allocation_id     =   "${aws_eip.nat.id}"
}


//eip
resource "aws_eip" "nat" {
  vpc               =  true

}
